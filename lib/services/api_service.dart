import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';

class ApiService {
  // ✅ Correct base URL as per manager
  static const String baseUrl = "https://troogood.in/api/V1";

  // --------------------------------------------------
  // GET REQUEST
  // --------------------------------------------------
  static Future<http.Response> get(String endpoint) async {
    final token = await AuthService.getToken();

    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',

        // ⚠️ JWT optional for now (backend said leave JWT part)
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // --------------------------------------------------
  // POST REQUEST
  // --------------------------------------------------
  static Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final token = await AuthService.getToken();

    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
