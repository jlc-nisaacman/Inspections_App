// lib/models/api_response_dry_system.dart
import 'dry_system_data.dart';
import 'pagination.dart';

class ApiResponseDrySystem {
  final List<DrySystemData> data;
  final Pagination pagination;

  ApiResponseDrySystem({required this.data, required this.pagination});

  factory ApiResponseDrySystem.fromJson(Map<String, dynamic> json) {
    return ApiResponseDrySystem(
      // Use null-aware operators and provide default empty list
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) =>
                        DrySystemData.fromJson(item as Map<String, dynamic>),
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
