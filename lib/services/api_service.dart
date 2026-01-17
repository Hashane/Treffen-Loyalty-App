import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/config/env_config.dart';

class ApiService {
  final String _baseUrl = EnvConfig.baseUrl;
  final FlutterSecureStorage _secureStorage;

  ApiService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Get authentication token from secure storage
  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  /// Build headers with authentication
  Future<Map<String, String>> _buildHeaders() async {
    final token = await _getAuthToken();
    final headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Generic GET request handler
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _buildHeaders();

      if (EnvConfig.enableLogging) {
        print('[API] GET $uri');
      }

      final response = await http.get(uri, headers: headers);

      if (EnvConfig.enableLogging) {
        print('[API] Response: ${response.statusCode}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (EnvConfig.enableLogging) {
        print('[API] Error: $e');
      }
      return {'success': false, 'message': 'Network error: ${e.toString()}', 'error': e.toString()};
    }
  }

  /// Generic POST request handler
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _buildHeaders();

      if (EnvConfig.enableLogging) {
        print('[API] POST $uri');
        print('[API] Body: $body');
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      if (EnvConfig.enableLogging) {
        print('[API] Response: ${response.statusCode}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (EnvConfig.enableLogging) {
        print('[API] Error: $e');
      }
      return {'success': false, 'message': 'Network error: ${e.toString()}', 'error': e.toString()};
    }
  }

  /// Generic PUT request handler
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _buildHeaders();

      if (EnvConfig.enableLogging) {
        print('[API] PUT $uri');
        print('[API] Body: $body');
      }

      final response = await http.put(
        uri,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      if (EnvConfig.enableLogging) {
        print('[API] Response: ${response.statusCode}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (EnvConfig.enableLogging) {
        print('[API] Error: $e');
      }
      return {'success': false, 'message': 'Network error: ${e.toString()}', 'error': e.toString()};
    }
  }

  /// Generic DELETE request handler
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _buildHeaders();

      if (EnvConfig.enableLogging) {
        print('[API] DELETE $uri');
      }

      final response = await http.delete(uri, headers: headers);

      if (EnvConfig.enableLogging) {
        print('[API] Response: ${response.statusCode}');
      }

      return _handleResponse(response);
    } catch (e) {
      if (EnvConfig.enableLogging) {
        print('[API] Error: $e');
      }
      return {'success': false, 'message': 'Network error: ${e.toString()}', 'error': e.toString()};
    }
  }

  /// Handle HTTP response and return standardized format
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': body['data'] ?? body,
          'message': body['message'],
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Request failed',
          'error': body['error'],
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to parse response',
        'error': e.toString(),
        'statusCode': response.statusCode,
        'rawBody': response.body,
      };
    }
  }
}
