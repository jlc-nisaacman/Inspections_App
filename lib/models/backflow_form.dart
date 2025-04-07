// lib/models/backflow_form.dart

class BackflowForm {
  final String pdfPath;
  final String backflowMake;
  final String backflowModel;
  final String backflowSerialNumber;
  final String backflowSize;
  final String backflowType;
  final String certificateNumber;
  final String contactPerson;
  final String date;
  final String dcvaBackPressureTest1PSI;
  final String dcvaBackPressureTest4PSI;
  final String dcvaCheckValve1PSID;
  final String dcvaCheckValve2PSID;
  final String dcvaFlow;
  final String dcvaNoFlow;
  final String deviceLocation;
  final String downstreamShutoffValveStatus;
  final String mailingAddress;
  final String ownerOfProperty;
  final String protectionType;
  final String pvbSrvbAirInletValveDidNotOpen;
  final String pvbSrvbAirInletValveOpenedAtPSID;
  final String pvbSrvbCheckValveFlow;
  final String pvbSrvbCheckValvePSID;
  final String remarks1;
  final String remarks2;
  final String remarks3;
  final String result;
  final String rpzCheckValve1ClosedTight;
  final String rpzCheckValve1Leaked;
  final String rpzCheckValve1PSID;
  final String rpzCheckValve2ClosedTight;
  final String rpzCheckValve2Leaked;
  final String rpzCheckValve2PSID;
  final String rpzCheckValveFlow;
  final String rpzCheckValveNoFlow;
  final String rpzReliefValveDidNotOpen;
  final String rpzReliefValveOpenedAtPSID;
  final String testType;
  final String testedBy;
  final String witness;

  BackflowForm({
    required this.pdfPath,
    required this.backflowMake,
    required this.backflowModel,
    required this.backflowSerialNumber,
    required this.backflowSize,
    required this.backflowType,
    required this.certificateNumber,
    required this.contactPerson,
    required this.date,
    required this.dcvaBackPressureTest1PSI,
    required this.dcvaBackPressureTest4PSI,
    required this.dcvaCheckValve1PSID,
    required this.dcvaCheckValve2PSID,
    required this.dcvaFlow,
    required this.dcvaNoFlow,
    required this.deviceLocation,
    required this.downstreamShutoffValveStatus,
    required this.mailingAddress,
    required this.ownerOfProperty,
    required this.protectionType,
    required this.pvbSrvbAirInletValveDidNotOpen,
    required this.pvbSrvbAirInletValveOpenedAtPSID,
    required this.pvbSrvbCheckValveFlow,
    required this.pvbSrvbCheckValvePSID,
    required this.remarks1,
    required this.remarks2,
    required this.remarks3,
    required this.result,
    required this.rpzCheckValve1ClosedTight,
    required this.rpzCheckValve1Leaked,
    required this.rpzCheckValve1PSID,
    required this.rpzCheckValve2ClosedTight,
    required this.rpzCheckValve2Leaked,
    required this.rpzCheckValve2PSID,
    required this.rpzCheckValveFlow,
    required this.rpzCheckValveNoFlow,
    required this.rpzReliefValveDidNotOpen,
    required this.rpzReliefValveOpenedAtPSID,
    required this.testType,
    required this.testedBy,
    required this.witness,
  });

  factory BackflowForm.fromJson(Map<String, dynamic> json) {
    return BackflowForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      backflowMake: json['backflow_make']?.toString() ?? '',
      backflowModel: json['backflow_model']?.toString() ?? '',
      backflowSerialNumber: json['backflow_serial_number']?.toString() ?? '',
      backflowSize: json['backflow_size']?.toString() ?? '',
      backflowType: json['backflow_type']?.toString() ?? '',
      certificateNumber: json['certificate_number']?.toString() ?? '',
      contactPerson: json['contact_person']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      dcvaBackPressureTest1PSI: json['dcva_back_pressure_test_1_psi']?.toString() ?? '',
      dcvaBackPressureTest4PSI: json['dcva_back_pressure_test_4_psi']?.toString() ?? '',
      dcvaCheckValve1PSID: json['dcva_check_valve_1_psid']?.toString() ?? '',
      dcvaCheckValve2PSID: json['dcva_check_valve_2_psid']?.toString() ?? '',
      dcvaFlow: json['dcva_flow']?.toString() ?? '',
      dcvaNoFlow: json['dcva_no_flow']?.toString() ?? '',
      deviceLocation: json['device_location']?.toString() ?? '',
      downstreamShutoffValveStatus: json['downsteam_shutoff_valve_status']?.toString() ?? '',
      mailingAddress: json['mailing_address']?.toString() ?? '',
      ownerOfProperty: json['owner_of_property']?.toString() ?? '',
      protectionType: json['protection_type']?.toString() ?? '',
      pvbSrvbAirInletValveDidNotOpen: json['pvb_srvb_air_inlet_valve_did_not_open']?.toString() ?? '',
      pvbSrvbAirInletValveOpenedAtPSID: json['pvb_srvb_air_inlet_valve_opened_at_psid']?.toString() ?? '',
      pvbSrvbCheckValveFlow: json['pvb_srvb_check_valve_flow']?.toString() ?? '',
      pvbSrvbCheckValvePSID: json['pvb_srvb_check_valve_psid']?.toString() ?? '',
      remarks1: json['remarks_1']?.toString() ?? '',
      remarks2: json['remarks_2']?.toString() ?? '',
      remarks3: json['remarks_3']?.toString() ?? '',
      result: json['result']?.toString() ?? '',
      rpzCheckValve1ClosedTight: json['rpz_check_valve_1_closed_tight']?.toString() ?? '',
      rpzCheckValve1Leaked: json['rpz_check_valve_1_leaked']?.toString() ?? '',
      rpzCheckValve1PSID: json['rpz_check_valve_1_psid']?.toString() ?? '',
      rpzCheckValve2ClosedTight: json['rpz_check_valve_2_closed_tight']?.toString() ?? '',
      rpzCheckValve2Leaked: json['rpz_check_valve_2_leaked']?.toString() ?? '',
      rpzCheckValve2PSID: json['rpz_check_valve_2_psid']?.toString() ?? '',
      rpzCheckValveFlow: json['rpz_check_valve_flow']?.toString() ?? '',
      rpzCheckValveNoFlow: json['rpz_check_valve_no_flow']?.toString() ?? '',
      rpzReliefValveDidNotOpen: json['rpz_relief_valve_did_not_open']?.toString() ?? '',
      rpzReliefValveOpenedAtPSID: json['rpz_relief_valve_opened_at_psid']?.toString() ?? '',
      testType: json['test_type']?.toString() ?? '',
      testedBy: json['tested_by']?.toString() ?? '',
      witness: json['witness']?.toString() ?? '',
    );
  }
}