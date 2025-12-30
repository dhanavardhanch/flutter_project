import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';
import '../services/local_storage.dart';


class TransactionDetailsScreen extends StatefulWidget {
  final int storeId;

  const TransactionDetailsScreen({
    super.key,
    required this.storeId,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState
    extends State<TransactionDetailsScreen> {
  bool loading = true;
  List<TransactionModel> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();

  }

  // ===================================================
  // 🔥 FETCH STORE-WISE TRANSACTIONS (ONLINE → OFFLINE)
  // ===================================================
  Future<void> fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://troogood.in/api/V1/sales/historybystore/${widget.storeId}",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List list = decoded["data"];

        transactions =
            list.map((e) => TransactionModel.fromJson(e)).toList();

        // ✅ SAVE STORE-WISE FOR OFFLINE
        await LocalStorage.saveTransactions(
          widget.storeId,
          transactions.map((t) => t.toJson()).toList(),
        );
      } else {
        throw Exception("API failed");
      }
    } catch (_) {
      // 🔁 OFFLINE FALLBACK (STORE-WISE)
      final offline =
      await LocalStorage.getTransactions(widget.storeId);

      transactions =
          offline.map((e) => TransactionModel.fromJson(e)).toList();
    }

    setState(() => loading = false);
  }

  // ===================================================
  // UI
  // ===================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text("No transactions found"))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (_, index) {
          final t = transactions[index];
          return ListTile(
            title: Text("₹ ${t.amount}"),
            subtitle: Text(
              "Qty: ${t.saleQty} | Date: ${t.saleDate}",
            ),
          );
        },
      ),
    );
  }
}
