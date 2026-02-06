// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _apiClient = ApiClient();

  /// Fetch all users with role='user' from the API
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/users');
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final users = data['users'] as List<dynamic>;
        return users.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
