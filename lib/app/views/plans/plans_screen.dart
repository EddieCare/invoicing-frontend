import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../controllers/plans/plans_controller.dart';
import '../../routes/app_routes.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: TopBar(
        title: "Manage Plans",
        showBackButton: true,
        showAddInvoice: false,
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(Routes.baseScreen),
            child: const Text(
              "Skip for now",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 16),
            _buildPlanTabs(),
            const SizedBox(height: 20),
            _buildToggle(),
            const SizedBox(height: 12),
            Expanded(child: _buildPlanDetail()),
          ],
        );
      }),
    );
  }

  Widget _buildPlanTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(controller.plans.length, (index) {
          final isSelected = controller.selectedPlan.value == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedPlan.value = index,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    controller.plans[index]['name'].toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildToggle() {
    final plan = controller.plans[controller.selectedPlan.value];
    final isYearly = controller.isYearly.value;

    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => Flexible(
              child: _PricePeriodBox(
                title: 'Monthly Plan',
                subtitle: '${plan['monthly']}\$ /Month',
                subscriptionType: "MONTHLY",
              ),
            ),
          ),
          Obx(
            () => Flexible(
              child: _PricePeriodBox(
                title: 'Yearly Plan',
                subtitle: '${plan['yearly']}\$ Yearly',
                subscriptionType: "YEARLY",
              ),
            ),
          ),
          // const Text("Yearly"),
        ],
      ),
    );
  }

  Widget _buildPlanDetail() {
    final plan = controller.plans[controller.selectedPlan.value];
    // final isYearly = controller.isYearly.value;
    // final price = isYearly ? plan['yearly'] : plan['monthly'];
    // final subtitle = isYearly ? "\$$price /year" : "\$$price /month";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // _PriceBox(
          //   title: "${plan['name']} Plan",
          //   subtitle: subtitle,
          //   highlight: true,
          // ),
          // const SizedBox(height: 20),
          _FeaturesBox(
            features: List<String>.from(plan['features'] as List<dynamic>),
          ),
          const SizedBox(height: 20),
          _SubscribeButton(controller: controller),
        ],
      ),
    );
  }

  _PricePeriodBox({
    required String title,
    required String subscriptionType,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        // controller.isYearly.value = !highlight;
        controller.subscriptionType.value = subscriptionType;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color:
              subscriptionType == controller.subscriptionType.value
                  ? Colors.green.shade50
                  : Colors.white,
          border: Border.all(
            color:
                subscriptionType == controller.subscriptionType.value
                    ? Colors.green
                    : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool highlight;

  const _PriceBox({
    required this.title,
    required this.subtitle,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Colors.green.shade50 : Colors.white,
        border: Border.all(
          color: highlight ? Colors.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _FeaturesBox extends StatelessWidget {
  final List<String> features;

  const _FeaturesBox({required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          features
              .map(
                (feature) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _SubscribeButton extends StatelessWidget {
  final SubscriptionController controller;

  const _SubscribeButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            // TODO: Handle button press
            await controller.subscribe();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Subscribe',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Automatically renews until cancelled',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          'Privacy Policy : Terms of Service',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
