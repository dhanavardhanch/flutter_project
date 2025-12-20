import 'dart:async';
import 'package:flutter/material.dart';
import '../home_page/home_page.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';

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

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      setState(() {
        taglineIndex++;
        progress = (taglineIndex + 1) / taglines.length;
      });

      if (taglineIndex >= taglines.length - 1) {
        timer.cancel();

        Future.delayed(const Duration(seconds: 1), () async {
          final token = await AuthService.getToken();

          if (!mounted) return;

          if (token != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      }
    });
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
              'assets/TrooGood_Logo.png',
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
