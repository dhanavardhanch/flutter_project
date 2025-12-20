import 'package:flutter/material.dart';
import 'add_superstockist_kyc.dart';

class AddSuperStockistBusinessScreen extends StatelessWidget {
  const AddSuperStockistBusinessScreen({super.key});

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
            const Text(
              "Add Super Stockist",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _step(true),
                _line(),
                _step(false),
                _line(),
                _step(false),
              ],
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 SECTION TITLE (THIS WAS MISSING)
            const Text(
              "Business Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            _field("Business Name"),
            _field("Owner Name"),
            _field("Phone Number"),
            _field("Email Address"),
            _dropdown("City", ["Mumbai", "Delhi", "Bangalore"]),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddSuperStockistKYCScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STEP INDICATOR =================

  static Widget _step(bool active) => CircleAvatar(
    radius: 6,
    backgroundColor: active ? Colors.white : Colors.white54,
  );

  static Widget _line() =>
      Container(width: 22, height: 2, color: Colors.white54);

  // ================= INPUT FIELDS =================

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

  Widget _dropdown(String label, List<String> items) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      onChanged: (_) {},
    ),
  );
}
