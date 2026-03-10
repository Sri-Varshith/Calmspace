import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';
import '../../data/repositories/ambience_repository.dart';

// ─── Repository Provider ───────────────────────────────────────────
// Provides single instance of AmbienceRepository to whole app
final ambienceRepositoryProvider = Provider<AmbienceRepository>((ref) {
  return AmbienceRepository();
});

// ─── Raw Ambiences Provider ────────────────────────────────────────
// Loads all ambiences from JSON once - read only, no modifications needed
// FutureProvider is still correct here in Riverpod 3.x
final ambiencesProvider = FutureProvider<List<Ambience>>((ref) async {
  final repository = ref.watch(ambienceRepositoryProvider);
    ref.keepAlive(); 
  return repository.loadAmbiences();
});

// ─── Search Query Notifier ─────────────────────────────────────────
// Replaces old StateProvider<String>
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => ''; // initial state is empty string

  void updateQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

// ─── Selected Tag Notifier ─────────────────────────────────────────
// Replaces old StateProvider<String?>
// null means no tag selected (show all)
class SelectedTagNotifier extends Notifier<String?> {
  @override
  String? build() => null; // initial state is null (no filter)

  void selectTag(String tag) {
    // If same tag tapped again → deselect it
    if (state == tag) {
      state = null;
    } else {
      state = tag;
    }
  }

  void clearTag() {
    state = null;
  }
}

final selectedTagProvider = NotifierProvider<SelectedTagNotifier, String?>(
  SelectedTagNotifier.new,
);

// ─── Filtered Ambiences Provider ──────────────────────────────────
// Combines raw ambiences + search + tag filter
// Returns final list UI should display
final filteredAmbiencesProvider = Provider<AsyncValue<List<Ambience>>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedTag = ref.watch(selectedTagProvider);

  return ambiencesAsync.whenData((ambiences) {
    return ambiences.where((ambience) {
      final matchesSearch = ambience.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesTag =
          selectedTag == null || ambience.tag == selectedTag;

      return matchesSearch && matchesTag;
    }).toList();
  });
});