// lib/models/inspection_form.dart

class InspectionForm {
  // Direct mapping to Go struct field names
  final String pdfPath; // PDF_Path
  final String billTo; // Bill_To
  final String location; // Location
  final String billToLn2; // Bill_To_LN_2
  final String locationLn2; // Location_LN_2
  final String attention; // Attention
  final String billingStreet; // Billing_Street
  final String billingStreetLn2; // Billing_Street_LN_2
  final String locationStreet; // Location_Street
  final String locationStreetLn2; // Location_Street_LN_2
  final String billingCityState; // Billing_City_State
  final String billingCityStateLn2; // Billing_City_State_LN_2
  final String locationCityState; // Location_City_State
  final String locationCityStateLn2; // Location_City_State_LN_2
  final String contact; // Contact
  final String date; // Date
  final String phone; // Phone
  final String inspector; // Inspector
  final String email; // Email
  final String inspectionFrequency; // Inspection_Frequency
  final String inspectionNumber; // Inspection_Number
  final String isTheBuildingOccupied; // Is_The_Building_Occupied
  final String areAllSystemsInService; // Are_All_Systems_In_Service
  final String
  areFpSystemsSameAsLastInspection; // Are_FP_Systems_Same_as_Last_Inspection
  final String
  hydraulicNameplateSecurelyAttachedAndLegible; // Hydraulic_Nameplate_Securely_Attached_And_Legible
  final String
  wasAMainDrainWaterFlowTestConducted; // Was_A_Main_Drain_Water_Flow_Test_Conducted
  final String
  areAllSprinklerSystemMainControlValvesOpen; // Are_All_Sprinkler_System_Main_Control_Valves_Open
  final String
  areAllOtherValvesInProperPosition; // Are_All_Other_Valves_In_Proper_Position
  final String
  areAllControlValvesSealedOrSupervised; // Are_All_Control_Valves_Sealed_Or_Supervised
  final String
  areAllControlValvesInGoodConditionAndFreeOfLeaks; // Are_All_Control_Valves_In_Good_Condition_and_Free_Of_Leaks
  final String
  areFireDepartmentConnectionsInSatisfactoryCondition; // Are_Fire_Department_Connections_In_Satisfactory_Condition
  final String areCapsInPlace; // Are_Caps_In_Place
  final String
  isFireDepartmentConnectionEasilyAccessible; // Is_Fire_Department_Connection_Easily_Accessible
  final String automaticDrainValeInPlace; // Automatic_Drain_Vale_In_Place
  final String isThePumpRoomHeated; // Is_The_Pump_Room_Heated
  final String isTheFirePumpInService; // Is_The_Fire_Pump_In_Service
  final String
  wasFirePumpRunDuringThisInspection; // Was_Fire_Pump_Run_During_This_Inspection
  final String
  wasThePumpStartedInTheAutomaticModeByAPressureDrop; // Was_The_Pump_Started_In_The_Automatic_Mode_By_A_Pressure_Drop
  final String
  wereThePumpBearingsLubricated; // Were_The_Pump_Bearings_Lubricated
  final String jockeyPumpStartPressurePSI; // Jockey_Pump_Start_Pressure_PSI
  final String jockeyPumpStartPressure; // Jockey_Pump_Start_Pressure
  final String jockeyPumpStopPressurePSI; // Jockey_Pump_Stop_Pressure_PSI
  final String jockeyPumpStopPressure; // Jockey_Pump_Stop_Pressure
  final String firePumpStartPressurePSI; // Fire_Pump_Start_Pressure_PSI
  final String firePumpStartPressure; // Fire_Pump_Start_Pressure
  final String firePumpStopPressurePSI; // Fire_Pump_Stop_Pressure_PSI
  final String firePumpStopPressure; // Fire_Pump_Stop_Pressure
  final String
  isTheFuelTankAtLeast2_3Full; // Is_The_Fuel_Tank_At_Least_2_3_Full
  final String isEngineOilAtCorrectLevel; // Is_Engine_Oil_At_Correct_Level
  final String
  isEngineCoolantAtCorrectLevel; // Is_Engine_Coolant_At_Correct_Level
  final String
  isTheEngineBlockHeaterWorking; // Is_The_Engine_Block_Heater_Working
  final String
  isPumpRoomVentilationOperatingProperly; // Is_Pump_Room_Ventilation_Operating_Properly
  final String
  wasWaterDischargeObservedFromHeatExchangerReturnLine; // Was_Water_Discharge_Observed_From_Heat_Exchanger_Return_Line
  final String
  wasCoolingLineStrainerCleanedAfterTest; // Was_Cooling_Line_Strainer_Cleaned_After_Test
  final String
  wasPumpRunForAtLeast30Minutes; // Was_Pump_Run_For_At_Least_30_Minutes
  final String
  doesTheSwitchInAutoAlarmWork; // Does_The_Switch_In_Auto_Alarm_Work
  final String doesThePumpRunningAlarmWork; // Does_The_Pump_Running_Alarm_Work
  final String doesTheCommonAlarmWork; // Does_The_Common_Alarm_Work
  final String
  wasCasingReliefValveOperatingProperly; // Was_Casing_Relief_Valve_Operating_Properly
  final String
  wasPumpRunForAtLeast10Minutes; // Was_Pump_Run_For_At_Least_10_Minutes
  final String doesTheLossOfPowerAlarmWork; // Does_The_Loss_Of_Power_Alarm_Work
  final String
  doesTheElectricPumpRunningAlarmWork; // Does_The_Electric_Pump_Running_Alarm_Work
  final String
  powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad; // Power_Failure_Condition_Simulated_While_Pump_Operating_At_Peak_Load
  final String
  trasferOfPowerToAlternativePowerSourceVerified; // Trasfer_Of_Power_To_Alternative_Power_Source_Verified
  final String powerFaulureConditionRemoved; // Power_Faulure_Condition_Removed
  final String
  pumpReconnectedToNormalPowerSourceAfterATimeDelay; // Pump_Reconnected_To_Normal_Power_Source_After_A_Time_Delay
  final String
  haveAntiFreezeSystemsBeenTested; // Have_Anti_Freeze_Systems_Been_Tested
  final String freezeProtectionInDegreesF; // Freeze_Protection_In_Degrees_F
  final String
  areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition; // Are_Alarm_Valves_Water_Flow_Devices_And_Retards_In_Satisfactory_Condition
  final String
  waterFlowAlarmTestConductedWithInspectorsTest; // Water_Flow_Alarm_Test_Conducted_With_Inspectors_Test
  final String
  waterFlowAlarmTestConductedWithBypassConnection; // Water_Flow_Alarm_Test_Conducted_With_Bypass_Connection
  final String
  isDryValveInServiceAndInGoodCondition; // Is_Dry_Valve_In_Service_And_In_Good_Condition
  final String
  isDryValveItermediateChamberNotLeaking; // Is_Dry_Valve_Itermediate_Chamber_Not_Leaking
  final String
  hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears; // Has_The_Dry_System_Been_Fully_Tripped_Within_The_Last_Three_Years
  final String
  areQuickOpeningDeviceControlValvesOpen; // Are_Quick_Opening_Device_Control_Valves_Open
  final String
  isThereAListOfKnownLowPointDrainsAtTheRiser; // Is_There_A_List_Of_Known_Low_Point_Drains_At_The_Riser
  final String
  haveKnownLowPointsBeenDrained; // Have_Known_Low_Points_Been_Drained
  final String
  isOilLevelFullOnAirCompressor; // Is_Oil_Level_Full_On_Air_Compressor
  final String
  doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder; // Does_The_Air_Compressor_Return_System_Pressure_In_30_minutes_or_Under
  final String
  whatPressureDoesAirCompressorStartPSI; // What_Pressure_Does_Air_Compressor_Start_PSI
  final String
  whatPressureDoesAirCompressorStart; // What_Pressure_Does_Air_Compressor_Start
  final String
  whatPressureDoesAirCompressorStopPSI; // What_Pressure_Does_Air_Compressor_Stop_PSI
  final String
  whatPressureDoesAirCompressorStop; // What_Pressure_Does_Air_Compressor_Stop
  final String didLowAirAlarmOperatePSI; // Did_Low_Air_Alarm_Operate_PSI
  final String didLowAirAlarmOperate; // Did_Low_Air_Alarm_Operate
  final String dateOfLastFullTripTest; // Date_Of_Last_Full_Trip_Test
  final String dateOfLastInternalInspection; // Date_Of_Last_Internal_Inspection
  final String
  areValvesInServiceAndInGoodCondition; // Are_Valves_In_Service_And_In_Good_Condition
  final String wereValvesTripped; // Were_Valves_Tripped
  final String
  whatPressureDidPneumaticActuatorTripPSI; // What_Pressure_Did_Pneumatic_Actuator_Trip_PSI
  final String
  whatPressureDidPneumaticActuatorTrip; // What_Pressure_Did_Pneumatic_Actuator_Trip
  final String
  wasPrimingLineLeftOnAfterTest; // Was_Priming_Line_Left_On_After_Test
  final String
  whatPressureDoesPreactionAirCompressorStartPSI; // What_Pressure_Does_Preaction_Air_Compressor_Start_PSI
  final String
  whatPressureDoesPreactionAirCompressorStart; // What_Pressure_Does_Preaction_Air_Compressor_Start
  final String
  whatPressureDoesPreactionAirCompressorStopPSI; // What_Pressure_Does_Preaction_Air_Compressor_Stop_PSI
  final String
  whatPressureDoesPreactionAirCompressorStop; // What_Pressure_Does_Preaction_Air_Compressor_Stop
  final String
  didPreactionLowAirAlarmOperatePSI; // Did_Preaction_Low_Air_Alarm_Operate_PSI
  final String
  didPreactionLowAirAlarmOperate; // Did_Preaction_Low_Air_Alarm_Operate
  final String doesWaterMotorGongWork; // Does_Water_Motor_Gong_Work
  final String doesElectricBellWork; // Does_Electric_Bell_Work
  final String
  areWaterFlowAlarmsOperational; // Are_Water_Flow_Alarms_Operational
  final String
  areAllTamperSwitchesOperational; // Are_All_Tamper_Switches_Operational
  final String didAlarmPanelClearAfterTest; // Did_Alarm_Panel_Clear_After_Test
  final String
  areAMinimumOf6SpareSprinklersReadilyAvaiable; // Are_A_Minimum_Of_6_Spare_Sprinklers_Readily_Avaiable
  final String
  isConditionOfPipingAndOtherSystemComponentsSatisfactory; // Is_Condition_Of_Piping_And_Other_System_Componets_Satisfactory
  final String
  areKnownDryTypeHeadsLessThan10YearsOld; // Are_Known_Dry_Type_Heads_Less_Than_10_Years_Old
  final String
  areKnownDryTypeHeadsLessThan10YearsOldYear; // Are_Known_Dry_Type_Heads_Less_Than_10_Years_Old_Year
  final String
  areKnownQuickResponseHeadsLessThan20YearsOld; // Are_Known_Quick_Response_Heads_Less_Than_20_Years_Old
  final String
  areKnownQuickResponseHeadsLessThan20YearsOldYear; // Are_Known_Quick_Response_Heads_Less_Than_20_Years_Old_Year
  final String
  areKnownStandardResponseHeadsLessThan50YearsOld; // Are_Known_Standard_Response_Heads_Less_Than_50_Years_Old
  final String
  areKnownStandardResponseHeadsLessThan50YearsOldYear; // Are_Known_Standard_Response_Heads_Less_Than_50_Years_Old_Year
  final String
  haveAllGaugesBeenTestedOrReplacedInTheLast5Years; // Have_All_Gauges_Been_Tested_Or_Replaced_In_The_Last_5_Years
  final String
  haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear; // Have_All_Gauges_Been_Tested_Or_Replaced_In_The_Last_5_Years_Year
  final String system1Name; // System_1_Name
  final String system1DrainSize; // System_1_Drain_Size
  final String system1StaticPSI; // System_1_Static_PSI
  final String system1ResidualPSI; // System_1_Residual_PSI
  final String system2Name; // System_2_Name
  final String system2DrainSize; // System_2_Drain_Size
  final String system2StaticPSI; // System_2_Static_PSI
  final String system2ResidualPSI; // System_2_Residual_PSI
  final String system3Name; // System_3_Name
  final String system3DrainSize; // System_3_Drain_Size
  final String system3StaticPSI; // System_3_Static_PSI
  final String system3ResidualPSI; // System_3_Residual_PSI
  final String system4Name; // System_4_Name
  final String system4DrainSize; // System_4_Drain_Size
  final String system4StaticPSI; // System_4_Static_PSI
  final String system4ResidualPSI; // System_4_Residual_PSI
  final String system5Name; // System_5_Name
  final String system5DrainSize; // System_5_Drain_Size
  final String system5StaticPSI; // System_5_Static_PSI
  final String system5ResidualPSI; // System_5_Residual_PSI
  final String system6Name; // System_6_Name
  final String system6DrainSize; // System_6_Drain_Size
  final String system6StaticPSI; // System_6_Static_PSI
  final String system6ResidualPSI; // System_6_Residual_PSI
  final String drainTestNotes; // Drain_Test_Notes
  final String device1Name; // Device_1_Name
  final String device1Address; // Device_1_Address
  final String device1DescriptionLocation; // Device_1_Description_Location
  final String device1Operated; // Device_1_Operated
  final String device1DelaySec; // Device_1_Delay_Sec
  final String device2Name; // Device_2_Name
  final String device2Address; // Device_2_Address
  final String device2DescriptionLocation; // Device_2_Description_Location
  final String device2Operated; // Device_2_Operated
  final String device2DelaySec; // Device_2_Delay_Sec
  final String device3Name; // Device_3_Name
  final String device3Address; // Device_3_Address
  final String device3DescriptionLocation; // Device_3_Description_Location
  final String device3Operated; // Device_3_Operated
  final String device3DelaySec; // Device_3_Delay_Sec
  final String device4Name; // Device_4_Name
  final String device4Address; // Device_4_Address
  final String device4DescriptionLocation; // Device_4_Description_Location
  final String device4Operated; // Device_4_Operated
  final String device4DelaySec; // Device_4_Delay_Sec
  final String device5Name; // Device_5_Name
  final String device5Address; // Device_5_Address
  final String device5DescriptionLocation; // Device_5_Description_Location
  final String device5Operated; // Device_5_Operated
  final String device5DelaySec; // Device_5_Delay_Sec
  final String device6Name; // Device_6_Name
  final String device6Address; // Device_6_Address
  final String device6DescriptionLocation; // Device_6_Description_Location
  final String device6Operated; // Device_6_Operated
  final String device6DelaySec; // Device_6_Delay_Sec
  final String device7Name; // Device_7_Name
  final String device7Address; // Device_7_Address
  final String device7DescriptionLocation; // Device_7_Description_Location
  final String device7Operated; // Device_7_Operated
  final String device7DelaySec; // Device_7_Delay_Sec
  final String device8Name; // Device_8_Name
  final String device8Address; // Device_8_Address
  final String device8DescriptionLocation; // Device_8_Description_Location
  final String device8Operated; // Device_8_Operated
  final String device8DelaySec; // Device_8_Delay_Sec
  final String device9Name; // Device_9_Name
  final String device9Address; // Device_9_Address
  final String device9DescriptionLocation; // Device_9_Description_Location
  final String device9Operated; // Device_9_Operated
  final String device9DelaySec; // Device_9_Delay_Sec
  final String device10Name; // Device_10_Name
  final String device10Address; // Device_10_Address
  final String device10DescriptionLocation; // Device_10_Description_Location
  final String device10Operated; // Device_10_Operated
  final String device10DelaySec; // Device_10_Delay_Sec
  final String device11Name; // Device_11_Name
  final String device11Address; // Device_11_Address
  final String device11DescriptionLocation; // Device_11_Description_Location
  final String device11Operated; // Device_11_Operated
  final String device11DelaySec; // Device_11_Delay_Sec
  final String device12Name; // Device_12_Name
  final String device12Address; // Device_12_Address
  final String device12DescriptionLocation; // Device_12_Description_Location
  final String device12Operated; // Device_12_Operated
  final String device12DelaySec; // Device_12_Delay_Sec
  final String device13Name; // Device_13_Name
  final String device13Address; // Device_13_Address
  final String device13DescriptionLocation; // Device_13_Description_Location
  final String device13Operated; // Device_13_Operated
  final String device13DelaySec; // Device_13_Delay_Sec
  final String device14Name; // Device_14_Name
  final String device14Address; // Device_14_Address
  final String device14DescriptionLocation; // Device_14_Description_Location
  final String device14Operated; // Device_14_Operated
  final String device14DelaySec; // Device_14_Delay_Sec
  final String adjustmentsOrCorrectionsMake; // Adjustments_Or_Corrections_Make
  final String explanationOfAnyNoAnswers; // Explanation_Of_Any_No_Answers
  final String
  explanationOfAnyNoAnswersContinued; // Explanation_Of_Any_No_Answers_Continued
  final String notes; // Notes

