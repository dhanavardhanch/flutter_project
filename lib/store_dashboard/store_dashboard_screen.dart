// lib/store_dashboard/store_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../store_dashboard/store_dashboard_menu.dart';
import '../store_dashboard/store_dashboard_stock.dart';
import '../store_dashboard/store_dashboard_purchaseorder.dart';
import '../store_dashboard/store_dashboard_task.dart';
import '../notifications/notification_screen.dart';
import 'package:tg_app/activity_logger.dart';
import '../selection/select_outlet_screen.dart';

class StoreDashboardScreen extends StatefulWidget {
  final String outletName;
  final String beatName;

  const StoreDashboardScreen({
    super.key,
    required this.outletName,
    required this.beatName,
  });

  @override
  State<StoreDashboardScreen> createState() => _StoreDashboardScreenState();
}

class _StoreDashboardScreenState extends State<StoreDashboardScreen> {
  @override
  void initState() {
    super.initState();

    /// ⭐ Always log store visit when user enters dashboard
    ActivityLogger.addStoreVisit(widget.outletName);
  }

  // ---------- REUSABLE BUTTON ----------
  Widget dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.blue.shade300, width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 6,
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: Colors.blue.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StoreDashboardMenu(
        outletName: widget.outletName,
        beatName: widget.beatName,
      ),
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF2F8FF),
                Color(0xFFE9F3FF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Column(
            children: [
              // ---------------- HEADER ----------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        return GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: const Icon(Icons.menu, size: 30),
                        );
                      },
                    ),

                    Column(
                      children: [
                        Text(
                          widget.outletName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.beatName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications_none,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- STORE OUT ----------------
              GestureDetector(
                onTap: () {
                  ActivityLogger.storeOut();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => SelectOutletScreen(
                        beatName: widget.beatName,
                        fromChangeOutlet: false,
                      ),
                    ),
                        (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.red.shade600,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Store Out",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.power_settings_new, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- LOGO ----------------
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/TrooGood_Logo.png",
                    width: 170,
                  ),
                ),
              ),

              // ---------------- BUTTONS ----------------
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // STOCK + PURCHASE ORDER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: dashboardButton(
                              icon: Icons.inventory_2,
                              label: "STOCK",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoreDashboardStock(
                                      outletName: widget.outletName,   // ⭐ FIXED
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: dashboardButton(
                              icon: Icons.shopping_cart,
                              label: "PURCHASE\nORDER",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const StoreDashboardPurchaseOrderScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // TASK BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: dashboardButton(
                              icon: Icons.task_alt,
                              label: "TASK",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const StoreDashboardTaskScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),

              // ---------------- REFRESH ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.refresh, size: 22),
                    SizedBox(width: 10),
                    Text("REFRESH", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
