import 'package:flutter/material.dart';
import '../models/inspection_data.dart';

class InspectionDetailView extends StatelessWidget {
  final InspectionData inspectionData;

  const InspectionDetailView({super.key, required this.inspectionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              // Additional Details Section
              _buildSectionHeader('Additional Details'),
              _buildAdditionalDetailsCard(),
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
    final basicInfo = inspectionData.basicInfo;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Date', inspectionData.formattedDate),
            _buildInfoRow('Inspector', basicInfo.inspector),
            _buildInfoRow('Location', basicInfo.location),
            _buildInfoRow('Address', basicInfo.street),
            _buildInfoRow('City/State', basicInfo.cityState2),
            _buildInfoRow('Contact', basicInfo.contact),
            _buildInfoRow('Phone', basicInfo.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistExpansionPanel() {
    final checklist = inspectionData.checklist;
    return ExpansionTile(
      title: const Text('Inspection Checklist Details'),
      children: [
        ListTile(
          title: const Text('General Inspection'),
          trailing: Text(checklist.x1a),
        ),
        ListTile(
          title: const Text('Control Valves'),
          trailing: Text(checklist.x3a),
        ),
        // Add more checklist items as needed
      ],
    );
  }

  Widget _buildSystemsExpansionPanel() {
    final systems = inspectionData.systems;
    return ExpansionTile(
      title: const Text('Sprinkler System Details'),
      children: [
        _buildSystemSubsection(
          'Fire Pump General', 
          systems.firePumpGeneral.isPumpRoomHeated,
        ),
        _buildSystemSubsection(
          'Diesel Fire Pump', 
          systems.dieselFirePump.isFuelTankAtLeast2_3Full,
        ),
        _buildSystemSubsection(
          'Electric Fire Pump', 
          systems.electricFirePump.wasCasingReliefValveOperating,
        ),
      ],
    );
  }

  Widget _buildSystemSubsection(String title, String value) {
    return ListTile(
      title: Text(title),
      trailing: Text(value),
    );
  }

  Widget _buildDrainTestsCard() {
    final drainTests = inspectionData.drainTests;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Drain Test Line 1', drainTests.drainTestLine1),
            _buildInfoRow('Drain Size 1', drainTests.drianSize1),
            _buildInfoRow('Static PSI 1', drainTests.static1),
            _buildInfoRow('Residual PSI 1', drainTests.residual1),
            _buildInfoRow('Drain Test Notes', drainTests.drainTestNotes),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalDetailsCard() {
    final additionalDetails = inspectionData.additionalDetails;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              'Adjustments or Corrections', 
              additionalDetails.x16AdjustmentsOrCorrections,
            ),
            _buildInfoRow(
              'Explanation of No Answers', 
              additionalDetails.x17ExplanationOfNoAnswers,
            ),
            _buildInfoRow(
              'Additional Notes', 
              additionalDetails.x18Notes,
            ),
          ],
        ),
      ),
    );
  }

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