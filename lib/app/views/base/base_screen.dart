import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/app/views/invoices/invoice_screen.dart';
import 'package:invoicing_fe/app/views/product/product_screen.dart';
import 'package:invoicing_fe/app/views/profile/profile_screen.dart';
import '../../../components/bottom_navbar.dart';
import '../../../components/sidebar_menu.dart';
import '../../controllers/base/base_controller.dart';
import '../dashboard/dashboard_screen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});

  final BaseController controller = Get.put(BaseController());

  final List<Widget> pages = [
    DashboardScreen(),
    InvoiceScreen(),
    ProductScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // return Obx(
    //   () => Scaffold(
    //     backgroundColor: Colors.white,
    //     body: pages[controller.selectedIndex.value],
    //     bottomNavigationBar: CustomBottomNav(),
    //   ),
    // );
    return Obx(() {
      final currentIndex = controller.selectedIndex.value;
      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomNav(),
        body: Stack(
          children: [
            pages[currentIndex], // Current selected screen
            SidebarMenu(), // Overlay sidebar menu
          ],
        ),
      );
    });
  }
}
