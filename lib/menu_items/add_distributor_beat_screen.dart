import 'package:flutter/material.dart';

class AddDistributorBeatScreen extends StatelessWidget {
  const AddDistributorBeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Add Beat",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field("Beat Name"),
            _field("City"),
            _field("Area / Locality"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context); // back to beat list
                },
                child: const Text("Add Beat"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
