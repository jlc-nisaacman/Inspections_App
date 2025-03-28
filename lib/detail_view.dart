import 'package:flutter/material.dart';
import 'models.dart';

class InspectionDetailView extends StatelessWidget {
  final InspectionData inspectionData;

  const InspectionDetailView({super.key, required this.inspectionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Date', inspectionData.formattedDate),
              const SizedBox(height: 12),
              _buildDetailRow('Inspector', inspectionData.inspector),
              const SizedBox(height: 12),
              _buildDetailRow('Location', inspectionData.location),
              const SizedBox(height: 12),
              _buildDetailRow('City/State', inspectionData.locationCityState),
              const SizedBox(height: 12),
              _buildDetailRow('PDF Path', inspectionData.pdfPath),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
