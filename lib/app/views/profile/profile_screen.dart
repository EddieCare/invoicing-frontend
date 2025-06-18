import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../controllers/shop/shop_controller.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final ShopController shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Settings",
        // leadingIcon: Icon(Icons.settings, size: 30),
        showBackButton: false,
        showMenu: true,
        showAddInvoice: false,
        actions: [
          Row(
            children: [
              // IconButton(icon: Icon(Icons.search, size: 28), onPressed: () {}),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              child: Image.asset("assets/images/default_profile.png"),
            ),
            SizedBox(height: 12),
            Text(
              controller.vendorData.value?['name'] ?? 'Loading...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.vendorData.value?['email'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.editProfile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Edit profile",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSettingsCard(
              context,
              children: [
                // _buildListTile(
                //   Icons.edit,
                //   "Edit profile information",
                //   onTap: () => {Get.toNamed(Routes.editProfile)},
                // ),
                _buildListTile(
                  Icons.notifications_none,
                  "Notifications",
                  trailing: Text("ON", style: TextStyle(color: Colors.green)),
                  onTap: () => {Get.toNamed(Routes.notificationScreen)},
                ),
                _buildListTile(
                  Icons.language,
                  "Language",
                  trailing: Text(
                    "English",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () => {Get.toNamed(Routes.languageScreen)},
                ),
              ],
            ),
            _buildSettingsCard(
              context,
              children: [
                _buildListTile(
                  Icons.add_business_outlined,
                  "View Shop",
                  onTap: () => {shopController.checkAndViewOrCreateShop()},
                ),
              ],
            ),

            _buildSettingsCard(
              context,
              children: [
                _buildListTile(
                  Icons.receipt_long,
                  "Manage Subscription",
                  onTap: () => {Get.toNamed(Routes.plansScreen)},
                ),
                _buildListTile(
                  Icons.restore_outlined,
                  "Restore Purchases",
                  onTap: () => {Get.toNamed(Routes.plansScreen)},
                ),
                _buildListTile(
                  Icons.delete,
                  "Delete Account",
                  onTap: () => {Get.toNamed(Routes.plansScreen)},
                ),
              ],
            ),

            // Spacer(),
            SizedBox(height: 10),
            _buildSettingsCard(
              context,
              cardTitle: "About",
              children: [
                // _buildListTile(Icons.support_agent, "About"),
                _buildListTile(
                  Icons.security,
                  "App version ${Config.versionCode}",
                ),
                // _buildListTile(Icons.support_agent, "Help & Support"),
                _buildListTile(Icons.chat_bubble_outline, "Contact us"),
                _buildListTile(Icons.lock_outline, "Privacy policy"),
                _buildListTile(Icons.terminal_sharp, "Terms of Services"),
                _buildListTile(
                  Icons.logout_sharp,
                  "Logout",
                  onTap: () async {
                    await AuthController.to
                        .signOut(); // Handles Firebase & Google logout
                  },
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    String? cardTitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          if (cardTitle != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                cardTitle ?? "",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
