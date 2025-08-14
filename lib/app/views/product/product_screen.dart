import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/dialogs.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/product/product_controller.dart';
import '../../routes/app_routes.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Products & Services",
        showBackButton: false,
        showMenu: true,
        actions: const [SizedBox(width: 16)],
      ),
      body: Obx(() {
        final controller = Get.find<ProductController>();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // urgentNotificationsCard(),
              const SizedBox(height: 20),
              _filterBar(controller),
              const SizedBox(height: 20),
              ..._productCards(context, controller.items),
            ],
          ),
        );
      }),
    );
  }

  Widget _filterBar(ProductController controller) {
    final options = ['All', 'Product', 'Service'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children:
              options.map((label) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => controller.updateFilter(label),
                    child: _filterButton(
                      label,
                      isSelected: controller.selectedFilter.value == label,
                    ),
                  ),
                );
              }).toList(),
        ),
        // GestureDetector(
        //   onTap: () => Get.toNamed(Routes.addProductScreen),
        //   child: _filterButton("Add", icon: Icons.add),
        // ),
        PopupMenuButton<String>(
          color: AppColor.themeColor,
          onSelected: (value) {
            final isService = value == 'Service';
            controller.fetchCategories(isService);
            Get.toNamed(
              isService ? Routes.addServiceScreen : Routes.addProductScreen,
              arguments: {'isService': isService},
            );
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'Product',
                  child: Text('Add Product'),
                ),
                const PopupMenuItem(
                  value: 'Service',
                  child: Text('Add Service'),
                ),
              ],
          child: _filterButton("Add", icon: Icons.add),
        ),
      ],
    );
  }

  Widget _filterButton(
    String label, {
    IconData? icon,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _productCards(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return items.map((item) {
      final stock = item["quantity"] ?? 0;
      final isLow = stock < 10;
      final isMedium = stock < 100;
      final stockColor =
          isLow
              ? Colors.red
              : isMedium
              ? Colors.orange
              : Colors.green;

      return GestureDetector(
        onTap: () => Get.toNamed(Routes.viewProductScreen, arguments: item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenSize.width * 0.25,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      item["image_link"] != null &&
                              item["image_link"].isNotEmpty
                          ? Image.network(
                            item["image_link"],
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                          )
                          : Image.asset(
                            item["type"] == 'product'
                                ? "assets/icons/producticon.png"
                                : "assets/icons/serviceicon.png",
                            width: 70,
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"] ?? "No Name",
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "PRICE: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "₹ ${item["price"]?.toStringAsFixed(2) ?? "--"}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: stockColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "In Stock: $stock",
                            style: TextStyle(
                              color: stockColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:
                          () => {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder:
                                  (_) => ConfirmationDialog(
                                    title: "Confirm Delete Product",
                                    message:
                                        "Are you sure you want to delete this product?",
                                    onYes: () async {
                                      productController.deleteProduct(item);
                                      Navigator.pop(context);
                                    },
                                    onNo: () => Navigator.pop(context),
                                  ),
                            ),
                          },
                      child: Container(
                        margin: EdgeInsets.all(3),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: const [
                        Text(
                          "View Details",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                          size: 13,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