  InspectionForm({
    required this.pdfPath,
    required this.billTo,
    required this.location,
    required this.billToLn2,
    required this.locationLn2,
    required this.attention,
    required this.billingStreet,
    required this.billingStreetLn2,
    required this.locationStreet,
    required this.locationStreetLn2,
    required this.billingCityState,
    required this.billingCityStateLn2,
    required this.locationCityState,
    required this.locationCityStateLn2,
    required this.contact,
    required this.date,
    required this.phone,
    required this.inspector,
    required this.email,
    required this.inspectionFrequency,
    required this.inspectionNumber,
    required this.isTheBuildingOccupied,
    required this.areAllSystemsInService,
    required this.areFpSystemsSameAsLastInspection,
    required this.hydraulicNameplateSecurelyAttachedAndLegible,
    required this.wasAMainDrainWaterFlowTestConducted,
    required this.areAllSprinklerSystemMainControlValvesOpen,
    required this.areAllOtherValvesInProperPosition,
    required this.areAllControlValvesSealedOrSupervised,
    required this.areAllControlValvesInGoodConditionAndFreeOfLeaks,
    required this.areFireDepartmentConnectionsInSatisfactoryCondition,
    required this.areCapsInPlace,
    required this.isFireDepartmentConnectionEasilyAccessible,
    required this.automaticDrainValeInPlace,
    required this.isThePumpRoomHeated,
    required this.isTheFirePumpInService,
    required this.wasFirePumpRunDuringThisInspection,
    required this.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
    required this.wereThePumpBearingsLubricated,
    required this.jockeyPumpStartPressurePSI,
    required this.jockeyPumpStartPressure,
    required this.jockeyPumpStopPressurePSI,
    required this.jockeyPumpStopPressure,
    required this.firePumpStartPressurePSI,
    required this.firePumpStartPressure,
    required this.firePumpStopPressurePSI,
    required this.firePumpStopPressure,
    required this.isTheFuelTankAtLeast2_3Full,
    required this.isEngineOilAtCorrectLevel,
    required this.isEngineCoolantAtCorrectLevel,
    required this.isTheEngineBlockHeaterWorking,
    required this.isPumpRoomVentilationOperatingProperly,
    required this.wasWaterDischargeObservedFromHeatExchangerReturnLine,
    required this.wasCoolingLineStrainerCleanedAfterTest,
    required this.wasPumpRunForAtLeast30Minutes,
    required this.doesTheSwitchInAutoAlarmWork,
    required this.doesThePumpRunningAlarmWork,
    required this.doesTheCommonAlarmWork,
    required this.wasCasingReliefValveOperatingProperly,
    required this.wasPumpRunForAtLeast10Minutes,
    required this.doesTheLossOfPowerAlarmWork,
    required this.doesTheElectricPumpRunningAlarmWork,
    required this.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
    required this.trasferOfPowerToAlternativePowerSourceVerified,
    required this.powerFaulureConditionRemoved,
    required this.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
    required this.haveAntiFreezeSystemsBeenTested,
    required this.freezeProtectionInDegreesF,
    required this.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
    required this.waterFlowAlarmTestConductedWithInspectorsTest,
    required this.waterFlowAlarmTestConductedWithBypassConnection,
    required this.isDryValveInServiceAndInGoodCondition,
    required this.isDryValveItermediateChamberNotLeaking,
    required this.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
    required this.areQuickOpeningDeviceControlValvesOpen,
    required this.isThereAListOfKnownLowPointDrainsAtTheRiser,
    required this.haveKnownLowPointsBeenDrained,
    required this.isOilLevelFullOnAirCompressor,
    required this.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
    required this.whatPressureDoesAirCompressorStartPSI,
    required this.whatPressureDoesAirCompressorStart,
    required this.whatPressureDoesAirCompressorStopPSI,
    required this.whatPressureDoesAirCompressorStop,
    required this.didLowAirAlarmOperatePSI,
    required this.didLowAirAlarmOperate,
    required this.dateOfLastFullTripTest,
    required this.dateOfLastInternalInspection,
    required this.areValvesInServiceAndInGoodCondition,
    required this.wereValvesTripped,
    required this.whatPressureDidPneumaticActuatorTripPSI,
    required this.whatPressureDidPneumaticActuatorTrip,
    required this.wasPrimingLineLeftOnAfterTest,
    required this.whatPressureDoesPreactionAirCompressorStartPSI,
    required this.whatPressureDoesPreactionAirCompressorStart,
    required this.whatPressureDoesPreactionAirCompressorStopPSI,
    required this.whatPressureDoesPreactionAirCompressorStop,
    required this.didPreactionLowAirAlarmOperatePSI,
    required this.didPreactionLowAirAlarmOperate,
    required this.doesWaterMotorGongWork,
    required this.doesElectricBellWork,
    required this.areWaterFlowAlarmsOperational,
    required this.areAllTamperSwitchesOperational,
    required this.didAlarmPanelClearAfterTest,
    required this.areAMinimumOf6SpareSprinklersReadilyAvaiable,
    required this.isConditionOfPipingAndOtherSystemComponentsSatisfactory,
    required this.areKnownDryTypeHeadsLessThan10YearsOld,
    required this.areKnownDryTypeHeadsLessThan10YearsOldYear,
    required this.areKnownQuickResponseHeadsLessThan20YearsOld,
    required this.areKnownQuickResponseHeadsLessThan20YearsOldYear,
    required this.areKnownStandardResponseHeadsLessThan50YearsOld,
    required this.areKnownStandardResponseHeadsLessThan50YearsOldYear,
    required this.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
    required this.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
    required this.system1Name,
    required this.system1DrainSize,
    required this.system1StaticPSI,
    required this.system1ResidualPSI,
    required this.system2Name,
    required this.system2DrainSize,
    required this.system2StaticPSI,
    required this.system2ResidualPSI,
    required this.system3Name,
    required this.system3DrainSize,
    required this.system3StaticPSI,
    required this.system3ResidualPSI,
    required this.system4Name,
    required this.system4DrainSize,
    required this.system4StaticPSI,
    required this.system4ResidualPSI,
    required this.system5Name,
    required this.system5DrainSize,
    required this.system5StaticPSI,
    required this.system5ResidualPSI,
    required this.system6Name,
    required this.system6DrainSize,
    required this.system6StaticPSI,
    required this.system6ResidualPSI,
    required this.drainTestNotes,
    required this.device1Name,
    required this.device1Address,
    required this.device1DescriptionLocation,
    required this.device1Operated,
    required this.device1DelaySec,
    required this.device2Name,
    required this.device2Address,
    required this.device2DescriptionLocation,
    required this.device2Operated,
    required this.device2DelaySec,
    required this.device3Name,
    required this.device3Address,
    required this.device3DescriptionLocation,
    required this.device3Operated,
    required this.device3DelaySec,
    required this.device4Name,
    required this.device4Address,
    required this.device4DescriptionLocation,
    required this.device4Operated,
    required this.device4DelaySec,
    required this.device5Name,
    required this.device5Address,
    required this.device5DescriptionLocation,
    required this.device5Operated,
    required this.device5DelaySec,
    required this.device6Name,
    required this.device6Address,
    required this.device6DescriptionLocation,
    required this.device6Operated,
    required this.device6DelaySec,
    required this.device7Name,
    required this.device7Address,
    required this.device7DescriptionLocation,
    required this.device7Operated,
    required this.device7DelaySec,
    required this.device8Name,
    required this.device8Address,
    required this.device8DescriptionLocation,
    required this.device8Operated,
    required this.device8DelaySec,
    required this.device9Name,
    required this.device9Address,
    required this.device9DescriptionLocation,
    required this.device9Operated,
    required this.device9DelaySec,
    required this.device10Name,
    required this.device10Address,
    required this.device10DescriptionLocation,
    required this.device10Operated,
    required this.device10DelaySec,
    required this.device11Name,
    required this.device11Address,
    required this.device11DescriptionLocation,
    required this.device11Operated,
    required this.device11DelaySec,
    required this.device12Name,
    required this.device12Address,
    required this.device12DescriptionLocation,
    required this.device12Operated,
    required this.device12DelaySec,
    required this.device13Name,
    required this.device13Address,
    required this.device13DescriptionLocation,
    required this.device13Operated,
    required this.device13DelaySec,
    required this.device14Name,
    required this.device14Address,
    required this.device14DescriptionLocation,
    required this.device14Operated,
    required this.device14DelaySec,
    required this.adjustmentsOrCorrectionsMake,
    required this.explanationOfAnyNoAnswers,
    required this.explanationOfAnyNoAnswersContinued,
    required this.notes,
  });

