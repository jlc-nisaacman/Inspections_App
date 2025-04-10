// lib/models/api_response_inspection.dart
import 'inspection_data.dart';
import 'pagination.dart';

class ApiResponseInspection {
  final List<InspectionData> data;
  final Pagination pagination;

  ApiResponseInspection({required this.data, required this.pagination});

  factory ApiResponseInspection.fromJson(Map<String, dynamic> json) {
    return ApiResponseInspection(
      // Use null-aware operators and provide default empty list
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) =>
                        InspectionData.fromJson(item as Map<String, dynamic>),
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
