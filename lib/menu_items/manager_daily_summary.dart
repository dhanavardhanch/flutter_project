import 'package:flutter/material.dart';

class ManagerDailySummaryScreen extends StatelessWidget {
  const ManagerDailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: Image.asset(
          'assets/TrooGood_Logo.png',
          height: 34,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
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
            _dateHeader(),
            const SizedBox(height: 10),

            _reportingHeader(),
            const SizedBox(height: 12),

            /// ================= L2 POSITION =================
            _sectionTitle("L2 POSITION"),
            _l2Card(),

            const SizedBox(height: 14),

            /// ================= L1 POSITION =================
            _sectionTitle("L1 POSITION"),
            _l1Card(),

            const SizedBox(height: 14),

            /// ================= ANOTHER L1 =================
            _sectionTitle("L1 POSITION"),
            _simpleL1Card(
              name: "Laxmi Narayan Rao",
              code: "AP_SR/S001",
              city: "Visakhapatnam",
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // HEADER SECTIONS
  // ------------------------------------------------------

  Widget _dateHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Chip(
        label: Text("Friday, 19-Dec-2025"),
        backgroundColor: Color(0xFFEAF4FF),
      ),
      Text(
        "Last Refreshed Just Now",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );

  Widget _reportingHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text(
        "REPORTING TO ANDHRA PRADESH_SR...",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      Text(
        "ALL FIELD USER",
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ------------------------------------------------------
  // L2 POSITION CARD
  // ------------------------------------------------------

  Widget _l2Card() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userHeader(
          name: "you",
          code: "(Andhra Pradesh_SR_E...)",
          city: "VIJAYAWADA",
        ),
        const SizedBox(height: 8),
        _tag("Others"),
        const SizedBox(height: 6),
        _locationRow("Rcp meet at Gudivada"),
      ],
    ),
  );

  // ------------------------------------------------------
  // L1 POSITION CARD (DETAILED)
  // ------------------------------------------------------

  Widget _l1Card() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userHeader(
          name: "Karanki Seetharamanjan...",
          code: "(AP_SR/S001)",
          city: "RAJAHMUNDRY",
        ),
        const SizedBox(height: 8),
        _tag("Retailing"),
        const SizedBox(height: 6),
        _locationRow(
          "DEVI CHOWK - Govardhana Agencies (RCP), Rajahmundry",
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statBlock("10:29 AM", "Log In"),
            _statBlock("11:13 AM", "First Call"),
            _statBlock("0", "First PC"),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statBlock("44", "SC"),
            _statBlock("7", "TC"),
            _statBlock("0", "PC"),
          ],
        ),
      ],
    ),
  );

  // ------------------------------------------------------
  // SIMPLE L1 CARD
  // ------------------------------------------------------

  Widget _simpleL1Card({
    required String name,
    required String code,
    required String city,
  }) =>
      _card(
        child: _userHeader(
          name: name,
          code: "($code)",
          city: city,
        ),
      );

  // ------------------------------------------------------
  // COMMON UI WIDGETS
  // ------------------------------------------------------

  Widget _card({required Widget child}) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );

  Widget _userHeader({
    required String name,
    required String code,
    required String city,
  }) =>
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
                    fontSize: 15,
                  ),
                ),
                Text(
                  code,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                city,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  _CircleIcon(Icons.chat),
                  SizedBox(width: 8),
                  _CircleIcon(Icons.call),
                ],
              )
            ],
          ),
        ],
      );

  Widget _tag(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );

  Widget _locationRow(String text) => Row(
    children: [
      const Icon(Icons.location_on, size: 16, color: Colors.grey),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ],
  );

  Widget _statBlock(String value, String label) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}

// ------------------------------------------------------
// CIRCULAR ICON BUTTON
// ------------------------------------------------------

class _CircleIcon extends StatelessWidget {
  final IconData icon;

  const _CircleIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFEAF4FF),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: Colors.blue),
    );
  }
}
