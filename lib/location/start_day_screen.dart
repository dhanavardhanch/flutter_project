import 'package:flutter/material.dart';
import 'current_location_screen.dart';
import 'package:tg_app/activity_logger.dart';

class StartDayScreen extends StatelessWidget {
  final String outletName;
  final String beatName;

  const StartDayScreen({
    super.key,
    required this.outletName,
    required this.beatName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Start your Day",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/TrooGood_Logo.png", width: 220),
            const SizedBox(height: 40),
            const Icon(Icons.location_on, color: Colors.red, size: 90),
            const SizedBox(height: 20),
            const Text(
              "Start app when at a store",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),

      bottomNavigationBar: GestureDetector(
        onTap: () {

          // ⭐ REQUIRED FOR MIS → Count store visit
          ActivityLogger.addStoreVisit(outletName);

          // Log that day has started
          ActivityLogger.add("Day Start", "User started the day", "start");

          // Redirect to Current Location screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CurrentLocationScreen(
                outletName: outletName,
                beatName: beatName,
              ),
            ),
          );
        },

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          color: Colors.blue.shade700,
          child: const Text(
            "I AM AT STORE →",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
