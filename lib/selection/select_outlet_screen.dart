import 'package:flutter/material.dart';

import '../notifications/notification_screen.dart';
import 'select_beat_screen.dart';
import 'add_outlet_screen.dart';
import '../selfie/selfie_camera_screen.dart';

import '../api/store_api.dart';
import '../models/store_model.dart';

import '../services/network_service.dart';
import '../services/local_storage.dart';


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
  StoreModel? selectedStore; // ✅ STORE MODEL (NOT JUST NAME)
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  late Future<List<StoreModel>> storeFuture;
  List<StoreModel> allStores = [];

  @override
  void initState() {
    super.initState();

    storeFuture = _loadStores();
  }

  // ===============================
  // 🌐 ONLINE / OFFLINE STORE LOADER
  // ===============================
  Future<List<StoreModel>> _loadStores() async {
    final hasInternet = await NetworkService.hasInternet();

    if (hasInternet) {
      return await StoreApi.getStoresBySeller(
        sellerId: 5, // TODO: replace with logged-in seller
        beatArea: widget.beatName,
      );
    } else {
      final localStores = await LocalStorage.getStores();
      return localStores
          .map((e) => StoreModel.fromJson(e))
          .where((s) => s.area == widget.beatName)
          .toList();
    }
  }

  void _addNewOutlet() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddOutletScreen(beatName: widget.beatName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SelectBeatScreen()),
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

              // 🕒 LAST SYNC
              FutureBuilder<String?>(
                future: LocalStorage.getLastSyncTime(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Last synced: ${snapshot.data}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
              ),

              _search(),
              const SizedBox(height: 10),

              // ===============================
              // 📦 OUTLET LIST
              // ===============================
              Expanded(
                child: FutureBuilder<List<StoreModel>>(
                  future: storeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Failed to load outlets",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    allStores = snapshot.data ?? [];

                    final filteredStores = allStores.where((store) {
                      return store.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                    }).toList();

                    if (filteredStores.isEmpty) {
                      return const Center(
                        child: Text(
                          "No outlets found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredStores.length,
                      itemBuilder: (context, index) {
                        final store = filteredStores[index];

                        return ListTile(
                          title: Text(
                            store.name.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(int.parse(store.color)),
                            ),
                          ),
                          subtitle: Text(
                            '₹ ${store.lifeValue} | Repeats: ${store.repeatCount}',
                          ),
                          trailing: selectedStore?.id == store.id
                              ? const Icon(Icons.check_box,
                              color: Colors.blue)
                              : const Icon(
                              Icons.check_box_outline_blank),
                          onTap: () {
                            setState(() {
                              selectedStore = store;
                            });
                          },
                        );
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

  // ===============================
  // 🔝 HEADER
  // ===============================
  Widget _header(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SelectBeatScreen()),
            );
          },
          child: const Icon(Icons.arrow_back, size: 28),
        ),
        Image.asset('assets/images/TrooGood_Logo.png', height: 45),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 28),
              onPressed: _addNewOutlet,
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
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
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Outlet",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: "Search outlet",
        ),
        onChanged: (v) => setState(() => searchQuery = v),
      ),
    ),
  );

  // ===============================
  // ✅ PROCEED → CAMERA (STORE ID PASSED)
  // ===============================
  Widget _proceed(BuildContext context) => GestureDetector(
    onTap: selectedStore == null
        ? null
        : () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SelfieCameraScreen(
            storeId: selectedStore!.id, // ✅ FIXED
            outletName: selectedStore!.name,
            beatName: widget.beatName,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      color: selectedStore == null ? Colors.grey : Colors.blue,
      child: Text(
        selectedStore == null
            ? "SELECT OUTLET TO PROCEED"
            : "PROCEED →",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
