import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';

class DeleteReasonScreen extends StatefulWidget {
  @override
  _DeleteReasonScreenState createState() => _DeleteReasonScreenState();
}

class _DeleteReasonScreenState extends State<DeleteReasonScreen> {
  String? selectedReason;

  final reasons = [
    "No longer using the service/platform",
    "Found a better alternative",
    "Privacy concerns",
    "Too many emails/notifications",
    "Difficulty navigating the platform",
    "Account security concerns",
    "Personal reasons",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: "Why leaving us?",
        // leadingIcon: Icon(Icons.settings, size: 30),
        showBackButton: true,
        showMenu: true,
        showAddInvoice: false,
        actions: [Row(children: [
            ],
          )],
      ),
      backgroundColor: AppColor.pageColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColor.textColorPrimary.withAlpha(100)),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Reason of deleting Account",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.textColorPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 2, left: 16, bottom: 16),
              child: Text(
                "If you need to delete an account and you're prompted to provide a reason.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final reason = reasons[index];
                  return RadioListTile<String>(
                    value: reason,
                    groupValue: selectedReason,
                    onChanged:
                        (value) => setState(() {
                          selectedReason = value;
                        }),
                    title: Text(reason),
                    activeColor: AppColor.textColorPrimary,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed:
                    selectedReason == null
                        ? null
                        : () => Get.back(result: selectedReason),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: AppColor.buttonColor,
                  foregroundColor: AppColor.buttonTextColor,
                ),
                child: const Text("Delete"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
