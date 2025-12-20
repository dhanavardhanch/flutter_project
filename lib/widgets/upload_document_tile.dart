import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentTile extends StatefulWidget {
  final String title;
  final String subtitle;

  const UploadDocumentTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<UploadDocumentTile> createState() => _UploadDocumentTileState();
}

class _UploadDocumentTileState extends State<UploadDocumentTile> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade100),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // PREVIEW
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue.shade50,
              image: _image != null
                  ? DecorationImage(
                image: FileImage(_image!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: _image == null
                ? const Icon(Icons.insert_drive_file,
                color: Colors.blue, size: 28)
                : null,
          ),

          const SizedBox(width: 12),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _image != null
                      ? _image!.path.split('/').last
                      : widget.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: _image != null ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // UPLOAD BUTTON
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload, size: 18),
            label: const Text("Upload"),
          ),
        ],
      ),
    );
  }
}
