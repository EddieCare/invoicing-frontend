import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../components/urgent_notification_card.dart';
import '../../../values/values.dart';
import '../../routes/app_routes.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Product",
        showBackButton: false,
        showMenu: true,
        actions: [
          // Icon(Icons.search_outlined, size: 28),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            urgentNotificationsCard(),
            const SizedBox(height: 20),
            _filterBar(),
            const SizedBox(height: 20),
            ..._productCards(context),
          ],
        ),
      ),
    );
  }

  Widget _filterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _filterButton("All", isSelected: true),
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(Routes.addProductScreen),
              child: _filterButton("Add"),
            ),
            const SizedBox(width: 5),
            _filterButton("Sort By"),
          ],
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
          if (label == 'Add') ...[
            SvgPicture.asset(
              'assets/icons/box-add.svg',
              height: 18,
              width: 18,
              color: isSelected ? Colors.white : Colors.black,
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

  List<Widget> _productCards(context) {
    final List<Map<String, dynamic>> items = [
      {"stock": 5, "price": 4.99},
      {"stock": 15, "price": 4.99},
      {"stock": 150, "price": 4.99},
      {"stock": 150, "price": 4.99},
    ];

    final screenSize = MediaQuery.of(context).size;

    return items.map((item) {
      final stock = item["stock"];
      final isLow = stock < 10;
      final isMedium = stock < 100;
      final stockColor =
          isLow
              ? Colors.red
              : isMedium
              ? Colors.orange
              : Colors.green;

      return GestureDetector(
        onTap: () => Get.toNamed(Routes.viewProductScreen),
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
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            // Make Row take full height of its tallest child
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenSize.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: Text(
                          "Wireless Mouse \nLogiTech".substring(1, 22),
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            "\$ ${item["price"].toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 14),
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
                    Icon(Icons.delete_outline, color: Colors.red, size: 24),
                    const Spacer(), // pushes view details to bottom
                    Row(
                      children: [
                        Text(
                          "View Details",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        const SizedBox(width: 6),
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
