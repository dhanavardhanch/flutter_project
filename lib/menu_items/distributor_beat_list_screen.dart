import 'package:flutter/material.dart';
import 'add_distributor_beat_screen.dart';
import 'distributor_outlet_list_screen.dart';

class DistributorBeatListScreen extends StatelessWidget {
  final String distributorName;
  const DistributorBeatListScreen({super.key, required this.distributorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Select Beat",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddDistributorBeatScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        children: const [
          _BeatTile("Ameerpet", 3),
          _BeatTile("Hitech City", 2),
          _BeatTile("Kompally", 1),
        ],
      ),
    );
  }
}

class _BeatTile extends StatelessWidget {
  final String name;
  final int outlets;
  const _BeatTile(this.name, this.outlets);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("$outlets outlets"),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 18),
          SizedBox(width: 10),
          Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DistributorOutletListScreen(beatName: name),
          ),
        );
      },
    );
  }
}
