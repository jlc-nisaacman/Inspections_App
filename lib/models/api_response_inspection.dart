import 'inspection_data.dart';
import 'pagination.dart';

class ApiResponseInspection {
  final List<InspectionData> data;
  final Pagination pagination;

  ApiResponseInspection({required this.data, required this.pagination});

  factory ApiResponseInspection.fromJson(Map<String, dynamic> json) {
    return ApiResponseInspection(
      data: (json['data'] as List)
          .map((item) => InspectionData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}