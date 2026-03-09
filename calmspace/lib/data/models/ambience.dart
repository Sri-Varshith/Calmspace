class Ambience {
  final String id;
  final String title;
  final String tag;
  final int durationSeconds;
  final String description;
  final String imagePath;
  final String audioPath;
  final List<String> sensoryChips;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.durationSeconds,
    required this.description,
    required this.imagePath,
    required this.audioPath,
    required this.sensoryChips,
  });

  // Converts raw JSON map into an Ambience object
  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      durationSeconds: json['durationSeconds'] as int,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      audioPath: json['audioPath'] as String,
      sensoryChips: List<String>.from(json['sensoryChips']),
    );
  }
}