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

  @override
  void onInit() {
    super.onInit();
    fetchVendorData();
  }

  Future<void> fetchVendorData() async {
    if (uid == null) return;

    final doc = await _firestore.collection('vendors').doc(uid).get();
    if (doc.exists) {
      vendorData.value = doc.data();
    }
  }

  // Future<void> checkAndViewShop() async {
  //   final userId = _auth.currentUser?.uid;
  //   if (userId == null) return;

  //   final shopCollection =
  //       await FirebaseFirestore.instance
  //           .collection('vendors')
  //           .doc(userId)
  //           .collection('shops')
  //           .get();

  //   if (shopCollection.docs.isNotEmpty) {
  //     final firstShop = shopCollection.docs.first.data();
  //     Get.toNamed(Routes.shopDetailScreen, arguments: firstShop);
  //   } else {
  //     showCreateShopBottomSheet(Get.context!);
  //   }
  // }

  // Future<void> createShop(Map<String, dynamic> shopData) async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid == null) return;

  //   final shopRef = FirebaseFirestore.instance
  //       .collection('vendors')
  //       .doc(uid)
  //       .collection('shops');

  //   final existing = await shopRef.limit(1).get();
  //   if (existing.docs.isNotEmpty) {
  //     Get.toNamed(
  //       Routes.shopDetailScreen,
  //       arguments: existing.docs.first.data(),
  //     );
  //     return;
  //   }

  //   final newShop = {
  //     ...shopData,
  //     "isActive": true,
  //     "createdAt": DateTime.now().toIso8601String(),
  //     "updatedAt": DateTime.now().toIso8601String(),
  //     "createdBy": "adminUser_001",
  //     "vendorId": uid,
  //   };

  //   await shopRef.add(newShop);
  //   // refetch here an return
  //   Get.back(); // Close bottom sheet
  //   Get.snackbar("Success", "Shop created successfully");
  // }

  void toggleNotification(int index) {
    notifications[index] = !notifications[index];
  }

  void completeOnboarding() {
    // Logic to mark onboarding as complete
  }
}
