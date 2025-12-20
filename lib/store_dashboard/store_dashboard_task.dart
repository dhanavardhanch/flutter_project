import 'package:flutter/material.dart';

// Task Screens
import '../task_screens/competitors_form_screen.dart';
import '../task_screens/sos_facing_target_screen.dart';
import '../task_screens/akam_joint_working_screen.dart';
import '../task_screens/customer_free_sampling_screen.dart';
import '../task_screens/fsu_paid_visibility_screen.dart';
import '../task_screens/near_expiry_tracking_screen.dart';

class StoreDashboardTaskScreen extends StatefulWidget {
  const StoreDashboardTaskScreen({super.key});

  @override
  State<StoreDashboardTaskScreen> createState() =>
      _StoreDashboardTaskScreenState();
}

class _StoreDashboardTaskScreenState extends State<StoreDashboardTaskScreen> {
  final List<Map<String, dynamic>> tasks = [
    {
      "title": "FSU tracking Unpaid visibility",
      "subtitle": "FSU tracking Unpaid visibility",
      "screen": "COMPETITOR_FORM",
      "mandatory": false,
    },
    {
      "title": "Competitor's Form",
      "subtitle": "Competitor's Form",
      "screen": "COMPETITOR_FORM",
      "mandatory": true,
    },
    {
      "title": "SOS Facing Target",
      "subtitle": "SOS Facing Target",
      "screen": "SOS_FACING",
      "mandatory": true,
    },
    {
      "title": "AKAM Joint Working",
      "subtitle": "AKAM Joint Working",
      "screen": "AKAM_JOINT",
      "mandatory": false,
    },
    {
      "title": "Customer Free Sampling",
      "subtitle": "Customer Free Sampling",
      "screen": "CUSTOMER_SAMPLING",
      "mandatory": false,
    },
    {
      "title": "FSU tracking Paid visibility",
      "subtitle": "FSU tracking Paid visibility",
      "screen": "FSU_PAID",
      "mandatory": false,
    },
    {
      "title": "SOH – PLANO – FIFO – NEAR EXPIRY TRACKING Task",
      "subtitle": "SOH – PLANO – FIFO – NEAR EXPIRY TRACKING Task",
      "screen": "NEAR_EXPIRY",
      "mandatory": true,
    },
  ];

  // Task Screen router
  Widget getTaskScreen(String key, String title) {
    switch (key) {
      case "COMPETITOR_FORM":
        return CompetitorsFormScreen(taskTitle: title);
      case "SOS_FACING":
        return SOSFacingTargetScreen(taskTitle: title);
      case "AKAM_JOINT":
        return AKAMJointWorkingScreen(taskTitle: title);
      case "CUSTOMER_SAMPLING":
        return CustomerFreeSamplingScreen(taskTitle: title);
      case "FSU_PAID":
        return FSUPaidVisibilityScreen(taskTitle: title);
      case "NEAR_EXPIRY":
        return NearExpiryTrackingScreen(taskTitle: title);
      default:
        return const Scaffold(
            body: Center(child: Text("Coming Soon")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: const Text(
          "Task",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),

      body: ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final task = tasks[index];

          return ListTile(
            dense: true,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      getTaskScreen(task["screen"], task["title"]),
                ),
              );
            },

            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task["mandatory"] == true)
                  Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Mandatory",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                Text(
                  task["title"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  task["subtitle"],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade600,
              size: 18,
            ),
          );
        },
      ),
    );
  }
}
