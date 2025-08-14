import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class EmailVerificationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final otpController = TextEditingController();
  var isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();
    resendOtp();
  }

  void verifyOtp() async {
    isVerifying.value = true;

    await _auth.currentUser?.reload(); // Refresh user state
    User? user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      Get.snackbar("Success", "Email verified successfully");
      Get.offAllNamed(Routes.businessDetails);
    } else {
      Get.snackbar(
        "Error",
        "Email not verified yet. Please click the link sent to your email.",
      );
    }

    isVerifying.value = false;
  }

  void resendOtp() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      Get.snackbar("Sent", "Verification email resent.");
    } catch (e) {
      Get.snackbar("Error", "Failed to resend email: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
