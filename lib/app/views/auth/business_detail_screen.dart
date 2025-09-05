// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../components/Buttons.dart';
// import '../../../values/values.dart';
// import '../../controllers/auth/signup_controller.dart';
// import '../../routes/app_routes.dart';
// import '../../../components/custom_text_field.dart';

// class BusinessDetailScreen extends StatelessWidget {
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
//                   label: "Business Name*",
//                   controller: TextEditingController(),
//                 ),
//                 CustomTextField(
//                   label: "Address*",
//                   controller: TextEditingController(),
//                 ),
//                 CustomTextField(
//                   label: "Phone Number*",
//                   controller: TextEditingController(),
//                 ),
//                 CustomTextField(
//                   label: "Business Number*",
//                   controller: TextEditingController(),
//                   isPassword: true,
//                 ),
//                 CustomTextField(
//                   label: "Industry",
//                   controller: TextEditingController(),
//                   isPassword: true,
//                 ),
//               ],
//             ),

//             // Spacer pushes the button section to the bottom
//             const Spacer(),

//             // Buttons at the Bottom
//             Column(
//               children: [
//                 PrimaryButton(text: "Signup"),

//                 TextButton(
//                   onPressed: () => Get.toNamed(Routes.signup),
//                   child: const Text(
//                     "Go back to Signup",
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
//         "Add Business Details",
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//       SizedBox(height: 20),
//       SizedBox(
//         width: MediaQuery.of(context).size.width * 0.4,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.end,
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
import 'package:invoicedaily/app/routes/app_routes.dart';
import '../../../components/Buttons.dart';
import '../../../values/values.dart';
import '../../controllers/auth/vendor_detail_controller.dart';
import '../../../components/input_fld.dart';

class BusinessDetailScreen extends StatelessWidget {
  final VendorDetailsController controller = Get.put(VendorDetailsController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              infoSection(context),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    buildInputField(
                      controller.fullNameController,
                      "Full Name",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.nameController,
                      "Business Name",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.emailController,
                      "Email",
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    buildInputField(
                      controller.phoneController,
                      "Phone Number",
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                    ),
                    buildInputField(
                      controller.streetController,
                      "Street Address",
                    ),
                    buildInputField(
                      controller.cityController,
                      "City",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.stateController,
                      "State",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.zipController,
                      "ZIP Code",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.countryController,
                      "Country",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.registrationController,
                      "Company Registration Number",
                    ),
                    buildInputField(
                      controller.categoryController,
                      "Business Category",
                      isRequired: true,
                    ),
                    buildInputField(
                      controller.businessTypeController,
                      "Business Type",
                      isRequired: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              AsyncButton(
                text: "Submit",
                onPressedAsync: () async {
                  if (formKey.currentState?.validate() == true) {
                    await controller.submitDetails();
                  }
                },
              ),
              TextButton(
                onPressed: () => {Get.toNamed(Routes.authMain)},
                child: const Text(
                  "Go back",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
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
        SizedBox(height: 30),
        Image.asset("assets/images/logo.png", width: 100, height: 100),
        SizedBox(height: 20),
        Text(
          "Add Business Details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Complete your profile to create professional invoices in seconds",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
