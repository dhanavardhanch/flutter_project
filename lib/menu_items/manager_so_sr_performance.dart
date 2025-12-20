import 'package:flutter/material.dart';

class ManagerSoSrPerformanceScreen extends StatelessWidget {
  const ManagerSoSrPerformanceScreen({super.key});

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
        title: const Text(
          "SO/SR Performance",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Chip(
              label: const Text("Thursday, 18-Dec-2025"),
              backgroundColor: Colors.blue.shade50,
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
          children: [
            _sectionCard(
              title: "SO/SR",
              items: const [
                PerfItem("P Durga Prasad", 441, 500),
                PerfItem("Vacant SR Exec-Andhra Pradesh", 373, 500),
                PerfItem("empty", 266, 500),
              ],
            ),

            const SizedBox(height: 16),

            _sectionCard(
              title: "Unique PC",
              items: const [
                PerfItem("P Durga Prasad", 157, 200),
                PerfItem("Vacant SR Exec-Andhra Pradesh", 139, 200),
                PerfItem("empty", 57, 200),
              ],
            ),

            const SizedBox(height: 16),

            _sectionCard(
              title: "oVC %",
              isPercentage: true,
              items: const [
                PerfItem("empty", 21.47, 100),
                PerfItem("P Durga Prasad", 0.25, 100),
                PerfItem("Vacant SR Exec-Andhra Pradesh", 0.16, 100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // SECTION CARD
  // ======================================================
  Widget _sectionCard({
    required String title,
    required List<PerfItem> items,
    bool isPercentage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          // 🔥 FIXED: no toList()
          ...items.map((item) {
            final double percent =
            (item.value / item.max).clamp(0.0, 1.0);

            return _progressRow(
              label: item.label,
              value: item.value,
              percent: percent,
              isPercentage: isPercentage,
            );
          }),
        ],
      ),
    );
  }

  // ======================================================
  // ROW WITH PROGRESS BAR
  // ======================================================
  Widget _progressRow({
    required String label,
    required double value,
    required double percent,
    required bool isPercentage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Text(
                isPercentage
                    ? value.toStringAsFixed(2)
                    : value.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent, // ✅ double
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// DATA MODEL (STRICT TYPES)
// ======================================================
class PerfItem {
  final String label;
  final double value;
  final double max;

  const PerfItem(this.label, this.value, this.max);
}
