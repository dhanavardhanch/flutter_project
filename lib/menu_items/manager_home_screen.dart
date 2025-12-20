import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Image.asset(
          'assets/TrooGood_Logo.png',
          height: 28,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _dateHeader(),
            const SizedBox(height: 14),

            /// USER + CALL SUMMARY (EQUAL HEIGHT)
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _userSummary()),
                  const SizedBox(width: 12),
                  Expanded(child: _callSummary()),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// PRIMARY CATEGORY
            _card(
              title: "Primary Category Wise Order",
              right: _mtd(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _bigDonut("₹ 4.73 Lac"),
                  const SizedBox(height: 12),
                  _legend("Makhan", Colors.purple, "₹ 2.17 Lac"),
                  _legend("Dry Fruits", Colors.green, "₹ 1.93 Lac"),
                  _legend("Kerala", Colors.grey, "₹ 46,841"),
                  _legend("Roasted", Colors.red, "₹ 5,375"),
                  _legend("Instant", Colors.lightGreen, "₹ 5,167"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// L1 POSITION WISE ORDER (EXACT IMAGE-2 STYLE)
            _card(
              title: "L1 Position Wise Order",
              right: _mtd(),
              child: Column(
                children: [
                  _orderValidationRow(
                    name:
                    "Andhra Pradesh_SR/S001 (Laxmi Narayan Rao)",
                    orderValue: "₹ 1.92 Lac",
                    validationValue: "₹ 1.41 Lac",
                    orderPercent: 0.85,
                    validationPercent: 0.62,
                  ),
                  _orderValidationRow(
                    name:
                    "Vijayawada_SR/S001 (Murugu Kiran Kumar)",
                    orderValue: "₹ 1.17 Lac",
                    validationValue: "₹ 86,841.8",
                    orderPercent: 0.65,
                    validationPercent: 0.48,
                  ),
                  _orderValidationRow(
                    name:
                    "AP_SR/S001 (Karanki Seetharam)",
                    orderValue: "₹ 1.02 Lac",
                    validationValue: "₹ 36,119.2",
                    orderPercent: 0.58,
                    validationPercent: 0.32,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// OUTLETS SUMMARY
            _card(
              title: "Outlets Summary",
              right: _mtd(),
              child: Column(
                children: [
                  _kv("UTC", "1,080.0", Colors.green),
                  _kv("UPC", "353.0", Colors.green),
                  _kv("Zero Order", "727.0", Colors.orange),
                  _kv("Not Visited", "1,336.0", Colors.red),
                  const Divider(),
                  _kv("Total", "2,416.0", Colors.blue),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _smallDonut("22%", "Productivity"),
                      _smallDonut("45%", "Covered"),
                      _smallDonut("15%", "Zero Order"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// SECONDARY TARGET
            _card(
              title: "Secondary Targets SR/SO wise",
              right: _mtd(),
              child: Column(
                children: [
                  _targetRow("Total", "9.97 Lac", "4.73 Lac (47%)"),
                  _targetRow(
                      "Andhra Pradesh", "3.79 Lac", "1.92 Lac (51%)"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ZSM
            _card(
              title: "ZSM Wise Targets vs Achievements",
              right: _mtd(),
              child: _tableRow(
                  "Total", "4.73 Lac", "4.55 Lac", "0"),
            ),

            const SizedBox(height: 12),

            /// ABL
            _card(
              title: "ABL Wise Targets vs Achievements",
              right: _mtd(),
              child: _tableRow(
                "Narahari Mallepally",
                "4.73 Lac",
                "4.55 Lac",
                "9.97 Lac",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // WIDGETS
  // ------------------------------------------------------------------

  Widget _dateHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Chip(label: Text("Friday, 19-Dec-2025")),
      Text("Last Refreshed Just Now",
          style: TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );

  Widget _userSummary() => _card(
    title: "User Summary",
    child: Column(
      children: [
        _kv("Retailing", "4", Colors.green),
        _kv("Official Work", "1", Colors.orange),
        _kv("Leave", "0", Colors.grey),
        _kv("Absent", "0", Colors.red),
        const Divider(),
        _kv("Total", "5", Colors.blue),
      ],
    ),
  );

  Widget _callSummary() => _card(
    title: "Call Summary",
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _smallDonut("31%", "Productivity"),
            _smallDonut("6%", "Covered"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("10\nPC", textAlign: TextAlign.center),
            Text("32\nTC", textAlign: TextAlign.center),
            Text("545\nSC", textAlign: TextAlign.center),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10)),
          child: const Text(
            "NetValue (₹)\n9,941.5",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );

  Widget _orderValidationRow({
    required String name,
    required String orderValue,
    required String validationValue,
    required double orderPercent,
    required double validationPercent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),

          /// ORDER
          _barRow("Order", orderValue, Colors.purple, orderPercent),

          const SizedBox(height: 6),

          /// VALIDATION
          _barRow(
              "Validation", validationValue, Colors.blue, validationPercent),
        ],
      ),
    );
  }

  Widget _barRow(
      String label, String value, Color color, double percent) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label)),
        Expanded(
          child: Stack(
            children: [
              Container(height: 8, color: color.withOpacity(0.2)),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(height: 8, color: color),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _card(
      {required String title,
        Widget? right,
        required Widget child}) =>
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                if (right != null) right,
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );

  Widget _kv(String k, String v, Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k),
        Text(v,
            style:
            TextStyle(color: c, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _mtd() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue)),
    child:
    const Text("MTD", style: TextStyle(color: Colors.blue)),
  );

  Widget _smallDonut(String value, String label) => Column(
    children: [
      CircularPercentIndicator(
        radius: 30,
        lineWidth: 6,
        percent:
        double.parse(value.replaceAll('%', '')) / 100,
        center: Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        progressColor: Colors.green,
        backgroundColor: Colors.grey.shade300,
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );

  Widget _bigDonut(String value) => CircularPercentIndicator(
    radius: 70,
    lineWidth: 14,
    percent: 0.75,
    center: Text(value,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16)),
    progressColor: Colors.purple,
    backgroundColor: Colors.grey.shade300,
  );

  Widget _legend(String t, Color c, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: c),
        const SizedBox(width: 6),
        Expanded(child: Text(t)),
        Text(v),
      ],
    ),
  );

  Widget _targetRow(
      String name, String target, String achieved) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(name), Text(target), Text(achieved)],
        ),
      );

  Widget _tableRow(
      String name, String mtd, String lmtd, String target) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(name), Text(mtd), Text(lmtd), Text(target)],
      );
}
