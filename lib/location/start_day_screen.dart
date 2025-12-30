import 'package:flutter/material.dart';
import 'current_location_screen.dart';
import 'package:tg_app/activity_logger.dart';

class StartDayScreen extends StatelessWidget {
  final int storeId;        // ✅ ADDED
  final String outletName;
  final String beatName;

  const StartDayScreen({
    super.key,
    required this.storeId,  // ✅ REQUIRED
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
            Image.asset(
              "assets/images/TrooGood_Logo.png",
              width: 220,
            ),
            const SizedBox(height: 40),
            const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 90,
            ),
            const SizedBox(height: 20),
            const Text(
              "Start app when at a store",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: GestureDetector(
        onTap: () {
          // ⭐ MIS: store visit
          ActivityLogger.addStoreVisit(outletName);

          // 🟢 Day start log
          ActivityLogger.add(
            "Day Start",
            "User started the day at $outletName",
            "start",
          );

          // ✅ PASS storeId CORRECTLY
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CurrentLocationScreen(
                storeId: storeId,        // ✅ FIXED
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
