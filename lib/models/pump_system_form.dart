// lib/models/pump_system_form.dart

class PumpSystemForm {
  final String pdfPath;
  final String reportTo;
  final String building;
  final String attention;
  final String street;
  final String inspector;
  final String cityState;
  final String date;
  final String pumpMake;
  final int? pumpRatedRPM;
  final String pumpModel;
  final double? pumpRatedGPM;
  final String pumpSerialNumber;
  final double? pumpMaxPSI;
  final String pumpPower;
  final double? pumpRatedPSI;
  final String pumpWaterSupply;
  final double? pumpPSIAt150Percent;
  final String pumpControllerMake;
  final String pumpControllerVoltage;
  final String pumpControllerModel;
  final String pumpControllerHorsePower;
  final String pumpControllerSerialNumber;
  final String pumpControllerSupervision;
  final String dieselEngineMake;
  final String dieselEngineSerialNumber;
  final String dieselEngineModel;
  final double? dieselEngineHours;
  final String flowTestOrificeSize1;
  final String flowTestOrificeSize2;
  final String flowTestOrificeSize3;
  final String flowTestOrificeSize4;
  final String flowTestOrificeSize5;
  final String flowTestOrificeSize6;
  final String flowTestOrificeSize7;
  final double? flowTest1SuctionPSI;
  final double? flowTest1DischargePSI;
  final double? flowTest1NetPSI;
  final int? flowTest1RPM;
  final double? flowTest1O1Pitot;
  final double? flowTest1O2Pitot;
  final double? flowTest1O3Pitot;
  final double? flowTest1O4Pitot;
  final double? flowTest1O5Pitot;
  final double? flowTest1O6Pitot;
  final double? flowTest1O7Pitot;
  final double? flowTest1O1GPM;
  final double? flowTest1O2GPM;
  final double? flowTest1O3GPM;
  final double? flowTest1O4GPM;
  final double? flowTest1O5GPM;
  final double? flowTest1O6GPM;
  final double? flowTest1O7GPM;
  final double? flowTest1TotalFlow;
  final double? flowTest2SuctionPSI;
  final double? flowTest2DischargePSI;
  final double? flowTest2NetPSI;
  final int? flowTest2RPM;
  final double? flowTest2O1Pitot;
  final double? flowTest2O2Pitot;
  final double? flowTest2O3Pitot;
  final double? flowTest2O4Pitot;
  final double? flowTest2O5Pitot;
  final double? flowTest2O6Pitot;
  final double? flowTest2O7Pitot;
  final double? flowTest2O1GPM;
  final double? flowTest2O2GPM;
  final double? flowTest2O3GPM;
  final double? flowTest2O4GPM;
  final double? flowTest2O5GPM;
  final double? flowTest2O6GPM;
  final double? flowTest2O7GPM;
  final double? flowTest2TotalFlow;
  final double? flowTest3SuctionPSI;
  final double? flowTest3DischargePSI;
  final double? flowTest3NetPSI;
  final int? flowTest3RPM;
  final double? flowTest3O1Pitot;
  final double? flowTest3O2Pitot;
  final double? flowTest3O3Pitot;
  final double? flowTest3O4Pitot;
  final double? flowTest3O5Pitot;
  final double? flowTest3O6Pitot;
  final double? flowTest3O7Pitot;
  final double? flowTest3O1GPM;
  final double? flowTest3O2GPM;
  final double? flowTest3O3GPM;
  final double? flowTest3O4GPM;
  final double? flowTest3O5GPM;
  final double? flowTest3O6GPM;
  final double? flowTest3O7GPM;
  final double? flowTest3TotalFlow;
  final double? flowTest4SuctionPSI;
  final double? flowTest4DischargePSI;
  final double? flowTest4NetPSI;
  final int? flowTest4RPM;
  final double? flowTest4O1Pitot;
  final double? flowTest4O2Pitot;
  final double? flowTest4O3Pitot;
  final double? flowTest4O4Pitot;
  final double? flowTest4O5Pitot;
  final double? flowTest4O6Pitot;
  final double? flowTest4O7Pitot;
  final double? flowTest4O1GPM;
  final double? flowTest4O2GPM;
  final double? flowTest4O3GPM;
  final double? flowTest4O4GPM;
  final double? flowTest4O5GPM;
  final double? flowTest4O6GPM;
  final double? flowTest4O7GPM;
  final double? flowTest4TotalFlow;
  final String remarksOnTest;

