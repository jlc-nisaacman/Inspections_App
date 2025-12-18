// lib/services/data_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/inspection_data.dart';
import '../models/inspection_form.dart';
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
import '../services/sync_service.dart';

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
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/health'))
          .timeout(const Duration(seconds: 5));
      
      final isReachable = response.statusCode == 200;
      
      // Cache the result
      _cachedOnlineStatus = isReachable;
      _lastHealthCheck = DateTime.now();
      
      if (kDebugMode && !isReachable) {
        print('API health check returned ${response.statusCode}');
      }
      
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
  Future<ConnectionStatus> getDetailedConnectionStatus() async {
    // Fast check: does device have any network?
    final connectivityResult = await _connectivity.checkConnectivity();
    
    if (connectivityResult == ConnectivityResult.none) {
      return ConnectionStatus.noNetwork;
    }
    
    // Device has network - check if API is reachable
    // Use checkServerReachability() to bypass cache for manual checks
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/health'),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        return ConnectionStatus.connected;
      } else {
        return ConnectionStatus.serverUnreachable;
      }
    } catch (e) {
      return ConnectionStatus.serverUnreachable;
    }
  }

  // INSPECTIONS
  Future<ApiResponseInspection> getInspections({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    return await _fetchWithFallback<ApiResponseInspection>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchInspectionsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getInspectionsFromDB(
        limit: itemsPerPage,
        offset: offset,
        page: page,
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

  Future<ApiResponseInspection> _getInspectionsFromDB({
    int? limit,
    int? offset,
    int page = 1,
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
      pageSize: limit ?? 20,
      totalPages: (totalCount / (limit ?? 20)).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseInspection(data: data, pagination: pagination);
  }

  // BACKFLOW
  Future<ApiResponseBackflow> getBackflow({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    return await _fetchWithFallback<ApiResponseBackflow>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchBackflowFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getBackflowFromDB(
        limit: itemsPerPage,
        offset: offset,
        page: page,
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

  Future<ApiResponseBackflow> _getBackflowFromDB({
    int? limit,
    int? offset,
    int page = 1,
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
      pageSize: limit ?? 20,
      totalPages: (totalCount / (limit ?? 20)).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseBackflow(data: data, pagination: pagination);
  }

  // PUMP SYSTEMS
  Future<ApiResponsePumpSystem> getPumpSystems({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    return await _fetchWithFallback<ApiResponsePumpSystem>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchPumpSystemsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getPumpSystemsFromDB(
        limit: itemsPerPage,
        offset: offset,
        page: page,
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

  Future<ApiResponsePumpSystem> _getPumpSystemsFromDB({
    int? limit,
    int? offset,
    int page = 1,
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
      pageSize: limit ?? 20,
      totalPages: (totalCount / (limit ?? 20)).ceil(),
      totalItems: totalCount,
    );

    return ApiResponsePumpSystem(data: data, pagination: pagination);
  }

  // DRY SYSTEMS
  Future<ApiResponseDrySystem> getDrySystems({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
  }) async {
    const int itemsPerPage = 20;
    final offset = (page - 1) * itemsPerPage;

    return await _fetchWithFallback<ApiResponseDrySystem>(
      forceOnline: forceOnline,
      onlineFetch: () => _fetchDrySystemsFromAPI(
        page: page,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        startDate: startDate,
        endDate: endDate,
      ),
      offlineFetch: () => _getDrySystemsFromDB(
        limit: itemsPerPage,
        offset: offset,
        page: page,
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

  Future<ApiResponseDrySystem> _getDrySystemsFromDB({
    int? limit,
    int? offset,
    int page = 1,
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
      pageSize: limit ?? 20,
      totalPages: (totalCount / (limit ?? 20)).ceil(),
      totalItems: totalCount,
    );

    return ApiResponseDrySystem(data: data, pagination: pagination);
  }

  // SYNC METHODS WITH PROGRESS TRACKING
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

  // Get last sync times for UI display
  Future<Map<String, DateTime?>> getLastSyncTimes() async {
    return {
      'inspections': await _dbHelper.getLastSyncTime('inspections'),
      'backflow': await _dbHelper.getLastSyncTime('backflow'),
      'pump_systems': await _dbHelper.getLastSyncTime('pump_systems'),
      'dry_systems': await _dbHelper.getLastSyncTime('dry_systems'),
    };
  }

  // Get sync statistics
  Future<Map<String, dynamic>> getSyncStatistics() async {
    final syncTimes = await getLastSyncTimes();
    
    // Get record counts for each table
    final inspectionsCount = await _dbHelper.getInspectionsCount();
    final backflowCount = await _dbHelper.getBackflowCount();
    final pumpSystemsCount = await _dbHelper.getPumpSystemsCount();
    final drySystemsCount = await _dbHelper.getDrySystemsCount();
    
    // Calculate total records
    final totalRecords = inspectionsCount + backflowCount + pumpSystemsCount + drySystemsCount;
    
    return {
      'totalRecords': totalRecords,
      'recordCounts': {
        'inspections': inspectionsCount,
        'backflow': backflowCount,
        'pumpSystems': pumpSystemsCount,
        'drySystems': drySystemsCount,
      },
      'lastSyncTimes': syncTimes,
      'isOnline': await isOnline(),
      'hasOfflineData': await hasOfflineData(),
    };
  }

  // Get server statistics (total available records)
  Future<Map<String, int>?> getServerStatistics() async {
    if (!await isOnline()) return null;
    
    try {
      // Fetch first page of each type to get total counts
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

  // Clear all cached data
  Future<void> clearCache() async {
    await _dbHelper.clearAllData();
  }

  // Check if data exists in cache
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

Future<bool> createInspection(InspectionData inspectionData) async {
  try {
    // Generate a unique PDF path for the new inspection
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    
    // Generate a meaningful PDF path based on location and date
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final locationForPath = inspectionData.form.location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_')
        .toLowerCase();
    final pdfPath = 'local_inspections/${dateStr}_${locationForPath}_$timestamp.pdf';
    
    // Create a new inspection form with the generated PDF path
    final updatedForm = InspectionForm(
      pdfPath: pdfPath,
      billTo: inspectionData.form.billTo,
      location: inspectionData.form.location,
      billToLn2: inspectionData.form.billToLn2,
      locationLn2: inspectionData.form.locationLn2,
      attention: inspectionData.form.attention,
      billingStreet: inspectionData.form.billingStreet,
      billingStreetLn2: inspectionData.form.billingStreetLn2,
      locationStreet: inspectionData.form.locationStreet,
      locationStreetLn2: inspectionData.form.locationStreetLn2,
      billingCityState: inspectionData.form.billingCityState,
      billingCityStateLn2: inspectionData.form.billingCityStateLn2,
      locationCityState: inspectionData.form.locationCityState,
      locationCityStateLn2: inspectionData.form.locationCityStateLn2,
      contact: inspectionData.form.contact,
      date: inspectionData.form.date,
      phone: inspectionData.form.phone,
      inspector: inspectionData.form.inspector,
      email: inspectionData.form.email,
      inspectionFrequency: inspectionData.form.inspectionFrequency,
      inspectionNumber: inspectionData.form.inspectionNumber,
      isTheBuildingOccupied: inspectionData.form.isTheBuildingOccupied,
      areAllSystemsInService: inspectionData.form.areAllSystemsInService,
      areFpSystemsSameAsLastInspection: inspectionData.form.areFpSystemsSameAsLastInspection,
      hydraulicNameplateSecurelyAttachedAndLegible: inspectionData.form.hydraulicNameplateSecurelyAttachedAndLegible,
      wasAMainDrainWaterFlowTestConducted: inspectionData.form.wasAMainDrainWaterFlowTestConducted,
      areAllSprinklerSystemMainControlValvesOpen: inspectionData.form.areAllSprinklerSystemMainControlValvesOpen,
      areAllOtherValvesInProperPosition: inspectionData.form.areAllOtherValvesInProperPosition,
      areAllControlValvesSealedOrSupervised: inspectionData.form.areAllControlValvesSealedOrSupervised,
      areAllControlValvesInGoodConditionAndFreeOfLeaks: inspectionData.form.areAllControlValvesInGoodConditionAndFreeOfLeaks,
      areFireDepartmentConnectionsInSatisfactoryCondition: inspectionData.form.areFireDepartmentConnectionsInSatisfactoryCondition,
      areCapsInPlace: inspectionData.form.areCapsInPlace,
      isFireDepartmentConnectionEasilyAccessible: inspectionData.form.isFireDepartmentConnectionEasilyAccessible,
      automaticDrainValeInPlace: inspectionData.form.automaticDrainValeInPlace,
      isThePumpRoomHeated: inspectionData.form.isThePumpRoomHeated,
      isTheFirePumpInService: inspectionData.form.isTheFirePumpInService,
      wasFirePumpRunDuringThisInspection: inspectionData.form.wasFirePumpRunDuringThisInspection,
      wasThePumpStartedInTheAutomaticModeByAPressureDrop: inspectionData.form.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
      wereThePumpBearingsLubricated: inspectionData.form.wereThePumpBearingsLubricated,
      jockeyPumpStartPressurePSI: inspectionData.form.jockeyPumpStartPressurePSI,
      jockeyPumpStartPressure: inspectionData.form.jockeyPumpStartPressure,
      jockeyPumpStopPressurePSI: inspectionData.form.jockeyPumpStopPressurePSI,
      jockeyPumpStopPressure: inspectionData.form.jockeyPumpStopPressure,
      firePumpStartPressurePSI: inspectionData.form.firePumpStartPressurePSI,
      firePumpStartPressure: inspectionData.form.firePumpStartPressure,
      firePumpStopPressurePSI: inspectionData.form.firePumpStopPressurePSI,
      firePumpStopPressure: inspectionData.form.firePumpStopPressure,
      isTheFuelTankAtLeast2_3Full: inspectionData.form.isTheFuelTankAtLeast2_3Full,
      isEngineOilAtCorrectLevel: inspectionData.form.isEngineOilAtCorrectLevel,
      isEngineCoolantAtCorrectLevel: inspectionData.form.isEngineCoolantAtCorrectLevel,
      isTheEngineBlockHeaterWorking: inspectionData.form.isTheEngineBlockHeaterWorking,
      isPumpRoomVentilationOperatingProperly: inspectionData.form.isPumpRoomVentilationOperatingProperly,
      wasWaterDischargeObservedFromHeatExchangerReturnLine: inspectionData.form.wasWaterDischargeObservedFromHeatExchangerReturnLine,
      wasCoolingLineStrainerCleanedAfterTest: inspectionData.form.wasCoolingLineStrainerCleanedAfterTest,
      wasPumpRunForAtLeast30Minutes: inspectionData.form.wasPumpRunForAtLeast30Minutes,
      doesTheSwitchInAutoAlarmWork: inspectionData.form.doesTheSwitchInAutoAlarmWork,
      doesThePumpRunningAlarmWork: inspectionData.form.doesThePumpRunningAlarmWork,
      doesTheCommonAlarmWork: inspectionData.form.doesTheCommonAlarmWork,
      wasCasingReliefValveOperatingProperly: inspectionData.form.wasCasingReliefValveOperatingProperly,
      wasPumpRunForAtLeast10Minutes: inspectionData.form.wasPumpRunForAtLeast10Minutes,
      doesTheLossOfPowerAlarmWork: inspectionData.form.doesTheLossOfPowerAlarmWork,
      doesTheElectricPumpRunningAlarmWork: inspectionData.form.doesTheElectricPumpRunningAlarmWork,
      powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad: inspectionData.form.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
      trasferOfPowerToAlternativePowerSourceVerified: inspectionData.form.trasferOfPowerToAlternativePowerSourceVerified,
      powerFaulureConditionRemoved: inspectionData.form.powerFaulureConditionRemoved,
      pumpReconnectedToNormalPowerSourceAfterATimeDelay: inspectionData.form.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
      haveAntiFreezeSystemsBeenTested: inspectionData.form.haveAntiFreezeSystemsBeenTested,
      freezeProtectionInDegreesF: inspectionData.form.freezeProtectionInDegreesF,
      areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition: inspectionData.form.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
      waterFlowAlarmTestConductedWithInspectorsTest: inspectionData.form.waterFlowAlarmTestConductedWithInspectorsTest,
      waterFlowAlarmTestConductedWithBypassConnection: inspectionData.form.waterFlowAlarmTestConductedWithBypassConnection,
      isDryValveInServiceAndInGoodCondition: inspectionData.form.isDryValveInServiceAndInGoodCondition,
      isDryValveItermediateChamberNotLeaking: inspectionData.form.isDryValveItermediateChamberNotLeaking,
      hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears: inspectionData.form.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
      areQuickOpeningDeviceControlValvesOpen: inspectionData.form.areQuickOpeningDeviceControlValvesOpen,
      isThereAListOfKnownLowPointDrainsAtTheRiser: inspectionData.form.isThereAListOfKnownLowPointDrainsAtTheRiser,
      haveKnownLowPointsBeenDrained: inspectionData.form.haveKnownLowPointsBeenDrained,
      isOilLevelFullOnAirCompressor: inspectionData.form.isOilLevelFullOnAirCompressor,
      doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder: inspectionData.form.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
      whatPressureDoesAirCompressorStartPSI: inspectionData.form.whatPressureDoesAirCompressorStartPSI,
      whatPressureDoesAirCompressorStart: inspectionData.form.whatPressureDoesAirCompressorStart,
      whatPressureDoesAirCompressorStopPSI: inspectionData.form.whatPressureDoesAirCompressorStopPSI,
      whatPressureDoesAirCompressorStop: inspectionData.form.whatPressureDoesAirCompressorStop,
      didLowAirAlarmOperatePSI: inspectionData.form.didLowAirAlarmOperatePSI,
      didLowAirAlarmOperate: inspectionData.form.didLowAirAlarmOperate,
      dateOfLastFullTripTest: inspectionData.form.dateOfLastFullTripTest,
      dateOfLastInternalInspection: inspectionData.form.dateOfLastInternalInspection,
      areValvesInServiceAndInGoodCondition: inspectionData.form.areValvesInServiceAndInGoodCondition,
      wereValvesTripped: inspectionData.form.wereValvesTripped,
      whatPressureDidPneumaticActuatorTripPSI: inspectionData.form.whatPressureDidPneumaticActuatorTripPSI,
      whatPressureDidPneumaticActuatorTrip: inspectionData.form.whatPressureDidPneumaticActuatorTrip,
      wasPrimingLineLeftOnAfterTest: inspectionData.form.wasPrimingLineLeftOnAfterTest,
      whatPressureDoesPreactionAirCompressorStartPSI: inspectionData.form.whatPressureDoesPreactionAirCompressorStartPSI,
      whatPressureDoesPreactionAirCompressorStart: inspectionData.form.whatPressureDoesPreactionAirCompressorStart,
      whatPressureDoesPreactionAirCompressorStopPSI: inspectionData.form.whatPressureDoesPreactionAirCompressorStopPSI,
      whatPressureDoesPreactionAirCompressorStop: inspectionData.form.whatPressureDoesPreactionAirCompressorStop,
      didPreactionLowAirAlarmOperatePSI: inspectionData.form.didPreactionLowAirAlarmOperatePSI,
      didPreactionLowAirAlarmOperate: inspectionData.form.didPreactionLowAirAlarmOperate,
      doesWaterMotorGongWork: inspectionData.form.doesWaterMotorGongWork,
      doesElectricBellWork: inspectionData.form.doesElectricBellWork,
      areWaterFlowAlarmsOperational: inspectionData.form.areWaterFlowAlarmsOperational,
      areAllTamperSwitchesOperational: inspectionData.form.areAllTamperSwitchesOperational,
      didAlarmPanelClearAfterTest: inspectionData.form.didAlarmPanelClearAfterTest,
      areAMinimumOf6SpareSprinklersReadilyAvaiable: inspectionData.form.areAMinimumOf6SpareSprinklersReadilyAvaiable,
      isConditionOfPipingAndOtherSystemComponentsSatisfactory: inspectionData.form.isConditionOfPipingAndOtherSystemComponentsSatisfactory,
      areKnownDryTypeHeadsLessThan10YearsOld: inspectionData.form.areKnownDryTypeHeadsLessThan10YearsOld,
      areKnownDryTypeHeadsLessThan10YearsOldYear: inspectionData.form.areKnownDryTypeHeadsLessThan10YearsOldYear,
      areKnownQuickResponseHeadsLessThan20YearsOld: inspectionData.form.areKnownQuickResponseHeadsLessThan20YearsOld,
      areKnownQuickResponseHeadsLessThan20YearsOldYear: inspectionData.form.areKnownQuickResponseHeadsLessThan20YearsOldYear,
      areKnownStandardResponseHeadsLessThan50YearsOld: inspectionData.form.areKnownStandardResponseHeadsLessThan50YearsOld,
      areKnownStandardResponseHeadsLessThan50YearsOldYear: inspectionData.form.areKnownStandardResponseHeadsLessThan50YearsOldYear,
      haveAllGaugesBeenTestedOrReplacedInTheLast5Years: inspectionData.form.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
      haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: inspectionData.form.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
      system1Name: inspectionData.form.system1Name,
      system1DrainSize: inspectionData.form.system1DrainSize,
      system1StaticPSI: inspectionData.form.system1StaticPSI,
      system1ResidualPSI: inspectionData.form.system1ResidualPSI,
      system2Name: inspectionData.form.system2Name,
      system2DrainSize: inspectionData.form.system2DrainSize,
      system2StaticPSI: inspectionData.form.system2StaticPSI,
      system2ResidualPSI: inspectionData.form.system2ResidualPSI,
      system3Name: inspectionData.form.system3Name,
      system3DrainSize: inspectionData.form.system3DrainSize,
      system3StaticPSI: inspectionData.form.system3StaticPSI,
      system3ResidualPSI: inspectionData.form.system3ResidualPSI,
      system4Name: inspectionData.form.system4Name,
      system4DrainSize: inspectionData.form.system4DrainSize,
      system4StaticPSI: inspectionData.form.system4StaticPSI,
      system4ResidualPSI: inspectionData.form.system4ResidualPSI,
      system5Name: inspectionData.form.system5Name,
      system5DrainSize: inspectionData.form.system5DrainSize,
      system5StaticPSI: inspectionData.form.system5StaticPSI,
      system5ResidualPSI: inspectionData.form.system5ResidualPSI,
      system6Name: inspectionData.form.system6Name,
      system6DrainSize: inspectionData.form.system6DrainSize,
      system6StaticPSI: inspectionData.form.system6StaticPSI,
      system6ResidualPSI: inspectionData.form.system6ResidualPSI,
      drainTestNotes: inspectionData.form.drainTestNotes,
      device1Name: inspectionData.form.device1Name,
      device1Address: inspectionData.form.device1Address,
      device1DescriptionLocation: inspectionData.form.device1DescriptionLocation,
      device1Operated: inspectionData.form.device1Operated,
      device1DelaySec: inspectionData.form.device1DelaySec,
      device2Name: inspectionData.form.device2Name,
      device2Address: inspectionData.form.device2Address,
      device2DescriptionLocation: inspectionData.form.device2DescriptionLocation,
      device2Operated: inspectionData.form.device2Operated,
      device2DelaySec: inspectionData.form.device2DelaySec,
      device3Name: inspectionData.form.device3Name,
      device3Address: inspectionData.form.device3Address,
      device3DescriptionLocation: inspectionData.form.device3DescriptionLocation,
      device3Operated: inspectionData.form.device3Operated,
      device3DelaySec: inspectionData.form.device3DelaySec,
      device4Name: inspectionData.form.device4Name,
      device4Address: inspectionData.form.device4Address,
      device4DescriptionLocation: inspectionData.form.device4DescriptionLocation,
      device4Operated: inspectionData.form.device4Operated,
      device4DelaySec: inspectionData.form.device4DelaySec,
      device5Name: inspectionData.form.device5Name,
      device5Address: inspectionData.form.device5Address,
      device5DescriptionLocation: inspectionData.form.device5DescriptionLocation,
      device5Operated: inspectionData.form.device5Operated,
      device5DelaySec: inspectionData.form.device5DelaySec,
      device6Name: inspectionData.form.device6Name,
      device6Address: inspectionData.form.device6Address,
      device6DescriptionLocation: inspectionData.form.device6DescriptionLocation,
      device6Operated: inspectionData.form.device6Operated,
      device6DelaySec: inspectionData.form.device6DelaySec,
      device7Name: inspectionData.form.device7Name,
      device7Address: inspectionData.form.device7Address,
      device7DescriptionLocation: inspectionData.form.device7DescriptionLocation,
      device7Operated: inspectionData.form.device7Operated,
      device7DelaySec: inspectionData.form.device7DelaySec,
      device8Name: inspectionData.form.device8Name,
      device8Address: inspectionData.form.device8Address,
      device8DescriptionLocation: inspectionData.form.device8DescriptionLocation,
      device8Operated: inspectionData.form.device8Operated,
      device8DelaySec: inspectionData.form.device8DelaySec,
      device9Name: inspectionData.form.device9Name,
      device9Address: inspectionData.form.device9Address,
      device9DescriptionLocation: inspectionData.form.device9DescriptionLocation,
      device9Operated: inspectionData.form.device9Operated,
      device9DelaySec: inspectionData.form.device9DelaySec,
      device10Name: inspectionData.form.device10Name,
      device10Address: inspectionData.form.device10Address,
      device10DescriptionLocation: inspectionData.form.device10DescriptionLocation,
      device10Operated: inspectionData.form.device10Operated,
      device10DelaySec: inspectionData.form.device10DelaySec,
      device11Name: inspectionData.form.device11Name,
      device11Address: inspectionData.form.device11Address,
      device11DescriptionLocation: inspectionData.form.device11DescriptionLocation,
      device11Operated: inspectionData.form.device11Operated,
      device11DelaySec: inspectionData.form.device11DelaySec,
      device12Name: inspectionData.form.device12Name,
      device12Address: inspectionData.form.device12Address,
      device12DescriptionLocation: inspectionData.form.device12DescriptionLocation,
      device12Operated: inspectionData.form.device12Operated,
      device12DelaySec: inspectionData.form.device12DelaySec,
      device13Name: inspectionData.form.device13Name,
      device13Address: inspectionData.form.device13Address,
      device13DescriptionLocation: inspectionData.form.device13DescriptionLocation,
      device13Operated: inspectionData.form.device13Operated,
      device13DelaySec: inspectionData.form.device13DelaySec,
      device14Name: inspectionData.form.device14Name,
      device14Address: inspectionData.form.device14Address,
      device14DescriptionLocation: inspectionData.form.device14DescriptionLocation,
      device14Operated: inspectionData.form.device14Operated,
      device14DelaySec: inspectionData.form.device14DelaySec,
      adjustmentsOrCorrectionsMake: inspectionData.form.adjustmentsOrCorrectionsMake,
      explanationOfAnyNoAnswers: inspectionData.form.explanationOfAnyNoAnswers,
      explanationOfAnyNoAnswersContinued: inspectionData.form.explanationOfAnyNoAnswersContinued,
      notes: inspectionData.form.notes,
    );
      
      // Create the updated inspection data
      final newInspectionData = InspectionData(updatedForm);
      
      // First save using the existing method
      await _dbHelper.saveInspections([newInspectionData]);
      
      // Then update the record to add local creation flags
      await _addLocalCreationFlags(pdfPath);
      
      // Optionally try to sync immediately if online
      if (await isOnline()) {
        try {
          final syncService = SyncService();
          await syncService.syncLocalRecords();
        } catch (e) {
          // Sync failed, but local save was successful
          if (kDebugMode) {
            print('Local save successful but sync failed: $e');
          }
        }
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating inspection: $e');
      }
      return false;
    }
  }

  /// Helper method to add local creation flags to a saved inspection
  Future<void> _addLocalCreationFlags(String pdfPath) async {
    final db = await _dbHelper.database;
    
    // Get the current form data
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      final formDataStr = result.first['form_data'] as String;
      final formData = jsonDecode(formDataStr) as Map<String, dynamic>;
      
      // Add local creation flags
      formData['created_locally'] = true;
      formData['synced_to_server'] = false;
      formData['created_at'] = DateTime.now().toIso8601String();
      
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
}