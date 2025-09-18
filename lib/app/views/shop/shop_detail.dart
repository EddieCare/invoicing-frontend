import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/shop/shop_controller.dart';
import 'shop_create.dart';

class ShopDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shopData;

  ShopDetailScreen({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopController>();
    final initialData = Map<String, dynamic>.from(shopData);
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(showBackButton: true, showAddInvoice: false),
      body: Obx(() {
        final latest = controller.shopData.value;
        final current =
            latest != null ? {...initialData, ...latest} : initialData;
        final logoUrl =
            (current['shopLogo'] ?? current['shop_image_link'] ?? '')
                .toString();

        final address = current['shop_address'];
        String street = '';
        String cityLine = '';
        String country = '';
        if (address is Map) {
          street = address['street']?.toString() ?? '';
          final city = address['city']?.toString() ?? '';
          final state = address['state']?.toString() ?? '';
          final zip = address['zip']?.toString() ?? '';
          cityLine =
              [
                city,
                state,
                zip,
              ].where((element) => element.isNotEmpty).join(' ').trim();
          country = address['country']?.toString() ?? '';
        } else if (address is String) {
          street = address;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current['shop_name'] ?? 'Shop Name',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColorPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                current['shop_category'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.textColorSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:
                      logoUrl.isNotEmpty
                          ? Image.network(
                            logoUrl,
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.9,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width * 0.9,
                            color: Colors.black12,
                            child: const Icon(
                              Icons.store_mall_directory,
                              size: 80,
                              color: Colors.black45,
                            ),
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
                        current['shop_type'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        current['shop_email'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.textColorSecondary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    current['isActive'] == true ? 'Active' : 'Inactive',
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
                street,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.textColorSecondary,
                ),
              ),
              Text(
                cityLine,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.textColorSecondary,
                ),
              ),
              Text(
                country,
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
                current['shop_phone'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.textColorSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => showEditShopBottomSheet(context, current),
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
        );
      }),
    );
  }
}
