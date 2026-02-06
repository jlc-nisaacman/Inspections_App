// lib/providers/system_config_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/system_config_state.dart';

class SystemConfigNotifier extends StateNotifier<SystemConfigState> {
  SystemConfigNotifier() : super(SystemConfigState.initial());

  void setFirePumpType(FirePumpType type) {
    state = state.copyWith(firePumpType: type);
  }

  void toggleSystemType(SystemType type) {
    final newTypes = Set<SystemType>.from(state.systemTypes);
    if (newTypes.contains(type)) {
      newTypes.remove(type);
    } else {
      newTypes.add(type);
    }
    state = state.copyWith(systemTypes: newTypes);
  }

  void setSystemType(SystemType type, bool enabled) {
    final newTypes = Set<SystemType>.from(state.systemTypes);
    if (enabled) {
      newTypes.add(type);
    } else {
      newTypes.remove(type);
    }
    state = state.copyWith(systemTypes: newTypes);
  }

  void completeConfiguration() {
    state = state.copyWith(isConfigured: true);
  }

  void reset() {
    state = SystemConfigState.initial();
  }
}

final systemConfigProvider =
    StateNotifierProvider<SystemConfigNotifier, SystemConfigState>((ref) {
  return SystemConfigNotifier();
});

// Provider to get active sections
final activeSectionsProvider = Provider<Set<String>>((ref) {
  final config = ref.watch(systemConfigProvider);
  return config.getActiveSections();
});
