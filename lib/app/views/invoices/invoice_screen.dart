import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../routes/app_routes.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        title: "Invoices",
        // leadingIcon: Icon(Icons, size: 30),
        showBackButton: false,
        showMenu: true,
        showAddInvoice: false,
        actions: [
          GestureDetector(
            onTap: () => {SnackBar(content: Text("Coming Soon"))},
            child: Icon(Icons.search_outlined, size: 30),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              InvoiceFilterButton(text: "Paid", selected: true),
              InvoiceFilterButton(text: "Draft", selected: false),
              InvoiceFilterButton(text: "Unpaid", selected: false),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => const InvoiceCard(),
              padding: const EdgeInsets.only(bottom: 80),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Get.toNamed(Routes.createInvoice)},
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class InvoiceFilterButton extends StatelessWidget {
  final String text;
  final bool selected;

  const InvoiceFilterButton({
    super.key,
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: selected ? Colors.black : const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Get.toNamed(Routes.invoiceDetails)},
      child: Card(
        color: AppColor.pageColor,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.black12),
        ),
        elevation: 1,
        child: ListTile(
          tileColor: Colors.transparent,
          leading: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "\$",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: const Text(
            "INV-20240304-003",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 4),
              Text(
                "Date: 27 March, 2025",
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
              SizedBox(height: 2),
              Text("4,800 AUD", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 2),
              Text("Eddiecare", style: TextStyle(fontSize: 12)),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}
