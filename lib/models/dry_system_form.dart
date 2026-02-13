// lib/models/dry_system_form.dart

class DrySystemForm {
  final String pdfPath;
  final String reportTo;
  final String building;
  final String reportTo2;
  final String building2;
  final String attention;
  final String street;
  final String inspector;
  final String cityState;
  final String date;
  final String dryPipeValveMake;
  final String dryPipeValveModel;
  final String dryPipeValveSize;
  final int? dryPipeValveYear; // Changed from String to int?
  final String dryPipeValveControlsSprinklersIn;
  final String quickOpeningDeviceMake;
  final String quickOpeningDeviceModel;
  final bool? quickOpeningDeviceControlValveOpen; // Changed from String to bool?
  final int? quickOpeningDeviceYear; // Changed from String to int?
  final double? tripTestAirPressureBeforeTest; // Changed from String to double?
  final double? tripTestAirSystemTrippedAt; // Changed from String to double?
  final double? tripTestWaterPressureBeforeTest; // Changed from String to double?
  final String tripTestTime;
  final double? tripTestAirQuickOpeningDeviceOperatedAt; // Changed from String to double?
  final String tripTestTimeQuickOpeningDeviceOperatedAt;
  final String tripTestTimeWaterAtInspectorsTest;
  final double? tripTestStaticWaterPressure; // Changed from String to double?
  final double? tripTestResidualWaterPressure; // Changed from String to double?
  final String remarksOnTest;

  DrySystemForm({
    required this.pdfPath,
    required this.reportTo,
    required this.building,
    required this.reportTo2,
    required this.building2,
    required this.attention,
    required this.street,
    required this.inspector,
    required this.cityState,
    required this.date,
    required this.dryPipeValveMake,
    required this.dryPipeValveModel,
    required this.dryPipeValveSize,
    required this.dryPipeValveYear,
    required this.dryPipeValveControlsSprinklersIn,
    required this.quickOpeningDeviceMake,
    required this.quickOpeningDeviceModel,
    required this.quickOpeningDeviceControlValveOpen,
    required this.quickOpeningDeviceYear,
    required this.tripTestAirPressureBeforeTest,
    required this.tripTestAirSystemTrippedAt,
    required this.tripTestWaterPressureBeforeTest,
    required this.tripTestTime,
    required this.tripTestAirQuickOpeningDeviceOperatedAt,
    required this.tripTestTimeQuickOpeningDeviceOperatedAt,
    required this.tripTestTimeWaterAtInspectorsTest,
    required this.tripTestStaticWaterPressure,
    required this.tripTestResidualWaterPressure,
    required this.remarksOnTest,
  });

  // Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.isEmpty) return null;
    return double.tryParse(value.toString());
  }

  // Helper method to safely parse int values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String && value.isEmpty) return null;
    return int.tryParse(value.toString());
  }

  // Helper method to safely parse bool values
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return null;
  }

  factory DrySystemForm.fromJson(Map<String, dynamic> json) {
    return DrySystemForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      reportTo: json['report_to']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      reportTo2: json['report_to_2']?.toString() ?? '',
      building2: json['building_2']?.toString() ?? '',
      attention: json['attention']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      cityState: json['city_state']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      dryPipeValveMake: json['dry_pipe_valve_make']?.toString() ?? '',
      dryPipeValveModel: json['dry_pipe_valve_model']?.toString() ?? '',
      dryPipeValveSize: json['dry_pipe_valve_size']?.toString() ?? '',
      dryPipeValveYear: _parseInt(json['dry_pipe_valve_year']),
      dryPipeValveControlsSprinklersIn:
          json['dry_pipe_valve_controls_sprinklers_in']?.toString() ?? '',
      quickOpeningDeviceMake:
          json['quick_opening_device_make']?.toString() ?? '',
      quickOpeningDeviceModel:
          json['quick_opening_device_model']?.toString() ?? '',
      quickOpeningDeviceControlValveOpen:
          _parseBool(json['quick_opening_device_control_valve_open']),
      quickOpeningDeviceYear:
          _parseInt(json['quick_opening_device_year']),
      tripTestAirPressureBeforeTest:
          _parseDouble(json['trip_test_air_pressure_before_test']),
      tripTestAirSystemTrippedAt:
          _parseDouble(json['trip_test_air_system_tripped_at']),
      tripTestWaterPressureBeforeTest:
          _parseDouble(json['trip_test_water_pressure_before_test']),
      tripTestTime: json['trip_test_time']?.toString() ?? '',
      tripTestAirQuickOpeningDeviceOperatedAt:
          _parseDouble(json['trip_test_air_quick_opening_device_operated_at']),
      tripTestTimeQuickOpeningDeviceOperatedAt:
          json['trip_test_time_quick_opening_device_operated_at']?.toString() ??
          '',
      tripTestTimeWaterAtInspectorsTest:
          json['trip_test_time_water_at_inspectors_test']?.toString() ?? '',
      tripTestStaticWaterPressure:
          _parseDouble(json['trip_test_static_water_pressure']),
      tripTestResidualWaterPressure:
          _parseDouble(json['trip_test_residual_water_pressure']),
      remarksOnTest: json['remarks_on_test']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_path': pdfPath,
      'report_to': reportTo,
      'building': building,
      'report_to_2': reportTo2,
      'building_2': building2,
      'attention': attention,
      'street': street,
      'inspector': inspector,
      'city_state': cityState,
      'date': date,
      'dry_pipe_valve_make': dryPipeValveMake,
      'dry_pipe_valve_model': dryPipeValveModel,
      'dry_pipe_valve_size': dryPipeValveSize,
      'dry_pipe_valve_year': dryPipeValveYear,
      'dry_pipe_valve_controls_sprinklers_in': dryPipeValveControlsSprinklersIn,
      'quick_opening_device_make': quickOpeningDeviceMake,
      'quick_opening_device_model': quickOpeningDeviceModel,
      'quick_opening_device_control_valve_open': quickOpeningDeviceControlValveOpen,
      'quick_opening_device_year': quickOpeningDeviceYear,
      'trip_test_air_pressure_before_test': tripTestAirPressureBeforeTest,
      'trip_test_air_system_tripped_at': tripTestAirSystemTrippedAt,
      'trip_test_water_pressure_before_test': tripTestWaterPressureBeforeTest,
      'trip_test_time': tripTestTime,
      'trip_test_air_quick_opening_device_operated_at': tripTestAirQuickOpeningDeviceOperatedAt,
      'trip_test_time_quick_opening_device_operated_at': tripTestTimeQuickOpeningDeviceOperatedAt,
      'trip_test_time_water_at_inspectors_test': tripTestTimeWaterAtInspectorsTest,
      'trip_test_static_water_pressure': tripTestStaticWaterPressure,
      'trip_test_residual_water_pressure': tripTestResidualWaterPressure,
      'remarks_on_test': remarksOnTest,
    };
  }
}
