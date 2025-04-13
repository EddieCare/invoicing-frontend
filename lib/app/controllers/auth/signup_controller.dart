import 'package:get/get.dart';

class SignupController extends GetxController {
  // Define login logic here
  RxString email = ''.obs;
  RxString password = ''.obs;

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void login() {
    print('Email: ${email.value}');
    print('Password: ${password.value}');
  }
}
