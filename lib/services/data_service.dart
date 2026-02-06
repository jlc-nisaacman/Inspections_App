// lib/services/data_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/inspection_data.dart';
import '../models/backflow_data.dart';
import '../models/pump_system_data.dart';
import '../models/dry_system_data.dart';
import '../models/pagination.dart';
import '../models/api_response_inspection.dart';
import '../models/api_response_backflow.dart';
import '../models/api_response_pump_system.dart';
import '../models/api_response_dry_system.dart';
import '../config/app_config.dart';
import '../services/database_helper.dart';
import '../services/inspection_creation_service.dart';
import '../services/auth_service.dart';
import 'api_client.dart';

enum ConnectionStatus {
  connected,
  noNetwork,
  serverUnreachable
}

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Connectivity _connectivity = Connectivity();
  final InspectionCreationService _creationService = InspectionCreationService();
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();
  
  // Cache the online status to avoid hammering the server
  bool? _cachedOnlineStatus;
  DateTime? _lastHealthCheck;
  static const Duration _healthCheckCacheDuration = Duration(seconds: 30);

  /// Check if device is online AND can reach the API server
  /// 
  /// This does two checks:
  /// 1. Fast check: Does the device have network connectivity (WiFi/cellular)?
  /// 2. Real check: Can we actually reach the API server with a health ping?
  /// 
  /// Results are cached for 30 seconds to avoid excessive server pings.
  Future<bool> isOnline() async {
    // First, check basic connectivity (fast check)
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _cachedOnlineStatus = false;
      return false;
    }

    // If we have a recent cached result, use it
    if (_cachedOnlineStatus != null && 
        _lastHealthCheck != null && 
        DateTime.now().difference(_lastHealthCheck!) < _healthCheckCacheDuration) {
      return _cachedOnlineStatus!;
    }

    // Actually ping the API server to verify it's reachable
    // Note: Health endpoint doesn't require auth
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/health'))
          .timeout(const Duration(seconds: 2));
      
      final isReachable = response.statusCode == 200;
      
      // Cache the result
      _cachedOnlineStatus = isReachable;
      _lastHealthCheck = DateTime.now();
      
      return isReachable;
    } catch (e) {
      // Server is unreachable
      _cachedOnlineStatus = false;
      _lastHealthCheck = DateTime.now();
      return false;
    }
  }

  // ============================================================================
  // INSPECTIONS
  // ============================================================================

  Future<ApiResponseInspection> getInspections({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
    bool forceOffline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    if (forceOffline) {
      return await _getInspectionsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      );
    }

    return await _fetchWithFallback<ApiResponseInspection>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchInspectionsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getInspectionsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      saveToCache: (data) => _dbHelper.saveInspections(data.data),
    );
  }

  Future<ApiResponseInspection> _fetchInspectionsFromAPI({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.get(
      Uri.parse(
        AppConfig.getEndpointUrl(
          AppConfig.inspectionsEndpoint,
          queryParams: {'page': page},
          searchTerm: searchTerm,
          searchColumn: searchColumn,
          startDate: startDate != null 
            ? DateFormat('yyyy-MM-dd').format(startDate) 
            : null,
          endDate: endDate != null 
            ? DateFormat('yyyy-MM-dd').format(endDate) 
            : null,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponseInspection.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing authentication');
    } else {
      throw Exception('Failed to load inspections: ${response.statusCode}');
    }
  }

  Future<ApiResponseInspection> _getInspectionsFromCache({
    required int page,
    required int limit,
    required int offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await _dbHelper.getInspections(
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final totalCount = await _dbHelper.getInspectionsCount(
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final pagination = Pagination(
      currentPage: page,
      pageSize: limit,
      totalPages: (totalCount / limit).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseInspection(data: data, pagination: pagination);
  }

  // ============================================================================
  // BACKFLOW
  // ============================================================================

  Future<ApiResponseBackflow> getBackflow({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
    bool forceOffline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    if (forceOffline) {
      return await _getBackflowFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      );
    }

    return await _fetchWithFallback<ApiResponseBackflow>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchBackflowFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getBackflowFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      saveToCache: (data) => _dbHelper.saveBackflow(data.data),
    );
  }

  Future<ApiResponseBackflow> _fetchBackflowFromAPI({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.get(
      Uri.parse(
        AppConfig.getEndpointUrl(
          AppConfig.backflowEndpoint,
          queryParams: {'page': page},
          searchTerm: searchTerm,
          searchColumn: searchColumn,
          startDate: startDate != null 
            ? DateFormat('yyyy-MM-dd').format(startDate) 
            : null,
          endDate: endDate != null 
            ? DateFormat('yyyy-MM-dd').format(endDate) 
            : null,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponseBackflow.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing authentication');
    } else {
      throw Exception('Failed to load backflow: ${response.statusCode}');
    }
  }

  Future<ApiResponseBackflow> _getBackflowFromCache({
    required int page,
    required int limit,
    required int offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await _dbHelper.getBackflow(
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final totalCount = await _dbHelper.getBackflowCount(
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final pagination = Pagination(
      currentPage: page,
      pageSize: limit,
      totalPages: (totalCount / limit).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseBackflow(data: data, pagination: pagination);
  }

  // ============================================================================
  // PUMP SYSTEMS
  // ============================================================================

  Future<ApiResponsePumpSystem> getPumpSystems({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
    bool forceOffline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    if (forceOffline) {
      return await _getPumpSystemsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      );
    }

    return await _fetchWithFallback<ApiResponsePumpSystem>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchPumpSystemsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getPumpSystemsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      saveToCache: (data) => _dbHelper.savePumpSystems(data.data),
    );
  }

  Future<ApiResponsePumpSystem> _fetchPumpSystemsFromAPI({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.get(
      Uri.parse(
        AppConfig.getEndpointUrl(
          AppConfig.pumpSystemsEndpoint,
          queryParams: {'page': page},
          searchTerm: searchTerm,
          searchColumn: searchColumn,
          startDate: startDate != null 
            ? DateFormat('yyyy-MM-dd').format(startDate) 
            : null,
          endDate: endDate != null 
            ? DateFormat('yyyy-MM-dd').format(endDate) 
            : null,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponsePumpSystem.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing authentication');
    } else {
      throw Exception('Failed to load pump systems: ${response.statusCode}');
    }
  }

  Future<ApiResponsePumpSystem> _getPumpSystemsFromCache({
    required int page,
    required int limit,
    required int offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await _dbHelper.getPumpSystems(
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final totalCount = await _dbHelper.getPumpSystemsCount(
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final pagination = Pagination(
      currentPage: page,
      pageSize: limit,
      totalPages: (totalCount / limit).ceil(),
      totalItems: totalCount,
    );

    return ApiResponsePumpSystem(data: data, pagination: pagination);
  }

  // ============================================================================
  // DRY SYSTEMS
  // ============================================================================

  Future<ApiResponseDrySystem> getDrySystems({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
    bool forceOffline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    if (forceOffline) {
      return await _getDrySystemsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      );
    }

    return await _fetchWithFallback<ApiResponseDrySystem>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchDrySystemsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getDrySystemsFromCache(
        page: page,
        limit: itemsPerPage,
        offset: offset,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      saveToCache: (data) => _dbHelper.saveDrySystems(data.data),
    );
  }

  Future<ApiResponseDrySystem> _fetchDrySystemsFromAPI({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final response = await _apiClient.get(
      Uri.parse(
        AppConfig.getEndpointUrl(
          AppConfig.drySystemsEndpoint,
          queryParams: {'page': page},
          searchTerm: searchTerm,
          searchColumn: searchColumn,
          startDate: startDate != null 
            ? DateFormat('yyyy-MM-dd').format(startDate) 
            : null,
          endDate: endDate != null 
            ? DateFormat('yyyy-MM-dd').format(endDate) 
            : null,
        ),
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return ApiResponseDrySystem.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing authentication');
    } else {
      throw Exception('Failed to load dry systems: ${response.statusCode}');
    }
  }

  Future<ApiResponseDrySystem> _getDrySystemsFromCache({
    required int page,
    required int limit,
    required int offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final data = await _dbHelper.getDrySystems(
      limit: limit,
      offset: offset,
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final totalCount = await _dbHelper.getDrySystemsCount(
      searchTerm: searchTerm,
      searchColumn: searchColumn,
      startDate: startDate,
      endDate: endDate,
    );

    final pagination = Pagination(
      currentPage: page,
      pageSize: limit,
      totalPages: (totalCount / limit).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseDrySystem(data: data, pagination: pagination);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Generic fetch-with-fallback pattern
  /// Tries online first, falls back to cache if offline
  Future<T> _fetchWithFallback<T>({
    required Future<T> Function() onlineFetch,
    required Future<T> Function() offlineFetch,
    required Future<void> Function(T) saveToCache,
    bool forceOnline = false,
  }) async {
    bool online = forceOnline || await isOnline();

    if (online) {
      try {
        final data = await onlineFetch();
        await saveToCache(data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          print('Online fetch failed, falling back to cache: $e');
        }
        return await offlineFetch();
      }
    } else {
      return await offlineFetch();
    }
  }

  /// Sync all data from server to local cache
  /// Note: This still requires auth headers
  Future<void> syncAllData({Function(String, int, int)? onProgress}) async {
    if (!await _authService.hasUuid()) {
      throw Exception('Cannot sync: No authentication UUID');
    }

    if (await isOnline()) {
      try {
        await _syncAllInspections(onProgress: onProgress);
        await _syncAllBackflow(onProgress: onProgress);
        await _syncAllPumpSystems(onProgress: onProgress);
        await _syncAllDrySystems(onProgress: onProgress);
      } catch (e) {
        throw Exception('Failed to sync data: $e');
      }
    } else {
      throw Exception('No internet connection available for sync');
    }
  }

  Future<void> _syncAllInspections({Function(String, int, int)? onProgress}) async {
    final allInspections = <InspectionData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing inspections', currentPage, 0);
      
      final response = await _fetchInspectionsFromAPI(page: currentPage);
      allInspections.addAll(response.data);
      
      onProgress?.call('Syncing inspections', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    await _dbHelper.saveInspections(allInspections);
    onProgress?.call('Inspections synced', currentPage - 1, currentPage - 1);
  }

  Future<void> _syncAllBackflow({Function(String, int, int)? onProgress}) async {
    final allBackflow = <BackflowData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing backflow', currentPage, 0);
      
      final response = await _fetchBackflowFromAPI(page: currentPage);
      allBackflow.addAll(response.data);
      
      onProgress?.call('Syncing backflow', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    await _dbHelper.saveBackflow(allBackflow);
    onProgress?.call('Backflow synced', currentPage - 1, currentPage - 1);
  }

  Future<void> _syncAllPumpSystems({Function(String, int, int)? onProgress}) async {
    final allPumpSystems = <PumpSystemData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing pump systems', currentPage, 0);
      
      final response = await _fetchPumpSystemsFromAPI(page: currentPage);
      allPumpSystems.addAll(response.data);
      
      onProgress?.call('Syncing pump systems', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    await _dbHelper.savePumpSystems(allPumpSystems);
    onProgress?.call('Pump systems synced', currentPage - 1, currentPage - 1);
  }

  Future<void> _syncAllDrySystems({Function(String, int, int)? onProgress}) async {
    final allDrySystems = <DrySystemData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing dry systems', currentPage, 0);
      
      final response = await _fetchDrySystemsFromAPI(page: currentPage);
      allDrySystems.addAll(response.data);
      
      onProgress?.call('Syncing dry systems', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    await _dbHelper.saveDrySystems(allDrySystems);
    onProgress?.call('Dry systems synced', currentPage - 1, currentPage - 1);
  }

  /// Get server statistics
  Future<Map<String, int>?> getServerStatistics() async {
    if (!await _authService.hasUuid()) {
      return null;
    }

    try {
      final inspectionsResponse = await _fetchInspectionsFromAPI(page: 1);
      final backflowResponse = await _fetchBackflowFromAPI(page: 1);
      final pumpSystemsResponse = await _fetchPumpSystemsFromAPI(page: 1);
      final drySystemsResponse = await _fetchDrySystemsFromAPI(page: 1);

      return {
        'inspections': inspectionsResponse.pagination.totalItems,
        'backflow': backflowResponse.pagination.totalItems,
        'pump_systems': pumpSystemsResponse.pagination.totalItems,
        'dry_systems': drySystemsResponse.pagination.totalItems,
      };
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _dbHelper.clearAllData();
  }

  /// Check if any offline data exists
  Future<bool> hasOfflineData() async {
    final inspections = await _dbHelper.getInspectionsCount();
    final backflow = await _dbHelper.getBackflowCount();
    final pumpSystems = await _dbHelper.getPumpSystemsCount();
    final drySystems = await _dbHelper.getDrySystemsCount();
    
    return inspections > 0 || backflow > 0 || pumpSystems > 0 || drySystems > 0;
  }

  Future<int> getInspectionsCount() async {
    return await _dbHelper.getInspectionsCount();
  }

  Future<int> getBackflowCount() async {
    return await _dbHelper.getBackflowCount();
  }

  Future<int> getPumpSystemsCount() async {
    return await _dbHelper.getPumpSystemsCount();
  }

  Future<int> getDrySystemsCount() async {
    return await _dbHelper.getDrySystemsCount();
  }

  /// Get detailed connection status (includes no network vs server unreachable)
  Future<ConnectionStatus> getDetailedConnectionStatus() async {
    // First check basic connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      return ConnectionStatus.noNetwork;
    }
    
    // Device has network - check if API is reachable
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/health'),
      ).timeout(const Duration(seconds: 2));
      
      if (response.statusCode == 200) {
        return ConnectionStatus.connected;
      } else {
        return ConnectionStatus.serverUnreachable;
      }
    } catch (e) {
      return ConnectionStatus.serverUnreachable;
    }
  }

  /// Get last sync times for all data types
  Future<Map<String, DateTime?>> getLastSyncTimes() async {
    return await _dbHelper.getLastSyncTimes();
  }

  Future<bool> createInspection(InspectionData inspectionData) async {
    return await _creationService.createInspection(
      inspectionData,
      attemptSync: true,
      isOnlineCheck: isOnline,
    );
  }
}