import 'package:flutter/material.dart';

class ManagerOutletSummaryScreen extends StatelessWidget {
  const ManagerOutletSummaryScreen({super.key});

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
        title: Row(
          children: [
            Chip(
              label: const Text(
                "Friday, 19-Dec-2025",
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue.shade50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _outletCard(
              name: "Andhra Pradesh_SR_Exec01",
              subtitle: "(P Durga Prasad)",
              location: "VIJAYAWADA",
              total: "2422",
            ),
            const SizedBox(height: 14),
            _outletCard(
              name: "AP_SR/S0001",
              subtitle: "(Karanki Seetharamjaneeya Swamy)",
              location: "RAJAHMUNDRY",
              total: "368",
            ),
            const SizedBox(height: 14),
            _outletCard(
              name: "Vijayawada_SR/S0001",
              subtitle: "(Murugu Kiran Kumar)",
              location: "VIJAYAWADA",
              total: "642",
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 🟦 OUTLET CARD
  // ======================================================
  Widget _outletCard({
    required String name,
    required String subtitle,
    required String location,
    required String total,
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
          // ---------- HEADER ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _iconCircle(Icons.share),
                      const SizedBox(width: 6),
                      _iconCircle(Icons.chat_bubble_outline), // WhatsApp-like
                      const SizedBox(width: 6),
                      _iconCircle(Icons.call),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---------- TOTAL ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL OUTLETS",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                total,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---------- STACKED BAR ----------
          _stackedBar(),

          const SizedBox(height: 12),

          // ---------- TABLE HEADER ----------
          Row(
            children: const [
              Expanded(child: Text("OUTLET TYPE")),
              Expanded(child: Text("TOTAL", textAlign: TextAlign.center)),
              Expanded(child: Text("MTD VISITED", textAlign: TextAlign.center)),
              Expanded(child: Text("MTD ORDER", textAlign: TextAlign.end)),
            ],
          ),
          const Divider(),

          _row("New", "174", "169 (97.1%)", "32 (18.4%)", Colors.purple),
          _row("Active", "432", "353 (81.7%)", "164 (38.0%)", Colors.green),
          _row("To Be Dormant", "139", "81 (58.3%)", "62 (44.6%)", Colors.blue),
          _row("Dormant", "85", "50 (58.8%)", "11 (12.9%)", Colors.amber),
          _row("No Order", "617", "396 (64.2%)", "76 (12.3%)", Colors.orange),
          _row("Never Visited", "975", "31 (3.2%)", "8 (0.8%)", Colors.red),
        ],
      ),
    );
  }

  // ======================================================
  // COMPONENTS
  // ======================================================

  Widget _iconCircle(IconData icon) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Colors.blue.shade50,
      child: Icon(icon, size: 16, color: Colors.blue),
    );
  }

  Widget _stackedBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          _bar(12, Colors.purple),
          _bar(18, Colors.green),
          _bar(10, Colors.blue),
          _bar(20, Colors.amber),
          _bar(22, Colors.orange),
          _bar(18, Colors.red),
        ],
      ),
    );
  }

  Widget _bar(int flex, Color color) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 18, // ✅ increased height
        color: color,
      ),
    );
  }

  Widget _row(
      String title,
      String total,
      String visited,
      String order,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: color),
                const SizedBox(width: 6),
                Expanded(child: Text(title)),
              ],
            ),
          ),
          Expanded(child: Text(total, textAlign: TextAlign.center)),
          Expanded(child: Text(visited, textAlign: TextAlign.center)),
          Expanded(child: Text(order, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
