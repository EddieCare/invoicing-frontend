import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/app/controllers/auth/auth_main_controller.dart';

import '../../routes/app_routes.dart';

class AuthMainScreen extends StatelessWidget {
  final AuthMainController controller = Get.put(AuthMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(height: 5),
              Container(child: infoSection(context)),
              SizedBox(height: 20),

              // Container(child: loginForm(context)),
              const SizedBox(height: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "By continuing you are agreeing to our Term's of Use & Privacy Policy",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container loginButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 20),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton.icon(
              onPressed: () => {Get.toNamed("login")},
              icon: Icon(Icons.email_outlined, color: Colors.white, size: 26),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(vertical: 4),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              label: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 10,
                ),
                child: Text(
                  "Login with email",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.signup),
            // child: Text("Don't have an account? Sign up"),
            child: Text(
              "Don't have an account? Sign up",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column infoSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        SizedBox(height: 160),
        Image.asset("assets/images/logo.png", width: 100, height: 100),
        SizedBox(height: 20),
        Text(
          "Atlas Invoice",
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
        loginButton(context),
      ],
    );
  }
}
