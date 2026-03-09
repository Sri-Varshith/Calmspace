import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbienceRepository {
  Future<List<Ambience>> loadAmbiences() async {
    // Step 1: Read the raw JSON text from assets
    final String rawJson = await rootBundle.loadString(
      'assets/data/ambiences.json',
    );

    // Step 2: Convert raw text into a Dart List
    final List<dynamic> decoded = jsonDecode(rawJson);

    // Step 3: Convert each Map into an Ambience object
    return decoded
        .map((item) => Ambience.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}