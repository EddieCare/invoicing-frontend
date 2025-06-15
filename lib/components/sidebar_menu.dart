import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/controllers/auth/auth_controller.dart';
import '../app/controllers/sidebar/sidebar_controller.dart';
import '../app/routes/app_routes.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}

class SidebarMenu extends StatelessWidget {
  SidebarMenu({super.key});

  final SidebarController controller = Get.put(SidebarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          // Background overlay when sidebar is open
          if (controller.isSidebarOpen.value)
            GestureDetector(
              onTap: () => controller.toggleSidebar(),
              child: Container(color: Colors.black.withAlpha(70)),
            ),

          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: controller.isSidebarOpen.value ? 0 : -260,
            top: 0,
            bottom: 0,
            width: 260,
            child: Material(
              elevation: 16,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade50,
                        child: const Icon(
                          Icons.photo_size_select_actual_rounded,
                          color: Colors.black,
                        ),
                      ),
                      title: const Text(
                        "Invoising Daily",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("sudha@invoicingdai.."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // SidebarItem(
                    //   icon: Icons.home_outlined,
                    //   label: "Dashboard",
                    //   onTap: () => Get.toNamed(Routes.dashboard),
                    // ),
                    SidebarItem(
                      icon: Icons.post_add,
                      label: "Create Invoice",
                      onTap: () => Get.toNamed(Routes.createInvoice),
                    ),

                    const Spacer(),
                    SidebarItem(
                      icon: Icons.logout,
                      label: "Logout",
                      onTap: () async {
                        await AuthController.to
                            .signOut(); // Handles Firebase & Google logout
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
