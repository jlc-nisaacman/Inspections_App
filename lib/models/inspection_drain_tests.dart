class InspectionDrainTests {
  final String drainTestLine1;
  final String drianSize1;
  final String static1;
  final String residual1;
  final String drainTestLine2;
  final String drianSize2;
  final String static2;
  final String residual2;
  final String drainTestLine3;
  final String drianSize3;
  final String static3;
  final String residual3;
  final String drainTestNotes;

  InspectionDrainTests({
    required this.drainTestLine1,
    required this.drianSize1,
    required this.static1,
    required this.residual1,
    required this.drainTestLine2,
    required this.drianSize2,
    required this.static2,
    required this.residual2,
    required this.drainTestLine3,
    required this.drianSize3,
    required this.static3,
    required this.residual3,
    required this.drainTestNotes,
  });

  factory InspectionDrainTests.fromJson(Map<String, dynamic> json) {
    return InspectionDrainTests(
      drainTestLine1: json['Drain test line 1']?.toString() ?? '',
      drianSize1: json['drian size 1']?.toString() ?? '',
      static1: json['Static 1']?.toString() ?? '',
      residual1: json['Residual 1']?.toString() ?? '',
      drainTestLine2: json['Drain test line 2']?.toString() ?? '',
      drianSize2: json['drian size 2']?.toString() ?? '',
      static2: json['Static 2']?.toString() ?? '',
      residual2: json['Residual 2']?.toString() ?? '',
      drainTestLine3: json['Drain test line 3']?.toString() ?? '',
      drianSize3: json['drian size 3']?.toString() ?? '',
      static3: json['Static 3']?.toString() ?? '',
      residual3: json['Residual 3']?.toString() ?? '',
      drainTestNotes: json['Drain test notes']?.toString() ?? '',
    );
  }
}