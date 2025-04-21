import 'package:flutter/material.dart';

import '../../../components/top_bar.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: const TopBar(
        // title: "Home",
        leadingIcon: Icon(Icons.dashboard_customize_outlined, size: 30),
        showBackButton: false,
        actions: [
          Icon(Icons.notifications_none, size: 30),
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
                        "Apr 16, 2025",
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
                const SizedBox(height: 24),
                informationContainer(screenSize),
                const SizedBox(height: 24),
                pendingInvoices(screenSize),
                const SizedBox(height: 24),
                Container(
                  width: screenSize.width * 0.9,
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: screenSize.width * 0.40,
                                    width: screenSize.width * 0.40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: screenSize.width * 0.40,
                                    width: screenSize.width * 0.40,
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
                                    height: screenSize.width * 0.40,
                                    width: screenSize.width * 0.40,
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
                                    height: screenSize.width * 0.40,
                                    width: screenSize.width * 0.40,
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
                const SizedBox(height: 18),
                recentInvoices(screenSize),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container recentInvoices(Size screenSize) {
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
                "Recent Invoices",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                "Check recent invoices",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          recentInvoiceCard(),
          recentInvoiceCard(),
          recentInvoiceCard(),
          recentInvoiceCard(),
        ],
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

          pendingInvoiceCard(),
          pendingInvoiceCard(),
          pendingInvoiceCard(),
          pendingInvoiceCard(),
        ],
      ),
    );
  }

  Container recentInvoiceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
        color: Color(0xFF7A7A7A).withAlpha(16),
      ),
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(
            "assets/images/checkicon.png",
            height: 45,
            width: 45,
          ),
        ),
        title: Text(
          "INV-20240304-003",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pending Invoice",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            // Text(
            //   "Due: 27 March, 2025",
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w200,
            //     color: Colors.red,
            //   ),
            // ),
          ],
        ),
        trailing: Text(
          "4000 AUD",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Container pendingInvoiceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: Colors.black12.withAlpha(14), width: 2),
        color: Color(0xFF7A7A7A).withAlpha(16),
      ),
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(
            "assets/images/pending_invoice.png",
            height: 45,
            width: 45,
          ),
        ),
        title: Text(
          "INV-20240304-003",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w200,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pending Invoice",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              "Due: 27 March, 2025",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: Colors.red,
              ),
            ),
          ],
        ),
        trailing: Text(
          "4000 AUD",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Container informationContainer(Size screenSize) {
    return Container(
      width: screenSize.width * 0.9,
      // height: 400,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          // Container(
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          //   width: screenSize.width * 0.3,
          //   child: Image.network(
          //     "https://blog.boon.so/wp-content/uploads/2024/03/BMW-Logo-3-scaled.jpg",
          //     width: screenSize.width * 0.2,
          //     height: screenSize.width * 0.2,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Container(
            width: screenSize.width * 0.28,
            height: screenSize.width * 0.28, // Make it a square
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // Curved border
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                20,
              ), // Match this with container's radius
              child: Image.network(
                "https://blog.boon.so/wp-content/uploads/2024/03/BMW-Logo-3-scaled.jpg",
                width: screenSize.width * 0.2,
                height: screenSize.width * 0.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BMW Motors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                "motormatters@bmw.com",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 181, 181, 181),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      "+1 123 456 7890",
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
                "Mountain View, California",
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
    );
  }
}
