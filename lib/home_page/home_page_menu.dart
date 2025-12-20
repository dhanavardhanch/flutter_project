import 'package:flutter/material.dart';

import '../menu_items/menu_item_data.dart';
import '../menu_items/menu_item_widget.dart';

// 🟦 MANAGER SCREENS
import '../menu_items/manager_home_screen.dart';
import '../menu_items/manager_daily_summary.dart';
import '../menu_items/manager_quick_viz.dart';
import '../menu_items/manager_outlet_summary_screen.dart';
import '../menu_items/manager_team_coverage.dart';
import '../menu_items/manager_so_sr_performance.dart';
import '../menu_items/manager_month_on_month_comparison.dart';
import '../menu_items/manager_superstockist_list.dart';
import '../menu_items/manager_distributor_list_screen.dart'; // ✅ DISTRIBUTOR
import '../menu_items/manager_more.dart';

// 🟩 FIELD USER SCREENS
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
import '../menu_items/user_profile.dart';

class HomePageMenu extends StatefulWidget {
  const HomePageMenu({super.key});

  @override
  State<HomePageMenu> createState() => _HomePageMenuState();
}

class _HomePageMenuState extends State<HomePageMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ======================================================
  // 🔹 MAIN MENU ITEMS
  // ======================================================
  final List<MenuItemData> menuList = [
    // 🟦 MANAGER DASHBOARDS
    MenuItemData(
      "Manager Home",
      Icons.dashboard_customize,
      const ManagerHomeScreen(),
    ),
    MenuItemData(
      "Manager Daily Summary",
      Icons.assignment_outlined,
      const ManagerDailySummaryScreen(),
    ),
    MenuItemData(
      "Manager Quick Viz",
      Icons.insights,
      const ManagerQuickVizScreen(),
    ),
    MenuItemData(
      "Manager Outlet Summary",
      Icons.storefront,
      const ManagerOutletSummaryScreen(),
    ),
    MenuItemData(
      "Manager Team Coverage",
      Icons.groups,
      const ManagerTeamCoverageScreen(),
    ),
    MenuItemData(
      "Manager SO/SR Performance",
      Icons.trending_up,
      const ManagerSoSrPerformanceScreen(),
    ),
    MenuItemData(
      "Month on Month Comparison",
      Icons.compare_arrows,
      const ManagerMonthOnMonthComparisonScreen(),
    ),

    // ✅ SUPER STOCKIST
    MenuItemData(
      "Super Stockist",
      Icons.warehouse,
      const ManagerSuperStockistListScreen(),
    ),

    // ✅ DISTRIBUTOR
    MenuItemData(
      "Distributor",
      Icons.local_shipping,
      const ManagerDistributorListScreen(),
    ),

    MenuItemData(
      "Manager More",
      Icons.more_horiz,
      const ManagerMoreScreen(),
    ),

    // 🟩 FIELD USER SCREENS
    MenuItemData("Timeline", Icons.timeline, const TimelineScreen()),
    MenuItemData(
      "Daywise Summary",
      Icons.calendar_month,
      const DaywiseSummaryScreen(),
    ),
    MenuItemData("Performance", Icons.bar_chart, const PerformanceScreen()),
    MenuItemData(
      "Pocket MIS",
      Icons.account_balance_wallet,
      const PocketMISScreen(),
    ),
    MenuItemData("My Request", Icons.assignment, const MyRequestScreen()),
    MenuItemData(
      "My Incentives",
      Icons.monetization_on,
      const MyIncentivesScreen(),
    ),
    MenuItemData(
      "Customer Interaction",
      Icons.people_alt,
      const CustomerInteractionScreen(),
    ),
    MenuItemData(
      "External Assets",
      Icons.inventory,
      const ExternalAssetsScreen(),
    ),
    MenuItemData(
      "View Purchase Order",
      Icons.shopping_bag,
      const ViewPurchaseOrderScreen(),
    ),
    MenuItemData(
      "Send PO via WhatsApp",
      Icons.send,
      const SendPOWhatsappScreen(),
    ),
    MenuItemData(
      "Sync Master Data",
      Icons.sync,
      const SyncMasterDataScreen(),
    ),
  ];

  // ======================================================
  // 🔹 FOOTER MENU ITEMS
  // ======================================================
  final List<MenuItemData> footerList = [
    MenuItemData(
      "Privacy Policy",
      Icons.privacy_tip,
      const PrivacyPolicyScreen(),
    ),
    MenuItemData(
      "Customer Care",
      Icons.support_agent,
      const CustomerCareScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children: [
            // ================= HEADER =================
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserProfileDashboard(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                color: const Color(0xFFD8F1FF),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage("assets/user.jpg"),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "EMP0012",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),

            // ================= MENU =================
            Expanded(
              child: ListView(
                children: [
                  ...menuList.map(
                        (item) => MenuItemWidget(
                      icon: item.icon,
                      title: item.title,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => item.page),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  ...footerList.map(
                        (item) => MenuItemWidget(
                      icon: item.icon,
                      title: item.title,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => item.page),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
