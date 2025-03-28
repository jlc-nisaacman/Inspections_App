class InspectionChecklist {
  // General Inspection
  final String x1a;
  final String x1b;
  final String x1c;
  final String x1d;
  final String x2a;

  // Control Valves
  final String x3a;
  final String x3b;
  final String x3c;
  final String x3d;

  // Fire Department Connections
  final String x4a;
  final String x4b;
  final String x4c;
  final String x4d;

  // Alarms
  final String x11a;
  final String x11b;
  final String x11c;
  final String x11d;
  final String x11e;

  InspectionChecklist({
    required this.x1a,
    required this.x1b,
    required this.x1c,
    required this.x1d,
    required this.x2a,
    required this.x3a,
    required this.x3b,
    required this.x3c,
    required this.x3d,
    required this.x4a,
    required this.x4b,
    required this.x4c,
    required this.x4d,
    required this.x11a,
    required this.x11b,
    required this.x11c,
    required this.x11d,
    required this.x11e,
  });

  factory InspectionChecklist.fromJson(Map<String, dynamic> json) {
    return InspectionChecklist(
      // General Inspection
      x1a: json['1A']?.toString() ?? '',
      x1b: json['1B']?.toString() ?? '',
      x1c: json['1C']?.toString() ?? '',
      x1d: json['1D']?.toString() ?? '',
      x2a: json['2A']?.toString() ?? '',

      // Control Valves
      x3a: json['3A']?.toString() ?? '',
      x3b: json['3B']?.toString() ?? '',
      x3c: json['3C']?.toString() ?? '',
      x3d: json['3D']?.toString() ?? '',

      // Fire Department Connections
      x4a: json['4A']?.toString() ?? '',
      x4b: json['4B']?.toString() ?? '',
      x4c: json['4C']?.toString() ?? '',
      x4d: json['4D']?.toString() ?? '',

      // Alarms
      x11a: json['11a']?.toString() ?? '',
      x11b: json['11b']?.toString() ?? '',
      x11c: json['11c']?.toString() ?? '',
      x11d: json['11d']?.toString() ?? '',
      x11e: json['11e']?.toString() ?? '',
    );
  }
}