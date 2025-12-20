import 'package:flutter/material.dart';
import 'distributor_beat_list_screen.dart';

class ManagerDistributorListScreen extends StatelessWidget {
  const ManagerDistributorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Distributor List",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _DistributorTile("ABC Distributors"),
          _DistributorTile("Sharma Agencies"),
          _DistributorTile("Global Enterprises"),
        ],
      ),
    );
  }
}

class _DistributorTile extends StatelessWidget {
  final String name;
  const _DistributorTile(this.name);

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
        onTap: () {
          // ✅ DIRECTLY OPEN BEAT LIST
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DistributorBeatListScreen(
                distributorName: name,
              ),
            ),
          );
        },
      ),
    );
  }
}
