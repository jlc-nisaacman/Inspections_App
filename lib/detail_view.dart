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
                // _buildChecklistExpansionPanel(),

                // Systems Section
                _buildSectionHeader('Systems'),
                // _buildSystemsExpansionPanel(),

                // Drain Tests Section
                _buildSectionHeader('Drain Tests'),
                // _buildDrainTestsCard(),

                // Additional Details Section
                _buildSectionHeader('Additional Details'),
                // _buildAdditionalDetailsCard(),
                Text(inspectionData.form.pdfPath)
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
                        children: [
                          _buildInfoRow('Location', form.location),
                          _buildInfoRow('', form.locationLn2),
                          _buildInfoRow('Location Street', form.locationStreet),
                          _buildInfoRow('', form.locationStreetLn2),
                          _buildInfoRow('Date', inspectionData.formattedDate),
                          _buildInfoRow('Inspector', form.inspector),
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

  // Widget _buildChecklistExpansionPanel() {
  //   final checklist = inspectionData.checklist;
  //   return ExpansionTile(
  //     title: const Text('Inspection Checklist Details'),
  //     children: [
  //       ListTile(
  //         title: const Text('General Inspection'),
  //         trailing: Text(checklist.x1a),
  //       ),
  //       ListTile(
  //         title: const Text('Control Valves'),
  //         trailing: Text(checklist.x3a),
  //       ),
  //       // Add more checklist items as needed
  //     ],
  //   );
  // }

  // Widget _buildSystemsExpansionPanel() {
  //   final systems = inspectionData.systems;
  //   return ExpansionTile(
  //     title: const Text('Sprinkler System Details'),
  //     children: [
  //       _buildSystemSubsection(
  //         'Fire Pump General',
  //         systems.firePumpGeneral.isPumpRoomHeated,
  //       ),
  //       _buildSystemSubsection(
  //         'Diesel Fire Pump',
  //         systems.dieselFirePump.isFuelTankAtLeast2_3Full,
  //       ),
  //       _buildSystemSubsection(
  //         'Electric Fire Pump',
  //         systems.electricFirePump.wasCasingReliefValveOperating,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSystemSubsection(String title, String value) {
  //   return ListTile(title: Text(title), trailing: Text(value));
  // }

  // Widget _buildDrainTestsCard() {
  //   final drainTests = inspectionData.drainTests;
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildInfoRow('Drain Test Line 1', drainTests.drainTestLine1),
  //           _buildInfoRow('Drain Size 1', drainTests.drianSize1),
  //           _buildInfoRow('Static PSI 1', drainTests.static1),
  //           _buildInfoRow('Residual PSI 1', drainTests.residual1),
  //           _buildInfoRow('Drain Test Notes', drainTests.drainTestNotes),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAdditionalDetailsCard() {
  //   final additionalDetails = inspectionData.additionalDetails;
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildInfoRow(
  //             'Adjustments or Corrections',
  //             additionalDetails.x16AdjustmentsOrCorrections,
  //           ),
  //           _buildInfoRow(
  //             'Explanation of No Answers',
  //             additionalDetails.x17ExplanationOfNoAnswers,
  //           ),
  //           _buildInfoRow('Additional Notes', additionalDetails.x18Notes),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
