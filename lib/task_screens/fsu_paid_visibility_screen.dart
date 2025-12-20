import 'package:flutter/material.dart';
import '../activity_logger.dart';

class FSUPaidVisibilityScreen extends StatefulWidget {
  final String taskTitle;
  const FSUPaidVisibilityScreen({super.key, required this.taskTitle});

  @override
  State<FSUPaidVisibilityScreen> createState() => _FSUPaidVisibilityScreenState();
}

class _FSUPaidVisibilityScreenState extends State<FSUPaidVisibilityScreen> {
  final TextEditingController notesController = TextEditingController();

  void saveForm() {
    ActivityLogger.addTask(widget.taskTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("FSU Paid visibility saved!"), backgroundColor: Colors.green),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) Navigator.pop(context); // FIXED
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivityLogger.add(widget.taskTitle, "Opened FSU Paid Visibility", "task_open");

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
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Notes",
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
