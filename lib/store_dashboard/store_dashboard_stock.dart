import 'package:flutter/material.dart';
import '../activity_logger.dart';

class StoreDashboardStock extends StatefulWidget {
  final String outletName;   // ⭐ IMPORTANT: Receive outlet name

  const StoreDashboardStock({
    super.key,
    required this.outletName,
  });

  @override
  State<StoreDashboardStock> createState() => _StoreDashboardStockState();
}

class _StoreDashboardStockState extends State<StoreDashboardStock> {
  int selectedTab = 0;

  final List<String> tabs = [
    "CHIKKI",
    "SHAKES",
    "CW BTL 1LTR",
    "CW BTL"
  ];

  final Map<String, List<String>> items = {
    "CHIKKI": [
      "MILLET CHIKKI",
      "PEANUT MILLET CHIKKI",
      "COCONUT MILLET CHIKKI",
      "TOFFEE CHIKKI"
    ],
    "SHAKES": [
      "BADAM",
      "BANANA",
      "CHOCOLATE",
      "COFFEE",
      "MANGO",
      "STRAWBERRY"
    ],
    "CW BTL 1LTR": ["CW BTL 1LTR"],
    "CW BTL": ["CW-Pet"],
  };

  String currentQty = "";
  String? activeItem;

  void submitStock(String item) {
    if (currentQty.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter quantity"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ⭐ REQUIRED FOR MIS → Merchandising (one per outlet per day)
    ActivityLogger.addMerchandising(widget.outletName);

    // ⭐ Save stock update
    ActivityLogger.addStock(item, currentQty, widget.outletName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.outletName}: $item → $currentQty pcs saved"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      activeItem = null;
      currentQty = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Stock - ${widget.outletName}",
          style: const TextStyle(color: Colors.white, fontSize: 21),
        ),
      ),

      body: Column(
        children: [
          // ---------------- TAB BAR ----------------
          Container(
            color: Colors.lightBlue,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                bool selected = index == selectedTab;

                return GestureDetector(
                  onTap: () => setState(() => selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.blueGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- ITEM LIST ----------------
          Expanded(
            child: ListView(
              children: items[tabs[selectedTab]]!.map((item) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(
                        activeItem == item
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      onTap: () {
                        setState(() {
                          activeItem = activeItem == item ? null : item;
                          currentQty = "";
                        });

                        // Optional log
                        ActivityLogger.add(
                          "Stock Entry",
                          "Started entry for $item",
                          "stock_start",
                        );
                      },
                    ),

                    if (activeItem == item)
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.grey.shade100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "QUANTITY",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                currentQty,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 2,
                              ),
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                String label = "";

                                if (index < 9) label = "${index + 1}";
                                if (index == 9) label = "0";
                                if (index == 10) label = "⌫";
                                if (index == 11) label = "SAVE";

                                bool isSave = label == "SAVE";

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (label == "⌫") {
                                        if (currentQty.isNotEmpty) {
                                          currentQty =
                                              currentQty.substring(0, currentQty.length - 1);
                                        }
                                      } else if (label == "SAVE") {
                                        submitStock(item);
                                      } else {
                                        currentQty = currentQty + label;
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSave ? Colors.green : Colors.white,
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSave ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                    const Divider(height: 1),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
