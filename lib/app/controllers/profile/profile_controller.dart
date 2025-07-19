import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../values/values.dart';
import '../../routes/app_routes.dart';
import '../../views/shop/shop_create.dart';
import '../../views/profile/delete_reason.dart';

class ProfileController extends GetxController {
  RxList<bool> notifications = List<bool>.filled(6, false).obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var vendorData = Rxn<Map<String, dynamic>>();

  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;

  @override
  void onInit() {
    super.onInit();
    fetchVendorData();
  }

  Future<void> fetchVendorData() async {
    if (uid == null) return;

    final doc = await _firestore.collection('vendors').doc(email).get();
    if (doc.exists) {
      vendorData.value = doc.data();
    }
  }

  void toggleNotification(int index) {
    notifications[index] = !notifications[index];
  }

  void completeOnboarding() {
    // Logic to mark onboarding as complete
  }

  void deleteAccountFlow(BuildContext context) async {
    final selectedReason = await Get.to<String>(() => DeleteReasonScreen());
    if (selectedReason == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon(Icons.help_outline, size: 48, color: Colors.amber),
                Image.asset(
                  "assets/icons/delete_emotional.png",
                  width: 64,
                  height: 64,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  "We're sad to see you go",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 91, 91, 91),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You want to delete your account permanently.\n\n"
                  "Ensuring that you understands the consequences "
                  "of deleting your account. You might see loss of data and subscriptions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  "Keep Account",
                  style: TextStyle(color: AppColor.buttonColor),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonColor,
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: AppColor.buttonTextColor),
                ),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _firestore.collection("vendors").doc(email).update({
        "isArchived": true,
        "account_deletion_reasons": {
          "reason": selectedReason,
          "timestamp": FieldValue.serverTimestamp(),
        },
      });
      await _auth.signOut();
      Get.offAllNamed(Routes.authMain);
    }
  }
}
