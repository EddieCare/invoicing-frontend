import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class InvoiceListController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxString selectedStatus = 'All'.obs;
  RxList<Map<String, dynamic>> invoices = <Map<String, dynamic>>[].obs;

  String vendorId = '';
  String shopId = '';

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
    fetchInvoices();
  }

  void setFilter(String status) {
    selectedStatus.value = status;
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    Query query = _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices')
        .orderBy('created_at', descending: true);

    if (selectedStatus.value != 'All') {
      query = query.where('status', isEqualTo: selectedStatus.value);
    }

    final snapshot = await query.get();
    invoices.assignAll(
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>),
    );
  }
}
