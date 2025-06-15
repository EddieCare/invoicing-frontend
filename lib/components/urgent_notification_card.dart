import 'package:flutter/material.dart';

Widget urgentNotificationsCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(Icons.trending_up, color: Colors.green, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Congratulations, Your Business is growing !!!",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: "Your revenue increase is ",
                  style: TextStyle(fontSize: 13),
                  children: [
                    TextSpan(
                      text: "6%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    TextSpan(text: " since last month"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
