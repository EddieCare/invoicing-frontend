import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoicedaily/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password are required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      _handleFirstTimeLogin(user);
      Get.snackbar(
        'Success',
        'Logged in successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message ?? 'An error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleFirstTimeLogin(User? user) async {
    if (user == null) return;

    final doc = await _firestore.collection('vendors').doc(user.email).get();
    if (!doc.exists) {
      // Redirect to business details to complete setup
      Get.offAllNamed(Routes.businessDetails);
    } else {
      // Redirect to plan selection if needed
      final isActive = doc['isActive'] ?? false;
      if (!isActive) {
        Get.offAllNamed(Routes.plansScreen);
      } else {
        Get.offAllNamed(Routes.baseScreen);
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
