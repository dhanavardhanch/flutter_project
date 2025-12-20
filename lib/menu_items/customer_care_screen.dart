import 'package:flutter/material.dart';

class CustomerCareScreen extends StatelessWidget {
  const CustomerCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Care"),
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
              const Text("Contact Support", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
              const SizedBox(height: 12),
              _supportCard("Helpline", "+91 1800-XXX-XXXX"),
              const SizedBox(height: 12),
              _supportCard("Email", "support@troogood.com"),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  // TODO: implement call or email action
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00AEEF)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text("Contact Support"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _supportCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0,3))],
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, color: Color(0xFF00AEEF), size: 30),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ])),
        ],
      ),
    );
  }
}
