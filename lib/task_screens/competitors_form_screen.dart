import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../activity_logger.dart';

class CompetitorsFormScreen extends StatefulWidget {
  final String taskTitle;
  const CompetitorsFormScreen({super.key, required this.taskTitle});

  @override
  State<CompetitorsFormScreen> createState() => _CompetitorsFormScreenState();
}

class _CompetitorsFormScreenState extends State<CompetitorsFormScreen> {
  File? frontImage;
  File? backImage;
  String otherType = "";
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(bool isFront) async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        if (isFront) {
          frontImage = File(image.path);
        } else {
          backImage = File(image.path);
        }
      });

      ActivityLogger.add(
        widget.taskTitle,
        isFront ? "Captured Front Image" : "Captured Back Image",
        "capture",
      );
    }
  }

  void saveForm() async {
    if (frontImage == null || backImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please capture both front & back images"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Log task completed
    ActivityLogger.addTask(widget.taskTitle);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task Saved Successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // ✅ FIXED: Only pop. DO NOT PUSH ANY SCREEN.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ActivityLogger.add(widget.taskTitle, "Opened Competitor Form", "task_open");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            ActivityLogger.add(widget.taskTitle, "Closed Form", "task_close");
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(widget.taskTitle, style: const TextStyle(color: Colors.black)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCaptureButton("Front Image", frontImage, () => pickImage(true)),
            const SizedBox(height: 20),
            buildCaptureButton("Back Image", backImage, () => pickImage(false)),
            const SizedBox(height: 20),
            buildTextField(),
            const SizedBox(height: 30),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget buildCaptureButton(String title, File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Icon(Icons.camera_alt, color: file == null ? Colors.black54 : Colors.green),
            const SizedBox(width: 12),
            Text(
              file == null ? "$title - TAKE PHOTO" : "$title Added",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField() {
    return TextField(
      onChanged: (value) => otherType = value,
      decoration: InputDecoration(
        labelText: "Other Type",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: saveForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00AEEF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          "SAVE",
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
