// lib/views/inspection_create_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/inspection_data.dart';
import '../models/inspection_form.dart';
import '../services/data_service.dart';

class InspectionCreatePage extends StatefulWidget {
  const InspectionCreatePage({super.key});

  @override
  InspectionCreatePageState createState() => InspectionCreatePageState();
}

class InspectionCreatePageState extends State<InspectionCreatePage> {
  final DataService _dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  bool _isSaving = false;

  // Form controllers - Basic Info
  final _billToController = TextEditingController();
  final _locationController = TextEditingController();
  final _billToLn2Controller = TextEditingController();
  final _locationLn2Controller = TextEditingController();
  final _attentionController = TextEditingController();
  final _billingStreetController = TextEditingController();
  final _billingStreetLn2Controller = TextEditingController();
  final _locationStreetController = TextEditingController();
  final _locationStreetLn2Controller = TextEditingController();
  final _billingCityStateController = TextEditingController();
  final _billingCityStateLn2Controller = TextEditingController();
  final _locationCityController = TextEditingController();
  final _locationStateController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _inspectionFrequencyController = TextEditingController();
  final _inspectionNumberController = TextEditingController();

  // Form controllers - Main Drain Test
  final _system1NameController = TextEditingController();
  final _system1DrainSizeController = TextEditingController();
  final _system1StaticPSIController = TextEditingController();
  final _system1ResidualPSIController = TextEditingController();
  final _system2NameController = TextEditingController();
  final _system2DrainSizeController = TextEditingController();
  final _system2StaticPSIController = TextEditingController();
  final _system2ResidualPSIController = TextEditingController();
  final _system3NameController = TextEditingController();
  final _system3DrainSizeController = TextEditingController();
  final _system3StaticPSIController = TextEditingController();
  final _system3ResidualPSIController = TextEditingController();
  final _drainTestNotesController = TextEditingController();

  // Form controllers - Device Tests (Optional)
  final List<TextEditingController> _deviceNameControllers = List.generate(
    14,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _deviceAddressControllers = List.generate(
    14,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _deviceLocationControllers = List.generate(
    14,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _deviceOperatedControllers = List.generate(
    14,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _deviceDelayControllers = List.generate(
    14,
    (index) => TextEditingController(),
  );

  // Form controllers - Notes (Optional)
  final _adjustmentsController = TextEditingController();
  final _explanationController = TextEditingController();
  final _explanationContinuedController = TextEditingController();
  final _notesController = TextEditingController();

  // Form values
  DateTime _selectedDate = DateTime.now();
  String? _selectedInspector;
  String? _selectedState;
  final Map<String, String> _stateMapping = {
    'New Hampshire': 'NH',
    'Vermont': 'VT',
    'Maine': 'ME',
  };
  List<Map<String, dynamic>> _municipalities = [];
  List<String> _filteredCities = [];
  String? _selectedCity;
  bool _isCitiesLoading = false;

  // Checklist values - General
  String _isBuildingOccupied = '';
  String _areAllSystemsInService = '';
  String _areFpSystemsSame = '';
  String _hydraulicNameplateSecure = '';

  // Checklist values - Water Supplies
  String _wasMainDrainTestConducted = '';

  // Checklist values - Control Valves
  final String _areMainControlValvesOpen = '';
  final String _areOtherValvesProper = '';
  final ValueNotifier<String> _areControlValvesSealed = ValueNotifier<String>(
    '',
  );
  final ValueNotifier<String> _areControlValvesGoodCondition =
      ValueNotifier<String>('');

  // Checklist values - Fire Department Connections
  final ValueNotifier<String> _areFDConnectionsSatisfactory =
      ValueNotifier<String>('');
  final ValueNotifier<String> _areCapsInPlace = ValueNotifier<String>('');
  final ValueNotifier<String> _isFDConnectionAccessible = ValueNotifier<String>(
    '',
  );
  final ValueNotifier<String> _automaticDrainValveInPlace =
      ValueNotifier<String>('');

  // Checklist values - Fire Pump General
  final ValueNotifier<String> _isPumpRoomHeated = ValueNotifier<String>('');
  final ValueNotifier<String> _isFirePumpInService = ValueNotifier<String>('');
  final ValueNotifier<String> _wasFirePumpRun = ValueNotifier<String>('');

  // Checklist values - Diesel Fire Pump
  final ValueNotifier<String> _dieselPumpValue = ValueNotifier<String>('');

  // Checklist values - Electric Fire Pump
  final ValueNotifier<String> _electricPumpValue = ValueNotifier<String>('');

  // Checklist values - Alarm Device
  final ValueNotifier<String> _areAllTamperSwitchesOperational =
      ValueNotifier<String>('');
  final ValueNotifier<String> _didAlarmPanelClear = ValueNotifier<String>('');

  // Checklist values - Sprinklers Piping
  final ValueNotifier<String> _areMinimumSpareSprinklers =
      ValueNotifier<String>('');
  final ValueNotifier<String> _isPipingConditionSatisfactory =
      ValueNotifier<String>('');
  final ValueNotifier<String> _areDryTypeHeadsLessThan10 =
      ValueNotifier<String>('');
  final ValueNotifier<String> _dryTypeHeadsYear = ValueNotifier<String>('');
  final ValueNotifier<String> _areQuickResponseHeadsLessThan20 =
      ValueNotifier<String>('');
  final ValueNotifier<String> _quickResponseHeadsYear = ValueNotifier<String>(
    '',
  );
  final ValueNotifier<String> _areStandardResponseHeadsLessThan50 =
      ValueNotifier<String>('');
  final ValueNotifier<String> _standardResponseHeadsYear =
      ValueNotifier<String>('');
  final ValueNotifier<String> _haveGaugesBeenTested = ValueNotifier<String>('');
  final ValueNotifier<String> _gaugesYear = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadMunicipalities();
  }

  // Load the municipalities JSON data
  Future<void> _loadMunicipalities() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/municipalities_dropdown.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      setState(() {
        _municipalities = jsonData.cast<Map<String, dynamic>>();
      });

      print('Loaded ${_municipalities.length} municipalities');
    } catch (e) {
      print('Error loading municipalities: $e');
      // Handle error appropriately
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load city data: $e')));
      }
    }
  }

