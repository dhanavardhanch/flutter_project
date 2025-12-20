// lib/menu_items/performance_screen.dart

import 'package:flutter/material.dart';
import 'package:tg_app/activity_logger.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  // Small helper to safely convert dynamic -> int
  int safeInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    // try parse string
    try {
      return int.parse(v.toString());
    } catch (_) {
      try {
        return (double.parse(v.toString())).toInt();
      } catch (_) {
        return 0;
      }
    }
  }

  // ---------------------------- WEEKLY DATA EXTRACTOR ----------------------------
  Map<String, int> getWeeklyVisits(Map<String, Map<String, dynamic>> summary) {
    Map<String, int> weekly = {};
    DateTime now = DateTime.now();

    // produce week labels Mon..Sun or last 7 days - here we do last 7 days (Mon-Sun depends on locale)
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      String key = DateFormat("yyyy-MM-dd").format(day);
      String label = DateFormat("EEE").format(day); // Mon, Tue...
      int visits = safeInt(summary[key]?["storesVisited"]);
      weekly[label] = visits;
    }

    return weekly;
  }

  // ---------------------------- PERFORMANCE IMPROVEMENT ----------------------------
  double getPerformanceIncrease(
      Map<String, Map<String, dynamic>> summary, String todayKey) {
    int todayVisits = safeInt(summary[todayKey]?["storesVisited"]);

    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    String yesterdayKey = DateFormat("yyyy-MM-dd").format(yesterday);

    int yesterdayVisits = safeInt(summary[yesterdayKey]?["storesVisited"]);

    if (yesterdayVisits == 0) return todayVisits > 0 ? 100.0 : 0.0;

    double increase = ((todayVisits - yesterdayVisits) / yesterdayVisits) * 100.0;
    return increase;
  }

  @override
  Widget build(BuildContext context) {
    final summary = ActivityLogger.getSummary();
    String todayKey = DateFormat("yyyy-MM-dd").format(DateTime.now());

    int todaysVisits = safeInt(summary[todayKey]?["storesVisited"]);

    // TOTAL VISITS & TOTAL PO
    int totalVisits = 0;
    int totalPOs = 0;

    summary.forEach((_, day) {
      totalVisits += safeInt(day["storesVisited"]);
      totalPOs += safeInt(day["purchaseOrders"]);
    });

    // WEEKLY DATA
    Map<String, int> weeklyVisits = getWeeklyVisits(summary);

    // PERFORMANCE IMPROVEMENT
    double improvement = getPerformanceIncrease(summary, todayKey);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AEEF),
        elevation: 0,
        title: const Text("Performance"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUMMARY HEADER
              const Text(
                "Performance Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),
              _statCard("Today's Visits", "$todaysVisits"),
              const SizedBox(height: 12),

              _statCard("Total Visits", "$totalVisits"),
              const SizedBox(height: 12),

              _statCard("PO Collected (Total)", "$totalPOs"),
              const SizedBox(height: 12),

              _statCard("Performance Improvement vs Yesterday",
                  "${improvement.toStringAsFixed(1)}%"),
              const SizedBox(height: 25),

              // WEEKLY GRAPH
              const Text(
                "Weekly Visit Trend",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),

              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= weeklyVisits.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                weeklyVisits.keys.elementAt(index),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                    ),
                    barGroups: List.generate(weeklyVisits.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: weeklyVisits.values.elementAt(index).toDouble(),
                            color: const Color(0xFF00AEEF),
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------- STAT CARD ----------------------------
  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,   // prevents overflow
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00AEEF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
