import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allServices = <Map<String, dynamic>>[].obs;

  RxString invoiceNumber = ''.obs;
  Rx<DateTime> issueDate = DateTime.now().obs;
  Rx<DateTime> dueDate = DateTime.now().obs;

  RxList<Map<String, dynamic>> selectedProducts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> selectedServices = <Map<String, dynamic>>[].obs;

  RxBool hasDiscount = false.obs;
  RxDouble discountAmt = 0.0.obs;

  Rxn<Map<String, dynamic>> selectedClient = Rxn<Map<String, dynamic>>();

  String vendorId = ''; // Set this from the calling screen or auth
  String shopId = ''; // Set this from the calling screen

  @override
  void onInit() {
    super.onInit();
    generateInvoiceNumber();
    fetchProductsAndServices();
  }

  Future<void> fetchProductsAndServices() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    try {
      final shopSnapshot =
          await _db
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .limit(1)
              .get();

      if (shopSnapshot.docs.isEmpty) return;

      final shopId = shopSnapshot.docs.first.id;

      final productsSnapshot =
          await _db
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .doc(shopId)
              .collection('products')
              .get();

      final servicesSnapshot =
          await _db
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .doc(shopId)
              .collection('services')
              .get();

      allProducts.assignAll(
        productsSnapshot.docs.map((doc) => doc.data()).toList(),
      );
      allServices.assignAll(
        servicesSnapshot.docs.map((doc) => doc.data()).toList(),
      );
    } catch (e) {
      print('Error fetching products/services: $e');
    }
  }

  void generateInvoiceNumber() {
    final now = DateTime.now();
    final formatted = DateFormat('yyyyMMdd').format(now);
    final rand = DateTime.now().millisecondsSinceEpoch % 1000;
    invoiceNumber.value = 'INV-$formatted-${rand.toString().padLeft(3, '0')}';
  }

  void updateDiscount() => hasDiscount.value = !hasDiscount.value;

  void updateDiscountAmt(String value) {
    discountAmt.value = double.tryParse(value) ?? 0.0;
  }

  void setIssueDate(DateTime date) => issueDate.value = date;
  void setDueDate(DateTime date) => dueDate.value = date;

  Future<void> addProduct(Map<String, dynamic> product) async {
    selectedProducts.add(product);
  }

  Future<void> addService(Map<String, dynamic> service) async {
    selectedServices.add(service);
  }

  Future<void> removeProduct(Map<String, dynamic> product) async {
    selectedProducts.remove(product);
  }

  Future<void> removeService(Map<String, dynamic> service) async {
    selectedServices.remove(service);
  }

  Future<void> setClientBySearch(String nameOrEmailOrPhone) async {
    final query =
        await _db
            .collection('vendors')
            .doc(vendorId)
            .collection('shops')
            .doc(shopId)
            .collection('clients')
            .where(
              Filter.or(
                Filter('name', isEqualTo: nameOrEmailOrPhone),
                Filter('email', isEqualTo: nameOrEmailOrPhone),
                Filter('phone', isEqualTo: nameOrEmailOrPhone),
              ),
            )
            .limit(1)
            .get();

    if (query.docs.isNotEmpty) {
      selectedClient.value = query.docs.first.data();
    }
  }

  Future<void> createInvoice() async {
    if (selectedClient.value == null) {
      Get.snackbar("Error", "Client not selected");
      return;
    }

    final invoiceData = {
      "invoice_number": invoiceNumber.value,
      "issue_date": issueDate.value,
      "due_date": dueDate.value,
      "products": selectedProducts,
      "services": selectedServices,
      "client": selectedClient.value,
      "discount": hasDiscount.value ? discountAmt.value : 0,
      "created_at": FieldValue.serverTimestamp(),
    };

    await _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices')
        .add(invoiceData);

    Get.snackbar("Success", "Invoice Created Successfully");
  }
}
