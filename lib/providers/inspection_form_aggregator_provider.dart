// lib/providers/inspection_form_aggregator_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/inspection_form.dart';
import '../models/inspection_data.dart';
import '../services/database_helper.dart';
import '../services/inspection_creation_service.dart';
import 'system_config_provider.dart';
import 'basic_info_provider.dart';
import 'checklist_providers.dart';
import 'main_drain_test_provider.dart';
import 'device_tests_provider.dart';
import 'notes_provider.dart';
import 'states/checklist_state.dart';

/// Provider that aggregates all form section states into a complete InspectionForm
final inspectionFormAggregatorProvider = Provider<InspectionFormAggregator>((ref) {
  return InspectionFormAggregator(ref);
});

/// Service class that aggregates all Riverpod form states into InspectionForm model
class InspectionFormAggregator {
  final Ref ref;
  
  InspectionFormAggregator(this.ref);

  /// Convert ChecklistAnswer enum to string for API
  String _answerToString(ChecklistAnswer answer) {
    switch (answer) {
      case ChecklistAnswer.yes:
        return 'YES';
      case ChecklistAnswer.no:
        return 'NO';
      case ChecklistAnswer.na:
        return 'N/A';
      case ChecklistAnswer.unanswered:
        return '';
    }
  }

  /// Build complete InspectionForm from all provider states
  InspectionForm buildInspectionForm() {
    // Read all provider states
    final basicInfo = ref.read(basicInfoProvider);
    final generalChecklist = ref.read(generalChecklistProvider);
    final waterSupplies = ref.read(waterSuppliesProvider);
    final controlValves = ref.read(controlValvesProvider);
    final fireDeptConnections = ref.read(fireDeptConnectionsProvider);
    final firePumpGeneral = ref.read(firePumpGeneralProvider);
    final dieselPump = ref.read(dieselFirePumpProvider);
    final electricPump = ref.read(electricFirePumpProvider);
    final wetSystems = ref.read(wetSystemsProvider);
    final drySystems = ref.read(drySystemsProvider);
    final preactionDeluge = ref.read(preActionDelugeProvider);
    final alarms = ref.read(alarmsProvider);
    final sprinklersPiping = ref.read(sprinklersPipingProvider);
    final mainDrainTest = ref.read(mainDrainTestProvider);
    final deviceTests = ref.read(deviceTestsProvider);
    final notes = ref.read(notesProvider);

    // Build device fields (convert dynamic list to fixed device1-14 fields)
    final deviceFields = _buildDeviceFields(deviceTests.devices);

    return InspectionForm(
      // PDF path will be generated during save
      pdfPath: '',
      
      // Basic Info - Billing
      billTo: basicInfo.billTo,
      billToLn2: basicInfo.billToLn2,
      attention: basicInfo.attention,
      billingStreet: basicInfo.billingStreet,
      billingStreetLn2: basicInfo.billingStreetLn2,
      billingCityState: basicInfo.billingCityState,
      billingCityStateLn2: basicInfo.billingCityStateLn2,
      
      // Basic Info - Location
      location: basicInfo.location,
      locationLn2: basicInfo.locationLn2,
      locationStreet: basicInfo.locationStreet,
      locationStreetLn2: basicInfo.locationStreetLn2,
      locationCityState: '${basicInfo.locationCity}, ${basicInfo.locationState}',
      locationCityStateLn2: '',
      
      // Contact and Inspection Details
      contact: basicInfo.contact,
      date: DateFormat('yyyy-MM-dd').format(basicInfo.date),
      phone: basicInfo.phone,
      inspector: basicInfo.inspector,
      email: basicInfo.email,
      inspectionFrequency: basicInfo.inspectionFrequency.isEmpty ? 'Annual' : basicInfo.inspectionFrequency,
      inspectionNumber: basicInfo.inspectionNumber,
      
      // General Checklist Questions
      isTheBuildingOccupied: _answerToString(generalChecklist.getAnswer('is_building_occupied')),
      areAllSystemsInService: _answerToString(generalChecklist.getAnswer('are_all_systems_in_service')),
      areFpSystemsSameAsLastInspection: _answerToString(generalChecklist.getAnswer('are_fp_systems_same')),
      hydraulicNameplateSecurelyAttachedAndLegible: _answerToString(generalChecklist.getAnswer('hydraulic_nameplate_secure')),
      wasAMainDrainWaterFlowTestConducted: _answerToString(waterSupplies.getAnswer('was_main_drain_test_conducted')),
      
      // Water Supplies (Control Valves Section)
      areAllSprinklerSystemMainControlValvesOpen: _answerToString(controlValves.getAnswer('are_main_control_valves_open')),
      areAllOtherValvesInProperPosition: _answerToString(controlValves.getAnswer('are_other_valves_proper')),
      areAllControlValvesSealedOrSupervised: _answerToString(controlValves.getAnswer('are_control_valves_sealed')),
      areAllControlValvesInGoodConditionAndFreeOfLeaks: _answerToString(controlValves.getAnswer('are_control_valves_good_condition')),
      
      // Fire Department Connections
      areFireDepartmentConnectionsInSatisfactoryCondition: _answerToString(fireDeptConnections.getAnswer('are_fd_connections_satisfactory')),
      areCapsInPlace: _answerToString(fireDeptConnections.getAnswer('are_caps_in_place')),
      isFireDepartmentConnectionEasilyAccessible: _answerToString(fireDeptConnections.getAnswer('is_fd_connection_accessible')),
      automaticDrainValeInPlace: _answerToString(fireDeptConnections.getAnswer('automatic_drain_valve_in_place')),
      
      // Fire Pump General
      isThePumpRoomHeated: _answerToString(firePumpGeneral.getAnswer('is_pump_room_heated')),
      isTheFirePumpInService: _answerToString(firePumpGeneral.getAnswer('is_fire_pump_in_service')),
      wasFirePumpRunDuringThisInspection: _answerToString(firePumpGeneral.getAnswer('was_fire_pump_run')),
      wasThePumpStartedInTheAutomaticModeByAPressureDrop: _answerToString(firePumpGeneral.getAnswer('was_pump_started_automatic')),
      wereThePumpBearingsLubricated: _answerToString(firePumpGeneral.getAnswer('were_pump_bearings_lubricated')),
      
      // Fire Pump Pressures (PSI inputs)
      jockeyPumpStartPressurePSI: firePumpGeneral.getValue('jockey_pump_start_pressure_psi'),
      jockeyPumpStartPressure: firePumpGeneral.getValue('jockey_pump_start_pressure_psi'), // Duplicate field in API
      jockeyPumpStopPressurePSI: firePumpGeneral.getValue('jockey_pump_stop_pressure_psi'),
      jockeyPumpStopPressure: firePumpGeneral.getValue('jockey_pump_stop_pressure_psi'), // Duplicate field in API
      firePumpStartPressurePSI: firePumpGeneral.getValue('fire_pump_start_pressure_psi'),
      firePumpStartPressure: firePumpGeneral.getValue('fire_pump_start_pressure_psi'), // Duplicate field in API
      firePumpStopPressurePSI: firePumpGeneral.getValue('fire_pump_stop_pressure_psi'),
      firePumpStopPressure: firePumpGeneral.getValue('fire_pump_stop_pressure_psi'), // Duplicate field in API
      
      // Diesel Fire Pump
      isTheFuelTankAtLeast2_3Full: _answerToString(dieselPump.getAnswer('is_fuel_tank_2_3_full')),
      isEngineOilAtCorrectLevel: _answerToString(dieselPump.getAnswer('is_engine_oil_correct')),
      isEngineCoolantAtCorrectLevel: _answerToString(dieselPump.getAnswer('is_engine_coolant_correct')),
      isTheEngineBlockHeaterWorking: _answerToString(dieselPump.getAnswer('is_engine_block_heater_working')),
      isPumpRoomVentilationOperatingProperly: _answerToString(dieselPump.getAnswer('is_pump_room_ventilation_proper')),
      wasWaterDischargeObservedFromHeatExchangerReturnLine: _answerToString(dieselPump.getAnswer('was_water_discharge_observed')),
      wasCoolingLineStrainerCleanedAfterTest: _answerToString(dieselPump.getAnswer('was_cooling_line_strainer_cleaned')),
      wasPumpRunForAtLeast30Minutes: _answerToString(dieselPump.getAnswer('was_pump_run_30_minutes')),
      doesTheSwitchInAutoAlarmWork: _answerToString(dieselPump.getAnswer('does_switch_auto_alarm_work')),
      doesThePumpRunningAlarmWork: _answerToString(dieselPump.getAnswer('does_pump_running_alarm_work')),
      doesTheCommonAlarmWork: _answerToString(dieselPump.getAnswer('does_common_alarm_work')),
      wasCasingReliefValveOperatingProperly: _answerToString(electricPump.getAnswer('was_casing_relief_valve_proper')),
      
      // Electric Fire Pump
      wasPumpRunForAtLeast10Minutes: _answerToString(electricPump.getAnswer('was_pump_run_10_minutes')),
      doesTheLossOfPowerAlarmWork: _answerToString(electricPump.getAnswer('does_loss_of_power_alarm_work')),
      doesTheElectricPumpRunningAlarmWork: _answerToString(electricPump.getAnswer('does_electric_pump_running_alarm_work')),
      powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad: _answerToString(electricPump.getAnswer('power_failure_simulated')),
      trasferOfPowerToAlternativePowerSourceVerified: _answerToString(electricPump.getAnswer('transfer_to_alternate_power_verified')),
      powerFaulureConditionRemoved: _answerToString(electricPump.getAnswer('power_failure_removed')),
      pumpReconnectedToNormalPowerSourceAfterATimeDelay: _answerToString(electricPump.getAnswer('pump_reconnected_after_delay')),
      
      // Wet Systems
      haveAntiFreezeSystemsBeenTested: _answerToString(wetSystems.getAnswer('have_antifreeze_systems_tested')),
      freezeProtectionInDegreesF: wetSystems.getValue('freeze_protection_in_degrees_f'),
      areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition: _answerToString(wetSystems.getAnswer('are_alarm_valves_satisfactory')),
      waterFlowAlarmTestConductedWithInspectorsTest: _answerToString(waterSupplies.getAnswer('water_flow_alarm_inspectors_test')),
      waterFlowAlarmTestConductedWithBypassConnection: _answerToString(waterSupplies.getAnswer('water_flow_alarm_bypass_connection')),
      
      // Dry Systems
      isDryValveInServiceAndInGoodCondition: _answerToString(drySystems.getAnswer('is_dry_valve_in_service')),
      isDryValveItermediateChamberNotLeaking: _answerToString(drySystems.getAnswer('is_dry_valve_chamber_not_leaking')),
      hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears: _answerToString(drySystems.getAnswer('has_dry_system_been_fully_tripped_within_last_three_years')),
      areQuickOpeningDeviceControlValvesOpen: _answerToString(drySystems.getAnswer('are_quick_opening_valves_open')),
      isThereAListOfKnownLowPointDrainsAtTheRiser: _answerToString(drySystems.getAnswer('is_list_of_low_point_drains')),
      haveKnownLowPointsBeenDrained: _answerToString(drySystems.getAnswer('have_low_points_been_drained')),
      isOilLevelFullOnAirCompressor: _answerToString(drySystems.getAnswer('is_oil_level_full_compressor')),
      doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder: _answerToString(drySystems.getAnswer('does_compressor_return_pressure_30min')),
      whatPressureDoesAirCompressorStartPSI: drySystems.getValue('what_pressure_compressor_start_psi'),
      whatPressureDoesAirCompressorStart: drySystems.getValue('what_pressure_compressor_start_psi'), // Duplicate field
      whatPressureDoesAirCompressorStopPSI: drySystems.getValue('what_pressure_compressor_stop_psi'),
      whatPressureDoesAirCompressorStop: drySystems.getValue('what_pressure_compressor_stop_psi'), // Duplicate field
      didLowAirAlarmOperatePSI: drySystems.getValue('did_low_air_alarm_operate_psi'),
      didLowAirAlarmOperate: drySystems.getValue('did_low_air_alarm_operate_psi'), // Duplicate field
      dateOfLastFullTripTest: drySystems.getValue('date_of_last_full_trip_test'),
      dateOfLastInternalInspection: drySystems.getValue('date_of_last_internal_inspection'),
      
      // Pre-Action/Deluge
      areValvesInServiceAndInGoodCondition: _answerToString(preactionDeluge.getAnswer('are_valves_in_service')),
      wereValvesTripped: _answerToString(preactionDeluge.getAnswer('were_valves_tripped')),
      whatPressureDidPneumaticActuatorTripPSI: preactionDeluge.getValue('what_pressure_pneumatic_actuator_trip_psi'),
      whatPressureDidPneumaticActuatorTrip: preactionDeluge.getValue('what_pressure_pneumatic_actuator_trip_psi'), // Duplicate field
      wasPrimingLineLeftOnAfterTest: _answerToString(preactionDeluge.getAnswer('was_priming_line_left_on')),
      whatPressureDoesPreactionAirCompressorStartPSI: preactionDeluge.getValue('what_pressure_preaction_compressor_start_psi'),
      whatPressureDoesPreactionAirCompressorStart: preactionDeluge.getValue('what_pressure_preaction_compressor_start_psi'), // Duplicate field
      whatPressureDoesPreactionAirCompressorStopPSI: preactionDeluge.getValue('what_pressure_preaction_compressor_stop_psi'),
      whatPressureDoesPreactionAirCompressorStop: preactionDeluge.getValue('what_pressure_preaction_compressor_stop_psi'), // Duplicate field
      didPreactionLowAirAlarmOperatePSI: preactionDeluge.getValue('did_preaction_low_air_alarm_operate_psi'),
      didPreactionLowAirAlarmOperate: preactionDeluge.getValue('did_preaction_low_air_alarm_operate_psi'), // Duplicate field
      
      // Alarms
      doesWaterMotorGongWork: _answerToString(alarms.getAnswer('does_water_motor_gong_work')),
      doesElectricBellWork: _answerToString(alarms.getAnswer('does_electric_bell_work')),
      areWaterFlowAlarmsOperational: _answerToString(alarms.getAnswer('are_water_flow_alarms_operational')),
      areAllTamperSwitchesOperational: _answerToString(alarms.getAnswer('are_tamper_switches_operational')),
      didAlarmPanelClearAfterTest: _answerToString(alarms.getAnswer('did_alarm_panel_clear')),
      
      // Sprinklers/Piping
      areAMinimumOf6SpareSprinklersReadilyAvaiable: _answerToString(sprinklersPiping.getAnswer('are_6_spare_sprinklers_available')),
      isConditionOfPipingAndOtherSystemComponentsSatisfactory: _answerToString(sprinklersPiping.getAnswer('is_piping_condition_satisfactory')),
      areKnownDryTypeHeadsLessThan10YearsOld: sprinklersPiping.getValue('dry_type_heads_result'),
      areKnownDryTypeHeadsLessThan10YearsOldYear: sprinklersPiping.getValue('dry_type_heads_year'),
      areKnownQuickResponseHeadsLessThan20YearsOld: sprinklersPiping.getValue('quick_response_heads_result'),
      areKnownQuickResponseHeadsLessThan20YearsOldYear: sprinklersPiping.getValue('quick_response_heads_year'),
      areKnownStandardResponseHeadsLessThan50YearsOld: sprinklersPiping.getValue('standard_response_heads_result'),
      areKnownStandardResponseHeadsLessThan50YearsOldYear: sprinklersPiping.getValue('standard_response_heads_year'),
      haveAllGaugesBeenTestedOrReplacedInTheLast5Years: sprinklersPiping.getValue('gauges_result'),
      haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: sprinklersPiping.getValue('gauges_year'),
      
      // Main Drain Test (Systems 1-6)
      system1Name: mainDrainTest.systems.length > 0 ? mainDrainTest.systems[0].name : '',
      system1DrainSize: mainDrainTest.systems.length > 0 ? mainDrainTest.systems[0].drainSize : '',
      system1StaticPSI: mainDrainTest.systems.length > 0 ? mainDrainTest.systems[0].staticPSI : '',
      system1ResidualPSI: mainDrainTest.systems.length > 0 ? mainDrainTest.systems[0].residualPSI : '',
      system2Name: mainDrainTest.systems.length > 1 ? mainDrainTest.systems[1].name : '',
      system2DrainSize: mainDrainTest.systems.length > 1 ? mainDrainTest.systems[1].drainSize : '',
      system2StaticPSI: mainDrainTest.systems.length > 1 ? mainDrainTest.systems[1].staticPSI : '',
      system2ResidualPSI: mainDrainTest.systems.length > 1 ? mainDrainTest.systems[1].residualPSI : '',
      system3Name: mainDrainTest.systems.length > 2 ? mainDrainTest.systems[2].name : '',
      system3DrainSize: mainDrainTest.systems.length > 2 ? mainDrainTest.systems[2].drainSize : '',
      system3StaticPSI: mainDrainTest.systems.length > 2 ? mainDrainTest.systems[2].staticPSI : '',
      system3ResidualPSI: mainDrainTest.systems.length > 2 ? mainDrainTest.systems[2].residualPSI : '',
      system4Name: mainDrainTest.systems.length > 3 ? mainDrainTest.systems[3].name : '',
      system4DrainSize: mainDrainTest.systems.length > 3 ? mainDrainTest.systems[3].drainSize : '',
      system4StaticPSI: mainDrainTest.systems.length > 3 ? mainDrainTest.systems[3].staticPSI : '',
      system4ResidualPSI: mainDrainTest.systems.length > 3 ? mainDrainTest.systems[3].residualPSI : '',
      system5Name: mainDrainTest.systems.length > 4 ? mainDrainTest.systems[4].name : '',
      system5DrainSize: mainDrainTest.systems.length > 4 ? mainDrainTest.systems[4].drainSize : '',
      system5StaticPSI: mainDrainTest.systems.length > 4 ? mainDrainTest.systems[4].staticPSI : '',
      system5ResidualPSI: mainDrainTest.systems.length > 4 ? mainDrainTest.systems[4].residualPSI : '',
      system6Name: mainDrainTest.systems.length > 5 ? mainDrainTest.systems[5].name : '',
      system6DrainSize: mainDrainTest.systems.length > 5 ? mainDrainTest.systems[5].drainSize : '',
      system6StaticPSI: mainDrainTest.systems.length > 5 ? mainDrainTest.systems[5].staticPSI : '',
      system6ResidualPSI: mainDrainTest.systems.length > 5 ? mainDrainTest.systems[5].residualPSI : '',
      drainTestNotes: mainDrainTest.notes,
      
      // Device Tests (Devices 1-14)
      device1Name: deviceFields['device1Name']!,
      device1Address: deviceFields['device1Address']!,
      device1DescriptionLocation: deviceFields['device1DescriptionLocation']!,
      device1Operated: deviceFields['device1Operated']!,
      device1DelaySec: deviceFields['device1DelaySec']!,
      device2Name: deviceFields['device2Name']!,
      device2Address: deviceFields['device2Address']!,
      device2DescriptionLocation: deviceFields['device2DescriptionLocation']!,
      device2Operated: deviceFields['device2Operated']!,
      device2DelaySec: deviceFields['device2DelaySec']!,
      device3Name: deviceFields['device3Name']!,
      device3Address: deviceFields['device3Address']!,
      device3DescriptionLocation: deviceFields['device3DescriptionLocation']!,
      device3Operated: deviceFields['device3Operated']!,
      device3DelaySec: deviceFields['device3DelaySec']!,
      device4Name: deviceFields['device4Name']!,
      device4Address: deviceFields['device4Address']!,
      device4DescriptionLocation: deviceFields['device4DescriptionLocation']!,
      device4Operated: deviceFields['device4Operated']!,
      device4DelaySec: deviceFields['device4DelaySec']!,
      device5Name: deviceFields['device5Name']!,
      device5Address: deviceFields['device5Address']!,
      device5DescriptionLocation: deviceFields['device5DescriptionLocation']!,
      device5Operated: deviceFields['device5Operated']!,
      device5DelaySec: deviceFields['device5DelaySec']!,
      device6Name: deviceFields['device6Name']!,
      device6Address: deviceFields['device6Address']!,
      device6DescriptionLocation: deviceFields['device6DescriptionLocation']!,
      device6Operated: deviceFields['device6Operated']!,
      device6DelaySec: deviceFields['device6DelaySec']!,
      device7Name: deviceFields['device7Name']!,
      device7Address: deviceFields['device7Address']!,
      device7DescriptionLocation: deviceFields['device7DescriptionLocation']!,
      device7Operated: deviceFields['device7Operated']!,
      device7DelaySec: deviceFields['device7DelaySec']!,
      device8Name: deviceFields['device8Name']!,
      device8Address: deviceFields['device8Address']!,
      device8DescriptionLocation: deviceFields['device8DescriptionLocation']!,
      device8Operated: deviceFields['device8Operated']!,
      device8DelaySec: deviceFields['device8DelaySec']!,
      device9Name: deviceFields['device9Name']!,
      device9Address: deviceFields['device9Address']!,
      device9DescriptionLocation: deviceFields['device9DescriptionLocation']!,
      device9Operated: deviceFields['device9Operated']!,
      device9DelaySec: deviceFields['device9DelaySec']!,
      device10Name: deviceFields['device10Name']!,
      device10Address: deviceFields['device10Address']!,
      device10DescriptionLocation: deviceFields['device10DescriptionLocation']!,
      device10Operated: deviceFields['device10Operated']!,
      device10DelaySec: deviceFields['device10DelaySec']!,
      device11Name: deviceFields['device11Name']!,
      device11Address: deviceFields['device11Address']!,
      device11DescriptionLocation: deviceFields['device11DescriptionLocation']!,
      device11Operated: deviceFields['device11Operated']!,
      device11DelaySec: deviceFields['device11DelaySec']!,
      device12Name: deviceFields['device12Name']!,
      device12Address: deviceFields['device12Address']!,
      device12DescriptionLocation: deviceFields['device12DescriptionLocation']!,
      device12Operated: deviceFields['device12Operated']!,
      device12DelaySec: deviceFields['device12DelaySec']!,
      device13Name: deviceFields['device13Name']!,
      device13Address: deviceFields['device13Address']!,
      device13DescriptionLocation: deviceFields['device13DescriptionLocation']!,
      device13Operated: deviceFields['device13Operated']!,
      device13DelaySec: deviceFields['device13DelaySec']!,
      device14Name: deviceFields['device14Name']!,
      device14Address: deviceFields['device14Address']!,
      device14DescriptionLocation: deviceFields['device14DescriptionLocation']!,
      device14Operated: deviceFields['device14Operated']!,
      device14DelaySec: deviceFields['device14DelaySec']!,
      
      // Notes
      adjustmentsOrCorrectionsMake: notes.adjustments,
      explanationOfAnyNoAnswers: notes.explanation,
      explanationOfAnyNoAnswersContinued: notes.explanationContinued,
      notes: notes.notes,
    );
  }

