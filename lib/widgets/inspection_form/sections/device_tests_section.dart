// lib/widgets/inspection_form/sections/device_tests_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/device_tests_provider.dart';
import '../shared/section_card.dart';

class DeviceTestsSection extends ConsumerWidget {
  const DeviceTestsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deviceTestsProvider);
    final notifier = ref.read(deviceTestsProvider.notifier);

    return SectionCard(
      title: '14. Device Tests',
      icon: Icons.devices,
      children: [
        const Text(
          'Record test results for each device:',
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 8),
        if (state.devices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No devices added yet. Click "Add Device" to begin.',
                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          ...state.devices.asMap().entries.map((entry) {
            final index = entry.key;
            final device = entry.value;
            
            return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: device.name,
                          decoration: const InputDecoration(
                            labelText: 'Device Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) => notifier.updateDeviceField(
                            index,
                            name: value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: device.address,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) => notifier.updateDeviceField(
                            index,
                            address: value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: device.descriptionLocation,
                          decoration: const InputDecoration(
                            labelText: 'Description/Location',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) => notifier.updateDeviceField(
                            index,
                            descriptionLocation: value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: device.operated,
                          decoration: const InputDecoration(
                            labelText: 'Operated',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (value) => notifier.updateDeviceField(
                            index,
                            operated: value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: device.delaySec,
                          decoration: const InputDecoration(
                            labelText: 'Delay (sec)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => notifier.updateDeviceField(
                            index,
                            delaySec: value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => notifier.removeDevice(index),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Remove'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => notifier.addDevice(),
          icon: const Icon(Icons.add),
          label: const Text('Add Device'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
