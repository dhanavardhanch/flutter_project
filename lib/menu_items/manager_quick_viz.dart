import 'package:flutter/material.dart';

class ManagerQuickVizScreen extends StatelessWidget {
  const ManagerQuickVizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Image.asset(
          'assets/TrooGood_Logo.png',
          height: 38,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          _QuickVizTile(
            title: "SO/SR Performance MTD",
            subtitle: "MTD",
          ),
          _QuickVizTile(
            title: "Month on Month Comparison",
            subtitle: "Last 3 Months",
          ),
          _QuickVizTile(
            title: "ASM wise performance dashboard",
            subtitle: "Last 3 Months",
          ),
          _QuickVizTile(
            title: "Trend Report",
            subtitle: "MTD",
          ),
          _QuickVizTile(
            title: "jksjdj",
            subtitle: "MTD",
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------------
/// 🔹 REUSABLE LIST TILE
/// ------------------------------------------------------------
class _QuickVizTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _QuickVizTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {
          // TODO: Navigate to respective visualization screen
        },
      ),
    );
  }
}
