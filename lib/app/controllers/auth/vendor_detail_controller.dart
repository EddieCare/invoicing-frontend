import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoicedaily/app/routes/app_routes.dart';

class VendorDetailsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();
  final registrationController = TextEditingController();
  final categoryController = TextEditingController();
  final businessTypeController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      emailController.text = user.email ?? '';
      nameController.text = user.displayName ?? '';

      // Optional: Split displayName into firstName and lastName
      final fullName = user.displayName ?? '';
      final nameParts = fullName.split(" ");
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(" ") : '';

      firstNameController.text = firstName;
      lastNameController.text = lastName;
    }
  }

  Future<void> submitDetails() async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final uid = user.uid;

    final vendorData = {
      "uid": uid,
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "address": {
        "street": streetController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "zip": zipController.text.trim(),
        "country": countryController.text.trim(),
      },
      "companyRegistrationNumber": registrationController.text.trim(),
      "catagory": categoryController.text.trim(),
      "businessType": businessTypeController.text.trim(),
      "isActive": true,
      "isSubscribed": false,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
      "createdBy": uid,
    };

    try {
      await _firestore.collection("vendors").doc(uid).set(vendorData);
      Get.snackbar("Success", "Vendor details saved");
      Get.toNamed(Routes.baseScreen);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
