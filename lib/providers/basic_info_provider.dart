// lib/providers/basic_info_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/basic_info_state.dart';

class BasicInfoNotifier extends StateNotifier<BasicInfoState> {
  BasicInfoNotifier() : super(BasicInfoState.initial());

  void updateBillTo(String value) => state = state.copyWith(billTo: value);
  void updateLocation(String value) => state = state.copyWith(location: value);
  void updateBillToLn2(String value) => state = state.copyWith(billToLn2: value);
  void updateLocationLn2(String value) => state = state.copyWith(locationLn2: value);
  void updateAttention(String value) => state = state.copyWith(attention: value);
  void updateBillingStreet(String value) => state = state.copyWith(billingStreet: value);
  void updateBillingStreetLn2(String value) => state = state.copyWith(billingStreetLn2: value);
  void updateLocationStreet(String value) => state = state.copyWith(locationStreet: value);
  void updateLocationStreetLn2(String value) => state = state.copyWith(locationStreetLn2: value);
  void updateBillingCityState(String value) => state = state.copyWith(billingCityState: value);
  void updateBillingCityStateLn2(String value) => state = state.copyWith(billingCityStateLn2: value);
  void updateLocationCity(String value) => state = state.copyWith(locationCity: value);
  void updateLocationState(String value) => state = state.copyWith(locationState: value);
  void updateContact(String value) => state = state.copyWith(contact: value);
  void updateDate(DateTime value) => state = state.copyWith(date: value);
  void updatePhone(String value) => state = state.copyWith(phone: value);
  void updateInspector(String value) => state = state.copyWith(inspector: value);
  void updateEmail(String value) => state = state.copyWith(email: value);
  void updateInspectionFrequency(String value) => state = state.copyWith(inspectionFrequency: value);
  void updateInspectionNumber(String value) => state = state.copyWith(inspectionNumber: value);

  void reset() {
    state = BasicInfoState.initial();
  }
}

final basicInfoProvider =
    StateNotifierProvider<BasicInfoNotifier, BasicInfoState>((ref) {
  return BasicInfoNotifier();
});
