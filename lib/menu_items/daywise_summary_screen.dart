import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../activity_logger.dart';

class DaywiseSummaryScreen extends StatefulWidget {
  const DaywiseSummaryScreen({super.key});

  @override
  State<DaywiseSummaryScreen> createState() => _DaywiseSummaryScreenState();
}

class _DaywiseSummaryScreenState extends State<DaywiseSummaryScreen> {
  late Map<String, Map<String, dynamic>> summary;
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    summary = ActivityLogger.getSummary();
    selectedDay = DateTime.now();
  }

  String formatKey(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  // ------------------------------------------------------------------
  // 📅 Open Date Picker
  // ------------------------------------------------------------------
  Future<void> pickDate() async {
    DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00AEEF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedKey = formatKey(selectedDay);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Daywise Summary",
            style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFF00AEEF),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,

        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.black, size: 26),
            onPressed: pickDate,
          ),
        ],
      ),

      backgroundColor: Colors.grey.shade100,

      body: Column(
        children: [
          // Selected date display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: Colors.white,
            child: Text(
              DateFormat("EEE, dd MMM yyyy").format(selectedDay),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          // SUMMARY VIEW
          Expanded(
            child: summary.containsKey(selectedKey)
                ? _summaryCard(summary[selectedKey]!, selectedKey)
                : const Center(
              child: Text(
                "No activity recorded for this day",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // SUMMARY CARD UI
  // ------------------------------------------------------------------
  Widget _summaryCard(Map<String, dynamic> data, String dateKey) {
    bool isAbsent = data["status"] != "Present";
    bool hasStock = data["stockUpdates"].isNotEmpty;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isAbsent ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data["status"],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (isAbsent)
              const Text(
                "Absent",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            else ...[
              _infoRow("First Activity", data["appOpen"]),
              if (data["lastStore"] != "-")
                _infoRow("Last Store", data["lastStore"]),

              const SizedBox(height: 20),

              // METRICS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _metric("Visits", "${data["storesVisited"]}"),
                  _metric("Revisits", "${data["revisits"]}"),
                  _metric("Orders", "${data["purchaseOrders"]}"),
                  _metric("Tasks", "${data["tasksCompleted"]}"),
                ],
              ),

              if (data["officialWork"] != "-") ...[
                const SizedBox(height: 20),
                Text("Official Work: ${data["officialWork"]}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500)),
              ],

              if (hasStock) ...[
                const SizedBox(height: 20),
                const Text("Stock Summary",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                ...data["stockUpdates"].entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(fontSize: 14)),
                        Text("${e.value} pcs",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ],
        ),
      ),
    );
  }

  // Row UI
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  // Metric UI
  Widget _metric(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}


