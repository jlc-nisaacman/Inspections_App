class InspectionSystems {
  // Fire Pump Subsections
  final FirePumpGeneral firePumpGeneral;
  final DieselFirePump dieselFirePump;
  final ElectricFirePump electricFirePump;
  
  // System Specific Details
  final WetSystems wetSystems;
  final DrySystems drySystems;
  final PreActionAndDelugeSystems preActionSystems;

  // Additional System Information
  final String lastFullTrip;
  final String lastInternal;

  InspectionSystems({
    required this.firePumpGeneral,
    required this.dieselFirePump,
    required this.electricFirePump,
    required this.wetSystems,
    required this.drySystems,
    required this.preActionSystems,
    required this.lastFullTrip,
    required this.lastInternal,
  });

  factory InspectionSystems.fromJson(Map<String, dynamic> json) {
    return InspectionSystems(
      firePumpGeneral: FirePumpGeneral.fromJson(json),
      dieselFirePump: DieselFirePump.fromJson(json),
      electricFirePump: ElectricFirePump.fromJson(json),
      wetSystems: WetSystems.fromJson(json),
      drySystems: DrySystems.fromJson(json),
      preActionSystems: PreActionAndDelugeSystems.fromJson(json),
      lastFullTrip: json['LASTFULLTRIP']?.toString() ?? '',
      lastInternal: json['LASTINTERNAL']?.toString() ?? '',
    );
  }
}

// Subsection Models
class FirePumpGeneral {
  final String isPumpRoomHeated;
  final String isFirePumpInService;
  final String wasFirePumpRunDuringInspection;
  final String wasPumpStartedInAutomaticMode;
  final String werePumpBearingsLubricated;
  final String jockeyPumpStartPressure;
  final String jockeyPumpStopPressure;
  final String firePumpStartPressure;
  final String firePumpStopPressure;

  FirePumpGeneral({
    required this.isPumpRoomHeated,
    required this.isFirePumpInService,
    required this.wasFirePumpRunDuringInspection,
    required this.wasPumpStartedInAutomaticMode,
    required this.werePumpBearingsLubricated,
    required this.jockeyPumpStartPressure,
    required this.jockeyPumpStopPressure,
    required this.firePumpStartPressure,
    required this.firePumpStopPressure,
  });

  factory FirePumpGeneral.fromJson(Map<String, dynamic> json) {
    return FirePumpGeneral(
      isPumpRoomHeated: json['5A']?.toString() ?? '',
      isFirePumpInService: json['5B']?.toString() ?? '',
      wasFirePumpRunDuringInspection: json['5C']?.toString() ?? '',
      wasPumpStartedInAutomaticMode: json['5D']?.toString() ?? '',
      werePumpBearingsLubricated: json['5E']?.toString() ?? '',
      jockeyPumpStartPressure: json['5FPSI']?.toString() ?? '',
      jockeyPumpStopPressure: json['5GPSI']?.toString() ?? '',
      firePumpStartPressure: json['5HPSI']?.toString() ?? '',
      firePumpStopPressure: json['5IPSI']?.toString() ?? '',
    );
  }
}

class DieselFirePump {
  final String isFuelTankAtLeast2_3Full;
  final String isEngineOilAtCorrectLevel;
  final String isEngineCoolantAtCorrectLevel;
  final String isEngineBlockHeaterWorking;
  final String isPumpRoomVentilationOperating;
  final String wasWaterDischargeObserved;
  final String wasCoolingLineStrainerCleaned;
  final String wasPumpRunFor30Minutes;
  final String doesAutoAlarmWork;
  final String doesPumpRunningAlarmWork;
  final String doesCommonAlarmWork;

  DieselFirePump({
    required this.isFuelTankAtLeast2_3Full,
    required this.isEngineOilAtCorrectLevel,
    required this.isEngineCoolantAtCorrectLevel,
    required this.isEngineBlockHeaterWorking,
    required this.isPumpRoomVentilationOperating,
    required this.wasWaterDischargeObserved,
    required this.wasCoolingLineStrainerCleaned,
    required this.wasPumpRunFor30Minutes,
    required this.doesAutoAlarmWork,
    required this.doesPumpRunningAlarmWork,
    required this.doesCommonAlarmWork,
  });

  factory DieselFirePump.fromJson(Map<String, dynamic> json) {
    return DieselFirePump(
      isFuelTankAtLeast2_3Full: json['6A']?.toString() ?? '',
      isEngineOilAtCorrectLevel: json['6B']?.toString() ?? '',
      isEngineCoolantAtCorrectLevel: json['6C']?.toString() ?? '',
      isEngineBlockHeaterWorking: json['6D']?.toString() ?? '',
      isPumpRoomVentilationOperating: json['6E']?.toString() ?? '',
      wasWaterDischargeObserved: json['6F']?.toString() ?? '',
      wasCoolingLineStrainerCleaned: json['6G']?.toString() ?? '',
      wasPumpRunFor30Minutes: json['6H']?.toString() ?? '',
      doesAutoAlarmWork: json['6I']?.toString() ?? '',
      doesPumpRunningAlarmWork: json['6J']?.toString() ?? '',
      doesCommonAlarmWork: json['6K']?.toString() ?? '',
    );
  }
}

class ElectricFirePump {
  final String wasCasingReliefValveOperating;
  final String wasPumpRunFor10Minutes;
  final String doesLossOfPowerAlarmWork;
  final String doesPumpRunningAlarmWork;
  final String wasPowerFailureSimulated;
  final String wasPowerTransferVerified;
  final String wasPowerFailureConditionRemoved;
  final String wasPumpReconnectedToNormalPower;

