// lib/services/inspection_creation_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/inspection_data.dart';
import '../models/inspection_form.dart';
import '../services/database_helper.dart';
import '../services/sync_service.dart';
import '../services/api_client.dart';
import '../config/app_config.dart';

/// Handles all inspection creation operations
/// Separated from DataService to keep that class focused on data retrieval
class InspectionCreationService {
  static final InspectionCreationService _instance = InspectionCreationService._internal();
  factory InspectionCreationService() => _instance;
  InspectionCreationService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiClient _apiClient = ApiClient();

  /// Create a new inspection locally with automatic PDF path generation
  /// Returns true if successful, false otherwise
  Future<bool> createInspection(
    InspectionData inspectionData, {
    bool attemptSync = true,
    Future<bool> Function()? isOnlineCheck,
  }) async {
    try {
      // Generate unique PDF path with city and location info
      final pdfPath = _generatePdfPath(
        inspectionData.form.location,
        locationCityState: inspectionData.form.locationCityState,
      );
      
      // Build the complete inspection form with all fields
      final updatedForm = _buildInspectionForm(inspectionData.form, pdfPath);
      
      // Create the inspection data object
      final newInspectionData = InspectionData(updatedForm);
      
      // Attempt to post to API if online
      bool apiSuccess = false;
      if (attemptSync && isOnlineCheck != null && await isOnlineCheck()) {
        apiSuccess = await _postToApi(newInspectionData);
        
        if (kDebugMode) {
          print('API post result: $apiSuccess');
        }
      }
      
      // Always save to local database (as backup or for offline use)
      await _dbHelper.saveInspections([newInspectionData]);
      
      // Add local creation flags for sync tracking if API failed
      if (!apiSuccess) {
        await _addLocalCreationFlags(pdfPath);
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating inspection: $e');
      }
      return false;
    }
  }

