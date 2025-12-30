import 'package:flutter/material.dart';

import '../notifications/notification_screen.dart';
import '../home_page/home_page.dart';
import 'select_outlet_screen.dart';
import 'add_beat_screen.dart';

import '../api/beat_api.dart';
import '../models/beat_model.dart';
import '../services/local_storage.dart';

class SelectBeatScreen extends StatefulWidget {
  final bool goToOutletAfterBeat;

  const SelectBeatScreen({
    super.key,
    this.goToOutletAfterBeat = false,
  });

  @override
  State<SelectBeatScreen> createState() => _SelectBeatScreenState();
}

class _SelectBeatScreenState extends State<SelectBeatScreen> {
  bool loading = true;
  List<BeatModel> beats = [];

  @override
  void initState() {
    super.initState();
    fetchBeats();
  }

  // ===================================================
  // 🔥 ONLINE → OFFLINE SAFE BEAT LOAD
  // ===================================================
  Future<void> fetchBeats() async {
    try {
      final apiBeats = await BeatApi.getBeatsBySeller(
        sellerId: 5,
      );

      beats = apiBeats;

      // ✅ SAVE FOR OFFLINE
      await LocalStorage.saveBeats(
        beats.map((b) => b.toJson()).toList(),
      );
    } catch (_) {
      // 🔁 OFFLINE FALLBACK
      final offline = await LocalStorage.getBeats();
      beats = offline.map((e) => BeatModel.fromJson(e)).toList();
    }

    setState(() => loading = false);
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : beats.isEmpty
                    ? const Center(child: Text("No beats found"))
                    : ListView.builder(
                  itemCount: beats.length,
                  itemBuilder: (context, index) {
                    final beat = beats[index];

                    return ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      title: Text(
                        beat.area,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        "${beat.storeCount} outlets",
                        style: const TextStyle(
                            color: Colors.grey),
                      ),
                      trailing:
                      const Icon(Icons.chevron_right),
                      onTap: () async {
                        final route = MaterialPageRoute(
                          builder: (_) => SelectOutletScreen(
                            beatName: beat.area,
                          ),
                        );

                        widget.goToOutletAfterBeat
                            ? await Navigator.pushReplacement(
                            context, route)
                            : await Navigator.push(
                            context, route);
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

  // 🔝 HEADER (UNCHANGED)
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
          Image.asset('assets/images/TrooGood_Logo.png', height: 42),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline,
                    size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddBeatScreen(),
                    ),
                  );
                },
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
  }
}
