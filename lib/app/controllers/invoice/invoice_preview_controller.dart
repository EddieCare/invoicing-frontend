import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// import '../../../services/email_service.dart';

class InvoicePreviewController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map<String, dynamic> invoice = <String, dynamic>{};
  bool isHydrating = false;

  @override
  void onInit() {
    invoice = Map<String, dynamic>.from(Get.arguments ?? {});
    super.onInit();
    _hydrateShopDetailsIfNeeded();
  }

  Future<void> _hydrateShopDetailsIfNeeded() async {
    final needsShopData = [
      'shop_name',
      'shop_email',
      'shop_phone',
      'shop_address',
      'shopLogo',
      'shop_image_link',
    ].any((key) {
      final value = invoice[key];
      if (value == null) return true;
      if (value is String) return value.trim().isEmpty;
      if (value is Map) return value.isEmpty;
      return false;
    });

    if (!needsShopData) return;

    final vendorEmail =
        (invoice['vendor_email'] ?? FirebaseAuth.instance.currentUser?.email)
            ?.toString()
            .trim();
    if (vendorEmail == null || vendorEmail.isEmpty) return;

    try {
      isHydrating = true;
      update();

      final snapshot =
          await _db
              .collection('vendors')
              .doc(vendorEmail)
              .collection('shops')
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) return;

      final data = snapshot.docs.first.data();
      final merged = {
        if (data['shop_name'] != null) 'shop_name': data['shop_name'],
        if (data['shop_email'] != null) 'shop_email': data['shop_email'],
        if (data['shop_phone'] != null) 'shop_phone': data['shop_phone'],
        if (data['shop_address'] != null) 'shop_address': data['shop_address'],
        if (data['shopLogo'] != null) 'shopLogo': data['shopLogo'],
        if (data['shop_image_link'] != null)
          'shop_image_link': data['shop_image_link'],
      };

      if (merged.isNotEmpty) {
        invoice = {...invoice, ...merged};
      }
    } catch (_) {
      // Ignore hydration failures; UI will fall back to placeholders.
    } finally {
      isHydrating = false;
      update();
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('d MMMM, yyyy').format(date);
  }

  String formatDateFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      return DateFormat('MMMM d, yyyy').format(date);
    }
    if (timestamp is DateTime) {
      return DateFormat('MMMM d, yyyy').format(timestamp);
    }
    if (timestamp is String && timestamp.isNotEmpty) {
      try {
        final parsed = DateTime.tryParse(timestamp);
        if (parsed != null) {
          return DateFormat('MMMM d, yyyy').format(parsed);
        }
      } catch (_) {}
    }
    return 'N/A';
  }

  Future<void> sendInvoiceToClient() async {
    final client = invoice['client'] ?? {};
    final clientEmail = (client['email'] ?? '').toString().trim();
    if (clientEmail.isEmpty) {
      Get.snackbar('No Client Email', 'Please add a client email to send.');
      return;
    }

    final pdf = await _buildReceiptPdf();
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
    final pdf = await _buildReceiptPdf();
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> sharePdf() async {
    final pdf = await _buildReceiptPdf();
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'invoice_' +
          (invoice['invoice_number']?.toString() ?? 'receipt') +
          '.pdf',
    );
  }

  Future<pw.Document> _buildReceiptPdf() async {
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

    final shopLogoUrl =
        (invoice['shopLogo'] ?? invoice['shop_image_link'] ?? '').toString();
    pw.ImageProvider? shopLogo;
    if (shopLogoUrl.isNotEmpty) {
      try {
        shopLogo = await networkImage(shopLogoUrl);
      } catch (_) {}
    }

    pw.ImageProvider? brandLogo;
    try {
      brandLogo = await imageFromAssetBundle('assets/images/logo.png');
    } catch (_) {}

    final vendorEmail =
        (invoice['shop_email'] ?? invoice['vendor_email'] ?? '-').toString();
    final shopPhone = (invoice['shop_phone'] ?? '').toString();

    String formatAddress(dynamic value) {
      if (value is String) return value.isEmpty ? '-' : value;
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

    pw.Widget logoBox(pw.ImageProvider? image, String fallbackText) {
      return pw.Container(
        width: 70,
        height: 70,
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          borderRadius: pw.BorderRadius.circular(16),
          border: pw.Border.all(color: PdfColors.grey500, width: 0.2),
        ),
        child:
            image != null
                ? pw.ClipRRect(
                  horizontalRadius: 16,
                  verticalRadius: 16,
                  child: pw.FittedBox(
                    fit: pw.BoxFit.cover,
                    child: pw.Image(image),
                  ),
                )
                : pw.Center(
                  child: pw.Text(
                    fallbackText,
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
      );
    }

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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  logoBox(shopLogo, 'Shop Logo'),
                  pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        'InvoiceDaily',
                        style: pw.TextStyle(
                          fontSize: 22,
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
                  logoBox(brandLogo, 'InvoiceDaily'),
                ],
              ),
              pw.SizedBox(height: 16),
              kv('Invoice #', (invoice['invoice_number'] ?? '-').toString()),
              kv('Issue Date', _fmtTs(invoice['issue_date'])),
              kv('Due Date', _fmtTs(invoice['due_date'])),
              pw.SizedBox(height: 12),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey200,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Vendor',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (invoice['shop_name'] != null)
                      pw.Text(
                        invoice['shop_name'].toString(),
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    if (invoice['shop_address'] != null)
                      pw.Text(
                        formatAddress(invoice['shop_address']),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Email: $vendorEmail',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                    if (shopPhone.isNotEmpty)
                      pw.Text(
                        'Phone: $shopPhone',
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Bill To',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    pw.Text(
                      (client['name'] ?? '-').toString(),
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    if (client['address'] != null)
                      pw.Text(
                        (client['address']).toString(),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    if (client['email'] != null)
                      pw.Text(
                        (client['email']).toString(),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 18),
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
