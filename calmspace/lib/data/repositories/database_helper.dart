import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry.dart';

class DatabaseHelper {
  // Single instance of DatabaseHelper throughout the app
  static final DatabaseHelper instance = DatabaseHelper._internal();
  
  // The actual database object
  static Database? _database;

  // Private constructor - prevents creating multiple instances
  DatabaseHelper._internal();

  // Getter that creates database if it doesn't exist yet
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Creates the database file on the device
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calmspace.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  // Creates the journal_entries table
  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        ambienceId TEXT NOT NULL,
        ambienceTitle TEXT NOT NULL,
        mood TEXT NOT NULL,
        journalText TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Save a new journal entry
  Future<void> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.insert(
      'journal_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all journal entries, newest first
  Future<List<JournalEntry>> getAllJournalEntries() async {
    final db = await database;
    final maps = await db.query(
      'journal_entries',
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }
}