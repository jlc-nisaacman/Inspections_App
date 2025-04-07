// lib/models/pump_system_form.dart

class PumpSystemForm {
  final String pdfPath;
  final String reportTo;
  final String building;
  final String reportTo2;
  final String building2;
  final String attention;
  final String street;
  final String inspector;
  final String cityState;
  final String date;

  // Add specific fields for pump system inspections
  final String pumpManufacturer;
  final String pumpModel;
  final String pumpSerial;
  final String pumpYear;
  final String pumpType;
  final String pumpLocation;

  // Pump Performance Details
  final String designFlow;
  final String designPressure;
  final String actualFlow;
  final String actualPressure;

  // Test Results
  final String testDate;
  final String testPressure;
  final String testFlow;
  final String testNotes;

  // Maintenance Details
  final String lastMaintenanceDate;
  final String maintenancePerformedBy;
  final String maintenanceNotes;

  // Additional fields as needed for pump systems
  final String remarks;

  PumpSystemForm({
    required this.pdfPath,
    required this.reportTo,
    required this.building,
    required this.reportTo2,
    required this.building2,
    required this.attention,
    required this.street,
    required this.inspector,
    required this.cityState,
    required this.date,
    required this.pumpManufacturer,
    required this.pumpModel,
    required this.pumpSerial,
    required this.pumpYear,
    required this.pumpType,
    required this.pumpLocation,
    required this.designFlow,
    required this.designPressure,
    required this.actualFlow,
    required this.actualPressure,
    required this.testDate,
    required this.testPressure,
    required this.testFlow,
    required this.testNotes,
    required this.lastMaintenanceDate,
    required this.maintenancePerformedBy,
    required this.maintenanceNotes,
    required this.remarks,
  });

  factory PumpSystemForm.fromJson(Map<String, dynamic> json) {
    return PumpSystemForm(
      pdfPath: json['pdf_path']?.toString() ?? '',
      reportTo: json['report_to']?.toString() ?? '',
      building: json['building']?.toString() ?? '',
      reportTo2: json['report_to_2']?.toString() ?? '',
      building2: json['building_2']?.toString() ?? '',
      attention: json['attention']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      inspector: json['inspector']?.toString() ?? '',
      cityState: json['city_state']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      pumpManufacturer: json['pump_manufacturer']?.toString() ?? '',
      pumpModel: json['pump_model']?.toString() ?? '',
      pumpSerial: json['pump_serial']?.toString() ?? '',
      pumpYear: json['pump_year']?.toString() ?? '',
      pumpType: json['pump_type']?.toString() ?? '',
      pumpLocation: json['pump_location']?.toString() ?? '',
      designFlow: json['design_flow']?.toString() ?? '',
      designPressure: json['design_pressure']?.toString() ?? '',
      actualFlow: json['actual_flow']?.toString() ?? '',
      actualPressure: json['actual_pressure']?.toString() ?? '',
      testDate: json['test_date']?.toString() ?? '',
      testPressure: json['test_pressure']?.toString() ?? '',
      testFlow: json['test_flow']?.toString() ?? '',
      testNotes: json['test_notes']?.toString() ?? '',
      lastMaintenanceDate: json['last_maintenance_date']?.toString() ?? '',
      maintenancePerformedBy: json['maintenance_performed_by']?.toString() ?? '',
      maintenanceNotes: json['maintenance_notes']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
    );
  }
}