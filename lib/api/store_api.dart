import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/store_model.dart';
import 'api_config.dart';

class StoreApi {
  static Future<List<StoreModel>> getStoresBySeller({
    required int sellerId,
    required String beatArea,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/V1/stores/listbyseller"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "seller_id": sellerId,
        "searchString": beatArea, // 🔥 Beat = Area
        "quantity": 20,
        "page": 0,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data'];
      return list.map((e) => StoreModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load stores");
    }
  }
}
