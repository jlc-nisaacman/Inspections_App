// lib/providers/states/main_drain_test_state.dart

class DrainTestSystem {
  final String name;
  final String drainSize;
  final String staticPSI;
  final String residualPSI;

  DrainTestSystem({
    required this.name,
    required this.drainSize,
    required this.staticPSI,
    required this.residualPSI,
  });

  factory DrainTestSystem.empty() {
    return DrainTestSystem(
      name: '',
      drainSize: '',
      staticPSI: '',
      residualPSI: '',
    );
  }

  DrainTestSystem copyWith({
    String? name,
    String? drainSize,
    String? staticPSI,
    String? residualPSI,
  }) {
    return DrainTestSystem(
      name: name ?? this.name,
      drainSize: drainSize ?? this.drainSize,
      staticPSI: staticPSI ?? this.staticPSI,
      residualPSI: residualPSI ?? this.residualPSI,
    );
  }

  bool get isEmpty {
    return name.trim().isEmpty &&
        drainSize.trim().isEmpty &&
        staticPSI.trim().isEmpty &&
        residualPSI.trim().isEmpty;
  }

  bool get isComplete {
    return name.trim().isNotEmpty &&
        drainSize.trim().isNotEmpty &&
        staticPSI.trim().isNotEmpty &&
        residualPSI.trim().isNotEmpty;
  }
}

class MainDrainTestState {
  final List<DrainTestSystem> systems;
  final String notes;
  final bool wasTestConducted;

  MainDrainTestState({
    required this.systems,
    required this.notes,
    required this.wasTestConducted,
  });

  factory MainDrainTestState.initial() {
    return MainDrainTestState(
      systems: List.generate(6, (_) => DrainTestSystem.empty()),
      notes: '',
      wasTestConducted: true,
    );
  }

  MainDrainTestState copyWith({
    List<DrainTestSystem>? systems,
    String? notes,
    bool? wasTestConducted,
  }) {
    return MainDrainTestState(
      systems: systems ?? this.systems,
      notes: notes ?? this.notes,
      wasTestConducted: wasTestConducted ?? this.wasTestConducted,
    );
  }

  MainDrainTestState updateSystem(int index, DrainTestSystem system) {
    final newSystems = List<DrainTestSystem>.from(systems);
    if (index >= 0 && index < newSystems.length) {
      newSystems[index] = system;
    }
    return copyWith(systems: newSystems);
  }

  bool get isValid {
    if (!wasTestConducted) {
      return notes.trim().isNotEmpty;
    }
    // At least one system should be filled
    return systems.any((system) => !system.isEmpty);
  }

  bool get isComplete {
    return isValid;
  }
}
