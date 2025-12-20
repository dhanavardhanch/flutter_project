// lib/store_dashboard/store_dashboard_menu.dart

import 'package:flutter/material.dart';
import 'package:tg_app/activity_logger.dart';

// Home modules
import '../home_page/home_page.dart';
import '../home_page/official_work_screen.dart';

// Selection modules
import '../selection/select_beat_screen.dart';
import '../selection/select_outlet_screen.dart';

// Menu Screens
import '../menu_items/timeline_screen.dart';
import '../menu_items/daywise_summary_screen.dart';
import '../menu_items/performance_screen.dart';
import '../menu_items/pocket_mis_screen.dart';
import '../menu_items/my_request_screen.dart';
import '../menu_items/my_incentives_screen.dart';
import '../menu_items/customer_interaction_screen.dart';
import '../menu_items/external_assets_screen.dart';
import '../menu_items/view_purchase_order_screen.dart';
import '../menu_items/send_po_whatsapp_screen.dart';
import '../menu_items/privacy_policy_screen.dart';
import '../menu_items/customer_care_screen.dart';
import '../menu_items/sync_master_data_screen.dart';

class StoreDashboardMenu extends StatelessWidget {
  final String outletName;
  final String beatName;

  const StoreDashboardMenu({
    super.key,
    required this.outletName,
    required this.beatName,
  });

  // Compact Menu Tile
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      leading: Icon(icon, color: Colors.blue, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  // YES/NO dialog helper
  Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required VoidCallback onYes,
  }) async {
    await showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx),
            child: const Text("NO"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              onYes();
            },
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // ---------- HEADER ----------
            Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outletName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          beatName,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // ---------- MENU LIST ----------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SWITCH TO OFFICIAL WORK
                    buildMenuItem(
                      icon: Icons.work,
                      title: "Switch to Official Work",
                      onTap: () {
                        showConfirmDialog(
                          context: context,
                          title: "Switch to Official Work?",
                          onYes: () {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomePage()),
                                  (route) => false,
                            );

                            Future.delayed(const Duration(milliseconds: 80), () {
                              navigator.push(MaterialPageRoute(
                                builder: (_) => const OfficialWorkScreen(),
                              ));
                            });
                          },
                        );
                      },
                    ),

                    // CHANGE BEAT
                    buildMenuItem(
                      icon: Icons.map,
                      title: "Change Beat",
                      onTap: () {
                        showConfirmDialog(
                          context: context,
                          title: "Change Beat?",
                          onYes: () {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomePage()),
                                  (route) => false,
                            );

                            Future.delayed(const Duration(milliseconds: 80), () {
                              navigator.push(MaterialPageRoute(
                                builder: (_) => SelectBeatScreen(),
                              ));
                            });
                          },
                        );
                      },
                    ),

                    // CHANGE OUTLET
                    buildMenuItem(
                      icon: Icons.store,
                      title: "Change Outlet",
                      onTap: () {
                        showConfirmDialog(
                          context: context,
                          title: "Change Outlet?",
                          onYes: () {
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const HomePage()),
                                  (route) => false,
                            );

                            Future.delayed(const Duration(milliseconds: 80), () {
                              navigator.push(MaterialPageRoute(
                                builder: (_) => SelectBeatScreen(),
                              ));

                              Future.delayed(const Duration(milliseconds: 70), () {
                                navigator.push(MaterialPageRoute(
                                  builder: (_) => SelectOutletScreen(
                                    beatName: beatName,
                                    fromChangeOutlet: true,
                                  ),
                                ));
                              });
                            });
                          },
                        );
                      },
                    ),

                    const Divider(),

                    // ---------------- MENU SCREENS ----------------

                    buildMenuItem(
                      icon: Icons.timeline,
                      title: "Timeline",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const TimelineScreen(),
                        ));
                      },
                    ),

                    // ⭐ NEW — DAYWISE SUMMARY
                    buildMenuItem(
                      icon: Icons.calendar_month,
                      title: "Daywise Summary",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => const DaywiseSummaryScreen(),
                          ),
                        );
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.stacked_line_chart,
                      title: "Performance",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const PerformanceScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.bar_chart,
                      title: "Pocket MIS",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const PocketMISScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.request_page,
                      title: "My Request",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const MyRequestScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.star,
                      title: "My Incentives",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const MyIncentivesScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.people_alt,
                      title: "Customer Interaction",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const CustomerInteractionScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.devices_other,
                      title: "External Assets",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const ExternalAssetsScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.receipt_long,
                      title: "View Purchase Order",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const ViewPurchaseOrderScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.chat,
                      title: "Send PO via WhatsApp",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const SendPOWhatsappScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.sync,
                      title: "Sync Master Data",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const SyncMasterDataScreen(),
                        ));
                      },
                    ),

                    const Divider(),

                    buildMenuItem(
                      icon: Icons.privacy_tip,
                      title: "Privacy Policy",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ));
                      },
                    ),

                    buildMenuItem(
                      icon: Icons.support_agent,
                      title: "Customer Care",
                      onTap: () {
                        Navigator.pop(context);
                        navigator.push(MaterialPageRoute(
                          builder: (_) => const CustomerCareScreen(),
                        ));
                      },
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ---------------- END DAY BUTTON ----------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 48,
                    ),
                  ),
                  onPressed: () {
                    showConfirmDialog(
                      context: context,
                      title: "Are you sure you want to End Day?",
                      onYes: () {
                        ActivityLogger.add(
                          "End Day",
                          "User ended the day",
                          "end_day",
                        );

                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomePage()),
                              (route) => false,
                        );
                      },
                    );
                  },
                  child: const Text(
                    "END DAY",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