  /// Convert dynamic device list to fixed device1-14 fields
  Map<String, String> _buildDeviceFields(List<dynamic> devices) {
    final fields = <String, String>{};
    
    // Initialize all 14 device fields with empty strings
    for (int i = 1; i <= 14; i++) {
      fields['device${i}Name'] = '';
      fields['device${i}Address'] = '';
      fields['device${i}DescriptionLocation'] = '';
      fields['device${i}Operated'] = '';
      fields['device${i}DelaySec'] = '';
    }
    
    // Fill in actual device data (up to 14 devices)
    for (int i = 0; i < devices.length && i < 14; i++) {
      final device = devices[i];
      final deviceNum = i + 1;
      fields['device${deviceNum}Name'] = device.name;
      fields['device${deviceNum}Address'] = device.address;
      fields['device${deviceNum}DescriptionLocation'] = device.descriptionLocation;
      fields['device${deviceNum}Operated'] = device.operated;
      fields['device${deviceNum}DelaySec'] = device.delaySec;
    }
    
    return fields;
  }

  /// Generate PDF path using the same format as final submissions
  String _generatePdfPath(String location, String locationCityState, {bool isDraft = false}) {
    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    
    // Extract city from locationCityState (format: "City, State")
    String cityName = 'Unknown';
    if (locationCityState.contains(',')) {
      cityName = locationCityState.split(',')[0].trim();
    }
    
    // Clean up location for use in path and filename
    final locationForPath = location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    
    final locationForFilename = location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_');
    
    // Add draft prefix if this is a draft
    final prefix = isDraft ? 'DRAFT_' : '';
    
    // Build path following the format: H:\Inspections - Maintenance\Files by town\{city}\{location}\Inspection Reports\{yyyy-mm-dd_location}.pdf
    return 'H:\\Inspections - Maintenance\\Files by town\\$cityName\\$locationForPath\\Inspection Reports\\$prefix${dateStr}_$locationForFilename.pdf';
  }

