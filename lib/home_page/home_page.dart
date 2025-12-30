import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../selection/select_beat_screen.dart';
import 'official_work_screen.dart';
import 'mark_leave_screen.dart';
import 'home_page_menu.dart';
import '../notifications/notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentDate = "";
  String currentTime = "";
  Timer? timeUpdater;

  @override
  void initState() {
    super.initState();
    _updateDateTime();

    timeUpdater = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) _updateDateTime();
    });
  }

  @override
  void dispose() {
    timeUpdater?.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = DateTime.now().toLocal();
    setState(() {
      currentDate = DateFormat("E, dd-MMM-yyyy").format(now);
      currentTime = DateFormat("hh:mm a").format(now);
    });
  }

  Widget actionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: const Color(0xFF00AEEF)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomePageMenu(),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7FBFE),
              Color(0xFFEAF3FA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Drawer Menu
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: const Icon(
                          Icons.menu,
                          size: 32,
                          color: Color(0xFF00AEEF),
                        ),
                      ),
                    ),

                    // Logo
                    Image.asset(
                      'assets/images/TrooGood_Logo.png',
                      height: 40,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_none,
                        size: 30,
                        color: Color(0xFF00AEEF),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- DATE + TIME CARD ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          color: Color(0xFF005F8F), size: 32),
                      const SizedBox(width: 14),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentDate,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentTime,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- ILLUSTRATION + TEXT ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      "Welcome! Ready to make healthy snacking reach every corner?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      height: 210,
                      child: Lottie.asset(
                        'assets/Animations/homepageanime.json',
                        repeat: true,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ---------------- BUTTONS ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    actionCard(
                      icon: Icons.shopping_bag,
                      title: "Merchandising",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SelectBeatScreen()),
                        );
                      },
                    ),
                    actionCard(
                      icon: Icons.work_outline,
                      title: "Official Work",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OfficialWorkScreen()),
                        );
                      },
                    ),
                    actionCard(
                      icon: Icons.event_available,
                      title: "Mark Leave / Weekly Off",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MarkLeaveScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
