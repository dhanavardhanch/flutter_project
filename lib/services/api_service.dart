import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';

class ApiService {
  static const String baseUrl = "https://troogood.in/api/V1";

  static Future<http.Response> get(String endpoint) async {
    final token = await AuthService.getToken();

    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> post(
      String endpoint, Map<String, dynamic> body) async {
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
