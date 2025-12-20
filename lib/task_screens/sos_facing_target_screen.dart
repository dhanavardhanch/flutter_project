import 'package:flutter/material.dart';
import '../activity_logger.dart';

class SOSFacingTargetScreen extends StatefulWidget {
  final String taskTitle;
  const SOSFacingTargetScreen({super.key, required this.taskTitle});

  @override
  State<SOSFacingTargetScreen> createState() => _SOSFacingTargetScreenState();
}

class _SOSFacingTargetScreenState extends State<SOSFacingTargetScreen> {
  final TextEditingController controller = TextEditingController();

  void saveForm() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter SOS facing value"), backgroundColor: Colors.red),
      );
      return;
    }

    ActivityLogger.addTask(widget.taskTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved successfully!"), backgroundColor: Colors.green),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pop(context); // FIXED
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivityLogger.add(widget.taskTitle, "Opened SOS Facing Target", "task_open");

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
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter Facing Count",
                border: OutlineInputBorder(),
              ),
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
