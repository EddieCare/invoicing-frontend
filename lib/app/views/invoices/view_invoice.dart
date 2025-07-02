import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/invoice/invoice_detail_controller.dart';
import '../../routes/app_routes.dart';
import '../../utils/barcode_generator.dart';

// import '../../../components/top_bar.dart';
// import '../../../values/values.dart';
// import '../../controllers/invoice/invoice_controller.dart';
// import '../../routes/app_routes.dart';
// import '../../utils/barcode_generator.dart';

// class InvoiceDetailsScreen extends StatelessWidget {
//   InvoiceDetailsScreen({super.key});
//   final InvoiceController controller = Get.put(InvoiceController());

//   @override
//   Widget build(BuildContext context) {
//     final isMobile = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: AppColor.pageColor,
//       appBar: TopBar(
//         title: "Invoice Details",
//         showBackButton: true,
//         showAddInvoice: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _invoiceHeaderCard(),
//             const SizedBox(height: 20),
//             _serviceListCard(),
//             const SizedBox(height: 32),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _actionButton(
//                   "View Receipt",
//                   onTap: () => Get.toNamed(Routes.invoicePreviewScreen),
//                 ),
//                 _actionButton(
//                   "Contact Client",
//                   onTap: () => Get.toNamed(Routes.invoicePreviewScreen),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _invoiceHeaderCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _infoColumn("Invoice no", "INV-20240304-001"),
//                     const SizedBox(height: 20),
//                     _infoColumn("Bill to", "John Snow"),
//                     const SizedBox(height: 12),
//                     _infoColumn("Issued on", "August 24, 2024"),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 40),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     generateBarcodeWidget(
//                       // "INV-20240304-001",
//                       "SUDHA IS AWESOME, I. Badde ac3idnm",
//                       width: 150,
//                       height: 50,
//                     ),
//                     const SizedBox(height: 20),
//                     _infoColumn("Descriptions", "Design service"),
//                     const SizedBox(height: 12),
//                     _infoColumn("Due Date", "August 28, 2024"),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const Divider(color: Colors.white24, height: 32),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Total Amount", style: TextStyle(color: Colors.white)),
//               Text(
//                 "\$24,000",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 28,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _serviceListCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Service",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 16),
//           _serviceItem("10 screen Website Design", "QYT X 1 \$200", "\$2000"),
//           _serviceItem(
//             "20 screen Mobile App Design",
//             "QYT X 1 \$100",
//             "\$2000",
//           ),
//           _serviceItem("Mobile Development", "QYT X 1 \$6000", "\$2000"),
//           _serviceItem("Website Development", "QYT X 1 \$6000", "\$2000"),
//         ],
//       ),
//     );
//   }

//   Widget _serviceItem(String title, String subtitle, String price) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 4),
//               Text(subtitle, style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//           Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _infoColumn(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: Colors.white70)),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _headerRow(String label, String value, {bool showBarcode = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: TextStyle(color: Colors.white70)),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         if (showBarcode)
//           generateBarcodeWidget(
//             // "INV-20240304-001",
//             "SUDHA IS AWESOME, I. Badde ac3idnm",
//             width: 150,
//             height: 50,
//           ),
//       ],
//     );
//   }

//   Widget _actionButton(String title, {VoidCallback? onTap}) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.black,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           onPressed: onTap,
//           child: Text(title, style: TextStyle(color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }

class InvoiceDetailsScreen extends StatelessWidget {
  InvoiceDetailsScreen({super.key});
  final controller = Get.put(InvoiceDetailsController());

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoice Details",
        showBackButton: true,
        showAddInvoice: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<InvoiceDetailsController>(
          builder:
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _invoiceHeaderCard(),
                  const SizedBox(height: 20),
                  _serviceListCard(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                        "View Receipt",
                        onTap:
                            () => Get.toNamed(
                              Routes.invoicePreviewScreen,
                              arguments: controller.invoice,
                            ),
                      ),
                      _actionButton(
                        "Contact Client",
                        onTap:
                            () => Get.toNamed(
                              Routes.invoicePreviewScreen,
                              arguments: controller.invoice,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }

  Widget _invoiceHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoColumn("Invoice no", controller.invoiceNumber),
                    const SizedBox(height: 20),
                    _infoColumn("Bill to", controller.clientName),
                    const SizedBox(height: 12),
                    _infoColumn("Issued on", controller.issueDate),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // RIGHT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    generateBarcodeWidget(
                      controller.invoiceNumber,
                      width: 150,
                      height: 50,
                    ),
                    const SizedBox(height: 20),
                    _infoColumn("Descriptions", controller.description),
                    const SizedBox(height: 12),
                    _infoColumn("Due Date", controller.dueDate),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount", style: TextStyle(color: Colors.white)),
              Text(
                "\$${controller.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _serviceListCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Service",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          for (var item in controller.services)
            _serviceItem(
              item['name'] ?? 'Unnamed',
              "QYT X ${item['quantity']} \$${(item['price'] as double).toStringAsFixed(2)}",
              "\$${(item['total'] as double).toStringAsFixed(2)}",
            ),
        ],
      ),
    );
  }

  Widget _serviceItem(String title, String subtitle, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String title, {VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
