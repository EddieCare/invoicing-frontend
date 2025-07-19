import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/app/routes/app_routes.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';

class SubscriptionController extends GetxController {
  var selectedTabIndex = 1.obs; // Default to 'Plus'

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key});

  final SubscriptionController controller = Get.put(SubscriptionController());
  final List<String> tabs = ['Free', 'Plus', 'Premium'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Manage Plans",
        showBackButton: true,
        showAddInvoice: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.baseScreen);
            },
            child: const Text(
              "Skip for now",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: List.generate(
                    tabs.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeTab(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controller.selectedTabIndex.value == index
                                    ? Colors.black
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color:
                                    controller.selectedTabIndex.value == index
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: IndexedStack(
                index: controller.selectedTabIndex.value,
                children: [
                  _PlanContentFree(),
                  _PlanContentPlus(planType: 'Plus'),
                  _PlanContentPremium(planType: 'Premium'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanContentFree extends StatelessWidget {
  const _PlanContentFree();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _PriceBox(
                        title: 'Free Plan',
                        subtitle: '11.99 \$ /Month',
                        highlight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FeaturesBox(
                  features: [
                    'All the features in Free tier',
                    '15 Invoices /Month',
                    'Reports',
                    'Add Pictures',
                    'Unlimited Estimates',
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Subscribe',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PlanContentPlus extends StatelessWidget {
  final String planType;

  const _PlanContentPlus({required this.planType});

  @override
  Widget build(BuildContext context) {
    bool isPlus = planType == 'Plus' || planType == "Premium";

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _PriceBox(
                        title: '$planType Plan',
                        subtitle: '11.99 \$ /Month',
                      ),
                    ),
                    if (isPlus) const SizedBox(width: 16),
                    if (isPlus)
                      Flexible(
                        child: _PriceBox(
                          title: '$planType Plan',
                          subtitle: '11.99 \$ /Yearly',
                          badge: 'Selected',
                          highlight: true,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _FeaturesBox(
                  features: [
                    'All the features in Free tier',
                    '15 Invoices /Month',
                    'Reports',
                    'Add Pictures',
                    'Unlimited Estimates',
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Subscribe',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PlanContentPremium extends StatelessWidget {
  final String planType;

  const _PlanContentPremium({required this.planType});

  @override
  Widget build(BuildContext context) {
    bool isPlus = planType == 'Plus' || planType == "Premium";

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _PriceBox(
                        title: '$planType Plan',
                        subtitle: '11.99 \$ /Month',
                      ),
                    ),
                    if (isPlus) const SizedBox(width: 16),
                    if (isPlus)
                      Flexible(
                        child: _PriceBox(
                          title: '$planType Plan',
                          subtitle: '11.99 \$ /Yearly',
                          badge: 'Selected',
                          highlight: true,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _FeaturesBox(
                  features: [
                    'All the features in Free tier',
                    '15 Invoices /Month',
                    'Reports',
                    'Add Pictures',
                    'Unlimited Estimates',
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Subscribe',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
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
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PriceBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badge;
  final bool highlight;

  const _PriceBox({
    required this.title,
    required this.subtitle,
    this.badge,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                badge!,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturesBox extends StatelessWidget {
  final List<String> features;

  const _FeaturesBox({required this.features});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children:
            features
                .map(
                  (feature) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            Text(feature),
                          ],
                        ),
                        const Icon(Icons.check_circle, color: Colors.green),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
