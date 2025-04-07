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
  final String dryPipeValveYear;
  final String dryPipeValveControlsSprinklersIn;
  final String quickOpeningDeviceMake;
  final String quickOpeningDeviceModel;
  final String quickOpeningDeviceControlValveOpen;
  final String quickOpeningDeviceYear;
  final String tripTestAirPressureBeforeTest;
  final String tripTestAirSystemTrippedAt;
  final String tripTestWaterPressureBeforeTest;
  final String tripTestTime;
  final String tripTestAirQuickOpeningDeviceOperatedAt;
  final String tripTestTimeQuickOpeningDeviceOperatedAt;
  final String tripTestTimeWaterAtInspectorsTest;
  final String tripTestStaticWaterPressure;
  final String tripTestResidualWaterPressure;
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
      dryPipeValveYear: json['dry_pipe_valve_year']?.toString() ?? '',
      dryPipeValveControlsSprinklersIn:
          json['dry_pipe_valve_controls_sprinklers_in']?.toString() ?? '',

      quickOpeningDeviceMake:
          json['quick_opening_device_make']?.toString() ?? '',
      quickOpeningDeviceModel:
          json['quick_opening_device_model']?.toString() ?? '',
      quickOpeningDeviceControlValveOpen:
          json['quick_opening_device_control_valve_open']?.toString() ?? '',
      quickOpeningDeviceYear:
          json['quick_opening_device_year']?.toString() ?? '',

      tripTestAirPressureBeforeTest:
          json['trip_test_air_pressure_before_test']?.toString() ?? '',
      tripTestAirSystemTrippedAt:
          json['trip_test_air_system_tripped_at']?.toString() ?? '',
      tripTestWaterPressureBeforeTest:
          json['trip_test_water_pressure_before_test']?.toString() ?? '',
      tripTestTime: json['trip_test_time']?.toString() ?? '',

      tripTestAirQuickOpeningDeviceOperatedAt:
          json['trip_test_air_quick_opening_device_operated_at']?.toString() ??
          '',
      tripTestTimeQuickOpeningDeviceOperatedAt:
          json['trip_test_time_quick_opening_device_operated_at']?.toString() ??
          '',
      tripTestTimeWaterAtInspectorsTest:
          json['trip_test_time_water_at_inspectors_test']?.toString() ?? '',

      tripTestStaticWaterPressure:
          json['trip_test_static_water_pressure']?.toString() ?? '',
      tripTestResidualWaterPressure:
          json['trip_test_residual_water_pressure']?.toString() ?? '',

      remarksOnTest: json['remarks_on_test']?.toString() ?? '',
    );
  }
}
