import 'package:flutter/material.dart';
import '../home_page/home_page.dart';
import '../activity_logger.dart';

class OfficialWorkScreen extends StatefulWidget {
  final bool fromMenu;

  const OfficialWorkScreen({super.key, this.fromMenu = false});

  @override
  State<OfficialWorkScreen> createState() => _OfficialWorkScreenState();
}

class _OfficialWorkScreenState extends State<OfficialWorkScreen> {
  int? selectedIndex;

  final List<String> workOptions = [
    "Promotional Activity",
    "Meeting",
    "Head Office Visit",
  ];

  @override
  void initState() {
    super.initState();

    // Log opening screen
    ActivityLogger.add(
      "Official Work",
      widget.fromMenu
          ? "Opened from Menu"
          : "Opened during Day Start / Workflow",
      "official_open",
    );
  }

  void applyOfficialWork() {
    if (selectedIndex == null) return;

    String selectedWork = workOptions[selectedIndex!];

    // ⭐ Correct log for Daywise Summary
    ActivityLogger.officialWork(selectedWork);

    // Additional detail log for timeline
    ActivityLogger.add(
      "Official Work",
      "Selected: $selectedWork",
      "official_select",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your day is updated to $selectedWork."),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (widget.fromMenu) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
        );
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ------------------- OKAY BUTTON -------------------
      bottomNavigationBar: selectedIndex != null
          ? GestureDetector(
        onTap: applyOfficialWork,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          child: const Text(
            "OKAY",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      )
          : null,

      // ------------------- BODY -------------------
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ----------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ActivityLogger.add(
                        "Official Work",
                        "Closed Official Work Screen",
                        "official_close",
                      );

                      if (widget.fromMenu) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                              (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(Icons.arrow_back,
                        size: 28, color: Colors.black),
                  ),

                  Image.asset(
                    'assets/images/TrooGood_Logo.png',
                    height: 45,
                  ),

                  const Icon(Icons.notifications_none,
                      size: 28, color: Colors.black),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Select Official Work",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Divider(height: 1),

            // ---------- LIST ----------
            Expanded(
              child: ListView.builder(
                itemCount: workOptions.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;

                  return InkWell(
                    onTap: () {
                      setState(() => selectedIndex = index);

                      ActivityLogger.add(
                        "Official Work",
                        "Option Clicked: ${workOptions[index]}",
                        "official_option",
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 15),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black12),
                        ),
                      ),
                      child: Text(
                        workOptions[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.blue.shade800
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
