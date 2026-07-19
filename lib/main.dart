import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/flashcard.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/study_screen.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeAlpha Flashcards',
      theme: AppTheme.lightTheme,
      home: const HomeController(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  final StorageService _storageService = StorageService();

  List<Flashcard> flashcards = [];
  bool isLoading = true;
  bool showingList = false;
  bool showingStudy = false;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _markSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_intro', true);
  }

  Future<void> _loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    final seenIntro = prefs.getBool('has_seen_intro') ?? false;
    final loadedFlashcards = await _storageService.loadFlashcards();
    if (!mounted) return;

    setState(() {
      flashcards = loadedFlashcards.isEmpty
          ? [
              Flashcard(
                id: 'sample-1',
                question: 'What is Flutter?',
                answer:
                    'Flutter is a UI toolkit for building natively compiled apps from a single codebase.',
                favorite: true,
                editCount: 0,
                updatedAt: DateTime.now().toIso8601String(),
              ),
              Flashcard(
                id: 'sample-2',
                question: 'What does StatefulWidget do?',
                answer:
                    'It lets a widget hold mutable state that can change over time.',
                favorite: false,
                editCount: 0,
                updatedAt: DateTime.now().toIso8601String(),
              ),
              Flashcard(
                id: 'sample-3',
                question: 'What is a Widget in Flutter?',
                answer:
                    'A widget is the basic building block of a Flutter user interface.',
                favorite: false,
                editCount: 0,
                updatedAt: DateTime.now().toIso8601String(),
              ),
            ]
          : loadedFlashcards;
      isLoading = false;
      if (seenIntro) {
        showingStudy = true;
      }
    });
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final now = DateTime.now().toIso8601String();
    final prepared = flashcard.copyWith(
      favorite: flashcard.favorite,
      editCount: 0,
      updatedAt: now,
    );
    final updated = [...flashcards, prepared];
    setState(() {
      flashcards = updated;
    });
    await _storageService.saveFlashcards(flashcards);
  }

  Future<void> editFlashcard(Flashcard updatedFlashcard) async {
    final now = DateTime.now().toIso8601String();
    final updated = flashcards.map((flashcard) {
      if (flashcard.id == updatedFlashcard.id) {
        final questionChanged = flashcard.question != updatedFlashcard.question;
        final answerChanged = flashcard.answer != updatedFlashcard.answer;
        final shouldIncrement = questionChanged || answerChanged;

        return updatedFlashcard.copyWith(
          editCount: shouldIncrement
              ? flashcard.editCount + 1
              : flashcard.editCount,
          updatedAt: shouldIncrement ? now : flashcard.updatedAt,
          favorite: updatedFlashcard.favorite,
        );
      }
      return flashcard;
    }).toList();

    setState(() {
      flashcards = updated;
    });
    await _storageService.saveFlashcards(flashcards);
  }

  Future<void> deleteFlashcard(String id) async {
    final updated = flashcards
        .where((flashcard) => flashcard.id != id)
        .toList();

    setState(() {
      flashcards = updated;
    });
    await _storageService.saveFlashcards(flashcards);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (showingList) {
      return ListScreen(
        flashcards: flashcards,
        onAdd: addFlashcard,
        onEdit: editFlashcard,
        onDelete: deleteFlashcard,
        onBack: () {
          setState(() {
            showingList = false;
          });
        },
      );
    }

    if (showingStudy) {
      return StudyScreen(
        flashcards: flashcards,
        onManage: () {
          setState(() {
            showingList = true;
          });
        },
      );
    }

    return HomeScreen(
      onStudyExisting: () {
        _markSeenIntro();
        setState(() {
          showingStudy = true;
        });
      },
      onAddNew: () {
        _markSeenIntro();
        setState(() {
          showingList = true;
        });
      },
    );
  }
}
