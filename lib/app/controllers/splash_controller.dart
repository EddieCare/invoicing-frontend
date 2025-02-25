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
    await Future.delayed(Duration(seconds: 5)); // 5-second delay

    final prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      Get.offNamed(
        Routes.onboarding,
      ); // Navigate to Onboarding if first-time user
    } else {
      Get.offNamed(Routes.login); // Otherwise, go to Login
    }
  }
}
