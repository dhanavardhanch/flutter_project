import 'package:flutter/material.dart';
import 'distributor_beat_list_screen.dart';

class DistributorDetailScreen extends StatelessWidget {
  final String distributorName;
  const DistributorDetailScreen({super.key, required this.distributorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: Text(
          distributorName,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DistributorBeatListScreen(
                  distributorName: distributorName,
                ),
              ),
            );
          },
          child: const Text("View Beats"),
        ),
      ),
    );
  }
}
