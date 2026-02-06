// lib/services/sync_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import 'database_helper.dart';
import 'auth_service.dart';
import 'api_client.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();

  /// Sync all locally created records to the server
  Future<SyncResult> syncLocalRecords() async {
    // Check if we have a UUID before attempting sync
    if (!await _authService.hasUuid()) {
      return SyncResult(
        uploadedCount: 0,
        failedCount: 0,
        errors: ['No authentication UUID found. Cannot sync without authentication.'],
      );
    }

    int uploadedCount = 0;
    int failedCount = 0;
    List<String> errors = [];

    try {
      // Sync inspections
      final inspectionResult = await _syncInspections();
      uploadedCount += inspectionResult.uploadedCount;
      failedCount += inspectionResult.failedCount;
      errors.addAll(inspectionResult.errors);

      // TODO: Add other inspection types
      // final backflowResult = await _syncBackflow();
      // final pumpSystemResult = await _syncPumpSystems();
      // final drySystemResult = await _syncDrySystems();

      return SyncResult(
        uploadedCount: uploadedCount,
        failedCount: failedCount,
        errors: errors,
      );
    } catch (e) {
      return SyncResult(
        uploadedCount: 0,
        failedCount: 1,
        errors: ['Sync failed: $e'],
      );
    }
  }

  Future<SyncResult> _syncInspections() async {
    int uploadedCount = 0;
    int failedCount = 0;
    List<String> errors = [];

    try {
      final db = await _dbHelper.database;
      
      // Get all locally created inspections that haven't been synced
      final result = await db.rawQuery('''
        SELECT * FROM inspections 
        WHERE json_extract(form_data, '\$.created_locally') = true
        AND (json_extract(form_data, '\$.synced_to_server') IS NULL OR json_extract(form_data, '\$.synced_to_server') = false)
      ''');

      if (kDebugMode) {
        print('Found ${result.length} local inspections to sync');
      }

      for (final row in result) {
        try {
          final formDataStr = row['form_data'] as String;
          final formData = jsonDecode(formDataStr) as Map<String, dynamic>;
          
          // Upload to server
          final success = await _uploadInspectionToServer(formData);
          
          if (success) {
            // Mark as synced in local database
            await _markInspectionAsSynced(row['pdf_path'] as String);
            uploadedCount++;
            
            if (kDebugMode) {
              print('Successfully synced inspection: ${formData['pdf_path']}');
            }
          } else {
            failedCount++;
            errors.add('Failed to upload inspection: ${formData['pdf_path']}');
          }
        } catch (e) {
          failedCount++;
          errors.add('Error uploading inspection: $e');
          if (kDebugMode) {
            print('Error syncing inspection: $e');
          }
        }
      }
    } catch (e) {
      errors.add('Error fetching local inspections: $e');
      failedCount++;
    }

    return SyncResult(
      uploadedCount: uploadedCount,
      failedCount: failedCount,
      errors: errors,
    );
  }

  Future<bool> _uploadInspectionToServer(Map<String, dynamic> formData) async {
    try {
      // Prepare the data for the API
      final apiData = _prepareInspectionForAPI(formData);
      
      final response = await _apiClient.post(
        Uri.parse('${AppConfig.baseUrl}/inspections'),
        body: apiData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        if (kDebugMode) {
          print('Server returned ${response.statusCode}: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Network error uploading inspection: $e');
      }
      return false;
    }
  }

  Map<String, dynamic> _prepareInspectionForAPI(Map<String, dynamic> formData) {
    // Convert the local format to the API format
    // Remove local-only fields and ensure proper formatting
    final apiData = Map<String, dynamic>.from(formData);
    
    // Remove local-only flags
    apiData.remove('created_locally');
    apiData.remove('synced_to_server');
    apiData.remove('last_modified');
    
    // Ensure required fields are present
    apiData['created_at'] = DateTime.now().toIso8601String();
    apiData['updated_at'] = DateTime.now().toIso8601String();
    
    return apiData;
  }

  Future<void> _markInspectionAsSynced(String pdfPath) async {
    final db = await _dbHelper.database;
    
    // Get current form data
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      final formDataStr = result.first['form_data'] as String;
      final formData = jsonDecode(formDataStr) as Map<String, dynamic>;
      
      // Mark as synced
      formData['synced_to_server'] = true;
      formData['synced_at'] = DateTime.now().toIso8601String();
      
      // Update the record
      await db.update(
        'inspections',
        {
          'form_data': jsonEncode(formData),
          'last_modified': DateTime.now().toIso8601String(),
        },
        where: 'pdf_path = ?',
        whereArgs: [pdfPath],
      );
    }
  }

  /// Check if there are any local records that need syncing
  Future<bool> hasLocalRecordsToSync() async {
    try {
      final db = await _dbHelper.database;
      
      final tables = ['inspections', 'backflow', 'pump_systems', 'dry_systems'];
      
      for (final table in tables) {
        final result = await db.rawQuery('''
          SELECT COUNT(*) as count FROM $table 
          WHERE json_extract(form_data, '\$.created_locally') = true
          AND (json_extract(form_data, '\$.synced_to_server') IS NULL OR json_extract(form_data, '\$.synced_to_server') = false)
        ''');
        
        final count = result.first['count'] as int;
        if (count > 0) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking for local records: $e');
      }
      return false;
    }
  }

  /// Get count of local records by type
  Future<Map<String, int>> getLocalRecordsCounts() async {
    final counts = <String, int>{};
    
    try {
      final db = await _dbHelper.database;
      
      final tables = {
        'inspections': 'inspections',
        'backflow': 'backflow',
        'pump_systems': 'pump_systems', 
        'dry_systems': 'dry_systems',
      };
      
      for (final entry in tables.entries) {
        final result = await db.rawQuery('''
          SELECT COUNT(*) as count FROM ${entry.value}
          WHERE json_extract(form_data, '\$.created_locally') = true
          AND (json_extract(form_data, '\$.synced_to_server') IS NULL OR json_extract(form_data, '\$.synced_to_server') = false)
        ''');
        
        counts[entry.key] = result.first['count'] as int;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting local records counts: $e');
      }
    }
    
    return counts;
  }
}

class SyncResult {
  final int uploadedCount;
  final int failedCount;
  final List<String> errors;

  SyncResult({
    required this.uploadedCount,
    required this.failedCount,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => failedCount == 0;
  int get totalProcessed => uploadedCount + failedCount;
}