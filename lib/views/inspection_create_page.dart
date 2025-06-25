// lib/views/inspection_create_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../models/inspection_data.dart';
import '../models/inspection_form.dart';
import '../services/data_service.dart';
import '../services/database_helper.dart';

class InspectionCreatePage extends StatefulWidget {
  const InspectionCreatePage({super.key});

  @override
  State<InspectionCreatePage> createState() => _InspectionCreatePageState();
}

class _InspectionCreatePageState extends State<InspectionCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final DataService _dataService = DataService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  // Loading states
  bool _isLoading = false;
  bool _isSaving = false;
  List<String> _inspectors = [];

  // Form controllers - Header Section
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
  final _locationCityStateController = TextEditingController();
  final _locationCityStateLn2Controller = TextEditingController();
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
  final List<TextEditingController> _deviceNameControllers = List.generate(14, (index) => TextEditingController());
  final List<TextEditingController> _deviceAddressControllers = List.generate(14, (index) => TextEditingController());
  final List<TextEditingController> _deviceLocationControllers = List.generate(14, (index) => TextEditingController());
  final List<TextEditingController> _deviceOperatedControllers = List.generate(14, (index) => TextEditingController());
  final List<TextEditingController> _deviceDelayControllers = List.generate(14, (index) => TextEditingController());

  // Form controllers - Notes (Optional)
  final _adjustmentsController = TextEditingController();
  final _explanationController = TextEditingController();
  final _explanationContinuedController = TextEditingController();
  final _notesController = TextEditingController();

  // Form values
  DateTime _selectedDate = DateTime.now();
  String? _selectedInspector;
  String _newInspectorName = '';

  // Checklist values - General
  String _isBuildingOccupied = '';
  String _areAllSystemsInService = '';
  String _areFpSystemsSame = '';
  String _hydraulicNameplateSecure = '';

  // Checklist values - Water Supplies
  String _wasMainDrainTestConducted = '';

  // Checklist values - Control Valves
  String _areMainControlValvesOpen = '';
  String _areOtherValvesProper = '';
  String _areControlValvesSealed = '';
  String _areControlValvesGoodCondition = '';

  // Checklist values - Fire Department Connections
  String _areFDConnectionsSatisfactory = '';
  String _areCapsInPlace = '';
  String _isFDConnectionAccessible = '';
  String _automaticDrainValveInPlace = '';

  // Checklist values - Fire Pump General
  String _isPumpRoomHeated = '';
  String _isFirePumpInService = '';
  String _wasFirePumpRun = '';

  // Checklist values - Diesel Fire Pump
  String _dieselPumpValue = '';

  // Checklist values - Electric Fire Pump
  String _electricPumpValue = '';

  // Checklist values - Alarm Device
  String _areAllTamperSwitchesOperational = '';
  String _didAlarmPanelClear = '';

  // Checklist values - Sprinklers Piping
  String _areMinimumSpareSprinklers = '';
  String _isPipingConditionSatisfactory = '';
  String _areDryTypeHeadsLessThan10 = '';
  String _dryTypeHeadsYear = '';
  String _areQuickResponseHeadsLessThan20 = '';
  String _quickResponseHeadsYear = '';
  String _areStandardResponseHeadsLessThan50 = '';
  String _standardResponseHeadsYear = '';
  String _haveGaugesBeenTested = '';
  String _gaugesYear = '';

  @override
  void initState() {
    super.initState();
    _loadInspectors();
  }

  @override
  void dispose() {
    // Dispose all controllers
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
    _locationCityStateController.dispose();
    _locationCityStateLn2Controller.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _inspectionFrequencyController.dispose();
    _inspectionNumberController.dispose();
    
    // Dispose drain test controllers
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
    
    // Dispose device controllers
    for (var controller in _deviceNameControllers) controller.dispose();
    for (var controller in _deviceAddressControllers) controller.dispose();
    for (var controller in _deviceLocationControllers) controller.dispose();
    for (var controller in _deviceOperatedControllers) controller.dispose();
    for (var controller in _deviceDelayControllers) controller.dispose();
    
    // Dispose notes controllers
    _adjustmentsController.dispose();
    _explanationController.dispose();
    _explanationContinuedController.dispose();
    _notesController.dispose();
    
    super.dispose();
  }

  Future<void> _loadInspectors() async {
    setState(() => _isLoading = true);
    
    try {
      final inspectors = await _getDistinctInspectors();
      setState(() {
        _inspectors = inspectors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading inspectors: $e')),
        );
      }
    }
  }

  Future<List<String>> _getDistinctInspectors() async {
    final db = await _dbHelper.database;
    final Set<String> inspectors = {};

    // Query all four inspection types
    final tables = ['inspections', 'backflow', 'pump_systems', 'dry_systems'];
    
    for (final table in tables) {
      try {
        final result = await db.rawQuery('''
          SELECT DISTINCT json_extract(form_data, '\$.inspector') as inspector 
          FROM $table 
          WHERE json_extract(form_data, '\$.inspector') IS NOT NULL 
          AND json_extract(form_data, '\$.inspector') != ''
        ''');
        
        for (final row in result) {
          final inspector = row['inspector'] as String?;
          if (inspector != null && inspector.isNotEmpty) {
            inspectors.add(inspector);
          }
        }
      } catch (e) {
        // Table might not exist or have data, continue
      }
    }
    
    final list = inspectors.toList();
    list.sort();
    return list;
  }

  String _generatePdfPath() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final location = _locationController.text.trim();
    final billTo = _billToController.text.trim();
    final city = _locationCityStateController.text.trim().split(',').first.trim();
    
    if (location.isEmpty || billTo.isEmpty || city.isEmpty) {
      return '';
    }
    
    return 'H:\\Inspections - Maintenance\\Files by town\\$city\\$billTo\\$location\\$dateStr - $location.pdf';
  }

  Future<void> _saveInspection() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate checklist sections
    if (!_validateChecklist()) {
      return;
    }

    // Validate main drain test
    if (!_validateMainDrainTest()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final pdfPath = _generatePdfPath();
      if (pdfPath.isEmpty) {
        throw Exception('Cannot generate PDF path. Ensure Bill To, Location, and City are provided.');
      }

      // Create InspectionForm
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
        locationCityState: _locationCityStateController.text.trim(),
        locationCityStateLn2: _locationCityStateLn2Controller.text.trim(),
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
        areAllControlValvesSealedOrSupervised: _areControlValvesSealed,
        areAllControlValvesInGoodConditionAndFreeOfLeaks: _areControlValvesGoodCondition,
        
        // Checklist - Fire Department Connections
        areFireDepartmentConnectionsInSatisfactoryCondition: _areFDConnectionsSatisfactory,
        areCapsInPlace: _areCapsInPlace,
        isFireDepartmentConnectionEasilyAccessible: _isFDConnectionAccessible,
        automaticDrainValeInPlace: _automaticDrainValveInPlace,
        
        // Checklist - Fire Pump General
        isThePumpRoomHeated: _isPumpRoomHeated,
        isTheFirePumpInService: _isFirePumpInService,
        wasFirePumpRunDuringThisInspection: _wasFirePumpRun,
        


        
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
        pumpEngineOilPressurePSI: '',
        pumpEngineOilPressure: '',
        pumpWaterPressurePSI: '',
        pumpWaterPressure: '',
        engineWaterTemperature: '',
        engineOilTemperature: '',
        engineBatteryVoltagePSI: '',
        engineBatteryVoltage: '',
        engineBatteryChargerCurrent: '',
        ratedSpeedRPM: '',
        noLoadSpeed: '',
        fiftyPercentRatedSpeed: '',
        oneHundredPercentRatedSpeed: '',
        oneHundredTwentyFivePercentRatedSpeed: '',
        areAllTamperSwitchesOperational: _areAllTamperSwitchesOperational,
        didAlarmPanelClearAfterTest: _didAlarmPanelClear,
        dieselPumpGeneralNa: _dieselPumpValue,
        dieselPumpGeneral: '',
        dieselPumpMaintenanceTest: '',
        dieselPumpMaintenanceTestNa: '',
        doesTheTankMeetStandards: '',
        doesTheDayTankMeetStandards: '',
        areFuelLinesSecurelySupportedAndProtected: '',
        areFuelLineShutOffValvesAccessible: '',
        areFuelLineCouplingsTight: '',
        doesTheVentMeetStandards: '',
        isTheSupplyLineMeetStandards: '',
        isTheReturnLineMeetStandards: '',
        areFuelFilterElementsServiced: '',
        isFuelFilterElementsCracked: '',
        isTheFuelPumpStrainerClean: '',
        arePumpAndBeltGuardsInPlace: '',
        arePumpAndBeltGuardsSafe: '',
        doesTheFlexibleCouplingMeetStandards: '',
        isTheEngineAndMountingSecure: '',
        isTheEngineAndControllerClean: '',
        areElectricalConnectionsSecure: '',
        areElectricalConnectionsClean: '',
        isExhaustSystemSecure: '',
        isExhaustSystemClean: '',
        areVibrationPadsInPlace: '',
        areVibrationPadsIntact: '',
        isTheAirIntakeFree: '',
        areStartingBatteriesSecure: '',
        areStartingBatteriesClean: '',
        isBatteryChargerOperational: '',
        isBatteryChargerMounted: '',
        electricPumpGeneralNa: _electricPumpValue,
        electricPumpGeneral: '',
        electricPumpMaintenanceTest: '',
        electricPumpMaintenanceTestNa: '',
        isPumpSecureToMountingPad: '',
        arePumpAndMotorCouplingSecure: '',
        arePumpAndMotorCouplingGuarded: '',
        arePumpStartingComponentsClean: '',
        arePumpCoolingSystemClean: '',
        isElectricalEquipmentClean: '',
        isMotorSecureToMountingPad: '',
        isControllerSecure: '',
        isControllerInEnclosure: '',
        isControllerMountingSecure: '',
        areElectricalConnectionsSecureElectric: '',
        areElectricalConnectionsCleanElectric: '',
        fireProtectionSystemsSprinklerHeads: '',
        sprinklerHeadsCondition: '',
        sprinklerHeadsSprayed: '',
        sprinklerHeadsObstructions: '',
        sprinklerHeadsDropped: '',
        pipeAndFittingsCondition: '',
        hangersAndSupportsCondition: '',
        fireProtectionSystemsPiping: '',
        areAMinimumOf6SpareSprinklersReadilyAvaiable: _areMinimumSpareSprinklers,
        isConditionOfPipingAndOtherSystemComponentsSatisfactory: _isPipingConditionSatisfactory,
        areKnownDryTypeHeadsLessThan10YearsOld: _areDryTypeHeadsLessThan10,
        areKnownDryTypeHeadsLessThan10YearsOldYear: _dryTypeHeadsYear,
        areKnownQuickResponseHeadsLessThan20YearsOld: _areQuickResponseHeadsLessThan20,
        areKnownQuickResponseHeadsLessThan20YearsOldYear: _quickResponseHeadsYear,
        areKnownStandardResponseHeadsLessThan50YearsOld: _areStandardResponseHeadsLessThan50,
        areKnownStandardResponseHeadsLessThan50YearsOldYear: _standardResponseHeadsYear,
        haveAllGaugesBeenTestedOrReplacedInTheLast5Years: _haveGaugesBeenTested,
        haveAllGaugesBeenTestedOrReplacedInTheLast5YearsYear: _gaugesYear,
        
        // Main Drain Test fields
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
      );

      // Create InspectionData
      final inspectionData = InspectionData(form: form);
      
      // Save to local database with created_locally flag
      await _saveToLocalDatabase(inspectionData);
      
      setState(() => _isSaving = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inspection saved locally. It will sync when online.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving inspection: $e')),
        );
      }
    }
  }

  Future<void> _saveToLocalDatabase(InspectionData inspectionData) async {
    final db = await _dbHelper.database;
    
    // Convert to JSON with created_locally flag
    final formJson = _inspectionToJson(inspectionData);
    formJson['created_locally'] = true;
    formJson['last_modified'] = DateTime.now().toIso8601String();
    
    final searchableText = _createSearchableText(formJson);
    
    await db.insert(
      'inspections',
      {
        'pdf_path': inspectionData.form.pdfPath,
        'form_data': jsonEncode(formJson),
        'last_updated': DateTime.now().millisecondsSinceEpoch,
        'last_modified': DateTime.now().toIso8601String(),
        'searchable_text': searchableText,
        'date': inspectionData.form.date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, dynamic> _inspectionToJson(InspectionData inspection) {
    // Convert InspectionData to JSON format matching your existing structure
    final form = inspection.form;
    return {
      'pdf_path': form.pdfPath,
      'bill_to': form.billTo,
      'location': form.location,
      'bill_to_ln_2': form.billToLn2,
      'location_ln_2': form.locationLn2,
      'attention': form.attention,
      'billing_street': form.billingStreet,
      'billing_street_ln_2': form.billingStreetLn2,
      'location_street': form.locationStreet,
      'location_street_ln_2': form.locationStreetLn2,
      'billing_city_state': form.billingCityState,
      'billing_city_state_ln_2': form.billingCityStateLn2,
      'location_city_state': form.locationCityState,
      'location_city_state_ln_2': form.locationCityStateLn2,
      'contact': form.contact,
      'date': form.date,
      'phone': form.phone,
      'inspector': form.inspector,
      'email': form.email,
      'inspection_frequency': form.inspectionFrequency,
      'inspection_number': form.inspectionNumber,
      
      // Checklist
      'is_the_building_occupied': form.isTheBuildingOccupied,
      'are_all_systems_in_service': form.areAllSystemsInService,
      'are_fp_systems_same_as_last_inspection': form.areFpSystemsSameAsLastInspection,
      'hydraulic_nameplate_securely_attached_and_legible': form.hydraulicNameplateSecurelyAttachedAndLegible,
      'was_a_main_drain_water_flow_test_conducted': form.wasAMainDrainWaterFlowTestConducted,
      'are_all_sprinkler_system_main_control_valves_open': form.areAllSprinklerSystemMainControlValvesOpen,
      'are_all_other_valves_in_proper_position': form.areAllOtherValvesInProperPosition,
      'are_all_control_valves_sealed_or_supervised': form.areAllControlValvesSealedOrSupervised,
      'are_all_control_valves_in_good_condition_and_free_of_leaks': form.areAllControlValvesInGoodConditionAndFreeOfLeaks,
      'are_fire_department_connections_in_satisfactory_condition': form.areFireDepartmentConnectionsInSatisfactoryCondition,
      'are_caps_in_place': form.areCapsInPlace,
      'is_fire_department_connection_easily_accessible': form.isFireDepartmentConnectionEasilyAccessible,
      'automatic_drain_vale_in_place': form.automaticDrainValeInPlace,
      'is_the_pump_room_heated': form.isThePumpRoomHeated,
      'is_the_fire_pump_in_service': form.isTheFirePumpInService,
      'was_fire_pump_run_during_this_inspection': form.wasFirePumpRunDuringThisInspection,
      
      // Main Drain Test
      'system_1_name': form.system1Name,
      'system_1_drain_size': form.system1DrainSize,
      'system_1_static_psi': form.system1StaticPSI,
      'system_1_residual_psi': form.system1ResidualPSI,
      'system_2_name': form.system2Name,
      'system_2_drain_size': form.system2DrainSize,
      'system_2_static_psi': form.system2StaticPSI,
      'system_2_residual_psi': form.system2ResidualPSI,
      'system_3_name': form.system3Name,
      'system_3_drain_size': form.system3DrainSize,
      'system_3_static_psi': form.system3StaticPSI,
      'system_3_residual_psi': form.system3ResidualPSI,
      'drain_test_notes': form.drainTestNotes,
      
      // Device Tests
      'device_1_name': form.device1Name,
      'device_1_address': form.device1Address,
      'device_1_description_location': form.device1DescriptionLocation,
      'device_1_operated': form.device1Operated,
      'device_1_delay_sec': form.device1DelaySec,
      // Add remaining devices...
      
      // Notes
      'adjustments_or_corrections_make': form.adjustmentsOrCorrectionsMake,
      'explanation_of_any_no_answers': form.explanationOfAnyNoAnswers,
      'explanation_of_any_no_answers_continued': form.explanationOfAnyNoAnswersContinued,
      'notes': form.notes,
    };
  }

  String _createSearchableText(Map<String, dynamic> formData) {
    final searchableValues = <String>[];
    
    final fieldsToIndex = [
      'pdf_path', 'bill_to', 'location', 'location_city_state', 'date',
      'contact', 'phone', 'inspector', 'email', 'inspection_frequency',
      'inspection_number', 'device_1_name', 'device_1_address', 
      'device_2_name', 'device_2_address', 'device_3_name', 'device_3_address',
      'attention', 'billing_street', 'location_street', 'billing_city_state',
    ];
    
    for (final field in fieldsToIndex) {
      final value = formData[field];
      if (value != null && value.toString().isNotEmpty) {
        searchableValues.add(value.toString().toLowerCase());
      }
    }
    
    return searchableValues.join(' ');
  }

  bool _validateChecklist() {
    final errors = <String>[];
    
    // Validate required checklist fields
    if (_isBuildingOccupied.isEmpty) errors.add('Building occupied status');
    if (_areAllSystemsInService.isEmpty) errors.add('Systems in service status');
    if (_areFpSystemsSame.isEmpty) errors.add('Fire protection systems same as last inspection');
    if (_hydraulicNameplateSecure.isEmpty) errors.add('Hydraulic nameplate status');
    
    // Add more validation as needed
    
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete required checklist items: ${errors.join(', ')}'),
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
    if (_wasMainDrainTestConducted == 'No' && _drainTestNotesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes are required when main drain test is not conducted (weather conditions, etc.)'),
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
        title: const Text('New Inspection'),
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
            TextButton(
              onPressed: _saveInspection,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    _buildSectionHeader('Header Information (Required)'),
                    _buildHeaderSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Checklist Section
                    _buildSectionHeader('Checklist (Required)'),
                    _buildChecklistSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Main Drain Test Section
                    _buildSectionHeader('Main Drain Test (Required)'),
                    _buildMainDrainTestSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Device Tests Section
                    _buildSectionHeader('Device Tests (Optional)'),
                    _buildDeviceTestsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Notes Section
                    _buildSectionHeader('Notes (Optional)'),
                    _buildNotesSection(),
                    
                    const SizedBox(height: 32),
                    
                    // Save Button
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveInspection,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSaving
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Saving...'),
                              ],
                            )
                          : const Text('Save Inspection', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date and Inspector
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Inspector *', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedInspector,
                        hint: const Text('Select Inspector'),
                        items: [
                          ..._inspectors.map((inspector) => DropdownMenuItem(
                            value: inspector,
                            child: Text(inspector),
                          )),
                          const DropdownMenuItem(
                            value: '__ADD_NEW__',
                            child: Text('+ Add New Inspector'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == '__ADD_NEW__') {
                            _showAddInspectorDialog();
                          } else {
                            setState(() => _selectedInspector = value);
                          }
                        },
                        validator: (value) => value == null || value.isEmpty ? 'Inspector is required' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Bill To and Location
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _billToController,
                    decoration: const InputDecoration(
                      labelText: 'Bill To *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Bill To is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.trim().isEmpty ?? true ? 'Location is required' : null,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Additional fields can be added here...
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(
                labelText: 'Contact *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Contact is required' : null,
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            
            // Location City/State (needed for PDF path)
            TextFormField(
              controller: _locationCityStateController,
              decoration: const InputDecoration(
                labelText: 'Location City/State *',
                border: OutlineInputBorder(),
                helperText: 'Required for PDF path generation',
              ),
              validator: (value) => value?.trim().isEmpty ?? true ? 'Location City/State is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // General Section
            ExpansionTile(
              title: const Text('General', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                _buildRadioGroup(
                  'Is the building occupied? *',
                  ['Yes', 'No', 'N/A'],
                  _isBuildingOccupied,
                  (value) => setState(() => _isBuildingOccupied = value),
                ),
                _buildRadioGroup(
                  'Are all systems in service? *',
                  ['Yes', 'No', 'N/A'],
                  _areAllSystemsInService,
                  (value) => setState(() => _areAllSystemsInService = value),
                ),
                _buildRadioGroup(
                  'Are fire protection systems same as last inspection? *',
                  ['Yes', 'No', 'N/A'],
                  _areFpSystemsSame,
                  (value) => setState(() => _areFpSystemsSame = value),
                ),
                _buildRadioGroup(
                  'Hydraulic nameplate securely attached and legible? *',
                  ['Yes', 'No', 'N/A'],
                  _hydraulicNameplateSecure,
                  (value) => setState(() => _hydraulicNameplateSecure = value),
                ),
              ],
            ),
            
            // Water Supplies Section
            ExpansionTile(
              title: const Text('Water Supplies', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                _buildRadioGroup(
                  'Was a main drain water flow test conducted? *',
                  ['Yes', 'No', 'N/A'],
                  _wasMainDrainTestConducted,
                  (value) => setState(() => _wasMainDrainTestConducted = value),
                ),
              ],
            ),
            
            // Control Valves Section
            ExpansionTile(
              title: const Text('Control Valves', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                _buildRadioGroup(
                  'Are all sprinkler system main control valves open? *',
                  ['Yes', 'No', 'N/A'],
                  _areMainControlValvesOpen,
                  (value) => setState(() => _areMainControlValvesOpen = value),
                ),
                _buildRadioGroup(
                  'Are all other valves in proper position? *',
                  ['Yes', 'No', 'N/A'],
                  _areOtherValvesProper,
                  (value) => setState(() => _areOtherValvesProper = value),
                ),
              ],
            ),
            
            // Add more checklist sections as needed...
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
            _buildRadioGroup(
              'Was main drain test conducted? *',
              ['Yes', 'No'],
              _wasMainDrainTestConducted,
              (value) => setState(() => _wasMainDrainTestConducted = value),
            ),
            
            if (_wasMainDrainTestConducted == 'Yes') ...[
              const SizedBox(height: 16),
              const Text('System 1', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _system1NameController,
                      decoration: const InputDecoration(
                        labelText: 'System Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _system1DrainSizeController,
                      decoration: const InputDecoration(
                        labelText: 'Drain Size',
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
                      controller: _system1StaticPSIController,
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
                      controller: _system1ResidualPSIController,
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
            
            if (_wasMainDrainTestConducted == 'No') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _drainTestNotesController,
                decoration: const InputDecoration(
                  labelText: 'Explanation (Required - e.g., weather conditions) *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: _wasMainDrainTestConducted == 'No' 
                    ? (value) => value?.trim().isEmpty ?? true ? 'Explanation is required when test not conducted' : null
                    : null,
              ),
            ],
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
            const Text(
              'Add device test entries as needed (all optional)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Just show first few devices for the create form
            ...List.generate(3, (index) => _buildDeviceTestEntry(index + 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTestEntry(int deviceNumber) {
    final nameController = _deviceNameControllers[deviceNumber - 1];
    final addressController = _deviceAddressControllers[deviceNumber - 1];
    final locationController = _deviceLocationControllers[deviceNumber - 1];
    final operatedController = _deviceOperatedControllers[deviceNumber - 1];
    final delayController = _deviceDelayControllers[deviceNumber - 1];
    
    return ExpansionTile(
      title: Text('Device $deviceNumber'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Device $deviceNumber Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Device $deviceNumber Address',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: operatedController,
                      decoration: const InputDecoration(
                        labelText: 'Operated',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: delayController,
                      decoration: const InputDecoration(
                        labelText: 'Delay (sec)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(String title, List<String> options, String selectedValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: options.map((option) => Expanded(
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(value!),
                dense: true,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  void _showAddInspectorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Inspector'),
        content: TextFormField(
          onChanged: (value) => _newInspectorName = value,
          decoration: const InputDecoration(
            labelText: 'Inspector Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_newInspectorName.trim().isNotEmpty) {
                setState(() {
                  _inspectors.add(_newInspectorName.trim());
                  _inspectors.sort();
                  _selectedInspector = _newInspectorName.trim();
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}