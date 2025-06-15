// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../components/Buttons.dart';
// import '../../../values/values.dart';
// import '../../controllers/auth/signup_controller.dart';
// import '../../routes/app_routes.dart';
// import '../../../components/custom_text_field.dart';

// class SignupScreen extends StatelessWidget {
//   final SignupController controller = Get.put(SignupController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.pageColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Info Section + Input Fields at the Top
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 infoSection(context),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   label: "Email*",
//                   controller: TextEditingController(),
//                 ),
//                 CustomTextField(
//                   label: "Password*",
//                   controller: TextEditingController(),
//                   isPassword: true,
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),

//             // Spacer pushes the button section to the bottom
//             const Spacer(),

//             // Buttons at the Bottom
//             Column(
//               children: [
//                 PrimaryButton(
//                   text: "Continue",
//                   onPressed: () => Get.toNamed(Routes.businessDetails),
//                 ),
//                 TextButton(
//                   onPressed: () => Get.toNamed(Routes.login),
//                   child: const Text(
//                     "Already have an account? Login",
//                     style: TextStyle(color: Colors.black, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Column infoSection(BuildContext context) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,

//     children: [
//       SizedBox(height: 80),
//       Image.asset("assets/images/logo.png", width: 100, height: 100),
//       SizedBox(height: 20),
//       Text(
//         // "Atlas Invoice",
//         "Create Account",
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//       SizedBox(height: 20),
//       SizedBox(
//         width: MediaQuery.of(context).size.width * 0.4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               textAlign: TextAlign.center,
//               "Create proffessional invoices in seconds",
//               style: TextStyle(fontSize: 18),
//             ),
//             Image.asset("assets/images/arc1.png", width: 100),
//           ],
//         ),
//       ),
//       // SizedBox(height: 100),
//     ],
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/Buttons.dart';
import '../../../components/custom_text_field.dart';
import '../../../values/values.dart';
import '../../controllers/auth/signup_controller.dart';
import '../../routes/app_routes.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final textScale = mediaQuery.textScaleFactor;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24 * textScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: Text(
                          "Create professional invoices in seconds",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16 * textScale),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset("assets/images/arc1.png", width: 100),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: "Email*",
                        controller: controller.emailController,
                      ),
                      CustomTextField(
                        label: "Password*",
                        controller: controller.passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),

                      const Spacer(),

                      // Loading or Continue Button
                      controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : PrimaryButton(
                            text: "Continue",
                            onPressed: controller.signupWithEmail,
                          ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.login),
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14 * textScale,
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
