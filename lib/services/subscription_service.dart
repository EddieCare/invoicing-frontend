import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoicedaily/models/subscription.dart';

/// Subscription and Limits helper
///
/// Firestore expected config shape (document: `config/subscriptionPlans`):
/// {
///   "free": {
///     "id": "FREE",
///     "name": "Free",
///     "monthly": 0,
///     "yearly": 0,
///     "features": ["5 products", "2 services", "5 invoices"],
///     "limits": {"products": 5, "services": 2, "invoices": 5}
///   },
///   "plus": {
///     "id": "PLUS",
///     "name": "Plus",
///     "monthly": 4.99,
///     "yearly": 49.99,
///     "features": ["10 products", "10 services", "15 invoices"],
///     "limits": {"products": 10, "services": 10, "invoices": 15}
///   },
///   "premium": {
///     "id": "PREMIUM",
///     "name": "Premium",
///     "monthly": 9.99,
///     "yearly": 99.99,
///     "features": ["150 products", "150 services", "Unlimited invoices"],
///     "limits": {"products": 150, "services": 150, "invoices": null}
///   }
/// }
class PlanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getPlansDoc() async {
    final doc =
        await _firestore.collection('config').doc('subscriptionPlans').get();
    if (!doc.exists) throw Exception('subscriptionPlans config missing');
    return doc.data() ?? {};
  }

  Future<SubscriptionInfo> getVendorSubscription(String vendorId) async {
    final vendorDoc =
        await _firestore.collection('vendors').doc(vendorId).get();
    if (!vendorDoc.exists) {
      // default FREE
      final limits = await _getLimitsForPlanKey('free');
      return SubscriptionInfo(
        planId: PlanId.free,
        planName: 'Free',
        period: 'MONTHLY',
        limits: limits,
      );
    }

    final data = vendorDoc.data()!;
    final sub = data['subscription'] as Map<String, dynamic>?;
    final planIdStr = (sub?['planId'] ?? sub?['plan'] ?? 'FREE').toString();
    final planKey = planIdStr.toLowerCase();
    final limits = await _getLimitsForPlanKey(planKey);

    final planId =
        {
          'free': PlanId.free,
          'plus': PlanId.plus,
          'premium': PlanId.premium,
        }[planKey] ??
        PlanId.free;

    Timestamp? expiryTs = sub?['repaymentDate'];
    return SubscriptionInfo(
      planId: planId,
      planName: (sub?['planName'] ?? planIdStr).toString(),
      period: (sub?['repaymentPeriod'] ?? 'MONTHLY').toString(),
      limits: limits,
      expiry: expiryTs?.toDate(),
    );
  }

  Future<PlanLimits> _getLimitsForPlanKey(String planKey) async {
    final plans = await _getPlansDoc();
    final raw = plans[planKey];
    if (raw is Map<String, dynamic>) {
      return PlanLimits.fromMap(raw['limits']);
    }
    // Safe defaults
    if (planKey == 'free')
      return const PlanLimits(invoices: 5, products: 5, services: 2);
    if (planKey == 'plus')
      return const PlanLimits(invoices: 15, products: 10, services: 10);
    if (planKey == 'premium')
      return const PlanLimits(invoices: null, products: 150, services: 150);
    return const PlanLimits(invoices: 5, products: 5, services: 2);
  }

  Future<bool> canCreateInvoiceForShop({
    required String vendorId,
    required String shopId,
  }) async {
    final sub = await getVendorSubscription(vendorId);
    final invLimit = sub.limits.invoices; // null => unlimited
    if (invLimit == null) return true;

    final ref = _firestore
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices');

    final countSnap = await ref.count().get();
    final current = countSnap.count;
    return current! < invLimit;
  }

  Future<bool> canAddProductForShop({
    required String vendorId,
    required String shopId,
  }) async {
    final sub = await getVendorSubscription(vendorId);
    final limit = sub.limits.products;
    if (limit == null) return true;
    final ref = _firestore
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('products');
    final countSnap = await ref.count().get();
    return countSnap.count! < limit;
  }

  Future<bool> canAddServiceForShop({
    required String vendorId,
    required String shopId,
  }) async {
    final sub = await getVendorSubscription(vendorId);
    final limit = sub.limits.services;
    if (limit == null) return true;
    final ref = _firestore
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('services');
    final countSnap = await ref.count().get();
    return countSnap.count! < limit;
  }

  /// Back-compat method for earlier invoice limit checks
  Future<Map<String, dynamic>> checkPlanLimit(
    String vendorId, {
    String? shopId,
  }) async {
    // If shopId is provided, use count-based check, otherwise just return subscription info
    final sub = await getVendorSubscription(vendorId);
    if (shopId == null) {
      return {
        'allowed': sub.limits.invoices == null || sub.limits.invoices! > 0,
        'remaining': sub.limits.invoices ?? double.infinity,
      };
    }

    if (await canCreateInvoiceForShop(vendorId: vendorId, shopId: shopId)) {
      final ref = _firestore
          .collection('vendors')
          .doc(vendorId)
          .collection('shops')
          .doc(shopId)
          .collection('invoices');
      final countSnap = await ref.count().get();
      final current = countSnap.count;
      final limit = sub.limits.invoices;
      final remaining =
          limit == null ? double.infinity : (limit - current!).clamp(0, limit);
      return {'allowed': true, 'remaining': remaining};
    }
    return {'allowed': false, 'remaining': 0};
  }
}
