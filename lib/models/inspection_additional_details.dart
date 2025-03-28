class InspectionAdditionalDetails {
  final List<Map<String, String>> deviceTests;
  final String x16AdjustmentsOrCorrections;
  final String x17ExplanationOfNoAnswers;
  final String x17ExplanationOfNoAnswersContinued;
  final String x18Notes;

  InspectionAdditionalDetails({
    required this.deviceTests,
    required this.x16AdjustmentsOrCorrections,
    required this.x17ExplanationOfNoAnswers,
    required this.x17ExplanationOfNoAnswersContinued,
    required this.x18Notes,
  });

  factory InspectionAdditionalDetails.fromJson(Map<String, dynamic> json) {
    // Helper function for device tests
    List<Map<String, String>> extractDeviceTests(Map<String, dynamic> json) {
      List<Map<String, String>> tests = [];
      for (int i = 1; i <= 5; i++) {
        final device = json['15 Device $i']?.toString() ?? '';
        final address = json['15 Address $i']?.toString() ?? '';
        final description = json['15 Description $i']?.toString() ?? '';
        final operated = json['15 Operated $i']?.toString() ?? '';
        final delay = json['15 Delay $i']?.toString() ?? '';

        if (device.isNotEmpty || address.isNotEmpty) {
          tests.add({
            'device': device,
            'address': address,
            'description': description,
            'operated': operated,
            'delay': delay,
          });
        }
      }
      return tests;
    }

    return InspectionAdditionalDetails(
      deviceTests: extractDeviceTests(json),
      x16AdjustmentsOrCorrections: json['16 Adjustments or Corrections']?.toString() ?? '',
      x17ExplanationOfNoAnswers: json['17 Explanation of no answers']?.toString() ?? '',
      x17ExplanationOfNoAnswersContinued: json['17 Explanation of no answers continued']?.toString() ?? '',
      x18Notes: json['18 NOTES']?.toString() ?? '',
    );
  }
}