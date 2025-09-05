import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getShopRef(String vendorEmail) async {
    final shopSnapshot = await _db
        .collection('vendors')
        .doc(vendorEmail)
        .collection('shops')
        .limit(1)
        .get();

    if (shopSnapshot.docs.isEmpty) {
      return {};
    }
    final shopId = shopSnapshot.docs.first.id;
    return {
      'shopId': shopId,
      'ref': _db
          .collection('vendors')
          .doc(vendorEmail)
          .collection('shops')
          .doc(shopId)
    };
  }

  Future<Map<String, dynamic>> computePeriodAnalytics({
    required String vendorEmail,
    required DateTime from,
    required DateTime to,
  }) async {
    final shop = await _getShopRef(vendorEmail);
    if (shop.isEmpty) return {};

    final shopRef = shop['ref'] as DocumentReference;
    final invoicesRef = shopRef.collection('invoices');

    final query = await invoicesRef
        .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('issue_date', isLessThan: Timestamp.fromDate(to))
        .get();

    int totalInvoices = 0;
    int paidCount = 0;
    int pendingCount = 0;
    int unpaidCount = 0;
    double totalRevenue = 0.0;
    double paidRevenue = 0.0;
    double pendingAmount = 0.0;

    DateTime? lastInvoiceDate;

    for (final doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      totalInvoices += 1;
      final statusRaw = (data['status'] ?? '').toString();
      final status = statusRaw.toUpperCase();
      final total = (data['total'] ?? 0).toDouble();
      totalRevenue += total;

      if (status == 'PAID') {
        paidCount += 1;
        paidRevenue += total;
      } else if (status == 'PENDING' || status == 'UNPAID') {
        // normalize both as pending bucket
        pendingCount += 1;
        pendingAmount += total;
        if (status == 'UNPAID') unpaidCount += 1;
      }

      final issueTs = data['issue_date'];
      if (issueTs is Timestamp) {
        final d = issueTs.toDate();
        if (lastInvoiceDate == null || d.isAfter(lastInvoiceDate!)) {
          lastInvoiceDate = d;
        }
      }
    }

    final avgInvoiceValue = totalInvoices == 0
        ? 0.0
        : (totalRevenue / totalInvoices).toDouble();

    return {
      'totalInvoices': totalInvoices,
      'paidCount': paidCount,
      'pendingCount': pendingCount,
      'unpaidCount': unpaidCount,
      'totalRevenue': totalRevenue,
      'paidRevenue': paidRevenue,
      'pendingAmount': pendingAmount,
      'avgInvoiceValue': avgInvoiceValue,
      'lastInvoiceDate': lastInvoiceDate,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }

  Future<void> saveAnalyticsSummary({
    required String vendorEmail,
    required Map<String, dynamic> summary,
    required String granularity, // 'daily' | 'monthly'
    required String periodKey, // e.g. '2025-09-01' or '2025-09'
  }) async {
    final shop = await _getShopRef(vendorEmail);
    if (shop.isEmpty) return;
    final shopRef = shop['ref'] as DocumentReference;

    await shopRef
        .collection('analytics')
        .doc('${granularity}_$periodKey')
        .set({
      ...summary,
      'granularity': granularity,
      'periodKey': periodKey,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getSavedSummary({
    required String vendorEmail,
    required String granularity,
    required String periodKey,
  }) async {
    final shop = await _getShopRef(vendorEmail);
    if (shop.isEmpty) return null;
    final shopRef = shop['ref'] as DocumentReference;
    final doc = await shopRef
        .collection('analytics')
        .doc('${granularity}_$periodKey')
        .get();
    if (!doc.exists) return null;
    return doc.data() as Map<String, dynamic>?;
  }
}

