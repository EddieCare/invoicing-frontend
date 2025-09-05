import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/buttons.dart';
import '../../../components/input_fld.dart';
import '../../../values/values.dart';
import '../../controllers/shop/shop_controller.dart';

void showCreateShopBottomSheet(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopImageUrl = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final controller = Get.find<ShopController>();
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColor.pageColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 15,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColor.textColorPrimary.withAlpha(80),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Create Shop",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                // Divider(thickness: 1),
                SizedBox(height: 50),
                buildInputField(nameController, "Shop Name", isRequired: true),
                buildInputField(shopImageUrl, "Shop Photo Link"),
                // _buildInput(gstController, "GST Number"),
                buildInputField(taxController, "Tax Number"),
                buildInputField(typeController, "Shop Type", isRequired: true),
                buildInputField(
                  categoryController,
                  "Shop Category",
                  isRequired: true,
                ),
                buildInputField(
                  emailController,
                  "Shop Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                buildInputField(
                  phoneController,
                  "Shop Phone",
                  keyboardType: TextInputType.phone,
                ),
                buildInputField(
                  addressController,
                  "Shop Address (Street, City, State, Zip, Country)",
                  maxLines: 2,
                ),
                SizedBox(height: 24),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Create Shop",
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        if (formKey.currentState?.validate() != true) return;
                        final data = {
                          "shop_name": nameController.text.trim(),
                          "shop_image_link": shopImageUrl.text.trim(),
                          // "gst_number": gstController.text.trim(),
                          "tax_number": taxController.text.trim(),
                          "shop_type": typeController.text.trim(),
                          "shop_category": categoryController.text.trim(),
                          "shop_email": emailController.text.trim(),
                          "shop_phone": phoneController.text.trim(),
                          "shop_address": {
                            "street": addressController.text.trim(),
                            "city": "",
                            "state": "",
                            "zip": "",
                            "country": "",
                          },
                        };
                        controller.createShop(data);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// Widget _buildInput(
//   TextEditingController controller,
//   String label, {
//   TextInputType keyboardType = TextInputType.text,
//   int maxLines = 1,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 16),
//     child: TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator:
//           (value) =>
//               value == null || value.trim().isEmpty
//                   ? 'This field is required'
//                   : null,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     ),
//   );
// }
