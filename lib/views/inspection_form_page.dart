// lib/views/inspection_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_config_provider.dart';

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
            onPressed: () {
              // TODO: Implement draft save
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Draft save coming soon')),
              );
            },
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
                    onPressed: () {
                      // TODO: Implement form submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Form submission coming soon'),
                        ),
                      );
                    },
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
          _buildSectionPlaceholder('Basic Information', Icons.info),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('1. General', Icons.checklist),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('2. Water Supplies', Icons.water_drop),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('3. Control Valves', Icons.settings),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('4. Fire Dept. Connections', Icons.fire_truck),
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
            _buildSectionPlaceholder('5. Fire Pump General', Icons.water_damage)
          else
            _buildDisabledSection('5. Fire Pump General'),
          const SizedBox(height: 16),
          if (activeSections.contains('diesel_fire_pump'))
            _buildSectionPlaceholder('6. Diesel Fire Pump', Icons.local_gas_station)
          else
            _buildDisabledSection('6. Diesel Fire Pump'),
          const SizedBox(height: 16),
          if (activeSections.contains('electric_fire_pump'))
            _buildSectionPlaceholder('7. Electric Fire Pump', Icons.electric_bolt)
          else
            _buildDisabledSection('7. Electric Fire Pump'),
          const SizedBox(height: 16),
          if (activeSections.contains('wet_systems'))
            _buildSectionPlaceholder('8. Wet Systems', Icons.opacity)
          else
            _buildDisabledSection('8. Wet Systems'),
          const SizedBox(height: 16),
          if (activeSections.contains('dry_systems'))
            _buildSectionPlaceholder('9. Dry Systems (Part 1)', Icons.air)
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
          if (activeSections.contains('dry_systems'))
            _buildSectionPlaceholder('9. Dry Systems (Part 2)', Icons.air)
          else
            _buildDisabledSection('9. Dry Systems (continued)'),
          const SizedBox(height: 16),
          if (activeSections.contains('preaction_deluge'))
            _buildSectionPlaceholder('10. Pre-Action/Deluge', Icons.water)
          else
            _buildDisabledSection('10. Pre-Action/Deluge'),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('11. Alarms', Icons.alarm),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('12. Sprinklers/Piping', Icons.plumbing),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('13. Main Drain Test', Icons.science),
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
          _buildSectionPlaceholder('Drain Test Notes', Icons.notes),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('14. Device Tests', Icons.devices),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('15. Adjustments/Corrections', Icons.build),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('16. Explanation of No Answers', Icons.comment),
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
          _buildSectionPlaceholder('17. Explanation (continued)', Icons.comment),
          const SizedBox(height: 16),
          _buildSectionPlaceholder('18. Notes', Icons.note),
          const SizedBox(height: 24),
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
}
