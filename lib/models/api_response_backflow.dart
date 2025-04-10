// lib/models/api_response_backflow.dart
import 'backflow_data.dart';
import 'pagination.dart';

class ApiResponseBackflow {
  final List<BackflowData> data;
  final Pagination pagination;

  ApiResponseBackflow({required this.data, required this.pagination});

  factory ApiResponseBackflow.fromJson(Map<String, dynamic> json) {
    return ApiResponseBackflow(
      // Use null-aware operators and provide default empty list
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) =>
                        BackflowData.fromJson(item as Map<String, dynamic>),
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
