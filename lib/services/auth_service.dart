// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Service for managing user authentication UUID
/// The UUID is stored locally and sent with all API requests
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _uuidKey = 'user_uuid';
  static const String _userNameKey = 'user_name';
  String? _cachedUuid;
  String? _cachedUserName;

  /// Get the stored UUID
  /// Returns null if no UUID is stored
  Future<String?> getUuid() async {
    // Return cached UUID if available
    if (_cachedUuid != null) {
      return _cachedUuid;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedUuid = prefs.getString(_uuidKey);
      return _cachedUuid;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving UUID: $e');
      }
      return null;
    }
  }

  /// Store the UUID
  /// Returns true if successful
  Future<bool> setUuid(String uuid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_uuidKey, uuid);
      
      if (success) {
        _cachedUuid = uuid;
        if (kDebugMode) {
          print('UUID stored successfully');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error storing UUID: $e');
      }
      return false;
    }
  }

  /// Get the stored user name
  /// Returns null if no user name is stored
  Future<String?> getUserName() async {
    // Return cached user name if available
    if (_cachedUserName != null) {
      return _cachedUserName;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedUserName = prefs.getString(_userNameKey);
      return _cachedUserName;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving user name: $e');
      }
      return null;
    }
  }

  /// Store the user name
  /// Returns true if successful
  Future<bool> setUserName(String userName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_userNameKey, userName);
      
      if (success) {
        _cachedUserName = userName;
        if (kDebugMode) {
          print('User name stored successfully');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error storing user name: $e');
      }
      return false;
    }
  }

  /// Clear the stored UUID and user name (logout)
  /// Returns true if successful
  Future<bool> clearUuid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuidSuccess = await prefs.remove(_uuidKey);
      final nameSuccess = await prefs.remove(_userNameKey);
      
      if (uuidSuccess && nameSuccess) {
        _cachedUuid = null;
        _cachedUserName = null;
        if (kDebugMode) {
          print('UUID and user name cleared successfully');
        }
      }
      
      return uuidSuccess && nameSuccess;
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing UUID: $e');
      }
      return false;
    }
  }

  /// Check if a UUID is stored
  Future<bool> hasUuid() async {
    final uuid = await getUuid();
    return uuid != null && uuid.isNotEmpty;
  }

  /// Get the authorization header value
  // ignore: unintended_html_in_doc_comment
  /// Returns "Bearer <uuid>" format as expected by the API
  /// Returns null if no UUID is stored
  Future<String?> getAuthHeader() async {
    final uuid = await getUuid();
    if (uuid == null || uuid.isEmpty) {
      return null;
    }
    return 'Bearer $uuid';
  }

  /// Get full headers map for API requests
  /// Throws exception if no UUID is stored
  Future<Map<String, String>> getAuthHeaders() async {
    final uuid = await getUuid();
    if (uuid == null || uuid.isEmpty) {
      throw Exception('No UUID found. User not authenticated.');
    }
    return {
      'Authorization': 'Bearer $uuid',
      'Content-Type': 'application/json',
    };
  }
}