  /// Post inspection data to API
  Future<bool> _postToApi(InspectionData inspectionData) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.inspectionsEndpoint}');
      
      // Convert InspectionForm to JSON map
      final formJson = _inspectionFormToJson(inspectionData.form);
      
      if (kDebugMode) {
        print('Posting inspection to API: $url');
        print('PDF Path: ${inspectionData.form.pdfPath}');
      }
      
      final response = await _apiClient.post(url, body: formJson);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Successfully posted inspection to API');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('❌ API returned error: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error posting to API: $e');
      }
      return false;
    }
  }

  /// Convert InspectionForm to JSON map for API
  Map<String, dynamic> _inspectionFormToJson(InspectionForm form) {
    return {
      'pdf_path': form.pdfPath,
      'pdf_needed': true,
      'bill_to': form.billTo,
      'location': form.location,
      'bill_to_ln_2': form.billToLn2,
      'location_ln_2': form.locationLn2,
      'attention': form.attention,
      'billing_street': form.billingStreet,
      'billing_street_ln_2': form.billingStreetLn2,
      'location_street': form.locationStreet,
      'location_street_ln_2': form.locationStreetLn2,
      'billing_city_state': form.billingCityState,
      'billing_city_state_ln_2': form.billingCityStateLn2,
      'location_city_state': form.locationCityState,
      'location_city_state_ln_2': form.locationCityStateLn2,
      'contact': form.contact,
      'date': form.date,
      'phone': form.phone,
      'inspector': form.inspector,
      'email': form.email,
      'inspection_frequency': form.inspectionFrequency,
      'inspection_number': form.inspectionNumber,
      'is_the_building_occupied': form.isTheBuildingOccupied,
      'are_all_systems_in_service': form.areAllSystemsInService,
      'are_fp_systems_same_as_last_inspection': form.areFpSystemsSameAsLastInspection,
      'hydraulic_nameplate_securely_attached_and_legible': form.hydraulicNameplateSecurelyAttachedAndLegible,
      'was_a_main_drain_water_flow_test_conducted': form.wasAMainDrainWaterFlowTestConducted,
      'are_all_sprinkler_system_main_control_valves_open': form.areAllSprinklerSystemMainControlValvesOpen,
      'are_all_other_valves_in_proper_position': form.areAllOtherValvesInProperPosition,
      'are_all_control_valves_sealed_or_supervised': form.areAllControlValvesSealedOrSupervised,
      'are_all_control_valves_in_good_condition_and_free_of_leaks': form.areAllControlValvesInGoodConditionAndFreeOfLeaks,
      'are_fire_department_connections_in_satisfactory_condition': form.areFireDepartmentConnectionsInSatisfactoryCondition,
      'are_caps_in_place': form.areCapsInPlace,
      'is_fire_department_connection_easily_accessible': form.isFireDepartmentConnectionEasilyAccessible,
      'automatic_drain_valve_in_place': form.automaticDrainValeInPlace,
      'is_the_pump_room_heated': form.isThePumpRoomHeated,
      'is_the_fire_pump_in_service': form.isTheFirePumpInService,
      'was_fire_pump_run_during_this_inspection': form.wasFirePumpRunDuringThisInspection,
      'was_the_pump_started_in_the_automatic_mode_by_a_pressure_drop': form.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
      'were_the_pump_bearings_lubricated': form.wereThePumpBearingsLubricated,
      'jockey_pump_start_pressure_psi': form.jockeyPumpStartPressurePSI,
      'jockey_pump_start_pressure': form.jockeyPumpStartPressure,
      'jockey_pump_stop_pressure_psi': form.jockeyPumpStopPressurePSI,
      'jockey_pump_stop_pressure': form.jockeyPumpStopPressure,
      'fire_pump_start_pressure_psi': form.firePumpStartPressurePSI,
      'fire_pump_start_pressure': form.firePumpStartPressure,
      'fire_pump_stop_pressure_psi': form.firePumpStopPressurePSI,
      'fire_pump_stop_pressure': form.firePumpStopPressure,
      'is_the_fuel_tank_at_least_2_3_full': form.isTheFuelTankAtLeast2_3Full,
      'is_engine_oil_at_correct_level': form.isEngineOilAtCorrectLevel,
      'is_engine_coolant_at_correct_level': form.isEngineCoolantAtCorrectLevel,
      'is_the_engine_block_heater_working': form.isTheEngineBlockHeaterWorking,
      'is_pump_room_ventilation_operating_properly': form.isPumpRoomVentilationOperatingProperly,
      'was_water_discharge_observed_from_heat_exchanger_return_line': form.wasWaterDischargeObservedFromHeatExchangerReturnLine,
      'was_cooling_line_strainer_cleaned_after_test': form.wasCoolingLineStrainerCleanedAfterTest,
      'was_pump_run_for_at_least_30_minutes': form.wasPumpRunForAtLeast30Minutes,
      'does_the_switch_in_auto_alarm_work': form.doesTheSwitchInAutoAlarmWork,
      'does_the_pump_running_alarm_work': form.doesThePumpRunningAlarmWork,
      'does_the_common_alarm_work': form.doesTheCommonAlarmWork,
      'was_casing_relief_valve_operating_properly': form.wasCasingReliefValveOperatingProperly,
      'was_pump_run_for_at_least_10_minutes': form.wasPumpRunForAtLeast10Minutes,
      'does_the_loss_of_power_alarm_work': form.doesTheLossOfPowerAlarmWork,
      'does_the_electric_pump_running_alarm_work': form.doesTheElectricPumpRunningAlarmWork,
      'power_failure_condition_simulated_while_pump_operating_at_peak_': form.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
      'transfer_of_power_to_alternative_power_source_verified': form.trasferOfPowerToAlternativePowerSourceVerified,
      'power_failure_condition_removed': form.powerFaulureConditionRemoved,
      'pump_reconnected_to_normal_power_source_after_a_time_delay': form.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
      'have_anti_freeze_systems_been_tested': form.haveAntiFreezeSystemsBeenTested,
      'freeze_protection_in_degrees_f': form.freezeProtectionInDegreesF,
      'are_alarm_valves_water_flow_devices_and_retards_in_satisfactory': form.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
      'water_flow_alarm_test_conducted_with_inspectors_test': form.waterFlowAlarmTestConductedWithInspectorsTest,
      'water_flow_alarm_test_conducted_with_bypass_connection': form.waterFlowAlarmTestConductedWithBypassConnection,
      'is_dry_valve_in_service_and_in_good_condition': form.isDryValveInServiceAndInGoodCondition,
      'is_dry_valve_itermediate_chamber_not_leaking': form.isDryValveItermediateChamberNotLeaking,
      'has_the_dry_system_been_fully_tripped_within_the_last_three_yea': form.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
      'are_quick_opening_device_control_valves_open': form.areQuickOpeningDeviceControlValvesOpen,
      'is_there_a_list_of_known_low_point_drains_at_the_riser': form.isThereAListOfKnownLowPointDrainsAtTheRiser,
      'have_known_low_points_been_drained': form.haveKnownLowPointsBeenDrained,
      'is_oil_level_full_on_air_compressor': form.isOilLevelFullOnAirCompressor,
      'does_the_air_compressor_return_system_pressure_in_30_minutes_or': form.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
      'what_pressure_does_air_compressor_start_psi': form.whatPressureDoesAirCompressorStartPSI,
      'what_pressure_does_air_compressor_start': form.whatPressureDoesAirCompressorStart,
      'what_pressure_does_air_compressor_stop_psi': form.whatPressureDoesAirCompressorStopPSI,
      'what_pressure_does_air_compressor_stop': form.whatPressureDoesAirCompressorStop,
      'did_low_air_alarm_operate_psi': form.didLowAirAlarmOperatePSI,
      'did_low_air_alarm_operate': form.didLowAirAlarmOperate,
      'date_of_last_full_trip_test': form.dateOfLastFullTripTest,
      'date_of_last_internal_inspection': form.dateOfLastInternalInspection,
      'are_valves_in_service_and_in_good_condition': form.areValvesInServiceAndInGoodCondition,
      'were_valves_tripped': form.wereValvesTripped,
      'what_pressure_did_pneumatic_actuator_trip_psi': form.whatPressureDidPneumaticActuatorTripPSI,
      'what_pressure_did_pneumatic_actuator_trip': form.whatPressureDidPneumaticActuatorTrip,
      'was_priming_line_left_on_after_test': form.wasPrimingLineLeftOnAfterTest,
      'what_pressure_does_preaction_air_compressor_start_psi': form.whatPressureDoesPreactionAirCompressorStartPSI,
      'what_pressure_does_preaction_air_compressor_start': form.whatPressureDoesPreactionAirCompressorStart,
      'what_pressure_does_preaction_air_compressor_stop_psi': form.whatPressureDoesPreactionAirCompressorStopPSI,
      'what_pressure_does_preaction_air_compressor_stop': form.whatPressureDoesPreactionAirCompressorStop,
      'did_preaction_low_air_alarm_operate_psi': form.didPreactionLowAirAlarmOperatePSI,
      'did_preaction_low_air_alarm_operate': form.didPreactionLowAirAlarmOperate,
      'does_water_motor_gong_work': form.doesWaterMotorGongWork,
      'does_electric_bell_work': form.doesElectricBellWork,
      'are_water_flow_alarms_operational': form.areWaterFlowAlarmsOperational,
      'are_all_tamper_switches_operational': form.areAllTamperSwitchesOperational,
      'did_alarm_panel_clear_after_test': form.didAlarmPanelClearAfterTest,
      'are_a_minimum_of_6_spare_sprinklers_readily_avaiable': form.areAMinimumOf6SpareSprinklersReadilyAvaiable,
      'is_condition_of_piping_and_other_system_componets_satisfactory': form.isConditionOfPipingAndOtherSystemComponentsSatisfactory,
      'are_known_dry_type_heads_less_than_10_years_old': form.areKnownDryTypeHeadsLessThan10YearsOld,
      'are_known_dry_type_heads_less_than_10_years_old_year': form.areKnownDryTypeHeadsLessThan10YearsOldYear,
      'are_known_quick_response_heads_less_than_20_years_old': form.areKnownQuickResponseHeadsLessThan20YearsOld,
      'are_known_quick_response_heads_less_than_20_years_old_year': form.areKnownQuickResponseHeadsLessThan20YearsOldYear,
      'are_known_standard_response_heads_less_than_50_years_old': form.areKnownStandardResponseHeadsLessThan50YearsOld,
      'are_known_standard_response_heads_less_than_50_years_old_year': form.areKnownStandardResponseHeadsLessThan50YearsOldYear,
      'have_all_gauges_been_tested_or_replaced_in_the_last_5_years': form.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
      'have_all_gauges_been_tested_or_replaced_in_the_last_5_years_yea': form.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
      'system_1_name': form.system1Name,
      'system_1_drain_size': form.system1DrainSize,
      'system_1_static_psi': form.system1StaticPSI,
      'system_1_residual_psi': form.system1ResidualPSI,
      'system_2_name': form.system2Name,
      'system_2_drain_size': form.system2DrainSize,
      'system_2_static_psi': form.system2StaticPSI,
      'system_2_residual_psi': form.system2ResidualPSI,
      'system_3_name': form.system3Name,
      'system_3_drain_size': form.system3DrainSize,
      'system_3_static_psi': form.system3StaticPSI,
      'system_3_residual_psi': form.system3ResidualPSI,
      'system_4_name': form.system4Name,
      'system_4_drain_size': form.system4DrainSize,
      'system_4_static_psi': form.system4StaticPSI,
      'system_4_residual_psi': form.system4ResidualPSI,
      'system_5_name': form.system5Name,
      'system_5_drain_size': form.system5DrainSize,
      'system_5_static_psi': form.system5StaticPSI,
      'system_5_residual_psi': form.system5ResidualPSI,
      'system_6_name': form.system6Name,
      'system_6_drain_size': form.system6DrainSize,
      'system_6_static_psi': form.system6StaticPSI,
      'system_6_residual_psi': form.system6ResidualPSI,
      'drain_test_notes': form.drainTestNotes,
      'device_1_name': form.device1Name,
      'device_1_address': form.device1Address,
      'device_1_description_location': form.device1DescriptionLocation,
      'device_1_operated': form.device1Operated,
      'device_1_delay_sec': form.device1DelaySec,
      'device_2_name': form.device2Name,
      'device_2_address': form.device2Address,
      'device_2_description_location': form.device2DescriptionLocation,
      'device_2_operated': form.device2Operated,
      'device_2_delay_sec': form.device2DelaySec,
      'device_3_name': form.device3Name,
      'device_3_address': form.device3Address,
      'device_3_description_location': form.device3DescriptionLocation,
      'device_3_operated': form.device3Operated,
      'device_3_delay_sec': form.device3DelaySec,
      'device_4_name': form.device4Name,
      'device_4_address': form.device4Address,
      'device_4_description_location': form.device4DescriptionLocation,
      'device_4_operated': form.device4Operated,
      'device_4_delay_sec': form.device4DelaySec,
      'device_5_name': form.device5Name,
      'device_5_address': form.device5Address,
      'device_5_description_location': form.device5DescriptionLocation,
      'device_5_operated': form.device5Operated,
      'device_5_delay_sec': form.device5DelaySec,
      'device_6_name': form.device6Name,
      'device_6_address': form.device6Address,
      'device_6_description_location': form.device6DescriptionLocation,
      'device_6_operated': form.device6Operated,
      'device_6_delay_sec': form.device6DelaySec,
      'device_7_name': form.device7Name,
      'device_7_address': form.device7Address,
      'device_7_description_location': form.device7DescriptionLocation,
      'device_7_operated': form.device7Operated,
      'device_7_delay_sec': form.device7DelaySec,
      'device_8_name': form.device8Name,
      'device_8_address': form.device8Address,
      'device_8_description_location': form.device8DescriptionLocation,
      'device_8_operated': form.device8Operated,
      'device_8_delay_sec': form.device8DelaySec,
      'device_9_name': form.device9Name,
      'device_9_address': form.device9Address,
      'device_9_description_location': form.device9DescriptionLocation,
      'device_9_operated': form.device9Operated,
      'device_9_delay_sec': form.device9DelaySec,
      'device_10_name': form.device10Name,
      'device_10_address': form.device10Address,
      'device_10_description_location': form.device10DescriptionLocation,
      'device_10_operated': form.device10Operated,
      'device_10_delay_sec': form.device10DelaySec,
      'device_11_name': form.device11Name,
      'device_11_address': form.device11Address,
      'device_11_description_location': form.device11DescriptionLocation,
      'device_11_operated': form.device11Operated,
      'device_11_delay_sec': form.device11DelaySec,
      'device_12_name': form.device12Name,
      'device_12_address': form.device12Address,
      'device_12_description_location': form.device12DescriptionLocation,
      'device_12_operated': form.device12Operated,
      'device_12_delay_sec': form.device12DelaySec,
      'device_13_name': form.device13Name,
      'device_13_address': form.device13Address,
      'device_13_description_location': form.device13DescriptionLocation,
      'device_13_operated': form.device13Operated,
      'device_13_delay_sec': form.device13DelaySec,
      'device_14_name': form.device14Name,
      'device_14_address': form.device14Address,
      'device_14_description_location': form.device14DescriptionLocation,
      'device_14_operated': form.device14Operated,
      'device_14_delay_sec': form.device14DelaySec,
      'adjustments_or_corrections_make': form.adjustmentsOrCorrectionsMake,
      'explanation_of_any_no_answers': form.explanationOfAnyNoAnswers,
      'explanation_of_any_no_answers_continued': form.explanationOfAnyNoAnswersContinued,
      'notes': form.notes,
    };
  }

  /// Generate a unique PDF path based on location and timestamp
  /// Format: H:\Inspections - Maintenance\Files by town\{city}\{location}\Inspection Reports\{yyyy-mm-dd_location}.pdf
  String _generatePdfPath(String location, {String? city, String? locationCityState}) {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    
    // Extract city from locationCityState if available (format: "City, State")
    String cityName = city ?? 'Unknown';
    if (locationCityState != null && locationCityState.contains(',')) {
      cityName = locationCityState.split(',')[0].trim();
    }
    
    // Clean up location for use in path and filename
    final locationForPath = location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    
    final locationForFilename = location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    
    // Build path following the format: H:\Inspections - Maintenance\Files by town\{city}\{location}\Inspection Reports\{yyyy-mm-dd_location}.pdf
    return 'H:\\Inspections - Maintenance\\Files by town\\$cityName\\$locationForPath\\Inspection Reports\\${dateStr}_$locationForFilename.pdf';
  }

  /// Build a complete InspectionForm with all fields from the source form
  /// This massive method exists because InspectionForm has 150+ fields
  InspectionForm _buildInspectionForm(InspectionForm sourceForm, String pdfPath) {
    return InspectionForm(
      // Generated field
      pdfPath: pdfPath,
      
      // Basic Info - Billing and Location
      billTo: sourceForm.billTo,
      location: sourceForm.location,
      billToLn2: sourceForm.billToLn2,
      locationLn2: sourceForm.locationLn2,
      attention: sourceForm.attention,
      billingStreet: sourceForm.billingStreet,
      billingStreetLn2: sourceForm.billingStreetLn2,
      locationStreet: sourceForm.locationStreet,
      locationStreetLn2: sourceForm.locationStreetLn2,
      billingCityState: sourceForm.billingCityState,
      billingCityStateLn2: sourceForm.billingCityStateLn2,
      locationCityState: sourceForm.locationCityState,
      locationCityStateLn2: sourceForm.locationCityStateLn2,
      
      // Contact and Inspection Details
      contact: sourceForm.contact,
      date: sourceForm.date,
      phone: sourceForm.phone,
      inspector: sourceForm.inspector,
      email: sourceForm.email,
      inspectionFrequency: sourceForm.inspectionFrequency,
      inspectionNumber: sourceForm.inspectionNumber,
      
      // Building and System Status Questions
      isTheBuildingOccupied: sourceForm.isTheBuildingOccupied,
      areAllSystemsInService: sourceForm.areAllSystemsInService,
      areFpSystemsSameAsLastInspection: sourceForm.areFpSystemsSameAsLastInspection,
      hydraulicNameplateSecurelyAttachedAndLegible: sourceForm.hydraulicNameplateSecurelyAttachedAndLegible,
      wasAMainDrainWaterFlowTestConducted: sourceForm.wasAMainDrainWaterFlowTestConducted,
      
      // Valve Questions
      areAllSprinklerSystemMainControlValvesOpen: sourceForm.areAllSprinklerSystemMainControlValvesOpen,
      areAllOtherValvesInProperPosition: sourceForm.areAllOtherValvesInProperPosition,
      areAllControlValvesSealedOrSupervised: sourceForm.areAllControlValvesSealedOrSupervised,
      areAllControlValvesInGoodConditionAndFreeOfLeaks: sourceForm.areAllControlValvesInGoodConditionAndFreeOfLeaks,
      
      // Fire Department Connection Questions
      areFireDepartmentConnectionsInSatisfactoryCondition: sourceForm.areFireDepartmentConnectionsInSatisfactoryCondition,
      areCapsInPlace: sourceForm.areCapsInPlace,
      isFireDepartmentConnectionEasilyAccessible: sourceForm.isFireDepartmentConnectionEasilyAccessible,
      automaticDrainValeInPlace: sourceForm.automaticDrainValeInPlace,
      
      // Pump Room and Fire Pump Questions
      isThePumpRoomHeated: sourceForm.isThePumpRoomHeated,
      isTheFirePumpInService: sourceForm.isTheFirePumpInService,
      wasFirePumpRunDuringThisInspection: sourceForm.wasFirePumpRunDuringThisInspection,
      wasThePumpStartedInTheAutomaticModeByAPressureDrop: sourceForm.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
      wereThePumpBearingsLubricated: sourceForm.wereThePumpBearingsLubricated,
      
      // Pump Pressure Settings
      jockeyPumpStartPressurePSI: sourceForm.jockeyPumpStartPressurePSI,
      jockeyPumpStartPressure: sourceForm.jockeyPumpStartPressure,
      jockeyPumpStopPressurePSI: sourceForm.jockeyPumpStopPressurePSI,
      jockeyPumpStopPressure: sourceForm.jockeyPumpStopPressure,
      firePumpStartPressurePSI: sourceForm.firePumpStartPressurePSI,
      firePumpStartPressure: sourceForm.firePumpStartPressure,
      firePumpStopPressurePSI: sourceForm.firePumpStopPressurePSI,
      firePumpStopPressure: sourceForm.firePumpStopPressure,
      
      // Engine and Fuel Questions
      isTheFuelTankAtLeast2_3Full: sourceForm.isTheFuelTankAtLeast2_3Full,
      isEngineOilAtCorrectLevel: sourceForm.isEngineOilAtCorrectLevel,
      isEngineCoolantAtCorrectLevel: sourceForm.isEngineCoolantAtCorrectLevel,
      isTheEngineBlockHeaterWorking: sourceForm.isTheEngineBlockHeaterWorking,
      isPumpRoomVentilationOperatingProperly: sourceForm.isPumpRoomVentilationOperatingProperly,
      wasWaterDischargeObservedFromHeatExchangerReturnLine: sourceForm.wasWaterDischargeObservedFromHeatExchangerReturnLine,
      wasCoolingLineStrainerCleanedAfterTest: sourceForm.wasCoolingLineStrainerCleanedAfterTest,
      wasPumpRunForAtLeast30Minutes: sourceForm.wasPumpRunForAtLeast30Minutes,
      
      // Alarm Questions
      doesTheSwitchInAutoAlarmWork: sourceForm.doesTheSwitchInAutoAlarmWork,
      doesThePumpRunningAlarmWork: sourceForm.doesThePumpRunningAlarmWork,
      doesTheCommonAlarmWork: sourceForm.doesTheCommonAlarmWork,
      wasCasingReliefValveOperatingProperly: sourceForm.wasCasingReliefValveOperatingProperly,
      wasPumpRunForAtLeast10Minutes: sourceForm.wasPumpRunForAtLeast10Minutes,
      doesTheLossOfPowerAlarmWork: sourceForm.doesTheLossOfPowerAlarmWork,
      doesTheElectricPumpRunningAlarmWork: sourceForm.doesTheElectricPumpRunningAlarmWork,
      
      // Power and Transfer Questions
      powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad: sourceForm.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
      trasferOfPowerToAlternativePowerSourceVerified: sourceForm.trasferOfPowerToAlternativePowerSourceVerified,
      powerFaulureConditionRemoved: sourceForm.powerFaulureConditionRemoved,
      pumpReconnectedToNormalPowerSourceAfterATimeDelay: sourceForm.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
      
      // Antifreeze System
      haveAntiFreezeSystemsBeenTested: sourceForm.haveAntiFreezeSystemsBeenTested,
      freezeProtectionInDegreesF: sourceForm.freezeProtectionInDegreesF,
      
      // Alarm Valves and Water Flow
      areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition: sourceForm.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
      waterFlowAlarmTestConductedWithInspectorsTest: sourceForm.waterFlowAlarmTestConductedWithInspectorsTest,
      waterFlowAlarmTestConductedWithBypassConnection: sourceForm.waterFlowAlarmTestConductedWithBypassConnection,
      
      // Dry Valve Questions
      isDryValveInServiceAndInGoodCondition: sourceForm.isDryValveInServiceAndInGoodCondition,
      isDryValveItermediateChamberNotLeaking: sourceForm.isDryValveItermediateChamberNotLeaking,
      hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears: sourceForm.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
      areQuickOpeningDeviceControlValvesOpen: sourceForm.areQuickOpeningDeviceControlValvesOpen,
      
      // Low Point Drains
      isThereAListOfKnownLowPointDrainsAtTheRiser: sourceForm.isThereAListOfKnownLowPointDrainsAtTheRiser,
      haveKnownLowPointsBeenDrained: sourceForm.haveKnownLowPointsBeenDrained,
      
      // Air Compressor Questions
      isOilLevelFullOnAirCompressor: sourceForm.isOilLevelFullOnAirCompressor,
      doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder: sourceForm.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
      whatPressureDoesAirCompressorStartPSI: sourceForm.whatPressureDoesAirCompressorStartPSI,
      whatPressureDoesAirCompressorStart: sourceForm.whatPressureDoesAirCompressorStart,
      whatPressureDoesAirCompressorStopPSI: sourceForm.whatPressureDoesAirCompressorStopPSI,
      whatPressureDoesAirCompressorStop: sourceForm.whatPressureDoesAirCompressorStop,
      didLowAirAlarmOperatePSI: sourceForm.didLowAirAlarmOperatePSI,
      didLowAirAlarmOperate: sourceForm.didLowAirAlarmOperate,
      
      // Test Dates
      dateOfLastFullTripTest: sourceForm.dateOfLastFullTripTest,
      dateOfLastInternalInspection: sourceForm.dateOfLastInternalInspection,
      
      // Preaction Valve Questions
      areValvesInServiceAndInGoodCondition: sourceForm.areValvesInServiceAndInGoodCondition,
      wereValvesTripped: sourceForm.wereValvesTripped,
      whatPressureDidPneumaticActuatorTripPSI: sourceForm.whatPressureDidPneumaticActuatorTripPSI,
      whatPressureDidPneumaticActuatorTrip: sourceForm.whatPressureDidPneumaticActuatorTrip,
      wasPrimingLineLeftOnAfterTest: sourceForm.wasPrimingLineLeftOnAfterTest,
      
      // Preaction Air Compressor
      whatPressureDoesPreactionAirCompressorStartPSI: sourceForm.whatPressureDoesPreactionAirCompressorStartPSI,
      whatPressureDoesPreactionAirCompressorStart: sourceForm.whatPressureDoesPreactionAirCompressorStart,
      whatPressureDoesPreactionAirCompressorStopPSI: sourceForm.whatPressureDoesPreactionAirCompressorStopPSI,
      whatPressureDoesPreactionAirCompressorStop: sourceForm.whatPressureDoesPreactionAirCompressorStop,
      didPreactionLowAirAlarmOperatePSI: sourceForm.didPreactionLowAirAlarmOperatePSI,
      didPreactionLowAirAlarmOperate: sourceForm.didPreactionLowAirAlarmOperate,
      
      // Alarm Device Questions
      doesWaterMotorGongWork: sourceForm.doesWaterMotorGongWork,
      doesElectricBellWork: sourceForm.doesElectricBellWork,
      areWaterFlowAlarmsOperational: sourceForm.areWaterFlowAlarmsOperational,
      areAllTamperSwitchesOperational: sourceForm.areAllTamperSwitchesOperational,
      didAlarmPanelClearAfterTest: sourceForm.didAlarmPanelClearAfterTest,
      
      // Sprinkler and Component Questions
      areAMinimumOf6SpareSprinklersReadilyAvaiable: sourceForm.areAMinimumOf6SpareSprinklersReadilyAvaiable,
      isConditionOfPipingAndOtherSystemComponentsSatisfactory: sourceForm.isConditionOfPipingAndOtherSystemComponentsSatisfactory,
      
      // Sprinkler Head Age Questions
      areKnownDryTypeHeadsLessThan10YearsOld: sourceForm.areKnownDryTypeHeadsLessThan10YearsOld,
      areKnownDryTypeHeadsLessThan10YearsOldYear: sourceForm.areKnownDryTypeHeadsLessThan10YearsOldYear,
      areKnownQuickResponseHeadsLessThan20YearsOld: sourceForm.areKnownQuickResponseHeadsLessThan20YearsOld,
      areKnownQuickResponseHeadsLessThan20YearsOldYear: sourceForm.areKnownQuickResponseHeadsLessThan20YearsOldYear,
      areKnownStandardResponseHeadsLessThan50YearsOld: sourceForm.areKnownStandardResponseHeadsLessThan50YearsOld,
      areKnownStandardResponseHeadsLessThan50YearsOldYear: sourceForm.areKnownStandardResponseHeadsLessThan50YearsOldYear,
      
      // Gauge Testing
      haveAllGaugesBeenTestedOrReplacedInTheLast5Years: sourceForm.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
      haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: sourceForm.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
      
      // Systems 1-6 (Main Drain Test Data)
      system1Name: sourceForm.system1Name,
      system1DrainSize: sourceForm.system1DrainSize,
      system1StaticPSI: sourceForm.system1StaticPSI,
      system1ResidualPSI: sourceForm.system1ResidualPSI,
      system2Name: sourceForm.system2Name,
      system2DrainSize: sourceForm.system2DrainSize,
      system2StaticPSI: sourceForm.system2StaticPSI,
      system2ResidualPSI: sourceForm.system2ResidualPSI,
      system3Name: sourceForm.system3Name,
      system3DrainSize: sourceForm.system3DrainSize,
      system3StaticPSI: sourceForm.system3StaticPSI,
      system3ResidualPSI: sourceForm.system3ResidualPSI,
      system4Name: sourceForm.system4Name,
      system4DrainSize: sourceForm.system4DrainSize,
      system4StaticPSI: sourceForm.system4StaticPSI,
      system4ResidualPSI: sourceForm.system4ResidualPSI,
      system5Name: sourceForm.system5Name,
      system5DrainSize: sourceForm.system5DrainSize,
      system5StaticPSI: sourceForm.system5StaticPSI,
      system5ResidualPSI: sourceForm.system5ResidualPSI,
      system6Name: sourceForm.system6Name,
      system6DrainSize: sourceForm.system6DrainSize,
      system6StaticPSI: sourceForm.system6StaticPSI,
      system6ResidualPSI: sourceForm.system6ResidualPSI,
      drainTestNotes: sourceForm.drainTestNotes,
      
      // Devices 1-14 (Alarm Device Test Data)
      device1Name: sourceForm.device1Name,
      device1Address: sourceForm.device1Address,
      device1DescriptionLocation: sourceForm.device1DescriptionLocation,
      device1Operated: sourceForm.device1Operated,
      device1DelaySec: sourceForm.device1DelaySec,
      device2Name: sourceForm.device2Name,
      device2Address: sourceForm.device2Address,
      device2DescriptionLocation: sourceForm.device2DescriptionLocation,
      device2Operated: sourceForm.device2Operated,
      device2DelaySec: sourceForm.device2DelaySec,
      device3Name: sourceForm.device3Name,
      device3Address: sourceForm.device3Address,
      device3DescriptionLocation: sourceForm.device3DescriptionLocation,
      device3Operated: sourceForm.device3Operated,
      device3DelaySec: sourceForm.device3DelaySec,
      device4Name: sourceForm.device4Name,
      device4Address: sourceForm.device4Address,
      device4DescriptionLocation: sourceForm.device4DescriptionLocation,
      device4Operated: sourceForm.device4Operated,
      device4DelaySec: sourceForm.device4DelaySec,
      device5Name: sourceForm.device5Name,
      device5Address: sourceForm.device5Address,
      device5DescriptionLocation: sourceForm.device5DescriptionLocation,
      device5Operated: sourceForm.device5Operated,
      device5DelaySec: sourceForm.device5DelaySec,
      device6Name: sourceForm.device6Name,
      device6Address: sourceForm.device6Address,
      device6DescriptionLocation: sourceForm.device6DescriptionLocation,
      device6Operated: sourceForm.device6Operated,
      device6DelaySec: sourceForm.device6DelaySec,
      device7Name: sourceForm.device7Name,
      device7Address: sourceForm.device7Address,
      device7DescriptionLocation: sourceForm.device7DescriptionLocation,
      device7Operated: sourceForm.device7Operated,
      device7DelaySec: sourceForm.device7DelaySec,
      device8Name: sourceForm.device8Name,
      device8Address: sourceForm.device8Address,
      device8DescriptionLocation: sourceForm.device8DescriptionLocation,
      device8Operated: sourceForm.device8Operated,
      device8DelaySec: sourceForm.device8DelaySec,
      device9Name: sourceForm.device9Name,
      device9Address: sourceForm.device9Address,
      device9DescriptionLocation: sourceForm.device9DescriptionLocation,
      device9Operated: sourceForm.device9Operated,
      device9DelaySec: sourceForm.device9DelaySec,
      device10Name: sourceForm.device10Name,
      device10Address: sourceForm.device10Address,
      device10DescriptionLocation: sourceForm.device10DescriptionLocation,
      device10Operated: sourceForm.device10Operated,
      device10DelaySec: sourceForm.device10DelaySec,
      device11Name: sourceForm.device11Name,
      device11Address: sourceForm.device11Address,
      device11DescriptionLocation: sourceForm.device11DescriptionLocation,
      device11Operated: sourceForm.device11Operated,
      device11DelaySec: sourceForm.device11DelaySec,
      device12Name: sourceForm.device12Name,
      device12Address: sourceForm.device12Address,
      device12DescriptionLocation: sourceForm.device12DescriptionLocation,
      device12Operated: sourceForm.device12Operated,
      device12DelaySec: sourceForm.device12DelaySec,
      device13Name: sourceForm.device13Name,
      device13Address: sourceForm.device13Address,
      device13DescriptionLocation: sourceForm.device13DescriptionLocation,
      device13Operated: sourceForm.device13Operated,
      device13DelaySec: sourceForm.device13DelaySec,
      device14Name: sourceForm.device14Name,
      device14Address: sourceForm.device14Address,
      device14DescriptionLocation: sourceForm.device14DescriptionLocation,
      device14Operated: sourceForm.device14Operated,
      device14DelaySec: sourceForm.device14DelaySec,
      
      // Final Notes
      adjustmentsOrCorrectionsMake: sourceForm.adjustmentsOrCorrectionsMake,
      explanationOfAnyNoAnswers: sourceForm.explanationOfAnyNoAnswers,
      explanationOfAnyNoAnswersContinued: sourceForm.explanationOfAnyNoAnswersContinued,
      notes: sourceForm.notes,
    );
  }

  /// Add local creation flags to track unsynced records
  Future<void> _addLocalCreationFlags(String pdfPath) async {
    final db = await _dbHelper.database;
    
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      final formDataStr = result.first['form_data'] as String;
      final formData = jsonDecode(formDataStr) as Map<String, dynamic>;
      
      // Flag this as locally created and not yet synced
      formData['created_locally'] = true;
      formData['synced_to_server'] = false;
      formData['created_at'] = DateTime.now().toIso8601String();
      
      await db.update(
        'inspections',
        {
          'form_data': jsonEncode(formData),
          'last_modified': DateTime.now().toIso8601String(),
        },
        where: 'pdf_path = ?',
        whereArgs: [pdfPath],
      );
    }
  }

  /// Attempt to sync locally created records to server
  Future<void> _attemptSync() async {
    try {
      final syncService = SyncService();
      await syncService.syncLocalRecords();
    } catch (e) {
      if (kDebugMode) {
        print('Local save successful but sync failed: $e');
      }
      // Don't throw - local save was successful
    }
  }
}