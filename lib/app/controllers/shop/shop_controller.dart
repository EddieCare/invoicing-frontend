import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../views/shop/shop_create.dart';

class ShopController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var shopData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;

  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;

  @override
  void onInit() {
    super.onInit();
    fetchShopDetails();
  }

  /// Fetch the first shop associated with the current vendor
  Future<void> fetchShopDetails() async {
    if (email == null) return;

    try {
      isLoading.value = true;

      final shopSnapshot =
          await _firestore
              .collection('vendors')
              .doc(email)
              .collection('shops')
              .limit(1)
              .get();

      if (shopSnapshot.docs.isNotEmpty) {
        final doc = shopSnapshot.docs.first;
        shopData.value = {...doc.data(), 'id': doc.id};
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
  Future<void> createShop(
    Map<String, dynamic> data, {
    Uint8List? logoBytes,
  }) async {
    if (email == null) return;

    try {
      isLoading.value = true;
      final shopRef = _firestore
          .collection('vendors')
          .doc(email)
          .collection('shops');

      // Prevent duplicate shop creation
      final existing = await shopRef.limit(1).get();
      if (existing.docs.isNotEmpty) {
        final doc = existing.docs.first;
        Get.toNamed(
          Routes.shopDetailScreen,
          arguments: {...doc.data(), 'id': doc.id},
        );
        return;
      }

      String? logoUrl;
      if (logoBytes != null) {
        try {
          logoUrl = await _uploadShopLogo(logoBytes);
        } catch (e) {
          Get.snackbar("Error", "Failed to upload shop logo: $e");
          return;
        }
      }

      final newShop = {
        ...data,
        if (logoUrl != null) "shopLogo": logoUrl,
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadShopLogo(Uint8List bytes) async {
    final path =
        'shops/${email ?? uid ?? 'unknown'}/logo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref(path);
    var options = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(bytes, options);
    return ref.getDownloadURL();
  }

  Future<void> updateShop({
    required String shopId,
    required Map<String, dynamic> data,
    Uint8List? logoBytes,
    String? previousLogoUrl,
  }) async {
    if (email == null) return;

    try {
      isLoading.value = true;

      String? logoUrl;
      if (logoBytes != null) {
        logoUrl = await _uploadShopLogo(logoBytes);
      }

      final payload = {
        ...data,
        if (logoUrl != null) 'shopLogo': logoUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('vendors')
          .doc(email)
          .collection('shops')
          .doc(shopId)
          .update(payload);

      await fetchShopDetails();
      Get.back();
      Get.snackbar('Success', 'Shop updated successfully');

      if (logoUrl != null &&
          previousLogoUrl != null &&
          previousLogoUrl.isNotEmpty) {
        try {
          await _deleteLogo(previousLogoUrl);
        } catch (_) {}
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update shop: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _deleteLogo(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  static const int _targetLogoBytes = 50 * 1024; // 50 KB
  static const int _maxUploadBytes = 2 * 1024 * 1024; // 2 MB

  Future<Uint8List?> optimiseLogo(Uint8List bytes) async {
    if (bytes.lengthInBytes > _maxUploadBytes) {
      Get.snackbar(
        "Logo Too Large",
        "Please select an image smaller than 2 MB.",
      );
      return null;
    }

    if (bytes.lengthInBytes <= _targetLogoBytes) {
      return bytes;
    }

    final original = bytes;
    Uint8List bestAttempt = bytes;
    int quality = 85;
    int minWidth = 800;
    int minHeight = 800;

    while (quality >= 30) {
      final compressed = await FlutterImageCompress.compressWithList(
        original,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      if (compressed.isEmpty) break;

      bestAttempt = Uint8List.fromList(compressed);
      if (bestAttempt.lengthInBytes <= _targetLogoBytes) {
        return bestAttempt;
      }

      if (minWidth > 320) {
        minWidth = (minWidth * 0.8).round();
        minHeight = (minHeight * 0.8).round();
      } else {
        quality -= 10;
      }
    }

    if (bestAttempt.lengthInBytes <= _targetLogoBytes) {
      return bestAttempt;
    }

    Get.snackbar(
      "Logo Too Detailed",
      "Unable to optimise below 50 KB. Please try a simpler logo.",
    );
    return null;
  }

  /// Used by profile or dashboard to navigate or trigger shop creation
  Future<void> checkAndViewOrCreateShop() async {
    if (uid == null || email == null) return;

    final shopCollection =
        await _firestore
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .get();

    if (shopCollection.docs.isNotEmpty) {
      final doc = shopCollection.docs.first;
      final firstShop = {...doc.data(), 'id': doc.id};
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
