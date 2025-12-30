import 'package:flutter/material.dart';
import '../store_dashboard/store_dashboard_menu.dart';
import '../store_dashboard/store_dashboard_stock.dart';
import '../store_dashboard/store_dashboard_purchaseorder.dart';
import '../store_dashboard/store_dashboard_task.dart';
import '../notifications/notification_screen.dart';
import 'package:tg_app/activity_logger.dart';
import '../selection/select_outlet_screen.dart';


class StoreDashboardScreen extends StatefulWidget {
  final int storeId;
  final String outletName;
  final String beatName;

  const StoreDashboardScreen({
    super.key,
    required this.storeId,
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
    ActivityLogger.addStoreVisit(widget.outletName);

  }

  Widget dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    double height = 110,
    bool fullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null, // ✅ FORCE FULL WIDTH
        height: height,
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
            Icon(icon, size: 36, color: Colors.blue.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
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
      backgroundColor: Colors.blue.shade50,

      body: SafeArea(
        child: Column(
          children: [
            // 🔵 TOP BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              color: Colors.blue.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: const Icon(Icons.menu, size: 28),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        widget.outletName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.beatName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🔴 STORE OUT
            GestureDetector(
              onTap: () {
                ActivityLogger.storeOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectOutletScreen(
                      beatName: widget.beatName,
                      fromChangeOutlet: false,
                    ),
                  ),
                      (_) => false,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.red.shade600,
                child: const Center(
                  child: Text(
                    "Store Out",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),

            // 🟡 CENTER AREA (LOGO)
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/TrooGood_Logo.png",
                  width: 160,
                ),
              ),
            ),

            // 🔘 BUTTON SECTION (BOTTOM)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
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
                                  outletName: widget.outletName,
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
                          label: "PURCHASE ORDER",
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

                  const SizedBox(height: 16),

                  // ✅ FULL-WIDTH TASK BUTTON
                  dashboardButton(
                    icon: Icons.task_alt,
                    label: "TASK",
                    height: 120,
                    fullWidth: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StoreDashboardTaskScreen(
                            storeId: widget.storeId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔄 REFRESH
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade300,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 20),
                  SizedBox(width: 8),
                  Text("REFRESH"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
