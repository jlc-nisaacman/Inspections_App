// lib/providers/checklist_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/checklist_state.dart';
import 'system_config_provider.dart';

// Base class for checklist notifiers
class ChecklistNotifier extends StateNotifier<ChecklistState> {
  final Ref ref;
  final bool isConditional;
  final String sectionKey;

  ChecklistNotifier(
    this.ref,
    List<String> questionKeys, {
    this.isConditional = false,
    this.sectionKey = '',
  }) : super(ChecklistState.initial(questionKeys)) {
    if (isConditional) {
      _listenToSystemConfig();
    }
  }

  void _listenToSystemConfig() {
    ref.listen(systemConfigProvider, (previous, next) {
      final activeSections = next.getActiveSections();
      if (!activeSections.contains(sectionKey)) {
        state = state.autoFillNA();
      }
    });
  }

  void setAnswer(String key, ChecklistAnswer answer) {
    state = state.setAnswer(key, answer);
  }

  void reset(List<String> questionKeys) {
    state = ChecklistState.initial(questionKeys);
  }
}

// 1. General Checklist Provider
final generalChecklistProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'is_building_occupied',
      'are_all_systems_in_service',
      'are_fp_systems_same',
      'hydraulic_nameplate_secure',
    ],
  );
});

// 2. Water Supplies Provider
final waterSuppliesProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'was_main_drain_test_conducted',
    ],
  );
});

// 3. Control Valves Provider
final controlValvesProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'are_main_control_valves_open',
      'are_other_valves_proper',
      'are_control_valves_sealed',
      'are_control_valves_good_condition',
    ],
  );
});

// 4. Fire Dept Connections Provider
final fireDeptConnectionsProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'are_fd_connections_satisfactory',
      'are_caps_in_place',
      'is_fd_connection_accessible',
      'automatic_drain_valve_in_place',
    ],
  );
});

// 5. Fire Pump General Provider (Conditional)
final firePumpGeneralProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'is_pump_room_heated',
      'is_fire_pump_in_service',
      'was_fire_pump_run',
      'was_pump_started_automatic',
      'were_pump_bearings_lubricated',
      'jockey_pump_start_pressure',
      'jockey_pump_stop_pressure',
      'fire_pump_start_pressure',
      'fire_pump_stop_pressure',
    ],
    isConditional: true,
    sectionKey: 'fire_pump_general',
  );
});

// 6. Diesel Fire Pump Provider (Conditional)
final dieselFirePumpProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'is_fuel_tank_2_3_full',
      'is_engine_oil_correct',
      'is_engine_coolant_correct',
      'is_engine_block_heater_working',
      'is_pump_room_ventilation_proper',
      'was_water_discharge_observed',
      'was_cooling_line_strainer_cleaned',
      'was_pump_run_30_minutes',
      'does_switch_auto_alarm_work',
      'does_pump_running_alarm_work',
      'does_common_alarm_work',
    ],
    isConditional: true,
    sectionKey: 'diesel_fire_pump',
  );
});

// 7. Electric Fire Pump Provider (Conditional)
final electricFirePumpProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'was_casing_relief_valve_proper',
      'was_pump_run_10_minutes',
      'does_loss_of_power_alarm_work',
      'does_electric_pump_running_alarm_work',
      'power_failure_simulated',
      'transfer_to_alternate_power_verified',
      'power_failure_removed',
      'pump_reconnected_after_delay',
    ],
    isConditional: true,
    sectionKey: 'electric_fire_pump',
  );
});

// 8. Wet Systems Provider (Conditional)
final wetSystemsProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'have_antifreeze_systems_tested',
      'freeze_protection_degrees',
      'are_alarm_valves_satisfactory',
      'water_flow_alarm_inspectors_test',
      'water_flow_alarm_bypass_connection',
    ],
    isConditional: true,
    sectionKey: 'wet_systems',
  );
});

// 9. Dry Systems Provider (Conditional)
final drySystemsProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'is_dry_valve_in_service',
      'is_dry_valve_chamber_not_leaking',
      'are_quick_opening_valves_open',
      'is_list_of_low_point_drains',
      'have_low_points_been_drained',
      'is_oil_level_full_compressor',
      'does_compressor_return_pressure_30min',
      'what_pressure_compressor_start',
      'what_pressure_compressor_stop',
      'did_low_air_alarm_operate',
    ],
    isConditional: true,
    sectionKey: 'dry_systems',
  );
});

// 10. Pre-Action/Deluge Provider (Conditional)
final preActionDelugeProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'are_valves_in_service',
      'were_valves_tripped',
      'what_pressure_pneumatic_actuator_trip',
      'was_priming_line_left_on',
      'what_pressure_preaction_compressor_start',
      'what_pressure_preaction_compressor_stop',
      'did_preaction_low_air_alarm_operate',
    ],
    isConditional: true,
    sectionKey: 'preaction_deluge',
  );
});

// 11. Alarms Provider (Always Active)
final alarmsProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'does_water_motor_gong_work',
      'does_electric_bell_work',
      'are_water_flow_alarms_operational',
      'are_tamper_switches_operational',
      'did_alarm_panel_clear',
    ],
  );
});

// 12. Sprinklers/Piping Provider
final sprinklersPipingProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  return ChecklistNotifier(
    ref,
    [
      'are_6_spare_sprinklers_available',
      'is_piping_condition_satisfactory',
      'are_dry_type_heads_less_than_10',
      'dry_type_heads_year',
      'are_quick_response_heads_less_than_20',
      'quick_response_heads_year',
      'are_standard_response_heads_less_than_50',
      'standard_response_heads_year',
      'have_gauges_been_tested_5_years',
      'gauges_year',
    ],
  );
});