  PumpSystemForm({
    required this.pdfPath,
    required this.reportTo,
    required this.building,
    required this.attention,
    required this.street,
    required this.inspector,
    required this.cityState,
    required this.date,
    required this.pumpMake,
    required this.pumpRatedRPM,
    required this.pumpModel,
    required this.pumpRatedGPM,
    required this.pumpSerialNumber,
    required this.pumpMaxPSI,
    required this.pumpPower,
    required this.pumpRatedPSI,
    required this.pumpWaterSupply,
    required this.pumpPSIAt150Percent,
    required this.pumpControllerMake,
    required this.pumpControllerVoltage,
    required this.pumpControllerModel,
    required this.pumpControllerHorsePower,
    required this.pumpControllerSerialNumber,
    required this.pumpControllerSupervision,
    required this.dieselEngineMake,
    required this.dieselEngineSerialNumber,
    required this.dieselEngineModel,
    required this.dieselEngineHours,
    required this.flowTestOrificeSize1,
    required this.flowTestOrificeSize2,
    required this.flowTestOrificeSize3,
    required this.flowTestOrificeSize4,
    required this.flowTestOrificeSize5,
    required this.flowTestOrificeSize6,
    required this.flowTestOrificeSize7,
    required this.flowTest1SuctionPSI,
    required this.flowTest1DischargePSI,
    required this.flowTest1NetPSI,
    required this.flowTest1RPM,
    required this.flowTest1O1Pitot,
    required this.flowTest1O2Pitot,
    required this.flowTest1O3Pitot,
    required this.flowTest1O4Pitot,
    required this.flowTest1O5Pitot,
    required this.flowTest1O6Pitot,
    required this.flowTest1O7Pitot,
    required this.flowTest1O1GPM,
    required this.flowTest1O2GPM,
    required this.flowTest1O3GPM,
    required this.flowTest1O4GPM,
    required this.flowTest1O5GPM,
    required this.flowTest1O6GPM,
    required this.flowTest1O7GPM,
    required this.flowTest1TotalFlow,
    required this.flowTest2SuctionPSI,
    required this.flowTest2DischargePSI,
    required this.flowTest2NetPSI,
    required this.flowTest2RPM,
    required this.flowTest2O1Pitot,
    required this.flowTest2O2Pitot,
    required this.flowTest2O3Pitot,
    required this.flowTest2O4Pitot,
    required this.flowTest2O5Pitot,
    required this.flowTest2O6Pitot,
    required this.flowTest2O7Pitot,
    required this.flowTest2O1GPM,
    required this.flowTest2O2GPM,
    required this.flowTest2O3GPM,
    required this.flowTest2O4GPM,
    required this.flowTest2O5GPM,
    required this.flowTest2O6GPM,
    required this.flowTest2O7GPM,
    required this.flowTest2TotalFlow,
    required this.flowTest3SuctionPSI,
    required this.flowTest3DischargePSI,
    required this.flowTest3NetPSI,
    required this.flowTest3RPM,
    required this.flowTest3O1Pitot,
    required this.flowTest3O2Pitot,
    required this.flowTest3O3Pitot,
    required this.flowTest3O4Pitot,
    required this.flowTest3O5Pitot,
    required this.flowTest3O6Pitot,
    required this.flowTest3O7Pitot,
    required this.flowTest3O1GPM,
    required this.flowTest3O2GPM,
    required this.flowTest3O3GPM,
    required this.flowTest3O4GPM,
    required this.flowTest3O5GPM,
    required this.flowTest3O6GPM,
    required this.flowTest3O7GPM,
    required this.flowTest3TotalFlow,
    required this.flowTest4SuctionPSI,
    required this.flowTest4DischargePSI,
    required this.flowTest4NetPSI,
    required this.flowTest4RPM,
    required this.flowTest4O1Pitot,
    required this.flowTest4O2Pitot,
    required this.flowTest4O3Pitot,
    required this.flowTest4O4Pitot,
    required this.flowTest4O5Pitot,
    required this.flowTest4O6Pitot,
    required this.flowTest4O7Pitot,
    required this.flowTest4O1GPM,
    required this.flowTest4O2GPM,
    required this.flowTest4O3GPM,
    required this.flowTest4O4GPM,
    required this.flowTest4O5GPM,
    required this.flowTest4O6GPM,
    required this.flowTest4O7GPM,
    required this.flowTest4TotalFlow,
    required this.remarksOnTest,
  });

