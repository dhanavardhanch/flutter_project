import 'package:flutter/material.dart';
import '../activity_logger.dart';

class AKAMJointWorkingScreen extends StatefulWidget {
  final String taskTitle;
  const AKAMJointWorkingScreen({super.key, required this.taskTitle});

  @override
  State<AKAMJointWorkingScreen> createState() => _AKAMJointWorkingScreenState();
}

class _AKAMJointWorkingScreenState extends State<AKAMJointWorkingScreen> {
  final TextEditingController remarksController = TextEditingController();

  void saveForm() {
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
    ActivityLogger.add(widget.taskTitle, "Opened AKAM Joint Working", "task_open");

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
              controller: remarksController,
              decoration: const InputDecoration(
                labelText: "Remarks",
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
