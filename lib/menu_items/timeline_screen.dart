import 'package:flutter/material.dart';
import '../activity_logger.dart';
import 'package:intl/intl.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool showAllDays = false;

  String formatDateLabel(String dateKey) {
    DateTime date = DateTime.parse(dateKey);
    DateTime today = DateTime.now();

    if (dateKey == DateFormat("yyyy-MM-dd").format(today)) return "Today";

    if (dateKey ==
        DateFormat("yyyy-MM-dd")
            .format(today.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }

    return DateFormat("MMM dd, yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final logs = ActivityLogger.getLogs();
    final sortedDates = logs.keys.toList()..sort((a, b) => b.compareTo(a));

    final displayedDates =
    showAllDays ? sortedDates : sortedDates.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AEEF),
        elevation: 0,
        title: const Text("Timeline"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...displayedDates.map((dateKey) {
            // ⭐ Descending order by time
            List dayLogs = List.from(logs[dateKey]!.reversed);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDateLabel(dateKey),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                ...List.generate(dayLogs.length, (index) {
                  final log = dayLogs[index];
                  final bool isLast = index == dayLogs.length - 1;

                  return _timelineTile(
                    title: log["title"]!,
                    subtitle: log["subtitle"]!,
                    time: log["time"]!,
                    type: log["type"]!,
                    isLast: isLast,
                  );
                }),

                const SizedBox(height: 30),
              ],
            );
          }),

          if (!showAllDays && sortedDates.length > 2)
            Center(
              child: TextButton(
                onPressed: () => setState(() => showAllDays = true),
                child: const Text(
                  "View Past Days",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _timelineTile({
    required String title,
    required String subtitle,
    required String time,
    required String type,
    required bool isLast,
  }) {
    Color dotColor = Colors.green;
    IconData tileIcon = Icons.fiber_manual_record;

    switch (type) {
      case "start":
        dotColor = Colors.blue;
        tileIcon = Icons.play_arrow;
        break;
      case "store":
        dotColor = Colors.deepPurple;
        tileIcon = Icons.store_mall_directory;
        break;
      case "revisit":
        dotColor = Colors.orange;
        tileIcon = Icons.refresh;
        break;
      case "po":
        dotColor = Colors.teal;
        tileIcon = Icons.shopping_cart;
        break;
      case "task":
        dotColor = Colors.orange;
        tileIcon = Icons.task_alt;
        break;
      case "stock_update":
        dotColor = Colors.purple;
        tileIcon = Icons.inventory;
        break;
      case "leave":
        dotColor = Colors.red;
        tileIcon = Icons.event_busy;
        break;
      case "official":
        dotColor = Colors.indigo;
        tileIcon = Icons.business_center;
        break;
      case "store_end":
        dotColor = Colors.redAccent;
        tileIcon = Icons.exit_to_app;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration:
              BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 55,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 22),
            padding: const EdgeInsets.all(14),
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
                Row(
                  children: [
                    Icon(tileIcon, size: 18, color: dotColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style:
                  const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
