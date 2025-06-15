import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      prefs.setBool('isFirstTime', false);
      Get.offNamed(Routes.authMain);
      return;
    }

    final user = _auth.currentUser;

    if (user == null) {
      // User not signed in
      Get.offNamed(Routes.authMain);
      return;
    }

    final uid = user.uid;

    try {
      final vendorDoc = await _firestore.collection('vendors').doc(uid).get();

      if (!vendorDoc.exists) {
        // User is signed in but hasn't completed vendor details
        Get.offNamed(Routes.businessDetails);
        return;
      }

      final data = vendorDoc.data();
      final isSubscribed = data?['isSubscribed'] ?? false;

      if (isSubscribed) {
        Get.offNamed(Routes.baseScreen);
      } else {
        // You could redirect to a subscription plan screen here if needed
        Get.offNamed(Routes.baseScreen); // or Routes.subscriptionPlans
      }
    } catch (e) {
      print("Error fetching vendor data: $e");
      Get.offNamed(Routes.authMain); // fallback in case of error
    }
  }
}
