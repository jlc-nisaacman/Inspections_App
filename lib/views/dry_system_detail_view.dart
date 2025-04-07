// lib/views/dry_system_detail_view.dart
import 'package:flutter/material.dart';
import '../models/dry_system_data.dart';

class DrySystemDetailView extends StatelessWidget {
  final DrySystemData drySystemData;

  const DrySystemDetailView({super.key, required this.drySystemData});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
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
                // Basic Information Section
                _buildSectionHeader('Inspection Information'),
                _buildBasicInfoCard(),

                // Dry System Details Section
                _buildSectionHeader('Dry System Details'),
                _buildDrySystemDetailsCard(),

                // Additional Details Section
                _buildSectionHeader('Additional Information'),
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
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Date', drySystemData.formattedDate),
            _buildInfoRow('Location', form.location),
            _buildInfoRow('Location City/State', form.locationCityState),
            _buildInfoRow('Inspector', form.inspector),
            _buildInfoRow('PDF Path', form.pdfPath),
          ],
        ),
      ),
    );
  }

  Widget _buildDrySystemDetailsCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Is Dry Valve In Service?', 
              form.isDryValveInService
            ),
            _buildInfoRow(
              'Is Dry Pipe Valve Intermediate Chamber Not Leaking?', 
              form.isDryPipeValveIntermediateChamberNotLeaking
            ),
            _buildInfoRow(
              'Are Quick Opening Device Control Valves Open?', 
              form.areQuickOpeningDeviceControlValvesOpen
            ),
            _buildInfoRow(
              'Is There a List of Known Low Point Drains?', 
              form.isThereAListOfKnownLowPointDrains
            ),
            _buildInfoRow(
              'Have Known Low Points Been Drained?', 
              form.haveKnownLowPointsBeenDrained
            ),
            _buildInfoRow(
              'Is Oil Level Full on Air Compressor?', 
              form.isOilLevelFullOnAirCompressor
            ),
            _buildInfoRow(
              'Does Air Compressor Return System Pressure in 30 Minutes?', 
              form.doesAirCompressorReturnSystemPressureIn30Minutes
            ),
            _buildInfoRow(
              'Air Compressor Start Pressure', 
              form.airCompressorStartPressure
            ),
            _buildInfoRow(
              'Air Compressor Start Pressure PSI', 
              form.airCompressorStartPressurePSI
            ),
            _buildInfoRow(
              'Air Compressor Stop Pressure', 
              form.airCompressorStopPressure
            ),
            _buildInfoRow(
              'Air Compressor Stop Pressure PSI', 
              form.airCompressorStopPressurePSI
            ),
            _buildInfoRow(
              'Did Low Air Alarm Operate?', 
              form.didLowAirAlarmOperate
            ),
            _buildInfoRow(
              'Low Air Alarm Operate PSI', 
              form.didLowAirAlarmOperatePSI
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetailsCard() {
    final form = drySystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Date of Last Full Trip Test', 
              form.dateOfLastFullTripTest
            ),
            _buildInfoRow(
              'Date of Last Internal Inspection', 
              form.dateOfLastInternalInspection
            ),
            if (form.notes.isNotEmpty)
              _buildInfoRow('Notes', form.notes),
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