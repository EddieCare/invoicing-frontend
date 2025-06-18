// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class EditProfileController extends GetxController {
//   final formKey = GlobalKey<FormState>();

//   final fullNameController = TextEditingController();
//   final businessNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   var selectedCountry = 'United States'.obs;
//   var selectedGender = 'Female'.obs;

//   void handleSubmit() {
//     if (formKey.currentState!.validate()) {
//       // You can connect API here.

//       Get.snackbar(
//         'Success',
//         'Profile updated successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       Get.back();
//     }
//   }

//   @override
//   void onClose() {
//     fullNameController.dispose();
//     businessNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.onClose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  var selectedCountry = 'United States'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch vendor profile details
  Future<void> fetchProfileData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('vendors').doc(user.email).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        fullNameController.text = data['firstName'] ?? '';
        businessNameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        addressController.text = data['address']['state'] ?? '';
        selectedCountry.value = data['country'] ?? 'United States';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  /// Update vendor profile details
  Future<void> handleSubmit() async {
    if (!formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('vendors').doc(user.email).update({
        'firstName': fullNameController.text.trim(),
        'name': businessNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'country': selectedCountry.value,
        'updated_at': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    businessNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
