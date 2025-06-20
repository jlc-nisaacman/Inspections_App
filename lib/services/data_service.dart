// lib/services/data_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'database_helper.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Connectivity _connectivity = Connectivity();

  // Check if device is online
  Future<bool> isOnline() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
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

  // INSPECTIONS
  Future<ApiResponseInspection> getInspections({
    int page = 1,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
    bool forceOnline = false,
  }) async {
    const int itemsPerPage = 20; // Adjust based on your API
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
}