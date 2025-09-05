import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/app/routes/app_routes.dart';
import 'package:invoicedaily/components/urgent_notification_card.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../controllers/invoice/invoice_controller.dart';
import '../../controllers/shop/shop_controller.dart';
import '../../controllers/base/base_controller.dart';
import '../shop/shop_create.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final ShopController shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String monthName(int month) {
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return months[month - 1];
    }

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        showBackButton: false,
        showMenu: true,
        actions: [
          Icon(Icons.notifications_none, size: 30),
          SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            // child: CircularProgressIndicator(color: AppColor.textColorPrimary),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    width: screenSize.width * 0.93,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Apr 16, 2025",
                          "${DateTime.now().toLocal().day.toString().padLeft(2, '0')} "
                          "${monthName(DateTime.now().month)}, "
                          "${DateTime.now().year}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 15),
                  const SizedBox(height: 24),
                  shopController.shopData.value != null
                      ? _buildShopCard(
                        shopController.shopData.value!,
                        screenSize,
                      )
                      : _buildCreateShopPrompt(screenSize),

                  const SizedBox(height: 24),
                  Obx(() {
                    if (!controller.hasAnalytics.value) {
                      return const SizedBox.shrink();
                    }
                    final s = controller.analyticsSummary;
                    return Container(
                      width: screenSize.width * 0.93,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withAlpha(16),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Financial Overview",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () =>
                                        Get.find<BaseController>().changeTab(1),
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () =>
                                controller.showGrowthCongrats.value
                                    ? urgentNotificationsCard(
                                      growthRate:
                                          ((s['growthRate'] ?? 0.0) as num)
                                              .toDouble(),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 18),
                          _invoicesRemainingBar(),
                          const SizedBox(height: 16),
                          Center(
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _metricCard(
                                  width: screenSize.width * 0.40,
                                  title: 'Revenue',
                                  primary: _currency(s['totalRevenue'] ?? 0),
                                  subtitle: 'Total Invoiced',
                                  color: Colors.black,
                                ),
                                _metricCard(
                                  width: screenSize.width * 0.40,
                                  title: 'Paid',
                                  primary: '${s['paidCount'] ?? 0}',
                                  subtitle: _currency(
                                    (s['paidRevenue'] ?? 0).toDouble(),
                                  ),
                                  color: const Color(0xFFE8EAF6),
                                  textDark: true,
                                ),
                                _metricCard(
                                  width: screenSize.width * 0.40,
                                  title: 'Pending',
                                  primary: '${s['pendingCount'] ?? 0}',
                                  subtitle: _currency(
                                    (s['pendingAmount'] ?? 0).toDouble(),
                                  ),
                                  color: const Color(0xFFFFF3E0),
                                  textDark: true,
                                ),
                                _metricCard(
                                  width: screenSize.width * 0.40,
                                  title: 'Avg Invoice',
                                  primary: _currency(
                                    (s['avgInvoiceValue'] ?? 0).toDouble(),
                                  ),
                                  subtitle: 'Average value',
                                  color: const Color(0xFFE0F2F1),
                                  textDark: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  pendingInvoices(screenSize),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _metricCard({
    required double width,
    required String title,
    required String primary,
    required String subtitle,
    required Color color,
    bool textDark = false,
  }) {
    final textColor = textDark ? Colors.black : Colors.white;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: textColor.withAlpha(100))),
          const SizedBox(height: 8),
          Text(
            primary,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateShopPrompt(Size screenSize) {
    return GestureDetector(
      onTap: () {
        showCreateShopBottomSheet(
          Get.context!,
          // onCreate: (data) {
          //   controller.createShop(data);
          // },
        );
      },
      child: Container(
        width: screenSize.width * 0.9,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.store, size: 40),
            const SizedBox(height: 12),
            Text(
              "No shop found. Tap to create your shop now!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Container pendingInvoices(Size screenSize) {
    return Container(
      width: screenSize.width * 0.93,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(16),
            offset: const Offset(0, 3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pending Invoices",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => Get.find<BaseController>().changeTab(2),
                child: const Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Check pending and unpaid invoices",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final invoices =
                Get.find<InvoiceController>().latestPendingOrUnpaid;
            if (invoices.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    "No pending invoices found.",
                    style: TextStyle(
                      color: AppColor.textColorPrimary.withAlpha(80),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              );
            }
            final display = invoices.take(3).toList();
            return Container(
              constraints: BoxConstraints(
                maxHeight: 72.0 * (display.length.clamp(1, 3)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: display.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) => pendingInvoiceCard(display[i]),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Container pendingInvoiceCard() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(15)),
  //       border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
  //       color: Color(0xFF7A7A7A).withAlpha(16),
  //     ),
  //     margin: EdgeInsets.only(top: 18),
  //     padding: EdgeInsets.symmetric(vertical: 4),
  //     child: ListTile(
  //       leading: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(15)),
  //         ),
  //         child: Image.asset(
  //           "assets/images/pending_invoice.png",
  //           height: 45,
  //           width: 45,
  //         ),
  //       ),
  //       title: Text(
  //         "INV-20240304-003",
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w200,
  //           color: Colors.black,
  //         ),
  //       ),
  //       subtitle: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Pending Invoice",
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black,
  //             ),
  //           ),
  //           Text(
  //             "Due: 27 March, 2025",
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: Colors.red,
  //             ),
  //           ),
  //         ],
  //       ),
  //       trailing: Text(
  //         "4000 AUD",
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget pendingInvoiceCard(Map<String, dynamic> invoice) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(15)),
  //       border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
  //       color: Color(0xFF7A7A7A).withAlpha(16),
  //     ),
  //     margin: EdgeInsets.only(top: 18),
  //     padding: EdgeInsets.symmetric(vertical: 4),
  //     child: ListTile(
  //       leading: Image.asset(
  //         "assets/images/pending_invoice.png",
  //         height: 45,
  //         width: 45,
  //       ),
  //       title: Text(
  //         invoice['invoice_number'] ?? '',
  //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
  //       ),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "${invoice['status']} Invoice",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //           ),
  //           Text(
  //             "Due: ${_formatDate(invoice['due_date'])}",
  //             style: TextStyle(fontSize: 14, color: Colors.red),
  //           ),
  //         ],
  //       ),
  //       trailing: Text(
  //         "${invoice['total'] ?? 0} AUD",
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  //       ),
  //     ),
  //   );
  // }

  // String _formatDate(Timestamp? timestamp) {
  //   if (timestamp == null) return '';
  //   final date = timestamp.toDate();
  //   return "${date.day} ${_monthName(date.month)}, ${date.year}";
  // }

  // String _monthName(int month) {
  //   const months = [
  //     "",
  //     "January",
  //     "February",
  //     "March",
  //     "April",
  //     "May",
  //     "June",
  //     "July",
  //     "August",
  //     "September",
  //     "October",
  //     "November",
  //     "December",
  //   ];
  //   return months[month];
  // }

  Widget pendingInvoiceCard(Map<String, dynamic> invoice) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: const Color(0xFFF8F8F8),
        border: Border.all(color: Colors.black12.withAlpha(24), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/images/pending_invoice.png"),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice['invoice_number'] ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     "${invoice['status']} Invoice",
                    //     style: const TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    Text(
                      "Due: ${_formatDate(invoice['due_date'])}",
                      style: const TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${(invoice['total'] ?? 0).toStringAsFixed(2)} AUD",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return "${date.day} ${_monthName(date.month)}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month];
  }

  Widget _buildShopCard(Map<String, dynamic> shopData, Size screenSize) {
    final address = (shopData['shop_address'] ?? {}) as Map<String, dynamic>;
    return GestureDetector(
      onTap: () => {Get.toNamed(Routes.shopDetailScreen, arguments: shopData)},
      child: Stack(
        children: [
          Container(
            width: screenSize.width * 0.93,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF333333)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: screenSize.width * 0.22,
                    height: screenSize.width * 0.22,
                    color: Colors.white10,
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopData["shop_name"] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shopData['shop_email'] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 181, 181, 181),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  shopData['shop_phone'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              [address['street'], address['zip']]
                                  .where((e) => (e ?? '').toString().isNotEmpty)
                                  .join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(255, 242, 242, 242),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned.fill(child: IgnorePointer(child: _SheenOverlay())),
        ],
      ),
    );
  }

  String _currency(num n) {
    return "\$" + n.toStringAsFixed(2);
  }

  Widget _analyticTile({
    required double width,
    required String title,
    required String primary,
    String? subtitle,
    required Color color,
    bool dark = false,
  }) {
    final tc = dark ? Colors.white : Colors.black;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: tc.withOpacity(0.8))),
          const SizedBox(height: 8),
          Text(
            primary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: tc,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: tc.withOpacity(0.8), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _invoicesRemainingBar() {
    return Obx(() {
      final d = Get.find<DashboardController>();
      final total = d.maxInvoices.value; // null if unlimited
      if (total == null) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.all_inclusive, color: Colors.black87),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Unlimited invoices on your plan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }

      final used = d.usedInvoices.value ?? 0;
      final remaining = d.remainingInvoices.value;
      final progress = total == 0 ? 0.0 : (used / total).clamp(0, 1).toDouble();

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Invoices Remaining',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$remaining of $total',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = constraints.maxWidth;
                final fillWidth = barWidth * progress;
                return Container(
                  height: 12,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        width: fillWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _growthTile({required double width, required double growthRate}) {
    final isUp = growthRate >= 0;
    final color = isUp ? const Color(0xFFE0F2F1) : const Color(0xFFFFEBEE);
    final arrow = isUp ? Icons.arrow_upward : Icons.arrow_downward;
    final label = isUp ? 'Growth' : 'Decline';
    return Container(
      height: 0.42 * width,
      width: width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$label MoM', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(arrow, size: 18, color: Colors.black87),
                const SizedBox(width: 6),
                Text(
                  '${growthRate.abs().toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'vs last month',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheenOverlay extends StatefulWidget {
  const _SheenOverlay({Key? key}) : super(key: key);

  @override
  State<_SheenOverlay> createState() => _SheenOverlayState();
}

class _SheenOverlayState extends State<_SheenOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final percent = _ctrl.value; // 0..1
        return CustomPaint(painter: _SheenPainter(percent: percent));
      },
    );
  }
}

class _SheenPainter extends CustomPainter {
  final double percent;
  _SheenPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final diag = math.sqrt(width * width + height * height);

    // Move to center and rotate 45 degrees
    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.rotate(0.78539816339); // ~45 degrees in radians

    final bandWidth = diag * 0.18;
    final travel = diag + bandWidth;
    final x = percent * travel - (travel / 2);
    final rect = Rect.fromLTWH(x, -diag / 2, bandWidth, diag);

    final gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0x00FFFFFF), Color(0x26FFFFFF), Color(0x00FFFFFF)],
      stops: [0.0, 0.5, 1.0],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SheenPainter oldDelegate) =>
      oldDelegate.percent != percent;
}
