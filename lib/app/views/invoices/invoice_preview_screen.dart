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
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoice Preview",
        showBackButton: true,
        showAddInvoice: false,
        actions: [
          PopupMenuButton<_InvoiceAction>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (action) async {
              switch (action) {
                case _InvoiceAction.send:
                  await controller.sendInvoiceToClient();
                  break;
                case _InvoiceAction.share:
                  await controller.sharePdf();
                  break;
                case _InvoiceAction.save:
                  await controller.downloadPdf();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: _InvoiceAction.send,
                    child: _menuItem(Icons.send_outlined, 'Send'),
                  ),
                  PopupMenuItem(
                    value: _InvoiceAction.share,
                    child: _menuItem(Icons.ios_share, 'Share'),
                  ),
                  PopupMenuItem(
                    value: _InvoiceAction.save,
                    child: _menuItem(Icons.download_outlined, 'Save'),
                  ),
                ],
          ),
        ],
      ),
      body: GetBuilder<InvoicePreviewController>(
        builder: (ctrl) {
          final isMobile = MediaQuery.of(context).size.width < 600;
          final invoice = ctrl.invoice;

          return Padding(
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
                    BoxShadow(
                      color: Colors.black12.withAlpha(10),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      if (ctrl.isHydrating) ...[
                        const LinearProgressIndicator(minHeight: 3),
                        const SizedBox(height: 16),
                      ],
                      _header(invoice),
                      const SizedBox(height: 24),
                      _invoiceDetails(invoice, ctrl),
                      const Divider(height: 40),
                      _itemsTable(invoice),
                      const Divider(height: 40),
                      _summary(invoice),
                      const SizedBox(height: 24),
                      _customerDetails(invoice),
                      const SizedBox(height: 60),
                      const Divider(
                        height: 40,
                        color: Color.fromARGB(15, 0, 0, 0),
                      ),
                      _disclaimer(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(Map<String, dynamic> inv) {
    final shopLogoUrl =
        (inv['shopLogo'] ?? inv['shop_image_link'] ?? '').toString().trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 16),
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
              Text(
                _stringOrDash(inv['shop_name']),
                style: const TextStyle(fontSize: 16),
              ),
              Text(_formatAddress(inv['shop_address'])),
              Text(_stringOrDash(inv['shop_email'])),
              Text(_stringOrDash(inv['shop_phone'])),
            ],
          ),
        ),
        SizedBox(width: 12),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:
                shopLogoUrl.isNotEmpty
                    ? Image.network(
                      shopLogoUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.storefront_outlined, size: 36),
                    )
                    : const Icon(Icons.storefront_outlined, size: 36),
          ),
        ),
      ],
    );
  }

  Widget _invoiceDetails(
    Map<String, dynamic> inv,
    InvoicePreviewController ctrl,
  ) {
    final paymentMethod = _resolvePaymentMethod(inv);
    final transactionId = _resolveTransactionId(inv);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Invoice Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Payment Method", value: paymentMethod),
        _DetailRow(label: "Transaction ID", value: transactionId),
        _DetailRow(
          label: "Issue Date & Time",
          value: ctrl.formatDateFromTimestamp(inv['issue_date']),
        ),
        _DetailRow(
          label: "Due Date & Time",
          value: ctrl.formatDateFromTimestamp(inv['due_date']),
        ),
      ],
    );
  }

  Widget _itemsTable(Map<String, dynamic> inv) {
    final products = (inv['products'] ?? []) as List<dynamic>;
    final services = (inv['services'] ?? []) as List<dynamic>;

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
        for (final raw in products)
          if (raw is Map<String, dynamic>)
            _tableRow(
              _stringOrDash(raw['quantity'], fallback: '0'),
              _stringOrDash(raw['name']),
              _formatCurrency(raw['total']),
            ),
        for (final raw in services)
          if (raw is Map<String, dynamic>)
            _tableRow(
              _stringOrDash(raw['quantity'], fallback: '0'),
              _stringOrDash(raw['name']),
              _formatCurrency(raw['total']),
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

  Widget _summary(Map<String, dynamic> inv) {
    final subtotal = (inv['subtotal'] ?? 0.0) as num;
    final discount = (inv['discount'] ?? 0.0) as num;
    final tax = (inv['tax'] ?? 0.0) as num;
    final total = (inv['total'] ?? 0.0) as num;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _SummaryRow(label: "Subtotal", value: _formatCurrency(subtotal)),
        if (discount > 0)
          _SummaryRow(
            label: "Discount",
            value: "-${_formatCurrency(discount)}",
            valueColor: Colors.green,
          ),
        if (tax > 0)
          _SummaryRow(
            label: "Tax",
            value: _formatCurrency(tax),
            valueColor: Colors.orange,
          ),
        Divider(),
        _SummaryRow(
          label: "Total",
          value: _formatCurrency(total),
          isBold: true,
        ),
      ],
    );
  }

  Widget _customerDetails(Map<String, dynamic> inv) {
    final client = (inv['client'] ?? {}) as Map<dynamic, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Info",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        SizedBox(height: 12),
        _DetailRow(label: "Name", value: _stringOrDash(client['name'])),
        _DetailRow(label: "Address", value: _stringOrDash(client['address'])),
        _DetailRow(label: "Email", value: _stringOrDash(client['email'])),
        _DetailRow(label: "Phone", value: _stringOrDash(client['phone'])),
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

  Widget _menuItem(IconData icon, String label) {
    return Row(
      children: [Icon(icon, size: 20), const SizedBox(width: 12), Text(label)],
    );
  }

  String _stringOrDash(dynamic value, {String fallback = '-'}) {
    if (value == null) return fallback;
    final str = value.toString().trim();
    return str.isEmpty ? fallback : str;
  }

  String _formatAddress(dynamic value) {
    if (value is String) return _stringOrDash(value);
    if (value is Map) {
      final parts =
          [
                value['street'],
                value['city'],
                value['state'],
                value['zip'],
                value['country'],
              ]
              .map((e) => (e ?? '').toString().trim())
              .where((element) => element.isNotEmpty)
              .toList();
      return parts.isEmpty ? '-' : parts.join(', ');
    }
    return '-';
  }

  String _formatCurrency(dynamic raw) {
    if (raw == null) return '\$0.00';
    final value =
        raw is num ? raw.toDouble() : double.tryParse(raw.toString()) ?? 0.0;
    return '\$${value.toStringAsFixed(2)}';
  }

  String _resolvePaymentMethod(Map<String, dynamic> inv) {
    final candidates = [
      inv['payment_method'],
      inv['paymentMethod'],
      _mapValue(inv['payment'], 'method'),
      _mapValue(inv['payment_details'], 'method'),
      _mapValue(inv['paymentDetails'], 'method'),
    ];

    for (final candidate in candidates) {
      final resolved = _stringOrDash(candidate);
      if (resolved != '-') return resolved;
    }
    return '-';
  }

  String _resolveTransactionId(Map<String, dynamic> inv) {
    final candidates = [
      inv['transaction_id'],
      inv['transactionId'],
      inv['transaction_reference'],
      _mapValue(inv['payment'], 'transactionId'),
      _mapValue(inv['payment'], 'transaction_id'),
      _mapValue(inv['payment'], 'reference'),
      _mapValue(inv['payment_details'], 'transactionId'),
      _mapValue(inv['payment_details'], 'transaction_id'),
      _mapValue(inv['payment_details'], 'reference'),
      _mapValue(inv['paymentDetails'], 'transactionId'),
      _mapValue(inv['paymentDetails'], 'transaction_id'),
      _mapValue(inv['paymentDetails'], 'reference'),
    ];

    for (final candidate in candidates) {
      final resolved = _stringOrDash(candidate);
      if (resolved != '-') return resolved;
    }
    return '-';
  }

  dynamic _mapValue(dynamic source, String key) {
    if (source is Map) {
      return source[key];
    }
    return null;
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

enum _InvoiceAction { send, share, save }
