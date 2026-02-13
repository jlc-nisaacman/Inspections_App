// lib/models/inspection_form.dart

class InspectionForm {
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
  final double? device1DelaySec; // Device_1_Delay_Sec
  final String device2Name; // Device_2_Name
  final String device2Address; // Device_2_Address
  final String device2DescriptionLocation; // Device_2_Description_Location
  final String device2Operated; // Device_2_Operated
  final double? device2DelaySec; // Device_2_Delay_Sec
  final String device3Name; // Device_3_Name
  final String device3Address; // Device_3_Address
  final String device3DescriptionLocation; // Device_3_Description_Location
  final String device3Operated; // Device_3_Operated
  final double? device3DelaySec; // Device_3_Delay_Sec
  final String device4Name; // Device_4_Name
  final String device4Address; // Device_4_Address
  final String device4DescriptionLocation; // Device_4_Description_Location
  final String device4Operated; // Device_4_Operated
  final double? device4DelaySec; // Device_4_Delay_Sec
  final String device5Name; // Device_5_Name
  final String device5Address; // Device_5_Address
  final String device5DescriptionLocation; // Device_5_Description_Location
  final String device5Operated; // Device_5_Operated
  final double? device5DelaySec; // Device_5_Delay_Sec
  final String device6Name; // Device_6_Name
  final String device6Address; // Device_6_Address
  final String device6DescriptionLocation; // Device_6_Description_Location
  final String device6Operated; // Device_6_Operated
  final double? device6DelaySec; // Device_6_Delay_Sec
  final String device7Name; // Device_7_Name
  final String device7Address; // Device_7_Address
  final String device7DescriptionLocation; // Device_7_Description_Location
  final String device7Operated; // Device_7_Operated
  final double? device7DelaySec; // Device_7_Delay_Sec
  final String device8Name; // Device_8_Name
  final String device8Address; // Device_8_Address
  final String device8DescriptionLocation; // Device_8_Description_Location
  final String device8Operated; // Device_8_Operated
  final double? device8DelaySec; // Device_8_Delay_Sec
  final String device9Name; // Device_9_Name
  final String device9Address; // Device_9_Address
  final String device9DescriptionLocation; // Device_9_Description_Location
  final String device9Operated; // Device_9_Operated
  final double? device9DelaySec; // Device_9_Delay_Sec
  final String device10Name; // Device_10_Name
  final String device10Address; // Device_10_Address
  final String device10DescriptionLocation; // Device_10_Description_Location
  final String device10Operated; // Device_10_Operated
  final double? device10DelaySec; // Device_10_Delay_Sec
  final String device11Name; // Device_11_Name
  final String device11Address; // Device_11_Address
  final String device11DescriptionLocation; // Device_11_Description_Location
  final String device11Operated; // Device_11_Operated
  final double? device11DelaySec; // Device_11_Delay_Sec
  final String device12Name; // Device_12_Name
  final String device12Address; // Device_12_Address
  final String device12DescriptionLocation; // Device_12_Description_Location
  final String device12Operated; // Device_12_Operated
  final double? device12DelaySec; // Device_12_Delay_Sec
  final String device13Name; // Device_13_Name
  final String device13Address; // Device_13_Address
  final String device13DescriptionLocation; // Device_13_Description_Location
  final String device13Operated; // Device_13_Operated
  final double? device13DelaySec; // Device_13_Delay_Sec
  final String device14Name; // Device_14_Name
  final String device14Address; // Device_14_Address
  final String device14DescriptionLocation; // Device_14_Description_Location
  final String device14Operated; // Device_14_Operated
  final double? device14DelaySec; // Device_14_Delay_Sec
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

  // Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_path': pdfPath,
      'bill_to': billTo,
      'location': location,
      'bill_to_ln_2': billToLn2,
      'location_ln_2': locationLn2,
      'attention': attention,
      'billing_street': billingStreet,
      'billing_street_ln_2': billingStreetLn2,
      'location_street': locationStreet,
      'location_street_ln_2': locationStreetLn2,
      'billing_city_state': billingCityState,
      'billing_city_state_ln_2': billingCityStateLn2,
      'location_city_state': locationCityState,
      'location_city_state_ln_2': locationCityStateLn2,
      'contact': contact,
      'date': date,
      'phone': phone,
      'inspector': inspector,
      'email': email,
      'inspection_frequency': inspectionFrequency,
      'inspection_number': inspectionNumber,
      'is_the_building_occupied': isTheBuildingOccupied,
      'are_all_systems_in_service': areAllSystemsInService,
      'are_fp_systems_same_as_last_inspection': areFpSystemsSameAsLastInspection,
      'hydraulic_nameplate_securely_attached_and_legible': hydraulicNameplateSecurelyAttachedAndLegible,
      'was_a_main_drain_water_flow_test_conducted': wasAMainDrainWaterFlowTestConducted,
      'are_all_sprinkler_system_main_control_valves_open': areAllSprinklerSystemMainControlValvesOpen,
      'are_all_other_valves_in_proper_position': areAllOtherValvesInProperPosition,
      'are_all_control_valves_sealed_or_supervised': areAllControlValvesSealedOrSupervised,
      'are_all_control_valves_in_good_condition_and_free_of_leaks': areAllControlValvesInGoodConditionAndFreeOfLeaks,
      'are_fire_department_connections_in_satisfactory_condition': areFireDepartmentConnectionsInSatisfactoryCondition,
      'are_caps_in_place': areCapsInPlace,
      'is_fire_department_connection_easily_accessible': isFireDepartmentConnectionEasilyAccessible,
      'automatic_drain_valve_in_place': automaticDrainValeInPlace,
      'is_the_pump_room_heated': isThePumpRoomHeated,
      'is_the_fire_pump_in_service': isTheFirePumpInService,
      'was_fire_pump_run_during_this_inspection': wasFirePumpRunDuringThisInspection,
      'was_the_pump_started_in_the_automatic_mode_by_a_pressure_drop': wasThePumpStartedInTheAutomaticModeByAPressureDrop,
      'were_the_pump_bearings_lubricated': wereThePumpBearingsLubricated,
      'jockey_pump_start_pressure_psi': jockeyPumpStartPressurePSI,
      'jockey_pump_start_pressure': jockeyPumpStartPressure,
      'jockey_pump_stop_pressure_psi': jockeyPumpStopPressurePSI,
      'jockey_pump_stop_pressure': jockeyPumpStopPressure,
      'fire_pump_start_pressure_psi': firePumpStartPressurePSI,
      'fire_pump_start_pressure': firePumpStartPressure,
      'fire_pump_stop_pressure_psi': firePumpStopPressurePSI,
      'fire_pump_stop_pressure': firePumpStopPressure,
      'is_the_fuel_tank_at_least_2_3_full': isTheFuelTankAtLeast2_3Full,
      'is_engine_oil_at_correct_level': isEngineOilAtCorrectLevel,
      'is_engine_coolant_at_correct_level': isEngineCoolantAtCorrectLevel,
      'is_the_engine_block_heater_working': isTheEngineBlockHeaterWorking,
      'is_pump_room_ventilation_operating_properly': isPumpRoomVentilationOperatingProperly,
      'was_water_discharge_observed_from_heat_exchanger_return_line': wasWaterDischargeObservedFromHeatExchangerReturnLine,
      'was_cooling_line_strainer_cleaned_after_test': wasCoolingLineStrainerCleanedAfterTest,
      'was_pump_run_for_at_least_30_minutes': wasPumpRunForAtLeast30Minutes,
      'does_the_switch_in_auto_alarm_work': doesTheSwitchInAutoAlarmWork,
      'does_the_pump_running_alarm_work': doesThePumpRunningAlarmWork,
      'does_the_common_alarm_work': doesTheCommonAlarmWork,
      'was_casing_relief_valve_operating_properly': wasCasingReliefValveOperatingProperly,
      'was_pump_run_for_at_least_10_minutes': wasPumpRunForAtLeast10Minutes,
      'does_the_loss_of_power_alarm_work': doesTheLossOfPowerAlarmWork,
      'does_the_electric_pump_running_alarm_work': doesTheElectricPumpRunningAlarmWork,
      'power_failure_condition_simulated_while_pump_operating_at_peak_': powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
      'transfer_of_power_to_alternative_power_source_verified': trasferOfPowerToAlternativePowerSourceVerified,
      'power_failure_condition_removed': powerFaulureConditionRemoved,
      'pump_reconnected_to_normal_power_source_after_a_time_delay': pumpReconnectedToNormalPowerSourceAfterATimeDelay,
      'have_anti_freeze_systems_been_tested': haveAntiFreezeSystemsBeenTested,
      'freeze_protection_in_degrees_f': freezeProtectionInDegreesF,
      'are_alarm_valves_water_flow_devices_and_retards_in_satisfactory': areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
      'water_flow_alarm_test_conducted_with_inspectors_test': waterFlowAlarmTestConductedWithInspectorsTest,
      'water_flow_alarm_test_conducted_with_bypass_connection': waterFlowAlarmTestConductedWithBypassConnection,
      'is_dry_valve_in_service_and_in_good_condition': isDryValveInServiceAndInGoodCondition,
      'is_dry_valve_itermediate_chamber_not_leaking': isDryValveItermediateChamberNotLeaking,
      'has_the_dry_system_been_fully_tripped_within_the_last_three_yea': hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears,
      'are_quick_opening_device_control_valves_open': areQuickOpeningDeviceControlValvesOpen,
      'is_there_a_list_of_known_low_point_drains_at_the_riser': isThereAListOfKnownLowPointDrainsAtTheRiser,
      'have_known_low_points_been_drained': haveKnownLowPointsBeenDrained,
      'is_oil_level_full_on_air_compressor': isOilLevelFullOnAirCompressor,
      'does_the_air_compressor_return_system_pressure_in_30_minutes_or': doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
      'what_pressure_does_air_compressor_start_psi': whatPressureDoesAirCompressorStartPSI,
      'what_pressure_does_air_compressor_start': whatPressureDoesAirCompressorStart,
      'what_pressure_does_air_compressor_stop_psi': whatPressureDoesAirCompressorStopPSI,
      'what_pressure_does_air_compressor_stop': whatPressureDoesAirCompressorStop,
      'did_low_air_alarm_operate_psi': didLowAirAlarmOperatePSI,
      'did_low_air_alarm_operate': didLowAirAlarmOperate,
      'date_of_last_full_trip_test': dateOfLastFullTripTest,
      'date_of_last_internal_inspection': dateOfLastInternalInspection,
      'are_valves_in_service_and_in_good_condition': areValvesInServiceAndInGoodCondition,
      'were_valves_tripped': wereValvesTripped,
      'what_pressure_did_pneumatic_actuator_trip_psi': whatPressureDidPneumaticActuatorTripPSI,
      'what_pressure_did_pneumatic_actuator_trip': whatPressureDidPneumaticActuatorTrip,
      'was_priming_line_left_on_after_test': wasPrimingLineLeftOnAfterTest,
      'what_pressure_does_preaction_air_compressor_start_psi': whatPressureDoesPreactionAirCompressorStartPSI,
      'what_pressure_does_preaction_air_compressor_start': whatPressureDoesPreactionAirCompressorStart,
      'what_pressure_does_preaction_air_compressor_stop_psi': whatPressureDoesPreactionAirCompressorStopPSI,
      'what_pressure_does_preaction_air_compressor_stop': whatPressureDoesPreactionAirCompressorStop,
      'did_preaction_low_air_alarm_operate_psi': didPreactionLowAirAlarmOperatePSI,
      'did_preaction_low_air_alarm_operate': didPreactionLowAirAlarmOperate,
      'does_water_motor_gong_work': doesWaterMotorGongWork,
      'does_electric_bell_work': doesElectricBellWork,
      'are_water_flow_alarms_operational': areWaterFlowAlarmsOperational,
      'are_all_tamper_switches_operational': areAllTamperSwitchesOperational,
      'did_alarm_panel_clear_after_test': didAlarmPanelClearAfterTest,
      'are_a_minimum_of_6_spare_sprinklers_readily_avaiable': areAMinimumOf6SpareSprinklersReadilyAvaiable,
      'is_condition_of_piping_and_other_system_componets_satisfactory': isConditionOfPipingAndOtherSystemComponentsSatisfactory,
      'are_known_dry_type_heads_less_than_10_years_old': areKnownDryTypeHeadsLessThan10YearsOld,
      'are_known_dry_type_heads_less_than_10_years_old_year': areKnownDryTypeHeadsLessThan10YearsOldYear,
      'are_known_quick_response_heads_less_than_20_years_old': areKnownQuickResponseHeadsLessThan20YearsOld,
      'are_known_quick_response_heads_less_than_20_years_old_year': areKnownQuickResponseHeadsLessThan20YearsOldYear,
      'are_known_standard_response_heads_less_than_50_years_old': areKnownStandardResponseHeadsLessThan50YearsOld,
      'are_known_standard_response_heads_less_than_50_years_old_year': areKnownStandardResponseHeadsLessThan50YearsOldYear,
      'have_all_gauges_been_tested_or_replaced_in_the_last_5_years': haveAllGaugesBeenTestedOrReplacedInTheLast5Years,
      'have_all_gauges_been_tested_or_replaced_in_the_last_5_years_yea': haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,
      'system_1_name': system1Name,
      'system_1_drain_size': system1DrainSize,
      'system_1_static_psi': system1StaticPSI,
      'system_1_residual_psi': system1ResidualPSI,
      'system_2_name': system2Name,
      'system_2_drain_size': system2DrainSize,
      'system_2_static_psi': system2StaticPSI,
      'system_2_residual_psi': system2ResidualPSI,
      'system_3_name': system3Name,
      'system_3_drain_size': system3DrainSize,
      'system_3_static_psi': system3StaticPSI,
      'system_3_residual_psi': system3ResidualPSI,
      'system_4_name': system4Name,
      'system_4_drain_size': system4DrainSize,
      'system_4_static_psi': system4StaticPSI,
      'system_4_residual_psi': system4ResidualPSI,
      'system_5_name': system5Name,
      'system_5_drain_size': system5DrainSize,
      'system_5_static_psi': system5StaticPSI,
      'system_5_residual_psi': system5ResidualPSI,
      'system_6_name': system6Name,
      'system_6_drain_size': system6DrainSize,
      'system_6_static_psi': system6StaticPSI,
      'system_6_residual_psi': system6ResidualPSI,
      'drain_test_notes': drainTestNotes,
      'device_1_name': device1Name,
      'device_1_address': device1Address,
      'device_1_description_location': device1DescriptionLocation,
      'device_1_operated': device1Operated,
      'device_1_delay_sec': device1DelaySec,
      'device_2_name': device2Name,
      'device_2_address': device2Address,
      'device_2_description_location': device2DescriptionLocation,
      'device_2_operated': device2Operated,
      'device_2_delay_sec': device2DelaySec,
      'device_3_name': device3Name,
      'device_3_address': device3Address,
      'device_3_description_location': device3DescriptionLocation,
      'device_3_operated': device3Operated,
      'device_3_delay_sec': device3DelaySec,
      'device_4_name': device4Name,
      'device_4_address': device4Address,
      'device_4_description_location': device4DescriptionLocation,
      'device_4_operated': device4Operated,
      'device_4_delay_sec': device4DelaySec,
      'device_5_name': device5Name,
      'device_5_address': device5Address,
      'device_5_description_location': device5DescriptionLocation,
      'device_5_operated': device5Operated,
      'device_5_delay_sec': device5DelaySec,
      'device_6_name': device6Name,
      'device_6_address': device6Address,
      'device_6_description_location': device6DescriptionLocation,
      'device_6_operated': device6Operated,
      'device_6_delay_sec': device6DelaySec,
      'device_7_name': device7Name,
      'device_7_address': device7Address,
      'device_7_description_location': device7DescriptionLocation,
      'device_7_operated': device7Operated,
      'device_7_delay_sec': device7DelaySec,
      'device_8_name': device8Name,
      'device_8_address': device8Address,
      'device_8_description_location': device8DescriptionLocation,
      'device_8_operated': device8Operated,
      'device_8_delay_sec': device8DelaySec,
      'device_9_name': device9Name,
      'device_9_address': device9Address,
      'device_9_description_location': device9DescriptionLocation,
      'device_9_operated': device9Operated,
      'device_9_delay_sec': device9DelaySec,
      'device_10_name': device10Name,
      'device_10_address': device10Address,
      'device_10_description_location': device10DescriptionLocation,
      'device_10_operated': device10Operated,
      'device_10_delay_sec': device10DelaySec,
      'device_11_name': device11Name,
      'device_11_address': device11Address,
      'device_11_description_location': device11DescriptionLocation,
      'device_11_operated': device11Operated,
      'device_11_delay_sec': device11DelaySec,
      'device_12_name': device12Name,
      'device_12_address': device12Address,
      'device_12_description_location': device12DescriptionLocation,
      'device_12_operated': device12Operated,
      'device_12_delay_sec': device12DelaySec,
      'device_13_name': device13Name,
      'device_13_address': device13Address,
      'device_13_description_location': device13DescriptionLocation,
      'device_13_operated': device13Operated,
      'device_13_delay_sec': device13DelaySec,
      'device_14_name': device14Name,
      'device_14_address': device14Address,
      'device_14_description_location': device14DescriptionLocation,
      'device_14_operated': device14Operated,
      'device_14_delay_sec': device14DelaySec,
      'adjustments_or_corrections_make': adjustmentsOrCorrectionsMake,
      'explanation_of_any_no_answers': explanationOfAnyNoAnswers,
      'explanation_of_any_no_answers_continued': explanationOfAnyNoAnswersContinued,
      'notes': notes,
    };
  }

  factory InspectionForm.fromJson(Map<String, dynamic> json) {
    return InspectionForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      billTo: json['bill_to']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      billToLn2: json['bill_to_ln_2']?.toString() ?? '',
      locationLn2: json['location_ln_2']?.toString() ?? '',
      attention: json['attention']?.toString() ?? '',
      billingStreet: json['billing_street']?.toString() ?? '',
      billingStreetLn2: json['billing_street_ln_2']?.toString() ?? '',
      locationStreet: json['location_street']?.toString() ?? '',
      locationStreetLn2: json['location_street_ln_2']?.toString() ?? '',
      billingCityState: json['billing_city_state']?.toString() ?? '',
      billingCityStateLn2: json['billing_city_state_ln_2']?.toString() ?? '',
      locationCityState: json['location_city_state']?.toString() ?? '',
      locationCityStateLn2: json['location_city_state_ln_2']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      inspectionFrequency: json['inspection_frequency']?.toString() ?? '',
      inspectionNumber: json['inspection_number']?.toString() ?? '',
      isTheBuildingOccupied: json['is_the_building_occupied']?.toString() ?? '',
      areAllSystemsInService:
          json['are_all_systems_in_service']?.toString() ?? '',
      areFpSystemsSameAsLastInspection:
          json['are_fp_systems_same_as_last_inspection']?.toString() ?? '',
      hydraulicNameplateSecurelyAttachedAndLegible:
          json['hydraulic_nameplate_securely_attached_and_legible']
              ?.toString() ??
          '',
      wasAMainDrainWaterFlowTestConducted:
          json['was_a_main_drain_water_flow_test_conducted']?.toString() ?? '',
      areAllSprinklerSystemMainControlValvesOpen:
          json['are_all_sprinkler_system_main_control_valves_open']
              ?.toString() ??
          '',
      areAllOtherValvesInProperPosition:
          json['are_all_other_valves_in_proper_position']?.toString() ?? '',
      areAllControlValvesSealedOrSupervised:
          json['are_all_control_valves_sealed_or_supervised']?.toString() ?? '',
      areAllControlValvesInGoodConditionAndFreeOfLeaks:
          json['are_all_control_valves_in_good_condition_and_free_of_leaks']
              ?.toString() ??
          '',
      areFireDepartmentConnectionsInSatisfactoryCondition:
          json['are_fire_department_connections_in_satisfactory_condition']
              ?.toString() ??
          '',
      areCapsInPlace: json['are_caps_in_place']?.toString() ?? '',
      isFireDepartmentConnectionEasilyAccessible:
          json['is_fire_department_connection_easily_accessible']?.toString() ??
          '',
      automaticDrainValeInPlace:
          json['automatic_drain_valve_in_place']?.toString() ?? '',
      isThePumpRoomHeated: json['is_the_pump_room_heated']?.toString() ?? '',
      isTheFirePumpInService:
          json['is_the_fire_pump_in_service']?.toString() ?? '',
      wasFirePumpRunDuringThisInspection:
          json['was_fire_pump_run_during_this_inspection']?.toString() ?? '',
      wasThePumpStartedInTheAutomaticModeByAPressureDrop:
          json['was_the_pump_started_in_the_automatic_mode_by_a_pressure_drop']
              ?.toString() ??
          '',
      wereThePumpBearingsLubricated:
          json['were_the_pump_bearings_lubricated']?.toString() ?? '',
      jockeyPumpStartPressurePSI:
          json['jockey_pump_start_pressure_psi']?.toString() ?? '',
      jockeyPumpStartPressure:
          json['jockey_pump_start_pressure']?.toString() ?? '',
      jockeyPumpStopPressurePSI:
          json['jockey_pump_stop_pressure_psi']?.toString() ?? '',
      jockeyPumpStopPressure:
          json['jockey_pump_stop_pressure']?.toString() ?? '',
      firePumpStartPressurePSI:
          json['fire_pump_start_pressure_psi']?.toString() ?? '',
      firePumpStartPressure: json['fire_pump_start_pressure']?.toString() ?? '',
      firePumpStopPressurePSI:
          json['fire_pump_stop_pressure_psi']?.toString() ?? '',
      firePumpStopPressure: json['fire_pump_stop_pressure']?.toString() ?? '',
      isTheFuelTankAtLeast2_3Full:
          json['is_the_fuel_tank_at_least_2_3_full']?.toString() ?? '',
      isEngineOilAtCorrectLevel:
          json['is_engine_oil_at_correct_level']?.toString() ?? '',
      isEngineCoolantAtCorrectLevel:
          json['is_engine_coolant_at_correct_level']?.toString() ?? '',
      isTheEngineBlockHeaterWorking:
          json['is_the_engine_block_heater_working']?.toString() ?? '',
      isPumpRoomVentilationOperatingProperly:
          json['is_pump_room_ventilation_operating_properly']?.toString() ?? '',
      wasWaterDischargeObservedFromHeatExchangerReturnLine:
          json['was_water_discharge_observed_from_heat_exchanger_return_line']
              ?.toString() ??
          '',
      wasCoolingLineStrainerCleanedAfterTest:
          json['was_cooling_line_strainer_cleaned_after_test']?.toString() ??
          '',
      wasPumpRunForAtLeast30Minutes:
          json['was_pump_run_for_at_least_30_minutes']?.toString() ?? '',
      doesTheSwitchInAutoAlarmWork:
          json['does_the_switch_in_auto_alarm_work']?.toString() ?? '',
      doesThePumpRunningAlarmWork:
          json['does_the_pump_running_alarm_work']?.toString() ?? '',
      doesTheCommonAlarmWork:
          json['does_the_common_alarm_work']?.toString() ?? '',
      wasCasingReliefValveOperatingProperly:
          json['was_casing_relief_valve_operating_properly']?.toString() ?? '',
      wasPumpRunForAtLeast10Minutes:
          json['was_pump_run_for_at_least_10_minutes']?.toString() ?? '',
      doesTheLossOfPowerAlarmWork:
          json['does_the_loss_of_power_alarm_work']?.toString() ?? '',
      doesTheElectricPumpRunningAlarmWork:
          json['does_the_electric_pump_running_alarm_work']?.toString() ?? '',
      powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad:
          json['power_failure_condition_simulated_while_pump_operating_at_peak_']
              ?.toString() ??
          '',
      trasferOfPowerToAlternativePowerSourceVerified:
          json['transfer_of_power_to_alternative_power_source_verified']
              ?.toString() ??
          '',
      powerFaulureConditionRemoved:
          json['power_failure_condition_removed']?.toString() ?? '',
      pumpReconnectedToNormalPowerSourceAfterATimeDelay:
          json['pump_reconnected_to_normal_power_source_after_a_time_delay']
              ?.toString() ??
          '',
      haveAntiFreezeSystemsBeenTested:
          json['have_anti_freeze_systems_been_tested']?.toString() ?? '',
      freezeProtectionInDegreesF:
          json['freeze_protection_in_degrees_f']?.toString() ?? '',
      areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition:
          json['are_alarm_valves_water_flow_devices_and_retards_in_satisfactory']
              ?.toString() ??
          '',
      waterFlowAlarmTestConductedWithInspectorsTest:
          json['water_flow_alarm_test_conducted_with_inspectors_test']
              ?.toString() ??
          '',
      waterFlowAlarmTestConductedWithBypassConnection:
          json['water_flow_alarm_test_conducted_with_bypass_connection']
              ?.toString() ??
          '',
      isDryValveInServiceAndInGoodCondition:
          json['is_dry_valve_in_service_and_in_good_condition']?.toString() ??
          '',
      isDryValveItermediateChamberNotLeaking:
          json['is_dry_valve_itermediate_chamber_not_leaking']?.toString() ??
          '',
      hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears:
          json['has_the_dry_system_been_fully_tripped_within_the_last_three_yea']
              ?.toString() ??
          '',
      areQuickOpeningDeviceControlValvesOpen:
          json['are_quick_opening_device_control_valves_open']?.toString() ??
          '',
      isThereAListOfKnownLowPointDrainsAtTheRiser:
          json['is_there_a_list_of_known_low_point_drains_at_the_riser']
              ?.toString() ??
          '',
      haveKnownLowPointsBeenDrained:
          json['have_known_low_points_been_drained']?.toString() ?? '',
      isOilLevelFullOnAirCompressor:
          json['is_oil_level_full_on_air_compressor']?.toString() ?? '',
      doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder:
          json['does_the_air_compressor_return_system_pressure_in_30_minutes_or']
              ?.toString() ??
          '',
      whatPressureDoesAirCompressorStartPSI:
          json['what_pressure_does_air_compressor_start_psi']?.toString() ?? '',
      whatPressureDoesAirCompressorStart:
          json['what_pressure_does_air_compressor_start']?.toString() ?? '',
      whatPressureDoesAirCompressorStopPSI:
          json['what_pressure_does_air_compressor_stop_psi']?.toString() ?? '',
      whatPressureDoesAirCompressorStop:
          json['what_pressure_does_air_compressor_stop']?.toString() ?? '',
      didLowAirAlarmOperatePSI:
          json['did_low_air_alarm_operate_psi']?.toString() ?? '',
      didLowAirAlarmOperate:
          json['did_low_air_alarm_operate']?.toString() ?? '',
      dateOfLastFullTripTest:
          json['date_of_last_full_trip_test']?.toString() ?? '',
      dateOfLastInternalInspection:
          json['date_of_last_internal_inspection']?.toString() ?? '',
      areValvesInServiceAndInGoodCondition:
          json['are_valves_in_service_and_in_good_condition']?.toString() ?? '',
      wereValvesTripped: json['were_valves_tripped']?.toString() ?? '',
      whatPressureDidPneumaticActuatorTripPSI:
          json['what_pressure_did_pneumatic_actuator_trip_psi']?.toString() ??
          '',
      whatPressureDidPneumaticActuatorTrip:
          json['what_pressure_did_pneumatic_actuator_trip']?.toString() ?? '',
      wasPrimingLineLeftOnAfterTest:
          json['was_priming_line_left_on_after_test']?.toString() ?? '',
      whatPressureDoesPreactionAirCompressorStartPSI:
          json['what_pressure_does_preaction_air_compressor_start_psi']
              ?.toString() ??
          '',
      whatPressureDoesPreactionAirCompressorStart:
          json['what_pressure_does_preaction_air_compressor_start']
              ?.toString() ??
          '',
      whatPressureDoesPreactionAirCompressorStopPSI:
          json['what_pressure_does_preaction_air_compressor_stop_psi']
              ?.toString() ??
          '',
      whatPressureDoesPreactionAirCompressorStop:
          json['what_pressure_does_preaction_air_compressor_stop']
              ?.toString() ??
          '',
      didPreactionLowAirAlarmOperatePSI:
          json['did_preaction_low_air_alarm_operate_psi']?.toString() ?? '',
      didPreactionLowAirAlarmOperate:
          json['did_preaction_low_air_alarm_operate']?.toString() ?? '',
      doesWaterMotorGongWork:
          json['does_water_motor_gong_work']?.toString() ?? '',
      doesElectricBellWork: json['does_electric_bell_work']?.toString() ?? '',
      areWaterFlowAlarmsOperational:
          json['are_water_flow_alarms_operational']?.toString() ?? '',
      areAllTamperSwitchesOperational:
          json['are_all_tamper_switches_operational']?.toString() ?? '',
      didAlarmPanelClearAfterTest:
          json['did_alarm_panel_clear_after_test']?.toString() ?? '',
      areAMinimumOf6SpareSprinklersReadilyAvaiable:
          json['are_a_minimum_of_6_spare_sprinklers_readily_avaiable']
              ?.toString() ??
          '',
      isConditionOfPipingAndOtherSystemComponentsSatisfactory:
          json['is_condition_of_piping_and_other_system_componets_satisfactory']
              ?.toString() ??
          '',
      areKnownDryTypeHeadsLessThan10YearsOld:
          json['are_known_dry_type_heads_less_than_10_years_old']?.toString() ??
          '',
      areKnownDryTypeHeadsLessThan10YearsOldYear:
          json['are_known_dry_type_heads_less_than_10_years_old_year']
              ?.toString() ??
          '',
      areKnownQuickResponseHeadsLessThan20YearsOld:
          json['are_known_quick_response_heads_less_than_20_years_old']
              ?.toString() ??
          '',
      areKnownQuickResponseHeadsLessThan20YearsOldYear:
          json['are_known_quick_response_heads_less_than_20_years_old_year']
              ?.toString() ??
          '',
      areKnownStandardResponseHeadsLessThan50YearsOld:
          json['are_known_standard_response_heads_less_than_50_years_old']
              ?.toString() ??
          '',
      areKnownStandardResponseHeadsLessThan50YearsOldYear:
          json['are_known_standard_response_heads_less_than_50_years_old_year']
              ?.toString() ??
          '',
      haveAllGaugesBeenTestedOrReplacedInTheLast5Years:
          json['have_all_gauges_been_tested_or_replaced_in_the_last_5_years']
              ?.toString() ??
          '',
      haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear:
          json['have_all_gauges_been_tested_or_replaced_in_the_last_5_years_yea']
              ?.toString() ??
          '',
      system1Name: json['system_1_name']?.toString() ?? '',
      system1DrainSize: json['system_1_drain_size']?.toString() ?? '',
      system1StaticPSI: json['system_1_static_psi']?.toString() ?? '',
      system1ResidualPSI: json['system_1_residual_psi']?.toString() ?? '',
      system2Name: json['system_2_name']?.toString() ?? '',
      system2DrainSize: json['system_2_drain_size']?.toString() ?? '',
      system2StaticPSI: json['system_2_static_psi']?.toString() ?? '',
      system2ResidualPSI: json['system_2_residual_psi']?.toString() ?? '',
      system3Name: json['system_3_name']?.toString() ?? '',
      system3DrainSize: json['system_3_drain_size']?.toString() ?? '',
      system3StaticPSI: json['system_3_static_psi']?.toString() ?? '',
      system3ResidualPSI: json['system_3_residual_psi']?.toString() ?? '',
      system4Name: json['system_4_name']?.toString() ?? '',
      system4DrainSize: json['system_4_drain_size']?.toString() ?? '',
      system4StaticPSI: json['system_4_static_psi']?.toString() ?? '',
      system4ResidualPSI: json['system_4_residual_psi']?.toString() ?? '',
      system5Name: json['system_5_name']?.toString() ?? '',
      system5DrainSize: json['system_5_drain_size']?.toString() ?? '',
      system5StaticPSI: json['system_5_static_psi']?.toString() ?? '',
      system5ResidualPSI: json['system_5_residual_psi']?.toString() ?? '',
      system6Name: json['system_6_name']?.toString() ?? '',
      system6DrainSize: json['system_6_drain_size']?.toString() ?? '',
      system6StaticPSI: json['system_6_static_psi']?.toString() ?? '',
      system6ResidualPSI: json['system_6_residual_psi']?.toString() ?? '',
      drainTestNotes: json['drain_test_notes']?.toString() ?? '',
      device1Name: json['device_1_name']?.toString() ?? '',
      device1Address: json['device_1_address']?.toString() ?? '',
      device1DescriptionLocation:
          json['device_1_description_location']?.toString() ?? '',
      device1Operated: json['device_1_operated']?.toString() ?? '',
      device1DelaySec: _parseDouble(json['device_1_delay_sec']),
      device2Name: json['device_2_name']?.toString() ?? '',
      device2Address: json['device_2_address']?.toString() ?? '',
      device2DescriptionLocation:
          json['device_2_description_location']?.toString() ?? '',
      device2Operated: json['device_2_operated']?.toString() ?? '',
      device2DelaySec: _parseDouble(json['device_2_delay_sec']),
      device3Name: json['device_3_name']?.toString() ?? '',
      device3Address: json['device_3_address']?.toString() ?? '',
      device3DescriptionLocation:
          json['device_3_description_location']?.toString() ?? '',
      device3Operated: json['device_3_operated']?.toString() ?? '',
      device3DelaySec: _parseDouble(json['device_3_delay_sec']),
      device4Name: json['device_4_name']?.toString() ?? '',
      device4Address: json['device_4_address']?.toString() ?? '',
      device4DescriptionLocation:
          json['device_4_description_location']?.toString() ?? '',
      device4Operated: json['device_4_operated']?.toString() ?? '',
      device4DelaySec: _parseDouble(json['device_4_delay_sec']),
      device5Name: json['device_5_name']?.toString() ?? '',
      device5Address: json['device_5_address']?.toString() ?? '',
      device5DescriptionLocation:
          json['device_5_description_location']?.toString() ?? '',
      device5Operated: json['device_5_operated']?.toString() ?? '',
      device5DelaySec: _parseDouble(json['device_5_delay_sec']),
      device6Name: json['device_6_name']?.toString() ?? '',
      device6Address: json['device_6_address']?.toString() ?? '',
      device6DescriptionLocation:
          json['device_6_description_location']?.toString() ?? '',
      device6Operated: json['device_6_operated']?.toString() ?? '',
      device6DelaySec: _parseDouble(json['device_6_delay_sec']),
      device7Name: json['device_7_name']?.toString() ?? '',
      device7Address: json['device_7_address']?.toString() ?? '',
      device7DescriptionLocation:
          json['device_7_description_location']?.toString() ?? '',
      device7Operated: json['device_7_operated']?.toString() ?? '',
      device7DelaySec: _parseDouble(json['device_7_delay_sec']),
      device8Name: json['device_8_name']?.toString() ?? '',
      device8Address: json['device_8_address']?.toString() ?? '',
      device8DescriptionLocation:
          json['device_8_description_location']?.toString() ?? '',
      device8Operated: json['device_8_operated']?.toString() ?? '',
      device8DelaySec: _parseDouble(json['device_8_delay_sec']),
      device9Name: json['device_9_name']?.toString() ?? '',
      device9Address: json['device_9_address']?.toString() ?? '',
      device9DescriptionLocation:
          json['device_9_description_location']?.toString() ?? '',
      device9Operated: json['device_9_operated']?.toString() ?? '',
      device9DelaySec: _parseDouble(json['device_9_delay_sec']),
      device10Name: json['device_10_name']?.toString() ?? '',
      device10Address: json['device_10_address']?.toString() ?? '',
      device10DescriptionLocation:
          json['device_10_description_location']?.toString() ?? '',
      device10Operated: json['device_10_operated']?.toString() ?? '',
      device10DelaySec: _parseDouble(json['device_10_delay_sec']),
      device11Name: json['device_11_name']?.toString() ?? '',
      device11Address: json['device_11_address']?.toString() ?? '',
      device11DescriptionLocation:
          json['device_11_description_location']?.toString() ?? '',
      device11Operated: json['device_11_operated']?.toString() ?? '',
      device11DelaySec: _parseDouble(json['device_11_delay_sec']),
      device12Name: json['device_12_name']?.toString() ?? '',
      device12Address: json['device_12_address']?.toString() ?? '',
      device12DescriptionLocation:
          json['device_12_description_location']?.toString() ?? '',
      device12Operated: json['device_12_operated']?.toString() ?? '',
      device12DelaySec: _parseDouble(json['device_12_delay_sec']),
      device13Name: json['device_13_name']?.toString() ?? '',
      device13Address: json['device_13_address']?.toString() ?? '',
      device13DescriptionLocation:
          json['device_13_description_location']?.toString() ?? '',
      device13Operated: json['device_13_operated']?.toString() ?? '',
      device13DelaySec: _parseDouble(json['device_13_delay_sec']),
      device14Name: json['device_14_name']?.toString() ?? '',
      device14Address: json['device_14_address']?.toString() ?? '',
      device14DescriptionLocation:
          json['device_14_description_location']?.toString() ?? '',
      device14Operated: json['device_14_operated']?.toString() ?? '',
      device14DelaySec: _parseDouble(json['device_14_delay_sec']),
      adjustmentsOrCorrectionsMake:
          json['adjustments_or_corrections_make']?.toString() ?? '',
      explanationOfAnyNoAnswers:
          json['explanation_of_any_no_answers']?.toString() ?? '',
      explanationOfAnyNoAnswersContinued:
          json['explanation_of_any_no_answers_continued']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }
}
