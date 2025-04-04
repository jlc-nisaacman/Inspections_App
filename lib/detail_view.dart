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
                _buildSectionHeader('Inspection Information'),
                _buildBasicInfoCard(),

                // Checklist Section
                _buildSectionHeader('Checklist'),
                _buildChecklistExpansionPanel(),

                // Drain Tests Section
                _buildSectionHeader('Main Drain Tests'),
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
                          _buildInfoRow(
                            'Location City/State',
                            form.locationCityState,
                          ),
                          _buildInfoRow('Date', inspectionData.formattedDate),
                          _buildInfoRow('Inspector', form.inspector),
                          _buildInfoRow(
                            'Inspection Frequency',
                            form.inspectionFrequency,
                          ),
                          _buildInfoRow(
                            'Inspection Number',
                            form.inspectionNumber,
                          ),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubExpansionTile("General", [
              _buildInfoRow(
                'Is the building occupied?',
                form.isTheBuildingOccupied,
              ),
              _buildInfoRow(
                'Are all systems in service?',
                form.areAllSystemsInService,
              ),
              _buildInfoRow(
                'Are fire protection systems same as last inspection?',
                form.areFpSystemsSameAsLastInspection,
              ),
              _buildInfoRow(
                'Hydraulic nameplate securely attached and legible?',
                form.hydraulicNameplateSecurelyAttachedAndLegible,
              ),
            ]),
            _buildSubExpansionTile("Water Supplies", [
              _buildInfoRow(
                'Was a main drain flow test conducted?',
                form.wasAMainDrainWaterFlowTestConducted,
              ),
            ]),
            _buildSubExpansionTile("Control Valves", [
              _buildInfoRow(
                'Are all sprinkler system main control valves open?',
                form.areAllSprinklerSystemMainControlValvesOpen,
              ),
              _buildInfoRow(
                'Are all other valves in proper position?',
                form.areAllOtherValvesInProperPosition,
              ),
              _buildInfoRow(
                'Are all control valves sealed or supervised?',
                form.areAllControlValvesSealedOrSupervised,
              ),
              _buildInfoRow(
                'Are all control valves in good condition, and free of leaks?',
                form.areAllControlValvesInGoodConditionAndFreeOfLeaks,
              ),
            ]),
            _buildSubExpansionTile("Fire Dept. Connections", [
              _buildInfoRow(
                'Are fire dept. connections in satisfactory condition?',
                form.areFireDepartmentConnectionsInSatisfactoryCondition,
              ),
              _buildInfoRow('Are caps in place?', form.areCapsInPlace),
              _buildInfoRow(
                'Is fire dept. connection easily accessible?',
                form.isFireDepartmentConnectionEasilyAccessible,
              ),
              _buildInfoRow(
                'Automatic drain valve in place?',
                form.automaticDrainValeInPlace,
              ),
            ]),
            _buildSubExpansionTile("Fire Pump General", [
              _buildInfoRow(
                'Is the pump room heated?',
                form.isThePumpRoomHeated,
              ),
              _buildInfoRow(
                'Is the fire pump in service?',
                form.isTheFirePumpInService,
              ),
              _buildInfoRow(
                'Was fire pump run during this inspection?',
                form.wasFirePumpRunDuringThisInspection,
              ),
              _buildInfoRow(
                'Was the pump started in the automatic mode by a pressure drop?',
                form.wasThePumpStartedInTheAutomaticModeByAPressureDrop,
              ),
              _buildInfoRow(
                'Were the pump bearings lubricated?',
                form.wereThePumpBearingsLubricated,
              ),
              _buildInfoRow(
                'Jockey pump start pressure?',
                form.jockeyPumpStartPressure,
              ),
              _buildInfoRow(
                'Jockey pump start pressure PSI?',
                form.jockeyPumpStartPressurePSI,
              ),
              _buildInfoRow(
                'Jockey pump stop pressure?',
                form.jockeyPumpStopPressure,
              ),
              _buildInfoRow(
                'Jockey pump stop pressure PSI?',
                form.jockeyPumpStopPressurePSI,
              ),
              _buildInfoRow(
                'Fire pump start pressure?',
                form.firePumpStartPressure,
              ),
              _buildInfoRow(
                'Fire pump start pressure PSI? ',
                form.firePumpStartPressurePSI,
              ),
              _buildInfoRow(
                'Fire pump stop pressure?',
                form.firePumpStopPressure,
              ),
              _buildInfoRow(
                'Fire pump stop pressure PSI?',
                form.firePumpStopPressurePSI,
              ),
            ]),
            _buildSubExpansionTile("Diesel Fire Pump", [
              _buildInfoRow(
                'Is the fuel tank at least 2/3 full?',
                form.isTheFuelTankAtLeast2_3Full,
              ),
              _buildInfoRow(
                'Is engine oil at correct level?',
                form.isEngineOilAtCorrectLevel,
              ),
              _buildInfoRow(
                'Is engine coolant at correct level?',
                form.isEngineCoolantAtCorrectLevel,
              ),
              _buildInfoRow(
                'Is the engine block heater working?',
                form.isTheEngineBlockHeaterWorking,
              ),
              _buildInfoRow(
                'Is pump room ventilation operating properly?',
                form.isPumpRoomVentilationOperatingProperly,
              ),
              _buildInfoRow(
                'Was water discharge observed from heat exchanger return line?',
                form.wasWaterDischargeObservedFromHeatExchangerReturnLine,
              ),
              _buildInfoRow(
                'Was cooling line strainer cleaned after test?',
                form.wasCoolingLineStrainerCleanedAfterTest,
              ),
              _buildInfoRow(
                'Does the switch in auto alarm work?',
                form.doesTheSwitchInAutoAlarmWork,
              ),
              _buildInfoRow(
                'Does the pump running alarm work?',
                form.doesThePumpRunningAlarmWork,
              ),
              _buildInfoRow(
                'Does the common alarm work?',
                form.doesTheCommonAlarmWork,
              ),
            ]),
            _buildSubExpansionTile("Electric Fire Pump", [
              _buildInfoRow(
                'Was casing relief valve operating properly?',
                form.wasCasingReliefValveOperatingProperly,
              ),
              _buildInfoRow(
                'Was pump run for at least 10 minutes?',
                form.wasPumpRunForAtLeast10Minutes,
              ),
              _buildInfoRow(
                'Does the loss of power alarm work?',
                form.doesTheLossOfPowerAlarmWork,
              ),
              _buildInfoRow(
                'Does the pump running alarm work?',
                form.doesThePumpRunningAlarmWork,
              ),
              _buildInfoRow(
                'Power failure condition simulated while pump operating at peak load?',
                form.powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad,
              ),
              _buildInfoRow(
                'Transfer of power to alternate power source verified?',
                form.trasferOfPowerToAlternativePowerSourceVerified,
              ),
              _buildInfoRow(
                'Pump reconnected to normal power source after a time delay?',
                form.pumpReconnectedToNormalPowerSourceAfterATimeDelay,
              ),
            ]),
            _buildSubExpansionTile("Wet Systems", [
              _buildInfoRow(
                'Have anti-freeze systems been tested?',
                form.haveAntiFreezeSystemsBeenTested,
              ),
              _buildInfoRow(
                'Freeze Protection in °F:',
                form.freezeProtectionInDegreesF,
              ),
              _buildInfoRow(
                'Are alarm valves, water flow devices and retards in satisfactory condition?',
                form.areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition,
              ),
              _buildInfoRow(
                'Water flow alarm test conducted with inspectors test?',
                form.waterFlowAlarmTestConductedWithInspectorsTest,
              ),
            ]),
            _buildSubExpansionTile("Dry Systems", [
              _buildInfoRow(
                'Is dry valve in service and in good condition?',
                form.isDryValveInServiceAndInGoodCondition,
              ),
              _buildInfoRow(
                'Is the dry pipe valve intermediate chamber not leaking?',
                form.isDryValveItermediateChamberNotLeaking,
              ),
              _buildInfoRow(
                'Are quick opening device control valves open?',
                form.areQuickOpeningDeviceControlValvesOpen,
              ),
              _buildInfoRow(
                'Is there a list of known low point drains at the riser?',
                form.isThereAListOfKnownLowPointDrainsAtTheRiser,
              ),
              _buildInfoRow(
                'Have known low points been drained?',
                form.haveKnownLowPointsBeenDrained,
              ),
              _buildInfoRow(
                'Is oil level full on air compressor?',
                form.isOilLevelFullOnAirCompressor,
              ),
              _buildInfoRow(
                'Does the air compressor return system pressure in 30 minutes or under?',
                form.doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder,
              ),
              _buildInfoRow(
                'What pressure does air compressor start?',
                form.whatPressureDoesAirCompressorStart,
              ),
              _buildInfoRow(
                'What pressure does air compressor start PSI?',
                form.whatPressureDoesAirCompressorStartPSI,
              ),
              _buildInfoRow(
                'What pressure does air compressor stop?',
                form.whatPressureDoesAirCompressorStop,
              ),
              _buildInfoRow(
                'What pressure does air compressor stop PSI?',
                form.whatPressureDoesAirCompressorStopPSI,
              ),
              _buildInfoRow(
                'Did low air alarm operate?',
                form.didLowAirAlarmOperate,
              ),
              _buildInfoRow(
                'Did low air alarm operate PSI?',
                form.didLowAirAlarmOperatePSI,
              ),
            ]),
            _buildSubExpansionTile("Pre-Action & Deluge Systems", [
              _buildInfoRow('Are valves in service and in good condition?', form.areValvesInServiceAndInGoodCondition,),
              _buildInfoRow('Were valves tripped?', form.wereValvesTripped,),
              _buildInfoRow('What pressure did pneumatic actuator trip?', form.whatPressureDidPneumaticActuatorTrip,),
              _buildInfoRow('What pressure did pneumatic actuator trip PSI?', form.whatPressureDidPneumaticActuatorTripPSI,),
              _buildInfoRow('Was priming line left on after test?', form.wasPrimingLineLeftOnAfterTest,),
              _buildInfoRow('What pressure does air compressor start?', form.whatPressureDoesPreactionAirCompressorStart,),
              _buildInfoRow('What pressure does air compressor start PSI?', form.whatPressureDoesPreactionAirCompressorStartPSI,),
              _buildInfoRow('What pressure does air compressor stop?', form.whatPressureDoesPreactionAirCompressorStart,),
              _buildInfoRow('What pressure does air compressor stop PSI?', form.whatPressureDoesPreactionAirCompressorStartPSI,),
              _buildInfoRow('Did low air alarm operate?', form.didPreactionLowAirAlarmOperate,),
              _buildInfoRow('Did low air alarm operate PSI?', form.didPreactionLowAirAlarmOperatePSI,),
            ]),
            _buildSubExpansionTile("Alarms", [
              _buildInfoRow('Does water motor gong work?', form.doesWaterMotorGongWork,),
              _buildInfoRow('Does electric bell work?', form.doesElectricBellWork,),
              _buildInfoRow('Are water flow alarms operational?', form.areWaterFlowAlarmsOperational,),
              _buildInfoRow('Are all tamper switches operational?', form.areAllTamperSwitchesOperational,),
              _buildInfoRow('Did alarm panel clear after test?', form.didAlarmPanelClearAfterTest,),
            ]),
            _buildSubExpansionTile("Sprinklers Piping", [
              _buildInfoRow('Are a minimum of 6 spare sprinklers readily available?', form.areAMinimumOf6SpareSprinklersReadilyAvaiable,),
              _buildInfoRow('Is condition of piping and other system components satisfactory?', form.isConditionOfPipingAndOtherSystemComponentsSatisfactory,),
              _buildInfoRow('Are known dry type heads less than 15 years old?', form.areKnownDryTypeHeadsLessThan10YearsOld,),
              _buildInfoRow('Are known dry type heads less than 15 years old, Year?', form.areKnownDryTypeHeadsLessThan10YearsOldYear,),
              _buildInfoRow('Are known quick response heads less than 20 years old?', form.areKnownQuickResponseHeadsLessThan20YearsOld,),
              _buildInfoRow('Are known quick response heads less than 20 years old, Year?', form.areKnownQuickResponseHeadsLessThan20YearsOldYear,),
              _buildInfoRow('Are known standard response heads less than 50 years old?', form.areKnownStandardResponseHeadsLessThan50YearsOld,),
              _buildInfoRow('Are known standard response heads less than 50 years old, Year?', form.areKnownStandardResponseHeadsLessThan50YearsOldYear,),
              _buildInfoRow('Have all gauges been tested or replaced in the last 5 years?', form.haveAllGaugesBeenTestedOrReplacedInTheLast5Years,),
              _buildInfoRow('Have all gauges been tested or replaced in the last 5 years, Year?', form.haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear,),
            ]),
          ],
        ),
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
          children:
              deviceTests.isEmpty
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
            if (form.drainTestNotes.isNotEmpty)
              _buildInfoRow(
                'Drain Test Notes',
                form.drainTestNotes,
              ),
            if (form.adjustmentsOrCorrectionsMake.isNotEmpty)
              _buildInfoRow(
                'Adjustments or Corrections',
                form.adjustmentsOrCorrectionsMake,
              ),
            if (form.explanationOfAnyNoAnswers.isNotEmpty) ...[
              _buildInfoRow(
                'Explanation of No Answers',
                form.explanationOfAnyNoAnswers,
              ),
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

    // Determine the value widget
    Widget valueWidget;
    if (value.isEmpty) {
      valueWidget = Text(
        'N/A',
        style: const TextStyle(color: Colors.black87),
        textAlign: TextAlign.center,
      );
    } else if (value.toUpperCase() == 'NO') {
      valueWidget = _conditionalTextRed(value);
    } else {
      valueWidget = Text(
        value,
        style: const TextStyle(color: Colors.black87),
        textAlign: TextAlign.center,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label.isEmpty ? '' : label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(flex: 2, child: valueWidget),
        ],
      ),
    );
  }

  Widget _conditionalTextRed(String data) {
    return Text(
      data,
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    );
  }
}