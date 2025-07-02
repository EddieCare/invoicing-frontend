import 'package:cloud_firestore/cloud_firestore.dart';
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
                  _actionButton(
                    "Save",
                    black: true,
                    onTap: () => controller.createInvoice(),
                  ),
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
                  controller.updateDiscountRate(value),
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
              Text(
                controller.subTotal.value.toStringAsFixed(2),
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Discount (${controller.discountRate.value}%)",
                style: TextStyle(color: Colors.green),
              ),
              Text(
                controller.discountAmt.value.toStringAsFixed(2),
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tax (${controller.TAX_RATE}%)",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                controller.tax.value.toStringAsFixed(2),
                style: TextStyle(color: Colors.red),
              ),
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
                controller.totalAmt.value.toStringAsFixed(2),
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
    return Obx(() {
      final client = controller.selectedClient.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CLIENT", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => showClientPopup(controller),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      client != null
                          ? (client['name']
                                  ?.toString()
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              'C')
                          : '?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (client != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client['name'] ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(client['email'] ?? ''),
                          if (client['phone'] != null)
                            Text(
                              client['phone'],
                              style: TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    )
                  else
                    Expanded(child: Text("Tap to select or add a client")),
                  Transform.rotate(
                    angle: -100,
                    child: Icon(Icons.arrow_circle_up_rounded, size: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _addButton(
            "Add Client",
            black: false,
            onTap: () => showClientPopup(controller),
          ),
        ],
      );
    });
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

    // Pre-fill with selected product quantities
    for (var p in controller.selectedProducts) {
      final id = p['id'] ?? p['name'];
      tempQuantities[id] = p['quantity'] ?? 1;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      mainAxisSize: MainAxisSize.min,
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

    // Pre-fill with selected service quantities
    for (var s in controller.selectedServices) {
      final id = s['id'] ?? s['name'];
      tempQuantities[id] = s['quantity'] ?? s['hours'] ?? 1;
    }

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            children:
                controller.allServices.map((service) {
                  final serviceId = service['id'] ?? service['name'];
                  final qty = tempQuantities[serviceId] ?? 0;

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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed:
                              qty > 0
                                  ? () {
                                    tempQuantities[serviceId] = qty - 1;
                                    tempQuantities.refresh();
                                  }
                                  : null,
                        ),
                        Text('$qty'),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            tempQuantities[serviceId] = qty + 1;
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
                                      'quantity': qty,
                                    });
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

  void showClientPopup(InvoiceController controller) {
    final searchController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    Get.bottomSheet(
      SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Add/Search Client",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Search field
              TextField(
                controller: searchController,
                onChanged:
                    (value) => controller.setClientBySearch(value.trim()),
                decoration: InputDecoration(
                  hintText: "Search by name, email or phone",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 8),
              // Dropdown list
              if (controller.searchResults.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children:
                        controller.searchResults.map((client) {
                          return ListTile(
                            title: Text(client['name'] ?? 'Unnamed'),
                            subtitle: Text(
                              "${client['email'] ?? ''} • ${client['phone'] ?? ''}",
                            ),
                            onTap: () {
                              controller.selectedClient.value = client;
                              nameController.text = client['name'] ?? '';
                              emailController.text = client['email'] ?? '';
                              phoneController.text = client['phone'] ?? '';
                              controller.searchResults.clear(); // Hide dropdown
                              searchController.clear();
                            },
                          );
                        }).toList(),
                  ),
                ),
              const SizedBox(height: 16),
              // Input fields
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _actionButton(
                "Add Client",
                black: true,
                onTap: () async {
                  final newClient = {
                    "name": nameController.text.trim(),
                    "email": emailController.text.trim(),
                    "phone": phoneController.text.trim(),
                    "created_at": FieldValue.serverTimestamp(),
                  };
                  await controller.addNewClient(newClient);
                  Get.back(); // Close the bottom sheet
                },
              ),
              const SizedBox(height: 16),

              // ElevatedButton(
              //   onPressed: () async {
              //     final newClient = {
              //       "name": nameController.text.trim(),
              //       "email": emailController.text.trim(),
              //       "phone": phoneController.text.trim(),
              //       "created_at": FieldValue.serverTimestamp(),
              //     };
              //     await controller.addNewClient(newClient);
              //     Get.back();
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //   ),
              //   child: Text("Add Client"),
              // ),
            ],
          );
        }),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