  factory PumpSystemForm.fromJson(Map<String, dynamic> json) {
    return PumpSystemForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      reportTo: json['report_to']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      attention: json['attention']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      cityState: json['city_state']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      pumpMake: json['pump_make']?.toString() ?? '',
      pumpRatedRPM: json['pump_rated_rpm'] != null 
          ? (json['pump_rated_rpm'] is String 
              ? int.tryParse(json['pump_rated_rpm'] as String)
              : json['pump_rated_rpm'] as int?)
          : null,
      pumpModel: json['pump_model']?.toString() ?? '',
      pumpRatedGPM: json['pump_rated_gpm'] != null
          ? (json['pump_rated_gpm'] is String
              ? double.tryParse(json['pump_rated_gpm'] as String)
              : (json['pump_rated_gpm'] as num?)?.toDouble())
          : null,
      pumpSerialNumber: json['pump_serial_number']?.toString() ?? '',
      pumpMaxPSI: json['pump_max_psi'] != null
          ? (json['pump_max_psi'] is String
              ? double.tryParse(json['pump_max_psi'] as String)
              : (json['pump_max_psi'] as num?)?.toDouble())
          : null,
      pumpPower: json['pump_power']?.toString() ?? '',
      pumpRatedPSI: json['pump_rated_psi'] != null
          ? (json['pump_rated_psi'] is String
              ? double.tryParse(json['pump_rated_psi'] as String)
              : (json['pump_rated_psi'] as num?)?.toDouble())
          : null,
      pumpWaterSupply: json['pump_water_supply']?.toString() ?? '',
      pumpPSIAt150Percent: json['pump_psi_at_150_percent'] != null
          ? (json['pump_psi_at_150_percent'] is String
              ? double.tryParse(json['pump_psi_at_150_percent'] as String)
              : (json['pump_psi_at_150_percent'] as num?)?.toDouble())
          : null,
      pumpControllerMake: json['pump_controller_make']?.toString() ?? '',
      pumpControllerVoltage: json['pump_controller_voltage']?.toString() ?? '',
      pumpControllerModel: json['pump_controller_model']?.toString() ?? '',
      pumpControllerHorsePower: json['pump_controller_horse_power']?.toString() ?? '',
      pumpControllerSerialNumber: json['pump_controller_serial_number']?.toString() ?? '',
      pumpControllerSupervision: json['pump_controller_supervision']?.toString() ?? '',
      dieselEngineMake: json['diesel_engine_make']?.toString() ?? '',
      dieselEngineSerialNumber: json['diesel_engine_serial_number']?.toString() ?? '',
      dieselEngineModel: json['diesel_engine_model']?.toString() ?? '',
      dieselEngineHours: json['diesel_engine_hours'] != null
          ? (json['diesel_engine_hours'] is String
              ? double.tryParse(json['diesel_engine_hours'] as String)
              : (json['diesel_engine_hours'] as num?)?.toDouble())
          : null,
      flowTestOrificeSize1: json['flow_test_orifice_size_1']?.toString() ?? '',
      flowTestOrificeSize2: json['flow_test_orifice_size_2']?.toString() ?? '',
      flowTestOrificeSize3: json['flow_test_orifice_size_3']?.toString() ?? '',
      flowTestOrificeSize4: json['flow_test_orifice_size_4']?.toString() ?? '',
      flowTestOrificeSize5: json['flow_test_orifice_size_5']?.toString() ?? '',
      flowTestOrificeSize6: json['flow_test_orifice_size_6']?.toString() ?? '',
      flowTestOrificeSize7: json['flow_test_orifice_size_7']?.toString() ?? '',
      flowTest1SuctionPSI: json['flow_test_1_suction_psi'] != null
          ? (json['flow_test_1_suction_psi'] is String
              ? double.tryParse(json['flow_test_1_suction_psi'] as String)
              : (json['flow_test_1_suction_psi'] as num?)?.toDouble())
          : null,
      flowTest1DischargePSI: json['flow_test_1_discharge_psi'] != null
          ? (json['flow_test_1_discharge_psi'] is String
              ? double.tryParse(json['flow_test_1_discharge_psi'] as String)
              : (json['flow_test_1_discharge_psi'] as num?)?.toDouble())
          : null,
      flowTest1NetPSI: json['flow_test_1_net_psi'] != null
          ? (json['flow_test_1_net_psi'] is String
              ? double.tryParse(json['flow_test_1_net_psi'] as String)
              : (json['flow_test_1_net_psi'] as num?)?.toDouble())
          : null,
      flowTest1RPM: json['flow_test_1_rpm'] != null 
          ? (json['flow_test_1_rpm'] is String 
              ? int.tryParse(json['flow_test_1_rpm'] as String)
              : json['flow_test_1_rpm'] as int?)
          : null,
      flowTest1O1Pitot: json['flow_test_1_o1_pitot'] != null ? (json['flow_test_1_o1_pitot'] is String ? double.tryParse(json['flow_test_1_o1_pitot'] as String) : (json['flow_test_1_o1_pitot'] as num?)?.toDouble()) : null,
      flowTest1O2Pitot: json['flow_test_1_o2_pitot'] != null ? (json['flow_test_1_o2_pitot'] is String ? double.tryParse(json['flow_test_1_o2_pitot'] as String) : (json['flow_test_1_o2_pitot'] as num?)?.toDouble()) : null,
      flowTest1O3Pitot: json['flow_test_1_o3_pitot'] != null ? (json['flow_test_1_o3_pitot'] is String ? double.tryParse(json['flow_test_1_o3_pitot'] as String) : (json['flow_test_1_o3_pitot'] as num?)?.toDouble()) : null,
      flowTest1O4Pitot: json['flow_test_1_o4_pitot'] != null ? (json['flow_test_1_o4_pitot'] is String ? double.tryParse(json['flow_test_1_o4_pitot'] as String) : (json['flow_test_1_o4_pitot'] as num?)?.toDouble()) : null,
      flowTest1O5Pitot: json['flow_test_1_o5_pitot'] != null ? (json['flow_test_1_o5_pitot'] is String ? double.tryParse(json['flow_test_1_o5_pitot'] as String) : (json['flow_test_1_o5_pitot'] as num?)?.toDouble()) : null,
      flowTest1O6Pitot: json['flow_test_1_o6_pitot'] != null ? (json['flow_test_1_o6_pitot'] is String ? double.tryParse(json['flow_test_1_o6_pitot'] as String) : (json['flow_test_1_o6_pitot'] as num?)?.toDouble()) : null,
      flowTest1O7Pitot: json['flow_test_1_o7_pitot'] != null ? (json['flow_test_1_o7_pitot'] is String ? double.tryParse(json['flow_test_1_o7_pitot'] as String) : (json['flow_test_1_o7_pitot'] as num?)?.toDouble()) : null,
      flowTest1O1GPM: json['flow_test_1_o1_gpm'] != null ? (json['flow_test_1_o1_gpm'] is String ? double.tryParse(json['flow_test_1_o1_gpm'] as String) : (json['flow_test_1_o1_gpm'] as num?)?.toDouble()) : null,
      flowTest1O2GPM: json['flow_test_1_o2_gpm'] != null ? (json['flow_test_1_o2_gpm'] is String ? double.tryParse(json['flow_test_1_o2_gpm'] as String) : (json['flow_test_1_o2_gpm'] as num?)?.toDouble()) : null,
      flowTest1O3GPM: json['flow_test_1_o3_gpm'] != null ? (json['flow_test_1_o3_gpm'] is String ? double.tryParse(json['flow_test_1_o3_gpm'] as String) : (json['flow_test_1_o3_gpm'] as num?)?.toDouble()) : null,
      flowTest1O4GPM: json['flow_test_1_o4_gpm'] != null ? (json['flow_test_1_o4_gpm'] is String ? double.tryParse(json['flow_test_1_o4_gpm'] as String) : (json['flow_test_1_o4_gpm'] as num?)?.toDouble()) : null,
      flowTest1O5GPM: json['flow_test_1_o5_gpm'] != null ? (json['flow_test_1_o5_gpm'] is String ? double.tryParse(json['flow_test_1_o5_gpm'] as String) : (json['flow_test_1_o5_gpm'] as num?)?.toDouble()) : null,
      flowTest1O6GPM: json['flow_test_1_o6_gpm'] != null ? (json['flow_test_1_o6_gpm'] is String ? double.tryParse(json['flow_test_1_o6_gpm'] as String) : (json['flow_test_1_o6_gpm'] as num?)?.toDouble()) : null,
      flowTest1O7GPM: json['flow_test_1_o7_gpm'] != null ? (json['flow_test_1_o7_gpm'] is String ? double.tryParse(json['flow_test_1_o7_gpm'] as String) : (json['flow_test_1_o7_gpm'] as num?)?.toDouble()) : null,
      flowTest1TotalFlow: json['flow_test_1_total_flow'] != null ? (json['flow_test_1_total_flow'] is String ? double.tryParse(json['flow_test_1_total_flow'] as String) : (json['flow_test_1_total_flow'] as num?)?.toDouble()) : null,
      flowTest2SuctionPSI: json['flow_test_2_suction_psi'] != null ? (json['flow_test_2_suction_psi'] is String ? double.tryParse(json['flow_test_2_suction_psi'] as String) : (json['flow_test_2_suction_psi'] as num?)?.toDouble()) : null,
      flowTest2DischargePSI: json['flow_test_2_discharge_psi'] != null ? (json['flow_test_2_discharge_psi'] is String ? double.tryParse(json['flow_test_2_discharge_psi'] as String) : (json['flow_test_2_discharge_psi'] as num?)?.toDouble()) : null,
      flowTest2NetPSI: json['flow_test_2_net_psi'] != null ? (json['flow_test_2_net_psi'] is String ? double.tryParse(json['flow_test_2_net_psi'] as String) : (json['flow_test_2_net_psi'] as num?)?.toDouble()) : null,
      flowTest2RPM: json['flow_test_2_rpm'] != null 
          ? (json['flow_test_2_rpm'] is String 
              ? int.tryParse(json['flow_test_2_rpm'] as String)
              : json['flow_test_2_rpm'] as int?)
          : null,
      flowTest2O1Pitot: json['flow_test_2_o1_pitot'] != null ? (json['flow_test_2_o1_pitot'] is String ? double.tryParse(json['flow_test_2_o1_pitot'] as String) : (json['flow_test_2_o1_pitot'] as num?)?.toDouble()) : null,
      flowTest2O2Pitot: json['flow_test_2_o2_pitot'] != null ? (json['flow_test_2_o2_pitot'] is String ? double.tryParse(json['flow_test_2_o2_pitot'] as String) : (json['flow_test_2_o2_pitot'] as num?)?.toDouble()) : null,
      flowTest2O3Pitot: json['flow_test_2_o3_pitot'] != null ? (json['flow_test_2_o3_pitot'] is String ? double.tryParse(json['flow_test_2_o3_pitot'] as String) : (json['flow_test_2_o3_pitot'] as num?)?.toDouble()) : null,
      flowTest2O4Pitot: json['flow_test_2_o4_pitot'] != null ? (json['flow_test_2_o4_pitot'] is String ? double.tryParse(json['flow_test_2_o4_pitot'] as String) : (json['flow_test_2_o4_pitot'] as num?)?.toDouble()) : null,
      flowTest2O5Pitot: json['flow_test_2_o5_pitot'] != null ? (json['flow_test_2_o5_pitot'] is String ? double.tryParse(json['flow_test_2_o5_pitot'] as String) : (json['flow_test_2_o5_pitot'] as num?)?.toDouble()) : null,
      flowTest2O6Pitot: json['flow_test_2_o6_pitot'] != null ? (json['flow_test_2_o6_pitot'] is String ? double.tryParse(json['flow_test_2_o6_pitot'] as String) : (json['flow_test_2_o6_pitot'] as num?)?.toDouble()) : null,
      flowTest2O7Pitot: json['flow_test_2_o7_pitot'] != null ? (json['flow_test_2_o7_pitot'] is String ? double.tryParse(json['flow_test_2_o7_pitot'] as String) : (json['flow_test_2_o7_pitot'] as num?)?.toDouble()) : null,
      flowTest2O1GPM: json['flow_test_2_o1_gpm'] != null ? (json['flow_test_2_o1_gpm'] is String ? double.tryParse(json['flow_test_2_o1_gpm'] as String) : (json['flow_test_2_o1_gpm'] as num?)?.toDouble()) : null,
      flowTest2O2GPM: json['flow_test_2_o2_gpm'] != null ? (json['flow_test_2_o2_gpm'] is String ? double.tryParse(json['flow_test_2_o2_gpm'] as String) : (json['flow_test_2_o2_gpm'] as num?)?.toDouble()) : null,
      flowTest2O3GPM: json['flow_test_2_o3_gpm'] != null ? (json['flow_test_2_o3_gpm'] is String ? double.tryParse(json['flow_test_2_o3_gpm'] as String) : (json['flow_test_2_o3_gpm'] as num?)?.toDouble()) : null,
      flowTest2O4GPM: json['flow_test_2_o4_gpm'] != null ? (json['flow_test_2_o4_gpm'] is String ? double.tryParse(json['flow_test_2_o4_gpm'] as String) : (json['flow_test_2_o4_gpm'] as num?)?.toDouble()) : null,
      flowTest2O5GPM: json['flow_test_2_o5_gpm'] != null ? (json['flow_test_2_o5_gpm'] is String ? double.tryParse(json['flow_test_2_o5_gpm'] as String) : (json['flow_test_2_o5_gpm'] as num?)?.toDouble()) : null,
      flowTest2O6GPM: json['flow_test_2_o6_gpm'] != null ? (json['flow_test_2_o6_gpm'] is String ? double.tryParse(json['flow_test_2_o6_gpm'] as String) : (json['flow_test_2_o6_gpm'] as num?)?.toDouble()) : null,
      flowTest2O7GPM: json['flow_test_2_o7_gpm'] != null ? (json['flow_test_2_o7_gpm'] is String ? double.tryParse(json['flow_test_2_o7_gpm'] as String) : (json['flow_test_2_o7_gpm'] as num?)?.toDouble()) : null,
      flowTest2TotalFlow: json['flow_test_2_total_flow'] != null ? (json['flow_test_2_total_flow'] is String ? double.tryParse(json['flow_test_2_total_flow'] as String) : (json['flow_test_2_total_flow'] as num?)?.toDouble()) : null,
      flowTest3SuctionPSI: json['flow_test_3_suction_psi'] != null ? (json['flow_test_3_suction_psi'] is String ? double.tryParse(json['flow_test_3_suction_psi'] as String) : (json['flow_test_3_suction_psi'] as num?)?.toDouble()) : null,
      flowTest3DischargePSI: json['flow_test_3_discharge_psi'] != null ? (json['flow_test_3_discharge_psi'] is String ? double.tryParse(json['flow_test_3_discharge_psi'] as String) : (json['flow_test_3_discharge_psi'] as num?)?.toDouble()) : null,
      flowTest3NetPSI: json['flow_test_3_net_psi'] != null ? (json['flow_test_3_net_psi'] is String ? double.tryParse(json['flow_test_3_net_psi'] as String) : (json['flow_test_3_net_psi'] as num?)?.toDouble()) : null,
      flowTest3RPM: json['flow_test_3_rpm'] != null 
          ? (json['flow_test_3_rpm'] is String 
              ? int.tryParse(json['flow_test_3_rpm'] as String)
              : json['flow_test_3_rpm'] as int?)
          : null,
      flowTest3O1Pitot: json['flow_test_3_o1_pitot'] != null ? (json['flow_test_3_o1_pitot'] is String ? double.tryParse(json['flow_test_3_o1_pitot'] as String) : (json['flow_test_3_o1_pitot'] as num?)?.toDouble()) : null,
      flowTest3O2Pitot: json['flow_test_3_o2_pitot'] != null ? (json['flow_test_3_o2_pitot'] is String ? double.tryParse(json['flow_test_3_o2_pitot'] as String) : (json['flow_test_3_o2_pitot'] as num?)?.toDouble()) : null,
      flowTest3O3Pitot: json['flow_test_3_o3_pitot'] != null ? (json['flow_test_3_o3_pitot'] is String ? double.tryParse(json['flow_test_3_o3_pitot'] as String) : (json['flow_test_3_o3_pitot'] as num?)?.toDouble()) : null,
      flowTest3O4Pitot: json['flow_test_3_o4_pitot'] != null ? (json['flow_test_3_o4_pitot'] is String ? double.tryParse(json['flow_test_3_o4_pitot'] as String) : (json['flow_test_3_o4_pitot'] as num?)?.toDouble()) : null,
      flowTest3O5Pitot: json['flow_test_3_o5_pitot'] != null ? (json['flow_test_3_o5_pitot'] is String ? double.tryParse(json['flow_test_3_o5_pitot'] as String) : (json['flow_test_3_o5_pitot'] as num?)?.toDouble()) : null,
      flowTest3O6Pitot: json['flow_test_3_o6_pitot'] != null ? (json['flow_test_3_o6_pitot'] is String ? double.tryParse(json['flow_test_3_o6_pitot'] as String) : (json['flow_test_3_o6_pitot'] as num?)?.toDouble()) : null,
      flowTest3O7Pitot: json['flow_test_3_o7_pitot'] != null ? (json['flow_test_3_o7_pitot'] is String ? double.tryParse(json['flow_test_3_o7_pitot'] as String) : (json['flow_test_3_o7_pitot'] as num?)?.toDouble()) : null,
      flowTest3O1GPM: json['flow_test_3_o1_gpm'] != null ? (json['flow_test_3_o1_gpm'] is String ? double.tryParse(json['flow_test_3_o1_gpm'] as String) : (json['flow_test_3_o1_gpm'] as num?)?.toDouble()) : null,
      flowTest3O2GPM: json['flow_test_3_o2_gpm'] != null ? (json['flow_test_3_o2_gpm'] is String ? double.tryParse(json['flow_test_3_o2_gpm'] as String) : (json['flow_test_3_o2_gpm'] as num?)?.toDouble()) : null,
      flowTest3O3GPM: json['flow_test_3_o3_gpm'] != null ? (json['flow_test_3_o3_gpm'] is String ? double.tryParse(json['flow_test_3_o3_gpm'] as String) : (json['flow_test_3_o3_gpm'] as num?)?.toDouble()) : null,
      flowTest3O4GPM: json['flow_test_3_o4_gpm'] != null ? (json['flow_test_3_o4_gpm'] is String ? double.tryParse(json['flow_test_3_o4_gpm'] as String) : (json['flow_test_3_o4_gpm'] as num?)?.toDouble()) : null,
      flowTest3O5GPM: json['flow_test_3_o5_gpm'] != null ? (json['flow_test_3_o5_gpm'] is String ? double.tryParse(json['flow_test_3_o5_gpm'] as String) : (json['flow_test_3_o5_gpm'] as num?)?.toDouble()) : null,
      flowTest3O6GPM: json['flow_test_3_o6_gpm'] != null ? (json['flow_test_3_o6_gpm'] is String ? double.tryParse(json['flow_test_3_o6_gpm'] as String) : (json['flow_test_3_o6_gpm'] as num?)?.toDouble()) : null,
      flowTest3O7GPM: json['flow_test_3_o7_gpm'] != null ? (json['flow_test_3_o7_gpm'] is String ? double.tryParse(json['flow_test_3_o7_gpm'] as String) : (json['flow_test_3_o7_gpm'] as num?)?.toDouble()) : null,
      flowTest3TotalFlow: json['flow_test_3_total_flow'] != null ? (json['flow_test_3_total_flow'] is String ? double.tryParse(json['flow_test_3_total_flow'] as String) : (json['flow_test_3_total_flow'] as num?)?.toDouble()) : null,
      flowTest4SuctionPSI: json['flow_test_4_suction_psi'] != null ? (json['flow_test_4_suction_psi'] is String ? double.tryParse(json['flow_test_4_suction_psi'] as String) : (json['flow_test_4_suction_psi'] as num?)?.toDouble()) : null,
      flowTest4DischargePSI: json['flow_test_4_discharge_psi'] != null ? (json['flow_test_4_discharge_psi'] is String ? double.tryParse(json['flow_test_4_discharge_psi'] as String) : (json['flow_test_4_discharge_psi'] as num?)?.toDouble()) : null,
      flowTest4NetPSI: json['flow_test_4_net_psi'] != null ? (json['flow_test_4_net_psi'] is String ? double.tryParse(json['flow_test_4_net_psi'] as String) : (json['flow_test_4_net_psi'] as num?)?.toDouble()) : null,
      flowTest4RPM: json['flow_test_4_rpm'] != null 
          ? (json['flow_test_4_rpm'] is String 
              ? int.tryParse(json['flow_test_4_rpm'] as String)
              : json['flow_test_4_rpm'] as int?)
          : null,
      flowTest4O1Pitot: json['flow_test_4_o1_pitot'] != null ? (json['flow_test_4_o1_pitot'] is String ? double.tryParse(json['flow_test_4_o1_pitot'] as String) : (json['flow_test_4_o1_pitot'] as num?)?.toDouble()) : null,
      flowTest4O2Pitot: json['flow_test_4_o2_pitot'] != null ? (json['flow_test_4_o2_pitot'] is String ? double.tryParse(json['flow_test_4_o2_pitot'] as String) : (json['flow_test_4_o2_pitot'] as num?)?.toDouble()) : null,
      flowTest4O3Pitot: json['flow_test_4_o3_pitot'] != null ? (json['flow_test_4_o3_pitot'] is String ? double.tryParse(json['flow_test_4_o3_pitot'] as String) : (json['flow_test_4_o3_pitot'] as num?)?.toDouble()) : null,
      flowTest4O4Pitot: json['flow_test_4_o4_pitot'] != null ? (json['flow_test_4_o4_pitot'] is String ? double.tryParse(json['flow_test_4_o4_pitot'] as String) : (json['flow_test_4_o4_pitot'] as num?)?.toDouble()) : null,
      flowTest4O5Pitot: json['flow_test_4_o5_pitot'] != null ? (json['flow_test_4_o5_pitot'] is String ? double.tryParse(json['flow_test_4_o5_pitot'] as String) : (json['flow_test_4_o5_pitot'] as num?)?.toDouble()) : null,
      flowTest4O6Pitot: json['flow_test_4_o6_pitot'] != null ? (json['flow_test_4_o6_pitot'] is String ? double.tryParse(json['flow_test_4_o6_pitot'] as String) : (json['flow_test_4_o6_pitot'] as num?)?.toDouble()) : null,
      flowTest4O7Pitot: json['flow_test_4_o7_pitot'] != null ? (json['flow_test_4_o7_pitot'] is String ? double.tryParse(json['flow_test_4_o7_pitot'] as String) : (json['flow_test_4_o7_pitot'] as num?)?.toDouble()) : null,
      flowTest4O1GPM: json['flow_test_4_o1_gpm'] != null ? (json['flow_test_4_o1_gpm'] is String ? double.tryParse(json['flow_test_4_o1_gpm'] as String) : (json['flow_test_4_o1_gpm'] as num?)?.toDouble()) : null,
      flowTest4O2GPM: json['flow_test_4_o2_gpm'] != null ? (json['flow_test_4_o2_gpm'] is String ? double.tryParse(json['flow_test_4_o2_gpm'] as String) : (json['flow_test_4_o2_gpm'] as num?)?.toDouble()) : null,
      flowTest4O3GPM: json['flow_test_4_o3_gpm'] != null ? (json['flow_test_4_o3_gpm'] is String ? double.tryParse(json['flow_test_4_o3_gpm'] as String) : (json['flow_test_4_o3_gpm'] as num?)?.toDouble()) : null,
      flowTest4O4GPM: json['flow_test_4_o4_gpm'] != null ? (json['flow_test_4_o4_gpm'] is String ? double.tryParse(json['flow_test_4_o4_gpm'] as String) : (json['flow_test_4_o4_gpm'] as num?)?.toDouble()) : null,
      flowTest4O5GPM: json['flow_test_4_o5_gpm'] != null ? (json['flow_test_4_o5_gpm'] is String ? double.tryParse(json['flow_test_4_o5_gpm'] as String) : (json['flow_test_4_o5_gpm'] as num?)?.toDouble()) : null,
      flowTest4O6GPM: json['flow_test_4_o6_gpm'] != null ? (json['flow_test_4_o6_gpm'] is String ? double.tryParse(json['flow_test_4_o6_gpm'] as String) : (json['flow_test_4_o6_gpm'] as num?)?.toDouble()) : null,
      flowTest4O7GPM: json['flow_test_4_o7_gpm'] != null ? (json['flow_test_4_o7_gpm'] is String ? double.tryParse(json['flow_test_4_o7_gpm'] as String) : (json['flow_test_4_o7_gpm'] as num?)?.toDouble()) : null,
      flowTest4TotalFlow: json['flow_test_4_total_flow'] != null ? (json['flow_test_4_total_flow'] is String ? double.tryParse(json['flow_test_4_total_flow'] as String) : (json['flow_test_4_total_flow'] as num?)?.toDouble()) : null,
      remarksOnTest: json['remarks_on_test']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_path': pdfPath,
      'report_to': reportTo,
      'building': building,
      'attention': attention,
      'street': street,
      'inspector': inspector,
      'city_state': cityState,
      'date': date,
      'pump_make': pumpMake,
      'pump_rated_rpm': pumpRatedRPM,
      'pump_model': pumpModel,
      'pump_rated_gpm': pumpRatedGPM,
      'pump_serial_number': pumpSerialNumber,
      'pump_max_psi': pumpMaxPSI,
      'pump_power': pumpPower,
      'pump_rated_psi': pumpRatedPSI,
      'pump_water_supply': pumpWaterSupply,
      'pump_psi_at_150_percent': pumpPSIAt150Percent,
      'pump_controller_make': pumpControllerMake,
      'pump_controller_voltage': pumpControllerVoltage,
      'pump_controller_model': pumpControllerModel,
      'pump_controller_horse_power': pumpControllerHorsePower,
      'pump_controller_serial_number': pumpControllerSerialNumber,
      'pump_controller_supervision': pumpControllerSupervision,
      'diesel_engine_make': dieselEngineMake,
      'diesel_engine_serial_number': dieselEngineSerialNumber,
      'diesel_engine_model': dieselEngineModel,
      'diesel_engine_hours': dieselEngineHours,
      'flow_test_orifice_size_1': flowTestOrificeSize1,
      'flow_test_orifice_size_2': flowTestOrificeSize2,
      'flow_test_orifice_size_3': flowTestOrificeSize3,
      'flow_test_orifice_size_4': flowTestOrificeSize4,
      'flow_test_orifice_size_5': flowTestOrificeSize5,
      'flow_test_orifice_size_6': flowTestOrificeSize6,
      'flow_test_orifice_size_7': flowTestOrificeSize7,
      'flow_test_1_suction_psi': flowTest1SuctionPSI,
      'flow_test_1_discharge_psi': flowTest1DischargePSI,
      'flow_test_1_net_psi': flowTest1NetPSI,
      'flow_test_1_rpm': flowTest1RPM,
      'flow_test_1_o1_pitot': flowTest1O1Pitot,
      'flow_test_1_o2_pitot': flowTest1O2Pitot,
      'flow_test_1_o3_pitot': flowTest1O3Pitot,
      'flow_test_1_o4_pitot': flowTest1O4Pitot,
      'flow_test_1_o5_pitot': flowTest1O5Pitot,
      'flow_test_1_o6_pitot': flowTest1O6Pitot,
      'flow_test_1_o7_pitot': flowTest1O7Pitot,
      'flow_test_1_o1_gpm': flowTest1O1GPM,
      'flow_test_1_o2_gpm': flowTest1O2GPM,
      'flow_test_1_o3_gpm': flowTest1O3GPM,
      'flow_test_1_o4_gpm': flowTest1O4GPM,
      'flow_test_1_o5_gpm': flowTest1O5GPM,
      'flow_test_1_o6_gpm': flowTest1O6GPM,
      'flow_test_1_o7_gpm': flowTest1O7GPM,
      'flow_test_1_total_flow': flowTest1TotalFlow,
      'flow_test_2_suction_psi': flowTest2SuctionPSI,
      'flow_test_2_discharge_psi': flowTest2DischargePSI,
      'flow_test_2_net_psi': flowTest2NetPSI,
      'flow_test_2_rpm': flowTest2RPM,
      'flow_test_2_o1_pitot': flowTest2O1Pitot,
      'flow_test_2_o2_pitot': flowTest2O2Pitot,
      'flow_test_2_o3_pitot': flowTest2O3Pitot,
      'flow_test_2_o4_pitot': flowTest2O4Pitot,
      'flow_test_2_o5_pitot': flowTest2O5Pitot,
      'flow_test_2_o6_pitot': flowTest2O6Pitot,
      'flow_test_2_o7_pitot': flowTest2O7Pitot,
      'flow_test_2_o1_gpm': flowTest2O1GPM,
      'flow_test_2_o2_gpm': flowTest2O2GPM,
      'flow_test_2_o3_gpm': flowTest2O3GPM,
      'flow_test_2_o4_gpm': flowTest2O4GPM,
      'flow_test_2_o5_gpm': flowTest2O5GPM,
      'flow_test_2_o6_gpm': flowTest2O6GPM,
      'flow_test_2_o7_gpm': flowTest2O7GPM,
      'flow_test_2_total_flow': flowTest2TotalFlow,
      'flow_test_3_suction_psi': flowTest3SuctionPSI,
      'flow_test_3_discharge_psi': flowTest3DischargePSI,
      'flow_test_3_net_psi': flowTest3NetPSI,
      'flow_test_3_rpm': flowTest3RPM,
      'flow_test_3_o1_pitot': flowTest3O1Pitot,
      'flow_test_3_o2_pitot': flowTest3O2Pitot,
      'flow_test_3_o3_pitot': flowTest3O3Pitot,
      'flow_test_3_o4_pitot': flowTest3O4Pitot,
      'flow_test_3_o5_pitot': flowTest3O5Pitot,
      'flow_test_3_o6_pitot': flowTest3O6Pitot,
      'flow_test_3_o7_pitot': flowTest3O7Pitot,
      'flow_test_3_o1_gpm': flowTest3O1GPM,
      'flow_test_3_o2_gpm': flowTest3O2GPM,
      'flow_test_3_o3_gpm': flowTest3O3GPM,
      'flow_test_3_o4_gpm': flowTest3O4GPM,
      'flow_test_3_o5_gpm': flowTest3O5GPM,
      'flow_test_3_o6_gpm': flowTest3O6GPM,
      'flow_test_3_o7_gpm': flowTest3O7GPM,
      'flow_test_3_total_flow': flowTest3TotalFlow,
      'flow_test_4_suction_psi': flowTest4SuctionPSI,
      'flow_test_4_discharge_psi': flowTest4DischargePSI,
      'flow_test_4_net_psi': flowTest4NetPSI,
      'flow_test_4_rpm': flowTest4RPM,
      'flow_test_4_o1_pitot': flowTest4O1Pitot,
      'flow_test_4_o2_pitot': flowTest4O2Pitot,
      'flow_test_4_o3_pitot': flowTest4O3Pitot,
      'flow_test_4_o4_pitot': flowTest4O4Pitot,
      'flow_test_4_o5_pitot': flowTest4O5Pitot,
      'flow_test_4_o6_pitot': flowTest4O6Pitot,
      'flow_test_4_o7_pitot': flowTest4O7Pitot,
      'flow_test_4_o1_gpm': flowTest4O1GPM,
      'flow_test_4_o2_gpm': flowTest4O2GPM,
      'flow_test_4_o3_gpm': flowTest4O3GPM,
      'flow_test_4_o4_gpm': flowTest4O4GPM,
      'flow_test_4_o5_gpm': flowTest4O5GPM,
      'flow_test_4_o6_gpm': flowTest4O6GPM,
      'flow_test_4_o7_gpm': flowTest4O7GPM,
      'flow_test_4_total_flow': flowTest4TotalFlow,
      'remarks_on_test': remarksOnTest,
    };
  }
}
