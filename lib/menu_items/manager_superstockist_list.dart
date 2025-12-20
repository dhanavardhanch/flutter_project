import 'package:flutter/material.dart';
import 'add_superstockist_business.dart';
import 'manager_distributor_list_screen.dart';
import '../home_page/home_page.dart';

class ManagerSuperStockistListScreen extends StatelessWidget {
  const ManagerSuperStockistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4FAFF),

        // ================= APP BAR =================
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                    (route) => false,
              );
            },
          ),
          title: const Text(
            "Super Stockist List",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddSuperStockistBusinessScreen(),
                  ),
                );
              },
              child: const Text(
                "New",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // ================= BODY =================
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            _StockistTile("Premier Stockist"),
            _StockistTile("Bantoo Stockist"),
            _StockistTile("Basse Accounts"),
          ],
        ),
      ),
    );
  }
}

class _StockistTile extends StatelessWidget {
  final String name;
  const _StockistTile(this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),

        // ✅ CORRECT NAVIGATION
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ManagerDistributorListScreen(),
            ),
          );
        },
      ),
    );
  }
}
