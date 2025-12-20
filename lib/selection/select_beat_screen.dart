import 'package:flutter/material.dart';
import '../notifications/notification_screen.dart';
import '../home_page/home_page.dart';
import 'select_outlet_screen.dart';
import 'add_beat_screen.dart';
import '../activity_logger.dart';

class SelectBeatScreen extends StatefulWidget {
  final bool goToOutletAfterBeat;

  const SelectBeatScreen({super.key, this.goToOutletAfterBeat = false});

  @override
  State<SelectBeatScreen> createState() => _SelectBeatScreenState();
}

class _SelectBeatScreenState extends State<SelectBeatScreen> {
  final List<Map<String, dynamic>> beats = [
    {"name": "Ameerpet", "outlets": 0},
    {"name": "Hitech City", "outlets": 0},
    {"name": "Kompally", "outlets": 0},
    {"name": "Nallagandla", "outlets": 0},
    {"name": "Nizampet", "outlets": 0},
    {"name": "Tolichowki", "outlets": 0},
  ];

  @override
  void initState() {
    super.initState();
    _mergeSavedBeats();
    _updateOutletCounts();
  }

  void _mergeSavedBeats() {
    final savedBeats = ActivityLogger.getBeats();
    for (final beatName in savedBeats) {
      final exists = beats.any((b) => b["name"] == beatName);
      if (!exists) {
        beats.add({"name": beatName, "outlets": 0});
      }
    }
  }

  void _updateOutletCounts() {
    for (final beat in beats) {
      final name = beat["name"];
      final staticCount = _staticOutletCount(name);
      final savedCount = ActivityLogger.getOutlets(name).length;
      beat["outlets"] = staticCount + savedCount;
    }
    setState(() {});
  }

  int _staticOutletCount(String beatName) {
    const staticOutletData = {
      "Ameerpet": 3,
      "Hitech City": 2,
      "Kompally": 1,
      "Nallagandla": 1,
      "Nizampet": 1,
      "Tolichowki": 1,
    };
    return staticOutletData[beatName] ?? 0;
  }

  void _addNewBeat() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddBeatScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        beats.add({"name": result, "outlets": 0});
      });
      _updateOutletCounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _header(context),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 15, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Beat",
                    style:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: beats.length,
                  itemBuilder: (context, index) {
                    final beat = beats[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      title: Text(
                        beat["name"],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("${beat["outlets"]} outlets"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ✏️ Edit Beat (FIXED)
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () async {
                              final oldName = beat["name"];

                              final updatedName = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddBeatScreen(
                                    initialBeatName: oldName,
                                  ),
                                ),
                              );

                              if (updatedName != null &&
                                  updatedName is String &&
                                  updatedName != oldName) {
                                await ActivityLogger.renameBeat(
                                  oldName,
                                  updatedName,
                                );

                                setState(() {
                                  beat["name"] = updatedName;
                                });

                                _updateOutletCounts();
                              }
                            },
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () async {
                        final route = MaterialPageRoute(
                          builder: (_) =>
                              SelectOutletScreen(beatName: beat["name"]),
                        );

                        widget.goToOutletAfterBeat
                            ? await Navigator.pushReplacement(context, route)
                            : await Navigator.push(context, route);

                        _updateOutletCounts();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔝 HEADER WITH + BUTTON
  Widget _header(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            child: const Icon(Icons.arrow_back, size: 28),
          ),
          Image.asset('assets/TrooGood_Logo.png', height: 42),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 28),
                onPressed: _addNewBeat,
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
