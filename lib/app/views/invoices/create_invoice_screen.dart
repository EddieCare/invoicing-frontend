import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/dashed_rect.dart';
import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_controller.dart';

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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInvoiceDetails(context),
              const SizedBox(height: 20),
              _buildSectionTitle("SERVICE"),
              if (controller.selectedServices.length == 0)
                emptyBox("Add services to the list"),
              ...controller.selectedServices.map((service) {
                return _buildServiceItem(
                  service['name'],
                  "QYT X ${service['quantity'] ?? 1} ₹${service['price']}",
                  "₹${(service['price'] * (service['quantity'] ?? 1))}",
                  highlighted: true,
                  () => {controller.removeService(service)},
                );
              }).toList(),
              _addButton(
                "Add Service",
                black: true,
                onTap: () => _showServicePopup(Get.find<InvoiceController>()),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("PRODUCT"),
              if (controller.selectedProducts.length == 0)
                emptyBox("Add products to the list"),
              ...controller.selectedProducts.map((product) {
                return _buildProductItem(
                  product['name'],
                  "QYT X ${product['quantity'] ?? 1} ₹${product['price']}",
                  "₹${(product['price'] * (product['quantity'] ?? 1))}",
                  () => {controller.removeProduct(product)},
                );
              }).toList(),
              _addButton(
                "Add Product",
                black: false,
                onTap: () => _showProductPopup(Get.find<InvoiceController>()),
              ),
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
      ),
    );
  }

  CustomPaint emptyBox(text) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: AppColor.textColorPrimary.withAlpha(50),
        strokeWidth: 3.0,
        dashWidth: 12.0,
        dashSpace: 8.0,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ), // Rounded corners
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            text,
            style: TextStyle(color: AppColor.textColorPrimary.withAlpha(100)),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails(context) {
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
              _dateColumn("Issue Date", controller.issueDate.value, () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.issueDate.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) controller.setIssueDate(picked);
              }),
              _dateColumn("Due Date", controller.dueDate.value, () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.dueDate.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) controller.setDueDate(picked);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateColumn(String title, DateTime date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                DateFormat('yMMMd').format(date),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.calendar_today, size: 18),
            ],
          ),
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
    String price,
    removeItem, {
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
          Row(
            children: [
              Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: removeItem,
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    String title,
    String subtitle,
    String price,
    removeItem,
  ) {
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
          Row(
            children: [
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: removeItem,
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addButton(String label, {bool black = true, onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton.icon(
            onPressed: onTap,
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

  void _showProductPopup(InvoiceController controller) {
    final RxMap<String, int> tempQuantities = <String, int>{}.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            children:
                controller.allProducts.map((product) {
                  final productId = product['id'] ?? product['name'];
                  final qty = tempQuantities[productId] ?? 0;

                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("₹${product['price']}"),
                        const SizedBox(height: 8),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // This is the key fix
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed:
                              qty > 0
                                  ? () {
                                    tempQuantities[productId] = qty - 1;
                                    tempQuantities.refresh();
                                  }
                                  : null,
                        ),
                        Text('$qty'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            tempQuantities[productId] = qty + 1;
                            tempQuantities.refresh();
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.black,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed:
                              qty > 0
                                  ? () {
                                    controller.addProduct({
                                      ...product,
                                      'quantity': qty,
                                    });
                                    // Get.back();
                                  }
                                  : null,
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void _showServicePopup(InvoiceController controller) {
    final RxMap<String, int> tempQuantities = <String, int>{}.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            children:
                controller.allServices.map((service) {
                  final productId = service['id'] ?? service['name'];
                  final qty = tempQuantities[productId] ?? 0;

                  return ListTile(
                    title: Text(service['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("₹${service['price']}"),
                        const SizedBox(height: 8),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // This is the key fix
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed:
                              qty > 0
                                  ? () {
                                    tempQuantities[productId] = qty - 1;
                                    tempQuantities.refresh();
                                  }
                                  : null,
                        ),
                        Text('$qty'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            tempQuantities[productId] = qty + 1;
                            tempQuantities.refresh();
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.black,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed:
                              qty > 0
                                  ? () {
                                    controller.addService({
                                      ...service,
                                      'hours': qty,
                                    });
                                    // Get.back();
                                  }
                                  : null,
                          child: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
