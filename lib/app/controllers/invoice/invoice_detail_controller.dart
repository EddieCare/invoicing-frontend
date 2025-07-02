import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceDetailsController extends GetxController {
  late Map<String, dynamic> invoice;

  @override
  void onInit() {
    super.onInit();
    invoice = Get.arguments;
    print('InvoiceDetailsController initialized ${invoice}');
  }

  String get invoiceNumber => invoice['invoice_number'] ?? 'N/A';
  String get clientName => invoice['client']?['name'] ?? 'N/A';
  String get issueDate => _formatDate(invoice['issue_date']);
  String get dueDate => _formatDate(invoice['due_date']);
  String get description => invoice['service_type'] ?? 'N/A';
  double get totalAmount => invoice['total'] ?? 0.0;

  List<Map<String, dynamic>> get services =>
      List<Map<String, dynamic>>.from(invoice['items'] ?? []);

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    final date = (timestamp as Timestamp).toDate();
    return DateFormat('MMMM d, yyyy').format(date);
  }
}
