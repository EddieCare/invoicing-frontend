import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/components/top_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../components/buttons.dart';
import '../../controllers/auth/email_verification_controller.dart';
import '../../routes/app_routes.dart';

class EmailOtpVerificationPage extends StatelessWidget {
  final EmailVerificationController controller = Get.put(
    EmailVerificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: "", showBackButton: true, showAddInvoice: false),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(child: Image.asset("assets/images/logo.png", height: 100)),
            const SizedBox(height: 30),
            const Text(
              "Email Verification",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                // "Enter the 6-digit OTP sent to your email",
                "A Link has been sent to your mail, click on the link to verify your email, then return to this page",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 50),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 40),
            //   child: PinCodeTextField(
            //     appContext: context,
            //     length: 6,
            //     autoFocus: true,
            //     animationType: AnimationType.fade,
            //     keyboardType: TextInputType.number,
            //     controller: controller.otpController,
            //     pinTheme: PinTheme(
            //       shape: PinCodeFieldShape.box,
            //       borderRadius: BorderRadius.circular(12),
            //       fieldHeight: 50,
            //       fieldWidth: 45,
            //       activeFillColor: Colors.white,
            //       selectedFillColor: Colors.white,
            //       inactiveFillColor: Colors.white,
            //       inactiveColor: Colors.grey,
            //       selectedColor: Colors.blue,
            //       activeColor: Colors.blue,
            //     ),
            //     onChanged: (value) {},
            //     onCompleted: (_) => controller.verifyOtp(),
            //   ),
            // ),
            // const SizedBox(height: 20),
            const Spacer(),
            Obx(
              () =>
                  controller.isVerifying.value
                      ? const CircularProgressIndicator()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PrimaryButton(
                          text: "Verify Email",
                          onPressed: () => controller.verifyOtp(),
                        ),
                      ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: controller.resendOtp,
              child: const Text(
                "Resend Email",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.toNamed(Routes.signup),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black, size: 16),
                  const SizedBox(width: 5),
                  const Text(
                    "Update Email",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
