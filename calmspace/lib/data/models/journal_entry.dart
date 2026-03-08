class JournalEntry {
  final String id;
  final String ambienceId;
  final String ambienceTitle;
  final String mood;
  final String journalText;
  final DateTime createdAt;

  const JournalEntry({
    required this.id,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.mood,
    required this.journalText,
    required this.createdAt,
  });

  // Convert database row into JournalEntry object
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      ambienceId: map['ambienceId'] as String,
      ambienceTitle: map['ambienceTitle'] as String,
      mood: map['mood'] as String,
      journalText: map['journalText'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Convert JournalEntry object into a map for saving to database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ambienceId': ambienceId,
      'ambienceTitle': ambienceTitle,
      'mood': mood,
      'journalText': journalText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}