import 'package:flutter/material.dart';
import '../notifications/notification_screen.dart';
import '../location/start_day_screen.dart';
import 'select_beat_screen.dart';
import 'add_outlet_screen.dart';
import '../activity_logger.dart';

class SelectOutletScreen extends StatefulWidget {
  final String beatName;
  final bool fromChangeOutlet;

  const SelectOutletScreen({
    super.key,
    required this.beatName,
    this.fromChangeOutlet = false,
  });

  @override
  State<SelectOutletScreen> createState() => _SelectOutletScreenState();
}

class _SelectOutletScreenState extends State<SelectOutletScreen> {
  String? selectedOutlet;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  final Map<String, List<Map<String, String>>> outletData = {
    "Ameerpet": [
      {"name": "Ratnadeep-Ameerpet_A11", "city": "AMEERPET"},
      {"name": "Ratnadeep-Somajiguda_A05", "city": "AMEERPET"},
      {"name": "Ratnadeep-Yousufguda_A08", "city": "AMEERPET"},
    ],
    "Hitech City": [
      {"name": "D-Mart - MyHome_5010", "city": "Hyderabad"},
      {"name": "Ratnadeep-Film Nagar_A43", "city": "Hitech City"},
    ],
    "Kompally": [
      {"name": "Ratnadeep-Kompally_A21", "city": "Kompally"},
    ],
    "Nallagandla": [
      {"name": "Ratnadeep-Nallagandla_A12", "city": "Nallagandla"},
    ],
    "Nizampet": [
      {"name": "Ratnadeep-Nizampet_A19", "city": "Nizampet"},
    ],
    "Tolichowki": [
      {"name": "Ratnadeep-Tolichowki_A27", "city": "Tolichowki"},
    ],
  };

  @override
  void initState() {
    super.initState();

    final savedOutlets = ActivityLogger.getOutlets(widget.beatName);
    if (savedOutlets.isNotEmpty) {
      outletData.putIfAbsent(widget.beatName, () => []);
      for (final outlet in savedOutlets) {
        final exists = outletData[widget.beatName]!
            .any((o) => o["name"] == outlet["name"]);
        if (!exists) {
          outletData[widget.beatName]!.add(outlet);
        }
      }
    }

    selectedOutlet = null; // ✅ nothing auto-selected
  }

  void _addNewOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddOutletScreen(beatName: widget.beatName),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        outletData.putIfAbsent(widget.beatName, () => []);
        outletData[widget.beatName]!.add(result);
        selectedOutlet = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final originalOutlets = outletData[widget.beatName] ?? [];
    final filteredOutlets = originalOutlets
        .where((o) =>
        (o["name"] ?? "")
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const SelectBeatScreen()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              _title(),
              _search(),
              const SizedBox(height: 10),

              Expanded(
                child: filteredOutlets.isEmpty
                    ? const Center(
                  child: Text(
                    "No outlets found",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredOutlets.length,
                  itemBuilder: (context, index) {
                    final outlet = filteredOutlets[index];

                    return ListTile(
                      title: Text(outlet["name"] ?? "Unknown Outlet"),
                      subtitle: Text(outlet["city"] ?? "-"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏️ Edit outlet
                          IconButton(
                            icon:
                            const Icon(Icons.edit, size: 20),
                            onPressed: () async {
                              final updated =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddOutletScreen(
                                        beatName: widget.beatName,
                                        initialOutlet: outlet,
                                      ),
                                ),
                              );

                              if (updated != null &&
                                  updated
                                  is Map<String, String>) {
                                setState(() {
                                  outlet["name"] =
                                  updated["name"]!;
                                  outlet["city"] =
                                  updated["city"]!;
                                  selectedOutlet = null;
                                });
                              }
                            },
                          ),
                          selectedOutlet == outlet["name"]
                              ? const Icon(
                            Icons.check_box,
                            color: Colors.blue,
                          )
                              : const Icon(Icons
                              .check_box_outline_blank),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedOutlet = outlet["name"];
                        });
                      },
                    );
                  },
                ),
              ),

              _proceed(context),
            ],
          ),
        ),
      ),
    );
  }

  // 🔝 HEADER WITH TOP + BUTTON
  Widget _header(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const SelectBeatScreen()),
            );
          },
          child: const Icon(Icons.arrow_back, size: 28),
        ),

        Image.asset('assets/TrooGood_Logo.png', height: 45),

        Row(
          children: [
            // ➕ ADD OUTLET (TOP)
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  size: 28),
              onPressed: _addNewOutlet,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const NotificationScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  );

  Widget _title() => Padding(
    padding:
    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Outlet",
          style:
          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        Text(
          widget.beatName,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _search() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: "Search",
        ),
        onChanged: (v) =>
            setState(() => searchQuery = v),
      ),
    ),
  );

  Widget _proceed(BuildContext context) => GestureDetector(
    onTap: selectedOutlet == null
        ? null
        : () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StartDayScreen(
            outletName: selectedOutlet!,
            beatName: widget.beatName,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      color:
      selectedOutlet == null ? Colors.grey : Colors.blue,
      child: Text(
        selectedOutlet == null
            ? "SELECT OUTLET TO PROCEED"
            : "PROCEED →",
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
