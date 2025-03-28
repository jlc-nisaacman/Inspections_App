import 'inspection_basic_info.dart';
import 'inspection_checklist.dart';
import 'inspection_systems.dart';
import 'inspection_drain_tests.dart';
import 'inspection_additional_details.dart';

class InspectionData {
  final InspectionBasicInfo basicInfo;
  final InspectionChecklist checklist;
  final InspectionSystems systems;
  final InspectionDrainTests drainTests;
  final InspectionAdditionalDetails additionalDetails;

  InspectionData({
    required this.basicInfo,
    required this.checklist,
    required this.systems,
    required this.drainTests,
    required this.additionalDetails,
  });

  // Getter for formatted date
  String get formattedDate {
    try {
      final DateTime dateTime = DateTime.parse(basicInfo.date);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return basicInfo.date; // Return original if parsing fails
    }
  }

  // Getter for location (with fallback)
  String get displayLocation {
    return basicInfo.location.isNotEmpty ? basicInfo.location : 'N/A';
  }

  // Getter for city/state (with fallback)
  String get locationCityState {
    return basicInfo.cityState2.isNotEmpty ? basicInfo.cityState2 : 'N/A';
  }

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      basicInfo: InspectionBasicInfo.fromJson(json),
      checklist: InspectionChecklist.fromJson(json),
      systems: InspectionSystems.fromJson(json),
      drainTests: InspectionDrainTests.fromJson(json),
      additionalDetails: InspectionAdditionalDetails.fromJson(json),
    );
  }
}