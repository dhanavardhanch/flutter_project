import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'preview_selfie_screen.dart';


class SelfieCameraScreen extends StatefulWidget {
  final int storeId;               // ✅ ADDED
  final String outletName;
  final String beatName;

  const SelfieCameraScreen({
    super.key,
    required this.storeId,         // ✅ ADDED
    required this.outletName,
    required this.beatName,
  });

  @override
  State<SelfieCameraScreen> createState() => _SelfieCameraScreenState();
}

class _SelfieCameraScreenState extends State<SelfieCameraScreen> {
  CameraController? controller;
  LatLng? currentLocation;
  bool loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    await _fetchLocation();
    await _initCamera();
  }

  // 📍 FETCH GPS LOCATION
  Future<void> _fetchLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() => loadingLocation = false);
    }
  }

  // 📷 INIT CAMERA
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final frontCamera =
    cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    controller =
        CameraController(frontCamera, ResolutionPreset.medium);
    await controller!.initialize();

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null ||
        !controller!.value.isInitialized ||
        loadingLocation ||
        currentLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(controller!),

          // 📍 INFO OVERLAY
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.outletName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lat: ${currentLocation!.latitude.toStringAsFixed(5)}, "
                        "Lng: ${currentLocation!.longitude.toStringAsFixed(5)}",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // 📸 CAPTURE
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
                      location: currentLocation!,
                      storeId: widget.storeId,      // ✅ FIX
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
