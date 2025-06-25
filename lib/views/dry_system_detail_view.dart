// lib/views/dry_system_detail_view.dart
import 'package:flutter/material.dart';
import '../models/dry_system_data.dart';

class DrySystemDetailView extends StatelessWidget {
  final DrySystemData drySystemData;

  const DrySystemDetailView({super.key, required this.drySystemData});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Dry System Details - ${drySystemData.displayLocation}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('Dry Pipe Valve Test Report'),
              _buildBasicInfoCard(),
    
              _buildSectionHeader('Dry Pipe Valve Information'),
              _buildDryPipeValveInfoCard(),
    
              _buildSectionHeader('Quick Opening Device Information'),
              _buildQuickOpeningDeviceInfoCard(),
    
              _buildSectionHeader('Trip Test'),
              _buildTripTestCard(),
    
              _buildSectionHeader('Notes'),
              _buildRemarksCard()
            ],
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
    final form = drySystemData.form;
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
                        _buildInfoRow('', form.reportTo2),
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
                        _buildInfoRow('', form.building2),
                        _buildInfoRow('Inspector', form.inspector),
                        _buildInfoRow('Date', drySystemData.formattedDate),

                      ],
                    ),
                  )
                ],
              )
            ],
          );
  }),
      ),
    );
  }

  Widget _buildDryPipeValveInfoCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Make', 
              form.dryPipeValveMake
            ),
            _buildInfoRow(
              'Model', 
              form.dryPipeValveModel
            ),
            _buildInfoRow(
              'Size', 
              form.dryPipeValveSize
            ),
            _buildInfoRow(
              'Year', 
              form.dryPipeValveYear
            ),
            _buildInfoRow(
              'Controls Sprinklers In', 
              form.dryPipeValveControlsSprinklersIn
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOpeningDeviceInfoCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Make', 
              form.quickOpeningDeviceMake
            ),
            _buildInfoRow(
              'Model', 
              form.quickOpeningDeviceModel
            ),
            _buildInfoRow(
              'Control Valve Open', 
              form.quickOpeningDeviceControlValveOpen
            ),
            _buildInfoRow(
              'Year', 
              form.quickOpeningDeviceYear
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTestCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Air Pressure Before Test', 
              form.tripTestAirPressureBeforeTest
            ),
            _buildInfoRow(
              'Water Pressure Before Test', 
              form.tripTestWaterPressureBeforeTest
            ),
            _buildInfoRow(
              'System Tripped At', 
              form.tripTestAirSystemTrippedAt
            ),
            _buildInfoRow('Test Trip Time', form.tripTestTime),
            _buildInfoRow('Q.O.D. Operated At', form.tripTestAirQuickOpeningDeviceOperatedAt),
            _buildInfoRow('Water At Inspectors Test', form.tripTestTimeWaterAtInspectorsTest),
            _buildInfoRow('Static Water Pressure', form.tripTestStaticWaterPressure),
            _buildInfoRow('Residual Water Pressure', form.tripTestResidualWaterPressure),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Remarks on Test', 
              form.remarksOnTest
            ),
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