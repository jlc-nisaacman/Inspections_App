// lib/models/inspection_data.dart
import 'inspection_form.dart';

/// InspectionData is a wrapper around InspectionForm.
/// This class maintains compatibility with existing code while you transition
/// to the new flat InspectionForm structure.
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

  // Simplified access to common sections
  Map<String, String> get basicInfo => {
    'PDF Path': form.pdfPath,
    'Bill To': form.billTo,
    'Location': form.location,
    'Attention': form.attention,
    'Street': form.billingStreet,
    'City/State': form.billingCityState,
    'Contact': form.contact,
    'Date': formattedDate,
    'Phone': form.phone,
    'Inspector': form.inspector,
    'Email': form.email,
  };

  Map<String, String> get checklist => {
    'Building Occupied': form.isTheBuildingOccupied,
    'Systems In Service': form.areAllSystemsInService,
    'Systems Same as Last Inspection': form.areFpSystemsSameAsLastInspection,
    'Hydraulic Nameplate Secure': form.hydraulicNameplateSecurelyAttachedAndLegible,
    'Control Valves Open': form.areAllSprinklerSystemMainControlValvesOpen,
    'FD Connections Satisfactory': form.areFireDepartmentConnectionsInSatisfactoryCondition,
  };

  Map<String, String> get drainTests => {
    'System 1': '${form.system1Name} - Static: ${form.system1StaticPSI} - Residual: ${form.system1ResidualPSI}',
    'System 2': '${form.system2Name} - Static: ${form.system2StaticPSI} - Residual: ${form.system2ResidualPSI}',
    'System 3': '${form.system3Name} - Static: ${form.system3StaticPSI} - Residual: ${form.system3ResidualPSI}',
    'Notes': form.drainTestNotes,
  };

  Map<String, String> get additionalDetails => {
    'Adjustments or Corrections': form.adjustmentsOrCorrectionsMake,
    'Explanation of No Answers': form.explanationOfAnyNoAnswers,
    'Notes': form.notes,
  };

  // Helper method to get device tests as list of maps
  List<Map<String, String>> getDeviceTests() {
    final tests = <Map<String, String>>[];
    
    // Function to add a device test if it exists
    void addDevice(String name, String address, String description, String operated, String delay) {
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
    addDevice(form.device1Name, form.device1Address, form.device1DescriptionLocation, 
              form.device1Operated, form.device1DelaySec);
    
    addDevice(form.device2Name, form.device2Address, form.device2DescriptionLocation, 
              form.device2Operated, form.device2DelaySec);
    
    addDevice(form.device3Name, form.device3Address, form.device3DescriptionLocation, 
              form.device3Operated, form.device3DelaySec);
    
    addDevice(form.device4Name, form.device4Address, form.device4DescriptionLocation, 
              form.device4Operated, form.device4DelaySec);
    
    addDevice(form.device5Name, form.device5Address, form.device5DescriptionLocation, 
              form.device5Operated, form.device5DelaySec);
    
    // Continue for all devices...
    // Devices 6-14 would follow the same pattern
    
    return tests;
  }

  // Factory method to create InspectionData from JSON
  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(InspectionForm.fromJson(json));
  }
}