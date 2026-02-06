// lib/widgets/inspection_form/sections/fire_pump_general_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class FirePumpGeneralSection extends ConsumerWidget {
  const FirePumpGeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '5. Fire Pump General',
      icon: Icons.water_damage,
      children: [
        YesNoNaRadio(
          question: 'Is pump room heated?',
          questionKey: 'is_pump_room_heated',
          provider: firePumpGeneralProvider,
        ),
        YesNoNaRadio(
          question: 'Is fire pump in service?',
          questionKey: 'is_fire_pump_in_service',
          provider: firePumpGeneralProvider,
        ),
        YesNoNaRadio(
          question: 'Was fire pump run?',
          questionKey: 'was_fire_pump_run',
          provider: firePumpGeneralProvider,
        ),
        YesNoNaRadio(
          question: 'Was pump started automatically?',
          questionKey: 'was_pump_started_automatic',
          provider: firePumpGeneralProvider,
        ),
        YesNoNaRadio(
          question: 'Were pump bearings lubricated?',
          questionKey: 'were_pump_bearings_lubricated',
          provider: firePumpGeneralProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Pressure Readings (PSI):',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Jockey Pump Start',
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
                  labelText: 'Jockey Pump Stop',
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fire Pump Start',
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
                  labelText: 'Fire Pump Stop',
                  border: OutlineInputBorder(),
                  isDense: true,
                  suffixText: 'PSI',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
