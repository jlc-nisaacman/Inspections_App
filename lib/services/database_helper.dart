// lib/services/database_helper.dart
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/inspection_data.dart';
import '../models/backflow_data.dart';
import '../models/pump_system_data.dart';
import '../models/dry_system_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'jlc_inspection.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create inspections table
    await db.execute('''
      CREATE TABLE inspections(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL
      )
    ''');

    // Create backflow table
    await db.execute('''
      CREATE TABLE backflow(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL
      )
    ''');

    // Create pump_systems table
    await db.execute('''
      CREATE TABLE pump_systems(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL
      )
    ''');

    // Create dry_systems table
    await db.execute('''
      CREATE TABLE dry_systems(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL
      )
    ''');

    // Create sync_metadata table to track last sync times
    await db.execute('''
      CREATE TABLE sync_metadata(
        table_name TEXT PRIMARY KEY,
        last_sync INTEGER NOT NULL
      )
    ''');

    // Initialize sync metadata
    await db.insert('sync_metadata', {'table_name': 'inspections', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'backflow', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'pump_systems', 'last_sync': 0});
    await db.insert('sync_metadata', {'table_name': 'dry_systems', 'last_sync': 0});
  }

  // Helper methods to convert forms to JSON since they don't have toJson methods
  Map<String, dynamic> _inspectionFormToJson(InspectionData inspection) {
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
      'automatic_drain_valve_in_place': form.automaticDrainValeInPlace,
      'is_the_pump_room_heated': form.isThePumpRoomHeated,
      'adjustments_or_corrections_make': form.adjustmentsOrCorrectionsMake,
      'explanation_of_any_no_answers': form.explanationOfAnyNoAnswers,
      'explanation_of_any_no_answers_continued': form.explanationOfAnyNoAnswersContinued,
      'notes': form.notes,
      // Add the key searchable fields for better offline search
      'device_1_name': form.device1Name,
      'device_1_address': form.device1Address,
      'device_2_name': form.device2Name,
      'device_2_address': form.device2Address,
      'device_3_name': form.device3Name,
      'device_3_address': form.device3Address,
    };
  }

  Map<String, dynamic> _backflowFormToJson(BackflowData backflow) {
    final form = backflow.form;
    return {
      'pdf_path': form.pdfPath,
      'owner_of_property': form.ownerOfProperty,
      'device_location': form.deviceLocation,
      'mailing_address': form.mailingAddress,
      'date': form.date,
      'backflow_make': form.backflowMake,
      'backflow_model': form.backflowModel,
      'backflow_serial_number': form.backflowSerialNumber,
      'backflow_size': form.backflowSize,
      'backflow_type': form.backflowType,
      'certificate_number': form.certificateNumber,
      'contact_person': form.contactPerson,
      'protection_type': form.protectionType,
      'test_type': form.testType,
      'tested_by': form.testedBy,
      'witness': form.witness,
      'result': form.result,
      // Add other fields as needed
    };
  }

  Map<String, dynamic> _pumpSystemFormToJson(PumpSystemData pumpSystem) {
    final form = pumpSystem.form;
    return {
      'pdf_path': form.pdfPath,
      'report_to': form.reportTo,
      'building': form.building,
      'city_state': form.cityState,
      'date': form.date,
      'attention': form.attention,
      'street': form.street,
      'inspector': form.inspector,
      'pump_make': form.pumpMake,
      'pump_model': form.pumpModel,
      'pump_serial_number': form.pumpSerialNumber,
      'pump_rated_rpm': form.pumpRatedRPM,
      'pump_rated_gpm': form.pumpRatedGPM,
      'pump_max_psi': form.pumpMaxPSI,
      'pump_power': form.pumpPower,
      'pump_rated_psi': form.pumpRatedPSI,
      'pump_water_supply': form.pumpWaterSupply,
      // Add other fields as needed
    };
  }

  Map<String, dynamic> _drySystemFormToJson(DrySystemData drySystem) {
    final form = drySystem.form;
    return {
      'pdf_path': form.pdfPath,
      'report_to': form.reportTo,
      'building': form.building,
      'city_state': form.cityState,
      'date': form.date,
      'report_to_2': form.reportTo2,
      'building_2': form.building2,
      'attention': form.attention,
      'street': form.street,
      'inspector': form.inspector,
      'dry_pipe_valve_make': form.dryPipeValveMake,
      'dry_pipe_valve_model': form.dryPipeValveModel,
      'dry_pipe_valve_size': form.dryPipeValveSize,
      'dry_pipe_valve_year': form.dryPipeValveYear,
      // Add other fields as needed
    };
  }

  // Generic method to build searchable text from form data
  String _buildSearchableText(Map<String, dynamic> formData) {
    return formData.values
        .where((value) => value != null)
        .map((value) => value.toString().toLowerCase())
        .join(' ');
  }

  // INSPECTIONS METHODS
  Future<void> saveInspections(List<InspectionData> inspections) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('inspections'); // Clear existing data
      for (var inspection in inspections) {
        final formJson = _inspectionFormToJson(inspection);
        await txn.insert('inspections', {
          'form_data': jsonEncode(formJson),
          'last_updated': DateTime.now().millisecondsSinceEpoch,
          'searchable_text': _buildSearchableText(formJson),
        });
      }
    });
    await _updateSyncTime('inspections');
  }

  Future<List<InspectionData>> getInspections({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'inspections',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'id DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return InspectionData.fromJson(formData);
    }).toList();
  }

  Future<int> getInspectionsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM inspections${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // BACKFLOW METHODS
  Future<void> saveBackflow(List<BackflowData> backflowData) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('backflow');
      for (var data in backflowData) {
        final formJson = _backflowFormToJson(data);
        await txn.insert('backflow', {
          'form_data': jsonEncode(formJson),
          'last_updated': DateTime.now().millisecondsSinceEpoch,
          'searchable_text': _buildSearchableText(formJson),
        });
      }
    });
    await _updateSyncTime('backflow');
  }

  Future<List<BackflowData>> getBackflow({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'backflow',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'id DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return BackflowData.fromJson(formData);
    }).toList();
  }

  Future<int> getBackflowCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM backflow${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // PUMP SYSTEMS METHODS
  Future<void> savePumpSystems(List<PumpSystemData> pumpSystems) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('pump_systems');
      for (var data in pumpSystems) {
        final formJson = _pumpSystemFormToJson(data);
        await txn.insert('pump_systems', {
          'form_data': jsonEncode(formJson),
          'last_updated': DateTime.now().millisecondsSinceEpoch,
          'searchable_text': _buildSearchableText(formJson),
        });
      }
    });
    await _updateSyncTime('pump_systems');
  }

  Future<List<PumpSystemData>> getPumpSystems({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'pump_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'id DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return PumpSystemData.fromJson(formData);
    }).toList();
  }

  Future<int> getPumpSystemsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM pump_systems${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // DRY SYSTEMS METHODS
  Future<void> saveDrySystems(List<DrySystemData> drySystems) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('dry_systems');
      for (var data in drySystems) {
        final formJson = _drySystemFormToJson(data);
        await txn.insert('dry_systems', {
          'form_data': jsonEncode(formJson),
          'last_updated': DateTime.now().millisecondsSinceEpoch,
          'searchable_text': _buildSearchableText(formJson),
        });
      }
    });
    await _updateSyncTime('dry_systems');
  }

  Future<List<DrySystemData>> getDrySystems({
    int? limit,
    int? offset,
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'dry_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'id DESC',
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return DrySystemData.fromJson(formData);
    }).toList();
  }

  Future<int> getDrySystemsCount({
    String? searchTerm,
    String? searchColumn,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (searchTerm != null && searchTerm.isNotEmpty) {
      if (searchColumn != null) {
        whereClause = "json_extract(form_data, '.\$.$searchColumn') LIKE ?";
        whereArgs.add('%$searchTerm%');
      } else {
        whereClause = "searchable_text LIKE ?";
        whereArgs.add('%${searchTerm.toLowerCase()}%');
      }
    }

    if (startDate != null || endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      
      if (startDate != null && endDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "json_extract(form_data, '.\$.date') >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "json_extract(form_data, '.\$.date') <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM dry_systems${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // UTILITY METHODS
  Future<void> _updateSyncTime(String tableName) async {
    final db = await database;
    await db.update(
      'sync_metadata',
      {'last_sync': DateTime.now().millisecondsSinceEpoch},
      where: 'table_name = ?',
      whereArgs: [tableName],
    );
  }

  Future<DateTime?> getLastSyncTime(String tableName) async {
    final db = await database;
    final result = await db.query(
      'sync_metadata',
      where: 'table_name = ?',
      whereArgs: [tableName],
    );

    if (result.isNotEmpty) {
      final timestamp = result.first['last_sync'] as int;
      return timestamp > 0 ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    }
    return null;
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('inspections');
      await txn.delete('backflow');
      await txn.delete('pump_systems');
      await txn.delete('dry_systems');
      await txn.update('sync_metadata', {'last_sync': 0});
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}