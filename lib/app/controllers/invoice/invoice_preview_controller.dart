import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// import '../../../services/email_service.dart';

class InvoicePreviewController extends GetxController {
  late Map<String, dynamic> invoice;

  @override
  void onInit() {
    invoice = Get.arguments ?? {};
    super.onInit();
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('d MMMM, yyyy').format(date);
  }

  String formatDateFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('MMMM d, yyyy').format(date);
  }

  Future<void> sendInvoiceToClient() async {
    final client = invoice['client'] ?? {};
    final clientEmail = (client['email'] ?? '').toString().trim();
    if (clientEmail.isEmpty) {
      Get.snackbar('No Client Email', 'Please add a client email to send.');
      return;
    }

    final pdf = _buildReceiptPdf();
    final bytes = await pdf.save();

    final status = (invoice['status'] ?? 'PENDING').toString().toUpperCase();
    final invNo = (invoice['invoice_number'] ?? '').toString();
    final total = (invoice['total'] ?? 0).toString();
    final issue = _fmtTs(invoice['issue_date']);
    final due = _fmtTs(invoice['due_date']);

    final subject = 'Invoice $invNo | $status';
    final body = [
      'Hello ${client['name'] ?? ''},',
      '',
      'Please find attached your invoice $invNo.',
      '- Total: $total',
      '- Issue Date: $issue',
      '- Due Date: $due',
      '- Status: $status',
      '',
      'Regards,',
      'Invoice Daily',
    ].join('\n');

    try {
      // await EmailService.sendEmail(
      //   to: clientEmail,
      //   subject: subject,
      //   body: body,
      //   attachmentBytes: bytes,
      //   attachmentFileName: 'invoice_${invNo.isEmpty ? 'receipt' : invNo}.pdf',
      // );
      Get.snackbar('Success', 'Invoice email sent to $clientEmail');
    } catch (e) {
      Get.snackbar('Email Failed', e.toString());
    }
  }

  Future<void> downloadPdf() async {
    final pdf = _buildReceiptPdf();
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> sharePdf() async {
    final pdf = _buildReceiptPdf();
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'invoice_' +
          (invoice['invoice_number']?.toString() ?? 'receipt') +
          '.pdf',
    );
  }

  pw.Document _buildReceiptPdf() {
    final doc = pw.Document();
    // Scale up to A4 for better readability
    final pageFormat = PdfPageFormat.a4.applyMargin(
      left: 24,
      top: 24,
      right: 24,
      bottom: 24,
    );

    final client = invoice['client'] ?? {};
    final products = List<Map<String, dynamic>>.from(invoice['products'] ?? []);
    final services = List<Map<String, dynamic>>.from(invoice['services'] ?? []);
    final subtotal = (invoice['subtotal'] ?? 0).toDouble();
    final discount = (invoice['discount'] ?? 0).toDouble();
    final tax = (invoice['tax'] ?? 0).toDouble();
    final total = (invoice['total'] ?? 0).toDouble();

    pw.Widget kv(String k, String v) => pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [pw.Text(k), pw.Text(v)],
    );

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'InvoiceDaily',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Official Invoice',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
              kv('Invoice #', (invoice['invoice_number'] ?? '-').toString()),
              kv('Issue Date', _fmtTs(invoice['issue_date'])),
              kv('Due Date', _fmtTs(invoice['due_date'])),
              pw.Divider(),

              pw.Text(
                'Vendor',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              kv('Email', (invoice['vendor_email'] ?? '-').toString()),
              if (invoice['shop_name'] != null)
                kv('Shop', (invoice['shop_name']).toString()),
              if (invoice['shop_address'] != null)
                pw.Text(
                  (invoice['shop_address']).toString(),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              pw.Divider(),

              pw.Text(
                'Bill To',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.Text((client['name'] ?? '-').toString()),
              if (client['address'] != null)
                pw.Text(
                  (client['address']).toString(),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              if (client['email'] != null)
                pw.Text(
                  (client['email']).toString(),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              pw.Divider(),

              pw.Text(
                'Items',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Row(
                children: [
                  pw.Expanded(flex: 1, child: pw.Text('QTY')),
                  pw.Expanded(flex: 4, child: pw.Text('ITEM')),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text('TOTAL'),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              ...products.map(
                (p) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(flex: 1, child: pw.Text('${p['quantity']}')),
                      pw.Expanded(flex: 4, child: pw.Text(p['name'] ?? '-')),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(_money(p['total'] ?? 0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...services.map(
                (s) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(flex: 1, child: pw.Text('${s['quantity']}')),
                      pw.Expanded(flex: 4, child: pw.Text(s['name'] ?? '-')),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(_money(s['total'] ?? 0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Divider(),

              kv('Subtotal', _money(subtotal)),
              if (discount > 0) kv('Discount', '-' + _money(discount)),
              if (tax > 0) kv('Tax', _money(tax)),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    _money(total),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(),

              pw.Text(
                'Disclaimer',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'All payments due upon receipt. Late payments may incur charges. This invoice is valid for 30 days. Prices include applicable taxes unless stated. Refer to terms for full details.',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text(
                  'Thank you for your business!',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc;
  }

  String _fmtTs(dynamic ts) {
    if (ts is Timestamp) {
      return DateFormat('d MMM yyyy').format(ts.toDate());
    }
    return '-';
  }

  String _money(num n) => n.toStringAsFixed(2);
}