  ElectricFirePump({
    required this.wasCasingReliefValveOperating,
    required this.wasPumpRunFor10Minutes,
    required this.doesLossOfPowerAlarmWork,
    required this.doesPumpRunningAlarmWork,
    required this.wasPowerFailureSimulated,
    required this.wasPowerTransferVerified,
    required this.wasPowerFailureConditionRemoved,
    required this.wasPumpReconnectedToNormalPower,
  });

  factory ElectricFirePump.fromJson(Map<String, dynamic> json) {
    return ElectricFirePump(
      wasCasingReliefValveOperating: json['7A']?.toString() ?? '',
      wasPumpRunFor10Minutes: json['7B']?.toString() ?? '',
      doesLossOfPowerAlarmWork: json['7C']?.toString() ?? '',
      doesPumpRunningAlarmWork: json['7D']?.toString() ?? '',
      wasPowerFailureSimulated: json['7E']?.toString() ?? '',
      wasPowerTransferVerified: json['7F']?.toString() ?? '',
      wasPowerFailureConditionRemoved: json['7G']?.toString() ?? '',
      wasPumpReconnectedToNormalPower: json['7H']?.toString() ?? '',
    );
  }
}

class WetSystems {
  final String haveAntiFreezeSystemsBeerTested;
  final String freezeProtectionInFahrenheit;
  final String areAlarmValvesInSatisfactoryCondition;
  final String wasWaterFlowAlarmTestedWithInspectorTest;
  final String wasWaterFlowAlarmTestedWithBypassConnection;

  WetSystems({
    required this.haveAntiFreezeSystemsBeerTested,
    required this.freezeProtectionInFahrenheit,
    required this.areAlarmValvesInSatisfactoryCondition,
    required this.wasWaterFlowAlarmTestedWithInspectorTest,
    required this.wasWaterFlowAlarmTestedWithBypassConnection,
  });

  factory WetSystems.fromJson(Map<String, dynamic> json) {
    return WetSystems(
      haveAntiFreezeSystemsBeerTested: json['8A']?.toString() ?? '',
      freezeProtectionInFahrenheit: json['AFTEMP']?.toString() ?? '',
      areAlarmValvesInSatisfactoryCondition: json['8B']?.toString() ?? '',
      wasWaterFlowAlarmTestedWithInspectorTest: json['8C']?.toString() ?? '',
      wasWaterFlowAlarmTestedWithBypassConnection: json['8D']?.toString() ?? '',
    );
  }
}

class DrySystems {
  final String isDryValveInService;
  final String isDryPipeValveIntermediateChamberNotLeaking;
  final String areQuickOpeningDeviceControlValvesOpen;
  final String isThereAListOfKnownLowPointDrains;
  final String haveKnownLowPointsBeenDrained;
  final String isOilLevelFullOnAirCompressor;
  final String doesAirCompressorReturnSystemPressureIn30Minutes;
  final String airCompressorStartPressure;
  final String airCompressorStopPressure;
  final String didLowAirAlarmOperate;

  DrySystems({
    required this.isDryValveInService,
    required this.isDryPipeValveIntermediateChamberNotLeaking,
    required this.areQuickOpeningDeviceControlValvesOpen,
    required this.isThereAListOfKnownLowPointDrains,
    required this.haveKnownLowPointsBeenDrained,
    required this.isOilLevelFullOnAirCompressor,
    required this.doesAirCompressorReturnSystemPressureIn30Minutes,
    required this.airCompressorStartPressure,
    required this.airCompressorStopPressure,
    required this.didLowAirAlarmOperate,
  });

  factory DrySystems.fromJson(Map<String, dynamic> json) {
    return DrySystems(
      isDryValveInService: json['9A']?.toString() ?? '',
      isDryPipeValveIntermediateChamberNotLeaking: json['9B']?.toString() ?? '',
      areQuickOpeningDeviceControlValvesOpen: json['9C']?.toString() ?? '',
      isThereAListOfKnownLowPointDrains: json['9D']?.toString() ?? '',
      haveKnownLowPointsBeenDrained: json['9E']?.toString() ?? '',
      isOilLevelFullOnAirCompressor: json['9F']?.toString() ?? '',
      doesAirCompressorReturnSystemPressureIn30Minutes: json['9G']?.toString() ?? '',
      airCompressorStartPressure: json['9ISTARTPSI']?.toString() ?? '',
      airCompressorStopPressure: json['9JPSISTOP']?.toString() ?? '',
      didLowAirAlarmOperate: json['9KLOWAIR']?.toString() ?? '',
    );
  }
}

class PreActionAndDelugeSystems {
  final String areValvesInService;
  final String whereValvesTripped;
  final String pneumaticActuatorTripPressure;
  final String wasPrimingLineLeftOn;
  final String airCompressorStartPressure;
  final String airCompressorStopPressure;
  final String didLowAirAlarmOperate;

  PreActionAndDelugeSystems({
    required this.areValvesInService,
    required this.whereValvesTripped,
    required this.pneumaticActuatorTripPressure,
    required this.wasPrimingLineLeftOn,
    required this.airCompressorStartPressure,
    required this.airCompressorStopPressure,
    required this.didLowAirAlarmOperate,
  });

  factory PreActionAndDelugeSystems.fromJson(Map<String, dynamic> json) {
    return PreActionAndDelugeSystems(
      areValvesInService: json['10A']?.toString() ?? '',
      whereValvesTripped: json['10B']?.toString() ?? '',
      pneumaticActuatorTripPressure: json['10C PSI']?.toString() ?? '',
      wasPrimingLineLeftOn: json['10D']?.toString() ?? '',
      airCompressorStartPressure: json['10E PSI']?.toString() ?? '',
      airCompressorStopPressure: json['10F PSI']?.toString() ?? '',
      didLowAirAlarmOperate: json['10G PSI']?.toString() ?? '',
    );
  }
}