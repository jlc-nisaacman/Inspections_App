// lib/providers/device_tests_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/device_tests_state.dart';

class DeviceTestsNotifier extends StateNotifier<DeviceTestsState> {
  DeviceTestsNotifier() : super(DeviceTestsState.initial());

  void updateDevice(int index, DeviceTest device) {
    state = state.updateDevice(index, device);
  }

  void updateDeviceField(
    int index, {
    String? name,
    String? address,
    String? descriptionLocation,
    String? operated,
    String? delaySec,
  }) {
    if (index >= 0 && index < state.devices.length) {
      final currentDevice = state.devices[index];
      final updatedDevice = currentDevice.copyWith(
        name: name,
        address: address,
        descriptionLocation: descriptionLocation,
        operated: operated,
        delaySec: delaySec,
      );
      state = state.updateDevice(index, updatedDevice);
    }
  }

  void addDevice() {
    state = state.addDevice();
  }

  void removeDevice(int index) {
    state = state.removeDevice(index);
  }

  void reset() {
    state = DeviceTestsState.initial();
  }
}

final deviceTestsProvider =
    StateNotifierProvider<DeviceTestsNotifier, DeviceTestsState>((ref) {
  return DeviceTestsNotifier();
});
