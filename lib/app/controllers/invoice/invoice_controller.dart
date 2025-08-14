import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'invoice_list_controller.dart';

class InvoiceController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> allProducts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> allServices = <Map<String, dynamic>>[].obs;

  RxString invoiceNumber = ''.obs;
  Rx<DateTime> issueDate = DateTime.now().obs;
  Rx<DateTime> dueDate = DateTime.now().obs;

  RxList<Map<String, dynamic>> selectedProducts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> selectedServices = <Map<String, dynamic>>[].obs;

  double TAX_RATE = 0.018; // 18% GST
  RxDouble subTotal = 0.0.obs;
  RxBool hasDiscount = false.obs;
  RxDouble discountRate = 0.0.obs;
  RxDouble discountAmt = 0.0.obs;
  RxDouble totalAmt = 0.0.obs;
  RxDouble tax = 0.0.obs;

  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  Rxn<Map<String, dynamic>> selectedClient = Rxn<Map<String, dynamic>>();

  String vendorId = ''; // Set this from the calling screen or auth
  String shopId = ''; // Set this from the calling screen

  @override
  void onInit() {
    super.onInit();
    generateInvoiceNumber();
    fetchProductsAndServices();
    updateTotals();
  }

  void updateTotals() {
    double subtotal = 0.0;

    for (final item in selectedProducts) {
      final qty = item['quantity'] ?? 1;
      final price = item['price'] ?? 0;
      subtotal += price * qty;
    }

    for (final item in selectedServices) {
      final qty = item['quantity'] ?? 1;
      final price = item['price'] ?? 0;
      subtotal += price * qty;
    }

    subTotal.value = subtotal;
    tax.value = subtotal * TAX_RATE;
    totalAmt.value =
        subtotal - (hasDiscount.value ? (discountAmt.value) : 0) + tax.value;
  }

  Future<void> fetchProductsAndServices() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    vendorId = email ?? '';
    try {
      final shopSnapshot =
          await _db
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .limit(1)
              .get();

      if (shopSnapshot.docs.isEmpty) return;

      shopId = shopSnapshot.docs.first.id;

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
        productsSnapshot.docs
            .map((doc) => {...doc.data(), "id": doc.id})
            .toList(),
      );
      allServices.assignAll(
        servicesSnapshot.docs
            .map((doc) => {...doc.data(), "id": doc.id})
            .toList(),
      );
    } catch (e) {
      print('Error fetching products/services: $e');
    }
  }

  void sortProductsByQuery(String query) {
    allProducts.sort((a, b) {
      final aName = a['name'].toLowerCase();
      final bName = b['name'].toLowerCase();

      // If query is empty, just sort alphabetically
      if (query.isEmpty) {
        return aName.compareTo(bName);
      }

      // Prioritize products that contain the query
      final aContains = aName.contains(query.toLowerCase());
      final bContains = bName.contains(query.toLowerCase());

      if (aContains && !bContains) return -1; // a first
      if (!aContains && bContains) return 1; // b first

      // If both contain or both don't contain, fallback to alphabetical
      return aName.compareTo(bName);
    });

    allProducts.refresh(); // Important for GetX
  }

  void sortServicesByQuery(String query) {
    allServices.sort((a, b) {
      final aName = a['name'].toLowerCase();
      final bName = b['name'].toLowerCase();

      // If query is empty, just sort alphabetically
      if (query.isEmpty) {
        return aName.compareTo(bName);
      }

      // Prioritize products that contain the query
      final aContains = aName.contains(query.toLowerCase());
      final bContains = bName.contains(query.toLowerCase());

      if (aContains && !bContains) return -1; // a first
      if (!aContains && bContains) return 1; // b first

      // If both contain or both don't contain, fallback to alphabetical
      return aName.compareTo(bName);
    });

    allServices.refresh(); // Important for GetX
  }

  void generateInvoiceNumber() {
    final now = DateTime.now();
    final formatted = DateFormat('yyyyMMdd').format(now);
    final rand = DateTime.now().millisecondsSinceEpoch % 1000;
    invoiceNumber.value = 'DINV-$formatted-${rand.toString().padLeft(3, '0')}';
  }

  void updateDiscount() => {
    updateDiscountRate(discountRate.value.toString()),
    hasDiscount.value = !hasDiscount.value,
    updateTotals(),
  };

  void updateDiscountRate(String value) {
    discountRate.value = double.tryParse(value) ?? 0.0;
    if (hasDiscount.value) {
      discountAmt.value = subTotal.value * (discountRate.value / 100);
    } else {
      discountAmt.value = 0.0;
    }
    updateTotals();
  }

  void setIssueDate(DateTime date) => issueDate.value = date;
  void setDueDate(DateTime date) => dueDate.value = date;

  Future<void> addProduct(Map<String, dynamic> product) async {
    final index = selectedProducts.indexWhere((p) => p['id'] == product['id']);

    print("Adding product: ${product['id']}");

    if (index >= 0) {
      final current = selectedProducts[index];
      final newQty = (product['quantity'] ?? 1);
      selectedProducts[index] = {...current, 'quantity': newQty};
    } else {
      selectedProducts.add({...product, 'quantity': product['quantity'] ?? 1});
    }

    updateTotals();
  }

  Future<void> addService(Map<String, dynamic> service) async {
    final index = selectedServices.indexWhere((s) => s['id'] == service['id']);

    if (index >= 0) {
      final current = selectedServices[index];
      final newQty = (service['quantity'] ?? 1);
      selectedServices[index] = {...current, 'quantity': newQty};
    } else {
      selectedServices.add({...service, 'quantity': service['quantity'] ?? 1});
    }

    updateTotals();
  }

  Future<void> removeProduct(Map<String, dynamic> product) async {
    print("Removing product: ${product['id']}");
    selectedProducts.removeWhere((p) => p['id'] == product['id']);
    updateTotals();
  }

  Future<void> removeService(Map<String, dynamic> service) async {
    selectedServices.removeWhere((s) => s['id'] == service['id']);
    updateTotals();
  }

  Future<void> setClientBySearch(String input) async {
    final email = FirebaseAuth.instance.currentUser?.email;
    searchResults.clear();
    final ref = _db
        .collection('vendors')
        .doc(email)
        .collection('shops')
        .doc(shopId)
        .collection('clients');

    final query =
        await ref
            .where(
              Filter.or(
                Filter('name', isEqualTo: input),
                Filter('email', isEqualTo: input),
                Filter('phone', isEqualTo: input),
              ),
            )
            .limit(5)
            .get();

    searchResults.assignAll(query.docs.map((doc) => doc.data()).toList());
  }

  Future<void> addNewClient(Map<String, dynamic> client) async {
    final ref = _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('clients');

    final existing =
        await ref
            .where(
              Filter.or(
                Filter('email', isEqualTo: client['email']),
                Filter('phone', isEqualTo: client['phone']),
              ),
            )
            .limit(1)
            .get();

    DocumentReference docRef;

    if (existing.docs.isNotEmpty) {
      // Update the existing client
      docRef = existing.docs.first.reference;
      await docRef.update(client);
    } else {
      // Add new client
      docRef = await ref.add(client);
    }

    final docSnapshot = await docRef.get();
    selectedClient.value = docSnapshot.data() as Map<String, dynamic>?;
    Get.back();
    Get.snackbar("Success", "Client added/updated successfully");
  }

  Future<void> createInvoice() async {
    if (selectedClient.value == null) {
      Get.snackbar("Error", "Client not selected");
      return;
    }

    double subtotal = 0.0;
    for (final product in selectedProducts) {
      final qty = product['quantity'] ?? 1;
      subtotal += (product['price'] ?? 0) * qty;
    }
    for (final service in selectedServices) {
      final qty = service['quantity'] ?? 1;
      subtotal += (service['price'] ?? 0) * qty;
    }

    double discount =
        hasDiscount.value ? subtotal * (discountRate.value / 100) : 0;
    tax.value = subtotal * TAX_RATE; // 18% GST
    totalAmt.value = (subtotal - discount) + tax.value;

    if (totalAmt.value < 0) {
      Get.snackbar("Error", "Total amount cannot be negative");
      return;
    }

    var servicesToBeAdded =
        selectedServices.map((s) {
          return {
            'id': s['id'],
            'name': s['name'],
            'quantity': s['quantity'] ?? 1,
            'price': s['price'] ?? 0.0,
            'total': (s['price'] ?? 0.0) * (s['quantity'] ?? 1),
          };
        }).toList();

    var productsToBeAdded =
        selectedProducts.map((p) {
          return {
            'id': p['id'],
            'name': p['name'],
            'quantity': p['quantity'] ?? 1,
            'price': p['price'] ?? 0.0,
            'total': (p['price'] ?? 0.0) * (p['quantity'] ?? 1),
          };
        }).toList();

    final invoiceData = {
      "invoice_number": invoiceNumber.value,
      "issue_date": issueDate.value,
      "due_date": dueDate.value,
      "products": productsToBeAdded,
      "services": servicesToBeAdded,
      "client": selectedClient.value,
      "subtotal": subtotal,
      "discount": discount,
      "tax": tax.value,
      "total": totalAmt.value,
      "status": "PENDING",
      "created_at": FieldValue.serverTimestamp(),
    };

    await _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .doc(shopId)
        .collection('invoices')
        .add(invoiceData);

    Get.back(); // Close the invoice creation screen
    Get.snackbar("Success", "Invoice Created Successfully");
    // Refresh the invoice list from invoice list controller
    Get.find<InvoiceListController>().fetchInvoices();
    // resetInvoiceData();
  }

  // void resetInvoiceData() {
  //   invoiceNumber.value = '';
  //   issueDate.value = DateTime.now();
  //   dueDate.value = DateTime.now();
  //   selectedProducts.clear();
  //   selectedServices.clear();
  //   subTotal.value = 0.0;
  //   hasDiscount.value = false;
  //   discountRate.value = 0.0;
  //   discountAmt.value = 0.0;
  //   totalAmt.value = 0.0;
  //   tax.value = 0.0;
  //   selectedClient.value = null;
  // }

  final RxList<Map<String, dynamic>> latestPendingOrUnpaid =
      <Map<String, dynamic>>[].obs;

  Future<void> fetchLatestPendingOrUnpaid() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;

    final shopSnapshot =
        await _db
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .limit(1)
            .get();

    if (shopSnapshot.docs.isEmpty) return;

    final shopId = shopSnapshot.docs.first.id;

    final query =
        await _db
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .doc(shopId)
            .collection('invoices')
            .where('status', whereIn: ['Pending', 'Unpaid'])
            .orderBy('issue_date', descending: true)
            .limit(5)
            .get();

    latestPendingOrUnpaid.assignAll(query.docs.map((doc) => doc.data()));
  }
}
