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
  final double? dcvaBackPressureTest1PSI; // Changed from String to double?
  final double? dcvaBackPressureTest4PSI; // Changed from String to double?
  final double? dcvaCheckValve1PSID; // Changed from String to double?
  final double? dcvaCheckValve2PSID; // Changed from String to double?
  final bool? dcvaFlow; // Changed from String to bool?
  final bool? dcvaNoFlow; // Changed from String to bool?
  final String deviceLocation;
  final String downstreamShutoffValveStatus;
  final String mailingAddress;
  final String ownerOfProperty;
  final String protectionType;
  final bool? pvbSrvbAirInletValveDidNotOpen; // Changed from String to bool?
  final double? pvbSrvbAirInletValveOpenedAtPSID; // Changed from String to double?
  final String pvbSrvbCheckValveFlow;
  final double? pvbSrvbCheckValvePSID; // Changed from String to double?
  final String remarks1;
  final String remarks2;
  final String remarks3;
  final String result;
  final bool? rpzCheckValve1ClosedTight; // Changed from String to bool?
  final bool? rpzCheckValve1Leaked; // Changed from String to bool?
  final double? rpzCheckValve1PSID; // Changed from String to double?
  final bool? rpzCheckValveFlow; // Changed from String to bool?
  final bool? rpzCheckValveNoFlow; // Changed from String to bool?
  final double? rpzCheckValve2PSID; // Changed from String to double?
  final bool? rpzCheckValve2ClosedTight; // Changed from String to bool?
  final bool? rpzCheckValve2Leaked; // Changed from String to bool?
  final bool? rpzReliefValveDidNotOpen; // Changed from String to bool?
  final double? rpzReliefValveOpenedAtPSID; // Changed from String to double?
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

  // Helper method to safely parse double values
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.isEmpty) return null;
    return double.tryParse(value.toString());
  }

  // Helper method to safely parse bool values
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return null;
  }

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
      dcvaBackPressureTest1PSI: _parseDouble(json['dcva_back_pressure_test_1_psi']),
      dcvaBackPressureTest4PSI: _parseDouble(json['dcva_back_pressure_test_4_psi']),
      dcvaCheckValve1PSID: _parseDouble(json['dcva_check_valve_1_psid']),
      dcvaCheckValve2PSID: _parseDouble(json['dcva_check_valve_2_psid']),
      dcvaFlow: _parseBool(json['dcva_flow']),
      dcvaNoFlow: _parseBool(json['dcva_no_flow']),
      deviceLocation: json['device_location']?.toString() ?? '',
      downstreamShutoffValveStatus: json['downsteam_shutoff_valve_status']?.toString() ?? '',
      mailingAddress: json['mailing_address']?.toString() ?? '',
      ownerOfProperty: json['owner_of_property']?.toString() ?? '',
      protectionType: json['protection_type']?.toString() ?? '',
      pvbSrvbAirInletValveDidNotOpen: _parseBool(json['pvb_srvb_air_inlet_valve_did_not_open']),
      pvbSrvbAirInletValveOpenedAtPSID: _parseDouble(json['pvb_srvb_air_inlet_valve_opened_at_psid']),
      pvbSrvbCheckValveFlow: json['pvb_srvb_check_valve_flow']?.toString() ?? '',
      pvbSrvbCheckValvePSID: _parseDouble(json['pvb_srvb_check_valve_psid']),
      remarks1: json['remarks_1']?.toString() ?? '',
      remarks2: json['remarks_2']?.toString() ?? '',
      remarks3: json['remarks_3']?.toString() ?? '',
      result: json['result']?.toString() ?? '',
      rpzCheckValve1ClosedTight: _parseBool(json['rpz_check_valve_1_closed_tight']),
      rpzCheckValve1Leaked: _parseBool(json['rpz_check_valve_1_leaked']),
      rpzCheckValve1PSID: _parseDouble(json['rpz_check_valve_1_psid']),
      rpzCheckValve2ClosedTight: _parseBool(json['rpz_check_valve_2_closed_tight']),
      rpzCheckValve2Leaked: _parseBool(json['rpz_check_valve_2_leaked']),
      rpzCheckValve2PSID: _parseDouble(json['rpz_check_valve_2_psid']),
      rpzCheckValveFlow: _parseBool(json['rpz_check_valve_flow']),
      rpzCheckValveNoFlow: _parseBool(json['rpz_check_valve_no_flow']),
      rpzReliefValveDidNotOpen: _parseBool(json['rpz_relief_valve_did_not_open']),
      rpzReliefValveOpenedAtPSID: _parseDouble(json['rpz_relief_valve_opened_at_psid']),
      testType: json['test_type']?.toString() ?? '',
      testedBy: json['tested_by']?.toString() ?? '',
      witness: json['witness']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pdf_path': pdfPath,
      'backflow_make': backflowMake,
      'backflow_model': backflowModel,
      'backflow_serial_number': backflowSerialNumber,
      'backflow_size': backflowSize,
      'backflow_type': backflowType,
      'certificate_number': certificateNumber,
      'contact_person': contactPerson,
      'date': date,
      'dcva_back_pressure_test_1_psi': dcvaBackPressureTest1PSI,
      'dcva_back_pressure_test_4_psi': dcvaBackPressureTest4PSI,
      'dcva_check_valve_1_psid': dcvaCheckValve1PSID,
      'dcva_check_valve_2_psid': dcvaCheckValve2PSID,
      'dcva_flow': dcvaFlow,
      'dcva_no_flow': dcvaNoFlow,
      'device_location': deviceLocation,
      'downsteam_shutoff_valve_status': downstreamShutoffValveStatus,
      'mailing_address': mailingAddress,
      'owner_of_property': ownerOfProperty,
      'protection_type': protectionType,
      'pvb_srvb_air_inlet_valve_did_not_open': pvbSrvbAirInletValveDidNotOpen,
      'pvb_srvb_air_inlet_valve_opened_at_psid': pvbSrvbAirInletValveOpenedAtPSID,
      'pvb_srvb_check_valve_flow': pvbSrvbCheckValveFlow,
      'pvb_srvb_check_valve_psid': pvbSrvbCheckValvePSID,
      'remarks_1': remarks1,
      'remarks_2': remarks2,
      'remarks_3': remarks3,
      'result': result,
      'rpz_check_valve_1_closed_tight': rpzCheckValve1ClosedTight,
      'rpz_check_valve_1_leaked': rpzCheckValve1Leaked,
      'rpz_check_valve_1_psid': rpzCheckValve1PSID,
      'rpz_check_valve_2_closed_tight': rpzCheckValve2ClosedTight,
      'rpz_check_valve_2_leaked': rpzCheckValve2Leaked,
      'rpz_check_valve_2_psid': rpzCheckValve2PSID,
      'rpz_check_valve_flow': rpzCheckValveFlow,
      'rpz_check_valve_no_flow': rpzCheckValveNoFlow,
      'rpz_relief_valve_did_not_open': rpzReliefValveDidNotOpen,
      'rpz_relief_valve_opened_at_psid': rpzReliefValveOpenedAtPSID,
      'test_type': testType,
      'tested_by': testedBy,
      'witness': witness,
    };
  }
}
