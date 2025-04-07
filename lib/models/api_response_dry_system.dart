import 'dry_system_data.dart';
import 'pagination.dart';

class ApiResponseDrySystem {
  final List<DrySystemData> data;
  final Pagination pagination;

  ApiResponseDrySystem({required this.data, required this.pagination});

  factory ApiResponseDrySystem.fromJson(Map<String, dynamic> json) {
    return ApiResponseDrySystem(
      data: (json['data'] as List)
          .map((item) => DrySystemData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}