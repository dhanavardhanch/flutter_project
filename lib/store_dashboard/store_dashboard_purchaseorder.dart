import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import '../activity_logger.dart';
import '../models/product_model.dart';
import '../services/local_storage.dart';


class StoreDashboardPurchaseOrderScreen extends StatefulWidget {
  const StoreDashboardPurchaseOrderScreen({super.key});

  @override
  State<StoreDashboardPurchaseOrderScreen> createState() =>
      _StoreDashboardPurchaseOrderScreenState();
}

class _StoreDashboardPurchaseOrderScreenState
    extends State<StoreDashboardPurchaseOrderScreen> {
  bool loading = true;

  /// UI STATE (qty is UI-only, not model data)
  final Map<int, int> quantities = {};
  final Map<int, TextEditingController> qtyControllers = {};

  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();

    fetchProducts();
  }

  // ===================================================
  // 🔥 FETCH PRODUCTS (ONLINE → OFFLINE FALLBACK)
  // ===================================================
  Future<void> fetchProducts() async {
    setState(() => loading = true);

    try {
      final response = await http.get(
        Uri.parse("https://troogood.in/api/V1/products/list"),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"];

        products = list.map((e) => ProductModel.fromJson(e)).toList();

        // ✅ SAVE FOR OFFLINE
        await LocalStorage.saveProducts(
          products.map((p) => p.toJson()).toList(),
        );
      } else {
        throw Exception("API failed");
      }
    } catch (_) {
      // 🔁 OFFLINE FALLBACK
      final offline = await LocalStorage.getProducts();
      products = offline.map((e) => ProductModel.fromJson(e)).toList();
    }

    setState(() => loading = false);
  }

  // ===================================================
  // 🟢 CREATE PURCHASE ORDER
  // ===================================================
  void createPO() async {
    final selected = products.where(
          (p) => (quantities[p.id] ?? 0) > 0,
    );

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add quantity for at least one item"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (final item in selected) {
      final qty = quantities[item.id] ?? 0;
      final total = qty * item.costToCompany;

      ActivityLogger.addPurchaseOrder(
        "${item.name} | Qty $qty | ₹$total",
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("PO created successfully for selected outlet"),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    fetchProducts();
  }

  // ===================================================
  // UI
  // ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Purchase Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final item = products[i];

                qtyControllers.putIfAbsent(
                  item.id,
                      () => TextEditingController(),
                );

                final qty = quantities[item.id] ?? 0;
                final total = qty * item.costToCompany;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ IMAGE (CACHED FOR OFFLINE)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  // QTY
                                  SizedBox(
                                    width: 70,
                                    height: 38,
                                    child: TextField(
                                      controller:
                                      qtyControllers[item.id],
                                      keyboardType:
                                      TextInputType.number,
                                      decoration:
                                      const InputDecoration(
                                        hintText: "Qty",
                                        border: OutlineInputBorder(),
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 6,
                                        ),
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          quantities[item.id] =
                                              int.tryParse(v) ?? 0;
                                        });
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Text(
                                    "₹ ${item.costToCompany}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(
                                    "₹ $total",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // RESET
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  quantities[item.id] = 0;
                                  qtyControllers[item.id]?.clear();
                                });
                              },
                            ),
                            const Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: createPO,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "CREATE PO",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
