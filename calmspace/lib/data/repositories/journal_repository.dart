import '../models/journal_entry.dart';
import 'database_helper.dart';

class JournalRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Save a new journal entry
  Future<void> saveEntry(JournalEntry entry) async {
    await _dbHelper.insertJournalEntry(entry);
  }

  // Get all journal entries
  Future<List<JournalEntry>> getEntries() async {
    return await _dbHelper.getAllJournalEntries();
  }
}