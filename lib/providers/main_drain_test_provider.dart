// lib/providers/main_drain_test_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/main_drain_test_state.dart';

class MainDrainTestNotifier extends StateNotifier<MainDrainTestState> {
  MainDrainTestNotifier() : super(MainDrainTestState.initial());

  void updateSystem(int index, DrainTestSystem system) {
    state = state.updateSystem(index, system);
  }

  void updateSystemField(
    int index, {
    String? name,
    String? drainSize,
    String? staticPSI,
    String? residualPSI,
  }) {
    if (index >= 0 && index < state.systems.length) {
      final currentSystem = state.systems[index];
      final updatedSystem = currentSystem.copyWith(
        name: name,
        drainSize: drainSize,
        staticPSI: staticPSI,
        residualPSI: residualPSI,
      );
      state = state.updateSystem(index, updatedSystem);
    }
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void setTestConducted(bool conducted) {
    state = state.copyWith(wasTestConducted: conducted);
  }

  void reset() {
    state = MainDrainTestState.initial();
  }
}

final mainDrainTestProvider =
    StateNotifierProvider<MainDrainTestNotifier, MainDrainTestState>((ref) {
  return MainDrainTestNotifier();
});
