// lib/widgets/inspection_form/sections/diesel_fire_pump_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class DieselFirePumpSection extends ConsumerWidget {
  const DieselFirePumpSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '6. Diesel Fire Pump',
      icon: Icons.local_gas_station,
      children: [
        YesNoNaRadio(
          question: 'Is fuel tank 2/3 full?',
          questionKey: 'is_fuel_tank_2_3_full',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Is engine oil at correct level?',
          questionKey: 'is_engine_oil_correct',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Is engine coolant at correct level?',
          questionKey: 'is_engine_coolant_correct',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Is engine block heater working?',
          questionKey: 'is_engine_block_heater_working',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Is pump room ventilation proper?',
          questionKey: 'is_pump_room_ventilation_proper',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Was water discharge observed?',
          questionKey: 'was_water_discharge_observed',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Was cooling line strainer cleaned?',
          questionKey: 'was_cooling_line_strainer_cleaned',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Was pump run for 30 minutes?',
          questionKey: 'was_pump_run_30_minutes',
          provider: dieselFirePumpProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Alarm Tests:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        YesNoNaRadio(
          question: 'Does switch to auto alarm work?',
          questionKey: 'does_switch_auto_alarm_work',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Does pump running alarm work?',
          questionKey: 'does_pump_running_alarm_work',
          provider: dieselFirePumpProvider,
        ),
        YesNoNaRadio(
          question: 'Does common alarm work?',
          questionKey: 'does_common_alarm_work',
          provider: dieselFirePumpProvider,
        ),
      ],
    );
  }
}
