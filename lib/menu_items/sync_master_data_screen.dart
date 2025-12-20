import 'package:flutter/material.dart';

class SyncMasterDataScreen extends StatefulWidget {
  const SyncMasterDataScreen({super.key});

  @override
  State<SyncMasterDataScreen> createState() => _SyncMasterDataScreenState();
}

class _SyncMasterDataScreenState extends State<SyncMasterDataScreen> {
  bool isSyncing = false;

  Future<void> syncMasterData() async {
    setState(() => isSyncing = true);

    // TODO: Add your API calls here.
    await Future.delayed(const Duration(seconds: 3));

    setState(() => isSyncing = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sync Complete"),
        content: const Text("Master data has been successfully synced."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00AEEF),
        elevation: 0,
        title: const Text("Sync Master Data"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7FBFE), Color(0xFFEAF3FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isSyncing
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Color(0xFF00AEEF)),
              SizedBox(height: 16),
              Text("Syncing...", style: TextStyle(fontSize: 16)),
            ],
          )
              : ElevatedButton.icon(
            onPressed: syncMasterData,
            icon: const Icon(Icons.sync),
            label: const Text("Start Sync"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00AEEF),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
