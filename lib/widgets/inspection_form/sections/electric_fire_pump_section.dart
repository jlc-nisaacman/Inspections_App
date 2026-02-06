// lib/widgets/inspection_form/sections/electric_fire_pump_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class ElectricFirePumpSection extends ConsumerWidget {
  const ElectricFirePumpSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '7. Electric Fire Pump',
      icon: Icons.electric_bolt,
      children: [
        YesNoNaRadio(
          question: 'Was casing relief valve operating properly?',
          questionKey: 'was_casing_relief_valve_proper',
          provider: electricFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Was pump run for 10 minutes?',
          questionKey: 'was_pump_run_10_minutes',
          provider: electricFirePumpProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Alarm Tests:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        YesNoNaRadio(
          question: 'Does loss of power alarm work?',
          questionKey: 'does_loss_of_power_alarm_work',
          provider: electricFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Does electric pump running alarm work?',
          questionKey: 'does_electric_pump_running_alarm_work',
          provider: electricFirePumpProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Power Transfer Test:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        YesNoNaRadio(
          question: 'Power failure simulated?',
          questionKey: 'power_failure_simulated',
          provider: electricFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Transfer to alternate power verified?',
          questionKey: 'transfer_to_alternate_power_verified',
          provider: electricFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Power failure removed?',
          questionKey: 'power_failure_removed',
          provider: electricFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Pump reconnected after delay?',
          questionKey: 'pump_reconnected_after_delay',
          provider: electricFirePumpProvider,
        ),
      ],
    );
  }
}
