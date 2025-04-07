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
  final String pumpRatedRPM;
  final String pumpModel;
  final String pumpRatedGPM;
  final String pumpSerialNumber;
  final String pumpMaxPSI;
  final String pumpPower;
  final String pumpRatedPSI;
  final String pumpWaterSupply;
  final String pumpPSIAt150Percent;
  final String pumpControllerMake;
  final String pumpControllerVoltage;
  final String pumpControllerModel;
  final String pumpControllerHorsePower;
  final String pumpControllerSerialNumber;
  final String pumpControllerSupervision;
  final String dieselEngineMake;
  final String dieselEngineSerialNumber;
  final String dieselEngineModel;
  final String dieselEngineHours;
  final String flowTestOrificeSize1;
  final String flowTestOrificeSize2;
  final String flowTestOrificeSize3;
  final String flowTestOrificeSize4;
  final String flowTestOrificeSize5;
  final String flowTestOrificeSize6;
  final String flowTestOrificeSize7;
  final String flowTest1SuctionPSI;
  final String flowTest1DischargePSI;
  final String flowTest1NetPSI;
  final String flowTest1RPM;
  final String flowTest1O1Pitot;
  final String flowTest1O2Pitot;
  final String flowTest1O3Pitot;
  final String flowTest1O4Pitot;
  final String flowTest1O5Pitot;
  final String flowTest1O6Pitot;
  final String flowTest1O7Pitot;
  final String flowTest1O1GPM;
  final String flowTest1O2GPM;
  final String flowTest1O3GPM;
  final String flowTest1O4GPM;
  final String flowTest1O5GPM;
  final String flowTest1O6GPM;
  final String flowTest1O7GPM;
  final String flowTest1TotalFlow;
  final String flowTest2SuctionPSI;
  final String flowTest2DischargePSI;
  final String flowTest2NetPSI;
  final String flowTest2RPM;
  final String flowTest2O1Pitot;
  final String flowTest2O2Pitot;
  final String flowTest2O3Pitot;
  final String flowTest2O4Pitot;
  final String flowTest2O5Pitot;
  final String flowTest2O6Pitot;
  final String flowTest2O7Pitot;
  final String flowTest2O1GPM;
  final String flowTest2O2GPM;
  final String flowTest2O3GPM;
  final String flowTest2O4GPM;
  final String flowTest2O5GPM;
  final String flowTest2O6GPM;
  final String flowTest2O7GPM;
  final String flowTest2TotalFlow;
  final String flowTest3SuctionPSI;
  final String flowTest3DischargePSI;
  final String flowTest3NetPSI;
  final String flowTest3RPM;
  final String flowTest3O1Pitot;
  final String flowTest3O2Pitot;
  final String flowTest3O3Pitot;
  final String flowTest3O4Pitot;
  final String flowTest3O5Pitot;
  final String flowTest3O6Pitot;
  final String flowTest3O7Pitot;
  final String flowTest3O1GPM;
  final String flowTest3O2GPM;
  final String flowTest3O3GPM;
  final String flowTest3O4GPM;
  final String flowTest3O5GPM;
  final String flowTest3O6GPM;
  final String flowTest3O7GPM;
  final String flowTest3TotalFlow;
  final String flowTest4SuctionPSI;
  final String flowTest4DischargePSI;
  final String flowTest4NetPSI;
  final String flowTest4RPM;
  final String flowTest4O1Pitot;
  final String flowTest4O2Pitot;
  final String flowTest4O3Pitot;
  final String flowTest4O4Pitot;
  final String flowTest4O5Pitot;
  final String flowTest4O6Pitot;
  final String flowTest4O7Pitot;
  final String flowTest4O1GPM;
  final String flowTest4O2GPM;
  final String flowTest4O3GPM;
  final String flowTest4O4GPM;
  final String flowTest4O5GPM;
  final String flowTest4O6GPM;
  final String flowTest4O7GPM;
  final String flowTest4TotalFlow;
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
      pumpRatedRPM: json['pump_rated_rpm']?.toString() ?? '',
      pumpModel: json['pump_model']?.toString() ?? '',
      pumpRatedGPM: json['pump_rated_gpm']?.toString() ?? '',
      pumpSerialNumber: json['pump_serial_number']?.toString() ?? '',
      pumpMaxPSI: json['pump_max_psi']?.toString() ?? '',
      pumpPower: json['pump_power']?.toString() ?? '',
      pumpRatedPSI: json['pump_rated_psi']?.toString() ?? '',
      pumpWaterSupply: json['pump_water_supply']?.toString() ?? '',
      pumpPSIAt150Percent: json['pump_psi_at_150_percent']?.toString() ?? '',
      pumpControllerMake: json['pump_controller_make']?.toString() ?? '',
      pumpControllerVoltage: json['pump_controller_voltage']?.toString() ?? '',
      pumpControllerModel: json['pump_controller_model']?.toString() ?? '',
      pumpControllerHorsePower: json['pump_controller_horse_power']?.toString() ?? '',
      pumpControllerSerialNumber: json['pump_controller_serial_number']?.toString() ?? '',
      pumpControllerSupervision: json['pump_controller_supervision']?.toString() ?? '',
      dieselEngineMake: json['diesel_engine_make']?.toString() ?? '',
      dieselEngineSerialNumber: json['diesel_engine_serial_number']?.toString() ?? '',
      dieselEngineModel: json['diesel_engine_model']?.toString() ?? '',
      dieselEngineHours: json['diesel_engine_hours']?.toString() ?? '',
      flowTestOrificeSize1: json['flow_test_orifice_size_1']?.toString() ?? '',
      flowTestOrificeSize2: json['flow_test_orifice_size_2']?.toString() ?? '',
      flowTestOrificeSize3: json['flow_test_orifice_size_3']?.toString() ?? '',
      flowTestOrificeSize4: json['flow_test_orifice_size_4']?.toString() ?? '',
      flowTestOrificeSize5: json['flow_test_orifice_size_5']?.toString() ?? '',
      flowTestOrificeSize6: json['flow_test_orifice_size_6']?.toString() ?? '',
      flowTestOrificeSize7: json['flow_test_orifice_size_7']?.toString() ?? '',
      flowTest1SuctionPSI: json['flow_test_1_suction_psi']?.toString() ?? '',
      flowTest1DischargePSI: json['flow_test_1_discharge_psi']?.toString() ?? '',
      flowTest1NetPSI: json['flow_test_1_net_psi']?.toString() ?? '',
      flowTest1RPM: json['flow_test_1_rpm']?.toString() ?? '',
      flowTest1O1Pitot: json['flow_test_1_o1_pitot']?.toString() ?? '',
      flowTest1O2Pitot: json['flow_test_1_o2_pitot']?.toString() ?? '',
      flowTest1O3Pitot: json['flow_test_1_o3_pitot']?.toString() ?? '',
      flowTest1O4Pitot: json['flow_test_1_o4_pitot']?.toString() ?? '',
      flowTest1O5Pitot: json['flow_test_1_o5_pitot']?.toString() ?? '',
      flowTest1O6Pitot: json['flow_test_1_o6_pitot']?.toString() ?? '',
      flowTest1O7Pitot: json['flow_test_1_o7_pitot']?.toString() ?? '',
      flowTest1O1GPM: json['flow_test_1_o1_gpm']?.toString() ?? '',
      flowTest1O2GPM: json['flow_test_1_o2_gpm']?.toString() ?? '',
      flowTest1O3GPM: json['flow_test_1_o3_gpm']?.toString() ?? '',
      flowTest1O4GPM: json['flow_test_1_o4_gpm']?.toString() ?? '',
      flowTest1O5GPM: json['flow_test_1_o5_gpm']?.toString() ?? '',
      flowTest1O6GPM: json['flow_test_1_o6_gpm']?.toString() ?? '',
      flowTest1O7GPM: json['flow_test_1_o7_gpm']?.toString() ?? '',
      flowTest1TotalFlow: json['flow_test_1_total_flow']?.toString() ?? '',
      flowTest2SuctionPSI: json['flow_test_2_suction_psi']?.toString() ?? '',
      flowTest2DischargePSI: json['flow_test_2_discharge_psi']?.toString() ?? '',
      flowTest2NetPSI: json['flow_test_2_net_psi']?.toString() ?? '',
      flowTest2RPM: json['flow_test_2_rpm']?.toString() ?? '',
      flowTest2O1Pitot: json['flow_test_2_o1_pitot']?.toString() ?? '',
      flowTest2O2Pitot: json['flow_test_2_o2_pitot']?.toString() ?? '',
      flowTest2O3Pitot: json['flow_test_2_o3_pitot']?.toString() ?? '',
      flowTest2O4Pitot: json['flow_test_2_o4_pitot']?.toString() ?? '',
      flowTest2O5Pitot: json['flow_test_2_o5_pitot']?.toString() ?? '',
      flowTest2O6Pitot: json['flow_test_2_o6_pitot']?.toString() ?? '',
      flowTest2O7Pitot: json['flow_test_2_o7_pitot']?.toString() ?? '',
      flowTest2O1GPM: json['flow_test_2_o1_gpm']?.toString() ?? '',
      flowTest2O2GPM: json['flow_test_2_o2_gpm']?.toString() ?? '',
      flowTest2O3GPM: json['flow_test_2_o3_gpm']?.toString() ?? '',
      flowTest2O4GPM: json['flow_test_2_o4_gpm']?.toString() ?? '',
      flowTest2O5GPM: json['flow_test_2_o5_gpm']?.toString() ?? '',
      flowTest2O6GPM: json['flow_test_2_o6_gpm']?.toString() ?? '',
      flowTest2O7GPM: json['flow_test_2_o7_gpm']?.toString() ?? '',
      flowTest2TotalFlow: json['flow_test_2_total_flow']?.toString() ?? '',
      flowTest3SuctionPSI: json['flow_test_3_suction_psi']?.toString() ?? '',
      flowTest3DischargePSI: json['flow_test_3_discharge_psi']?.toString() ?? '',
      flowTest3NetPSI: json['flow_test_3_net_psi']?.toString() ?? '',
      flowTest3RPM: json['flow_test_3_rpm']?.toString() ?? '',
      flowTest3O1Pitot: json['flow_test_3_o1_pitot']?.toString() ?? '',
      flowTest3O2Pitot: json['flow_test_3_o2_pitot']?.toString() ?? '',
      flowTest3O3Pitot: json['flow_test_3_o3_pitot']?.toString() ?? '',
      flowTest3O4Pitot: json['flow_test_3_o4_pitot']?.toString() ?? '',
      flowTest3O5Pitot: json['flow_test_3_o5_pitot']?.toString() ?? '',
      flowTest3O6Pitot: json['flow_test_3_o6_pitot']?.toString() ?? '',
      flowTest3O7Pitot: json['flow_test_3_o7_pitot']?.toString() ?? '',
      flowTest3O1GPM: json['flow_test_3_o1_gpm']?.toString() ?? '',
      flowTest3O2GPM: json['flow_test_3_o2_gpm']?.toString() ?? '',
      flowTest3O3GPM: json['flow_test_3_o3_gpm']?.toString() ?? '',
      flowTest3O4GPM: json['flow_test_3_o4_gpm']?.toString() ?? '',
      flowTest3O5GPM: json['flow_test_3_o5_gpm']?.toString() ?? '',
      flowTest3O6GPM: json['flow_test_3_o6_gpm']?.toString() ?? '',
      flowTest3O7GPM: json['flow_test_3_o7_gpm']?.toString() ?? '',
      flowTest3TotalFlow: json['flow_test_3_total_flow']?.toString() ?? '',
      flowTest4SuctionPSI: json['flow_test_4_suction_psi']?.toString() ?? '',
      flowTest4DischargePSI: json['flow_test_4_discharge_psi']?.toString() ?? '',
      flowTest4NetPSI: json['flow_test_4_net_psi']?.toString() ?? '',
      flowTest4RPM: json['flow_test_4_rpm']?.toString() ?? '',
      flowTest4O1Pitot: json['flow_test_4_o1_pitot']?.toString() ?? '',
      flowTest4O2Pitot: json['flow_test_4_o2_pitot']?.toString() ?? '',
      flowTest4O3Pitot: json['flow_test_4_o3_pitot']?.toString() ?? '',
      flowTest4O4Pitot: json['flow_test_4_o4_pitot']?.toString() ?? '',
      flowTest4O5Pitot: json['flow_test_4_o5_pitot']?.toString() ?? '',
      flowTest4O6Pitot: json['flow_test_4_o6_pitot']?.toString() ?? '',
      flowTest4O7Pitot: json['flow_test_4_o7_pitot']?.toString() ?? '',
      flowTest4O1GPM: json['flow_test_4_o1_gpm']?.toString() ?? '',
      flowTest4O2GPM: json['flow_test_4_o2_gpm']?.toString() ?? '',
      flowTest4O3GPM: json['flow_test_4_o3_gpm']?.toString() ?? '',
      flowTest4O4GPM: json['flow_test_4_o4_gpm']?.toString() ?? '',
      flowTest4O5GPM: json['flow_test_4_o5_gpm']?.toString() ?? '',
      flowTest4O6GPM: json['flow_test_4_o6_gpm']?.toString() ?? '',
      flowTest4O7GPM: json['flow_test_4_o7_gpm']?.toString() ?? '',
      flowTest4TotalFlow: json['flow_test_4_total_flow']?.toString() ?? '',
      remarksOnTest: json['remarks_on_test']?.toString() ?? '',
    );
  }
}