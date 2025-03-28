import 'inspection_data.dart';
import 'pagination.dart';

class ApiResponse {
  final List<InspectionData> data;
  final Pagination pagination;

  ApiResponse({required this.data, required this.pagination});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: (json['data'] as List)
          .map((item) => InspectionData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}