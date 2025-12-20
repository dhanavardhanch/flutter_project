import 'package:flutter/material.dart';
import '../activity_logger.dart';

class AddOutletScreen extends StatefulWidget {
  final String beatName;
  final Map<String, String>? initialOutlet; // 🔹 null = add, value = edit

  const AddOutletScreen({
    super.key,
    required this.beatName,
    this.initialOutlet,
  });

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  final TextEditingController outletController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialOutlet != null) {
      outletController.text = widget.initialOutlet!["name"] ?? "";
      cityController.text = widget.initialOutlet!["city"] ?? "";
    }
  }

  void _saveOutlet() async {
    final outletName = outletController.text.trim();
    final city = cityController.text.trim();

    if (outletName.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Outlet & City required")),
      );
      return;
    }

    final outletData = {
      "name": outletName,
      "city": city,
    };

    // Save / update in storage
    await ActivityLogger.addOutlet(widget.beatName, outletData);

    // Return updated outlet
    Navigator.pop(context, outletData);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialOutlet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Outlet" : "Add Outlet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Beat: ${widget.beatName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: outletController,
              decoration: const InputDecoration(
                labelText: "Outlet Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveOutlet,
                child: Text(isEdit ? "Update Outlet" : "Save Outlet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
