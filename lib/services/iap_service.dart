import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

enum BillingPeriod { monthly, yearly }

class IAPService {
  IAPService._();
  static final IAPService instance = IAPService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  // Configure these product IDs in App Store Connect and Google Play Console
  // and keep them consistent across stores where possible.
  // Example identifiers (replace with your real IDs):
  static const String plusMonthly = 'plus_monthlyx';
  static const String plusYearly = 'plus_yearly';
  static const String premiumMonthly = 'premium_monthly';
  static const String premiumYearly = 'premium_yearly';

  Future<void> init() async {
    // Ensure the purchase stream is listened to exactly once.
    _sub ??= _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {
        _sub?.cancel();
      },
      onError: (e) {
        // Handle error appropriately in UI layer if needed.
      },
    );
  }

  Completer<bool>? _purchaseCompleter;

  void _onPurchaseUpdated(List<PurchaseDetails> detailsList) async {
    for (final purchaseDetails in detailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Always verify receipt server-side in production.
          if (_iapVerifier != null) {
            final verified = await _iapVerifier!(purchaseDetails);
            if (!verified) {
              _purchaseCompleter?.complete(false);
              return;
            }
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await _iap.completePurchase(purchaseDetails);
          }
          _purchaseCompleter?.complete(true);
          break;
        case PurchaseStatus.pending:
          // No-op; UI can show spinner
          break;
        case PurchaseStatus.error:
          _purchaseCompleter?.complete(false);
          break;
        case PurchaseStatus.canceled:
          _purchaseCompleter?.complete(false);
          break;
      }
    }
  }

  /// Optional: Plug in your server-side verification.
  /// Return true if the receipt is valid, false otherwise.
  Future<bool> Function(PurchaseDetails details)? _iapVerifier;
  void setReceiptVerifier(
    Future<bool> Function(PurchaseDetails details) verifier,
  ) {
    _iapVerifier = verifier;
  }

  Future<bool> purchase(String productId) async {
    final available = await _iap.isAvailable();
    print("IAP Available: $available");
    if (!available) return false;

    final response = await _iap.queryProductDetails({productId});
    print(
      "IAP Query Response: ${response.productDetails}, NotFound: ${response.notFoundIDs}, productId: $productId",
    );
    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      return false;
    }

    final product = response.productDetails.first;
    final param = PurchaseParam(productDetails: product);

    _purchaseCompleter = Completer<bool>();
    await init();

    // Subscriptions are non-consumable purchases with auto-renew in the store
    await _iap.buyNonConsumable(purchaseParam: param);
    final result = await _purchaseCompleter!.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () => false,
    );
    _purchaseCompleter = null;
    return result;
  }
}
