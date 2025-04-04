import 'package:flutter/material.dart';
import '../models/inspection_data.dart';

class InspectionDetailView extends StatelessWidget {
  final InspectionData inspectionData;

  const InspectionDetailView({super.key, required this.inspectionData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inspection Details - ${inspectionData.displayLocation}'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                _buildBasicInfoCard(),

                // Checklist Section
                _buildSectionHeader('Checklist'),
                _buildChecklistExpansionPanel(),

                // Systems Section
                _buildSectionHeader('Systems'),
                _buildSystemsExpansionPanel(),

                // Drain Tests Section
                _buildSectionHeader('Drain Tests'),
                _buildDrainTestsCard(),

                // Device Tests Section
                _buildSectionHeader('Device Tests'),
                _buildDeviceTestsPanel(),

                // Additional Details Section
                _buildSectionHeader('Additional Details'),
                _buildAdditionalDetailsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    final form = inspectionData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Bill To', form.billTo),
                          _buildInfoRow('', form.billToLn2),
                          _buildInfoRow('Attention', form.attention),
                          _buildInfoRow('Billing Street', form.billingStreet),
                          _buildInfoRow('', form.billingStreetLn2),
                          _buildInfoRow('City & State', form.billingCityState),
                          _buildInfoRow('', form.billingCityStateLn2),
                          _buildInfoRow('Contact', form.contact),
                          _buildInfoRow('Phone', form.phone),
                          _buildInfoRow('Email', form.email),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Location', form.location),
                          _buildInfoRow('', form.locationLn2),
                          _buildInfoRow('Location Street', form.locationStreet),
                          _buildInfoRow('', form.locationStreetLn2),
                          _buildInfoRow('Location City/State', form.locationCityState),
                          _buildInfoRow('Date', inspectionData.formattedDate),
                          _buildInfoRow('Inspector', form.inspector),
                          _buildInfoRow('Inspection Frequency', form.inspectionFrequency),
                          _buildInfoRow('Inspection Number', form.inspectionNumber),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChecklistExpansionPanel() {
    final form = inspectionData.form;
    return Card(
      child: ExpansionTile(
        title: const Text('Inspection Checklist Details'),
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Building Occupied', form.isTheBuildingOccupied),
                _buildInfoRow('All Systems In Service', form.areAllSystemsInService),
                _buildInfoRow('FP Systems Same as Last Inspection', form.areFpSystemsSameAsLastInspection),
                _buildInfoRow('Main Control Valves Open', form.areAllSprinklerSystemMainControlValvesOpen),
                _buildInfoRow('Other Valves In Proper Position', form.areAllOtherValvesInProperPosition),
                _buildInfoRow('Control Valves Sealed/Supervised', form.areAllControlValvesSealedOrSupervised),
                _buildInfoRow('Control Valves Free of Leaks', form.areAllControlValvesInGoodConditionAndFreeOfLeaks),
                _buildInfoRow('FD Connections Satisfactory', form.areFireDepartmentConnectionsInSatisfactoryCondition),
                _buildInfoRow('FD Caps In Place', form.areCapsInPlace),
                _buildInfoRow('FD Connection Accessible', form.isFireDepartmentConnectionEasilyAccessible),
                _buildInfoRow('Piping Condition Satisfactory', form.isConditionOfPipingAndOtherSystemComponentsSatisfactory),
                _buildInfoRow('Spare Sprinklers Available', form.areAMinimumOf6SpareSprinklersReadilyAvaiable),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemsExpansionPanel() {
    final form = inspectionData.form;
    return Card(
      child: ExpansionTile(
        title: const Text('System Type Information'),
        initiallyExpanded: false,
        children: [
          // Dry System
          if (form.system1Name == 'Dry' || form.isDryValveInServiceAndInGoodCondition != 'N/A')
            _buildSubExpansionTile('Dry System', [
              _buildInfoRow('Dry Valve In Service', form.isDryValveInServiceAndInGoodCondition),
              _buildInfoRow('Intermediate Chamber Not Leaking', form.isDryValveItermediateChamberNotLeaking),
              _buildInfoRow('Fully Tripped Within 3 Years', form.hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears),
              _buildInfoRow('Quick Opening Valves Open', form.areQuickOpeningDeviceControlValvesOpen),
              _buildInfoRow('Low Point Drains List at Riser', form.isThereAListOfKnownLowPointDrainsAtTheRiser),
              _buildInfoRow('Low Points Drained', form.haveKnownLowPointsBeenDrained),
              _buildInfoRow('Oil Level Full on Compressor', form.isOilLevelFullOnAirCompressor),
              _buildInfoRow('Compressor Returns Pressure in 30 Min', form.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder),
              _buildInfoRow('Compressor Start Pressure', '${form.whatPressureDoesAirCompressorStart} PSI: ${form.whatPressureDoesAirCompressorStartPSI}'),
              _buildInfoRow('Compressor Stop Pressure', '${form.whatPressureDoesAirCompressorStop} PSI: ${form.whatPressureDoesAirCompressorStopPSI}'),
              _buildInfoRow('Low Air Alarm Operated', '${form.didLowAirAlarmOperate} PSI: ${form.didLowAirAlarmOperatePSI}'),
            ]),

          // Wet System
          if (form.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition != 'N/A')
            _buildSubExpansionTile('Wet System', [
              _buildInfoRow('Anti-Freeze System Tested', form.haveAntiFreezeSystemsBeenTested),
              _buildInfoRow('Freeze Protection (°F)', form.freezeProtectionInDegreesF),
              _buildInfoRow('Alarm Valves Satisfactory', form.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition),
              _buildInfoRow('Water Flow Test - Inspector Test', form.waterFlowAlarmTestConductedWithInspectorsTest),
              _buildInfoRow('Water Flow Test - Bypass Connection', form.waterFlowAlarmTestConductedWithBypassConnection),
            ]),

          // PreAction/Deluge System
          if (form.areValvesInServiceAndInGoodCondition != 'N/A')
            _buildSubExpansionTile('PreAction/Deluge System', [
              _buildInfoRow('Valves In Service', form.areValvesInServiceAndInGoodCondition),
              _buildInfoRow('Valves Tripped', form.wereValvesTripped),
              _buildInfoRow('Pneumatic Actuator Trip Pressure', '${form.whatPressureDidPneumaticActuatorTrip} PSI: ${form.whatPressureDidPneumaticActuatorTripPSI}'),
              _buildInfoRow('Priming Line Left On', form.wasPrimingLineLeftOnAfterTest),
              _buildInfoRow('PreAction Air Compressor Start', '${form.whatPressureDoesPreactionAirCompressorStart} PSI: ${form.whatPressureDoesPreactionAirCompressorStartPSI}'),
              _buildInfoRow('PreAction Air Compressor Stop', '${form.whatPressureDoesPreactionAirCompressorStop} PSI: ${form.whatPressureDoesPreactionAirCompressorStopPSI}'),
              _buildInfoRow('PreAction Low Air Alarm', '${form.didPreactionLowAirAlarmOperate} PSI: ${form.didPreactionLowAirAlarmOperatePSI}'),
            ]),

          // Alarms Section
          _buildSubExpansionTile('Alarms', [
            _buildInfoRow('Water Motor Gong Works', form.doesWaterMotorGongWork),
            _buildInfoRow('Electric Bell Works', form.doesElectricBellWork),
            _buildInfoRow('Water Flow Alarms Operational', form.areWaterFlowAlarmsOperational),
            _buildInfoRow('Tamper Switches Operational', form.areAllTamperSwitchesOperational),
            _buildInfoRow('Alarm Panel Cleared After Test', form.didAlarmPanelClearAfterTest),
          ]),

          // Sprinkler Components
          _buildSubExpansionTile('Sprinkler Components', [
            _buildInfoRow('Dry Heads < 10 Years Old', '${form.areKnownDryTypeHeadsLessThan10YearsOld} (${form.areKnownDryTypeHeadsLessThan10YearsOldYear})'),
            _buildInfoRow('Quick Response Heads < 20 Years Old', '${form.areKnownQuickResponseHeadsLessThan20YearsOld} (${form.areKnownQuickResponseHeadsLessThan20YearsOldYear})'),
            _buildInfoRow('Standard Response Heads < 50 Years Old', '${form.areKnownStandardResponseHeadsLessThan50YearsOld} (${form.areKnownStandardResponseHeadsLessThan50YearsOldYear})'),
            _buildInfoRow('Gauges Tested/Replaced in 5 Years', '${form.haveAllGaugesBeenTestedOrReplacedInTheLast5Years} (${form.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear})'),
          ]),

          // Fire Pump (if present)
          if (form.isTheFirePumpInService != 'N/A')
            _buildSubExpansionTile('Fire Pump', [
              _buildInfoRow('Pump Room Heated', form.isThePumpRoomHeated),
              _buildInfoRow('Fire Pump In Service', form.isTheFirePumpInService),
              _buildInfoRow('Pump Run During Inspection', form.wasFirePumpRunDuringThisInspection),
              _buildInfoRow('Pump Started in Auto Mode', form.wasThePumpStartedInTheAutomaticModeByAPressureDrop),
              _buildInfoRow('Pump Bearings Lubricated', form.wereThePumpBearingsLubricated),
              _buildInfoRow('Jockey Pump Start Pressure', '${form.jockeyPumpStartPressure} PSI: ${form.jockeyPumpStartPressurePSI}'),
              _buildInfoRow('Jockey Pump Stop Pressure', '${form.jockeyPumpStopPressure} PSI: ${form.jockeyPumpStopPressurePSI}'),
              _buildInfoRow('Fire Pump Start Pressure', '${form.firePumpStartPressure} PSI: ${form.firePumpStartPressurePSI}'),
              _buildInfoRow('Fire Pump Stop Pressure', '${form.firePumpStopPressure} PSI: ${form.firePumpStopPressurePSI}'),
            ]),

          // Diesel Fire Pump (if present)
          if (form.isTheFuelTankAtLeast2_3Full != 'N/A')
            _buildSubExpansionTile('Diesel Fire Pump', [
              _buildInfoRow('Fuel Tank ≥ 2/3 Full', form.isTheFuelTankAtLeast2_3Full),
              _buildInfoRow('Engine Oil Level Correct', form.isEngineOilAtCorrectLevel),
              _buildInfoRow('Engine Coolant Level Correct', form.isEngineCoolantAtCorrectLevel),
              _buildInfoRow('Engine Block Heater Working', form.isTheEngineBlockHeaterWorking),
              _buildInfoRow('Pump Room Ventilation Working', form.isPumpRoomVentilationOperatingProperly),
              _buildInfoRow('Water Discharge Observed', form.wasWaterDischargeObservedFromHeatExchangerReturnLine),
              _buildInfoRow('Cooling Line Strainer Cleaned', form.wasCoolingLineStrainerCleanedAfterTest),
              _buildInfoRow('Pump Run for 30 Minutes', form.wasPumpRunForAtLeast30Minutes),
              _buildInfoRow('Switch in Auto Alarm Works', form.doesTheSwitchInAutoAlarmWork),
              _buildInfoRow('Pump Running Alarm Works', form.doesThePumpRunningAlarmWork),
              _buildInfoRow('Common Alarm Works', form.doesTheCommonAlarmWork),
            ]),

          // Electric Fire Pump (if present)
          if (form.wasCasingReliefValveOperatingProperly != 'N/A')
            _buildSubExpansionTile('Electric Fire Pump', [
              _buildInfoRow('Casing Relief Valve Operating', form.wasCasingReliefValveOperatingProperly),
              _buildInfoRow('Pump Run for 10 Minutes', form.wasPumpRunForAtLeast10Minutes),
              _buildInfoRow('Loss of Power Alarm Works', form.doesTheLossOfPowerAlarmWork),
              _buildInfoRow('Electric Pump Running Alarm Works', form.doesTheElectricPumpRunningAlarmWork),
              _buildInfoRow('Power Failure Simulated', form.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad),
              _buildInfoRow('Transfer to Alternative Power', form.trasferOfPowerToAlternativePowerSourceVerified),
              _buildInfoRow('Power Failure Condition Removed', form.powerFaulureConditionRemoved),
              _buildInfoRow('Reconnected to Normal Power', form.pumpReconnectedToNormalPowerSourceAfterATimeDelay),
            ]),
        ],
      ),
    );
  }

  Widget _buildSubExpansionTile(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: false,
        children: children,
      ),
    );
  }

  Widget _buildDrainTestsCard() {
    final form = inspectionData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (form.system1Name.isNotEmpty) ...[
              _buildInfoRow('System 1', form.system1Name),
              _buildInfoRow('Drain Size', form.system1DrainSize),
              _buildInfoRow('Static PSI', form.system1StaticPSI),
              _buildInfoRow('Residual PSI', form.system1ResidualPSI),
              const Divider(),
            ],
            if (form.system2Name.isNotEmpty) ...[
              _buildInfoRow('System 2', form.system2Name),
              _buildInfoRow('Drain Size', form.system2DrainSize),
              _buildInfoRow('Static PSI', form.system2StaticPSI),
              _buildInfoRow('Residual PSI', form.system2ResidualPSI),
              const Divider(),
            ],
            if (form.system3Name.isNotEmpty) ...[
              _buildInfoRow('System 3', form.system3Name),
              _buildInfoRow('Drain Size', form.system3DrainSize),
              _buildInfoRow('Static PSI', form.system3StaticPSI),
              _buildInfoRow('Residual PSI', form.system3ResidualPSI),
              const Divider(),
            ],
            if (form.drainTestNotes.isNotEmpty)
              _buildInfoRow('Notes', form.drainTestNotes),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTestsPanel() {
    final deviceTests = inspectionData.getDeviceTests();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: deviceTests.isEmpty
              ? [const Text('No device tests recorded')]
              : deviceTests.map((test) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Device', test['device'] ?? ''),
                      _buildInfoRow('Address', test['address'] ?? ''),
                      _buildInfoRow('Description', test['description'] ?? ''),
                      _buildInfoRow('Operated', test['operated'] ?? ''),
                      _buildInfoRow('Delay (sec)', test['delay'] ?? ''),
                      const Divider(),
                    ],
                  );
                }).toList(),
        ),
      ),
    );
  }

  Widget _buildAdditionalDetailsCard() {
    final form = inspectionData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (form.adjustmentsOrCorrectionsMake.isNotEmpty)
              _buildInfoRow('Adjustments or Corrections', form.adjustmentsOrCorrectionsMake),
            if (form.explanationOfAnyNoAnswers.isNotEmpty) ...[
              _buildInfoRow('Explanation of No Answers', form.explanationOfAnyNoAnswers),
              if (form.explanationOfAnyNoAnswersContinued.isNotEmpty)
                _buildInfoRow('', form.explanationOfAnyNoAnswersContinued),
            ],
            if (form.notes.isNotEmpty)
              _buildInfoRow('Additional Notes', form.notes),
            const SizedBox(height: 16),
            _buildInfoRow('PDF Path', form.pdfPath),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    // Skip empty rows if the label is also empty
    if (label.isEmpty && (value.isEmpty || value == 'N/A')) {
      return const SizedBox.shrink();
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label.isEmpty ? '' : '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}