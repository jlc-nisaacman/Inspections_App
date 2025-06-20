// lib/services/database_helper.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      version: 2, // Increment version to trigger migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create inspections table with pdf_path as primary key
    await db.execute('''
      CREATE TABLE inspections(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create backflow table with pdf_path as primary key
    await db.execute('''
      CREATE TABLE backflow(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create pump_systems table with pdf_path as primary key
    await db.execute('''
      CREATE TABLE pump_systems(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Create dry_systems table with pdf_path as primary key
    await db.execute('''
      CREATE TABLE dry_systems(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migrate from old schema to new schema with pdf_path as primary key
      await _migrateToV2(db);
    }
  }

  Future<void> _migrateToV2(Database db) async {
    // Create new tables with correct schema
    await db.execute('''
      CREATE TABLE inspections_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE backflow_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pump_systems_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE dry_systems_new(
        pdf_path TEXT PRIMARY KEY,
        form_data TEXT NOT NULL,
        last_updated INTEGER NOT NULL,
        searchable_text TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Migrate data from old tables to new tables (extracting pdf_path and date from JSON)
    await _migrateTableData(db, 'inspections', 'inspections_new');
    await _migrateTableData(db, 'backflow', 'backflow_new');
    await _migrateTableData(db, 'pump_systems', 'pump_systems_new');
    await _migrateTableData(db, 'dry_systems', 'dry_systems_new');

    // Drop old tables
    await db.execute('DROP TABLE IF EXISTS inspections');
    await db.execute('DROP TABLE IF EXISTS backflow');
    await db.execute('DROP TABLE IF EXISTS pump_systems');
    await db.execute('DROP TABLE IF EXISTS dry_systems');

    // Rename new tables
    await db.execute('ALTER TABLE inspections_new RENAME TO inspections');
    await db.execute('ALTER TABLE backflow_new RENAME TO backflow');
    await db.execute('ALTER TABLE pump_systems_new RENAME TO pump_systems');
    await db.execute('ALTER TABLE dry_systems_new RENAME TO dry_systems');
  }

  Future<void> _migrateTableData(Database db, String oldTable, String newTable) async {
    try {
      // Get all records from old table
      final List<Map<String, dynamic>> oldRecords = await db.query(oldTable);
      
      for (final record in oldRecords) {
        try {
          final formData = jsonDecode(record['form_data'] as String);
          final pdfPath = formData['pdf_path'] as String? ?? '';
          final date = formData['date'] as String? ?? '';
          
          // Only migrate records that have a valid pdf_path
          if (pdfPath.isNotEmpty) {
            await db.insert(
              newTable,
              {
                'pdf_path': pdfPath,
                'form_data': record['form_data'],
                'last_updated': record['last_updated'],
                'searchable_text': record['searchable_text'],
                'date': date,
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        } catch (e) {
          // Skip records that can't be parsed or don't have pdf_path
          // Use developer print instead of production print
          if (kDebugMode) {
            print('Skipping record migration due to error: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error migrating table $oldTable: $e');
      }
    }
  }

  // Helper methods to convert forms to JSON since they don't have toJson methods
  Map<String, dynamic> _inspectionFormToJson(InspectionData inspection) {
    final form = inspection.form;
    return {
      'pdf_path': form.pdfPath,
      'bill_to': form.billTo,
      'location': form.location,
      'location_city_state': form.locationCityState,
      'date': form.date,
      'contact': form.contact,
      'phone': form.phone,
      'inspector': form.inspector,
      'email': form.email,
      'inspection_frequency': form.inspectionFrequency,
      'inspection_number': form.inspectionNumber,
      'device_1_name': form.device1Name,
      'device_1_address': form.device1Address,
      'device_2_name': form.device2Name,
      'device_2_address': form.device2Address,
      'device_3_name': form.device3Name,
      'device_3_address': form.device3Address,
      // Add other key fields
      'attention': form.attention,
      'billing_street': form.billingStreet,
      'location_street': form.locationStreet,
      'billing_city_state': form.billingCityState,
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
      'pump_rated_gpm': form.pumpRatedGPM,
      'pump_rated_psi': form.pumpRatedPSI,
      'pump_max_psi': form.pumpMaxPSI,
      'pump_power': form.pumpPower,
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
      'attention': form.attention,
      'street': form.street,
      'inspector': form.inspector,
      'dry_pipe_valve_make': form.dryPipeValveMake,
      'dry_pipe_valve_model': form.dryPipeValveModel,
      'dry_pipe_valve_size': form.dryPipeValveSize,
      'dry_pipe_valve_year': form.dryPipeValveYear,
      'quick_opening_device_make': form.quickOpeningDeviceMake,
      'quick_opening_device_model': form.quickOpeningDeviceModel,
      'trip_test_air_pressure_before_test': form.tripTestAirPressureBeforeTest,
      'trip_test_air_system_tripped_at': form.tripTestAirSystemTrippedAt,
      'trip_test_water_pressure_before_test': form.tripTestWaterPressureBeforeTest,
      'trip_test_time': form.tripTestTime,
      'remarks_on_test': form.remarksOnTest,
      // Add other fields as needed
    };
  }

  // SAVE METHODS (Updated to use pdf_path as primary key)
  Future<void> saveInspections(List<InspectionData> inspections) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final inspection in inspections) {
        final formJson = _inspectionFormToJson(inspection);
        final searchableText = _createSearchableText(formJson);
        
        await txn.insert(
          'inspections',
          {
            'pdf_path': inspection.form.pdfPath,
            'form_data': jsonEncode(formJson),
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'searchable_text': searchableText,
            'date': inspection.form.date,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    await _updateSyncTime('inspections');
  }

  Future<void> saveBackflow(List<BackflowData> backflowList) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final backflow in backflowList) {
        final formJson = _backflowFormToJson(backflow);
        final searchableText = _createSearchableText(formJson);
        
        await txn.insert(
          'backflow',
          {
            'pdf_path': backflow.form.pdfPath,
            'form_data': jsonEncode(formJson),
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'searchable_text': searchableText,
            'date': backflow.form.date,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    await _updateSyncTime('backflow');
  }

  Future<void> savePumpSystems(List<PumpSystemData> pumpSystems) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final pumpSystem in pumpSystems) {
        final formJson = _pumpSystemFormToJson(pumpSystem);
        final searchableText = _createSearchableText(formJson);
        
        await txn.insert(
          'pump_systems',
          {
            'pdf_path': pumpSystem.form.pdfPath,
            'form_data': jsonEncode(formJson),
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'searchable_text': searchableText,
            'date': pumpSystem.form.date,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    await _updateSyncTime('pump_systems');
  }

  Future<void> saveDrySystems(List<DrySystemData> drySystems) async {
    final db = await database;
    await db.transaction((txn) async {
      for (final drySystem in drySystems) {
        final formJson = _drySystemFormToJson(drySystem);
        final searchableText = _createSearchableText(formJson);
        
        await txn.insert(
          'dry_systems',
          {
            'pdf_path': drySystem.form.pdfPath,
            'form_data': jsonEncode(formJson),
            'last_updated': DateTime.now().millisecondsSinceEpoch,
            'searchable_text': searchableText,
            'date': drySystem.form.date,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    await _updateSyncTime('dry_systems');
  }

  // GET METHODS (Updated to sort by date DESC for newest to oldest)
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'inspections',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC', // Sort by date newest to oldest, then by pdf_path
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return InspectionData.fromJson(formData);
    }).toList();
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'backflow',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC', // Sort by date newest to oldest, then by pdf_path
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return BackflowData.fromJson(formData);
    }).toList();
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'pump_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC', // Sort by date newest to oldest, then by pdf_path
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return PumpSystemData.fromJson(formData);
    }).toList();
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.query(
      'dry_systems',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      limit: limit,
      offset: offset,
      orderBy: 'date DESC, pdf_path DESC', // Sort by date newest to oldest, then by pdf_path
    );

    return result.map((map) {
      final formData = jsonDecode(map['form_data'] as String);
      return DrySystemData.fromJson(formData);
    }).toList();
  }

  // COUNT METHODS (Updated for new schema)
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM inspections${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM backflow${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
        whereArgs.add(endDate!.toIso8601String().split('T')[0]);
      }
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM pump_systems${whereClause.isEmpty ? '' : ' WHERE $whereClause'}',
      whereArgs.isEmpty ? null : whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
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
        whereClause += "date BETWEEN ? AND ?";
        whereArgs.addAll([
          startDate.toIso8601String().split('T')[0],
          endDate.toIso8601String().split('T')[0]
        ]);
      } else if (startDate != null) {
        whereClause += "date >= ?";
        whereArgs.add(startDate.toIso8601String().split('T')[0]);
      } else {
        whereClause += "date <= ?";
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
  String _createSearchableText(Map<String, dynamic> formData) {
    // Create searchable text from all relevant fields
    final searchableValues = <String>[];
    
    // Add common searchable fields
    final fieldsToIndex = [
      'pdf_path', 'bill_to', 'location', 'location_city_state', 'date',
      'contact', 'phone', 'inspector', 'email', 'inspection_frequency',
      'inspection_number', 'device_1_name', 'device_1_address', 
      'device_2_name', 'device_2_address', 'device_3_name', 'device_3_address',
      'attention', 'billing_street', 'location_street', 'billing_city_state',
      'owner_of_property', 'device_location', 'mailing_address', 
      'backflow_make', 'backflow_model', 'backflow_serial_number',
      'backflow_size', 'backflow_type', 'certificate_number', 'contact_person',
      'protection_type', 'test_type', 'tested_by', 'witness', 'result',
      'report_to', 'building', 'city_state', 'street',
      'pump_make', 'pump_model', 'pump_serial_number', 'pump_rated_gpm', 
      'pump_rated_psi', 'pump_max_psi', 'pump_power', 'pump_water_supply',
      'dry_pipe_valve_make', 'dry_pipe_valve_model', 'dry_pipe_valve_size',
      'quick_opening_device_make', 'quick_opening_device_model', 'remarks_on_test',
    ];
    
    for (final field in fieldsToIndex) {
      final value = formData[field];
      if (value != null && value.toString().isNotEmpty) {
        searchableValues.add(value.toString().toLowerCase());
      }
    }
    
    return searchableValues.join(' ');
  }

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

  // GET INDIVIDUAL RECORD BY PDF_PATH
  Future<InspectionData?> getInspectionByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return InspectionData.fromJson(formData);
    }
    return null;
  }

  Future<BackflowData?> getBackflowByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return BackflowData.fromJson(formData);
    }
    return null;
  }

  Future<PumpSystemData?> getPumpSystemByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return PumpSystemData.fromJson(formData);
    }
    return null;
  }

  Future<DrySystemData?> getDrySystemByPdfPath(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );

    if (result.isNotEmpty) {
      final formData = jsonDecode(result.first['form_data'] as String);
      return DrySystemData.fromJson(formData);
    }
    return null;
  }

  // DELETE METHODS
  Future<void> deleteInspection(String pdfPath) async {
    final db = await database;
    await db.delete(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deleteBackflow(String pdfPath) async {
    final db = await database;
    await db.delete(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deletePumpSystem(String pdfPath) async {
    final db = await database;
    await db.delete(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  Future<void> deleteDrySystem(String pdfPath) async {
    final db = await database;
    await db.delete(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
    );
  }

  // CLEAR ALL DATA
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

  // CHECK IF RECORD EXISTS
  Future<bool> inspectionExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'inspections',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> backflowExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'backflow',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> pumpSystemExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'pump_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> drySystemExists(String pdfPath) async {
    final db = await database;
    final result = await db.query(
      'dry_systems',
      where: 'pdf_path = ?',
      whereArgs: [pdfPath],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  // GET DATABASE STATISTICS
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;
    
    final inspectionsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM inspections')
    ) ?? 0;
    
    final backflowCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM backflow')
    ) ?? 0;
    
    final pumpSystemsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM pump_systems')
    ) ?? 0;
    
    final drySystemsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM dry_systems')
    ) ?? 0;
    
    return {
      'inspections': inspectionsCount,
      'backflow': backflowCount,
      'pump_systems': pumpSystemsCount,
      'dry_systems': drySystemsCount,
      'total': inspectionsCount + backflowCount + pumpSystemsCount + drySystemsCount,
    };
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}