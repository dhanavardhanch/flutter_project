import 'package:flutter/material.dart';
import 'add_distributor_outlet_screen.dart';

class DistributorOutletListScreen extends StatelessWidget {
  final String beatName;
  const DistributorOutletListScreen({super.key, required this.beatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: Text(
          beatName,
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddDistributorOutletScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        children: const [
          _OutletTile("Ratnadeep-Ameerpet_A11", "AMEERPET"),
          _OutletTile("Ratnadeep-Somajiguda_A05", "AMEERPET"),
        ],
      ),
    );
  }
}

class _OutletTile extends StatelessWidget {
  final String name;
  final String city;
  const _OutletTile(this.name, this.city);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(city),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 18),
          SizedBox(width: 10),
          Icon(Icons.check_box_outline_blank),
        ],
      ),
    );
  }
}
