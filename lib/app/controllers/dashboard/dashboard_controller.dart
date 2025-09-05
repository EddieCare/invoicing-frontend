import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../invoice/invoice_controller.dart';
import '../../../services/subscription_service.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var shopData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;
  var hasAnalytics = false.obs;
  final analyticsSummary = <String, dynamic>{}.obs;

  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;

  final InvoiceController invoiceController = Get.put(InvoiceController());
  final PlanService _planService = PlanService();
  final remainingInvoices = 0.obs;
  final RxnInt maxInvoices = RxnInt();
  final RxnInt usedInvoices = RxnInt();
  final showGrowthCongrats = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShopDetails();
    invoiceController.fetchLatestPendingOrUnpaid();
    fetchDashboardAnalytics();
    computeRemainingInvoicesV2();
  }

  Future<void> fetchShopDetails() async {
    if (email == null) return;
    isLoading.value = true;

    final shopCollection =
        await _firestore
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .limit(1)
            .get();

    if (shopCollection.docs.isNotEmpty) {
      shopData.value = shopCollection.docs.first.data();
      print("Shop data: --------------> ${shopData.value}");
    } else {
      shopData.value = null;
    }
    isLoading.value = false;
  }

  Future<void> computeRemainingInvoices() async {
    if (email == null) return;
    final shopSnapshot = await _firestore
        .collection('vendors')
        .doc(email)
        .collection('shops')
        .limit(1)
        .get();
    if (shopSnapshot.docs.isEmpty) return;
    final shopId = shopSnapshot.docs.first.id;
    final res = await _planService.checkPlanLimit(email!, shopId: shopId);
    final rem = res['remaining'];
    if (rem is num) remainingInvoices.value = rem.toInt();
  }

  Future<void> createShop(Map<String, dynamic> shopDataInput) async {
    if (email == null) return;

    final shopRef = _firestore
        .collection('vendors')
        .doc(email)
        .collection('shops');

    final newShop = {
      ...shopDataInput,
      "isActive": true,
      "createdAt": DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
      "vendorId": uid,
    };

    await shopRef.add(newShop);
    await fetchShopDetails(); // Refresh after creation
    Get.snackbar("Success", "Shop created successfully");
  }

  Future<void> fetchDashboardAnalytics() async {
    if (email == null) return;
    try {
      final shopSnapshot = await _firestore
          .collection('vendors')
          .doc(email)
          .collection('shops')
          .limit(1)
          .get();
      if (shopSnapshot.docs.isEmpty) {
        hasAnalytics.value = false;
        return;
      }
      final shopId = shopSnapshot.docs.first.id;
      final invoicesRef = _firestore
          .collection('vendors')
          .doc(email)
          .collection('shops')
          .doc(shopId)
          .collection('invoices');

      // any invoices?
      final any = await invoicesRef.limit(1).get();
      if (any.docs.isEmpty) {
        hasAnalytics.value = false;
        analyticsSummary.clear();
        return;
      }

      // Try current month window first
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, 1);
      final to = DateTime(now.year, now.month + 1, 1);

      final snap = await invoicesRef
          .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where('issue_date', isLessThan: Timestamp.fromDate(to))
          .get();

      Map<String, dynamic> computed = _computeFromSnapshot(snap);
      // Fallback to last 90 days if current month is empty
      if ((computed['totalInvoices'] ?? 0) == 0) {
        final from90 = now.subtract(const Duration(days: 90));
        final snap90 = await invoicesRef
            .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(from90))
            .where('issue_date', isLessThan: Timestamp.fromDate(now.add(const Duration(days: 1))))
            .get();
        computed = _computeFromSnapshot(snap90);
      }

      // Compute month-over-month growth based on PAID revenue
      final prevFrom = DateTime(now.year, now.month - 1, 1);
      final prevTo = DateTime(now.year, now.month, 1);
      final prevSnap = await invoicesRef
          .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(prevFrom))
          .where('issue_date', isLessThan: Timestamp.fromDate(prevTo))
          .get();
      final prev = _computeFromSnapshot(prevSnap);
      final paidCurr = (computed['paidRevenue'] ?? 0.0) as double;
      final paidPrev = (prev['paidRevenue'] ?? 0.0) as double;
      double growthRate;
      if (paidPrev == 0 && paidCurr == 0) {
        growthRate = 0.0;
      } else if (paidPrev == 0) {
        growthRate = 100.0;
      } else {
        growthRate = ((paidCurr - paidPrev) / paidPrev) * 100.0;
      }
      computed['growthRate'] = growthRate;
      showGrowthCongrats.value = paidPrev > 0 && growthRate > 0;

      analyticsSummary.assignAll(computed);
      hasAnalytics.value = (computed['totalInvoices'] ?? 0) > 0;
    } catch (e) {
      hasAnalytics.value = false;
    }
  }

  Future<void> computeRemainingInvoicesV2() async {
    if (email == null) return;
    final shopSnapshot = await _firestore
        .collection('vendors')
        .doc(email)
        .collection('shops')
        .limit(1)
        .get();
    if (shopSnapshot.docs.isEmpty) return;
    final shopId = shopSnapshot.docs.first.id;

    final subscription = await _planService.getVendorSubscription(email!);
    final limit = subscription.limits.invoices; // null => unlimited

    if (limit == null) {
      maxInvoices.value = null;
      usedInvoices.value = null;
      remainingInvoices.value = 99999;
      return;
    }

    final ref = _firestore
        .collection('vendors')
        .doc(email)
        .collection('shops')
        .doc(shopId)
        .collection('invoices');

    // Count only current month invoices by issue_date
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime(now.year, now.month + 1, 1);
    final snap = await ref
        .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('issue_date', isLessThan: Timestamp.fromDate(to))
        .get();
    final used = snap.size;
    usedInvoices.value = used;
    maxInvoices.value = limit;
    remainingInvoices.value = (limit - used).clamp(0, limit);
  }

  Map<String, dynamic> _computeFromSnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
    int totalInvoices = 0;
    int paidCount = 0;
    int pendingCount = 0;
    double totalRevenue = 0.0;
    double paidRevenue = 0.0;
    double pendingAmount = 0.0;

    for (final d in snap.docs) {
      final data = d.data();
      totalInvoices += 1;
      final status = (data['status'] ?? '').toString().toUpperCase();
      final total = (data['total'] ?? 0).toDouble();
      totalRevenue += total;
      if (status == 'PAID') {
        paidCount += 1;
        paidRevenue += total;
      } else if (status == 'PENDING' || status == 'UNPAID') {
        pendingCount += 1;
        pendingAmount += total;
      }
    }

    return {
      'totalInvoices': totalInvoices,
      'paidCount': paidCount,
      'pendingCount': pendingCount,
      'totalRevenue': totalRevenue,
      'paidRevenue': paidRevenue,
      'pendingAmount': pendingAmount,
      'avgInvoiceValue': totalInvoices == 0 ? 0.0 : totalRevenue / totalInvoices,
    };
  }
}
