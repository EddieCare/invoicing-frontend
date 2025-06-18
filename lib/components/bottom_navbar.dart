import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/controllers/base/base_controller.dart';

class CustomBottomNav extends StatelessWidget {
  final BaseController controller = Get.find();

  CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.only(top: 12), // Top padding inside bar
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, "Home", 0),
              // _buildNavItem(Icons.wb_sunny_outlined, "Invoices", 1),
              _buildNavItem(Icons.money, "Invoices", 1),
              _buildNavItem(Icons.inventory_2_outlined, "Product", 2),
              _buildNavItem(Icons.settings_outlined, "Settings", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = controller.selectedIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey.shade500,
              size: 28,
              // size: icon == Icons.post_add ? 50 : 25,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
