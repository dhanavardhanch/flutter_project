import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'preview_selfie_screen.dart';

class SelfieCameraScreen extends StatefulWidget {
  final LatLng location;
  final String outletName;
  final String beatName;

  const SelfieCameraScreen({
    super.key,
    required this.location,
    required this.outletName,
    required this.beatName,
  });

  @override
  State<SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<SelfieCameraScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front);

    controller = CameraController(front, ResolutionPreset.medium);
    await controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final picture = await controller!.takePicture();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PreviewSelfieScreen(
                      imagePath: picture.path,
                      location: widget.location,
                      outletName: widget.outletName,
                      beatName: widget.beatName,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
