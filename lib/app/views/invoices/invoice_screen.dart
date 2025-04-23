import 'package:flutter/material.dart';
import 'package:invoicing_fe/values/values.dart';

import '../../../components/top_bar.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoices",
        // leadingIcon: Icon(Icons, size: 30),
        showBackButton: false,
        actions: [
          GestureDetector(
            onTap: () => {SnackBar(content: Text("Coming Soon"))},
            child: Icon(Icons.search_outlined, size: 30),
          ),
          SizedBox(width: 12),
          Icon(Icons.menu, size: 30),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
