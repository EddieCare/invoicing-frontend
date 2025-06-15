import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../views/shop/shop_create.dart';

class ShopController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var shopData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;

  String? get uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchShopDetails();
  }

  /// Fetch the first shop associated with the current vendor
  Future<void> fetchShopDetails() async {
    if (uid == null) return;

    try {
      isLoading.value = true;

      final shopSnapshot =
          await _firestore
              .collection('vendors')
              .doc(uid)
              .collection('shops')
              .limit(1)
              .get();

      if (shopSnapshot.docs.isNotEmpty) {
        shopData.value = shopSnapshot.docs.first.data();
      } else {
        shopData.value = null;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch shop details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a shop for the current vendor if none exists
  Future<void> createShop(Map<String, dynamic> data) async {
    if (uid == null) return;

    try {
      final shopRef = _firestore
          .collection('vendors')
          .doc(uid)
          .collection('shops');

      // Prevent duplicate shop creation
      final existing = await shopRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        Get.toNamed(
          Routes.shopDetailScreen,
          arguments: existing.docs.first.data(),
        );
        return;
      }

      final newShop = {
        ...data,
        "isActive": true,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
        "createdBy": "adminUser_001",
        "vendorId": uid,
      };

      await shopRef.add(newShop);
      await fetchShopDetails(); // Refresh state
      Get.back(); // Close bottom sheet if open
      Get.snackbar("Success", "Shop created successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to create shop: $e");
    }
  }

  /// Used by profile or dashboard to navigate or trigger shop creation
  Future<void> checkAndViewOrCreateShop() async {
    if (uid == null) return;

    final shopCollection =
        await _firestore
            .collection('vendors')
            .doc(uid)
            .collection('shops')
            .get();

    if (shopCollection.docs.isNotEmpty) {
      final firstShop = shopCollection.docs.first.data();
      Get.toNamed(Routes.shopDetailScreen, arguments: firstShop);
    } else {
      showCreateShopBottomSheet(Get.context!);
    }
  }

  /// Clear the shop data (if needed)
  void resetShop() {
    shopData.value = null;
  }
}
