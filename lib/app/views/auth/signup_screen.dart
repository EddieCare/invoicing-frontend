import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
