import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../activity_logger.dart';

class UserProfileDashboard extends StatelessWidget {
  const UserProfileDashboard({super.key});

  static const int totalOutlets = 9;
  static const int userTargetPcs = 10000;

  @override
  Widget build(BuildContext context) {
    final summary = ActivityLogger.getSummary();
    final todayKey = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final now = DateTime.now();

    // ================= DAILY PCS =================
    int dailyPcs = 0;
    if (summary.containsKey(todayKey)) {
      final stock =
      Map<String, int>.from(summary[todayKey]!["stockUpdates"] ?? {});
      dailyPcs = stock.values.fold(0, (a, b) => a + b);
    }

    double dailyRaw = userTargetPcs == 0 ? 0 : dailyPcs / userTargetPcs;
    double dailyProgress = dailyRaw.clamp(0, 1);
    double dailyPercentText = min(dailyRaw * 100, 100);

    // ================= MTD PCS =================
    int mtdPcs = 0;
    Map<String, int> itemOutletCount = {};

    summary.forEach((date, data) {
      final d = DateTime.parse(date);
      if (d.month == now.month && d.year == now.year) {
        final stock =
        Map<String, int>.from(data["stockUpdates"] ?? {});
        stock.forEach((item, qty) {
          mtdPcs += qty;
          if (qty > 0) {
            itemOutletCount[item] =
                (itemOutletCount[item] ?? 0) + 1;
          }
        });
      }
    });

    double mtdRaw = userTargetPcs == 0 ? 0 : mtdPcs / userTargetPcs;
    double mtdProgress = mtdRaw.clamp(0, 1);
    double mtdPercentText = min(mtdRaw * 100, 100);

    int remainingPcs =
    (userTargetPcs - mtdPcs).clamp(0, userTargetPcs);

    final top2 = itemOutletCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final gtmTop = top2.take(2).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("My Profile", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _profileHeader(),
            const SizedBox(height: 14),

            /// USER OVERALL
            Row(
              children: [
                Expanded(
                  child: GaugeCard(
                    title: "User Overall - MTD",
                    value: "${mtdPercentText.toStringAsFixed(1)}%",
                    subtitle: "$mtdPcs / $userTargetPcs pcs",
                    progress: mtdProgress,
                    rrr: "$mtdPcs",
                    crr: "$userTargetPcs",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GaugeCard(
                    title: "User Overall - Daily",
                    value: "${dailyPercentText.toStringAsFixed(1)}%",
                    subtitle: "$dailyPcs / $userTargetPcs pcs",
                    progress: dailyProgress,
                    rrr: "$dailyPcs",
                    crr: "$userTargetPcs",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// GTM TOP
            Row(
              children: List.generate(gtmTop.length, (i) {
                final item = gtmTop[i];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == 0 ? 12 : 0),
                    child: GTMCard(
                      title: "GTM - ${item.key}",
                      value: "${item.value}/$totalOutlets",
                      progress:
                      totalOutlets == 0 ? 0 : item.value / totalOutlets,
                      color: i == 0 ? Colors.green : Colors.indigo,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            /// MY TARGET
            _myTargetSection(
              achievedPcs: mtdPcs,
              remainingPcs: remainingPcs,
              progress: mtdProgress,
            ),

            const SizedBox(height: 14),

            /// GTM TARGET
            Row(
              children: [
                _gtmTargetItem(
                  title: "Toffee Chikki",
                  count: itemOutletCount["TOFFEE CHIKKI"] ?? 0,
                ),
                const SizedBox(width: 12),
                _gtmTargetItem(
                  title: "Millet Chikki",
                  count: itemOutletCount["MILLET CHIKKI"] ?? 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE7D9FF),
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("John Doe",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("EMP0012"),
              Text("Route: JW with User Name",
                  style: TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _myTargetSection({
    required int achievedPcs,
    required int remainingPcs,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GaugeCard(
              title: "Employee Wise Targets",
              value: "${(progress * 100).toStringAsFixed(1)}%",
              subtitle: "$userTargetPcs pcs",
              progress: progress,
              rrr: "$achievedPcs",
              crr: "$userTargetPcs",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🌤 Almost there!",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Text("$userTargetPcs pcs",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Target"),
                const SizedBox(height: 8),
                Text("$remainingPcs pcs",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Remaining"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= GAUGE CARD =================
class GaugeCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double progress;
  final String rrr;
  final String crr;

  const GaugeCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.rrr,
    required this.crr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          SizedBox(
            height: 90,
            child: CustomPaint(
              painter: SpeedometerPainter(progress),
              child: Center(
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("RRR: $rrr", style: const TextStyle(fontSize: 11)),
              Text("CRR: $crr", style: const TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= GTM CARD =================
class GTMCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress;
  final Color color;

  const GTMCard({
    super.key,
    required this.title,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            width: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const Text("Outlets", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

/// ================= SPEEDOMETER =================
class SpeedometerPainter extends CustomPainter {
  final double progress;
  SpeedometerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2.2;

    const strokeWidth = 10.0;
    const gap = 0.04;
    const startAngle = pi;
    const totalSweep = pi;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final segments = [
      _Segment(0.0, 0.25, Colors.red),
      _Segment(0.25, 0.5, Colors.orange),
      _Segment(0.5, 0.75, Colors.yellow),
      _Segment(0.75, 1.0, Colors.green),
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.color.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle + totalSweep * seg.start,
        totalSweep * (seg.end - seg.start) - gap,
        false,
        paint,
      );
    }

    for (final seg in segments) {
      if (progress <= seg.start) break;

      final segProgress =
      ((progress - seg.start) / (seg.end - seg.start))
          .clamp(0.0, 1.0);

      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle + totalSweep * seg.start,
        totalSweep * (seg.end - seg.start) * segProgress - gap,
        false,
        paint,
      );
    }

    final angle = startAngle + totalSweep * progress;
    final offset = Offset(
      center.dx + cos(angle) * radius,
      center.dy + sin(angle) * radius,
    );

    canvas.drawCircle(offset, 6, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _Segment {
  final double start;
  final double end;
  final Color color;
  _Segment(this.start, this.end, this.color);
}

/// ================= GTM TARGET ITEM =================
Widget _gtmTargetItem({
  required String title,
  required int count,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ white background
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            "$count / 9",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "outlets",
            style: TextStyle(color: Colors.grey), // ✅ visible now
          ),
        ],
      ),
    ),
  );
}
