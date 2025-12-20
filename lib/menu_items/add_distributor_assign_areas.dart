import 'package:flutter/material.dart';
import 'manager_distributor_list_screen.dart';

class AssignDistributorAreasScreen extends StatefulWidget {
  const AssignDistributorAreasScreen({super.key});

  @override
  State<AssignDistributorAreasScreen> createState() =>
      _AssignDistributorAreasScreenState();
}

class _AssignDistributorAreasScreenState
    extends State<AssignDistributorAreasScreen> {
  final Map<String, bool> areas = {
    "Andheri": false,
    "Borivali": false,
    "Kandivali": false,
    "Malad": false,
    "Goregaon": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(children: [
          _dot(false), _line(), _dot(false), _line(), _dot(false), _line(), _dot(true)
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: areas.keys.map((area) {
                return CheckboxListTile(
                  title: Text(area),
                  value: areas[area],
                  onChanged: (v) => setState(() => areas[area] = v!),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManagerDistributorListScreen()),
                      (route) => false,
                );
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(bool active) =>
      CircleAvatar(radius: 6, backgroundColor: active ? Colors.white : Colors.white54);
  Widget _line() => Container(width: 20, height: 2, color: Colors.white54);
}
