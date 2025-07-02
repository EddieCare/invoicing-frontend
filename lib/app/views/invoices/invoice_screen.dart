import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_list_controller.dart';
import '../../routes/app_routes.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceListController());

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
            _buildUpgradeCard(),
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
    final filters = ['All', 'Paid', 'Draft', 'Unpaid'];
    return Row(
      children:
          filters.map((status) {
            final isSelected = controller.selectedStatus.value == status;
            return GestureDetector(
              onTap: () => controller.setFilter(status),
              child: InvoiceFilterButton(text: status, selected: isSelected),
            );
          }).toList(),
    );
  }

  Widget _buildUpgradeCard() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "0 Invoices left!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: "Consider upgrading to our ",
                      children: [
                        TextSpan(
                          text: "premium",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " plans"),
                      ],
                    ),
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
    final total = invoice['total']?.toStringAsFixed(2) ?? '0.00';

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
          trailing: const Icon(Icons.chevron_right),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
