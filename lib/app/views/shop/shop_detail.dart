import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/dialogs.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';

class ShopDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shopData;

  ShopDetailScreen({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(showBackButton: true, showAddInvoice: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shopData['shop_name'] ?? 'Shop Name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              shopData['shop_category'] ?? '',
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
                  'https://img.freepik.com/premium-vector/isolated-cartoon-vector-store-building-front-icon_1138841-28041.jpg',
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.9,

                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopData['shop_type'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shopData['shop_email'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.textColorSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  shopData['isActive'] == true ? "Active" : "Inactive",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Shop Address',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              shopData['shop_address']?['street'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            Text(
              "${shopData['shop_address']?['city'] ?? ''} ${shopData['shop_address']?['state'] ?? ''} ${shopData['shop_address']?['zip'] ?? ''}",
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            Text(
              shopData['shop_address']?['country'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Contact',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColor.textColorPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              shopData['shop_phone'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColor.textColorSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                ElevatedButton.icon(
                  // onPressed: () => controller.editProduct(item),
                  onPressed: () => {},
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
}
