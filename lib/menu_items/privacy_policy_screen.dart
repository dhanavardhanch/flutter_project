import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
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
          child: ListView(
            children: const [
              Text("Privacy Policy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF444444))),
              SizedBox(height: 12),
              Text(
                "This is a placeholder privacy policy. Replace this content with your actual policy. "
                    "Describe how user data is handled, storage locations, third-party services, permissions, and contact details.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text("1. Data Collection", style: TextStyle(fontWeight: FontWeight.w600)),
              Text("We collect only necessary information to provide the service."),
              SizedBox(height: 8),
              Text("2. Data Usage", style: TextStyle(fontWeight: FontWeight.w600)),
              Text("Data is used to improve app experience and for service functionality."),
            ],
          ),
        ),
      ),
    );
  }
}
