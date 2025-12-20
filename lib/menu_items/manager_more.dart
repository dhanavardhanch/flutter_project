import 'package:flutter/material.dart';

class ManagerMoreScreen extends StatelessWidget {
  const ManagerMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        titleSpacing: 12,
        title: Image.asset(
          'assets/TrooGood_Logo.png',
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        children: [
          _menuTile(
            title: "Team Coverage",
            onTap: () {
              // TODO: Navigate to Team Coverage
            },
          ),
          _divider(),

          _menuTile(
            title: "Beat-o-Meter",
            onTap: () {
              // TODO: Navigate to Beat-o-Meter
            },
          ),
          _divider(),

          _menuTile(
            title: "FA Battleground",
            onTap: () {
              // TODO: Navigate to FA Battleground
            },
          ),
          _divider(),
        ],
      ),
    );
  }

  // ================= COMPONENTS =================

  Widget _menuTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _divider() => const Divider(
    height: 1,
    thickness: 0.6,
  );
}
