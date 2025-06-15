// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../components/top_bar.dart';
// import '../../../../values/values.dart';
// import '../../../controllers/profile/profile_controller.dart';

// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({super.key});

//   final ProfileController controller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: AppColor.pageColor,
//       appBar: TopBar(
//         title: "Notification Settings",
//         // leadingIcon: Icon(Icons.settings, size: 30),
//         showBackButton: true,
//         actions: [
//           Row(
//             children: [
//               IconButton(icon: Icon(Icons.search, size: 28), onPressed: () {}),
//               IconButton(
//                 icon: Icon(Icons.menu, size: 28),
//                 onPressed: () {
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text("Coming Soon")));
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Container(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/top_bar.dart';
import '../../../../values/values.dart';
import '../../../controllers/profile/profile_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Notifications",
        showBackButton: true,
        showAddInvoice: false,
        actions: [
          // IconButton(icon: Icon(Icons.search, size: 28), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SectionHeader(title: "Common"),
            NotificationToggleTile(
              index: 0,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),
            NotificationToggleTile(
              index: 1,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),
            NotificationToggleTile(
              index: 2,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),

            SectionHeader(title: "System & services update"),
            NotificationToggleTile(
              index: 3,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),
            NotificationToggleTile(
              index: 4,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),

            SectionHeader(title: "Others"),
            NotificationToggleTile(
              index: 5,
              title: "General Notification",
              subTitle: "Turn on to receive all general purpose notifications",
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class NotificationToggleTile extends StatelessWidget {
  final int index;
  final String title;
  final String subTitle;
  final ProfileController controller = Get.find();

  NotificationToggleTile({
    super.key,
    required this.index,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () => controller.toggleNotification(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "General Notification",
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      // "Turn on to receive all general purpose notifications",
                      subTitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: controller.notifications[index],
                onChanged: (val) => controller.toggleNotification(index),
                activeColor: AppColor.toggleButtonColor,
                inactiveThumbColor: AppColor.toggleButtonColor.withAlpha(60),
                inactiveTrackColor: AppColor.toggleButtonColor.withAlpha(30),
                trackOutlineColor: WidgetStateColor.transparent,
              ),
            ],
          ),
        ),
      );
    });
  }
}
