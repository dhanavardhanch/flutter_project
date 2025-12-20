import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'add_distributor_assign_areas.dart';

class AddDistributorBankScreen extends StatefulWidget {
  const AddDistributorBankScreen({super.key});

  @override
  State<AddDistributorBankScreen> createState() =>
      _AddDistributorBankScreenState();
}

class _AddDistributorBankScreenState extends State<AddDistributorBankScreen> {
  File? cheque;

  Future<void> pickCheque() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => cheque = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: _appBar(3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field("Bank Name"),
            _field("Account Number"),
            _field("IFSC Code"),

            Card(
              child: ListTile(
                title: const Text("Cancelled Cheque"),
                subtitle:
                Text(cheque == null ? "Upload" : cheque!.path.split('/').last),
                trailing: ElevatedButton(
                  onPressed: pickCheque,
                  child: const Text("Upload"),
                ),
              ),
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
                      builder: (_) => const AssignDistributorAreasScreen(),
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

  AppBar _appBar(int step) => AppBar(
    backgroundColor: Colors.blue,
    title: Row(children: [_dot(false), _line(), _dot(false), _line(), _dot(step == 3), _line(), _dot(false)]),
  );

  Widget _dot(bool active) =>
      CircleAvatar(radius: 6, backgroundColor: active ? Colors.white : Colors.white54);
  Widget _line() => Container(width: 20, height: 2, color: Colors.white54);

  Widget _field(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
