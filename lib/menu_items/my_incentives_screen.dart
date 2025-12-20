import 'package:flutter/material.dart';

class MyIncentivesScreen extends StatelessWidget {
  const MyIncentivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Incentives"),
        backgroundColor: const Color(0xFF00AEEF),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FBFE), Color(0xFFEAF3FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Incentives Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
              const SizedBox(height: 12),
              _incentiveCard("Monthly Target Achieved", "₹ 5,000"),
              const SizedBox(height: 12),
              _incentiveCard("Festival Bonus", "₹ 2,000"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _incentiveCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,3))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00AEEF))),
        ],
      ),
    );
  }
}
