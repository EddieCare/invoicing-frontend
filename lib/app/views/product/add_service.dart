import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/input_fld.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/product/product_controller.dart';

class AddServiceScreen extends StatelessWidget {
  // final bool isService;
  final isService = Get.arguments?['isService'] ?? false;
  AddServiceScreen({super.key});

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

              Obx(
                () => buildDropdownField(
                  "Type of Service",
                  productController.selectedCategory,
                  productController.categoryOptions.value,
                ),
              ),

              buildInputField(
                productController.notesController,
                "Description",
                maxLines: 4,
                isRequired: true,
              ),

              buildInputField(
                productController.priceController,
                "Fee Per Hour of Service",
                isRequired: true,
                isNumber: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.all(16),
      //   child: Form(
      //     key: productController.formKey,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         buildInputField(
      //           productController.nameController,
      //           "Name",
      //           isRequired: true,
      //         ),
      //         // TODO: Gallery or capture and upload
      //         buildInputField(productController.imageLink, "Add an image Link"),
      //         if (!isService)
      //           buildInputField(
      //             productController.skuController,
      //             "Stock Keep Unit",
      //           ),
      //         if (!isService)
      //           buildInputField(
      //             productController.brandController,
      //             "Brand",
      //             isRequired: true,
      //           ),
      //         Obx(
      //           () => buildDropdownField(
      //             "Category",
      //             productController.selectedCategory,
      //             productController.categoryOptions,
      //             isRequired: true,
      //           ),
      //         ),
      //         if (!isService)
      //           buildInputField(
      //             productController.quantityController,
      //             "Quantity",
      //             isRequired: true,
      //             // isNumber: true,
      //           ),
      //         buildDropdownField(
      //           "Status",
      //           productController.selectedStatus,
      //           productController.statusOptions,
      //           isRequired: true,
      //         ),
      //         if (!isService)
      //           buildInputField(
      //             productController.unitTypeController,
      //             "Unit Type",
      //           ),
      //         buildInputField(
      //           productController.priceController,
      //           !isService ? "Price" : "Price per hour",
      //           // isNumber: true,
      //         ),
      //         buildInputField(
      //           productController.notesController,
      //           "Notes",
      //           maxLines: 3,
      //         ),
      //         const SizedBox(height: 24),
      //         if (!isService)
      //           const Text(
      //             "Supplier Details*",
      //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //           ),
      //         if (!isService) const SizedBox(height: 20),
      //         if (!isService)
      //           buildInputField(
      //             productController.supplierNameController,
      //             "Name",
      //           ),
      //         if (!isService)
      //           buildInputField(
      //             productController.supplierAddressController,
      //             "Address",
      //           ),
      //         if (!isService)
      //           buildInputField(
      //             productController.supplierContactController,
      //             "Contact",
      //           ),
      //         const SizedBox(height: 24),
      //       ],
      //     ),
      //   ),
      // ),

      /// 🔽 Sticky Button Row here
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              productController.isLoading.value
                  ? SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: AppColor.textColorPrimary,
                      strokeWidth: 4,
                    ),
                  )
                  : _buildButton(
                    isService ? "Add Service" : "Add Product",
                    onTap: () {
                      if (!productController.isLoading.value) {
                        productController.submitForm(isService: isService);
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String label, {
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.grey.shade300,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
