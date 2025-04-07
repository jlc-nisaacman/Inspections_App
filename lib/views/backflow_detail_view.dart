// lib/views/backflow_detail_view.dart
import 'package:flutter/material.dart';
import '../models/backflow_data.dart';

class BackflowDetailView extends StatelessWidget {
  final BackflowData backflowData;

  const BackflowDetailView({super.key, required this.backflowData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Backflow Details - ${backflowData.displayLocation}',
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('Basic Information'),
                _buildBasicInfoCard(),

                _buildSectionHeader('Backflow Device Details'),
                _buildDeviceDetailsCard(),

                _buildSectionHeader('Test Results'),
                _buildTestResultsCard(),

                _buildSectionHeader('Remarks'),
                _buildRemarksCard(),

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
    final form = backflowData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Date', backflowData.formattedDate),
            _buildInfoRow('Test Type', form.testType),
            _buildInfoRow('Tested By', form.testedBy),
            _buildInfoRow('Witness', form.witness),
            _buildInfoRow('Contact Person', form.contactPerson),
            _buildInfoRow('Owner of Property', form.ownerOfProperty),
            _buildInfoRow('Mailing Address', form.mailingAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceDetailsCard() {
    final form = backflowData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Device Location', form.deviceLocation),
            _buildInfoRow('Backflow Make', form.backflowMake),
            _buildInfoRow('Backflow Model', form.backflowModel),
            _buildInfoRow('Serial Number', form.backflowSerialNumber),
            _buildInfoRow('Backflow Size', form.backflowSize),
            _buildInfoRow('Backflow Type', form.backflowType),
            _buildInfoRow('Protection Type', form.protectionType),
            _buildInfoRow('Certificate Number', form.certificateNumber),
            _buildInfoRow('Downstream Shutoff Valve Status', form.downstreamShutoffValveStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultsCard() {
    final form = backflowData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionSubheader('DCVA Test'),
            _buildInfoRow('Back Pressure Test 1 PSI', form.dcvaBackPressureTest1PSI),
            _buildInfoRow('Back Pressure Test 4 PSI', form.dcvaBackPressureTest4PSI),
            _buildInfoRow('Check Valve 1 PSID', form.dcvaCheckValve1PSID),
            _buildInfoRow('Check Valve 2 PSID', form.dcvaCheckValve2PSID),
            _buildInfoRow('Flow', form.dcvaFlow),
            _buildInfoRow('No Flow', form.dcvaNoFlow),

            const Divider(),
            _buildSectionSubheader('PVB/SRVB Test'),
            _buildInfoRow('Air Inlet Valve Did Not Open', form.pvbSrvbAirInletValveDidNotOpen),
            _buildInfoRow('Air Inlet Valve Opened At PSID', form.pvbSrvbAirInletValveOpenedAtPSID),
            _buildInfoRow('Check Valve Flow', form.pvbSrvbCheckValveFlow),
            _buildInfoRow('Check Valve PSID', form.pvbSrvbCheckValvePSID),

            const Divider(),
            _buildSectionSubheader('RPZ Test'),
            _buildInfoRow('Check Valve 1 Closed Tight', form.rpzCheckValve1ClosedTight),
            _buildInfoRow('Check Valve 1 Leaked', form.rpzCheckValve1Leaked),
            _buildInfoRow('Check Valve 1 PSID', form.rpzCheckValve1PSID),
            _buildInfoRow('Check Valve 2 Closed Tight', form.rpzCheckValve2ClosedTight),
            _buildInfoRow('Check Valve 2 Leaked', form.rpzCheckValve2Leaked),
            _buildInfoRow('Check Valve 2 PSID', form.rpzCheckValve2PSID),
            _buildInfoRow('Check Valve Flow', form.rpzCheckValveFlow),
            _buildInfoRow('Check Valve No Flow', form.rpzCheckValveNoFlow),
            _buildInfoRow('Relief Valve Did Not Open', form.rpzReliefValveDidNotOpen),
            _buildInfoRow('Relief Valve Opened At PSID', form.rpzReliefValveOpenedAtPSID),

            const Divider(),
            _buildInfoRow('Result', form.result),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard() {
    final form = backflowData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Remarks 1', form.remarks1),
            _buildInfoRow('Remarks 2', form.remarks2),
            _buildInfoRow('Remarks 3', form.remarks3),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetailsCard() {
    final form = backflowData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('PDF Path', form.pdfPath),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSubheader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
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