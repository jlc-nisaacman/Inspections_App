// lib/services/inspection_creation_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/inspection_data.dart';
import '../models/inspection_form.dart';
import '../services/database_helper.dart';
import '../services/sync_service.dart';

/// Handles all inspection creation operations
/// Separated from DataService to keep that class focused on data retrieval
class InspectionCreationService {
  static final InspectionCreationService _instance = InspectionCreationService._internal();
  factory InspectionCreationService() => _instance;
  InspectionCreationService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Create a new inspection locally with automatic PDF path generation
  /// Returns true if successful, false otherwise
  Future<bool> createInspection(
    InspectionData inspectionData, {
    bool attemptSync = true,
    Future<bool> Function()? isOnlineCheck,
  }) async {
    try {
      // Generate unique PDF path
      final pdfPath = _generatePdfPath(inspectionData.form.location);
      
      // Build the complete inspection form with all fields
      final updatedForm = _buildInspectionForm(inspectionData.form, pdfPath);
      
      // Create the inspection data object
      final newInspectionData = InspectionData(updatedForm);
      
      // Save to local database
      await _dbHelper.saveInspections([newInspectionData]);
      
      // Add local creation flags for sync tracking
      await _addLocalCreationFlags(pdfPath);
      
      // Attempt to sync if requested and online
      if (attemptSync && isOnlineCheck != null && await isOnlineCheck()) {
        await _attemptSync();
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating inspection: $e');
      }
      return false;
    }
  }

  /// Generate a unique PDF path based on location and timestamp
  String _generatePdfPath(String location) {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    
    // Clean up location for use in filename
    final locationForPath = location
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(' ', '_')
        .toLowerCase();
    
    return 'local_inspections/${dateStr}_${locationForPath}_$timestamp.pdf';
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