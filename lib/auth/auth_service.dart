import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/local_storage.dart';

class AuthService {
  static const String _loginUrl =
      'https://troogood.in/api/V1/salesexecutives/login';

  // ---------------- LOGIN ----------------
  static Future<bool> login({
    required String mobile,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobile': mobile,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['success'] == 'true') {
        final data = json['data'];

        await LocalStorage.saveUser(
          id: data['id'],
          name: data['name'],
          mobile: data['mobile'],
        );

        // JWT not provided yet by backend
        // await LocalStorage.saveToken(json['token']);

        return true;
      }
    }
    return false;
  }

  // ---------------- TOKEN ----------------
  static Future<String?> getToken() async {
    return LocalStorage.getToken();
  }

  // ---------------- SESSION ----------------
  static Future<bool> isLoggedIn() async {
    return LocalStorage.isLoggedIn();
  }

  // ---------------- LOGOUT ----------------
  static Future<void> logout() async {
    await LocalStorage.clear();
  }
}
