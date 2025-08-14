import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicedaily/app/routes/app_routes.dart';
import 'package:invoicedaily/components/urgent_notification_card.dart';

import '../../../components/top_bar.dart';
import '../../../values/values.dart';
import '../../controllers/dashboard/dashboard_controller.dart';
import '../../controllers/invoice/invoice_controller.dart';
import '../../controllers/shop/shop_controller.dart';
import '../shop/shop_create.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final ShopController shopController = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    String monthName(int month) {
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return months[month - 1];
    }

    return Scaffold(
      backgroundColor: AppColor.pageColor,
      appBar: TopBar(
        showBackButton: false,
        showMenu: true,
        actions: [
          Icon(Icons.notifications_none, size: 30),
          SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            // child: CircularProgressIndicator(color: AppColor.textColorPrimary),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 15),
                  SizedBox(
                    width: screenSize.width * 0.89,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Apr 16, 2025",
                          "${DateTime.now().toLocal().day.toString().padLeft(2, '0')} "
                          "${monthName(DateTime.now().month)}, "
                          "${DateTime.now().year}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 15),
                  const SizedBox(height: 24),
                  shopController.shopData.value != null
                      ? _buildShopCard(
                        shopController.shopData.value!,
                        screenSize,
                      )
                      : _buildCreateShopPrompt(screenSize),

                  const SizedBox(height: 24),
                  Container(
                    width: screenSize.width * 0.9,
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 4),
                    decoration: BoxDecoration(
                      // color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Financial Overview",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "See All",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            urgentNotificationsCard(),
                            const SizedBox(height: 18),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: screenSize.width * 0.42,
                                      width: screenSize.width * 0.42,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: screenSize.width * 0.42,
                                      width: screenSize.width * 0.42,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          210,
                                          210,
                                          210,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: screenSize.width * 0.42,
                                      width: screenSize.width * 0.42,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          210,
                                          210,
                                          210,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      height: screenSize.width * 0.42,
                                      width: screenSize.width * 0.42,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  pendingInvoices(screenSize),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCreateShopPrompt(Size screenSize) {
    return GestureDetector(
      onTap: () {
        showCreateShopBottomSheet(
          Get.context!,
          // onCreate: (data) {
          //   controller.createShop(data);
          // },
        );
      },
      child: Container(
        width: screenSize.width * 0.9,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.store, size: 40),
            const SizedBox(height: 12),
            Text(
              "No shop found. Tap to create your shop now!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Container pendingInvoices(Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withAlpha(10),
            offset: Offset(0, 3),
            blurRadius: 1,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Pending Invoices",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                "Check pending invoices",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          Obx(() {
            final invoices =
                Get.find<InvoiceController>().latestPendingOrUnpaid;
            return Column(
              children:
                  invoices.isNotEmpty
                      ? invoices.map((invoice) {
                        return pendingInvoiceCard(invoice);
                      }).toList()
                      : [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 30.0,
                              horizontal: 10,
                            ),
                            child: Text(
                              "No pending invoices found.",
                              style: TextStyle(
                                color: AppColor.textColorPrimary.withAlpha(50),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
            );
          }),
        ],
      ),
    );
  }

  // Container pendingInvoiceCard() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(15)),
  //       border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
  //       color: Color(0xFF7A7A7A).withAlpha(16),
  //     ),
  //     margin: EdgeInsets.only(top: 18),
  //     padding: EdgeInsets.symmetric(vertical: 4),
  //     child: ListTile(
  //       leading: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(15)),
  //         ),
  //         child: Image.asset(
  //           "assets/images/pending_invoice.png",
  //           height: 45,
  //           width: 45,
  //         ),
  //       ),
  //       title: Text(
  //         "INV-20240304-003",
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w200,
  //           color: Colors.black,
  //         ),
  //       ),
  //       subtitle: Column(
  //         mainAxisSize: MainAxisSize.max,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "Pending Invoice",
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.w500,
  //               color: Colors.black,
  //             ),
  //           ),
  //           Text(
  //             "Due: 27 March, 2025",
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: Colors.red,
  //             ),
  //           ),
  //         ],
  //       ),
  //       trailing: Text(
  //         "4000 AUD",
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget pendingInvoiceCard(Map<String, dynamic> invoice) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(15)),
  //       border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
  //       color: Color(0xFF7A7A7A).withAlpha(16),
  //     ),
  //     margin: EdgeInsets.only(top: 18),
  //     padding: EdgeInsets.symmetric(vertical: 4),
  //     child: ListTile(
  //       leading: Image.asset(
  //         "assets/images/pending_invoice.png",
  //         height: 45,
  //         width: 45,
  //       ),
  //       title: Text(
  //         invoice['invoice_number'] ?? '',
  //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
  //       ),
  //       subtitle: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             "${invoice['status']} Invoice",
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //           ),
  //           Text(
  //             "Due: ${_formatDate(invoice['due_date'])}",
  //             style: TextStyle(fontSize: 14, color: Colors.red),
  //           ),
  //         ],
  //       ),
  //       trailing: Text(
  //         "${invoice['total'] ?? 0} AUD",
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  //       ),
  //     ),
  //   );
  // }

  // String _formatDate(Timestamp? timestamp) {
  //   if (timestamp == null) return '';
  //   final date = timestamp.toDate();
  //   return "${date.day} ${_monthName(date.month)}, ${date.year}";
  // }

  // String _monthName(int month) {
  //   const months = [
  //     "",
  //     "January",
  //     "February",
  //     "March",
  //     "April",
  //     "May",
  //     "June",
  //     "July",
  //     "August",
  //     "September",
  //     "October",
  //     "November",
  //     "December",
  //   ];
  //   return months[month];
  // }

  Widget pendingInvoiceCard(Map<String, dynamic> invoice) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
        color: Color(0xFF7A7A7A).withAlpha(16),
      ),
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Image.asset(
          "assets/images/pending_invoice.png",
          height: 45,
          width: 45,
        ),
        title: Text(
          invoice['invoice_number'] ?? '',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${invoice['status']} Invoice",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              "Due: ${_formatDate(invoice['due_date'])}",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ],
        ),
        trailing: Text(
          "${invoice['total'] ?? 0} AUD",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    return "${date.day} ${_monthName(date.month)}, ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month];
  }

  Widget _buildShopCard(Map<String, dynamic> shopData, Size screenSize) {
    return GestureDetector(
      onTap: () => {Get.toNamed(Routes.shopDetailScreen, arguments: shopData)},
      child: Container(
        width: screenSize.width * 0.9,
        // height: 400,
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Container(
              width: screenSize.width * 0.28,
              height: screenSize.width * 0.28, // Make it a square
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Curved border
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  20,
                ), // Match this with container's radius
                child:
                // shopData['shop_image_link'] != null
                //     ? Image.network(
                //       // shopData['shop_image_link'] ?? "assets/images/no_image.png",
                //       shopData['shop_image_link'],
                //       width: screenSize.width * 0.2,
                //       height: screenSize.width * 0.2,
                //       fit: BoxFit.cover,
                //     )
                //     : Image.asset("assets/images/no_image.png"),
                Image.asset("assets/images/no_image.png"),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "BMW Motors",
                  shopData["shop_name"] ?? "",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  // "motormatters@bmw.com",
                  shopData['shop_email'] ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromARGB(255, 181, 181, 181),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        // "+1 123 456 7890",
                        shopData['shop_phone'] ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${shopData['shop_address']['street']}, ${shopData['shop_address']['zip']}" ??
                      "",
                  // "Mountain View, California",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromARGB(255, 242, 242, 242),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
