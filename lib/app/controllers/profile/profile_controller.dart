import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../views/shop/shop_create.dart';

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
}
