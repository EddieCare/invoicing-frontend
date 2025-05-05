import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final brandController = TextEditingController();
  final quantityController = TextEditingController();
  final unitTypeController = TextEditingController();
  final priceController = TextEditingController();
  final notesController = TextEditingController();
  final supplierNameController = TextEditingController();
  final supplierAddressController = TextEditingController();
  final supplierContactController = TextEditingController();

  // Dropdowns
  RxString selectedCategory = ''.obs;
  RxString selectedStatus = ''.obs;

  final categoryOptions = ["Electronics", "Clothing", "Furniture"];
  final statusOptions = ["Available", "Out of Stock", "Discontinued"];

  // Date
  Rxn<DateTime> dateOfPurchase = Rxn<DateTime>();

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // TODO: handle API call or local storage logic
      Get.snackbar("Success", "Product added successfully!");
      resetForm();
    }
  }

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
    dateOfPurchase.value = null;
  }

  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    brandController.dispose();
    quantityController.dispose();
    unitTypeController.dispose();
    priceController.dispose();
    notesController.dispose();
    supplierNameController.dispose();
    supplierAddressController.dispose();
    supplierContactController.dispose();
    super.onClose();
  }
}
