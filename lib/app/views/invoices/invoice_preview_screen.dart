import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_preview_controller.dart';

class InvoicePreviewScreen extends StatelessWidget {
  InvoicePreviewScreen({super.key});

  final controller = Get.put(InvoicePreviewController());

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
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Container(
            width: isMobile ? double.infinity : 700,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.black12, width: 1),
              boxShadow: [
                BoxShadow(color: Colors.black12.withAlpha(10), blurRadius: 30),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _header(),
                  const SizedBox(height: 24),
                  _invoiceDetails(),
                  const Divider(height: 40),
                  _itemsTable(),
                  const Divider(height: 40),
                  _summary(),
                  const SizedBox(height: 24),
                  _customerDetails(),
                  const SizedBox(height: 60),
                  const Divider(height: 40, color: Color.fromARGB(15, 0, 0, 0)),
                  _disclaimer(),
                  const SizedBox(height: 24),
                  _actionButtons(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final inv = controller.invoice;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Make the id more prominent
              const Text(
                "Invoice ID",
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Text(
                "${inv['invoice_number'] ?? '-'}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),
              Text(inv['shop_name'] ?? "-", style: TextStyle(fontSize: 16)),
              Text(inv['shop_address'] ?? "-"),
              Text(inv['shop_email'] ?? "-"),
              Text(inv['shop_phone'] ?? "-"),
            ],
          ),
        ),
        SizedBox(width: 12),
        Container(
          // margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: const Color.fromARGB(14, 0, 0, 0),
          ),
          child: Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _invoiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Service Type", value: "Blue Collar"),
        _DetailRow(label: "Payment Method", value: "Cash"),
        _DetailRow(label: "Transaction ID", value: "-"),
        _DetailRow(
          label: "Issue Date & Time",
          // Date is a timestamp, format it to a readable string
          value: controller.formatDateFromTimestamp(
            controller.invoice['issue_date'] ?? "",
          ),
        ),
        _DetailRow(
          label: "Due Date & Time",
          value: controller.formatDateFromTimestamp(
            controller.invoice['due_date'] ?? "",
          ),
        ),
      ],
    );
  }

  Widget _itemsTable() {
    final products = controller.invoice['products'] ?? [];
    final services = controller.invoice['services'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Items",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 16),
        _tableHeader(),
        SizedBox(height: 8),
        for (var p in products)
          _tableRow(
            p['quantity'].toString(),
            p['name'],
            '\$${p['total'].toStringAsFixed(2)}',
          ),
        for (var s in services)
          _tableRow(
            s['quantity'].toString(),
            s['name'],
            '\$${s['total'].toStringAsFixed(2)}',
          ),
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
    final subtotal = controller.invoice['subtotal'] ?? 0.0;
    final discount = controller.invoice['discount'] ?? 0.0;
    final tax = controller.invoice['tax'] ?? 0.0;
    final total = controller.invoice['total'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SummaryRow(
          label: "Subtotal",
          value: "\$${subtotal.toStringAsFixed(2)}",
        ),
        if (discount > 0)
          _SummaryRow(
            label: "Discount",
            value: "-\$${discount.toStringAsFixed(2)}",
            valueColor: Colors.green,
          ),
        if (tax > 0)
          _SummaryRow(
            label: "Tax",
            value: "\$${tax.toStringAsFixed(2)}",
            valueColor: Colors.orange,
          ),
        Divider(),
        _SummaryRow(
          label: "Total",
          value: "\$${total.toStringAsFixed(2)}",
          isBold: true,
        ),
      ],
    );
  }

  Widget _customerDetails() {
    final client = controller.invoice['client'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Info",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Name", value: client['name'] ?? '-'),
        _DetailRow(label: "Address", value: client['address'] ?? '-'),
        _DetailRow(label: "Email", value: client['email'] ?? '-'),
        _DetailRow(label: "Phone", value: client['phone'] ?? '-'),
      ],
    );
  }

  Widget _disclaimer() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Disclaimer",
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 12),
          Text(
            "• All payments are due upon receipt unless otherwise agreed.\n"
            "• Late payments may incur additional charges or interest.\n"
            "• This invoice is valid for 30 days from the date of issue.\n"
            "• Goods/services listed are provided as described.\n"
            "• All prices are in the stated currency unless specified otherwise.\n"
            "• Disputes must be reported within 7 days of receipt.\n"
            "• Taxes, if applicable, are included or stated separately.\n"
            "• This invoice is computer generated and does not require a signature.\n"
            "• Any applicable warranties are subject to terms.\n"
            "• Returns or refunds are subject to company policy.\n"
            "• Overdue invoices may be sent to collections.\n"
            "• Bank charges, if any, are to be borne by the payer.\n"
            "• Please ensure the invoice number is referenced in all payments.\n"
            "• All services/products are subject to availability.\n"
            "• The client is responsible for providing accurate billing details.\n"
            "• Payment methods accepted are listed on the invoice.\n"
            "• The company reserves the right to modify invoice terms.\n"
            "• Delivery timelines are estimates unless guaranteed.\n"
            "• Any modifications to the invoice must be approved in writing.\n"
            "• Visit invoicedaily.com/terms for full details.",
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _button(
          context,
          "Download PDF",
          Icons.print,
          Colors.blue,
          onPressed: () async {
            await controller.downloadPdf();
          },
        ),
        _button(
          context,
          "Send",
          Icons.send,
          Colors.green,
          onPressed: () async {
            await controller.sendInvoiceToClient();
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
