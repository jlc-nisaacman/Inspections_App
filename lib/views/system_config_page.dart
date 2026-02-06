// lib/views/system_config_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_config_provider.dart';
import '../providers/states/system_config_state.dart';
import 'inspection_form_page.dart';

class SystemConfigPage extends ConsumerWidget {
  const SystemConfigPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(systemConfigProvider);
    final notifier = ref.read(systemConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preliminary Questions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Answer these questions to customize the inspection form. Sections that don\'t apply will be automatically filled with N/A.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Fire Pump Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Does this location have a Fire Pump?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<FirePumpType>(
                            title: const Text('No'),
                            value: FirePumpType.none,
                            groupValue: config.firePumpType,
                            onChanged: (value) {
                              if (value != null) {
                                notifier.setFirePumpType(value);
                              }
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<FirePumpType>(
                            title: const Text('Yes'),
                            value: FirePumpType.diesel,
                            groupValue: config.firePumpType,
                            onChanged: (value) {
                              if (value != null) {
                                notifier.setFirePumpType(value);
                              }
                            },
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    
                    // Show pump type selection if fire pump exists
                    if (config.hasFirePump) ...[
                      const Divider(height: 24),
                      Text(
                        'What type of Fire Pump?',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<FirePumpType>(
                              title: const Text('Diesel'),
                              value: FirePumpType.diesel,
                              groupValue: config.firePumpType,
                              onChanged: (value) {
                                if (value != null) {
                                  notifier.setFirePumpType(value);
                                }
                              },
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<FirePumpType>(
                              title: const Text('Electric'),
                              value: FirePumpType.electric,
                              groupValue: config.firePumpType,
                              onChanged: (value) {
                                if (value != null) {
                                  notifier.setFirePumpType(value);
                                }
                              },
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Wet Systems Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Does this location have Wet Systems?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue: config.hasWetSystem,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.wet,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue: config.hasWetSystem,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.wet,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dry Systems Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Does this location have Dry Systems?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue: config.hasDrySystem,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.dry,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue: config.hasDrySystem,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.dry,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pre-Action/Deluge Systems Question
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Does this location have Pre-Action/Deluge Systems?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('No'),
                            value: false,
                            groupValue: config.hasPreActionDeluge,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.preActionDeluge,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Yes'),
                            value: true,
                            groupValue: config.hasPreActionDeluge,
                            onChanged: (value) {
                              notifier.setSystemType(
                                SystemType.preActionDeluge,
                                value ?? false,
                              );
                            },
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Active Sections',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.blue[900],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'The following sections will be included in your inspection:',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    const SizedBox(height: 8),
                    ...config.getActiveSections().map((section) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                size: 16, color: Colors.green[700]),
                            const SizedBox(width: 8),
                            Text(
                              _formatSectionName(section),
                              style: TextStyle(color: Colors.blue[900]),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            ElevatedButton(
              onPressed: () {
                notifier.completeConfiguration();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InspectionFormPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Continue to Inspection Form',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSectionName(String section) {
    return section
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
