import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/services/iap_service.dart';

class SubscriptionController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxInt selectedTab = 0.obs;
  RxInt selectedPlan = 0.obs;
  RxString subscriptionType = "MONTHLY".obs;
  RxBool isYearly = false.obs;

  RxList<Map<String, dynamic>> plans = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
  }

  /// Fetch subscription plans securely
  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      final subscriptionDoc =
          await _firestore.collection('config').doc('subscriptionPlans').get();

      final data = subscriptionDoc.data();
      if (data != null) {
        final List<Map<String, dynamic>> loadedPlans = [];
        final orderedKeys = ['free', 'plus', 'premium'];

        for (final key in orderedKeys) {
          if (data.containsKey(key)) {
            final plan = data[key] ?? {};
            loadedPlans.add({
              'id': plan['id'] ?? "FREE",
              'name': plan['name'] ?? key.capitalizeFirst,
              'monthly': double.tryParse(plan['monthly'].toString()) ?? 0.0,
              'yearly': double.tryParse(plan['yearly'].toString()) ?? 0.0,
              'features': List<String>.from(plan['features'] ?? []),
              'limits': plan['limits'],
              'isOneTime': plan['isOneTime'] ?? false,
            });
          }
        }

        plans.assignAll(loadedPlans);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load plans: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Subscribe user securely
  Future<void> subscribe() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "You must be logged in to subscribe.");
      return;
    }

    final selected = plans[selectedPlan.value];
    if (selected.isEmpty) {
      Get.snackbar("Error", "No subscription plan selected.");
      return;
    }

    try {
      isLoading.value = true;

      // 1️⃣ Calculate repayment date
      final now = DateTime.now();
      DateTime repayDate =
          subscriptionType.value == "MONTHLY"
              ? DateTime(now.year, now.month + 1, now.day)
              : DateTime(now.year + 1, now.month, now.day);

      // 2️⃣ Call in-app purchase flow (Play Billing / StoreKit)
      // ⚠️ DO NOT mark as subscribed before backend verification
      final paymentSuccess = await _processPayment(selected);
      if (!paymentSuccess) {
        Get.snackbar("Error", "Payment failed or cancelled.");
        return;
      }

      // 3️⃣ Verify payment via backend before updating Firestore
      // Example: send payment token to backend to validate receipt
      final verified = await _verifyPaymentServerSide();
      if (!verified) {
        Get.snackbar("Error", "Payment verification failed.");
        return;
      }

      // 4️⃣ Update vendor document with subscription details
      await _firestore.collection('vendors').doc(user.email).update({
        'subscription': {
          'planId': selected['id'],
          'planName': selected['name'],
          'repaymentPeriod': subscriptionType.value,
          'repaymentDate': Timestamp.fromDate(repayDate),
          'invoicesLimit': (selected['limits'] ?? const {})['invoices'],
          'status': 'active',
        },
        'paymentDetails': {
          'amount':
              subscriptionType.value == "MONTHLY"
                  ? selected['monthly']
                  : selected['yearly'],
          'currency': 'USD',
          'method': GetPlatform.isIOS ? 'App Store' : 'Play Billing',
          'paidAt': FieldValue.serverTimestamp(),
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Subscription activated!");
    } catch (e) {
      Get.snackbar("Error", "Subscription failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// In-app purchase using `in_app_purchase` (StoreKit / Play Billing)
  Future<bool> _processPayment(Map<String, dynamic> plan) async {
    final planId = (plan['id'] ?? '').toString().toUpperCase();
    if (planId == 'FREE') {
      return true; // No charge for free plan
    }

    // Map plan + period -> product identifiers configured in stores
    final bool isMonthly = subscriptionType.value == 'MONTHLY';
    late final String productId;
    if (planId == 'PLUS') {
      productId = isMonthly ? 'plus_monthlyx' : 'plus_yearly';
    } else if (planId == 'PREMIUM') {
      productId = isMonthly ? 'premium_monthly' : 'premium_yearly';
    } else {
      return false;
    }

    print(
      "Purchasing product: $productId, monthly: $isMonthly, planId: $planId",
    );

    return await IAPService.instance.purchase(productId);
  }

  /// Dummy backend verification (replace with API call to validate receipt)
  Future<bool> _verifyPaymentServerSide() async {
    // TODO: Make secure HTTPS call to your backend to validate payment receipt
    await Future.delayed(Duration(seconds: 1));
    return true; // Simulate verified
  }

  void selectTab(int index) => selectedTab.value = index;

  void selectPlan(int index) => selectedPlan.value = index;
}
