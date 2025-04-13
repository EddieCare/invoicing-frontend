import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/Buttons.dart';
import '../../controllers/auth/login_controller.dart';
import '../../routes/app_routes.dart';
import '../../../components/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  infoSection(context),
                  // Login Form
                  CustomTextField(
                    label: "Email*",
                    controller: TextEditingController(),
                  ),
                  CustomTextField(
                    label: "Password*",
                    controller: TextEditingController(),
                    isPassword: true,
                  ),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Login Button
              Column(
                children: [
                  PrimaryButton(),

                  // Sign Up Link
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.signup),
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column infoSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        SizedBox(height: 50),
        Image.asset("assets/images/logo.png", width: 100, height: 100),
        SizedBox(height: 20),
        Text(
          // "Atlas Invoice",
          "Login",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                textAlign: TextAlign.center,
                "Create proffessional invoices in seconds",
                style: TextStyle(fontSize: 18),
              ),
              Image.asset("assets/images/arc1.png", width: 100),
            ],
          ),
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
