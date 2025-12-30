import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/beat_model.dart';
import 'api_config.dart';

class BeatApi {
  static Future<List<BeatModel>> getBeatsBySeller({
    required int sellerId,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/V1/beats/listbyseller"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "seller_id": sellerId,
        "searchString": "",
        "quantity": 50,
        "page": 0,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List list = decoded['data'];
      return list.map((e) => BeatModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load beats");
    }
  }
}
