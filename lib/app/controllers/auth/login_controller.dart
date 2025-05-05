import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class LoginController extends GetxController {
//   // Define login logic here
//   RxString email = ''.obs;
//   RxString password = ''.obs;

//   void setEmail(String value) {
//     email.value = value;
//   }

//   void setPassword(String value) {
//     password.value = value;
//   }

//   void login() {
//     print('Email: ${email.value}');
//     print('Password: ${password.value}');
//   }
// }

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    print('here\'s Email: ${emailController.value}');
    // print('Password: ${passwordController.value}');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
