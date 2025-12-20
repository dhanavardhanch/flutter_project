import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // 🔐 JWT storage key
  static const String _tokenKey = 'jwt_token';

  // ------------------------------------------------------------------
  // SAVE JWT TOKEN
  // ------------------------------------------------------------------
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // ------------------------------------------------------------------
  // GET JWT TOKEN
  // ------------------------------------------------------------------
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // ------------------------------------------------------------------
  // CLEAR JWT TOKEN (LOGOUT)
  // ------------------------------------------------------------------
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ------------------------------------------------------------------
  // LOGIN (TEMP DEV STUB)
  // ------------------------------------------------------------------
  /// This is a TEMPORARY login implementation.
  /// Backend (Laravel) will later validate credentials and return real JWT.
  /// For now, we simulate login and store a dummy JWT.
  static Future<bool> login() async {
    const String dummyJwtToken = "DEV_JWT_TOKEN";

    await saveToken(dummyJwtToken);

    return true;
  }
}
