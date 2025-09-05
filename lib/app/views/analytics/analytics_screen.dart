import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../values/values.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../../components/top_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final AnalyticsController controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: 'Analytics',
        showBackButton: false,
        showMenu: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.hasData.value) {
          return _emptyState(context);
        }

        final s = controller.summary;
        final lid = s['lastInvoiceDate'];
        DateTime? lastDate;
        if (lid is DateTime) lastDate = lid;
        if (lid is Timestamp) lastDate = lid.toDate();
        final lastDateStr = lastDate == null
            ? '-'
            : DateFormat('MMM d, yyyy').format(lastDate);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _sectionHeader('This Month'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _metricCard(
                      width: screenSize.width * 0.43,
                      title: 'Revenue',
                      primary: _currency(s['totalRevenue'] ?? 0),
                      subtitle: 'Total Invoiced',
                      color: Colors.black,
                    ),
                    _metricCard(
                      width: screenSize.width * 0.43,
                      title: 'Paid',
                      primary: '${s['paidCount'] ?? 0}',
                      subtitle:
                          _currency((s['paidRevenue'] ?? 0).toDouble()),
                      color: const Color(0xFFE8EAF6),
                      textDark: true,
                    ),
                    _metricCard(
                      width: screenSize.width * 0.43,
                      title: 'Pending',
                      primary: '${s['pendingCount'] ?? 0}',
                      subtitle:
                          _currency((s['pendingAmount'] ?? 0).toDouble()),
                      color: const Color(0xFFFFF3E0),
                      textDark: true,
                    ),
                    _metricCard(
                      width: screenSize.width * 0.43,
                      title: 'Avg Invoice',
                      primary: _currency((s['avgInvoiceValue'] ?? 0).toDouble()),
                      subtitle: 'Average value',
                      color: const Color(0xFFE0F2F1),
                      textDark: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _sectionHeader('Insights'),
                const SizedBox(height: 12),
                _infoTile(
                  icon: Icons.event_available,
                  title: 'Last Invoice',
                  value: lastDateStr,
                ),
                const SizedBox(height: 8),
                _infoTile(
                  icon: Icons.playlist_add_check_circle_outlined,
                  title: 'Invoices Remaining',
                  value: controller.remainingInvoices.value >= 99999
                      ? 'Unlimited'
                      : controller.remainingInvoices.value.toString(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.insights_outlined, size: 64, color: Colors.black26),
            SizedBox(height: 12),
            Text(
              'No analytics to show yet',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 6),
            Text(
              'Create invoices to see analytics here.',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      );

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
          Text(title, style: TextStyle(color: textColor.withOpacity(0.8))),
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

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(10),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.insights, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _currency(num n) => '\$' + NumberFormat('#,##0.00').format(n);
}
