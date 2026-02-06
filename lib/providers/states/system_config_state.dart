// lib/providers/states/system_config_state.dart

enum FirePumpType { none, diesel, electric }

enum SystemType { wet, dry, preActionDeluge }

class SystemConfigState {
  final FirePumpType firePumpType;
  final Set<SystemType> systemTypes;
  final bool isConfigured;

  SystemConfigState({
    required this.firePumpType,
    required this.systemTypes,
    this.isConfigured = false,
  });

  factory SystemConfigState.initial() {
    return SystemConfigState(
      firePumpType: FirePumpType.none,
      systemTypes: {},
      isConfigured: false,
    );
  }

  SystemConfigState copyWith({
    FirePumpType? firePumpType,
    Set<SystemType>? systemTypes,
    bool? isConfigured,
  }) {
    return SystemConfigState(
      firePumpType: firePumpType ?? this.firePumpType,
      systemTypes: systemTypes ?? this.systemTypes,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }

  // Helper methods
  bool get hasFirePump => firePumpType != FirePumpType.none;
  bool get hasDieselPump => firePumpType == FirePumpType.diesel;
  bool get hasElectricPump => firePumpType == FirePumpType.electric;
  bool get hasWetSystem => systemTypes.contains(SystemType.wet);
  bool get hasDrySystem => systemTypes.contains(SystemType.dry);
  bool get hasPreActionDeluge => systemTypes.contains(SystemType.preActionDeluge);

  // Get list of active section names
  Set<String> getActiveSections() {
    final sections = <String>{
      'basic_info',
      'general',
      'water_supplies',
      'control_valves',
      'fire_dept_connections',
      'alarms', // Always active (required by code)
      'sprinklers_piping',
      'main_drain_test',
      'device_tests',
      'notes',
    };

    if (hasFirePump) {
      sections.add('fire_pump_general');
      if (hasDieselPump) sections.add('diesel_fire_pump');
      if (hasElectricPump) sections.add('electric_fire_pump');
    }

    if (hasWetSystem) sections.add('wet_systems');
    if (hasDrySystem) sections.add('dry_systems');
    if (hasPreActionDeluge) sections.add('preaction_deluge');

    return sections;
  }
}
