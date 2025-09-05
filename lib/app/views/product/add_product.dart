import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs.dart';
import '../../../components/input_fld.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/product/product_controller.dart';

class AddProductScreen extends StatelessWidget {
  // final bool isService;
  final isService = Get.arguments?['isService'] ?? false;
  AddProductScreen({super.key});

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: isService ? "Add Service" : "Add Product",
        showBackButton: true,
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: productController.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField(
                productController.nameController,
                "Name",
                isRequired: true,
              ),
              // TODO: Gallery or capture and upload
              buildInputField(productController.imageLink, "Add an image Link"),
              if (!isService)
                buildInputField(
                  productController.skuController,
                  "Stock Keep Unit",
                ),
              if (!isService)
                buildInputField(
                  productController.brandController,
                  "Brand",
                  isRequired: true,
                ),
              Obx(
                () => buildDropdownField(
                  "Category",
                  productController.selectedCategory,
                  productController.categoryOptions.value,
                  isRequired: true,
                ),
              ),
              if (!isService)
                buildInputField(
                  productController.quantityController,
                  "Quantity",
                  isRequired: true,
                  // isNumber: true,
                ),
              buildDropdownField(
                "Status",
                productController.selectedStatus,
                productController.statusOptions,
                isRequired: true,
              ),
              if (!isService)
                buildInputField(
                  productController.unitTypeController,
                  "Unit Type",
                ),
              buildInputField(
                productController.priceController,
                !isService ? "Price" : "Price per hour",
                // isNumber: true,
              ),
              buildInputField(
                productController.notesController,
                "Notes",
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (!isService)
                const Text(
                  "Supplier Details*",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              if (!isService) const SizedBox(height: 20),
              if (!isService)
                buildInputField(
                  productController.supplierNameController,
                  "Name",
                ),
              if (!isService)
                buildInputField(
                  productController.supplierAddressController,
                  "Address",
                ),
              if (!isService)
                buildInputField(
                  productController.supplierContactController,
                  "Contact",
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      /// 🔽 Sticky Button Row here
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: isService ? "Add Service" : "Add Product",
                  isLoading: productController.isLoading.value,
                  onPressed: () {
                    final form = productController.formKey.currentState;
                    if (form?.validate() == true) {
                      productController.submitForm(isService: isService);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTextField(
  //   String label,
  //   TextEditingController controller, {
  //   bool isNumber = false,
  //   int maxLines = 1,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 20),
  //     child: TextFormField(
  //       controller: controller,
  //       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
  //       maxLines: maxLines,
  //       cursorColor: Colors.black,
  //       style: const TextStyle(color: Colors.black),
  //       decoration: InputDecoration(
  //         labelText: "$label *",
  //         labelStyle: const TextStyle(color: Colors.black),
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 20,
  //           vertical: 18,
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(14),
  //           borderSide: const BorderSide(color: Colors.grey),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(14),
  //           borderSide: const BorderSide(color: Colors.black, width: 1.5),
  //         ),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  //       ),
  //       validator:
  //           (value) =>
  //               value == null || value.trim().isEmpty
  //                   ? "$label is required"
  //                   : null,
  //     ),
  //   );
  // }

  Widget _buildDropdown(
    String label,
    RxString selectedValue,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) selectedValue.value = value;
          },
          decoration: InputDecoration(
            labelText: "$label *",
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          iconEnabledColor: Colors.black,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  // Removed local button in favor of PrimaryButton
}
