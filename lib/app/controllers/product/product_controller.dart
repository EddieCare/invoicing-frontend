import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxString selectedFilter = 'All'.obs;

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final imageLink = TextEditingController();
  final skuController = TextEditingController();
  final brandController = TextEditingController();
  final quantityController = TextEditingController();
  final unitTypeController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();
  final supplierNameController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierContactController = TextEditingController();

  final RxString selectedCategory = ''.obs;
  final RxString selectedStatus = ''.obs;
  final List<String> categoryOptions = ['Electronics', 'Grocery'];
  final List<String> statusOptions = ['Active', 'Inactive'];

  void resetForm() {
    nameController.clear();
    skuController.clear();
    brandController.clear();
    quantityController.clear();
    unitTypeController.clear();
    priceController.clear();
    notesController.clear();
    supplierNameController.clear();
    supplierAddressController.clear();
    supplierContactController.clear();
    selectedCategory.value = '';
    selectedStatus.value = '';
  }

  Future<void> submitForm({bool isService = false}) async {
    // if (!formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not authenticated.");
      return;
    }

    final email = user.email;

    final shopSnapshot =
        await _firestore
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .limit(1)
            .get();

    if (shopSnapshot.docs.isEmpty) {
      Get.snackbar("Error", "No shop found for this vendor.");
      return;
    }

    final shopId = shopSnapshot.docs.first.id;
    final collection = isService ? 'services' : 'products';

    print("Product =--=-=-=-=-=-=> $email, $shopId, $collection ");
    final itemData = {
      'name': nameController.text.trim(),
      'image_link': imageLink.text.trim(),
      'sku': skuController.text.trim(),
      'brand': brandController.text.trim(),
      'category': selectedCategory.value,
      'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
      'status': selectedStatus.value,
      'unit_type': unitTypeController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0.0,
      'notes': notesController.text.trim(),
      'supplier_name': supplierNameController.text.trim(),
      'supplier_address': supplierAddressController.text.trim(),
      'supplier_contact': supplierContactController.text.trim(),
      'created_at': FieldValue.serverTimestamp(),

      'shopId': shopId,
      'type': isService ? 'service' : 'product',
    };

    // Remove SKU and quantity if it's a service
    if (isService) {
      itemData.remove('sku');
      itemData.remove('quantity');
    }

    try {
      await _firestore
          .collection('vendors')
          .doc(email)
          .collection('shops')
          .doc(shopId)
          .collection(collection)
          .add(itemData);

      Get.snackbar(
        "Success",
        isService
            ? "Service added successfully!"
            : "Product added successfully!",
        snackPosition: SnackPosition.BOTTOM,
      );

      resetForm();
      Get.back();
      fetchItems(); // Refresh
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add item: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final email = user.email;

    final shopSnapshot =
        await _firestore
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .limit(1)
            .get();

    if (shopSnapshot.docs.isEmpty) return;

    final shopId = shopSnapshot.docs.first.id;
    items.clear();

    if (selectedFilter.value == 'Product' || selectedFilter.value == 'All') {
      final productSnap =
          await _firestore
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .doc(shopId)
              .collection('products')
              .get();

      items.addAll(productSnap.docs.map((e) => {"id": e.id, ...e.data()}));
    }

    if (selectedFilter.value == 'Service' || selectedFilter.value == 'All') {
      final serviceSnap =
          await _firestore
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .doc(shopId)
              .collection('services')
              .get();

      items.addAll(serviceSnap.docs.map((e) => {"id": e.id, ...e.data()}));
    }

    update(); // For GetBuilder
  }

  void deleteProduct(Map<String, dynamic> item) async {
    try {
      final email = FirebaseAuth.instance.currentUser!.email;
      final shopId = item["shopId"]; // Implement this based on your logic
      print(shopId + "------" + email + "------------------");
      await FirebaseFirestore.instance
          .collection("vendors")
          .doc(email)
          .collection("shops")
          .doc(shopId)
          .collection(item["type"] == "product" ? "products" : "services")
          .doc(item["id"])
          .delete();

      fetchItems();

      Get.snackbar(
        "Deleted",
        "Product has been deleted successfully.",
        backgroundColor: Colors.red.shade100,
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to delete product: $e");
    }
  }

  void editProduct(Map<String, dynamic> item) {
    Get.toNamed(
      Routes.addProductScreen,
      arguments: {"isEdit": true, "product": item},
    );
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    fetchItems();
  }

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }
}
