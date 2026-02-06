// lib/widgets/inspection_form/sections/dry_systems_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class DrySystemsSection extends ConsumerWidget {
  const DrySystemsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '9. Dry Systems',
      icon: Icons.air,
      children: [
        YesNoNaRadio(
          question: 'Is dry valve in service?',
          questionKey: 'is_dry_valve_in_service',
          provider: drySystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Is dry valve chamber not leaking?',
          questionKey: 'is_dry_valve_chamber_not_leaking',
          provider: drySystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Are quick opening valves open?',
          questionKey: 'are_quick_opening_valves_open',
          provider: drySystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Is list of low point drains available?',
          questionKey: 'is_list_of_low_point_drains',
          provider: drySystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Have low points been drained?',
          questionKey: 'have_low_points_been_drained',
          provider: drySystemsProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Compressor:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        YesNoNaRadio(
          question: 'Is oil level full in compressor?',
          questionKey: 'is_oil_level_full_compressor',
          provider: drySystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Does compressor return pressure in 30 min?',
          questionKey: 'does_compressor_return_pressure_30min',
          provider: drySystemsProvider,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Compressor Start Pressure',
                  border: OutlineInputBorder(),
                  isDense: true,
                  suffixText: 'PSI',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Compressor Stop Pressure',
                  border: OutlineInputBorder(),
                  isDense: true,
                  suffixText: 'PSI',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Low Air Alarm Operate Pressure',
            border: OutlineInputBorder(),
            isDense: true,
            suffixText: 'PSI',
            helperText: 'Pressure at which low air alarm operated',
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
