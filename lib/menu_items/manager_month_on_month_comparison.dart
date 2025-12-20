import 'package:flutter/material.dart';

class ManagerMonthOnMonthComparisonScreen extends StatelessWidget {
  const ManagerMonthOnMonthComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,

        // ---------- TITLE AREA ----------
        title: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Month on Month",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Last 3 Months",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------- RIGHT ACTIONS ----------
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 170),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Thursday, 18-Dec-2025",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TITLE ----------
            const Text(
              "Month on Month Sales and Coverage\nComparison",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            // ---------- CARD ----------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Billed Counters for Last 3 months",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _progressRow(
                    name: "P Durga Prasad",
                    value: 471,
                    percent: 0.85,
                  ),
                  const SizedBox(height: 14),

                  _progressRow(
                    name: "Vacant SR Exec-Andhra Pradesh",
                    value: 293,
                    percent: 0.55,
                  ),
                  const SizedBox(height: 14),

                  _progressRow(
                    name: "empty",
                    value: 89,
                    percent: 0.25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 🔹 PROGRESS ROW
  // ======================================================
  Widget _progressRow({
    required String name,
    required int value,
    required double percent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
