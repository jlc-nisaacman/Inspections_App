// lib/models/pump_system_data.dart
import 'pump_system_form.dart';

class PumpSystemData {
  final PumpSystemForm form;

  PumpSystemData(this.form);

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
    return form.building.isNotEmpty ? form.building : 'N/A';
  }

  // Helper method to get flow tests as list of maps
  List<Map<String, String>> getFlowTests() {
    final tests = <Map<String, String>>[];

    // Function to add a flow test if it has meaningful data
    void addFlowTest(
      String testNumber,
      String suctionPSI,
      String dischargePSI,
      String netPSI,
      String rpm,
      List<String> orifices,
      List<String> pitots,
      List<String> gpms,
      String totalFlow,
    ) {
      // Check if the test has meaningful data
      final hasData = suctionPSI.isNotEmpty || 
                      dischargePSI.isNotEmpty || 
                      netPSI.isNotEmpty || 
                      rpm.isNotEmpty || 
                      totalFlow.isNotEmpty ||
                      orifices.any((o) => o.isNotEmpty) ||
                      pitots.any((p) => p.isNotEmpty) ||
                      gpms.any((g) => g.isNotEmpty);

      if (hasData) {
        final testData = {
          'testNumber': testNumber,
          'suctionPSI': suctionPSI,
          'dischargePSI': dischargePSI,
          'netPSI': netPSI,
          'rpm': rpm,
          'orificeSize1': orifices.isNotEmpty ? orifices[0] : '',
          'orificeSize2': orifices.length > 1 ? orifices[1] : '',
          'orificeSize3': orifices.length > 2 ? orifices[2] : '',
          'orificeSize4': orifices.length > 3 ? orifices[3] : '',
          'orificeSize5': orifices.length > 4 ? orifices[4] : '',
          'orificeSize6': orifices.length > 5 ? orifices[5] : '',
          'orificeSize7': orifices.length > 6 ? orifices[6] : '',
          'pitot1': pitots.isNotEmpty ? pitots[0] : '',
          'pitot2': pitots.length > 1 ? pitots[1] : '',
          'pitot3': pitots.length > 2 ? pitots[2] : '',
          'pitot4': pitots.length > 3 ? pitots[3] : '',
          'pitot5': pitots.length > 4 ? pitots[4] : '',
          'pitot6': pitots.length > 5 ? pitots[5] : '',
          'pitot7': pitots.length > 6 ? pitots[6] : '',
          'gpm1': gpms.isNotEmpty ? gpms[0] : '',
          'gpm2': gpms.length > 1 ? gpms[1] : '',
          'gpm3': gpms.length > 2 ? gpms[2] : '',
          'gpm4': gpms.length > 3 ? gpms[3] : '',
          'gpm5': gpms.length > 4 ? gpms[4] : '',
          'gpm6': gpms.length > 5 ? gpms[5] : '',
          'gpm7': gpms.length > 6 ? gpms[6] : '',
          'totalFlow': totalFlow,
        };
        tests.add(testData);
      }
    }

    // Add each flow test with its data
    addFlowTest(
      'Flow Test 1',
      form.flowTest1SuctionPSI,
      form.flowTest1DischargePSI, 
      form.flowTest1NetPSI,
      form.flowTest1RPM,
      [
        form.flowTestOrificeSize1,
        form.flowTestOrificeSize2,
        form.flowTestOrificeSize3,
        form.flowTestOrificeSize4,
        form.flowTestOrificeSize5,
        form.flowTestOrificeSize6,
        form.flowTestOrificeSize7,
      ],
      [
        form.flowTest1O1Pitot,
        form.flowTest1O2Pitot,
        form.flowTest1O3Pitot,
        form.flowTest1O4Pitot,
        form.flowTest1O5Pitot,
        form.flowTest1O6Pitot,
        form.flowTest1O7Pitot,
      ],
      [
        form.flowTest1O1GPM,
        form.flowTest1O2GPM,
        form.flowTest1O3GPM,
        form.flowTest1O4GPM,
        form.flowTest1O5GPM,
        form.flowTest1O6GPM,
        form.flowTest1O7GPM,
      ],
      form.flowTest1TotalFlow,
    );

    addFlowTest(
      'Flow Test 2',
      form.flowTest2SuctionPSI,
      form.flowTest2DischargePSI, 
      form.flowTest2NetPSI,
      form.flowTest2RPM,
      [
        form.flowTestOrificeSize1,
        form.flowTestOrificeSize2,
        form.flowTestOrificeSize3,
        form.flowTestOrificeSize4,
        form.flowTestOrificeSize5,
        form.flowTestOrificeSize6,
        form.flowTestOrificeSize7,
      ],
      [
        form.flowTest2O1Pitot,
        form.flowTest2O2Pitot,
        form.flowTest2O3Pitot,
        form.flowTest2O4Pitot,
        form.flowTest2O5Pitot,
        form.flowTest2O6Pitot,
        form.flowTest2O7Pitot,
      ],
      [
        form.flowTest2O1GPM,
        form.flowTest2O2GPM,
        form.flowTest2O3GPM,
        form.flowTest2O4GPM,
        form.flowTest2O5GPM,
        form.flowTest2O6GPM,
        form.flowTest2O7GPM,
      ],
      form.flowTest2TotalFlow,
    );

    addFlowTest(
      'Flow Test 3',
      form.flowTest3SuctionPSI,
      form.flowTest3DischargePSI, 
      form.flowTest3NetPSI,
      form.flowTest3RPM,
      [
        form.flowTestOrificeSize1,
        form.flowTestOrificeSize2,
        form.flowTestOrificeSize3,
        form.flowTestOrificeSize4,
        form.flowTestOrificeSize5,
        form.flowTestOrificeSize6,
        form.flowTestOrificeSize7,
      ],
      [
        form.flowTest3O1Pitot,
        form.flowTest3O2Pitot,
        form.flowTest3O3Pitot,
        form.flowTest3O4Pitot,
        form.flowTest3O5Pitot,
        form.flowTest3O6Pitot,
        form.flowTest3O7Pitot,
      ],
      [
        form.flowTest3O1GPM,
        form.flowTest3O2GPM,
        form.flowTest3O3GPM,
        form.flowTest3O4GPM,
        form.flowTest3O5GPM,
        form.flowTest3O6GPM,
        form.flowTest3O7GPM,
      ],
      form.flowTest3TotalFlow,
    );

    addFlowTest(
      'Flow Test 4',
      form.flowTest4SuctionPSI,
      form.flowTest4DischargePSI, 
      form.flowTest4NetPSI,
      form.flowTest4RPM,
      [
        form.flowTestOrificeSize1,
        form.flowTestOrificeSize2,
        form.flowTestOrificeSize3,
        form.flowTestOrificeSize4,
        form.flowTestOrificeSize5,
        form.flowTestOrificeSize6,
        form.flowTestOrificeSize7,
      ],
      [
        form.flowTest4O1Pitot,
        form.flowTest4O2Pitot,
        form.flowTest4O3Pitot,
        form.flowTest4O4Pitot,
        form.flowTest4O5Pitot,
        form.flowTest4O6Pitot,
        form.flowTest4O7Pitot,
      ],
      [
        form.flowTest4O1GPM,
        form.flowTest4O2GPM,
        form.flowTest4O3GPM,
        form.flowTest4O4GPM,
        form.flowTest4O5GPM,
        form.flowTest4O6GPM,
        form.flowTest4O7GPM,
      ],
      form.flowTest4TotalFlow,
    );

    return tests;
  }

  // Factory method to create PumpSystemData from JSON
  factory PumpSystemData.fromJson(Map<String, dynamic> json) {
    return PumpSystemData(PumpSystemForm.fromJson(json));
  }
}