  // This file contains just the fromJson factory method for InspectionForm
  // Include this in your InspectionForm class or extend it as needed

  factory InspectionForm.fromJson(Map<String, dynamic> json) {
    return InspectionForm(
      // Basic Information
      pdfPath: json['pdf_path']?.toString() ?? '',
      billTo: json['BILL TO']?.toString() ?? '',
      location: json['LOCATION']?.toString() ?? '',
      billToLn2: json['BILL TO LN2']?.toString() ?? '',
      locationLn2: json['LOCATION LN2']?.toString() ?? '',
      attention: json['ATTN']?.toString() ?? '',
      billingStreet: json['STREET']?.toString() ?? '',
      billingStreetLn2: json['STREET LN2']?.toString() ?? '',
      locationStreet: json['STREET_2']?.toString() ?? '',
      locationStreetLn2: json['STREET_2 LN 2']?.toString() ?? '',
      billingCityState: json['CITY  STATE']?.toString() ?? '',
      billingCityStateLn2: json['CITY STATE LN 2']?.toString() ?? '',
      locationCityState: json['CITY  STATE_2']?.toString() ?? '',
      locationCityStateLn2: json['CITY STATE_2 LN 2']?.toString() ?? '',
      contact: json['CONTACT']?.toString() ?? '',
      date: json['DATE']?.toString() ?? json['DATE1']?.toString() ?? '',
      phone: json['PHONE']?.toString() ?? '',
      inspector: json['INSPECTOR']?.toString() ?? '',
      email: json['EMAIL']?.toString() ?? '',
      inspectionFrequency: json['INSP_FREQ']?.toString() ?? '',
      inspectionNumber: json['INSP_#']?.toString() ?? '',

      // General Inspection
      isTheBuildingOccupied: json['1A']?.toString() ?? '',
      areAllSystemsInService: json['1B']?.toString() ?? '',
      areFpSystemsSameAsLastInspection: json['1C']?.toString() ?? '',
      hydraulicNameplateSecurelyAttachedAndLegible:
          json['1D']?.toString() ?? '',
      wasAMainDrainWaterFlowTestConducted: json['2A']?.toString() ?? '',

      // Control Valves
      areAllSprinklerSystemMainControlValvesOpen: json['3A']?.toString() ?? '',
      areAllOtherValvesInProperPosition: json['3B']?.toString() ?? '',
      areAllControlValvesSealedOrSupervised: json['3C']?.toString() ?? '',
      areAllControlValvesInGoodConditionAndFreeOfLeaks:
          json['3D']?.toString() ?? '',

      // Fire Department Connections
      areFireDepartmentConnectionsInSatisfactoryCondition:
          json['4A']?.toString() ?? '',
      areCapsInPlace: json['4B']?.toString() ?? '',
      isFireDepartmentConnectionEasilyAccessible: json['4C']?.toString() ?? '',
      automaticDrainValeInPlace: json['4D']?.toString() ?? '',

      // Fire Pump General
      isThePumpRoomHeated: json['5A']?.toString() ?? '',
      isTheFirePumpInService: json['5B']?.toString() ?? '',
      wasFirePumpRunDuringThisInspection: json['5C']?.toString() ?? '',
      wasThePumpStartedInTheAutomaticModeByAPressureDrop:
          json['5D']?.toString() ?? '',
      wereThePumpBearingsLubricated: json['5E']?.toString() ?? '',
      jockeyPumpStartPressurePSI: json['5FPSI']?.toString() ?? '',
      jockeyPumpStartPressure: json['5F']?.toString() ?? '',
      jockeyPumpStopPressurePSI: json['5GPSI']?.toString() ?? '',
      jockeyPumpStopPressure: json['5G']?.toString() ?? '',
      firePumpStartPressurePSI: json['5HPSI']?.toString() ?? '',
      firePumpStartPressure: json['5H']?.toString() ?? '',
      firePumpStopPressurePSI: json['5IPSI']?.toString() ?? '',
      firePumpStopPressure: json['5I']?.toString() ?? '',

      // Diesel Fire Pump
      isTheFuelTankAtLeast2_3Full: json['6A']?.toString() ?? '',
      isEngineOilAtCorrectLevel: json['6B']?.toString() ?? '',
      isEngineCoolantAtCorrectLevel: json['6C']?.toString() ?? '',
      isTheEngineBlockHeaterWorking: json['6D']?.toString() ?? '',
      isPumpRoomVentilationOperatingProperly: json['6E']?.toString() ?? '',
      wasWaterDischargeObservedFromHeatExchangerReturnLine:
          json['6F']?.toString() ?? '',
      wasCoolingLineStrainerCleanedAfterTest: json['6G']?.toString() ?? '',
      wasPumpRunForAtLeast30Minutes: json['6H']?.toString() ?? '',
      doesTheSwitchInAutoAlarmWork: json['6I']?.toString() ?? '',
      doesThePumpRunningAlarmWork: json['6J']?.toString() ?? '',
      doesTheCommonAlarmWork: json['6K']?.toString() ?? '',

      // Electric Fire Pump
      wasCasingReliefValveOperatingProperly: json['7A']?.toString() ?? '',
      wasPumpRunForAtLeast10Minutes: json['7B']?.toString() ?? '',
      doesTheLossOfPowerAlarmWork: json['7C']?.toString() ?? '',
      doesTheElectricPumpRunningAlarmWork: json['7D']?.toString() ?? '',
      powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad:
          json['7E']?.toString() ?? '',
      trasferOfPowerToAlternativePowerSourceVerified:
          json['7F']?.toString() ?? '',
      powerFaulureConditionRemoved: json['7G']?.toString() ?? '',
      pumpReconnectedToNormalPowerSourceAfterATimeDelay:
          json['7H']?.toString() ?? '',

      // Wet Systems
      haveAntiFreezeSystemsBeenTested: json['8A']?.toString() ?? '',
      freezeProtectionInDegreesF: json['AFTEMP']?.toString() ?? '',
      areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition:
          json['8B']?.toString() ?? '',
      waterFlowAlarmTestConductedWithInspectorsTest:
          json['8C']?.toString() ?? '',
      waterFlowAlarmTestConductedWithBypassConnection:
          json['8D']?.toString() ?? '',

      // Dry Systems
      isDryValveInServiceAndInGoodCondition: json['9A']?.toString() ?? '',
      isDryValveItermediateChamberNotLeaking: json['9B']?.toString() ?? '',
      hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears:
          json['9C']?.toString() ?? '',
      areQuickOpeningDeviceControlValvesOpen: json['9D']?.toString() ?? '',
      isThereAListOfKnownLowPointDrainsAtTheRiser: json['9E']?.toString() ?? '',
      haveKnownLowPointsBeenDrained: json['9F']?.toString() ?? '',
      isOilLevelFullOnAirCompressor: json['9G']?.toString() ?? '',
      doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder:
          json['9H']?.toString() ?? '',
      whatPressureDoesAirCompressorStartPSI:
          json['9ISTARTPSI']?.toString() ?? '',
      whatPressureDoesAirCompressorStart: json['9I']?.toString() ?? '',
      whatPressureDoesAirCompressorStopPSI: json['9JPSISTOP']?.toString() ?? '',
      whatPressureDoesAirCompressorStop: json['9J']?.toString() ?? '',
      didLowAirAlarmOperatePSI: json['9KLOWAIR']?.toString() ?? '',
      didLowAirAlarmOperate: json['9K']?.toString() ?? '',
      dateOfLastFullTripTest: json['LASTFULLTRIP']?.toString() ?? '',
      dateOfLastInternalInspection: json['LASTINTERNAL']?.toString() ?? '',

      // Preaction/Deluge Systems
      areValvesInServiceAndInGoodCondition: json['10a']?.toString() ?? '',
      wereValvesTripped: json['10b']?.toString() ?? '',
      whatPressureDidPneumaticActuatorTripPSI:
          json['10c PSI']?.toString() ?? '',
      whatPressureDidPneumaticActuatorTrip: json['10c']?.toString() ?? '',
      wasPrimingLineLeftOnAfterTest: json['10d']?.toString() ?? '',
      whatPressureDoesPreactionAirCompressorStartPSI:
          json['10e PSI']?.toString() ?? '',
      whatPressureDoesPreactionAirCompressorStart:
          json['10e']?.toString() ?? '',
      whatPressureDoesPreactionAirCompressorStopPSI:
          json['10f PSI']?.toString() ?? '',
      whatPressureDoesPreactionAirCompressorStop: json['10f']?.toString() ?? '',
      didPreactionLowAirAlarmOperatePSI: json['10g PSI']?.toString() ?? '',
      didPreactionLowAirAlarmOperate: json['10g']?.toString() ?? '',

      // Alarms
      doesWaterMotorGongWork: json['11a']?.toString() ?? '',
      doesElectricBellWork: json['11b']?.toString() ?? '',
      areWaterFlowAlarmsOperational: json['11c']?.toString() ?? '',
      areAllTamperSwitchesOperational: json['11d']?.toString() ?? '',
      didAlarmPanelClearAfterTest: json['11e']?.toString() ?? '',

      // Sprinkler Components
      areAMinimumOf6SpareSprinklersReadilyAvaiable:
          json['12a']?.toString() ?? '',
      isConditionOfPipingAndOtherSystemComponentsSatisfactory:
          json['12b']?.toString() ?? '',
      areKnownDryTypeHeadsLessThan10YearsOld: json['12c']?.toString() ?? '',
      areKnownDryTypeHeadsLessThan10YearsOldYear:
          json['12c year']?.toString() ?? '',
      areKnownQuickResponseHeadsLessThan20YearsOld:
          json['12d']?.toString() ?? '',
      areKnownQuickResponseHeadsLessThan20YearsOldYear:
          json['12d year']?.toString() ?? '',
      areKnownStandardResponseHeadsLessThan50YearsOld:
          json['12e']?.toString() ?? '',
      areKnownStandardResponseHeadsLessThan50YearsOldYear:
          json['12e year']?.toString() ?? '',
      haveAllGaugesBeenTestedOrReplacedInTheLast5Years:
          json['12f']?.toString() ?? '',
      haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear:
          json['12f year']?.toString() ?? '',

      // Drain Tests
      system1Name: json['Drain test line 1']?.toString() ?? '',
      system1DrainSize: json['drian size 1']?.toString() ?? '',
      system1StaticPSI: json['Static 1']?.toString() ?? '',
      system1ResidualPSI: json['Residual 1']?.toString() ?? '',
      system2Name: json['Drain test line 2']?.toString() ?? '',
      system2DrainSize: json['drian size 2']?.toString() ?? '',
      system2StaticPSI: json['Static 2']?.toString() ?? '',
      system2ResidualPSI: json['Residual 2']?.toString() ?? '',
      system3Name: json['Drain test line 3']?.toString() ?? '',
      system3DrainSize: json['drian size 3']?.toString() ?? '',
      system3StaticPSI: json['Static 3']?.toString() ?? '',
      system3ResidualPSI: json['Residual 3']?.toString() ?? '',
      system4Name: json['Drain test line 4']?.toString() ?? '',
      system4DrainSize: json['drian size 4']?.toString() ?? '',
      system4StaticPSI: json['Static 4']?.toString() ?? '',
      system4ResidualPSI: json['Residual 4']?.toString() ?? '',
      system5Name: json['Drain test line 5']?.toString() ?? '',
      system5DrainSize: json['drian size 5']?.toString() ?? '',
      system5StaticPSI: json['Static 5']?.toString() ?? '',
      system5ResidualPSI: json['Residual 5']?.toString() ?? '',
      system6Name: json['Drain test line 6']?.toString() ?? '',
      system6DrainSize: json['drian size 6']?.toString() ?? '',
      system6StaticPSI: json['Static 6']?.toString() ?? '',
      system6ResidualPSI: json['Residual 6']?.toString() ?? '',
      drainTestNotes: json['Drain test notes']?.toString() ?? '',

      // Device Tests
      device1Name: json['15a pt1']?.toString() ?? '',
      device1Address: json['15a pt2']?.toString() ?? '',
      device1DescriptionLocation: json['15a pt3']?.toString() ?? '',
      device1Operated: json['15a pt4']?.toString() ?? '',
      device1DelaySec: json['15a pt5']?.toString() ?? '',
      device2Name: json['15b pt1']?.toString() ?? '',
      device2Address: json['15b pt2']?.toString() ?? '',
      device2DescriptionLocation: json['15b pt3']?.toString() ?? '',
      device2Operated: json['15b pt4']?.toString() ?? '',
      device2DelaySec: json['15b pt5']?.toString() ?? '',
      device3Name: json['15c pt1']?.toString() ?? '',
      device3Address: json['15c pt2']?.toString() ?? '',
      device3DescriptionLocation: json['15c pt3']?.toString() ?? '',
      device3Operated: json['15c pt4']?.toString() ?? '',
      device3DelaySec: json['15c pt5']?.toString() ?? '',
      device4Name: json['15d pt1']?.toString() ?? '',
      device4Address: json['15d pt2']?.toString() ?? '',
      device4DescriptionLocation: json['15d pt3']?.toString() ?? '',
      device4Operated: json['15d pt4']?.toString() ?? '',
      device4DelaySec: json['15d pt5']?.toString() ?? '',
      device5Name: json['15e pt1']?.toString() ?? '',
      device5Address: json['15e pt2']?.toString() ?? '',
      device5DescriptionLocation: json['15e pt3']?.toString() ?? '',
      device5Operated: json['15e pt4']?.toString() ?? '',
      device5DelaySec: json['15e pt5']?.toString() ?? '',
      device6Name: json['15f pt1']?.toString() ?? '',
      device6Address: json['15f pt2']?.toString() ?? '',
      device6DescriptionLocation: json['15f pt3']?.toString() ?? '',
      device6Operated: json['15f pt4']?.toString() ?? '',
      device6DelaySec: json['15f pt5']?.toString() ?? '',
      device7Name: json['15g pt1']?.toString() ?? '',
      device7Address: json['15g pt2']?.toString() ?? '',
      device7DescriptionLocation: json['15g pt3']?.toString() ?? '',
      device7Operated: json['15g pt4']?.toString() ?? '',
      device7DelaySec: json['15g pt5']?.toString() ?? '',
      device8Name: json['15h pt1']?.toString() ?? '',
      device8Address: json['15h pt2']?.toString() ?? '',
      device8DescriptionLocation: json['15h pt3']?.toString() ?? '',
      device8Operated: json['15h pt4']?.toString() ?? '',
      device8DelaySec: json['15h pt5']?.toString() ?? '',
      device9Name: json['15i pt1']?.toString() ?? '',
      device9Address: json['15i pt2']?.toString() ?? '',
      device9DescriptionLocation: json['15i pt3']?.toString() ?? '',
      device9Operated: json['15i pt4']?.toString() ?? '',
      device9DelaySec: json['15i pt5']?.toString() ?? '',
      device10Name: json['15j pt1']?.toString() ?? '',
      device10Address: json['15j pt2']?.toString() ?? '',
      device10DescriptionLocation: json['15j pt3']?.toString() ?? '',
      device10Operated: json['15j pt4']?.toString() ?? '',
      device10DelaySec: json['15j pt5']?.toString() ?? '',
      device11Name: json['15k pt1']?.toString() ?? '',
      device11Address: json['15k pt2']?.toString() ?? '',
      device11DescriptionLocation: json['15k pt3']?.toString() ?? '',
      device11Operated: json['15k pt4']?.toString() ?? '',
      device11DelaySec: json['15k pt5']?.toString() ?? '',
      device12Name: json['15l pt1']?.toString() ?? '',
      device12Address: json['15l pt2']?.toString() ?? '',
      device12DescriptionLocation: json['15l pt3']?.toString() ?? '',
      device12Operated: json['15l pt4']?.toString() ?? '',
      device12DelaySec: json['15l pt5']?.toString() ?? '',
      device13Name: json['15m pt1']?.toString() ?? '',
      device13Address: json['15m pt2']?.toString() ?? '',
      device13DescriptionLocation: json['15m pt3']?.toString() ?? '',
      device13Operated: json['15m pt4']?.toString() ?? '',
      device13DelaySec: json['15m pt5']?.toString() ?? '',
      device14Name: json['15n pt1']?.toString() ?? '',
      device14Address: json['15n pt2']?.toString() ?? '',
      device14DescriptionLocation: json['15n pt3']?.toString() ?? '',
      device14Operated: json['15n pt4']?.toString() ?? '',
      device14DelaySec: json['15n pt5']?.toString() ?? '',

      // Final sections
      adjustmentsOrCorrectionsMake:
          json['16 Adjustments or Corrections']?.toString() ?? '',
      explanationOfAnyNoAnswers:
          json['17 Explanation of no answers']?.toString() ?? '',
      explanationOfAnyNoAnswersContinued:
          json['17 Explanation of no answers continued']?.toString() ?? '',
      notes: json['18 NOTES']?.toString() ?? '',
    );
  }
}
