import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/top_bar.dart';
import '../../../../values/values.dart';
import '../../../controllers/profile/edit_profile/edit_profile_controller.dart';
import '../../../utils/utilities.dart';

// class EditProfileScreen extends GetView<EditProfileController> {
class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Edit Profile",
        // leadingIcon: Icon(Icons.arrow_back_ios, size: 30),
        showBackButton: true,
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                "Full name",
                controller.fullNameController,
                "Full name",
              ),
              buildTextField(
                "Business Name",
                controller.businessNameController,
                "Business Name",
              ),
              buildTextField(
                "Mail",
                controller.emailController,
                "example@mail.com",
              ),
              // buildPhoneField(),
              // const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => buildDropdownField(
                        "Country",
                        controller.selectedCountry.value,
                        [
                          'United States',
                          'United Kingdom',
                          'Canada',
                          'Australia',
                          'South Africa',
                        ],
                        (value) => controller.selectedCountry.value = value!,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              buildTextField(
                "Address",
                controller.addressController,
                "Address",
              ),
              const SizedBox(height: 24),
              buildSubmitButton(controller.handleSubmit, "Submit"),
            ],
          ),
        ),
      ),
    );
  }
}

// class EditProfileForm extends StatefulWidget {
//   const EditProfileForm({super.key});

//   @override
//   State<EditProfileForm> createState() => _EditProfileFormState();
// }

// class _EditProfileFormState extends State<EditProfileForm> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController businessNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   String selectedCountry = 'United States';
//   String selectedGender = 'Female';

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     businessNameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState!.validate()) {
//       // Submit form logic here
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Profile updated!')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildTextField("Full name", fullNameController, "Eddy K"),
//             buildTextField(
//               "Business Name",
//               businessNameController,
//               "Eddiecare",
//             ),
//             buildTextField("Mail", emailController, "youremail@domain.com"),
//             buildPhoneField(),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: buildDropdownField(
//                     "Country",
//                     selectedCountry,
//                     ['United States', 'India', 'Canada'],
//                     (value) {
//                       setState(() {
//                         selectedCountry = value!;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: buildDropdownField(
//                     "Genre",
//                     selectedGender,
//                     ['Male', 'Female', 'Other'],
//                     (value) {
//                       setState(() {
//                         selectedGender = value!;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             buildTextField(
//               "Address",
//               addressController,
//               "45 New Avenue, New York",
//             ),
//             const SizedBox(height: 24),
//             buildSubmitButton(_handleSubmit),
//           ],
//         ),
//       ),
//     );
//   }
// }
