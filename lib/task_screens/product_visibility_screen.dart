import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

import '../models/product_model.dart';
import '../services/local_storage.dart';


class ProductVisibilityScreen extends StatefulWidget {
  const ProductVisibilityScreen({super.key});

  @override
  State<ProductVisibilityScreen> createState() =>
      _ProductVisibilityScreenState();
}

class _ProductVisibilityScreenState
    extends State<ProductVisibilityScreen> {
  bool loading = true;

  List<ProductModel> products = [];
  ProductModel? selectedProduct;

  File? frontImage;
  File? backImage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // ===================================================
  // 🔥 FETCH PRODUCTS (ONLINE → OFFLINE)
  // ===================================================
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://troogood.in/api/V1/products/list"),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"];

        products =
            list.map((e) => ProductModel.fromJson(e)).toList();

        // ✅ SAVE FOR OFFLINE
        await LocalStorage.saveProducts(
          products.map((p) => p.toJson()).toList(),
        );
      } else {
        throw Exception("API failed");
      }
    } catch (_) {
      // 🔁 OFFLINE FALLBACK
      final offline = await LocalStorage.getProducts();
      products =
          offline.map((e) => ProductModel.fromJson(e)).toList();
    }

    setState(() => loading = false);
  }

  // ===================================================
  // 📸 CAMERA
  // ===================================================
  Future<void> openCamera(bool isFront) async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    final controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    await controller.initialize();

    final image = await Navigator.push<XFile?>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(controller: controller),
      ),
    );

    if (image != null) {
      setState(() {
        if (isFront) {
          frontImage = File(image.path);
        } else {
          backImage = File(image.path);
        }
      });
    }
  }

  // ===================================================
  // 💾 SAVE VISIBILITY
  // ===================================================
  void saveVisibility() {
    if (selectedProduct == null ||
        frontImage == null ||
        backImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 🔒 Here you can later upload images + product ID

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product visibility saved successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  // ===================================================
  // 🖼 IMAGE TILE
  // ===================================================
  Widget imageTile(String label, File? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image == null
            ? Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  // ===================================================
  // UI
  // ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "Product Visibility",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔽 PRODUCT DROPDOWN
            DropdownButtonFormField<ProductModel>(
              value: selectedProduct,
              hint: const Text("Select Product"),
              items: products
                  .map(
                    (p) => DropdownMenuItem<ProductModel>(
                  value: p,
                  child: Text(p.name),
                ),
              )
                  .toList(),
              onChanged: (v) =>
                  setState(() => selectedProduct = v),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // 📸 FRONT IMAGE
            imageTile(
              "Front Image - TAKE PHOTO",
              frontImage,
                  () => openCamera(true),
            ),

            // 📸 BACK IMAGE
            imageTile(
              "Back Image - TAKE PHOTO",
              backImage,
                  () => openCamera(false),
            ),

            const Spacer(),

            // 💾 SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveVisibility,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AEEF),
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "SAVE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// CAMERA CAPTURE SCREEN (UNCHANGED)
//////////////////////////////////////////////////////////////

class CameraCaptureScreen extends StatelessWidget {
  final CameraController controller;

  const CameraCaptureScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  final image = await controller.takePicture();
                  Navigator.pop(context, image);
                },
                child: const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
