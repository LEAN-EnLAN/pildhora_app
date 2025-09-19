import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/models/medication_intake.dart';

/// A service that handles all database operations for the application.
///
/// This class follows the singleton pattern to ensure only one instance
/// of the database is open at any time.
class DatabaseService {
  /// The single, static instance of [DatabaseService].
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Returns the singleton instance of the database.
  ///
  /// If the database is not yet initialized, it will be initialized.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pildhora.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await _createMedicationsTable(db);
    await _createIntakesTable(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createIntakesTable(db);
    }
  }

  Future<void> _createMedicationsTable(Database db) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE medications (
      id $idType,
      "patientId" $textType,
      name $textType,
      dosage $textType,
      time $textType
    )
    ''');
  }

  Future<void> _createIntakesTable(Database db) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE medication_intakes (
      id $idType,
      "medicationId" $textType,
      "medicationName" $textType,
      "patientId" $textType,
      "scheduledTime" $textType,
      "takenTime" $textType,
      status $textType
    )
    ''');
  }

  /// Inserts a new medication into the database.
  Future<void> insertMedication(Medication medication) async {
    final db = await instance.database;
    await db.insert('medications', medication.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retrieves all medications for a given patient.
  Future<List<Medication>> getMedications(String patientId) async {
    final db = await instance.database;
    final maps = await db.query(
      'medications',
      where: '"patientId" = ?',
      whereArgs: [patientId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Medication.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  /// Updates an existing medication in the database.
  Future<void> updateMedication(Medication medication) async {
    final db = await instance.database;
    await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  /// Deletes a medication from the database by its ID.
  Future<void> deleteMedication(String id) async {
    final db = await instance.database;
    await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Intake Methods ---

  /// Inserts a new medication intake record into the database.
  Future<void> insertIntake(MedicationIntake intake) async {
    final db = await instance.database;
    await db.insert('medication_intakes', intake.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Retrieves all intake records for a given patient, ordered by most recent.
  Future<List<MedicationIntake>> getIntakes(String patientId) async {
    final db = await instance.database;
    final maps = await db.query(
      'medication_intakes',
      where: '"patientId" = ?',
      whereArgs: [patientId],
      orderBy: 'takenTime DESC',
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => MedicationIntake.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  /// Closes the database connection.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

