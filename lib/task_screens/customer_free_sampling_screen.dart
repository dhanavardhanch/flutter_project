import 'package:flutter/material.dart';
import '../activity_logger.dart';

class CustomerFreeSamplingScreen extends StatefulWidget {
  final String taskTitle;
  const CustomerFreeSamplingScreen({super.key, required this.taskTitle});

  @override
  State<CustomerFreeSamplingScreen> createState() =>
      _CustomerFreeSamplingScreenState();
}

class _CustomerFreeSamplingScreenState extends State<CustomerFreeSamplingScreen> {
  final TextEditingController qtyController = TextEditingController();

  void saveForm() {
    if (qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter sampling quantity"), backgroundColor: Colors.red),
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
    ActivityLogger.add(widget.taskTitle, "Opened Customer Sampling", "task_open");

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
