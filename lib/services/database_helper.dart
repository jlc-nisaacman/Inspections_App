// lib/services/database_helper.dart - COMPLETE DEBUG VERSION

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/inspection_data.dart';
import '../models/backflow_data.dart';
import '../models/pump_system_data.dart';
import '../models/dry_system_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async {
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  String path = join(await getDatabasesPath(), 'jlc_inspection.db');
  return await openDatabase(
    path,
    version: 3,
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}

  Future<void> _onCreate(Database db, int version) async {
    // Create inspections table with pdf_path as primary key + last_modified tracking
    await db.execute('''
      CREATE TABLE inspections(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create backflow table with pdf_path as primary key + last_modified tracking
    await db.execute('''
      CREATE TABLE backflow(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create pump_systems table with pdf_path as primary key + last_modified tracking
    await db.execute('''
      CREATE TABLE pump_systems(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create dry_systems table with pdf_path as primary key + last_modified tracking
    await db.execute('''
      CREATE TABLE dry_systems(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create sync_metadata table to track last sync times
    await db.execute('''
      CREATE TABLE sync_metadata(
        table_name TEXT PRIMARY KEY,
        last_sync INTEGER NOT NULL
      )
    ''');

    // Initialize sync metadata
    await db.insert('sync_metadata', {'table_name': 'inspections', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'backflow', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'pump_systems', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'dry_systems', 'last_sync': 0});
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migrate from old schema to new schema with pdf_path as primary key
      await _migrateToV2(db);
    }
    if (oldVersion < 3) {
      // Add last_modified column for change tracking
      await _addLastModifiedColumn(db);
    }
  }

  Future<void> _addLastModifiedColumn(Database db) async {
    try {
      await db.execute('ALTER TABLE inspections ADD COLUMN last_modified TEXT');
      await db.execute('ALTER TABLE backflow ADD COLUMN last_modified TEXT');
      await db.execute('ALTER TABLE pump_systems ADD COLUMN last_modified TEXT');
      await db.execute('ALTER TABLE dry_systems ADD COLUMN last_modified TEXT');
    } catch (e) {
      // Column might already exist, ignore error
      if (kDebugMode) {
        print('Error adding last_modified column (might already exist): $e');
      }
    }
  }

  Future<void> _migrateToV2(Database db) async {
    // Create new tables with correct schema
    await db.execute('''
      CREATE TABLE inspections_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE backflow_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pump_systems_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE dry_systems_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        last_modified TEXT,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Migrate data from old tables to new tables (extracting pdf_path and date from JSON)
    await _migrateTableData(db, 'inspections', 'inspections_new');
    await _migrateTableData(db, 'backflow', 'backflow_new');
    await _migrateTableData(db, 'pump_systems', 'pump_systems_new');
    await _migrateTableData(db, 'dry_systems', 'dry_systems_new');

    // Drop old tables
    await db.execute('DROP TABLE IF EXISTS inspections');
    await db.execute('DROP TABLE IF EXISTS backflow');
    await db.execute('DROP TABLE IF EXISTS pump_systems');
    await db.execute('DROP TABLE IF EXISTS dry_systems');

    // Rename new tables
    await db.execute('ALTER TABLE inspections_new RENAME TO inspections');
    await db.execute('ALTER TABLE backflow_new RENAME TO backflow');
    await db.execute('ALTER TABLE pump_systems_new RENAME TO pump_systems');
    await db.execute('ALTER TABLE dry_systems_new RENAME TO dry_systems');
  }

  Future<void> _migrateTableData(Database db, String oldTable, String newTable) async {
    try {
      // Get all records from old table
      final List<Map<String, dynamic>> oldRecords = await db.query(oldTable);
      
      for (final record in oldRecords) {
        try {
          final formData = jsonDecode(record['form_data'] as String);
          final pdfPath = formData['pdf_path'] as String? ?? '';
          final date = formData['date'] as String? ?? '';
          
          // Only migrate records that have a valid pdf_path
          if (pdfPath.isNotEmpty) {
            await db.insert(
              newTable,
              {
                'pdf_path': pdfPath,
                'form_data': record['form_data'],
                'last_updated': record['last_updated'],
                'last_modified': null, // Will be null for migrated records
                'searchable_text': record['searchable_text'],
                'date': date,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        } catch (e) {
          // Skip records that can't be parsed or don't have pdf_path
          if (kDebugMode) {
            print('Skipping record migration due to error: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error migrating table $oldTable: $e');
      }
    }
  }

  // Helper methods to convert forms to JSON since they don't have toJson methods
Map<String, dynamic> _inspectionFormToJson(InspectionData inspection) {
  final form = inspection.form;
  return {
    // Basic Info
    'pdf_path': form.pdfPath,
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
    
    // Checklist Questions (These are the "YES" values showing as "N/A")
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
    
    // Pump Pressures
    'jockey_pump_start_pressure_psi': form.jockeyPumpStartPressurePSI,
    'jockey_pump_start_pressure': form.jockeyPumpStartPressure,
    'jockey_pump_stop_pressure_psi': form.jockeyPumpStopPressurePSI,
    'jockey_pump_stop_pressure': form.jockeyPumpStopPressure,
    'fire_pump_start_pressure_psi': form.firePumpStartPressurePSI,
    'fire_pump_start_pressure': form.firePumpStartPressure,
    'fire_pump_stop_pressure_psi': form.firePumpStopPressurePSI,
    'fire_pump_stop_pressure': form.firePumpStopPressure,
    
    // Engine Questions
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
    
    // More Questions
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
    
    // Air Compressor
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
    
    // Systems 1-6
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
    
    // ALL Devices 1-14 (This was the missing part!)
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
    
    // Final Fields
    'adjustments_or_corrections_make': form.adjustmentsOrCorrectionsMake,
    'explanation_of_any_no_answers': form.explanationOfAnyNoAnswers,
    'explanation_of_any_no_answers_continued': form.explanationOfAnyNoAnswersContinued,
    'notes': form.notes,
  };
}

Map<String, dynamic> _backflowFormToJson(BackflowData backflow) {
  final form = backflow.form;
  return {
    // Basic Info
    'pdf_path': form.pdfPath,
    'owner_of_property': form.ownerOfProperty,
    'date': form.date,
    'mailing_address': form.mailingAddress,
    'tested_by': form.testedBy,
    'certificate_number': form.certificateNumber,
    'contact_person': form.contactPerson,
    'backflow_type': form.backflowType,
    'backflow_make': form.backflowMake,
    'backflow_model': form.backflowModel,
    'backflow_size': form.backflowSize,
    'backflow_serial_number': form.backflowSerialNumber,
    'test_type': form.testType,
    'device_location': form.deviceLocation,
    
    // RPZ Test Results
    'rpz_check_valve_1_closed_tight': form.rpzCheckValve1ClosedTight,
    'rpz_check_valve_1_leaked': form.rpzCheckValve1Leaked,
    'rpz_check_valve_1_psid': form.rpzCheckValve1PSID,
    'rpz_check_valve_2_closed_tight': form.rpzCheckValve2ClosedTight,
    'rpz_check_valve_flow': form.rpzCheckValveFlow,
    'rpz_check_valve_no_flow': form.rpzCheckValveNoFlow,
    'rpz_relief_valve_opened_at_psid': form.rpzReliefValveOpenedAtPSID,
    'rpz_check_valve_2_psid': form.rpzCheckValve2PSID,
    'rpz_check_valve_2_leaked': form.rpzCheckValve2Leaked,
    'rpz_relief_valve_did_not_open': form.rpzReliefValveDidNotOpen,
    
    // PVB/SRVB Test Results
    'pvb_srvb_check_valve_flow': form.pvbSrvbCheckValveFlow,
    'pvb_srvb_check_valve_psid': form.pvbSrvbCheckValvePSID,
    'pvb_srvb_air_inlet_valve_opened_at_psid': form.pvbSrvbAirInletValveOpenedAtPSID,
    'pvb_srvb_air_inlet_valve_did_not_open': form.pvbSrvbAirInletValveDidNotOpen,
    
    // DCVA Test Results
    'dcva_back_pressure_test_1_psi': form.dcvaBackPressureTest1PSI,
    'dcva_back_pressure_test_4_psi': form.dcvaBackPressureTest4PSI,
    'dcva_check_valve_1_psid': form.dcvaCheckValve1PSID,
    'dcva_check_valve_2_psid': form.dcvaCheckValve2PSID,
    'dcva_flow': form.dcvaFlow,
    'dcva_no_flow': form.dcvaNoFlow,
    
    // Additional Fields
    'downsteam_shutoff_valve_status': form.downstreamShutoffValveStatus,
    'protection_type': form.protectionType,
    'result': form.result,
    'remarks_1': form.remarks1,
    'remarks_2': form.remarks2,
    'remarks_3': form.remarks3,
    'witness': form.witness,
  };
}

Map<String, dynamic> _pumpSystemFormToJson(PumpSystemData pumpSystem) {
  final form = pumpSystem.form;
  return {
    // Basic Info
    'pdf_path': form.pdfPath,
    'report_to': form.reportTo,
    'building': form.building,
    'attention': form.attention,
    'street': form.street,
    'inspector': form.inspector,
    'city_state': form.cityState,
    'date': form.date,
    
    // Pump Info
    'pump_make': form.pumpMake,
    'pump_model': form.pumpModel,
    'pump_serial_number': form.pumpSerialNumber,
    'pump_rated_rpm': form.pumpRatedRPM,
    'pump_rated_gpm': form.pumpRatedGPM,
    'pump_max_psi': form.pumpMaxPSI,
    'pump_power': form.pumpPower,
    'pump_rated_psi': form.pumpRatedPSI,
    'pump_water_supply': form.pumpWaterSupply,
    'pump_psi_at_150_percent': form.pumpPSIAt150Percent,
    
    // Controller Info
    'pump_controller_make': form.pumpControllerMake,
    'pump_controller_voltage': form.pumpControllerVoltage,
    'pump_controller_model': form.pumpControllerModel,
    'pump_controller_horse_power': form.pumpControllerHorsePower,
    'pump_controller_serial_number': form.pumpControllerSerialNumber,
    'pump_controller_supervision': form.pumpControllerSupervision,
    
    // Diesel Engine Info
    'diesel_engine_make': form.dieselEngineMake,
    'diesel_engine_serial_number': form.dieselEngineSerialNumber,
    'diesel_engine_model': form.dieselEngineModel,
    'diesel_engine_hours': form.dieselEngineHours,
    
    // Flow Test Orifice Sizes
    'flow_test_orifice_size_1': form.flowTestOrificeSize1,
    'flow_test_orifice_size_2': form.flowTestOrificeSize2,
    'flow_test_orifice_size_3': form.flowTestOrificeSize3,
    'flow_test_orifice_size_4': form.flowTestOrificeSize4,
    'flow_test_orifice_size_5': form.flowTestOrificeSize5,
    'flow_test_orifice_size_6': form.flowTestOrificeSize6,
    'flow_test_orifice_size_7': form.flowTestOrificeSize7,
    
    // Flow Test 1 - Complete
    'flow_test_1_suction_psi': form.flowTest1SuctionPSI,
    'flow_test_1_discharge_psi': form.flowTest1DischargePSI,
    'flow_test_1_net_psi': form.flowTest1NetPSI,
    'flow_test_1_rpm': form.flowTest1RPM,
    'flow_test_1_o1_pitot': form.flowTest1O1Pitot,
    'flow_test_1_o2_pitot': form.flowTest1O2Pitot,
    'flow_test_1_o3_pitot': form.flowTest1O3Pitot,
    'flow_test_1_o4_pitot': form.flowTest1O4Pitot,
    'flow_test_1_o5_pitot': form.flowTest1O5Pitot,
    'flow_test_1_o6_pitot': form.flowTest1O6Pitot,
    'flow_test_1_o7_pitot': form.flowTest1O7Pitot,
    'flow_test_1_o1_gpm': form.flowTest1O1GPM,
    'flow_test_1_o2_gpm': form.flowTest1O2GPM,
    'flow_test_1_o3_gpm': form.flowTest1O3GPM,
    'flow_test_1_o4_gpm': form.flowTest1O4GPM,
    'flow_test_1_o5_gpm': form.flowTest1O5GPM,
    'flow_test_1_o6_gpm': form.flowTest1O6GPM,
    'flow_test_1_o7_gpm': form.flowTest1O7GPM,
    'flow_test_1_total_flow': form.flowTest1TotalFlow,
    
    // Flow Test 2 - Complete
    'flow_test_2_suction_psi': form.flowTest2SuctionPSI,
    'flow_test_2_discharge_psi': form.flowTest2DischargePSI,
    'flow_test_2_net_psi': form.flowTest2NetPSI,
    'flow_test_2_rpm': form.flowTest2RPM,
    'flow_test_2_o1_pitot': form.flowTest2O1Pitot,
    'flow_test_2_o2_pitot': form.flowTest2O2Pitot,
    'flow_test_2_o3_pitot': form.flowTest2O3Pitot,
    'flow_test_2_o4_pitot': form.flowTest2O4Pitot,
    'flow_test_2_o5_pitot': form.flowTest2O5Pitot,
    'flow_test_2_o6_pitot': form.flowTest2O6Pitot,
    'flow_test_2_o7_pitot': form.flowTest2O7Pitot,
    'flow_test_2_o1_gpm': form.flowTest2O1GPM,
    'flow_test_2_o2_gpm': form.flowTest2O2GPM,
    'flow_test_2_o3_gpm': form.flowTest2O3GPM,
    'flow_test_2_o4_gpm': form.flowTest2O4GPM,
    'flow_test_2_o5_gpm': form.flowTest2O5GPM,
    'flow_test_2_o6_gpm': form.flowTest2O6GPM,
    'flow_test_2_o7_gpm': form.flowTest2O7GPM,
    'flow_test_2_total_flow': form.flowTest2TotalFlow,
    
    // Flow Test 3 - Complete
    'flow_test_3_suction_psi': form.flowTest3SuctionPSI,
    'flow_test_3_discharge_psi': form.flowTest3DischargePSI,
    'flow_test_3_net_psi': form.flowTest3NetPSI,
    'flow_test_3_rpm': form.flowTest3RPM,
    'flow_test_3_o1_pitot': form.flowTest3O1Pitot,
    'flow_test_3_o2_pitot': form.flowTest3O2Pitot,
    'flow_test_3_o3_pitot': form.flowTest3O3Pitot,
    'flow_test_3_o4_pitot': form.flowTest3O4Pitot,
    'flow_test_3_o5_pitot': form.flowTest3O5Pitot,
    'flow_test_3_o6_pitot': form.flowTest3O6Pitot,
    'flow_test_3_o7_pitot': form.flowTest3O7Pitot,
    'flow_test_3_o1_gpm': form.flowTest3O1GPM,
    'flow_test_3_o2_gpm': form.flowTest3O2GPM,
    'flow_test_3_o3_gpm': form.flowTest3O3GPM,
    'flow_test_3_o4_gpm': form.flowTest3O4GPM,
    'flow_test_3_o5_gpm': form.flowTest3O5GPM,
    'flow_test_3_o6_gpm': form.flowTest3O6GPM,
    'flow_test_3_o7_gpm': form.flowTest3O7GPM,
    'flow_test_3_total_flow': form.flowTest3TotalFlow,
    
    // Flow Test 4 - Complete
    'flow_test_4_suction_psi': form.flowTest4SuctionPSI,
    'flow_test_4_discharge_psi': form.flowTest4DischargePSI,
    'flow_test_4_net_psi': form.flowTest4NetPSI,
    'flow_test_4_rpm': form.flowTest4RPM,
    'flow_test_4_o1_pitot': form.flowTest4O1Pitot,
    'flow_test_4_o2_pitot': form.flowTest4O2Pitot,
    'flow_test_4_o3_pitot': form.flowTest4O3Pitot,
    'flow_test_4_o4_pitot': form.flowTest4O4Pitot,
    'flow_test_4_o5_pitot': form.flowTest4O5Pitot,
    'flow_test_4_o6_pitot': form.flowTest4O6Pitot,
    'flow_test_4_o7_pitot': form.flowTest4O7Pitot,
    'flow_test_4_o1_gpm': form.flowTest4O1GPM,
    'flow_test_4_o2_gpm': form.flowTest4O2GPM,
    'flow_test_4_o3_gpm': form.flowTest4O3GPM,
    'flow_test_4_o4_gpm': form.flowTest4O4GPM,
    'flow_test_4_o5_gpm': form.flowTest4O5GPM,
    'flow_test_4_o6_gpm': form.flowTest4O6GPM,
    'flow_test_4_o7_gpm': form.flowTest4O7GPM,
    'flow_test_4_total_flow': form.flowTest4TotalFlow,
    
    // Remarks
    'remarks_on_test': form.remarksOnTest,
  };
}

Map<String, dynamic> _drySystemFormToJson(DrySystemData drySystem) {
  final form = drySystem.form;
  return {
    // Basic Info
    'pdf_path': form.pdfPath,
    'report_to': form.reportTo,
    'building': form.building,
    'report_to_2': form.reportTo2,
    'building_2': form.building2,
    'attention': form.attention,
    'street': form.street,
    'inspector': form.inspector,
    'city_state': form.cityState,
    'date': form.date,
    
    // Dry Pipe Valve Info
    'dry_pipe_valve_make': form.dryPipeValveMake,
    'dry_pipe_valve_model': form.dryPipeValveModel,
    'dry_pipe_valve_size': form.dryPipeValveSize,
    'dry_pipe_valve_year': form.dryPipeValveYear,
    'dry_pipe_valve_controls_sprinklers_in': form.dryPipeValveControlsSprinklersIn,
    
    // Quick Opening Device Info
    'quick_opening_device_make': form.quickOpeningDeviceMake,
    'quick_opening_device_model': form.quickOpeningDeviceModel,
    'quick_opening_device_control_valve_open': form.quickOpeningDeviceControlValveOpen,
    'quick_opening_device_year': form.quickOpeningDeviceYear,
    
    // Trip Test Results
    'trip_test_air_pressure_before_test': form.tripTestAirPressureBeforeTest,
    'trip_test_air_system_tripped_at': form.tripTestAirSystemTrippedAt,
    'trip_test_water_pressure_before_test': form.tripTestWaterPressureBeforeTest,
    'trip_test_time': form.tripTestTime,
    'trip_test_air_quick_opening_device_operated_at': form.tripTestAirQuickOpeningDeviceOperatedAt,
    'trip_test_time_quick_opening_device_operated_at': form.tripTestTimeQuickOpeningDeviceOperatedAt,
    'trip_test_time_water_at_inspectors_test': form.tripTestTimeWaterAtInspectorsTest,
    'trip_test_static_water_pressure': form.tripTestStaticWaterPressure,
    'trip_test_residual_water_pressure': form.tripTestResidualWaterPressure,
    
    // Remarks
    'remarks_on_test': form.remarksOnTest,
    
    // Note: May need additional fields based on actual PostgreSQL schema
  };
}

  // DEBUG VERSION OF SAVE METHODS WITH DETAILED LOGGING
  Future<void> saveInspections(List<InspectionData> inspections) async {
    final db = await database;
    int updatedCount = 0;
    int insertedCount = 0;
    // int skippedCount = 0;
    // int duplicateCount = 0;
    // int errorCount = 0;
    
    // if (kDebugMode) {
    //   print('🔄 Starting to save ${inspections.length} inspections...');
    // }
    
    await db.transaction((txn) async {
      for (int i = 0; i < inspections.length; i++) {
        final inspection = inspections[i];
        
        try {
          // Check if pdf_path is valid
          // if (inspection.form.pdfPath.isEmpty) {
          //   skippedCount++;
          //   if (kDebugMode) {
          //     print('⚠️  Skipping inspection $i: Empty pdf_path');
          //     print('   Data: ${inspection.form.billTo} - ${inspection.form.location}');
          //   }
          //   continue;
          // }
          
          final formJson = _inspectionFormToJson(inspection);
          final searchableText = _createSearchableText(formJson);
          final newFormDataString = jsonEncode(formJson);
          
          // Check if record exists and compare content
          final existing = await txn.query(
            'inspections',
            where: 'pdf_path = ?',
            whereArgs: [inspection.form.pdfPath],
          );
          
          final recordData = {
            'pdf_path': inspection.form.pdfPath,
            'form_data': newFormDataString,
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'last_modified': DateTime.now().toIso8601String(),
            'searchable_text': searchableText,
            'date': inspection.form.date,
          };
          
          if (existing.isEmpty) {
            // Insert new record
            await txn.insert('inspections', recordData);
            insertedCount++;
            if (kDebugMode && insertedCount <= 5) {
              // print('✅ Inserted inspection: ${inspection.form.pdfPath}');
            }
          } else {
            // Check if content has actually changed
            final existingFormData = existing.first['form_data'] as String;
            if (existingFormData != newFormDataString) {
              // Update only if content changed
              await txn.update(
                'inspections',
                recordData,
                where: 'pdf_path = ?',
                whereArgs: [inspection.form.pdfPath],
              );
              updatedCount++;
              if (kDebugMode && updatedCount <= 5) {
                // print('🔄 Updated inspection: ${inspection.form.pdfPath}');
              }
            } 
            // else {
            //   // Content is identical - this is a duplicate!
            //   duplicateCount++;
            //   if (kDebugMode) {
            //     print('🔄 Duplicate found (same content): ${inspection.form.pdfPath}');
            //   }
            // }
            // If content is the same, do nothing (no unnecessary writes)
          }
        } catch (e) {
          // errorCount++;
          if (kDebugMode) {
            print('❌ Error processing inspection $i: $e');
            print('   PDF Path: ${inspection.form.pdfPath}');
            print('   Data: ${inspection.form.billTo} - ${inspection.form.location}');
          }
        }
      }
    });
    
    await _updateSyncTime('inspections');
    
    // if (kDebugMode) {
    //   print('📊 Inspections sync complete:');
    //   print('   Inserted: $insertedCount');
    //   print('   Updated: $updatedCount');
    //   print('   Duplicates: $duplicateCount');
    //   print('   Skipped (empty pdf_path): $skippedCount');
    //   print('   Errors: $errorCount');
    //   print('   Total processed: ${inspections.length}');
    // }
  }

  Future<void> saveBackflow(List<BackflowData> backflowList) async {
    final db = await database;
    int updatedCount = 0;
    int insertedCount = 0;
    // int skippedCount = 0;
    // int errorCount = 0;
    
    // if (kDebugMode) {
    //   print('🔄 Starting to save ${backflowList.length} backflow records...');
    // }
    
    await db.transaction((txn) async {
      for (int i = 0; i < backflowList.length; i++) {
        final backflow = backflowList[i];
        
        try {
          // Check if pdf_path is valid
          // if (backflow.form.pdfPath.isEmpty) {
          //   skippedCount++;
          //   if (kDebugMode) {
          //     print('⚠️  Skipping backflow $i: Empty pdf_path');
          //     print('   Data: ${backflow.form.ownerOfProperty} - ${backflow.form.deviceLocation}');
          //   }
          //   continue;
          // }
          
          final formJson = _backflowFormToJson(backflow);
          final searchableText = _createSearchableText(formJson);
          final newFormDataString = jsonEncode(formJson);
          
          // Check if record exists and compare content
          final existing = await txn.query(
            'backflow',
            where: 'pdf_path = ?',
            whereArgs: [backflow.form.pdfPath],
          );
          
          final recordData = {
            'pdf_path': backflow.form.pdfPath,
            'form_data': newFormDataString,
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'last_modified': DateTime.now().toIso8601String(),
            'searchable_text': searchableText,
            'date': backflow.form.date,
          };
          
          if (existing.isEmpty) {
            // Insert new record
            await txn.insert('backflow', recordData);
            insertedCount++;
            if (kDebugMode && insertedCount <= 5) {
              // print('✅ Inserted backflow: ${backflow.form.pdfPath}');
            }
          } else {
            // Check if content has actually changed
            final existingFormData = existing.first['form_data'] as String;
            if (existingFormData != newFormDataString) {
              // Update only if content changed
              await txn.update(
                'backflow',
                recordData,
                where: 'pdf_path = ?',
                whereArgs: [backflow.form.pdfPath],
              );
              updatedCount++;
              if (kDebugMode && updatedCount <= 5) {
                // print('🔄 Updated backflow: ${backflow.form.pdfPath}');
              }
            }
          }
        } catch (e) {
          // errorCount++;
          if (kDebugMode) {
            print('❌ Error processing backflow $i: $e');
            print('   PDF Path: ${backflow.form.pdfPath}');
            print('   Data: ${backflow.form.ownerOfProperty} - ${backflow.form.deviceLocation}');
          }
        }
      }
    });
    
    await _updateSyncTime('backflow');
    
    // if (kDebugMode) {
    //   print('📊 Backflow sync complete:');
    //   print('   Inserted: $insertedCount');
    //   print('   Updated: $updatedCount');
    //   print('   Skipped (empty pdf_path): $skippedCount');
    //   print('   Errors: $errorCount');
    //   print('   Total processed: ${backflowList.length}');
    // }
  }

  Future<void> savePumpSystems(List<PumpSystemData> pumpSystems) async {
    final db = await database;
    int updatedCount = 0;
    int insertedCount = 0;
    // int skippedCount = 0;
    // int errorCount = 0;
    
    // if (kDebugMode) {
    //   print('🔄 Starting to save ${pumpSystems.length} pump systems...');
    // }
    
    await db.transaction((txn) async {
      for (int i = 0; i < pumpSystems.length; i++) {
        final pumpSystem = pumpSystems[i];
        
        try {
          // Check if pdf_path is valid
          // if (pumpSystem.form.pdfPath.isEmpty) {
          //   skippedCount++;
          //   if (kDebugMode) {
          //     print('⚠️  Skipping pump system $i: Empty pdf_path');
          //     print('   Data: ${pumpSystem.form.reportTo} - ${pumpSystem.form.building}');
          //   }
          //   continue;
          // }
          
          final formJson = _pumpSystemFormToJson(pumpSystem);
          final searchableText = _createSearchableText(formJson);
          final newFormDataString = jsonEncode(formJson);
          
          // Check if record exists and compare content
          final existing = await txn.query(
            'pump_systems',
            where: 'pdf_path = ?',
            whereArgs: [pumpSystem.form.pdfPath],
          );
          
          final recordData = {
            'pdf_path': pumpSystem.form.pdfPath,
            'form_data': newFormDataString,
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'last_modified': DateTime.now().toIso8601String(),
            'searchable_text': searchableText,
            'date': pumpSystem.form.date,
          };
          
          if (existing.isEmpty) {
            // Insert new record
            await txn.insert('pump_systems', recordData);
            insertedCount++;
            if (kDebugMode && insertedCount <= 5) {
              // print('✅ Inserted pump system: ${pumpSystem.form.pdfPath}');
            }
          } else {
            // Check if content has actually changed
            final existingFormData = existing.first['form_data'] as String;
            if (existingFormData != newFormDataString) {
              // Update only if content changed
              await txn.update(
                'pump_systems',
                recordData,
                where: 'pdf_path = ?',
                whereArgs: [pumpSystem.form.pdfPath],
              );
              updatedCount++;
              if (kDebugMode && updatedCount <= 5) {
                // print('🔄 Updated pump system: ${pumpSystem.form.pdfPath}');
              }
            }
          }
        } catch (e) {
          // errorCount++;
          if (kDebugMode) {
            print('❌ Error processing pump system $i: $e');
            print('   PDF Path: ${pumpSystem.form.pdfPath}');
            print('   Data: ${pumpSystem.form.reportTo} - ${pumpSystem.form.building}');
          }
        }
      }
    });
    
    await _updateSyncTime('pump_systems');
    
    // if (kDebugMode) {
    //   print('📊 Pump systems sync complete:');
    //   print('   Inserted: $insertedCount');
    //   print('   Updated: $updatedCount');
    //   print('   Skipped (empty pdf_path): $skippedCount');
    //   print('   Errors: $errorCount');
    //   print('   Total processed: ${pumpSystems.length}');
    // }
  }

  Future<void> saveDrySystems(List<DrySystemData> drySystems) async {
    final db = await database;
    int updatedCount = 0;
    int insertedCount = 0;
    // int skippedCount = 0;
    // int errorCount = 0;
    
    // if (kDebugMode) {
    //   print('🔄 Starting to save ${drySystems.length} dry systems...');
    // }
    
    await db.transaction((txn) async {
      for (int i = 0; i < drySystems.length; i++) {
        final drySystem = drySystems[i];
        
        try {
          // Check if pdf_path is valid
          // if (drySystem.form.pdfPath.isEmpty) {
          //   skippedCount++;
          //   if (kDebugMode) {
          //     print('⚠️  Skipping dry system $i: Empty pdf_path');
          //     print('   Data: ${drySystem.form.reportTo} - ${drySystem.form.building}');
          //   }
          //   continue;
          // }
          
          final formJson = _drySystemFormToJson(drySystem);
          final searchableText = _createSearchableText(formJson);
          final newFormDataString = jsonEncode(formJson);
          
          // Check if record exists and compare content
          final existing = await txn.query(
            'dry_systems',
            where: 'pdf_path = ?',
            whereArgs: [drySystem.form.pdfPath],
          );
          
          final recordData = {
            'pdf_path': drySystem.form.pdfPath,
            'form_data': newFormDataString,
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'last_modified': DateTime.now().toIso8601String(),
            'searchable_text': searchableText,
            'date': drySystem.form.date,
          };
          
          if (existing.isEmpty) {
            // Insert new record
            await txn.insert('dry_systems', recordData);
            insertedCount++;
            if (kDebugMode && insertedCount <= 5) {
              // print('✅ Inserted dry system: ${drySystem.form.pdfPath}');
            }
          } else {
            // Check if content has actually changed
            final existingFormData = existing.first['form_data'] as String;
            if (existingFormData != newFormDataString) {
              // Update only if content changed
              await txn.update(
                'dry_systems',
                recordData,
                where: 'pdf_path = ?',
                whereArgs: [drySystem.form.pdfPath],
              );
              updatedCount++;
              if (kDebugMode && updatedCount <= 5) {
                // print('🔄 Updated dry system: ${drySystem.form.pdfPath}');
              }
            }
          }
        } catch (e) {
          // errorCount++;
          if (kDebugMode) {
            print('❌ Error processing dry system $i: $e');
            print('   PDF Path: ${drySystem.form.pdfPath}');
            print('   Data: ${drySystem.form.reportTo} - ${drySystem.form.building}');
          }
        }
      }
    });
    
    await _updateSyncTime('dry_systems');
    
    // if (kDebugMode) {
    //   print('📊 Dry systems sync complete:');
    //   print('   Inserted: $insertedCount');
    //   print('   Updated: $updatedCount');
    //   print('   Skipped (empty pdf_path): $skippedCount');
    //   print('   Errors: $errorCount');
    //   print('   Total processed: ${drySystems.length}');
    // }
  }

  // GET METHODS (Updated to sort by date DESC for newest to oldest)
  Future<List<InspectionData>> getInspections({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'inspections',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC', // Sort by date newest to oldest, then by pdf_path
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return InspectionData.fromJson(formData);
    }).toList();
  }

  Future<List<BackflowData>> getBackflow({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'backflow',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return BackflowData.fromJson(formData);
    }).toList();
  }

  Future<List<PumpSystemData>> getPumpSystems({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'pump_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return PumpSystemData.fromJson(formData);
    }).toList();
  }

  Future<List<DrySystemData>> getDrySystems({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'dry_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return DrySystemData.fromJson(formData);
    }).toList();
  }

  // COUNT METHODS WITH DEBUG LOGGING
  Future<int> getInspectionsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM inspections${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    final count = Sqflite.firstIntValue(result) ?? 0;
    
    // if (kDebugMode) {
    //   print('🔍 getInspectionsCount() = $count');
    //   if (searchTerm != null || startDate != null || endDate != null) {
    //     print('   (with filters applied)');
    //   }
    // }
    
    return count;
  }

  Future<int> getBackflowCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM backflow${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    final count = Sqflite.firstIntValue(result) ?? 0;
    
    // if (kDebugMode) {
    //   print('🔍 getBackflowCount() = $count');
    //   if (searchTerm != null || startDate != null || endDate != null) {
    //     print('   (with filters applied)');
    //   }
    // }
    
    return count;
  }

  Future<int> getPumpSystemsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM pump_systems${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    final count = Sqflite.firstIntValue(result) ?? 0;
    
    // if (kDebugMode) {
    //   print('🔍 getPumpSystemsCount() = $count');
    //   if (searchTerm != null || startDate != null || endDate != null) {
    //     print('   (with filters applied)');
    //   }
    // }
    
    return count;
  }

  Future<int> getDrySystemsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM dry_systems${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    final count = Sqflite.firstIntValue(result) ?? 0;
    
    // if (kDebugMode) {
    //   print('🔍 getDrySystemsCount() = $count');
    //   if (searchTerm != null || startDate != null || endDate != null) {
    //     print('   (with filters applied)');
    //   }
    // }
    
    return count;
  }

  // UTILITY METHODS
  String _createSearchableText(Map<String, dynamic> formData) {
    // Create searchable text from all relevant fields
    final searchableValues = <String>[];
    
    // Add common searchable fields
    final fieldsToIndex = [
      'pdf_path', 'bill_to', 'location', 'location_city_state', 'date',
      'contact', 'phone', 'inspector', 'email', 'inspection_frequency',
      'inspection_number', 'device_1_name', 'device_1_address', 
      'device_2_name', 'device_2_address', 'device_3_name', 'device_3_address',
      'attention', 'billing_street', 'location_street', 'billing_city_state',
      'owner_of_property', 'device_location', 'mailing_address', 
      'backflow_make', 'backflow_model', 'backflow_serial_number',
      'backflow_size', 'backflow_type', 'certificate_number', 'contact_person',
      'protection_type', 'test_type', 'tested_by', 'witness', 'result',
      'report_to', 'building', 'city_state', 'street',
      'pump_make', 'pump_model', 'pump_serial_number', 'pump_rated_gpm', 
      'pump_rated_psi', 'pump_max_psi', 'pump_power', 'pump_water_supply',
      'dry_pipe_valve_make', 'dry_pipe_valve_model', 'dry_pipe_valve_size',
      'quick_opening_device_make', 'quick_opening_device_model', 'remarks_on_test',
    ];
    
    for (final field in fieldsToIndex) {
      final value = formData[field];
      if (value != null && value.toString().isNotEmpty) {
        searchableValues.add(value.toString().toLowerCase());
      }
    }
    
    return searchableValues.join(' ');
  }

  Future<void> _updateSyncTime(String tableName) async {
    final db = await database;
    await db.update(
      'sync_metadata',
      {'last_sync': DateTime.now().millisecondsSinceEpoch},
      where: 'table_name = ?',
      whereArgs: [tableName],
    );
  }

  Future<DateTime?> getLastSyncTime(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sync_metadata',
      where: 'table_name = ?',
      whereArgs: [tableName],
    );

    if (result.isNotEmpty) {
      final timestamp = result.first['last_sync'] as int;
      return timestamp > 0 ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    }
    return null;
  }

  Future<Map<String, DateTime?>> getLastSyncTimes() async {
    return {
      'inspections': await getLastSyncTime('inspections'),
      'backflow': await getLastSyncTime('backflow'),
      'pump_systems': await getLastSyncTime('pump_systems'),
      'dry_systems': await getLastSyncTime('dry_systems'),
    };
  }

  // GET INDIVIDUAL RECORD BY PDF_PATH
  Future<InspectionData?> getInspectionByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return InspectionData.fromJson(formData);
    }
    return null;
  }

  Future<BackflowData?> getBackflowByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return BackflowData.fromJson(formData);
    }
    return null;
  }

  Future<PumpSystemData?> getPumpSystemByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return PumpSystemData.fromJson(formData);
    }
    return null;
  }

  Future<DrySystemData?> getDrySystemByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return DrySystemData.fromJson(formData);
    }
    return null;
  }

  // DELETE METHODS
  Future<void> deleteInspection(String pdfPath) async {
    final db = await database;
    await db.delete(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deleteBackflow(String pdfPath) async {
    final db = await database;
    await db.delete(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deletePumpSystem(String pdfPath) async {
    final db = await database;
    await db.delete(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deleteDrySystem(String pdfPath) async {
    final db = await database;
    await db.delete(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  // CHECK IF RECORD EXISTS
  Future<bool> inspectionExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> backflowExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> pumpSystemExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> drySystemExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // CLEAR ALL DATA (Only used when "Clear Cache" button is pressed)
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('inspections');
      await txn.delete('backflow');
      await txn.delete('pump_systems');
      await txn.delete('dry_systems');
      await txn.update('sync_metadata', {'last_sync': 0});
    });
    
    // if (kDebugMode) {
    //   print('🗑️ All cached data cleared');
    // }
  }

  // GET DATABASE STATISTICS WITH DEBUG LOGGING
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;
    
    final inspectionsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM inspections')
    ) ?? 0;
    
    final backflowCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM backflow')
    ) ?? 0;
    
    final pumpSystemsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM pump_systems')
    ) ?? 0;
    
    final drySystemsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM dry_systems')
    ) ?? 0;

    final totalCount = inspectionsCount + backflowCount + pumpSystemsCount + drySystemsCount;

    // if (kDebugMode) {
    //   print('📊 DATABASE STATISTICS:');
    //   print('   Inspections: $inspectionsCount');
    //   print('   Backflow: $backflowCount');
    //   print('   Pump Systems: $pumpSystemsCount');
    //   print('   Dry Systems: $drySystemsCount');
    //   print('   TOTAL: $totalCount');
    //   print('');
    // }
    
    return {
      'counts': {
        'inspections': inspectionsCount,
        'backflow': backflowCount,
        'pump_systems': pumpSystemsCount,
        'dry_systems': drySystemsCount,
        'total': totalCount,
      },
    };
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}