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
    // OPTIMIZED: Reduced from 5 seconds to 2 seconds
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
      // Server is unreachable - could be down, wrong network, timeout, etc.
      if (kDebugMode) {
        print('API health check failed: $e');
      }
      
      _cachedOnlineStatus = false;
      _lastHealthCheck = DateTime.now();
      
      return false;
    }
  }
  
  /// Force a fresh health check (ignores cache)
  /// Use this when you need to verify connectivity immediately,
  /// like after the user manually taps a "retry" button
  Future<bool> checkServerReachability() async {
    _cachedOnlineStatus = null;
    _lastHealthCheck = null;
    return await isOnline();
  }
  
  /// Clear the health check cache
  /// Useful when you know connectivity status has changed
  void clearHealthCheckCache() {
    _cachedOnlineStatus = null;
    _lastHealthCheck = null;
  }

  // Generic method to fetch data with offline fallback
  Future<T> _fetchWithFallback<T>({
    required Future<T> Function() onlineFetch,
    required Future<T> Function() offlineFetch,
    required Future<void> Function(T data) saveToCache,
    bool forceOnline = false,
  }) async {
    if (!forceOnline) {
      // Try offline first for better performance
      try {
        final offlineData = await offlineFetch();
        return offlineData;
      } catch (e) {
        // If offline fails, continue to online fetch
      }
    }

    // Check if online
    final online = await isOnline();
    if (online) {
      try {
        final onlineData = await onlineFetch();
        // Cache the data for offline use
        await saveToCache(onlineData);
        return onlineData;
      } catch (e) {
        // If online fetch fails, fallback to offline
        return await offlineFetch();
      }
    } else {
      // No internet, use offline data
      return await offlineFetch();
    }
  }

  /// Get detailed connection status - distinguishes between no network and server unreachable
  /// OPTIMIZED: Reduced timeout from 5 seconds to 2 seconds
  Future<ConnectionStatus> getDetailedConnectionStatus() async {
    // Fast check: does device have any network?
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      return ConnectionStatus.noNetwork;
    }
    
    // Device has network - check if API is reachable
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/health'),
      ).timeout(const Duration(seconds: 2)); // OPTIMIZED: Changed from 5 to 2
      
      if (response.statusCode == 200) {
        return ConnectionStatus.connected;
      } else {
        return ConnectionStatus.serverUnreachable;
      }
    } catch (e) {
      return ConnectionStatus.serverUnreachable;
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
    bool forceOffline = false, // NEW: Skip network entirely
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    // NEW: If forceOffline, go straight to cache
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
    final response = await http.get(
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
    } else {
      throw Exception('Failed to load inspections: ${response.statusCode}');
    }
  }

  // NEW: Helper method to get inspections from cache
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
    bool forceOffline = false, // NEW: Skip network entirely
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    // NEW: If forceOffline, go straight to cache
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
    final response = await http.get(
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
    } else {
      throw Exception('Failed to load backflow data: ${response.statusCode}');
    }
  }

  // NEW: Helper method to get backflow from cache
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
    bool forceOffline = false, // NEW: Skip network entirely
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    // NEW: If forceOffline, go straight to cache
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
    final response = await http.get(
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
    } else {
      throw Exception('Failed to load pump systems: ${response.statusCode}');
    }
  }

  // NEW: Helper method to get pump systems from cache
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
    bool forceOffline = false, // NEW: Skip network entirely
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    // NEW: If forceOffline, go straight to cache
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
    final response = await http.get(
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
    } else {
      throw Exception('Failed to load dry systems: ${response.statusCode}');
    }
  }

  // NEW: Helper method to get dry systems from cache
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
  // SYNC METHODS WITH PROGRESS TRACKING
  // ============================================================================

  Future<void> syncAllData({Function(String, int, int)? onProgress}) async {
    if (await isOnline()) {
      try {
        // Sync all data types by fetching all pages
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

  // Sync all inspections (fetch all pages)
  Future<void> _syncAllInspections({Function(String, int, int)? onProgress}) async {
    final allInspections = <InspectionData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing inspections', currentPage, 0); // totalPages unknown initially
      
      final response = await _fetchInspectionsFromAPI(page: currentPage);
      allInspections.addAll(response.data);
      
      // Update progress with known total pages
      onProgress?.call('Syncing inspections', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    // Save all inspections to cache
    await _dbHelper.saveInspections(allInspections);
    onProgress?.call('Inspections synced', currentPage - 1, currentPage - 1);
  }

  // Sync all backflow data (fetch all pages)
  Future<void> _syncAllBackflow({Function(String, int, int)? onProgress}) async {
    final allBackflow = <BackflowData>[];
    int currentPage = 1;
    bool hasMorePages = true;

    while (hasMorePages) {
      onProgress?.call('Syncing backflow tests', currentPage, 0);
      
      final response = await _fetchBackflowFromAPI(page: currentPage);
      allBackflow.addAll(response.data);
      
      onProgress?.call('Syncing backflow tests', currentPage, response.pagination.totalPages);
      
      hasMorePages = currentPage < response.pagination.totalPages;
      currentPage++;
    }

    // Save all backflow data to cache
    await _dbHelper.saveBackflow(allBackflow);
    onProgress?.call('Backflow tests synced', currentPage - 1, currentPage - 1);
  }

  // Sync all pump systems (fetch all pages)
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

    // Save all pump systems to cache
    await _dbHelper.savePumpSystems(allPumpSystems);
    onProgress?.call('Pump systems synced', currentPage - 1, currentPage - 1);
  }

  // Sync all dry systems (fetch all pages)
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

    // Save all dry systems to cache
    await _dbHelper.saveDrySystems(allDrySystems);
    onProgress?.call('Dry systems synced', currentPage - 1, currentPage - 1);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get last sync times for all data types
  Future<Map<String, DateTime?>> getLastSyncTimes() async {
    return await _dbHelper.getLastSyncTimes();
  }

  /// Get server statistics (record counts from API)
  Future<Map<String, int>?> getServerStatistics() async {
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

  /// Get count of inspections in local database
  Future<int> getInspectionsCount() async {
    return await _dbHelper.getInspectionsCount();
  }

  /// Get count of backflow tests in local database
  Future<int> getBackflowCount() async {
    return await _dbHelper.getBackflowCount();
  }

  /// Get count of pump systems in local database
  Future<int> getPumpSystemsCount() async {
    return await _dbHelper.getPumpSystemsCount();
  }

  /// Get count of dry systems in local database
  Future<int> getDrySystemsCount() async {
    return await _dbHelper.getDrySystemsCount();
  }

  /// Create a new inspection - delegates to InspectionCreationService
  Future<bool> createInspection(InspectionData inspectionData) async {
    return await _creationService.createInspection(
      inspectionData,
      attemptSync: true,
      isOnlineCheck: isOnline,
    );
  }
}