// lib/activity_logger.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ActivityLogger {
  // ========================================================
  // DAILY ACTIVITY LOGS (EXISTING - UNTOUCHED)
  // ========================================================
  static Map<String, List<Map<String, String>>> dailyLogs = {};
  static const String storageKey = "timeline_logs";

  // ========================================================
  // MASTER DATA (SAFE ADDITION)
  // ========================================================
  static const String beatKey = "user_beats";
  static const String outletKey = "user_outlets";

  static List<String> beats = [];
  static Map<String, List<Map<String, String>>> outlets = {};

  // Today key
  static String get todayKey =>
      DateFormat("yyyy-MM-dd").format(DateTime.now());

  // --------------------------------------------------------
  // INITIALIZE — LOAD LOGS + MASTER DATA
  // --------------------------------------------------------
  static Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // -------- LOAD DAILY LOGS --------
    String? jsonString = prefs.getString(storageKey);
    if (jsonString != null) {
      try {
        Map<String, dynamic> decoded = jsonDecode(jsonString);
        decoded.forEach((key, value) {
          dailyLogs[key] = List<Map<String, String>>.from(
            value.map((e) => Map<String, String>.from(e)),
          );
        });
      } catch (_) {
        dailyLogs = {};
      }
    }

    dailyLogs.putIfAbsent(todayKey, () => []);
    await saveLogs();

    // -------- LOAD BEATS --------
    String? beatJson = prefs.getString(beatKey);
    if (beatJson != null) {
      beats = List<String>.from(jsonDecode(beatJson));
    }

    // -------- LOAD OUTLETS --------
    String? outletJson = prefs.getString(outletKey);
    if (outletJson != null) {
      Map<String, dynamic> decoded = jsonDecode(outletJson);
      decoded.forEach((beat, list) {
        outlets[beat] = List<Map<String, String>>.from(
          list.map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  // --------------------------------------------------------
  // SAVE LOG DATA
  // --------------------------------------------------------
  static Future<void> saveLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(dailyLogs));
  }

  // ========================================================
  // MASTER DATA — BEATS
  // ========================================================
  static Future<void> addBeat(String beatName) async {
    if (beatName.trim().isEmpty) return;
    if (beats.contains(beatName)) return;

    beats.add(beatName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(beatKey, jsonEncode(beats));
  }

  static List<String> getBeats() {
    return beats;
  }

  // 🔁 RENAME BEAT (MOVE OUTLETS SAFELY)
  static Future<void> renameBeat(
      String oldBeatName,
      String newBeatName,
      ) async {
    if (oldBeatName == newBeatName) return;

    // Move outlets
    final oldOutlets = outlets[oldBeatName] ?? [];
    if (oldOutlets.isNotEmpty) {
      outlets.putIfAbsent(newBeatName, () => []);
      for (final outlet in oldOutlets) {
        final exists = outlets[newBeatName]!
            .any((o) => o["name"] == outlet["name"]);
        if (!exists) {
          outlets[newBeatName]!.add(outlet);
        }
      }
    }

    // Remove old beat + outlets
    outlets.remove(oldBeatName);
    beats.remove(oldBeatName);

    // Add new beat if missing
    if (!beats.contains(newBeatName)) {
      beats.add(newBeatName);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(beatKey, jsonEncode(beats));
    await prefs.setString(outletKey, jsonEncode(outlets));
  }

  // ========================================================
  // MASTER DATA — OUTLETS
  // ========================================================
  static Future<void> addOutlet(
      String beatName,
      Map<String, String> outlet,
      ) async {
    if (!outlet.containsKey("name") || !outlet.containsKey("city")) return;

    outlets.putIfAbsent(beatName, () => []);

    bool exists =
    outlets[beatName]!.any((o) => o["name"] == outlet["name"]);

    if (!exists) {
      outlets[beatName]!.add({
        "name": outlet["name"]!,
        "city": outlet["city"]!,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(outletKey, jsonEncode(outlets));
    }
  }

  static List<Map<String, String>> getOutlets(String beatName) {
    return outlets[beatName] ?? [];
  }

  // ========================================================
  // GENERIC LOG ENTRY
  // ========================================================
  static void add(String title, String subtitle, String type) {
    String date = todayKey;
    dailyLogs.putIfAbsent(date, () => []);

    dailyLogs[date]!.add({
      "title": title,
      "subtitle": subtitle,
      "type": type,
      "time": DateFormat("hh:mm a").format(DateTime.now()),
    });

    saveLogs();
  }

  // ========================================================
  // MERCHANDISING LOG
  // ========================================================
  static void addMerchandising(String outletName) {
    String date = todayKey;
    dailyLogs.putIfAbsent(date, () => []);

    bool alreadyLogged = dailyLogs[date]!.any(
          (log) => log["type"] == "merch" && log["subtitle"] == outletName,
    );

    if (!alreadyLogged) {
      dailyLogs[date]!.add({
        "title": "Merchandising",
        "subtitle": outletName,
        "type": "merch",
        "time": DateFormat("hh:mm a").format(DateTime.now()),
      });

      saveLogs();
    }
  }

  // ========================================================
  // STOCK UPDATE (UNCHANGED)
  // ========================================================
  static void addStock(String item, String qty, [String? storeName]) {
    String date = todayKey;
    dailyLogs.putIfAbsent(date, () => []);

    String formatted = storeName != null && storeName.isNotEmpty
        ? "$storeName → $item → $qty pcs"
        : "$item → $qty pcs";

    dailyLogs[date]!.add({
      "title": "Stock Updated",
      "subtitle": formatted,
      "type": "stock_update",
      "time": DateFormat("hh:mm a").format(DateTime.now()),
    });

    saveLogs();
  }

  // ========================================================
  // SHORTCUT EVENTS
  // ========================================================
  static void appOpened() =>
      add("App Opened", "User started the app", "start");

  static void storeOut() =>
      add("Store Out", "User finished Store", "store_end");

  static void officialWork(String reason) =>
      add("Official Work", reason, "official");

  static void markLeave(String type) =>
      add("Leave Marked", type, "leave");

  static void addPurchaseOrder(String store) =>
      add("Purchase Order", "Created for $store", "po");

  static void addStoreVisit(String store) =>
      add("Store Visit", store, "store");

  static void addTask(String taskTitle) =>
      add("Task Completed", taskTitle, "task");

  // ========================================================
  // CHECK IF TASK COMPLETED
  // ========================================================
  static bool isTaskCompleted(String taskTitle) {
    String dateKey = todayKey;
    if (!dailyLogs.containsKey(dateKey)) return false;

    return dailyLogs[dateKey]!.any(
          (log) => log["type"] == "task" && log["subtitle"] == taskTitle,
    );
  }

  // ========================================================
  // RAW LOG ACCESS
  // ========================================================
  static Map<String, List<Map<String, String>>> getLogs() {
    return dailyLogs;
  }

  // ========================================================
  // DAYWISE SUMMARY (UNCHANGED)
  // ========================================================
  static Map<String, Map<String, dynamic>> getSummary() {
    Map<String, Map<String, dynamic>> result = {};

    dailyLogs.forEach((date, logs) {
      String appOpen = "-";
      String lastStore = "-";
      int storeCount = 0;
      int revisits = 0;
      int poCount = 0;
      int taskCount = 0;
      String status = "Present";
      String officialWork = "-";
      Map<String, int> stockUpdates = {};

      String? lastUniqueStore;

      for (var log in logs) {
        switch (log["type"]) {
          case "start":
            appOpen = log["time"] ?? appOpen;
            break;
          case "store":
            String store = (log["subtitle"] ?? "-").trim();
            if (lastUniqueStore != store) {
              storeCount++;
              lastUniqueStore = store;
            } else {
              revisits++;
            }
            lastStore = store;
            break;
          case "po":
            poCount++;
            break;
          case "task":
            taskCount++;
            break;
          case "leave":
            status = log["subtitle"] ?? status;
            break;
          case "official":
            officialWork = log["subtitle"] ?? officialWork;
            break;
          case "stock_update":
            final subtitle = log["subtitle"] ?? "";
            for (var raw in subtitle.split("\n")) {
              if (!raw.contains("→")) continue;
              var parts = raw.split("→").map((e) => e.trim()).toList();
              if (parts.length < 2) continue;
              String item = parts[parts.length - 2];
              int qty = int.tryParse(
                  parts.last.replaceAll(RegExp(r'[^\d-]'), '')) ??
                  0;
              stockUpdates[item] = (stockUpdates[item] ?? 0) + qty;
            }
            break;
        }
      }

      result[date] = {
        "appOpen": appOpen,
        "storesVisited": storeCount,
        "revisits": revisits,
        "purchaseOrders": poCount,
        "tasksCompleted": taskCount,
        "status": status,
        "officialWork": officialWork,
        "lastStore": lastStore,
        "stockUpdates": stockUpdates,
      };
    });

    return result;
  }
}
