// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../components/Buttons.dart';
// import '../../../values/values.dart';
// import '../../controllers/auth/login_controller.dart';
// import '../../routes/app_routes.dart';
// import '../../../components/custom_text_field.dart';

// class LoginScreen extends StatelessWidget {
//   final LoginController controller = Get.put(LoginController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.pageColor,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   infoSection(context),
//                   // Login Form
//                   CustomTextField(
//                     label: "Email*",
//                     controller: TextEditingController(),
//                   ),
//                   CustomTextField(
//                     label: "Password*",
//                     controller: TextEditingController(),
//                     isPassword: true,
//                   ),
//                   // Forgot Password
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: const Text("Forgot Password?"),
//                     ),
//                   ),
//                 ],
//               ),

//               const Spacer(),

//               // Login Button
//               Column(
//                 children: [
//                   PrimaryButton(
//                     onPressed: () => Get.toNamed(Routes.baseScreen),
//                     text: "Login",
//                   ),

//                   // Sign Up Link
//                   TextButton(
//                     onPressed: () => Get.toNamed(Routes.signup),
//                     child: const Text(
//                       "Don't have an account? Sign up",
//                       style: TextStyle(color: Colors.black, fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Column infoSection(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,

//       children: [
//         SizedBox(height: 50),
//         Image.asset("assets/images/logo.png", width: 100, height: 100),
//         SizedBox(height: 20),
//         Text(
//           // "Atlas Invoice",
//           "Login",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 20),
//         SizedBox(
//           width: MediaQuery.of(context).size.width * 0.4,
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 textAlign: TextAlign.center,
//                 "Create proffessional invoices in seconds",
//                 style: TextStyle(fontSize: 18),
//               ),
//               Image.asset("assets/images/arc1.png", width: 100),
//             ],
//           ),
//         ),
//         SizedBox(height: 100),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/Buttons.dart';
import '../../../components/custom_text_field.dart';
import '../../../values/values.dart';
import '../../controllers/auth/login_controller.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title
                Image.asset("assets/images/logo.png", width: 100, height: 100),
                const SizedBox(height: 20),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 26 * textScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Create professional invoices in seconds",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16 * textScale),
                ),
                const SizedBox(height: 10),
                Image.asset("assets/images/arc1.png", width: 100),
                const SizedBox(height: 40),

                // Email & Password Fields
                CustomTextField(
                  label: "Email*",
                  controller: controller.emailController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Password*",
                  controller: controller.passwordController,
                  isPassword: true,
                ),

                const SizedBox(height: 30),

                // Login Button
                PrimaryButton(
                  onPressed: () => {controller.login()},
                  text: "Login",
                ),

                // Sign Up Link
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.signup),
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      fontSize: 14 * textScale,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
