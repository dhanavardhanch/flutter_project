import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 🔥 IMPORTANT: import your list screen
import 'manager_superstockist_list.dart';

class AddSuperStockistBankScreen extends StatefulWidget {
  const AddSuperStockistBankScreen({super.key});

  @override
  State<AddSuperStockistBankScreen> createState() =>
      _AddSuperStockistBankScreenState();
}

class _AddSuperStockistBankScreenState
    extends State<AddSuperStockistBankScreen> {
  File? chequeImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickCheque() async {
    final XFile? img =
    await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        chequeImage = File(img.path);
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
            const Text(
              "Add Super Stockist",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _step(false),
                _line(),
                _step(false),
                _line(),
                _step(true), // ✅ STEP 3 ACTIVE
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
              "Bank Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 14),

            _field("Bank Name"),
            _field("Account Number"),
            _field("Confirm Account Number"),
            _field("IFSC Code"),

            const SizedBox(height: 10),

            _uploadTile(
              title: "Cancelled Cheque",
              file: chequeImage,
              onTap: pickCheque,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  // ✅ FINAL REDIRECT TO LIST SCREEN
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) =>
                      const ManagerSuperStockistListScreen(),
                    ),
                        (route) => false,
                  );
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  static Widget _step(bool active) => CircleAvatar(
    radius: 6,
    backgroundColor: active ? Colors.white : Colors.white54,
  );

  static Widget _line() =>
      Container(width: 22, height: 2, color: Colors.white54);

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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt, color: Colors.blue),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              file == null
                  ? "Upload $title"
                  : file.path.split('/').last,
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
}
