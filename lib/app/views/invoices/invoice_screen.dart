import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:invoicedaily/app/controllers/dashboard/dashboard_controller.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_list_controller.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../routes/app_routes.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceListController());
    Get.put(DashboardController());

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoices",
        showBackButton: false,
        showMenu: true,
        showAddInvoice: false,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.search_outlined, size: 30),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            const SizedBox(height: 8),
            _buildUpgradeCard(controller),
            const SizedBox(height: 18),
            _buildFilters(controller),
            const SizedBox(height: 12),
            Expanded(
              child:
                  controller.invoices.isEmpty
                      ? Center(child: Text("No invoices found"))
                      : ListView.builder(
                        itemCount: controller.invoices.length,
                        itemBuilder: (context, index) {
                          final data = controller.invoices[index];
                          return InvoiceCard(invoice: data);
                        },
                        padding: const EdgeInsets.only(bottom: 80),
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.createInvoice),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters(InvoiceListController controller) {
    final filters = ['All', 'PAID', 'PENDING'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children:
            filters.map((status) {
              final isSelected = controller.selectedStatus.value == status;
              return GestureDetector(
                onTap: () => controller.setFilter(status),
                child: InvoiceFilterButton(text: status, selected: isSelected),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildUpgradeCard(InvoiceListController controller) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Obx(() {
        final d = Get.find<DashboardController>();
        final remaining = d.remainingInvoices.value;
        final limit = d.maxInvoices.value; // null => unlimited
        final used = limit == null ? null : (limit - remaining).clamp(0, limit);

        Color color;
        IconData icon;
        if (limit == null) {
          color = Colors.green;
          icon = Icons.all_inclusive;
        } else if (remaining <= 0) {
          color = Colors.redAccent;
          icon = Icons.error_outline;
        } else if (remaining <= 2) {
          color = Colors.orange;
          icon = Icons.warning_amber_rounded;
        } else {
          color = Colors.green;
          icon = Icons.check_circle_outline;
        }

        final title =
            limit == null
                ? 'Unlimited invoices this month'
                : '$remaining invoices left this month';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (limit != null)
                      Text(
                        'Used $used of $limit this month',
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class InvoiceFilterButton extends StatelessWidget {
  final String text;
  final bool selected;

  const InvoiceFilterButton({
    super.key,
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: selected ? Colors.black : const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final Map<String, dynamic> invoice;

  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final date = (invoice['issue_date'] as Timestamp?)?.toDate();
    final clientName = invoice['client']?['name'] ?? '';
    final total = (invoice['total'] ?? 0).toStringAsFixed(2);
    final status = (invoice['status'] ?? '').toString().toUpperCase();

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.invoiceDetails, arguments: invoice),
      child: Card(
        color: AppColor.pageColor,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: const Text(
                "\$",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          title: Text(
            invoice['invoice_number'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (date != null)
                Text(
                  "Date: ${DateFormat('d MMMM, yyyy').format(date)}",
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              const SizedBox(height: 2),
              Text(
                "\$ $total",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(clientName, style: const TextStyle(fontSize: 12)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _statusPill(status),
              const SizedBox(height: 6),
              const Icon(Icons.chevron_right),
            ],
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    final isPaid = status == 'PAID';
    final color = isPaid ? Colors.green : Colors.redAccent;
    final label = isPaid ? 'Paid' : 'Pending';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
