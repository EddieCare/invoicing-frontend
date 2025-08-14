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

  RxBool btnLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch vendor profile details
  Future<void> fetchProfileData() async {
    btnLoading.value = true;
    final user = _auth.currentUser;
    if (user == null) return;
    btnLoading.value = false;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('vendors').doc(user.email).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        fullNameController.text = data['fullName'] ?? '';
        businessNameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        selectedCountry.value = data['country'] ?? 'United States';
      }
      btnLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  /// Update vendor profile details
  Future<void> handleSubmit() async {
    btnLoading.value = true;

    if (!formKey.currentState!.validate()) {
      btnLoading.value = false;
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      btnLoading.value = false;
      return;
    }

    try {
      await _firestore
          .collection('vendors')
          .doc(user.email)
          .update({
            'fullName': fullNameController.text.trim(),
            'businessName': businessNameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'address': addressController.text.trim(),
            'country': selectedCountry.value,
            'updatedAt': FieldValue.serverTimestamp(),
          })
          .then((d) async {
            btnLoading.value = false;
            fetchProfileData();
            Get.back();
            Get.snackbar('Success', 'Profile updated successfully!');
          });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      btnLoading.value = false;
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
