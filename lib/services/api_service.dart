import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/app_user.dart';

/// An error with a message that is safe to show to the user.
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Talks to the .NET backend. The app never connects to PostgreSQL directly.
class ApiService {
  ApiService._();

  static const _tokenKey = 'auth_token';
  static const _timeout = Duration(seconds: 15);
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String? _token;

  // ---------- Public API ----------

  static Future<AppUser> login({
    required String email,
    required String password,
    required bool remember,
  }) async {
    final body = await _post('/api/auth/login', {'email': email, 'password': password});

    final token = body['token'] as String;
    _token = token;

    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }

    return AppUser.fromJson(body['user'] as Map<String, dynamic>);
  }

  static Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String language,
    String? phone,
  }) async {
    await _post('/api/auth/register', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'language': language,
      'phone': (phone == null || phone.isEmpty) ? null : phone,
    });
  }

  /// Called at app start: if a saved token is still valid, returns the user.
  static Future<AppUser?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null) return null;

    try {
      final res = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/auth/me'),
            headers: {..._headers, 'Authorization': 'Bearer $token'},
          )
          .timeout(_timeout);

      if (res.statusCode == 200) {
        _token = token;
        return AppUser.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
      }

      if (res.statusCode == 401 || res.statusCode == 403) {
        await prefs.remove(_tokenKey); // expired or account suspended
      }
    } on TimeoutException {
      // Server not reachable: keep the token, show the login screen.
    } on http.ClientException {
      // Same: keep the token for next time.
    }
    return null;
  }

  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// For future authenticated calls (reports, etc.).
  static Map<String, String> get authHeaders => {
        ..._headers,
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ---------- Helpers ----------

  static Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> data) async {
    final http.Response res;
    try {
      res = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$path'),
            headers: _headers,
            body: jsonEncode(data),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw ApiException('The server took too long to respond. Please try again.');
    } on http.ClientException {
      throw ApiException('Cannot reach the server. Check that the backend is running and the address is correct.');
    }
    return _handle(res);
  }

  static Map<String, dynamic> _handle(http.Response res) {
    Map<String, dynamic> body = {};
    if (res.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) body = decoded;
      } catch (_) {
        // not JSON: fall through to the generic message
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException(_errorMessage(body, res.statusCode));
  }

  static String _errorMessage(Map<String, dynamic> body, int status) {
    // ASP.NET validation errors: { "errors": { "Email": ["..."] } }
    final errors = body['errors'];
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
      }
    }

    final message = body['message'];
    if (message is String && message.isNotEmpty) return message;

    if (status == 401) return 'Invalid email or password.';
    return 'Something went wrong (error $status).';
  }
}
