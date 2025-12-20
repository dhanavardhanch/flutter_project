import 'package:flutter/material.dart';

class SendPOWhatsappScreen extends StatelessWidget {
  const SendPOWhatsappScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send PO via WhatsApp"),
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
              const Text("Send Purchase Order", style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444))),
              const SizedBox(height: 12),
              _contactCard("Alpha Mart", "+91 98765 43210"),
              const SizedBox(height: 12),
              _contactCard("Beta Store", "+91 91234 56789"),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: implement send via WhatsApp logic
                },
                icon: const Icon(Icons.send),
                label: const Text("Send Selected PO"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEEF),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard(String name, String phone) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.phone_android, color: Color(0xFF00AEEF), size: 28),
          const SizedBox(width: 12),

          Expanded(
            child: Text("$name\n$phone",
                style: const TextStyle(fontSize: 14)),
          ),

          Icon(Icons.chat_bubble, color: Colors.green, size: 26),
        ],
      ),
    );
  }
}