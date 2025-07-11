import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              buildInputField(nameController, "Shop Name"),
              buildInputField(shopImageUrl, "Shop Photo Link"),
              // _buildInput(gstController, "GST Number"),
              buildInputField(taxController, "Tax Number"),
              buildInputField(typeController, "Shop Type"),
              buildInputField(categoryController, "Shop Category"),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // final controller = Get.find<ShopController>();
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
                    if (!controller.isLoading.value)
                      controller.createShop(data);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.isLoading.value
                            ? AppColor.pageColor
                            : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      controller.isLoading.value
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.textColorPrimary,
                            ),
                          )
                          : Text(
                            "Create Shop",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 20),
            ],
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
