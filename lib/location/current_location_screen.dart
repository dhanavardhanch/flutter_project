import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tg_app/selfie/selfie_camera_screen.dart';
import 'package:tg_app/activity_logger.dart';

class CurrentLocationScreen extends StatefulWidget {
  final int storeId;          // ✅ ADDED
  final String outletName;
  final String beatName;
  final bool showLoader;

  const CurrentLocationScreen({
    super.key,
    required this.storeId,    // ✅ REQUIRED
    required this.outletName,
    required this.beatName,
    this.showLoader = true,
  });

  @override
  State<CurrentLocationScreen> createState() =>
      _CurrentLocationScreenState();
}

class _CurrentLocationScreenState
    extends State<CurrentLocationScreen> {
  LatLng? userLatLng;
  double accuracy = 0;
  bool mapReady = false;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 🧾 LOG LOCATION
    ActivityLogger.add(
      "Location Fetched",
      "Lat: ${position.latitude}, "
          "Lng: ${position.longitude}, "
          "Accuracy: ${position.accuracy}m",
      "location",
    );

    setState(() {
      userLatLng = LatLng(position.latitude, position.longitude);
      accuracy = position.accuracy;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => mapReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Current Location",
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            ActivityLogger.add(
              "Back from Location",
              "User returned from Current Location screen",
              "navigation",
            );
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: (!mapReady)
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 180,
              child: Lottie.asset(
                "assets/lottie/globe.json",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Fetching your location...",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLatLng!,
              zoom: 17,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),

          // ✅ CONFIRM LOCATION
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                ActivityLogger.add(
                  "Location Confirmed",
                  "Accuracy: ${accuracy.toInt()}m | "
                      "Outlet: ${widget.outletName}",
                  "location",
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelfieCameraScreen(
                      storeId: widget.storeId, // ✅ FIXED
                      outletName: widget.outletName,
                      beatName: widget.beatName,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.blue.shade700,
                child: Text(
                  "CONFIRM LOCATION "
                      "(${accuracy.toInt()} m) →",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
