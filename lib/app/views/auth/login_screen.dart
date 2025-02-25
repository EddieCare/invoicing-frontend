import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/login_controller.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

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
            ElevatedButton(onPressed: () {}, child: Text("Login")),
            TextButton(
              onPressed: () => Get.toNamed(Routes.signup),
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
