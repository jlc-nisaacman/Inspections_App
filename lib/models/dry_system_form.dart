// lib/models/dry_system_form.dart

class DrySystemForm {
  final String pdfPath;
  final String date;
  final String location;
  final String locationCityState;
  final String inspector;

  // Dry Systems Specific Fields
  final String isDryValveInService;
  final String isDryPipeValveIntermediateChamberNotLeaking;
  final String areQuickOpeningDeviceControlValvesOpen;
  final String isThereAListOfKnownLowPointDrains;
  final String haveKnownLowPointsBeenDrained;
  final String isOilLevelFullOnAirCompressor;
  final String doesAirCompressorReturnSystemPressureIn30Minutes;
  final String airCompressorStartPressure;
  final String airCompressorStartPressurePSI;
  final String airCompressorStopPressure;
  final String airCompressorStopPressurePSI;
  final String didLowAirAlarmOperate;
  final String didLowAirAlarmOperatePSI;
  final String dateOfLastFullTripTest;
  final String dateOfLastInternalInspection;
  final String notes;

  DrySystemForm({
    required this.pdfPath,
    required this.date,
    required this.location,
    required this.locationCityState,
    required this.inspector,
    required this.isDryValveInService,
    required this.isDryPipeValveIntermediateChamberNotLeaking,
    required this.areQuickOpeningDeviceControlValvesOpen,
    required this.isThereAListOfKnownLowPointDrains,
    required this.haveKnownLowPointsBeenDrained,
    required this.isOilLevelFullOnAirCompressor,
    required this.doesAirCompressorReturnSystemPressureIn30Minutes,
    required this.airCompressorStartPressure,
    required this.airCompressorStartPressurePSI,
    required this.airCompressorStopPressure,
    required this.airCompressorStopPressurePSI,
    required this.didLowAirAlarmOperate,
    required this.didLowAirAlarmOperatePSI,
    required this.dateOfLastFullTripTest,
    required this.dateOfLastInternalInspection,
    required this.notes,
  });

  factory DrySystemForm.fromJson(Map<String, dynamic> json) {
    return DrySystemForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      locationCityState: json['location_city_state']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',

      // Dry Systems Specific Fields
      isDryValveInService: json['is_dry_valve_in_service']?.toString() ?? '',
      isDryPipeValveIntermediateChamberNotLeaking: 
          json['is_dry_pipe_valve_intermediate_chamber_not_leaking']?.toString() ?? '',
      areQuickOpeningDeviceControlValvesOpen: 
          json['are_quick_opening_device_control_valves_open']?.toString() ?? '',
      isThereAListOfKnownLowPointDrains: 
          json['is_there_a_list_of_known_low_point_drains']?.toString() ?? '',
      haveKnownLowPointsBeenDrained: 
          json['have_known_low_points_been_drained']?.toString() ?? '',
      isOilLevelFullOnAirCompressor: 
          json['is_oil_level_full_on_air_compressor']?.toString() ?? '',
      doesAirCompressorReturnSystemPressureIn30Minutes: 
          json['does_air_compressor_return_system_pressure_in_30_minutes']?.toString() ?? '',
      airCompressorStartPressure: 
          json['air_compressor_start_pressure']?.toString() ?? '',
      airCompressorStartPressurePSI: 
          json['air_compressor_start_pressure_psi']?.toString() ?? '',
      airCompressorStopPressure: 
          json['air_compressor_stop_pressure']?.toString() ?? '',
      airCompressorStopPressurePSI: 
          json['air_compressor_stop_pressure_psi']?.toString() ?? '',
      didLowAirAlarmOperate: 
          json['did_low_air_alarm_operate']?.toString() ?? '',
      didLowAirAlarmOperatePSI: 
          json['did_low_air_alarm_operate_psi']?.toString() ?? '',
      dateOfLastFullTripTest: 
          json['date_of_last_full_trip_test']?.toString() ?? '',
      dateOfLastInternalInspection: 
          json['date_of_last_internal_inspection']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }
}