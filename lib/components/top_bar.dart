import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../app/controllers/sidebar/sidebar_controller.dart';
import '../app/routes/app_routes.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leadingIcon;
  final String? title;
  final bool showBackButton;
  final bool centerTitle;
  final bool showMenu;
  final bool showAddInvoice;
  final List<Widget> actions;

  final SidebarController sidebarController = Get.put(SidebarController());

  TopBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.actions = const [],
    this.leadingIcon,
    this.centerTitle = false,
    this.showMenu = false,
    this.showAddInvoice = true,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.red, // Set the status bar color
        statusBarIconBrightness:
            Brightness.light, // Set the icon brightness (light or dark)
      ),
    );
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        child: ClipRRect(
          child: Container(
            color: Colors.white.withAlpha(50), // Soft transparent background
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
            child: Row(
              children: [
                SizedBox(width: 8),
                if (leadingIcon != null) SizedBox(child: leadingIcon),
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                // Placeholder for symmetry
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title ?? "",
                    textAlign: centerTitle ? TextAlign.center : TextAlign.left,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...actions,
                if (showAddInvoice)
                  IconButton(
                    icon: const Icon(Icons.post_add, size: 30),
                    onPressed: () => Get.toNamed(Routes.createInvoice),
                  ),
                // if (showMenu)
                //   IconButton(
                //     icon: const Icon(Icons.menu, size: 30),
                //     onPressed: () => sidebarController.toggleSidebar(),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
