import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var shopData = Rxn<Map<String, dynamic>>();
  var isLoading = false.obs;

  String? get uid => _auth.currentUser?.uid;
  String? get email => _auth.currentUser?.email;

  @override
  void onInit() {
    super.onInit();
    fetchShopDetails();
  }

  Future<void> fetchShopDetails() async {
    if (email == null) return;
    isLoading.value = true;

    final shopCollection =
        await _firestore
            .collection('vendors')
            .doc(email)
            .collection('shops')
            .limit(1)
            .get();

    if (shopCollection.docs.isNotEmpty) {
      shopData.value = shopCollection.docs.first.data();
      print("Shop data: --------------> ${shopData.value}");
    } else {
      shopData.value = null;
    }
    isLoading.value = false;
  }

  Future<void> createShop(Map<String, dynamic> shopDataInput) async {
    if (email == null) return;

    final shopRef = _firestore
        .collection('vendors')
        .doc(email)
        .collection('shops');

    final newShop = {
      ...shopDataInput,
      "isActive": true,
      "createdAt": DateTime.now().toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
      "vendorId": uid,
    };

    await shopRef.add(newShop);
    await fetchShopDetails(); // Refresh after creation
    Get.snackbar("Success", "Shop created successfully");
  }
}
