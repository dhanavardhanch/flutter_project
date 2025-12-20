import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tg_app/store_dashboard/store_dashboard_screen.dart';


class PreviewSelfieScreen extends StatelessWidget {
  final String imagePath;
  final LatLng location;
  final String outletName;
  final String beatName;

  const PreviewSelfieScreen({
    super.key,
    required this.imagePath,
    required this.location,
    required this.outletName,
    required this.beatName,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Preview", style: TextStyle(color: Colors.black)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade700, width: 4),
              ),
              child: Stack(
                children: [
                  Image.file(
                    File(imagePath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Date: ${now.day}-${now.month}-${now.year} | "
                            "Time: ${now.hour}:${now.minute}\n"
                            "Lat: ${location.latitude}, Lng: ${location.longitude}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Retake
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
              // Save & Proceed
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoreDashboardScreen(
                        outletName: outletName,
                        beatName: beatName,
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
