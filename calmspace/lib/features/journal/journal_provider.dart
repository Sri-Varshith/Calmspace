import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/journal_entry.dart';
import '../../data/repositories/journal_repository.dart';

// ─── Repository Provider ───────────────────────────────────────────
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

// ─── Journal State ─────────────────────────────────────────────────
class JournalState {
  final List<JournalEntry> entries;
  final bool isLoading;
  final String? error;

  const JournalState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
  });

  JournalState copyWith({
    List<JournalEntry>? entries,
    bool? isLoading,
    String? error,
  }) {
    return JournalState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// ─── Journal Notifier ──────────────────────────────────────────────
class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    // Load entries as soon as provider is created
    loadEntries();
    return const JournalState();
  }

  Future<void> loadEntries() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(journalRepositoryProvider);
      final entries = await repository.getEntries();
      state = state.copyWith(
        entries: entries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> saveEntry(JournalEntry entry) async {
    try {
      final repository = ref.read(journalRepositoryProvider);
      await repository.saveEntry(entry);
      // Reload entries after saving
      await loadEntries();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final journalProvider = NotifierProvider<JournalNotifier, JournalState>(
  JournalNotifier.new,
);