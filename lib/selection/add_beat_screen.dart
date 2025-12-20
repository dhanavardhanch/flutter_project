import 'package:flutter/material.dart';
import '../activity_logger.dart';

class AddBeatScreen extends StatefulWidget {
  final String? initialBeatName; // 🔹 null = add, value = edit

  const AddBeatScreen({super.key, this.initialBeatName});

  @override
  State<AddBeatScreen> createState() => _AddBeatScreenState();
}

class _AddBeatScreenState extends State<AddBeatScreen> {
  final TextEditingController beatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialBeatName != null) {
      beatController.text = widget.initialBeatName!;
    }
  }

  void _saveBeat() async {
    final beatName = beatController.text.trim();

    if (beatName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Beat Name")),
      );
      return;
    }

    // Save / update in storage
    await ActivityLogger.addBeat(beatName);

    // Return updated beat name
    Navigator.pop(context, beatName);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialBeatName != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Beat" : "Add Beat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: beatController,
              decoration: const InputDecoration(
                labelText: "Beat Name",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBeat,
                child: Text(isEdit ? "Update Beat" : "Save Beat"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
