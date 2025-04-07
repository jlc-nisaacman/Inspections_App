// lib/models/api_response_pump_system.dart
import 'pump_system_data.dart';
import 'pagination.dart';

class ApiResponsePumpSystem {
  final List<PumpSystemData> data;
  final Pagination pagination;

  ApiResponsePumpSystem({required this.data, required this.pagination});

  factory ApiResponsePumpSystem.fromJson(Map<String, dynamic> json) {
    return ApiResponsePumpSystem(
      data: (json['data'] as List)
          .map((item) => PumpSystemData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}