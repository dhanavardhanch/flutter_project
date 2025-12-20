import 'package:flutter/material.dart';

class ViewPurchaseOrderScreen extends StatelessWidget {
  const ViewPurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Purchase Order"),
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
              const Text("Recent POs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
              const SizedBox(height: 12),
              _poCard("PO #12345", "Pending - ₹ 12,500"),
              const SizedBox(height: 12),
              _poCard("PO #12344", "Delivered - ₹ 8,300"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _poCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,3))],
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag, color: Color(0xFF00AEEF), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
