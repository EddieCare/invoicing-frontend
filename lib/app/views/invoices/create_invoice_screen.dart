import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicing_fe/app/controllers/invoice/invoice_controller.dart';
import 'package:invoicing_fe/values/values.dart';
import '../../../components/top_bar.dart';

class CreateInvoiceScreen extends StatelessWidget {
  CreateInvoiceScreen({super.key});
  final InvoiceController controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Create Invoice",
        showBackButton: true,
        actions: [SizedBox(width: 12)],
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInvoiceDetails(),
            const SizedBox(height: 20),
            _buildSectionTitle("SERVICE"),
            _buildServiceItem(
              "10 screen Website Design",
              "QYT X 1 \$200",
              "\$2000",
              highlighted: true,
            ),
            _buildServiceItem(
              "20 screen Mobile Design",
              "QYT X 1 \$200",
              "\$2000",
            ),
            _buildServiceItem("Mobile Development", "QYT X 1 \$6000", "\$2000"),
            _addButton("Add Service", black: true),
            const SizedBox(height: 24),
            _buildSectionTitle("PRODUCT"),
            _buildProductItem(
              "10 screen Website Design",
              "QYT X 1 \$200",
              "\$2000",
            ),
            _buildProductItem(
              "20 screen Mobile Design",
              "QYT X 1 \$200",
              "\$2000",
            ),
            _addButton("Add Product", black: false),
            const SizedBox(height: 24),
            _buildDiscountTaxSummary(),
            const SizedBox(height: 24),
            _buildClientCard(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton("Save", black: true),
                const SizedBox(width: 10),
                _actionButton("Discard", black: true),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "INVOICING DETAILS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text("Invoice Number", style: TextStyle(color: Colors.black54)),
          Text(
            "INV-20240304-001",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dateColumn("Issue Date *", "March 4, 2025"),
              _dateColumn("Due Date *", "March 4, 2025"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateColumn(String title, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.black54)),
        Row(
          children: [
            Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  Widget _buildServiceItem(
    String title,
    String subtitle,
    String price, {
    bool highlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlighted ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: highlighted ? Border.all(color: Colors.blue) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.black54)),
            ],
          ),
          Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProductItem(String title, String subtitle, String price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(subtitle, style: TextStyle(color: Colors.white70)),
            ],
          ),
          Text(
            price,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _addButton(String label, {bool black = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Transform.rotate(
              angle: -100,
              child: Icon(Icons.arrow_circle_up_rounded, size: 24),
            ),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              backgroundColor: black ? Colors.black : Colors.white,
              foregroundColor: black ? Colors.white : Colors.black,
              shape: StadiumBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountTaxSummary() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: controller.hasDiscount.value,
            onChanged: (_) {
              controller.updateDiscount();
            },
            contentPadding: EdgeInsets.only(left: 0),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.black,
            title: Text("Add Discount"),
          ),
          TextField(
            enabled: controller.hasDiscount.value,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged:
                (value) => {
                  print("value is this--> $value"),
                  controller.updateDiscountAmt(value),
                },

            decoration: InputDecoration(
              hintText: "Discount %",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(color: Colors.black54)),
              Text("\$244.94"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount (${controller.discountAmt.value}%)",
                style: TextStyle(color: Colors.green),
              ),
              Text("-\$12.25", style: TextStyle(color: Colors.green)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax (8%)", style: TextStyle(color: Colors.red)),
              Text("\$19.60", style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.black12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "\$356.29",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildClientCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("CLIENT", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text("J", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("johndoe@gmail.com"),
                ],
              ),
              Spacer(),
              Transform.rotate(
                angle: -100,
                child: Icon(Icons.arrow_circle_up_rounded, size: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _addButton("Add Client", black: false),
      ],
    );
  }

  Widget _actionButton(String text, {VoidCallback? onTap, bool black = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: black ? Colors.black : Colors.white,
        foregroundColor: black ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Reduced radius
        ),
      ),
      onPressed: onTap ?? () {},
      child: Text(text),
    );
  }
}
