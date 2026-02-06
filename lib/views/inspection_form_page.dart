// lib/views/inspection_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_config_provider.dart';
import '../providers/inspection_form_aggregator_provider.dart';
import '../widgets/inspection_form/sections/basic_info_section.dart';
import '../widgets/inspection_form/sections/general_checklist_section.dart';
import '../widgets/inspection_form/sections/water_supplies_section.dart';
import '../widgets/inspection_form/sections/control_valves_section.dart';
import '../widgets/inspection_form/sections/fire_dept_connections_section.dart';
import '../widgets/inspection_form/sections/fire_pump_general_section.dart';
import '../widgets/inspection_form/sections/diesel_fire_pump_section.dart';
import '../widgets/inspection_form/sections/electric_fire_pump_section.dart';
import '../widgets/inspection_form/sections/wet_systems_section.dart';
import '../widgets/inspection_form/sections/dry_systems_section.dart';
import '../widgets/inspection_form/sections/preaction_deluge_section.dart';
import '../widgets/inspection_form/sections/main_drain_test_section.dart';
import '../widgets/inspection_form/sections/alarms_section.dart';
import '../widgets/inspection_form/sections/sprinklers_piping_section.dart';
import '../widgets/inspection_form/sections/device_tests_section.dart';
import '../widgets/inspection_form/sections/notes_section.dart';

class InspectionFormPage extends ConsumerStatefulWidget {
  const InspectionFormPage({super.key});

  @override
  ConsumerState<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends ConsumerState<InspectionFormPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(systemConfigProvider);
    final activeSections = config.getActiveSections();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection Form - Page ${_currentPage + 1}/$_totalPages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () => _saveDraft(context),
            tooltip: 'Save Draft',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          
          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage1(activeSections),
                _buildPage2(activeSections),
                _buildPage3(activeSections),
                _buildPage4(activeSections),
                _buildPage5(activeSections),
              ],
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                if (_currentPage > 0)
                  ElevatedButton.icon(
                    onPressed: _previousPage,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                
                // Page Indicator
                Text(
                  'Page ${_currentPage + 1} of $_totalPages',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                
                // Next/Submit Button
                if (_currentPage < _totalPages - 1)
                  ElevatedButton.icon(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: () => _submitInspection(context),
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1(Set<String> activeSections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildClickableSectionCard(
            'Basic Information',
            Icons.info,
            () => _navigateToSection(context, 'Basic Information', const BasicInfoSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '1. General',
            Icons.checklist,
            () => _navigateToSection(context, '1. General', const GeneralChecklistSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '2. Water Supplies',
            Icons.water_drop,
            () => _navigateToSection(context, '2. Water Supplies', const WaterSuppliesSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '3. Control Valves',
            Icons.settings,
            () => _navigateToSection(context, '3. Control Valves', const ControlValvesSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '4. Fire Dept. Connections',
            Icons.fire_truck,
            () => _navigateToSection(context, '4. Fire Dept. Connections', const FireDeptConnectionsSection()),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2(Set<String> activeSections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (activeSections.contains('fire_pump_general'))
            _buildClickableSectionCard(
              '5. Fire Pump General',
              Icons.water_damage,
              () => _navigateToSection(context, '5. Fire Pump General', const FirePumpGeneralSection()),
            )
          else
            _buildDisabledSection('5. Fire Pump General'),
          const SizedBox(height: 16),
          if (activeSections.contains('diesel_fire_pump'))
            _buildClickableSectionCard(
              '6. Diesel Fire Pump',
              Icons.local_gas_station,
              () => _navigateToSection(context, '6. Diesel Fire Pump', const DieselFirePumpSection()),
            )
          else
            _buildDisabledSection('6. Diesel Fire Pump'),
          const SizedBox(height: 16),
          if (activeSections.contains('electric_fire_pump'))
            _buildClickableSectionCard(
              '7. Electric Fire Pump',
              Icons.electric_bolt,
              () => _navigateToSection(context, '7. Electric Fire Pump', const ElectricFirePumpSection()),
            )
          else
            _buildDisabledSection('7. Electric Fire Pump'),
          const SizedBox(height: 16),
          if (activeSections.contains('wet_systems'))
            _buildClickableSectionCard(
              '8. Wet Systems',
              Icons.opacity,
              () => _navigateToSection(context, '8. Wet Systems', const WetSystemsSection()),
            )
          else
            _buildDisabledSection('8. Wet Systems'),
          const SizedBox(height: 16),
          if (activeSections.contains('dry_systems'))
            _buildClickableSectionCard(
              '9. Dry Systems',
              Icons.air,
              () => _navigateToSection(context, '9. Dry Systems', const DrySystemsSection()),
            )
          else
            _buildDisabledSection('9. Dry Systems'),
        ],
      ),
    );
  }

  Widget _buildPage3(Set<String> activeSections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (activeSections.contains('preaction_deluge'))
            _buildClickableSectionCard(
              '10. Pre-Action/Deluge',
              Icons.water,
              () => _navigateToSection(context, '10. Pre-Action/Deluge', const PreActionDelugeSection()),
            )
          else
            _buildDisabledSection('10. Pre-Action/Deluge'),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '11. Alarms',
            Icons.alarm,
            () => _navigateToSection(context, '11. Alarms', const AlarmsSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '12. Sprinklers/Piping',
            Icons.plumbing,
            () => _navigateToSection(context, '12. Sprinklers/Piping', const SprinklersPipingSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '13. Main Drain Test',
            Icons.science,
            () => _navigateToSection(context, '13. Main Drain Test', const MainDrainTestSection()),
          ),
        ],
      ),
    );
  }

  Widget _buildPage4(Set<String> activeSections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildClickableSectionCard(
            '14. Device Tests',
            Icons.devices,
            () => _navigateToSection(context, '14. Device Tests', const DeviceTestsSection()),
          ),
          const SizedBox(height: 16),
          _buildClickableSectionCard(
            '15-18. Notes & Explanations',
            Icons.note,
            () => _navigateToSection(context, '15-18. Notes & Explanations', const NotesSection()),
          ),
        ],
      ),
    );
  }

  Widget _buildPage5(Set<String> activeSections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 48, color: Colors.green[700]),
                  const SizedBox(height: 12),
                  Text(
                    'Review and Submit',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.green[900],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please review all sections before submitting the inspection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPlaceholder(String title, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Section content will be implemented here...',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledSection(String title) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.block, color: Colors.grey[400]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Not applicable (auto-filled with N/A)',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableSectionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSection(BuildContext context, String title, Widget sectionWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title saved')),
                  );
                },
                tooltip: 'Save & Close',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: sectionWidget,
          ),
        ),
      ),
    );
  }

  Future<void> _saveDraft(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final aggregator = ref.read(inspectionFormAggregatorProvider);
      final success = await aggregator.saveDraft();

      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft saved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save draft'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving draft: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _submitInspection(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Inspection'),
        content: const Text(
          'Are you sure you want to submit this inspection? '
          'It will be saved locally and synced to the server when online.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!context.mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final aggregator = ref.read(inspectionFormAggregatorProvider);
      final success = await aggregator.submitInspection(
        isOnlineCheck: () async {
          // Simple connectivity check - can be enhanced
          return true;
        },
      );

      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inspection submitted successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to home - use popUntil to ensure we go to home page
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit inspection'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting inspection: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