  /// Save inspection as draft to local database
  Future<bool> saveDraft() async {
    try {
      final inspectionForm = buildInspectionForm();
      
      // Validate required fields
      if (inspectionForm.location.isEmpty) {
        if (kDebugMode) {
          print('Error: Location is required');
        }
        return false;
      }
      
      if (inspectionForm.locationCityState.isEmpty) {
        if (kDebugMode) {
          print('Error: City is required');
        }
        return false;
      }
      
      // Generate PDF path using proper format with DRAFT prefix
      final pdfPath = _generatePdfPath(
        inspectionForm.location,
        inspectionForm.locationCityState,
        isDraft: true,
      );
      
      // Create form with generated PDF path
      final formWithPath = InspectionForm(
        pdfPath: pdfPath,
        billTo: inspectionForm.billTo,
        location: inspectionForm.location,
        billToLn2: inspectionForm.billToLn2,
        locationLn2: inspectionForm.locationLn2,
        attention: inspectionForm.attention,
        billingStreet: inspectionForm.billingStreet,
        billingStreetLn2: inspectionForm.billingStreetLn2,
        locationStreet: inspectionForm.locationStreet,
        locationStreetLn2: inspectionForm.locationStreetLn2,
        billingCityState: inspectionForm.billingCityState,
        billingCityStateLn2: inspectionForm.billingCityStateLn2,
        locationCityState: inspectionForm.locationCityState,
        locationCityStateLn2: inspectionForm.locationCityStateLn2,
        contact: inspectionForm.contact,
        date: inspectionForm.date,
        phone: inspectionForm.phone,
        inspector: inspectionForm.inspector,
        email: inspectionForm.email,
        inspectionFrequency: inspectionForm.inspectionFrequency,
        inspectionNumber: inspectionForm.inspectionNumber,
        isTheBuildingOccupied: inspectionForm.isTheBuildingOccupied,
        areAllSystemsInService: inspectionForm.areAllSystemsInService,
        areFpSystemsSameAsLastInspection: inspectionForm.areFpSystemsSameAsLastInspection,
        hydraulicNameplateSecurelyAttachedAndLegible: inspectionForm.hydraulicNameplateSecurelyAttachedAndLegible,
        wasAMainDrainWaterFlowTestConducted: inspectionForm.wasAMainDrainWaterFlowTestConducted,
        areAllSprinklerSystemMainControlValvesOpen: inspectionForm.areAllSprinklerSystemMainControlValvesOpen,
        areAllOtherValvesInProperPosition: inspectionForm.areAllOtherValvesInProperPosition,
        areAllControlValvesSealedOrSupervised: inspectionForm.areAllControlValvesSealedOrSupervised,
        areAllControlValvesInGoodConditionAndFreeOfLeaks: inspectionForm.areAllControlValvesInGoodConditionAndFreeOfLeaks,
        areFireDepartmentConnectionsInSatisfactoryCondition: inspectionForm.areFireDepartmentConnectionsInSatisfactoryCondition,
        areCapsInPlace: inspectionForm.areCapsInPlace,
        isFireDepartmentConnectionEasilyAccessible: inspectionForm.isFireDepartmentConnectionEasilyAccessible,
        automaticDrainValeInPlace: inspectionForm.automaticDrainValeInPlace,
        isThePumpRoomHeated: inspectionForm.isThePumpRoomHeated,
        isTheFirePumpInService: inspectionForm.isTheFirePumpInService,
        wasFirePumpRunDuringThisInspection: inspectionForm.wasFirePumpRunDuringThisInspection,
        wasThePumpStartedInTheAutomaticModeByAPressureDrop: inspectionForm.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
        wereThePumpBearingsLubricated: inspectionForm.wereThePumpBearingsLubricated,
        jockeyPumpStartPressurePSI: inspectionForm.jockeyPumpStartPressurePSI,
        jockeyPumpStartPressure: inspectionForm.jockeyPumpStartPressure,
        jockeyPumpStopPressurePSI: inspectionForm.jockeyPumpStopPressurePSI,
        jockeyPumpStopPressure: inspectionForm.jockeyPumpStopPressure,
        firePumpStartPressurePSI: inspectionForm.firePumpStartPressurePSI,
        firePumpStartPressure: inspectionForm.firePumpStartPressure,
        firePumpStopPressurePSI: inspectionForm.firePumpStopPressurePSI,
        firePumpStopPressure: inspectionForm.firePumpStopPressure,
        isTheFuelTankAtLeast2_3Full: inspectionForm.isTheFuelTankAtLeast2_3Full,
        isEngineOilAtCorrectLevel: inspectionForm.isEngineOilAtCorrectLevel,
        isEngineCoolantAtCorrectLevel: inspectionForm.isEngineCoolantAtCorrectLevel,
        isTheEngineBlockHeaterWorking: inspectionForm.isTheEngineBlockHeaterWorking,
        isPumpRoomVentilationOperatingProperly: inspectionForm.isPumpRoomVentilationOperatingProperly,
        wasWaterDischargeObservedFromHeatExchangerReturnLine: inspectionForm.wasWaterDischargeObservedFromHeatExchangerReturnLine,
        wasCoolingLineStrainerCleanedAfterTest: inspectionForm.wasCoolingLineStrainerCleanedAfterTest,
        wasPumpRunForAtLeast30Minutes: inspectionForm.wasPumpRunForAtLeast30Minutes,
        doesTheSwitchInAutoAlarmWork: inspectionForm.doesTheSwitchInAutoAlarmWork,
        doesThePumpRunningAlarmWork: inspectionForm.doesThePumpRunningAlarmWork,
        doesTheCommonAlarmWork: inspectionForm.doesTheCommonAlarmWork,
        wasCasingReliefValveOperatingProperly: inspectionForm.wasCasingReliefValveOperatingProperly,
        wasPumpRunForAtLeast10Minutes: inspectionForm.wasPumpRunForAtLeast10Minutes,
        doesTheLossOfPowerAlarmWork: inspectionForm.doesTheLossOfPowerAlarmWork,
        doesTheElectricPumpRunningAlarmWork: inspectionForm.doesTheElectricPumpRunningAlarmWork,
        powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad: inspectionForm.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
        trasferOfPowerToAlternativePowerSourceVerified: inspectionForm.trasferOfPowerToAlternativePowerSourceVerified,
        powerFaulureConditionRemoved: inspectionForm.powerFaulureConditionRemoved,
        pumpReconnectedToNormalPowerSourceAfterATimeDelay: inspectionForm.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
        haveAntiFreezeSystemsBeenTested: inspectionForm.haveAntiFreezeSystemsBeenTested,
        freezeProtectionInDegreesF: inspectionForm.freezeProtectionInDegreesF,
        areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition: inspectionForm.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
        waterFlowAlarmTestConductedWithInspectorsTest: inspectionForm.waterFlowAlarmTestConductedWithInspectorsTest,
        waterFlowAlarmTestConductedWithBypassConnection: inspectionForm.waterFlowAlarmTestConductedWithBypassConnection,
        isDryValveInServiceAndInGoodCondition: inspectionForm.isDryValveInServiceAndInGoodCondition,
        isDryValveItermediateChamberNotLeaking: inspectionForm.isDryValveItermediateChamberNotLeaking,
        hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears: inspectionForm.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
        areQuickOpeningDeviceControlValvesOpen: inspectionForm.areQuickOpeningDeviceControlValvesOpen,
        isThereAListOfKnownLowPointDrainsAtTheRiser: inspectionForm.isThereAListOfKnownLowPointDrainsAtTheRiser,
        haveKnownLowPointsBeenDrained: inspectionForm.haveKnownLowPointsBeenDrained,
        isOilLevelFullOnAirCompressor: inspectionForm.isOilLevelFullOnAirCompressor,
        doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder: inspectionForm.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
        whatPressureDoesAirCompressorStartPSI: inspectionForm.whatPressureDoesAirCompressorStartPSI,
        whatPressureDoesAirCompressorStart: inspectionForm.whatPressureDoesAirCompressorStart,
        whatPressureDoesAirCompressorStopPSI: inspectionForm.whatPressureDoesAirCompressorStopPSI,
        whatPressureDoesAirCompressorStop: inspectionForm.whatPressureDoesAirCompressorStop,
        didLowAirAlarmOperatePSI: inspectionForm.didLowAirAlarmOperatePSI,
        didLowAirAlarmOperate: inspectionForm.didLowAirAlarmOperate,
        dateOfLastFullTripTest: inspectionForm.dateOfLastFullTripTest,
        dateOfLastInternalInspection: inspectionForm.dateOfLastInternalInspection,
        areValvesInServiceAndInGoodCondition: inspectionForm.areValvesInServiceAndInGoodCondition,
        wereValvesTripped: inspectionForm.wereValvesTripped,
        whatPressureDidPneumaticActuatorTripPSI: inspectionForm.whatPressureDidPneumaticActuatorTripPSI,
        whatPressureDidPneumaticActuatorTrip: inspectionForm.whatPressureDidPneumaticActuatorTrip,
        wasPrimingLineLeftOnAfterTest: inspectionForm.wasPrimingLineLeftOnAfterTest,
        whatPressureDoesPreactionAirCompressorStartPSI: inspectionForm.whatPressureDoesPreactionAirCompressorStartPSI,
        whatPressureDoesPreactionAirCompressorStart: inspectionForm.whatPressureDoesPreactionAirCompressorStart,
        whatPressureDoesPreactionAirCompressorStopPSI: inspectionForm.whatPressureDoesPreactionAirCompressorStopPSI,
        whatPressureDoesPreactionAirCompressorStop: inspectionForm.whatPressureDoesPreactionAirCompressorStop,
        didPreactionLowAirAlarmOperatePSI: inspectionForm.didPreactionLowAirAlarmOperatePSI,
        didPreactionLowAirAlarmOperate: inspectionForm.didPreactionLowAirAlarmOperate,
        doesWaterMotorGongWork: inspectionForm.doesWaterMotorGongWork,
        doesElectricBellWork: inspectionForm.doesElectricBellWork,
        areWaterFlowAlarmsOperational: inspectionForm.areWaterFlowAlarmsOperational,
        areAllTamperSwitchesOperational: inspectionForm.areAllTamperSwitchesOperational,
        didAlarmPanelClearAfterTest: inspectionForm.didAlarmPanelClearAfterTest,
        areAMinimumOf6SpareSprinklersReadilyAvaiable: inspectionForm.areAMinimumOf6SpareSprinklersReadilyAvaiable,
        isConditionOfPipingAndOtherSystemComponentsSatisfactory: inspectionForm.isConditionOfPipingAndOtherSystemComponentsSatisfactory,
        areKnownDryTypeHeadsLessThan10YearsOld: inspectionForm.areKnownDryTypeHeadsLessThan10YearsOld,
        areKnownDryTypeHeadsLessThan10YearsOldYear: inspectionForm.areKnownDryTypeHeadsLessThan10YearsOldYear,
        areKnownQuickResponseHeadsLessThan20YearsOld: inspectionForm.areKnownQuickResponseHeadsLessThan20YearsOld,
        areKnownQuickResponseHeadsLessThan20YearsOldYear: inspectionForm.areKnownQuickResponseHeadsLessThan20YearsOldYear,
        areKnownStandardResponseHeadsLessThan50YearsOld: inspectionForm.areKnownStandardResponseHeadsLessThan50YearsOld,
        areKnownStandardResponseHeadsLessThan50YearsOldYear: inspectionForm.areKnownStandardResponseHeadsLessThan50YearsOldYear,
        haveAllGaugesBeenTestedOrReplacedInTheLast5Years: inspectionForm.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
        haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: inspectionForm.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
        system1Name: inspectionForm.system1Name,
        system1DrainSize: inspectionForm.system1DrainSize,
        system1StaticPSI: inspectionForm.system1StaticPSI,
        system1ResidualPSI: inspectionForm.system1ResidualPSI,
        system2Name: inspectionForm.system2Name,
        system2DrainSize: inspectionForm.system2DrainSize,
        system2StaticPSI: inspectionForm.system2StaticPSI,
        system2ResidualPSI: inspectionForm.system2ResidualPSI,
        system3Name: inspectionForm.system3Name,
        system3DrainSize: inspectionForm.system3DrainSize,
        system3StaticPSI: inspectionForm.system3StaticPSI,
        system3ResidualPSI: inspectionForm.system3ResidualPSI,
        system4Name: inspectionForm.system4Name,
        system4DrainSize: inspectionForm.system4DrainSize,
        system4StaticPSI: inspectionForm.system4StaticPSI,
        system4ResidualPSI: inspectionForm.system4ResidualPSI,
        system5Name: inspectionForm.system5Name,
        system5DrainSize: inspectionForm.system5DrainSize,
        system5StaticPSI: inspectionForm.system5StaticPSI,
        system5ResidualPSI: inspectionForm.system5ResidualPSI,
        system6Name: inspectionForm.system6Name,
        system6DrainSize: inspectionForm.system6DrainSize,
        system6StaticPSI: inspectionForm.system6StaticPSI,
        system6ResidualPSI: inspectionForm.system6ResidualPSI,
        drainTestNotes: inspectionForm.drainTestNotes,
        device1Name: inspectionForm.device1Name,
        device1Address: inspectionForm.device1Address,
        device1DescriptionLocation: inspectionForm.device1DescriptionLocation,
        device1Operated: inspectionForm.device1Operated,
        device1DelaySec: inspectionForm.device1DelaySec,
        device2Name: inspectionForm.device2Name,
        device2Address: inspectionForm.device2Address,
        device2DescriptionLocation: inspectionForm.device2DescriptionLocation,
        device2Operated: inspectionForm.device2Operated,
        device2DelaySec: inspectionForm.device2DelaySec,
        device3Name: inspectionForm.device3Name,
        device3Address: inspectionForm.device3Address,
        device3DescriptionLocation: inspectionForm.device3DescriptionLocation,
        device3Operated: inspectionForm.device3Operated,
        device3DelaySec: inspectionForm.device3DelaySec,
        device4Name: inspectionForm.device4Name,
        device4Address: inspectionForm.device4Address,
        device4DescriptionLocation: inspectionForm.device4DescriptionLocation,
        device4Operated: inspectionForm.device4Operated,
        device4DelaySec: inspectionForm.device4DelaySec,
        device5Name: inspectionForm.device5Name,
        device5Address: inspectionForm.device5Address,
        device5DescriptionLocation: inspectionForm.device5DescriptionLocation,
        device5Operated: inspectionForm.device5Operated,
        device5DelaySec: inspectionForm.device5DelaySec,
        device6Name: inspectionForm.device6Name,
        device6Address: inspectionForm.device6Address,
        device6DescriptionLocation: inspectionForm.device6DescriptionLocation,
        device6Operated: inspectionForm.device6Operated,
        device6DelaySec: inspectionForm.device6DelaySec,
        device7Name: inspectionForm.device7Name,
        device7Address: inspectionForm.device7Address,
        device7DescriptionLocation: inspectionForm.device7DescriptionLocation,
        device7Operated: inspectionForm.device7Operated,
        device7DelaySec: inspectionForm.device7DelaySec,
        device8Name: inspectionForm.device8Name,
        device8Address: inspectionForm.device8Address,
        device8DescriptionLocation: inspectionForm.device8DescriptionLocation,
        device8Operated: inspectionForm.device8Operated,
        device8DelaySec: inspectionForm.device8DelaySec,
        device9Name: inspectionForm.device9Name,
        device9Address: inspectionForm.device9Address,
        device9DescriptionLocation: inspectionForm.device9DescriptionLocation,
        device9Operated: inspectionForm.device9Operated,
        device9DelaySec: inspectionForm.device9DelaySec,
        device10Name: inspectionForm.device10Name,
        device10Address: inspectionForm.device10Address,
        device10DescriptionLocation: inspectionForm.device10DescriptionLocation,
        device10Operated: inspectionForm.device10Operated,
        device10DelaySec: inspectionForm.device10DelaySec,
        device11Name: inspectionForm.device11Name,
        device11Address: inspectionForm.device11Address,
        device11DescriptionLocation: inspectionForm.device11DescriptionLocation,
        device11Operated: inspectionForm.device11Operated,
        device11DelaySec: inspectionForm.device11DelaySec,
        device12Name: inspectionForm.device12Name,
        device12Address: inspectionForm.device12Address,
        device12DescriptionLocation: inspectionForm.device12DescriptionLocation,
        device12Operated: inspectionForm.device12Operated,
        device12DelaySec: inspectionForm.device12DelaySec,
        device13Name: inspectionForm.device13Name,
        device13Address: inspectionForm.device13Address,
        device13DescriptionLocation: inspectionForm.device13DescriptionLocation,
        device13Operated: inspectionForm.device13Operated,
        device13DelaySec: inspectionForm.device13DelaySec,
        device14Name: inspectionForm.device14Name,
        device14Address: inspectionForm.device14Address,
        device14DescriptionLocation: inspectionForm.device14DescriptionLocation,
        device14Operated: inspectionForm.device14Operated,
        device14DelaySec: inspectionForm.device14DelaySec,
        adjustmentsOrCorrectionsMake: inspectionForm.adjustmentsOrCorrectionsMake,
        explanationOfAnyNoAnswers: inspectionForm.explanationOfAnyNoAnswers,
        explanationOfAnyNoAnswersContinued: inspectionForm.explanationOfAnyNoAnswersContinued,
        notes: inspectionForm.notes,
      );
      
      final inspectionData = InspectionData(formWithPath);
      
      final dbHelper = DatabaseHelper();
      await dbHelper.saveInspections([inspectionData]);
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving draft: $e');
      }
      return false;
    }
  }

  /// Submit inspection (save locally and attempt sync to API)
  Future<bool> submitInspection({
    Future<bool> Function()? isOnlineCheck,
  }) async {
    try {
      final inspectionForm = buildInspectionForm();
      final inspectionData = InspectionData(inspectionForm);
      
      final creationService = InspectionCreationService();
      final success = await creationService.createInspection(
        inspectionData,
        attemptSync: true,
        isOnlineCheck: isOnlineCheck,
      );
      
      if (kDebugMode) {
        print('Submit inspection result: $success');
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting inspection: $e');
      }
      return false;
    }
  }
}