  // Filter cities based on selected state
  void _filterCitiesByState(String? selectedState) {
    if (selectedState == null || _municipalities.isEmpty) {
      setState(() {
        _filteredCities = [];
        _selectedCity = null;
      });
      return;
    }

    setState(() {
      _isCitiesLoading = true;
    });

    // Get state abbreviation
    final stateAbbr = _stateMapping[selectedState];
    if (stateAbbr == null) {
      setState(() {
        _filteredCities = [];
        _selectedCity = null;
        _isCitiesLoading = false;
      });
      return;
    }

    // Filter municipalities by state
    final citiesForState =
        _municipalities
            .where((municipality) => municipality['state'] == stateAbbr)
            .map<String>((municipality) => municipality['name'] as String)
            .toList();

    // Sort alphabetically
    citiesForState.sort();

    setState(() {
      _filteredCities = citiesForState;
      _selectedCity = null; // Reset selected city when state changes
      _locationCityController
          .clear(); // Clear the text controller if you're keeping it
      _isCitiesLoading = false;
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _billToController.dispose();
    _locationController.dispose();
    _billToLn2Controller.dispose();
    _locationLn2Controller.dispose();
    _attentionController.dispose();
    _billingStreetController.dispose();
    _billingStreetLn2Controller.dispose();
    _locationStreetController.dispose();
    _locationStreetLn2Controller.dispose();
    _billingCityStateController.dispose();
    _billingCityStateLn2Controller.dispose();
    _locationCityController.dispose();
    _locationStateController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _inspectionFrequencyController.dispose();
    _inspectionNumberController.dispose();
    _system1NameController.dispose();
    _system1DrainSizeController.dispose();
    _system1StaticPSIController.dispose();
    _system1ResidualPSIController.dispose();
    _system2NameController.dispose();
    _system2DrainSizeController.dispose();
    _system2StaticPSIController.dispose();
    _system2ResidualPSIController.dispose();
    _system3NameController.dispose();
    _system3DrainSizeController.dispose();
    _system3StaticPSIController.dispose();
    _system3ResidualPSIController.dispose();
    _drainTestNotesController.dispose();

    for (int i = 0; i < 14; i++) {
      _deviceNameControllers[i].dispose();
      _deviceAddressControllers[i].dispose();
      _deviceLocationControllers[i].dispose();
      _deviceOperatedControllers[i].dispose();
      _deviceDelayControllers[i].dispose();
    }

    _adjustmentsController.dispose();
    _explanationController.dispose();
    _explanationContinuedController.dispose();
    _notesController.dispose();

    // Dispose ValueNotifiers
    _areControlValvesSealed.dispose();
    _areControlValvesGoodCondition.dispose();
    _areFDConnectionsSatisfactory.dispose();
    _areCapsInPlace.dispose();
    _isFDConnectionAccessible.dispose();
    _automaticDrainValveInPlace.dispose();
    _isPumpRoomHeated.dispose();
    _isFirePumpInService.dispose();
    _wasFirePumpRun.dispose();
    _dieselPumpValue.dispose();
    _electricPumpValue.dispose();
    _areAllTamperSwitchesOperational.dispose();
    _didAlarmPanelClear.dispose();
    _areMinimumSpareSprinklers.dispose();
    _isPipingConditionSatisfactory.dispose();
    _areDryTypeHeadsLessThan10.dispose();
    _dryTypeHeadsYear.dispose();
    _areQuickResponseHeadsLessThan20.dispose();
    _quickResponseHeadsYear.dispose();
    _areStandardResponseHeadsLessThan50.dispose();
    _standardResponseHeadsYear.dispose();
    _haveGaugesBeenTested.dispose();
    _gaugesYear.dispose();

    super.dispose();
  }

  // Save inspection data
  Future<void> _saveInspection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_validateChecklist()) {
      return;
    }

    if (!_validateMainDrainTest()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Generate PDF path
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final locationForPath = _locationController.text
          .trim()
          .replaceAll(RegExp(r'[^\w\s-]'), '')
          .replaceAll(' ', '_');
      final pdfPath =
          'inspections/${dateStr}_${locationForPath}_inspection.pdf';

      // Validate required fields
      if (_billToController.text.trim().isEmpty ||
          _locationController.text.trim().isEmpty ||
          _selectedCity!.trim().isEmpty ||
          _selectedState!.trim().isEmpty) {
        throw Exception(
          'Please ensure Bill To, Location, City, and State are provided.',
        );
      }

      // Create InspectionForm with ALL required parameters
      final form = InspectionForm(
        // Basic Info
        pdfPath: pdfPath,
        billTo: _billToController.text.trim(),
        location: _locationController.text.trim(),
        billToLn2: _billToLn2Controller.text.trim(),
        locationLn2: _locationLn2Controller.text.trim(),
        attention: _attentionController.text.trim(),
        billingStreet: _billingStreetController.text.trim(),
        billingStreetLn2: _billingStreetLn2Controller.text.trim(),
        locationStreet: _locationStreetController.text.trim(),
        locationStreetLn2: _locationStreetLn2Controller.text.trim(),
        billingCityState: _billingCityStateController.text.trim(),
        billingCityStateLn2: _billingCityStateLn2Controller.text.trim(),
        locationCityState: _selectedCity?.trim() ?? '',
        locationCityStateLn2: _selectedState?.trim() ?? '',
        contact: _contactController.text.trim(),
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        phone: _phoneController.text.trim(),
        inspector: _selectedInspector ?? '',
        email: _emailController.text.trim(),
        inspectionFrequency: _inspectionFrequencyController.text.trim(),
        inspectionNumber: _inspectionNumberController.text.trim(),

        // Checklist - General
        isTheBuildingOccupied: _isBuildingOccupied,
        areAllSystemsInService: _areAllSystemsInService,
        areFpSystemsSameAsLastInspection: _areFpSystemsSame,
        hydraulicNameplateSecurelyAttachedAndLegible: _hydraulicNameplateSecure,

        // Checklist - Water Supplies
        wasAMainDrainWaterFlowTestConducted: _wasMainDrainTestConducted,

        // Checklist - Control Valves
        areAllSprinklerSystemMainControlValvesOpen: _areMainControlValvesOpen,
        areAllOtherValvesInProperPosition: _areOtherValvesProper,
        areAllControlValvesSealedOrSupervised: _areControlValvesSealed.value,
        areAllControlValvesInGoodConditionAndFreeOfLeaks:
            _areControlValvesGoodCondition.value,

        // Checklist - Fire Department Connections
        areFireDepartmentConnectionsInSatisfactoryCondition:
            _areFDConnectionsSatisfactory.value,
        areCapsInPlace: _areCapsInPlace.value,
        isFireDepartmentConnectionEasilyAccessible:
            _isFDConnectionAccessible.value,
        automaticDrainValeInPlace: _automaticDrainValveInPlace.value,

        // Checklist - Fire Pump General
        isThePumpRoomHeated: _isPumpRoomHeated.value,
        isTheFirePumpInService: _isFirePumpInService.value,
        wasFirePumpRunDuringThisInspection: _wasFirePumpRun.value,

        // Checklist - Alarm Device (ADD THESE MISSING ONES)
        areAllTamperSwitchesOperational: _areAllTamperSwitchesOperational.value,
        didAlarmPanelClearAfterTest: _didAlarmPanelClear.value,

        // Checklist - Sprinklers Piping (ADD THESE MISSING ONES)
        areAMinimumOf6SpareSprinklersReadilyAvaiable:
            _areMinimumSpareSprinklers.value,
        isConditionOfPipingAndOtherSystemComponentsSatisfactory:
            _isPipingConditionSatisfactory.value,
        areKnownDryTypeHeadsLessThan10YearsOld:
            _areDryTypeHeadsLessThan10.value,
        areKnownDryTypeHeadsLessThan10YearsOldYear: _dryTypeHeadsYear.value,
        areKnownQuickResponseHeadsLessThan20YearsOld:
            _areQuickResponseHeadsLessThan20.value,
        areKnownQuickResponseHeadsLessThan20YearsOldYear:
            _quickResponseHeadsYear.value,
        areKnownStandardResponseHeadsLessThan50YearsOld:
            _areStandardResponseHeadsLessThan50.value,
        areKnownStandardResponseHeadsLessThan50YearsOldYear:
            _standardResponseHeadsYear.value,
        haveAllGaugesBeenTestedOrReplacedInTheLast5Years:
            _haveGaugesBeenTested.value,
        haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: _gaugesYear.value,

        // Main Drain Test Systems (FIX THE SYSTEM MAPPING)
        system1Name: _system1NameController.text.trim(),
        system1DrainSize: _system1DrainSizeController.text.trim(),
        system1StaticPSI: _system1StaticPSIController.text.trim(),
        system1ResidualPSI: _system1ResidualPSIController.text.trim(),
        system2Name: _system2NameController.text.trim(),
        system2DrainSize: _system2DrainSizeController.text.trim(),
        system2StaticPSI: _system2StaticPSIController.text.trim(),
        system2ResidualPSI: _system2ResidualPSIController.text.trim(),
        system3Name: _system3NameController.text.trim(),
        system3DrainSize: _system3DrainSizeController.text.trim(),
        system3StaticPSI: _system3StaticPSIController.text.trim(),
        system3ResidualPSI: _system3ResidualPSIController.text.trim(),
        drainTestNotes: _drainTestNotesController.text.trim(),

        // All remaining required fields with empty defaults
        wasThePumpStartedInTheAutomaticModeByAPressureDrop: '',
        wereThePumpBearingsLubricated: '',
        jockeyPumpStartPressurePSI: '',
        jockeyPumpStartPressure: '',
        jockeyPumpStopPressurePSI: '',
        jockeyPumpStopPressure: '',
        firePumpStartPressurePSI: '',
        firePumpStartPressure: '',
        firePumpStopPressurePSI: '',
        firePumpStopPressure: '',
        isTheFuelTankAtLeast2_3Full: '',
        isEngineOilAtCorrectLevel: '',
        isEngineCoolantAtCorrectLevel: '',
        isTheEngineBlockHeaterWorking: '',
        isPumpRoomVentilationOperatingProperly: '',
        wasWaterDischargeObservedFromHeatExchangerReturnLine: '',
        wasCoolingLineStrainerCleanedAfterTest: '',
        wasPumpRunForAtLeast30Minutes: '',
        doesTheSwitchInAutoAlarmWork: '',
        doesThePumpRunningAlarmWork: '',
        doesTheCommonAlarmWork: '',
        wasCasingReliefValveOperatingProperly: '',
        wasPumpRunForAtLeast10Minutes: '',
        doesTheLossOfPowerAlarmWork: '',
        doesTheElectricPumpRunningAlarmWork: '',
        powerFailureConditionSimulatedWhilePumpOperatingAtPeakLoad: '',
        trasferOfPowerToAlternativePowerSourceVerified: '',
        powerFaulureConditionRemoved: '',
        pumpReconnectedToNormalPowerSourceAfterATimeDelay: '',
        haveAntiFreezeSystemsBeenTested: '',
        freezeProtectionInDegreesF: '',
        areAlarmValvesWaterFlowDevicesAndRetardsInSatisfactoryCondition: '',
        waterFlowAlarmTestConductedWithInspectorsTest: '',
        waterFlowAlarmTestConductedWithBypassConnection: '',
        isDryValveInServiceAndInGoodCondition: '',
        isDryValveItermediateChamberNotLeaking: '',
        hasTheDrySystemBeenFullyTrippedWithinTheLastThreeYears: '',
        areQuickOpeningDeviceControlValvesOpen: '',
        isThereAListOfKnownLowPointDrainsAtTheRiser: '',
        haveKnownLowPointsBeenDrained: '',
        isOilLevelFullOnAirCompressor: '',
        doesTheAirCompressorReturnSystemPressureIn30MinutesOrUnder: '',
        whatPressureDoesAirCompressorStartPSI: '',
        whatPressureDoesAirCompressorStart: '',
        whatPressureDoesAirCompressorStopPSI: '',
        whatPressureDoesAirCompressorStop: '',
        didLowAirAlarmOperatePSI: '',
        didLowAirAlarmOperate: '',
        dateOfLastFullTripTest: '',
        dateOfLastInternalInspection: '',
        areValvesInServiceAndInGoodCondition: '',
        wereValvesTripped: '',
        whatPressureDidPneumaticActuatorTripPSI: '',
        whatPressureDidPneumaticActuatorTrip: '',
        wasPrimingLineLeftOnAfterTest: '',
        whatPressureDoesPreactionAirCompressorStartPSI: '',
        whatPressureDoesPreactionAirCompressorStart: '',
        whatPressureDoesPreactionAirCompressorStopPSI: '',
        whatPressureDoesPreactionAirCompressorStop: '',
        didPreactionLowAirAlarmOperatePSI: '',
        didPreactionLowAirAlarmOperate: '',
        doesWaterMotorGongWork: '',
        doesElectricBellWork: '',
        areWaterFlowAlarmsOperational: '',
        system4Name: '', // Keep these empty since they're extras
        system4DrainSize: '',
        system4StaticPSI: '',
        system4ResidualPSI: '',
        system5Name: '',
        system5DrainSize: '',
        system5StaticPSI: '',
        system5ResidualPSI: '',
        system6Name: '',
        system6DrainSize: '',
        system6StaticPSI: '',
        system6ResidualPSI: '',
        device1Name: _deviceNameControllers[0].text.trim(),
        device1Address: _deviceAddressControllers[0].text.trim(),
        device1DescriptionLocation: _deviceLocationControllers[0].text.trim(),
        device1Operated: _deviceOperatedControllers[0].text.trim(),
        device1DelaySec: _deviceDelayControllers[0].text.trim(),
        device2Name: _deviceNameControllers[1].text.trim(),
        device2Address: _deviceAddressControllers[1].text.trim(),
        device2DescriptionLocation: _deviceLocationControllers[1].text.trim(),
        device2Operated: _deviceOperatedControllers[1].text.trim(),
        device2DelaySec: _deviceDelayControllers[1].text.trim(),
        device3Name: _deviceNameControllers[2].text.trim(),
        device3Address: _deviceAddressControllers[2].text.trim(),
        device3DescriptionLocation: _deviceLocationControllers[2].text.trim(),
        device3Operated: _deviceOperatedControllers[2].text.trim(),
        device3DelaySec: _deviceDelayControllers[2].text.trim(),
        device4Name: _deviceNameControllers[3].text.trim(),
        device4Address: _deviceAddressControllers[3].text.trim(),
        device4DescriptionLocation: _deviceLocationControllers[3].text.trim(),
        device4Operated: _deviceOperatedControllers[3].text.trim(),
        device4DelaySec: _deviceDelayControllers[3].text.trim(),
        device5Name: _deviceNameControllers[4].text.trim(),
        device5Address: _deviceAddressControllers[4].text.trim(),
        device5DescriptionLocation: _deviceLocationControllers[4].text.trim(),
        device5Operated: _deviceOperatedControllers[4].text.trim(),
        device5DelaySec: _deviceDelayControllers[4].text.trim(),
        device6Name: _deviceNameControllers[5].text.trim(),
        device6Address: _deviceAddressControllers[5].text.trim(),
        device6DescriptionLocation: _deviceLocationControllers[5].text.trim(),
        device6Operated: _deviceOperatedControllers[5].text.trim(),
        device6DelaySec: _deviceDelayControllers[5].text.trim(),
        device7Name: _deviceNameControllers[6].text.trim(),
        device7Address: _deviceAddressControllers[6].text.trim(),
        device7DescriptionLocation: _deviceLocationControllers[6].text.trim(),
        device7Operated: _deviceOperatedControllers[6].text.trim(),
        device7DelaySec: _deviceDelayControllers[6].text.trim(),
        device8Name: _deviceNameControllers[7].text.trim(),
        device8Address: _deviceAddressControllers[7].text.trim(),
        device8DescriptionLocation: _deviceLocationControllers[7].text.trim(),
        device8Operated: _deviceOperatedControllers[7].text.trim(),
        device8DelaySec: _deviceDelayControllers[7].text.trim(),
        device9Name: _deviceNameControllers[8].text.trim(),
        device9Address: _deviceAddressControllers[8].text.trim(),
        device9DescriptionLocation: _deviceLocationControllers[8].text.trim(),
        device9Operated: _deviceOperatedControllers[8].text.trim(),
        device9DelaySec: _deviceDelayControllers[8].text.trim(),
        device10Name: _deviceNameControllers[9].text.trim(),
        device10Address: _deviceAddressControllers[9].text.trim(),
        device10DescriptionLocation: _deviceLocationControllers[9].text.trim(),
        device10Operated: _deviceOperatedControllers[9].text.trim(),
        device10DelaySec: _deviceDelayControllers[9].text.trim(),
        device11Name: _deviceNameControllers[10].text.trim(),
        device11Address: _deviceAddressControllers[10].text.trim(),
        device11DescriptionLocation: _deviceLocationControllers[10].text.trim(),
        device11Operated: _deviceOperatedControllers[10].text.trim(),
        device11DelaySec: _deviceDelayControllers[10].text.trim(),
        device12Name: _deviceNameControllers[11].text.trim(),
        device12Address: _deviceAddressControllers[11].text.trim(),
        device12DescriptionLocation: _deviceLocationControllers[11].text.trim(),
        device12Operated: _deviceOperatedControllers[11].text.trim(),
        device12DelaySec: _deviceDelayControllers[11].text.trim(),
        device13Name: _deviceNameControllers[12].text.trim(),
        device13Address: _deviceAddressControllers[12].text.trim(),
        device13DescriptionLocation: _deviceLocationControllers[12].text.trim(),
        device13Operated: _deviceOperatedControllers[12].text.trim(),
        device13DelaySec: _deviceDelayControllers[12].text.trim(),
        device14Name: _deviceNameControllers[13].text.trim(),
        device14Address: _deviceAddressControllers[13].text.trim(),
        device14DescriptionLocation: _deviceLocationControllers[13].text.trim(),
        device14Operated: _deviceOperatedControllers[13].text.trim(),
        device14DelaySec: _deviceDelayControllers[13].text.trim(),
        adjustmentsOrCorrectionsMake: _adjustmentsController.text.trim(),
        explanationOfAnyNoAnswers: _explanationController.text.trim(),
        explanationOfAnyNoAnswersContinued:
            _explanationContinuedController.text.trim(),
        notes: _notesController.text.trim(),
      );

      // Create InspectionData with just the form
      final inspectionData = InspectionData(form);

      // Save the inspection
      final success = await _dataService.createInspection(inspectionData);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inspection saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Failed to save inspection to database');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving inspection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _validateChecklist() {
    final errors = <String>[];

    // Validate required checklist fields
    if (_isBuildingOccupied.isEmpty) errors.add('Building occupied status');
    if (_areAllSystemsInService.isEmpty) {
      errors.add('Systems in service status');
    }
    if (_areFpSystemsSame.isEmpty) {
      errors.add('Fire protection systems same as last inspection');
    }
    if (_hydraulicNameplateSecure.isEmpty) {
      errors.add('Hydraulic nameplate status');
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete required checklist items: ${errors.join(', ')}',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    return true;
  }

  bool _validateMainDrainTest() {
    if (_wasMainDrainTestConducted.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please indicate if main drain test was conducted'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    // If main drain test not conducted, notes are required
    if (_wasMainDrainTestConducted == 'No' &&
        _drainTestNotesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notes are required when main drain test is not conducted (weather conditions, etc.)',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Blank Inspection'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(onPressed: _saveInspection, child: const Text('Save')),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Basic Information Section
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),

                      // Checklist Section
                      _buildChecklistSection(),
                      const SizedBox(height: 24),

                      // Main Drain Test Section
                      _buildMainDrainTestSection(),
                      const SizedBox(height: 24),

                      // Device Tests Section (Optional)
                      _buildDeviceTestsSection(),
                      const SizedBox(height: 24),

                      // Notes Section (Optional)
                      _buildNotesSection(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildBasicInfoSection() {
  return Container(
    constraints: const BoxConstraints(maxWidth: 600),
    child: Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Date and Inspector
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Inspector',
                border: OutlineInputBorder(),
              ),
              value: _selectedInspector,
              items: const [
                DropdownMenuItem(value: 'John Doe', child: Text('John Doe')),
                DropdownMenuItem(value: 'Jane Smith', child: Text('Jane Smith')),
                DropdownMenuItem(value: 'Charlie Brown', child: Text('Charlie Brown')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedInspector = value;
                });
              },
              validator: (value) => value?.isEmpty ?? true ? 'Inspector is required' : null,
            ),

            const SizedBox(height: 16),

            // Bill To and Location
            TextFormField(
              controller: _billToController,
              decoration: const InputDecoration(
                labelText: 'Bill To',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Bill To is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Location is required' : null,
            ),

            const SizedBox(height: 16),

            // Contact, City, and State
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Contact',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Contact is required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              value: _selectedState,
              items: const [
                DropdownMenuItem(value: 'New Hampshire', child: Text('New Hampshire')),
                DropdownMenuItem(value: 'Vermont', child: Text('Vermont')),
                DropdownMenuItem(value: 'Maine', child: Text('Maine')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                });
                _filterCitiesByState(value);
              },
              validator: (value) => value?.isEmpty ?? true ? 'State is required' : null,
            ),
            const SizedBox(height: 16),

            // Updated DropdownSearch for version 5.0.6
            DropdownSearch<String>(
              // NEW API: items is now a function
              items: (filter, infiniteScrollProps) {
                if (filter.isNotEmpty) {
                  return _filteredCities
                      .where((city) => city.toLowerCase().contains(filter.toLowerCase()))
                      .toList();
                }
                return _filteredCities;
              },
              
              selectedItem: _selectedCity,
              enabled: _selectedState != null && !_isCitiesLoading,
              
              onChanged: _selectedState == null || _isCitiesLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCity = value;
                        _locationCityController.text = value ?? '';
                      });
                    },
              
              // NEW API: decoratorProps replaces dropdownSearchDecoration
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: '',
                  border: const OutlineInputBorder(),
                  enabled: _selectedState != null && !_isCitiesLoading,
                  suffixIcon: _isCitiesLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
              ),
              
