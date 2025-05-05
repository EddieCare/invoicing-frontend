import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/values/values.dart';
import '../../../components/dialogs.dart';
import '../../../components/top_bar.dart';
import '../../controllers/product/product_controller.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Add Product",
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
              _buildTextField("Name", productController.nameController),
              _buildTextField(
                "Stock Keep Unit",
                productController.skuController,
              ),
              _buildTextField("Brand", productController.brandController),
              _buildDropdown(
                "Category",
                productController.selectedCategory,
                productController.categoryOptions,
              ),
              _buildTextField(
                "Quantity",
                productController.quantityController,
                isNumber: true,
              ),
              _buildDropdown(
                "Status",
                productController.selectedStatus,
                productController.statusOptions,
              ),
              _buildTextField(
                "Unit Type",
                productController.unitTypeController,
              ),
              _buildTextField(
                "Price",
                productController.priceController,
                isNumber: true,
              ),
              _buildTextField(
                "Notes",
                productController.notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text(
                "Supplier Details*",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildTextField("Name", productController.supplierNameController),
              _buildTextField(
                "Address",
                productController.supplierAddressController,
              ),
              _buildTextField(
                "Contact",
                productController.supplierContactController,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      /// 🔽 Sticky Button Row here
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            _buildButton(
              "Discard",
              onTap: () {
                productController.resetForm();
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder:
                      (_) => ConfirmationDialog(
                        title: "Discard Changes",
                        message: "Are you sure you want to discard changes?",
                        onYes: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Add discard logic if needed
                        },
                        onNo: () => Navigator.pop(context),
                      ),
                );
              },
              isPrimary: false,
            ),
            const SizedBox(width: 12),
            _buildButton("Add", onTap: productController.submitForm),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black),
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
        validator:
            (value) =>
                value == null || value.trim().isEmpty
                    ? "$label is required"
                    : null,
      ),
    );
  }

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
