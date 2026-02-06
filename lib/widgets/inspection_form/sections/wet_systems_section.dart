// lib/widgets/inspection_form/sections/wet_systems_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class WetSystemsSection extends ConsumerWidget {
  const WetSystemsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '8. Wet Systems',
      icon: Icons.opacity,
      children: [
        YesNoNaRadio(
          question: 'Have antifreeze systems been tested?',
          questionKey: 'have_antifreeze_systems_tested',
          provider: wetSystemsProvider,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Freeze Protection (degrees)',
            border: OutlineInputBorder(),
            isDense: true,
            suffixText: '°F',
            helperText: 'Enter temperature for freeze protection',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        YesNoNaRadio(
          question: 'Are alarm valves satisfactory?',
          questionKey: 'are_alarm_valves_satisfactory',
          provider: wetSystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Water flow alarm - inspector\'s test?',
          questionKey: 'water_flow_alarm_inspectors_test',
          provider: wetSystemsProvider,
        ),
        YesNoNaRadio(
          question: 'Water flow alarm - bypass connection?',
          questionKey: 'water_flow_alarm_bypass_connection',
          provider: wetSystemsProvider,
        ),
      ],
    );
  }
}
