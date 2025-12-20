import 'package:flutter/material.dart';
import '../activity_logger.dart';

class NearExpiryTrackingScreen extends StatefulWidget {
  final String taskTitle;
  const NearExpiryTrackingScreen({super.key, required this.taskTitle});

  @override
  State<NearExpiryTrackingScreen> createState() =>
      _NearExpiryTrackingScreenState();
}

class _NearExpiryTrackingScreenState extends State<NearExpiryTrackingScreen> {
  final TextEditingController qtyController = TextEditingController();

  void saveForm() {
    if (qtyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter quantity"), backgroundColor: Colors.red),
      );
      return;
    }

    ActivityLogger.addTask(widget.taskTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved!"), backgroundColor: Colors.green),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pop(context); // FIXED
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivityLogger.add(widget.taskTitle, "Opened Near Expiry Tracking", "task_open");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskTitle, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: BackButton(color: Colors.black),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(
                labelText: "Enter Quantity",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00AEEF),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("SAVE", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
