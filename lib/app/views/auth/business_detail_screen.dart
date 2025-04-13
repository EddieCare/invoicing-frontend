import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/app/controllers/auth/signup_controller.dart';
import '../../../components/Buttons.dart';
import '../../routes/app_routes.dart';
import '../../../components/custom_text_field.dart';

class BusinessDetailScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Section + Input Fields at the Top
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                infoSection(context),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Business Name*",
                  controller: TextEditingController(),
                ),
                CustomTextField(
                  label: "Address*",
                  controller: TextEditingController(),
                ),
                CustomTextField(
                  label: "Phone Number*",
                  controller: TextEditingController(),
                ),
                CustomTextField(
                  label: "Business Number*",
                  controller: TextEditingController(),
                  isPassword: true,
                ),
                CustomTextField(
                  label: "Industry",
                  controller: TextEditingController(),
                  isPassword: true,
                ),
              ],
            ),

            // Spacer pushes the button section to the bottom
            const Spacer(),

            // Buttons at the Bottom
            Column(
              children: [
                PrimaryButton(text: "Signup"),

                TextButton(
                  onPressed: () => Get.toNamed(Routes.signup),
                  child: const Text(
                    "Go back to Signup",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Column infoSection(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,

    children: [
      SizedBox(height: 80),
      Image.asset("assets/images/logo.png", width: 100, height: 100),
      SizedBox(height: 20),
      Text(
        // "Atlas Invoice",
        "Add Business Details",
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
      // SizedBox(height: 100),
    ],
  );
}
