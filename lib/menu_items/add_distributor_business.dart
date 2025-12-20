import 'package:flutter/material.dart';
import 'add_distributor_kyc.dart';

class AddDistributorBusinessScreen extends StatelessWidget {
  const AddDistributorBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add Distributor"),
            const SizedBox(height: 6),
            Row(
              children: [
                _dot(true),
                _line(),
                _dot(false),
                _line(),
                _dot(false),
                _line(),
                _dot(false),
              ],
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Business Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),

            _field("Distributor Name"),
            _field("Owner Name"),
            _field("Phone Number"),
            _field("Email Address"),
            _field("City"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddDistributorKYCScreen(),
                    ),
                  );
                },
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  static Widget _dot(bool active) => CircleAvatar(
    radius: 6,
    backgroundColor: active ? Colors.white : Colors.white54,
  );

  static Widget _line() =>
      Container(width: 20, height: 2, color: Colors.white54);

  Widget _field(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
