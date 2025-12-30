import 'package:flutter/material.dart';

import '../task_screens/product_visibility_screen.dart';
import '../task_screens/transaction_details_screen.dart';

class StoreDashboardTaskScreen extends StatelessWidget {
  final int storeId;

  const StoreDashboardTaskScreen({
    super.key,
    required this.storeId,
  });

  final List<Map<String, dynamic>> tasks = const [
    {
      "title": "Product Visibility",
      "subtitle": "Capture product visibility",
      "screen": "PRODUCT_VISIBILITY",
    },
    {
      "title": "Transaction Details",
      "subtitle": "View store sales history",
      "screen": "TRANSACTION",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Task", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
      ),

      body: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ListTile(
            title: Text(
              task["title"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(task["subtitle"]),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (task["screen"] == "PRODUCT_VISIBILITY") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductVisibilityScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionDetailsScreen(
                      storeId: storeId, // ✅ FIXED
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
