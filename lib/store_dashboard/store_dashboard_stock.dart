import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../activity_logger.dart';
import '../models/product_model.dart';
import '../services/local_storage.dart';



class StoreDashboardStock extends StatefulWidget {
  final String outletName;

  const StoreDashboardStock({
    super.key,
    required this.outletName,
  });

  @override
  State<StoreDashboardStock> createState() => _StoreDashboardStockState();
}

class _StoreDashboardStockState extends State<StoreDashboardStock> {
  int selectedTab = 0;
  bool loading = true;

  /// ✅ TABS (UNCHANGED)
  final List<String> tabs = [
    "CHIKKI",
    "NAMKEEN",
    "RUSK",
  ];

  /// ✅ PRODUCTS
  List<ProductModel> chikkiProducts = [];

  String currentQty = "";
  String? activeItem;

  @override
  void initState() {
    super.initState();
    fetchChikkiProducts();

  }

  // ===================================================
  // 🔥 FETCH PRODUCTS (ONLINE → OFFLINE)
  // ===================================================
  Future<void> fetchChikkiProducts() async {
    try {
      final response = await http.get(
        Uri.parse("https://troogood.in/api/V1/products/list"),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"];

        final allProducts =
        list.map((e) => ProductModel.fromJson(e)).toList();

        // ✅ SAVE ALL PRODUCTS FOR OFFLINE
        await LocalStorage.saveProducts(
          allProducts.map((p) => p.toJson()).toList(),
        );

        // ✅ FILTER CHIKKI
        chikkiProducts =
            allProducts.where((p) => p.costToCompany > 0).toList();
      } else {
        throw Exception("API failed");
      }
    } catch (e) {
      // 🔁 OFFLINE FALLBACK
      final offline = await LocalStorage.getProducts();
      final allProducts =
      offline.map((e) => ProductModel.fromJson(e)).toList();

      chikkiProducts =
          allProducts.where((p) => p.costToCompany > 0).toList();
    }

    setState(() => loading = false);
  }

  // ===================================================
  // 🟢 SAVE STOCK
  // ===================================================
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

    // ⭐ MIS requirement
    ActivityLogger.addMerchandising(widget.outletName);

    // ⭐ Save stock
    ActivityLogger.addStock(item, currentQty, widget.outletName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
        Text("${widget.outletName}: $item → $currentQty pcs saved"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      activeItem = null;
      currentQty = "";
    });
  }

  List<String> getCurrentItems() {
    if (tabs[selectedTab] == "CHIKKI") {
      return chikkiProducts.map((e) => e.name).toList();
    }
    return []; // NAMKEEN & RUSK later
  }

  // ===================================================
  // UI (UNCHANGED)
  // ===================================================
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
                  onTap: () => setState(() {
                    selectedTab = index;
                    activeItem = null;
                    currentQty = "";
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
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
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : getCurrentItems().isEmpty
                ? const Center(
              child: Text(
                "No products available",
                style: TextStyle(
                    color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView(
              children: getCurrentItems().map((item) {
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
                          activeItem =
                          activeItem == item ? null : item;
                          currentQty = "";
                        });

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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                              padding:
                              const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black26),
                                borderRadius:
                                BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                currentQty,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 2,
                              ),
                              itemCount: 12,
                              itemBuilder:
                                  (context, index) {
                                String label = "";

                                if (index < 9)
                                  label = "${index + 1}";
                                if (index == 9) label = "0";
                                if (index == 10) label = "⌫";
                                if (index == 11) label = "SAVE";

                                bool isSave =
                                    label == "SAVE";

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (label == "⌫") {
                                        if (currentQty
                                            .isNotEmpty) {
                                          currentQty =
                                              currentQty.substring(
                                                  0,
                                                  currentQty.length -
                                                      1);
                                        }
                                      } else if (label ==
                                          "SAVE") {
                                        submitStock(item);
                                      } else {
                                        currentQty =
                                            currentQty + label;
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment:
                                    Alignment.center,
                                    decoration:
                                    BoxDecoration(
                                      border: Border.all(
                                          color:
                                          Colors.black26),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      color: isSave
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: isSave
                                            ? Colors.white
                                            : Colors.black,
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
