import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../home_page/home_page.dart';
import '../auth/login_screen.dart';
import '../services/local_storage.dart';
import '../services/network_service.dart';
import '../services/master_sync_service.dart';



class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int taglineIndex = 0;
  double progress = 0.0;

  final List<String> taglines = [
    "GOODNESS OF MILLETS,\nSNACKING MADE SIMPLE.",
    "HEALTHY SNACKS.\nHAPPY LIVES.",
    "MILLET-POWERED CRUNCH,\nEVERYDAY.",
    "SNACK SMART —\nTASTE GOOD, FEEL GOOD.",
  ];

  late Timer _timer;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();

    _startTime = DateTime.now();
    _startAnimation();
    _initializeApp();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;

      setState(() {
        taglineIndex++;
        progress = (taglineIndex + 1) / taglines.length;
      });

      if (taglineIndex >= taglines.length - 1) {
        timer.cancel();
      }
    });
  }

  Future<void> _initializeApp() async {
    // Small delay so UI doesn’t feel rushed
    await Future.delayed(const Duration(seconds: 3));

    // 1️⃣ Check login
    final isLoggedIn = await LocalStorage.isLoggedIn();

    if (!isLoggedIn) {
      _logPerformance();
      _goTo(const LoginScreen());
      return;
    }

    // 2️⃣ Check internet
    final hasInternet = await NetworkService.hasInternet();

    if (hasInternet) {
      try {
        // 3️⃣ Master data sync (ONLINE)
        await MasterSyncService.syncAll(
          sellerId: 5, // TODO: replace with logged-in seller ID
        );
      } catch (e) {
        log("Master sync failed: $e");
      }
    } else {
      log("Offline mode: using cached master data");
    }

    // 4️⃣ Performance log
    _logPerformance();

    // 5️⃣ Navigate to Home
    _goTo(const HomePage());
  }

  void _logPerformance() {
    final endTime = DateTime.now();
    final duration =
        endTime.difference(_startTime).inMilliseconds;

    log("🚀 App load time: ${duration}ms");
  }

  void _goTo(Widget page) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/TrooGood_Logo.png',
              width: 180,
            ),

            const SizedBox(height: 30),

            const Text(
              "Where",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Container(
              height: 3,
              width: 90,
              color: Colors.blueAccent,
            ),

            const SizedBox(height: 30),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Text(
                taglines[taglineIndex],
                key: ValueKey(taglines[taglineIndex]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue,
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 40),

            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0, end: progress),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  minHeight: 6,
                  value: value,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
