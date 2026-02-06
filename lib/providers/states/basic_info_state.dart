// lib/providers/states/basic_info_state.dart

class BasicInfoState {
  final String billTo;
  final String location;
  final String billToLn2;
  final String locationLn2;
  final String attention;
  final String billingStreet;
  final String billingStreetLn2;
  final String locationStreet;
  final String locationStreetLn2;
  final String billingCityState;
  final String billingCityStateLn2;
  final String locationCity;
  final String locationState;
  final String contact;
  final DateTime date;
  final String phone;
  final String inspector;
  final String email;
  final String inspectionFrequency;
  final String inspectionNumber;

  BasicInfoState({
    required this.billTo,
    required this.location,
    required this.billToLn2,
    required this.locationLn2,
    required this.attention,
    required this.billingStreet,
    required this.billingStreetLn2,
    required this.locationStreet,
    required this.locationStreetLn2,
    required this.billingCityState,
    required this.billingCityStateLn2,
    required this.locationCity,
    required this.locationState,
    required this.contact,
    required this.date,
    required this.phone,
    required this.inspector,
    required this.email,
    required this.inspectionFrequency,
    required this.inspectionNumber,
  });

  factory BasicInfoState.initial() {
    return BasicInfoState(
      billTo: '',
      location: '',
      billToLn2: '',
      locationLn2: '',
      attention: '',
      billingStreet: '',
      billingStreetLn2: '',
      locationStreet: '',
      locationStreetLn2: '',
      billingCityState: '',
      billingCityStateLn2: '',
      locationCity: '',
      locationState: '',
      contact: '',
      date: DateTime.now(),
      phone: '',
      inspector: '',
      email: '',
      inspectionFrequency: '',
      inspectionNumber: '',
    );
  }

  BasicInfoState copyWith({
    String? billTo,
    String? location,
    String? billToLn2,
    String? locationLn2,
    String? attention,
    String? billingStreet,
    String? billingStreetLn2,
    String? locationStreet,
    String? locationStreetLn2,
    String? billingCityState,
    String? billingCityStateLn2,
    String? locationCity,
    String? locationState,
    String? contact,
    DateTime? date,
    String? phone,
    String? inspector,
    String? email,
    String? inspectionFrequency,
    String? inspectionNumber,
  }) {
    return BasicInfoState(
      billTo: billTo ?? this.billTo,
      location: location ?? this.location,
      billToLn2: billToLn2 ?? this.billToLn2,
      locationLn2: locationLn2 ?? this.locationLn2,
      attention: attention ?? this.attention,
      billingStreet: billingStreet ?? this.billingStreet,
      billingStreetLn2: billingStreetLn2 ?? this.billingStreetLn2,
      locationStreet: locationStreet ?? this.locationStreet,
      locationStreetLn2: locationStreetLn2 ?? this.locationStreetLn2,
      billingCityState: billingCityState ?? this.billingCityState,
      billingCityStateLn2: billingCityStateLn2 ?? this.billingCityStateLn2,
      locationCity: locationCity ?? this.locationCity,
      locationState: locationState ?? this.locationState,
      contact: contact ?? this.contact,
      date: date ?? this.date,
      phone: phone ?? this.phone,
      inspector: inspector ?? this.inspector,
      email: email ?? this.email,
      inspectionFrequency: inspectionFrequency ?? this.inspectionFrequency,
      inspectionNumber: inspectionNumber ?? this.inspectionNumber,
    );
  }

  bool get isValid {
    return billTo.trim().isNotEmpty &&
        location.trim().isNotEmpty &&
        locationCity.trim().isNotEmpty &&
        locationState.trim().isNotEmpty &&
        contact.trim().isNotEmpty &&
        inspector.trim().isNotEmpty;
  }

  bool get isComplete {
    return isValid;
  }
}
