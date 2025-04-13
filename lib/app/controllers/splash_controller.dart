import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      Get.offNamed(
        // Routes.onboarding,
        // Routes.login,
        Routes.authMain,
      );
    } else {
      Get.offNamed(Routes.login);
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SplashScreenController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(Duration(seconds: 5), () {
//       Get.offNamed('/home'); // Replace with your actual route name
//     });
//   }
// }
