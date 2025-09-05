import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class InvoiceListController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxString selectedStatus = 'All'.obs;
  // Filtered list for UI
  RxList<Map<String, dynamic>> invoices = <Map<String, dynamic>>[].obs;
  // Keep original list to filter locally
  final List<Map<String, dynamic>> _allInvoices = <Map<String, dynamic>>[];

  String vendorId = '';
  String shopId = '';
  // Plan usage (monthly invoices)
  RxnInt monthlyLimit = RxnInt();
  RxInt monthlyUsed = 0.obs;
  RxInt monthlyRemaining = 0.obs;
  RxString planName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initShopAndFetch();
  }

  Future<void> initShopAndFetch() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;

    vendorId = email;

    final shopSnapshot =
        await _db
            .collection('vendors')
            .doc(vendorId)
            .collection('shops')
            .limit(1)
            .get();

    if (shopSnapshot.docs.isEmpty) return;

    shopId = shopSnapshot.docs.first.id;
    await fetchPlanUsage();
    await fetchInvoices();
  }

  void setFilter(String status) {
    selectedStatus.value = status;
    _applyFilter();
  }

  Future<void> fetchInvoices() async {
    Query query = _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices')
        .orderBy('created_at', descending: true);

    final snapshot = await query.get();
    _allInvoices
      ..clear()
      ..addAll(
        snapshot.docs
            .map((doc) => ({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList(),
      );
    _applyFilter();
  }

  Future<void> updateInvoiceStatus(String invoiceId, String newStatus) async {
    try {
      await _db
          .collection('vendors')
          .doc(vendorId)
          .collection('shops')
          .doc(shopId)
          .collection('invoices')
          .doc(invoiceId)
          .update({'status': newStatus});

      await fetchInvoices(); // Refresh list
      Get.snackbar("Success", "Invoice marked as $newStatus");
    } catch (e) {
      Get.snackbar("Error", "Failed to update invoice: $e");
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    try {
      await _db
          .collection('vendors')
          .doc(vendorId)
          .collection('shops')
          .doc(shopId)
          .collection('invoices')
          .doc(invoiceId)
          .delete();

      fetchInvoices(); // Refresh list
      Get.snackbar("Success", "Invoice deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete invoice: $e");
    }
  }

  @override
  void onClose() {
    super.onClose();
    invoices.clear();
    _allInvoices.clear();
  }

  Future<void> fetchPlanUsage() async {
    // count invoices in current month to compute remaining
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime(now.year, now.month + 1, 1);

    final snapshot = await _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices')
        .where('issue_date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('issue_date', isLessThan: Timestamp.fromDate(to))
        .get();

    monthlyUsed.value = snapshot.size;

    // Get plan limits
    try {
      final config = await _db.collection('vendors').doc(vendorId).get();
      final sub = config.data()?['subscription'] as Map<String, dynamic>?;
      planName.value = (sub?['planName'] ?? sub?['planId'] ?? 'Free').toString();

      // Pull limits from config/subscriptionPlans
      final plansDoc =
          await _db.collection('config').doc('subscriptionPlans').get();
      final planKey = (planName.value).toLowerCase();
      final limits = (plansDoc.data()?[planKey]?['limits']
              as Map<String, dynamic>?) ??
          {};
      final invLimit = limits['invoices'];
      if (invLimit is int) {
        monthlyLimit.value = invLimit;
        monthlyRemaining.value = (invLimit - monthlyUsed.value).clamp(0, invLimit);
      } else {
        monthlyLimit.value = null; // unlimited
        monthlyRemaining.value = 99999;
      }
    } catch (_) {
      monthlyLimit.value = null;
      monthlyRemaining.value = 99999;
      planName.value = 'Free';
    }
  }

  void _applyFilter() {
    final s = selectedStatus.value.toUpperCase();
    if (s == 'ALL') {
      invoices.assignAll(_allInvoices);
      return;
    }
    invoices.assignAll(
      _allInvoices.where((inv) => (inv['status'] ?? '').toString().toUpperCase() == s).toList(),
    );
  }
}
