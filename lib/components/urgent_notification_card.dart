import 'package:flutter/material.dart';

Widget urgentNotificationsCard({required double growthRate}) {
  final isUp = growthRate > 0;
  final color = isUp ? Colors.green : Colors.redAccent;
  final title = isUp
      ? "Congratulations, Your business is growing!"
      : "Heads up, revenue declined";
  final subtitle = isUp
      ? "Your revenue increased by ${growthRate.toStringAsFixed(1)}% since last month"
      : "Your revenue decreased by ${growthRate.abs().toStringAsFixed(1)}% since last month";

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade100,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
