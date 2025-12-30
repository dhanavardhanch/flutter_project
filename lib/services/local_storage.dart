import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _userId = 'user_id';
  static const _userName = 'user_name';
  static const _mobile = 'mobile';
  static const _tokenKey = 'auth_token';

  static const _beatsKey = 'beats';
  static const _storesKey = 'stores';
  static const _productsKey = 'products';
  static const _lastSyncKey = 'last_sync_time';

  // 🔑 BASE KEY FOR TRANSACTIONS
  static String _transactionKey(int storeId) =>
      'transactions_store_$storeId';

  // ---------- AUTH ----------
  static Future<void> saveUser({
    required int id,
    required String name,
    required String mobile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userId, id);
    await prefs.setString(_userName, name);
    await prefs.setString(_mobile, mobile);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userId);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ---------- MASTER SAVE ----------
  static Future<void> saveBeats(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_beatsKey, jsonEncode(data));
  }

  static Future<void> saveStores(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storesKey, jsonEncode(data));
  }

  static Future<void> saveProducts(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_productsKey, jsonEncode(data));
  }

  // ✅ STORE-WISE TRANSACTIONS SAVE
  static Future<void> saveTransactions(
      int storeId,
      List<Map<String, dynamic>> data,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _transactionKey(storeId),
      jsonEncode(data),
    );
  }

  static Future<void> saveLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastSyncKey,
      DateTime.now().toIso8601String(),
    );
  }

  // ---------- MASTER GET ----------
  static Future<List<Map<String, dynamic>>> getBeats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_beatsKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<List<Map<String, dynamic>>> getStores() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storesKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_productsKey);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  // ✅ STORE-WISE TRANSACTIONS GET
  static Future<List<Map<String, dynamic>>> getTransactions(
      int storeId,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_transactionKey(storeId));
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<String?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastSyncKey);
  }

  // ---------- LOGOUT ----------
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
