import 'package:flutter/material.dart';

class MyRequestScreen extends StatelessWidget {
  const MyRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Request"),
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
              const Text(
                "Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444)),
              ),
              const SizedBox(height: 12),
              _requestCard("PO Approval", "Request raised for PO #12345"),
              const SizedBox(height: 12),
              _requestCard("Stock Refill", "Request for product refill"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,3))],
      ),
      child: Row(
        children: [
          const Icon(Icons.request_page, color: Color(0xFF00AEEF), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
