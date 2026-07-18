import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/flashcard.dart';

class StorageService {
  static const String _storageKey = 'flashcards_data';

  Future<List<Flashcard>> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(savedData) as List<dynamic>;
    return decoded
        .map((item) => Flashcard.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      flashcards.map((flashcard) => flashcard.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }
}
