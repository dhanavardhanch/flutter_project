import 'package:flutter/material.dart';
import 'package:tg_app/activity_logger.dart';
import '../menu_items/daywise_summary_screen.dart';

class PocketMISScreen extends StatefulWidget {
  const PocketMISScreen({super.key});

  @override
  State<PocketMISScreen> createState() => _PocketMISScreenState();
}

class _PocketMISScreenState extends State<PocketMISScreen> {
  int totalDays = 0;
  int merchandising = 0;
  int officialWorkDays = 0;
  int leaveDays = 0;
  int absentDays = 0;
  int todayMerch = 0;

  @override
  void initState() {
    super.initState();
    calculateMIS();
  }

  // ------------------------------------------------------------
  // ⭐ CALCULATE MIS VALUES
  // ------------------------------------------------------------
  void calculateMIS() {
    final logs = ActivityLogger.getLogs();

    Set<String> uniqueDays = logs.keys.toSet();
    totalDays = uniqueDays.length;

    merchandising = 0;
    officialWorkDays = 0;
    leaveDays = 0;
    absentDays = 0;
    todayMerch = 0;

    logs.forEach((date, dayLogs) {
      bool hasStoreVisit = false;
      bool hasMerch = false;
      bool hasLeave = false;
      bool hasOfficial = false;

      Set<String> uniqueMerchOutlets = {};

      for (var log in dayLogs) {
        if (log["type"] == "store") hasStoreVisit = true;

        if (log["type"] == "merch") {
          hasMerch = true;
          uniqueMerchOutlets.add(log["subtitle"]!);
        }

        if (log["type"] == "leave") hasLeave = true;

        if (log["type"] == "official") hasOfficial = true;
      }

      merchandising += uniqueMerchOutlets.length;

      if (date == ActivityLogger.todayKey) {
        todayMerch = uniqueMerchOutlets.length;
      }

      if (hasLeave) leaveDays++;

      if (hasOfficial) officialWorkDays++;

      if (!hasStoreVisit && !hasLeave) absentDays++;
    });

    setState(() {});
  }

  // ------------------------------------------------------------
  // REUSABLE ROW (ICON + TITLE + VALUE)
  // ------------------------------------------------------------
  Widget _misItem(String emoji, String title, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AEEF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Pocket MIS", style: TextStyle(color: Colors.white)),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FBFE), Color(0xFFEAF3FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ⭐ SINGLE MIS SUMMARY CARD ⭐
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "MTD Attendance Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _misItem("🛒", "Merchandising", "$merchandising"),
                    const SizedBox(height: 12),

                    _misItem("💼", "Official Work", "$officialWorkDays"),
                    const SizedBox(height: 12),

                    _misItem("🏖️", "Leave", "$leaveDays"),
                    const SizedBox(height: 12),

                    _misItem("❌", "Absent Days", "$absentDays"),
                    const SizedBox(height: 12),

                    const Divider(),

                    const SizedBox(height: 12),
                    _misItem("📅", "Total Work Days", "$totalDays"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- DAY WISE SUMMARY BUTTON ----------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DaywiseSummaryScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      "Daywise Summary →",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
