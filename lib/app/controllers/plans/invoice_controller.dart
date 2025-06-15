// subscription_controller.dart
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedPlan = 0.obs;
  RxInt payPeriod = 0.obs;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void selectplan(int index) {
    selectedPlan.value = index;
  }

  void selectPayPeriod(int index) {
    payPeriod.value = index;
  }
}
