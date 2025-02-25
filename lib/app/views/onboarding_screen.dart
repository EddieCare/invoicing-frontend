import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome to the Invoicing App!", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.completeOnboarding(),
            child: Text("Get Started"),
          ),
        ],
      ),
    );
  }
}
