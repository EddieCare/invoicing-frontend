import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/app/controllers/invoice/invoice_list_controller.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_detail_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/barcode_generator.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  InvoiceDetailsScreen({super.key});
  final controller = Get.put(InvoiceDetailsController());

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoice Details",
        showBackButton: true,
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<InvoiceDetailsController>(
          builder:
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _invoiceHeaderCard(),
                  const SizedBox(height: 20),
                  if (controller.services.isNotEmpty)
                    _itemListCard("Services", controller.services),
                  const SizedBox(height: 20),
                  if (controller.products.isNotEmpty)
                    _itemListCard("Products", controller.products),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                        "View Receipt",
                        onTap:
                            () => Get.toNamed(
                              Routes.invoicePreviewScreen,
                              arguments: controller.invoice,
                            ),
                      ),
                      _actionButton(
                        controller.invoice["status"] == "PENDING"
                            ? "Mark as Paid"
                            : "Mark as Pending",
                        onTap:
                            () => Get.find<InvoiceListController>()
                                .updateInvoiceStatus(
                                  controller.invoice["id"],
                                  controller.invoice["status"] == "PENDING"
                                      ? "PAID"
                                      : "PENDING",
                                ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _invoiceHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoColumn("Invoice no", controller.invoiceNumber),
                    const SizedBox(height: 20),
                    _infoColumn("Bill to", controller.clientName),
                    const SizedBox(height: 12),
                    _infoColumn("Issued on", controller.issueDate),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // RIGHT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    generateBarcodeWidget(
                      controller.invoiceNumber,
                      width: 150,
                      height: 50,
                    ),
                    const SizedBox(height: 20),
                    _infoColumn("Descriptions", controller.description),
                    const SizedBox(height: 12),
                    _infoColumn("Due Date", controller.dueDate),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(color: Colors.white)),
              Text(
                "\$${controller.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemListCard(title, items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          for (var item in items)
            _item(
              item['name'] ?? 'Unnamed',
              "QYT X ${item['quantity']} \$${(item['price'] as double).toStringAsFixed(2)}",
              "\$${(item['total'] as double).toStringAsFixed(2)}",
            ),
        ],
      ),
    );
  }

  Widget _item(String title, String subtitle, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String title, {VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
