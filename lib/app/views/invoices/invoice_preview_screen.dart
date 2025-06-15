import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoice Preview",
        showBackButton: true,
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Container(
            width: isMobile ? double.infinity : 700,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black12.withAlpha(10), blurRadius: 30),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 24),
                _invoiceDetails(),
                const Divider(height: 40),
                _itemsTable(),
                const Divider(height: 40),
                _summary(),
                const SizedBox(height: 24),
                _customerDetails(),
                const Divider(height: 40),
                _disclaimer(),
                const SizedBox(height: 24),
                _actionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "INVOICE #INV-20240304-001",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text("Elite Tech Solutions", style: TextStyle(fontSize: 16)),
              Text("1234 Silicon Valley, CA, USA"),
              Text("contact@elitetech.com"),
              Text("+1 555-1234-567"),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black12,
          ),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _invoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Invoice Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Service Type", value: "Retail Product Sale"),
        _DetailRow(label: "Payment Method", value: "Credit Card (Visa)"),
        _DetailRow(label: "Transaction ID", value: "TXN-9876543210"),
        _DetailRow(
          label: "Issue Date & Time",
          value: "March 4, 2025 | 10:30 AM",
        ),
        _DetailRow(
          label: "Due Date & Time",
          value: "March 11, 2025 | 11:59 PM",
        ),
      ],
    );
  }

  Widget _itemsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 16),
        _tableHeader(),
        const SizedBox(height: 8),
        _tableRow("2", "Logitech MX Keys Wireless Keyboard", "\$90.00"),
        _tableRow("1", "Sony WH-1000XM5 Bluetooth Headphones", "\$120.00"),
        _tableRow("3", "Anker PowerLine+ USB-C Cable", "\$80.00"),
      ],
    );
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("QTY", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 4,
          child: Text("ITEM", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            "TOTAL",
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _tableRow(String qty, String item, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(qty)),
          Expanded(flex: 4, child: Text(item)),
          Expanded(flex: 2, child: Text(total, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _summary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _SummaryRow(label: "Subtotal", value: "\$244.94"),
        _SummaryRow(
          label: "Discount (15%)",
          value: "-\$12.25",
          valueColor: Colors.green,
        ),
        _SummaryRow(
          label: "Tax (8%)",
          value: "\$19.60",
          valueColor: Colors.orange,
        ),
        Divider(),
        _SummaryRow(label: "Total", value: "\$252.29", isBold: true),
      ],
    );
  }

  Widget _customerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Customer Info",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Name", value: "John Doe"),
        _DetailRow(label: "Address", value: "Flat 22/45, 34566 Baltimore, USA"),
        _DetailRow(label: "Email", value: "johndoe@yahoo.com"),
        _DetailRow(label: "Phone", value: "+1 545-1874-567"),
      ],
    );
  }

  Widget _disclaimer() {
    return const Text(
      "• 1-year warranty on electronics.\n"
      "• 30-day return/exchange window.\n"
      "• 5% late fee after due date.\n"
      "• Refunds take 7-10 business days.\n\n"
      "Visit elitetech.com/terms for full details.",
      style: TextStyle(fontSize: 14, height: 1.5),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _button(context, "Discard", Icons.close, Colors.red),
        _button(
          context,
          "Print",
          Icons.print,
          Colors.blue,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Printing...")));
          },
        ),
        _button(
          context,
          "Send",
          Icons.send,
          Colors.green,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Invoice sent!")));
          },
        ),
      ],
    );
  }

  Widget _button(
    BuildContext context,
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
