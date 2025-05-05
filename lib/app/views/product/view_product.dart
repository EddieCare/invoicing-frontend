import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/values/values.dart';
import '../../../components/dialogs.dart';
import '../../../components/top_bar.dart';
import '../../controllers/product/view_product_controller.dart';

class ViewProductScreen extends StatelessWidget {
  ViewProductScreen({super.key});

  final productController = Get.put(ProductsViewController());

  @override
  Widget build(BuildContext context) {
    // Replace with actual product from controller
    final product = productController.selectedProduct;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(showBackButton: true, showAddInvoice: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle
            Text(
              "Lipton Green Tea",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Lorem Ipsum",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "https://www.bbassets.com/media/uploads/p/xxl/1201452-6_1-lipton-green-tea-pure-light.jpg",
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,

                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Price & Quantity & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rs.${459}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Quantity ${1} Units',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.textColorSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Active",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Product Details
            const Text(
              'Product Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Suitability:Very suitable for health conscious and tea lovers!\nTaste:Very nice and acceptable\nQuality:Very good. I trust Lipton brand.",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Stock Keep Unit
            const Text(
              'Stock Keep Unit',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "JUIE3389YR",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorPrimary,
              ),
            ),

            const SizedBox(height: 24),

            // Supplier Details
            const Text(
              'Supplier Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Sudha",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            Text(
              "LA",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            Text(
              "+91 7008365792",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            Text(
              "sudha@story.com",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Delete Button
                ElevatedButton.icon(
                  onPressed:
                      () => {
                        // _showDeleteConfirmation(context),
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder:
                              (_) => ConfirmationDialog(
                                title: "Confirm Delete Product",
                                message:
                                    "Are you sure you want to delete this product?",
                                onYes: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                onNo: () => Navigator.pop(context),
                              ),
                        ),
                      },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Edit Button
                ElevatedButton.icon(
                  onPressed: () => {productController.editProduct()},
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  productController.deleteProduct();
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
