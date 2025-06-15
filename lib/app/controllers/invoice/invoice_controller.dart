// import 'package:get/get.dart';

// class InvoiceController extends GetxController {
//   RxList invoices = [].obs;
//   RxBool hasDiscount = false.obs;
//   RxInt discountAmt = 0.obs;

//   void updateDiscount() {
//     hasDiscount.value = !hasDiscount.value;
//     discountAmt.value = !hasDiscount.value ? 0 : discountAmt.value;
//   }

//   void updateDiscountAmt(newValue) {
//     discountAmt.value = int.parse(newValue);
//   }

//   void completeOnboarding() {
//     // Logic to mark onboarding as complete
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class InvoiceController extends GetxController {
//   RxList<Map<String, dynamic>> selectedProducts = <Map<String, dynamic>>[].obs;
//   RxList<Map<String, dynamic>> selectedServices = <Map<String, dynamic>>[].obs;
//   RxMap<String, dynamic> clientDetails = <String, dynamic>{}.obs;
//   RxBool hasDiscount = false.obs;
//   RxInt discountAmt = 0.obs;
//   RxString invoiceNumber = ''.obs;
//   Rx<DateTime> issueDate = DateTime.now().obs;
//   Rx<DateTime> dueDate = DateTime.now().obs;

//   Future<void> fetchAndSetInvoiceNumber() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final shopSnap =
//         await FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(uid)
//             .collection('shops')
//             .limit(1)
//             .get();
//     if (shopSnap.docs.isEmpty) return;
//     final shopId = shopSnap.docs.first.id;

//     final invoices =
//         await FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(uid)
//             .collection('shops')
//             .doc(shopId)
//             .collection('invoices')
//             .orderBy('created_at', descending: true)
//             .limit(1)
//             .get();

//     String newInvoiceNumber;
//     if (invoices.docs.isNotEmpty) {
//       final lastNumber = invoices.docs.first.data()['invoice_number'];
//       newInvoiceNumber = _generateNextInvoiceNumber(lastNumber);
//     } else {
//       newInvoiceNumber = _generateNextInvoiceNumber(null);
//     }

//     invoiceNumber.value = newInvoiceNumber;
//   }

//   String _generateNextInvoiceNumber(String? lastInvoice) {
//     final today = DateTime.now();
//     final datePrefix =
//         "${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
//     final prefix = "INV-$datePrefix-";

//     if (lastInvoice != null && lastInvoice.startsWith(prefix)) {
//       final lastSeq = int.parse(lastInvoice.split("-").last);
//       return "$prefix${(lastSeq + 1).toString().padLeft(3, '0')}";
//     } else {
//       return "prefix001";
//     }
//   }

//   void updateDiscount() {
//     hasDiscount.value = !hasDiscount.value;
//     if (!hasDiscount.value) discountAmt.value = 0;
//   }

//   void updateDiscountAmt(String newValue) {
//     discountAmt.value = int.tryParse(newValue) ?? 0;
//   }

//   void setClient(Map<String, dynamic> client) {
//     clientDetails.value = client;
//   }

//   Future<void> saveInvoice() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final shopSnap =
//         await FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(uid)
//             .collection('shops')
//             .limit(1)
//             .get();
//     if (shopSnap.docs.isEmpty) return;
//     final shopId = shopSnap.docs.first.id;

//     double subtotal = 0.0;
//     List<Map<String, dynamic>> items = [];

//     for (var item in [...selectedProducts, ...selectedServices]) {
//       subtotal += item['price'] * (item['quantity'] ?? 1);
//       items.add(item);
//     }

//     double discount =
//         hasDiscount.value ? (subtotal * discountAmt.value / 100) : 0;
//     double tax = subtotal * 0.08;
//     double total = subtotal - discount + tax;

//     final invoiceData = {
//       "invoice_number": invoiceNumber.value,
//       "issue_date": Timestamp.fromDate(issueDate.value),
//       "due_date": Timestamp.fromDate(dueDate.value),
//       "products": selectedProducts,
//       "services": selectedServices,
//       "client": clientDetails,
//       "subtotal": subtotal,
//       "discount_percent": discountAmt.value,
//       "discount_amount": discount,
//       "tax": tax,
//       "total": total,
//       "created_at": FieldValue.serverTimestamp(),
//     };

//     await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(uid)
//         .collection('shops')
//         .doc(shopId)
//         .collection('invoices')
//         .add(invoiceData);

//     Get.snackbar("Success", "Invoice created successfully");
//     clearInvoice();
//   }

//   void addClient(String name, String email, String phone) async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     final shopSnap =
//         await FirebaseFirestore.instance
//             .collection('vendors')
//             .doc(uid)
//             .collection('shops')
//             .limit(1)
//             .get();
//     if (shopSnap.docs.isEmpty) return;
//     final shopId = shopSnap.docs.first.id;

//     final newClient = {
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "created_at": FieldValue.serverTimestamp(),
//     };

//     final clientRef = await FirebaseFirestore.instance
//         .collection('vendors')
//         .doc(uid)
//         .collection('shops')
//         .doc(shopId)
//         .collection('clients')
//         .add(newClient);

//     InvoiceController controller = Get.find();
//     controller.setClient({...newClient, "id": clientRef.id});
//   }

//   void clearInvoice() {
//     selectedProducts.clear();
//     selectedServices.clear();
//     clientDetails.clear();
//     hasDiscount.value = false;
//     discountAmt.value = 0;
//     fetchAndSetInvoiceNumber();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final shopSnapshot =
          await _db
              .collection('vendors')
              .doc(uid)
              .collection('shops')
              .limit(1)
              .get();

      if (shopSnapshot.docs.isEmpty) return;

      final shopId = shopSnapshot.docs.first.id;

      final productsSnapshot =
          await _db
              .collection('vendors')
              .doc(uid)
              .collection('shops')
              .doc(shopId)
              .collection('products')
              .get();

      final servicesSnapshot =
          await _db
              .collection('vendors')
              .doc(uid)
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
