// lib/providers/states/device_tests_state.dart

class DeviceTest {
  final String name;
  final String address;
  final String descriptionLocation;
  final String operated;
  final String delaySec;

  DeviceTest({
    required this.name,
    required this.address,
    required this.descriptionLocation,
    required this.operated,
    required this.delaySec,
  });

  factory DeviceTest.empty() {
    return DeviceTest(
      name: '',
      address: '',
      descriptionLocation: '',
      operated: '',
      delaySec: '',
    );
  }

  DeviceTest copyWith({
    String? name,
    String? address,
    String? descriptionLocation,
    String? operated,
    String? delaySec,
  }) {
    return DeviceTest(
      name: name ?? this.name,
      address: address ?? this.address,
      descriptionLocation: descriptionLocation ?? this.descriptionLocation,
      operated: operated ?? this.operated,
      delaySec: delaySec ?? this.delaySec,
    );
  }

  bool get isEmpty {
    return name.trim().isEmpty &&
        address.trim().isEmpty &&
        descriptionLocation.trim().isEmpty &&
        operated.trim().isEmpty &&
        delaySec.trim().isEmpty;
  }
}

class DeviceTestsState {
  final List<DeviceTest> devices;

  DeviceTestsState({required this.devices});

  factory DeviceTestsState.initial() {
    return DeviceTestsState(
      devices: [],
    );
  }

  DeviceTestsState copyWith({List<DeviceTest>? devices}) {
    return DeviceTestsState(
      devices: devices ?? this.devices,
    );
  }

  DeviceTestsState updateDevice(int index, DeviceTest device) {
    final newDevices = List<DeviceTest>.from(devices);
    if (index >= 0 && index < newDevices.length) {
      newDevices[index] = device;
    }
    return copyWith(devices: newDevices);
  }

  DeviceTestsState addDevice() {
    final newDevices = List<DeviceTest>.from(devices)..add(DeviceTest.empty());
    return copyWith(devices: newDevices);
  }

  DeviceTestsState removeDevice(int index) {
    if (index >= 0 && index < devices.length) {
      final newDevices = List<DeviceTest>.from(devices)..removeAt(index);
      return copyWith(devices: newDevices);
    }
    return this;
  }

  bool get isComplete {
    // Device tests are optional, so always complete
    return true;
  }
}
