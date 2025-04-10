// lib/models/api_response_pump_system.dart
import 'pump_system_data.dart';
import 'pagination.dart';

class ApiResponsePumpSystem {
  final List<PumpSystemData> data;
  final Pagination pagination;

  ApiResponsePumpSystem({required this.data, required this.pagination});

  factory ApiResponsePumpSystem.fromJson(Map<String, dynamic> json) {
    return ApiResponsePumpSystem(
      // Use null-aware operators and provide default empty list
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) =>
                        PumpSystemData.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : [],
      // Provide a default pagination if null
      pagination:
          json['pagination'] != null
              ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
              : Pagination(
                currentPage: 1,
                pageSize: 10,
                totalItems: 0,
                totalPages: 1,
              ),
    );
  }
}
