// lib/services/api_client.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';

/// HTTP client wrapper that automatically includes authentication headers
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final AuthService _authService = AuthService();

  /// Perform authenticated GET request
  Future<http.Response> get(Uri url) async {
    final headers = await _authService.getAuthHeaders();
    return await http.get(url, headers: headers);
  }

  /// Perform authenticated POST request
  Future<http.Response> post(Uri url, {Map<String, dynamic>? body}) async {
    final headers = await _authService.getAuthHeaders();
    return await http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Perform authenticated PUT request
  Future<http.Response> put(Uri url, {Map<String, dynamic>? body}) async {
    final headers = await _authService.getAuthHeaders();
    return await http.put(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Perform authenticated DELETE request
  Future<http.Response> delete(Uri url) async {
    final headers = await _authService.getAuthHeaders();
    return await http.delete(url, headers: headers);
  }
}