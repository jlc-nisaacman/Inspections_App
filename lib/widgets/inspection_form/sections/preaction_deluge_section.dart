// lib/widgets/inspection_form/sections/preaction_deluge_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class PreActionDelugeSection extends ConsumerWidget {
  const PreActionDelugeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '10. Pre-Action/Deluge',
      icon: Icons.water,
      children: [
        YesNoNaRadio(
          question: 'Are valves in service?',
          questionKey: 'are_valves_in_service',
          provider: preActionDelugeProvider,
        ),
        YesNoNaRadio(
          question: 'Were valves tripped?',
          questionKey: 'were_valves_tripped',
          provider: preActionDelugeProvider,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Pneumatic Actuator Trip Pressure',
            border: OutlineInputBorder(),
            isDense: true,
            suffixText: 'PSI',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        YesNoNaRadio(
          question: 'Was priming line left on?',
          questionKey: 'was_priming_line_left_on',
          provider: preActionDelugeProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Compressor:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
