import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    // Implement actual sending logic here (email, API call, etc.)
    print("Invoice sent to: ${invoice['client']?['email']}");
  }

  Future<void> downloadPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (context) => pw.Center(
              child: pw.Text('Invoice: ${invoice['invoice_number'] ?? 'N/A'}'),
            ),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
