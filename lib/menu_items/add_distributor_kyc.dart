import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'add_distributor_bank.dart';

class AddDistributorKYCScreen extends StatefulWidget {
  const AddDistributorKYCScreen({super.key});

  @override
  State<AddDistributorKYCScreen> createState() =>
      _AddDistributorKYCScreenState();
}

class _AddDistributorKYCScreenState extends State<AddDistributorKYCScreen> {
  File? gstImage;
  File? panImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isGst) async {
    final XFile? img =
    await _picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        if (isGst) {
          gstImage = File(img.path);
        } else {
          panImage = File(img.path);
        }
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
            const Text("Add Distributor"),
            const SizedBox(height: 6),
            Row(
              children: [
                _dot(false),
                _line(),
                _dot(true),
                _line(),
                _dot(false),
                _line(),
                _dot(false),
              ],
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "KYC Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),

            _field("GST Number"),
            _uploadTile(
              title: "GST Certificate",
              file: gstImage,
              onTap: () => _pickImage(true),
            ),

            const SizedBox(height: 12),

            _field("PAN Number"),
            _uploadTile(
              title: "PAN Card",
              file: panImage,
              onTap: () => _pickImage(false),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddDistributorBankScreen(),
                    ),
                  );
                },
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  static Widget _dot(bool active) => CircleAvatar(
    radius: 6,
    backgroundColor: active ? Colors.white : Colors.white54,
  );

  static Widget _line() =>
      Container(width: 20, height: 2, color: Colors.white54);

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

  Widget _uploadTile({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          file == null ? "Upload" : file.path.split('/').last,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: const Text("Upload"),
        ),
      ),
    );
  }
}
