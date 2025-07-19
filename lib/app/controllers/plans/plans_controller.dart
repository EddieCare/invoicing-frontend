import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxInt selectedPlan = 0.obs;
  RxInt payPeriod = 0.obs;

  RxInt selectedPlanIndex = 1.obs;
  RxBool isYearly = false.obs;

  final plans = [
    {
      'name': 'Free',
      'monthly': '0',
      'yearly': '0',
      'features': ['Basic invoices', 'Limited Estimates'],
    },
    {
      'name': 'Plus',
      'monthly': '4.99',
      'yearly': '49.99',
      'features': [
        '15 Invoices /Month',
        'Reports',
        'Add Pictures',
        'Unlimited Estimates',
      ],
    },
    {
      'name': 'Premium',
      'monthly': '9.99',
      'yearly': '99.99',
      'features': [
        'Unlimited Invoices',
        'Reports',
        'Pictures',
        'Unlimited Estimates',
        'Priority Support',
      ],
    },
  ];

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
