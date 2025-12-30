import '../api/beat_api.dart';
import '../api/store_api.dart';
import '../api/product_api.dart';
import '../services/local_storage.dart';
import '../services/network_service.dart';

class MasterSyncService {
  static Future<void> syncAll({
    required int sellerId,
  }) async {
    // 🌐 CHECK INTERNET FIRST
    final hasInternet = await NetworkService.hasInternet();
    if (!hasInternet) {
      // Offline → use cached data, do NOT throw
      return;
    }

    try {
      // =========================
      // 1️⃣ BEATS
      // =========================
      final beats = await BeatApi.getBeatsBySeller(
        sellerId: sellerId,
      );

      await LocalStorage.saveBeats(
        beats.map((b) => b.toJson()).toList(),
      );

      // =========================
      // 2️⃣ STORES (BY BEAT AREA)
      // =========================
      final List<Map<String, dynamic>> allStores = [];

      for (final beat in beats) {
        final stores = await StoreApi.getStoresBySeller(
          sellerId: sellerId,
          beatArea: beat.area,
        );

        for (final store in stores) {
          allStores.add(store.toJson());
        }
      }

      await LocalStorage.saveStores(allStores);

      // =========================
      // 3️⃣ PRODUCTS (GLOBAL)
      // =========================
      final products = await ProductApi.getProducts();

      await LocalStorage.saveProducts(
        products.map((p) => p.toJson()).toList(),
      );

      // =========================
      // 4️⃣ LAST SYNC TIME
      // =========================
      await LocalStorage.saveLastSyncTime();
    } catch (e) {
      // ❌ DO NOT crash app for sync failures
      // Log if needed, but allow offline flow
    }
  }
}
