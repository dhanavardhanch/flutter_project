import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'add_superstockist_bank.dart';

class AddSuperStockistKYCScreen extends StatefulWidget {
  const AddSuperStockistKYCScreen({super.key});

  @override
  State<AddSuperStockistKYCScreen> createState() =>
      _AddSuperStockistKYCScreenState();
}

class _AddSuperStockistKYCScreenState
    extends State<AddSuperStockistKYCScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController gstController = TextEditingController();
  final TextEditingController panController = TextEditingController();

  File? panCardImage;
  File? addressProofImage;

  Future<void> pickImage(bool isPan) async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        isPan
            ? panCardImage = File(image.path)
            : addressProofImage = File(image.path);
      });
    }
  }

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
            const Text("Add Super Stockist", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Row(
              children: [
                _step(false),
                _line(),
                _step(true), // ✅ STEP 2 ACTIVE
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
            const Text(
              "KYC Documents",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 14),

            _field(gstController, "GST Number"),
            _field(panController, "PAN Number"),

            const SizedBox(height: 14),

            _uploadTile("PAN Card", panCardImage, () => pickImage(true)),
            const SizedBox(height: 12),
            _uploadTile("Address Proof", addressProofImage, () => pickImage(false)),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddSuperStockistBankScreen(),
                    ),
                  );
                },
                child: const Text("Next", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  static Widget _step(bool active) => CircleAvatar(
    radius: 6,
    backgroundColor: active ? Colors.white : Colors.white54,
  );

  static Widget _line() =>
      Container(width: 22, height: 2, color: Colors.white54);

  Widget _field(TextEditingController c, String label) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  Widget _uploadTile(String title, File? file, VoidCallback onTap) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      children: [
        const Icon(Icons.insert_drive_file, color: Colors.blue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            file == null ? "$title upload" : file.path.split('/').last,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.upload, size: 18),
          label: const Text("Upload"),
        ),
      ],
    ),
  );
}
