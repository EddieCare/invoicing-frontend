import 'package:get/get.dart';

class InvoiceController extends GetxController {
  RxList invoices = [].obs;
  RxBool hasDiscount = false.obs;
  RxInt discountAmt = 0.obs;

  void updateDiscount() {
    hasDiscount.value = !hasDiscount.value;
    discountAmt.value = !hasDiscount.value ? 0 : discountAmt.value;
  }

  void updateDiscountAmt(newValue) {
    discountAmt.value = int.parse(newValue);
  }

  void completeOnboarding() {
    // Logic to mark onboarding as complete
  }
}
