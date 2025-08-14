import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  void signupWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Get.toNamed(Routes.emailOtpVerification);

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      print(
        "User signed up: ${userCredential.user!.email} : ${userCredential.user!.emailVerified}",
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        print("Sending verification email");
        // await userCredential.user!.sendEmailVerification();
        // Get.snackbar(
        //   "Verification Email Sent",
        //   "Please check your email to verify your account.",
        //   snackPosition: SnackPosition.TOP,
        // );
        Get.toNamed(Routes.emailOtpVerification); // Navigate to OTP screen
      }

      // if (userCredential.user != null) {
      //   // Success, navigate to business details screen
      //   Get.toNamed(Routes.businessDetails);
      // }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Signup failed";
      print("Here is the Error --> " + e.code);
      if (e.code == 'email-already-in-use') {
        errorMessage = "Email already in use";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      }

      Get.snackbar(
        "Signup Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
