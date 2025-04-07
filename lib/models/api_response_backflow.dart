// lib/models/api_response_backflow.dart
import 'backflow_data.dart';
import 'pagination.dart';

class ApiResponseBackflow {
  final List<BackflowData> data;
  final Pagination pagination;

  ApiResponseBackflow({required this.data, required this.pagination});

  factory ApiResponseBackflow.fromJson(Map<String, dynamic> json) {
    return ApiResponseBackflow(
      data: (json['data'] as List)
          .map((item) => BackflowData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}