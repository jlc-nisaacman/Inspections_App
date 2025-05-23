// lib/models/inspection_data.dart
import 'inspection_form.dart';

class InspectionData {
  final InspectionForm form;

  InspectionData(this.form);

  // Getter for formatted date
  String get formattedDate {
    try {
      if (form.date.isEmpty) {
        return 'N/A';
      }

      // Try parsing as DateTime (handles different date formats)
      DateTime? dateTime;

      // First attempt: Try parsing as ISO format
      try {
        dateTime = DateTime.parse(form.date);
      } catch (e) {
        // If that fails, try alternate formats or return original
        return form.date;
      }

      // Format the date consistently
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return form.date; // Return original if parsing fails
    }
  }

  // Getter for location (with fallback)
  String get displayLocation {
    return form.location.isNotEmpty ? form.location : 'N/A';
  }

  // Getter for city/state (with fallback)
  String get locationCityState {
    return form.locationCityState.isNotEmpty ? form.locationCityState : 'N/A';
  }

  // Helper method to get device tests as list of maps
  List<Map<String, String>> getDeviceTests() {
    final tests = <Map<String, String>>[];

    // Function to add a device test if it exists
    void addDevice(
      String name,
      String address,
      String description,
      String operated,
      String delay,
    ) {
      if (name.isNotEmpty || address.isNotEmpty) {
        tests.add({
          'device': name,
          'address': address,
          'description': description,
          'operated': operated,
          'delay': delay,
        });
      }
    }

    // Add each device that has data
    addDevice(
      form.device1Name,
      form.device1Address,
      form.device1DescriptionLocation,
      form.device1Operated,
      form.device1DelaySec,
    );

    addDevice(
      form.device2Name,
      form.device2Address,
      form.device2DescriptionLocation,
      form.device2Operated,
      form.device2DelaySec,
    );

    addDevice(
      form.device3Name,
      form.device3Address,
      form.device3DescriptionLocation,
      form.device3Operated,
      form.device3DelaySec,
    );

    addDevice(
      form.device4Name,
      form.device4Address,
      form.device4DescriptionLocation,
      form.device4Operated,
      form.device4DelaySec,
    );

    addDevice(
      form.device5Name,
      form.device5Address,
      form.device5DescriptionLocation,
      form.device5Operated,
      form.device5DelaySec,
    );
    addDevice(
      form.device6Name,
      form.device6Address,
      form.device6DescriptionLocation,
      form.device6Operated,
      form.device6DelaySec,
    );

    addDevice(
      form.device7Name,
      form.device7Address,
      form.device7DescriptionLocation,
      form.device7Operated,
      form.device7DelaySec,
    );

    addDevice(
      form.device8Name,
      form.device8Address,
      form.device8DescriptionLocation,
      form.device8Operated,
      form.device8DelaySec,
    );

    addDevice(
      form.device9Name,
      form.device9Address,
      form.device9DescriptionLocation,
      form.device9Operated,
      form.device9DelaySec,
    );

    addDevice(
      form.device10Name,
      form.device10Address,
      form.device10DescriptionLocation,
      form.device10Operated,
      form.device10DelaySec,
    );

    addDevice(
      form.device11Name,
      form.device11Address,
      form.device11DescriptionLocation,
      form.device11Operated,
      form.device11DelaySec,
    );

    addDevice(
      form.device12Name,
      form.device12Address,
      form.device12DescriptionLocation,
      form.device12Operated,
      form.device12DelaySec,
    );

    addDevice(
      form.device13Name,
      form.device13Address,
      form.device13DescriptionLocation,
      form.device13Operated,
      form.device13DelaySec,
    );

    addDevice(
      form.device14Name,
      form.device14Address,
      form.device14DescriptionLocation,
      form.device14Operated,
      form.device14DelaySec,
    );

    return tests;
  }

  // Factory method to create InspectionData from JSON
  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(InspectionForm.fromJson(json));
  }
}
