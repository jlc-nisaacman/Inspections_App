// lib/views/pump_system_detail_view.dart
import 'package:flutter/material.dart';
import '../models/pump_system_data.dart';

class PumpSystemDetailView extends StatelessWidget {
  final PumpSystemData pumpSystemData;

  const PumpSystemDetailView({super.key, required this.pumpSystemData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pump System Details - ${pumpSystemData.displayLocation}',
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('Fire Pump Test Report'),
                _buildBasicInfoCard(),

                _buildSectionHeader('Pump Information'),
                _buildPumpInfoCard(),

                _buildSectionHeader('Pump Controller Information'),
                _buildPumpControlerInfoCard(),

                if (pumpSystemData.form.pumpPower == " Diesel") ...[
                  _buildSectionHeader('Diesel Engine Information'),
                  _buildDieselEngineInfoCard(),
                ],

                _buildSectionHeader('Flow Test'),
                _buildFlowTestCard(),

                _buildSectionHeader('Notes'),
                _buildRemarksCard(),

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
    final form = pumpSystemData.form;
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
                          _buildInfoRow('Report To', form.reportTo),
                          _buildInfoRow('Attention', form.attention),
                          _buildInfoRow('Street', form.street),
                          _buildInfoRow('City & State', form.cityState),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Building', form.building),
                          _buildInfoRow('Inspector', form.inspector),
                          _buildInfoRow('Date', pumpSystemData.formattedDate),
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

  Widget _buildPumpInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.pumpMake),
            _buildInfoRow('Model', form.pumpModel),
            _buildInfoRow('Serial Number', form.pumpSerialNumber),
            _buildInfoRow('Power', form.pumpPower),
            _buildInfoRow('Water Supply', form.pumpWaterSupply),
          ],
        ),
      ),
    );
  }

  Widget _buildPumpControlerInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.pumpControllerMake),
            _buildInfoRow('Model', form.pumpControllerModel),
            _buildInfoRow('Serial Number', form.pumpControllerSerialNumber),
            _buildInfoRow('Voltage', form.pumpControllerVoltage),
            _buildInfoRow('HP', form.pumpControllerHorsePower),
            _buildInfoRow('Supervision', form.pumpControllerSupervision),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowTestCard() {
    final flowtest = pumpSystemData.getFlowTests();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
            flowtest.isEmpty
            ? [const Text('No Flow Tests Recorded')]
            : flowtest.map((test) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Suction PSI', test['suctionPSI'] ?? ''),
                  _buildInfoRow('Discharge PSI', test['dischargePSI'] ?? ''),
                  _buildInfoRow('Net PSI', test['netPSI'] ?? ''),
                  _buildInfoRow('RPM', test['rpm'] ?? ''),
                  _buildInfoRow('Total Flow', test['totalFlow'] ?? ''),
                  SizedBox(height: 50.0,),

                  // Dynamically build orifice, pitot, and GPM rows
                  ...List.generate(7, (index) {
                    final orificeSize = test['orificeSize${index + 1}'] ?? '';
                    final pitot = test['pitot${index + 1}'] ?? '';
                    final gpm = test['gpm${index + 1}'] ?? '';

                    // Only add widgets if at least one value is non-empty
                    if (orificeSize.isNotEmpty || pitot.isNotEmpty || gpm.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (orificeSize.isNotEmpty)
                            _buildInfoRow('Orifice Size ${index + 1}', orificeSize),
                            _buildInfoRow('Pitot ${index + 1}', pitot),
                            _buildInfoRow('GPM ${index + 1}', gpm),
                        ],
                      );
                    }
                    return const SizedBox.shrink(); // Return empty widget if no data
                  }),
                  const Divider(),
                  const Divider(),
                ],
              );
            }).toList(),
        ),
      ),
    );
  }

  Widget _buildDieselEngineInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.dieselEngineMake),
            _buildInfoRow('Model', form.dieselEngineModel),
            _buildInfoRow('Serial Number', form.dieselEngineSerialNumber),
            _buildInfoRow('Hours', form.dieselEngineHours),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Remarks On Test', form.remarksOnTest),
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
