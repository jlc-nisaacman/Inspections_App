// lib/widgets/inspection_form/sections/main_drain_test_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/main_drain_test_provider.dart';
import '../shared/section_card.dart';

class MainDrainTestSection extends ConsumerWidget {
  const MainDrainTestSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drainTest = ref.watch(mainDrainTestProvider);
    final notifier = ref.read(mainDrainTestProvider.notifier);

    return SectionCard(
      title: '13. Main Drain Test',
      icon: Icons.science,
      children: [
        // System 1
        _buildSystemRow(context, 'System 1', 0, drainTest, notifier),
        const SizedBox(height: 16),
        
        // System 2
        _buildSystemRow(context, 'System 2', 1, drainTest, notifier),
        const SizedBox(height: 16),
        
        // System 3
        _buildSystemRow(context, 'System 3', 2, drainTest, notifier),
        const SizedBox(height: 16),
        
        // Notes
        TextFormField(
          initialValue: drainTest.notes,
          decoration: const InputDecoration(
            labelText: 'Drain Test Notes',
            border: OutlineInputBorder(),
            hintText: 'Enter any notes about the drain test...',
          ),
          maxLines: 3,
          onChanged: notifier.updateNotes,
        ),
      ],
    );
  }

  Widget _buildSystemRow(
    BuildContext context,
    String systemName,
    int index,
    dynamic drainTest,
    dynamic notifier,
  ) {
    final system = drainTest.systems[index];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          systemName,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                initialValue: system.name,
                decoration: const InputDecoration(
                  labelText: 'System Name',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  notifier.updateSystemField(index, name: value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: system.drainSize,
                decoration: const InputDecoration(
                  labelText: 'Drain Size',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) {
                  notifier.updateSystemField(index, drainSize: value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: system.staticPSI,
                decoration: const InputDecoration(
                  labelText: 'Static PSI',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  notifier.updateSystemField(index, staticPSI: value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                initialValue: system.residualPSI,
                decoration: const InputDecoration(
                  labelText: 'Residual PSI',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  notifier.updateSystemField(index, residualPSI: value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
