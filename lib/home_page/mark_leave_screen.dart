import 'package:flutter/material.dart';
import '../activity_logger.dart';

class MarkLeaveScreen extends StatefulWidget {
  const MarkLeaveScreen({super.key});

  @override
  State<MarkLeaveScreen> createState() => _MarkLeaveScreenState();
}

class _MarkLeaveScreenState extends State<MarkLeaveScreen> {
  String selectedType = "Leave";
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ActivityLogger.add(
      "Mark Leave",
      "Opened Mark Leave / Weekly Off Screen",
      "leave_open",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ActivityLogger.add(
                        "Mark Leave",
                        "Closed Mark Leave Screen",
                        "leave_close",
                      );
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back,
                        size: 28, color: Colors.black),
                  ),

                  Image.asset('assets/images/TrooGood_Logo.png', height: 42),

                  const Icon(Icons.notifications_none,
                      size: 28, color: Colors.black),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 15, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mark Leave / Weekly Off",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "SELECT TYPE",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),


                    buildOption("Leave"),
                    buildOption("Holiday"),
                    buildOption("Weekly Off"),

                    const SizedBox(height: 25),

                    // Reason Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "REASON / COMMENT *",
                          labelStyle: TextStyle(
                            color: Colors.teal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ---------------- APPLY BUTTON ----------------
      bottomNavigationBar: GestureDetector(
        onTap: reasonController.text.trim().isEmpty
            ? null
            : () {
          // ⭐ Correct logging – DAYWISE SUMMARY NEEDS THIS
          ActivityLogger.markLeave(selectedType);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Today marked as $selectedType"),
            ),
          );

          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          color: reasonController.text.trim().isEmpty
              ? Colors.grey.shade400
              : Colors.blue.shade700,
          child: Text(
            "APPLY $selectedType →",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- OPTION BUILDER ----------------
  Widget buildOption(String text) {
    bool isSelected = selectedType == text;

    return GestureDetector(
      onTap: () {
        setState(() => selectedType = text);

        ActivityLogger.add(
          "Mark Leave",
          "Selected: $text",
          "leave_select_type",
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 5),
        color: isSelected ? Colors.lightBlue.shade50 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            isSelected
                ? const Icon(Icons.check, color: Colors.blue)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
