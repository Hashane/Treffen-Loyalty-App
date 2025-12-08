import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/config/env_config.dart';

class AuthService {
  final String _baseUrl = EnvConfig.baseUrl;
  final FlutterSecureStorage _secureStorage;

  AuthService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Attempts to log in and returns a result map:
  /// { 'success': bool, 'token': String?, 'message': String? }
  Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );

      if (resp.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(resp.body);

        final token = body['data']['token'] as String?;
        if (token != null && token.isNotEmpty) {
          // persist token securely
          await _secureStorage.write(key: 'access_token', value: token);
        }
        return {'success': true, 'token': token, 'data': body};
      }

      // Try to parse error message
      String message = 'Login failed';
      try {
        final Map<String, dynamic> body = jsonDecode(resp.body);
        message = body['message'] ?? body['error'] ?? message;
      } catch (_) {}

      return {'success': false, 'status': resp.statusCode, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async => await _secureStorage.read(key: 'auth_token');
}