              // NEW API: popupProps replaces mode and showSearchBox
              popupProps: PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search cities...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                itemBuilder: (context, item, isDisabled, isSelected) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isDisabled ? Colors.grey : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
              
              // NEW API: dropdownBuilder for custom display when closed
              dropdownBuilder: (context, selectedItem) {
                if (selectedItem == null) {
                  return Text(
                    _selectedState == null
                        ? 'Select a state first'
                        : _isCitiesLoading
                            ? 'Loading cities...'
                            : _filteredCities.isEmpty
                                ? 'No cities found for this state'
                                : 'Select a city',
                    style: TextStyle(color: Colors.grey[600]),
                  );
                }
                return Text(selectedItem);
              },
              
              // Form validation - unchanged
              validator: (value) => value?.isEmpty ?? true ? 'City is required' : null,
            ),

            // Optional: Show city count info
            if (_filteredCities.length > 20) ...[
              const SizedBox(height: 8),
              Text(
                '${_filteredCities.length} cities available. Type to search.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    )
  );
}

  Widget _buildChecklistSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inspection Checklist',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildChecklistItem(
              'Is the building occupied?',
              _isBuildingOccupied,
              (value) => setState(() => _isBuildingOccupied = value!),
              required: true,
            ),

            _buildChecklistItem(
              'Are all systems in service?',
              _areAllSystemsInService,
              (value) => setState(() => _areAllSystemsInService = value!),
              required: true,
            ),

            _buildChecklistItem(
              'Are FP systems same as last inspection?',
              _areFpSystemsSame,
              (value) => setState(() => _areFpSystemsSame = value!),
              required: true,
            ),

            _buildChecklistItem(
              'Is hydraulic nameplate securely attached and legible?',
              _hydraulicNameplateSecure,
              (value) => setState(() => _hydraulicNameplateSecure = value!),
              required: true,
            ),

            _buildChecklistItem(
              'Was a main drain water flow test conducted?',
              _wasMainDrainTestConducted,
              (value) => setState(() => _wasMainDrainTestConducted = value!),
              required: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDrainTestSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Drain Tests',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // System 1
            _buildSystemTestRow('System 1', 0),
            const SizedBox(height: 16),

            // System 2
            _buildSystemTestRow('System 2', 1),
            const SizedBox(height: 16),

            // System 3
            _buildSystemTestRow('System 3', 2),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _drainTestNotesController,
              decoration: const InputDecoration(
                labelText: 'Drain Test Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTestsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Tests (Optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Show first 3 device test rows
            for (int i = 0; i < 3; i++) ...[
              _buildDeviceTestRow('Device ${i + 1}', i),
              if (i < 2) const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _adjustmentsController,
              decoration: const InputDecoration(
                labelText: 'Adjustments or Corrections Made',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _explanationController,
              decoration: const InputDecoration(
                labelText: 'Explanation of Any "No" Answers',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'General Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(
    String question,
    String value,
    Function(String?) onChanged, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question + (required ? ' *' : '')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Yes'),
                  value: 'Yes',
                  groupValue: value,
                  onChanged: onChanged,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('No'),
                  value: 'No',
                  groupValue: value,
                  onChanged: onChanged,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('N/A'),
                  value: 'N/A',
                  groupValue: value,
                  onChanged: onChanged,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemTestRow(String systemName, int index) {
    final controllers = [
      [
        _system1NameController,
        _system1DrainSizeController,
        _system1StaticPSIController,
        _system1ResidualPSIController,
      ],
      [
        _system2NameController,
        _system2DrainSizeController,
        _system2StaticPSIController,
        _system2ResidualPSIController,
      ],
      [
        _system3NameController,
        _system3DrainSizeController,
        _system3StaticPSIController,
        _system3ResidualPSIController,
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(systemName, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controllers[index][0],
                decoration: const InputDecoration(
                  labelText: 'System Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controllers[index][1],
                decoration: const InputDecoration(
                  labelText: 'Drain Size',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controllers[index][2],
                decoration: const InputDecoration(
                  labelText: 'Static PSI',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controllers[index][3],
                decoration: const InputDecoration(
                  labelText: 'Residual PSI',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeviceTestRow(String deviceName, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(deviceName, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _deviceNameControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Device Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _deviceAddressControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _deviceLocationControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Description/Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _deviceOperatedControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Operated',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _deviceDelayControllers[index],
                decoration: const InputDecoration(
                  labelText: 'Delay (Sec)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()), // Spacer
          ],
        ),
      ],
    );
  }
}
