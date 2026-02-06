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
    List<String>? valueKeys,
    this.isConditional = false,
    this.sectionKey = '',
  }) : super(ChecklistState.initial(questionKeys, valueKeys: valueKeys)) {
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

  void setValue(String key, String value) {
    state = state.setValue(key, value);
  }

  void reset(List<String> questionKeys, {List<String>? valueKeys}) {
    state = ChecklistState.initial(questionKeys, valueKeys: valueKeys);
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
      'water_flow_alarm_inspectors_test',
      'water_flow_alarm_bypass_connection',
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
    ],
    valueKeys: [
      'jockey_pump_start_pressure_psi',
      'jockey_pump_stop_pressure_psi',
      'fire_pump_start_pressure_psi',
      'fire_pump_stop_pressure_psi',
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
      'are_alarm_valves_satisfactory',
    ],
    valueKeys: [
      'freeze_protection_in_degrees_f',
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
      'has_dry_system_been_fully_tripped_within_last_three_years',
      'are_quick_opening_valves_open',
      'is_list_of_low_point_drains',
      'have_low_points_been_drained',
      'is_oil_level_full_compressor',
      'does_compressor_return_pressure_30min',
    ],
    valueKeys: [
      'what_pressure_compressor_start_psi',
      'what_pressure_compressor_stop_psi',
      'did_low_air_alarm_operate_psi',
      'date_of_last_full_trip_test',
      'date_of_last_internal_inspection',
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
      'was_priming_line_left_on',
    ],
    valueKeys: [
      'what_pressure_pneumatic_actuator_trip_psi',
      'what_pressure_preaction_compressor_start_psi',
      'what_pressure_preaction_compressor_stop_psi',
      'did_preaction_low_air_alarm_operate_psi',
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
    ],
    valueKeys: [
      'dry_type_heads_result',
      'dry_type_heads_year',
      'quick_response_heads_result',
      'quick_response_heads_year',
      'standard_response_heads_result',
      'standard_response_heads_year',
      'gauges_result',
      'gauges_year',
    ],
  );
});
