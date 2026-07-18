import 'package:flutter/material.dart';

import 'models/flashcard.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
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
              ),
              Flashcard(
                id: 'sample-2',
                question: 'What does StatefulWidget do?',
                answer:
                    'It lets a widget hold mutable state that can change over time.',
              ),
              Flashcard(
                id: 'sample-3',
                question: 'What is a Widget in Flutter?',
                answer:
                    'A widget is the basic building block of a Flutter user interface.',
              ),
            ]
          : loadedFlashcards;
      isLoading = false;
    });
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    final updated = [...flashcards, flashcard];
    setState(() {
      flashcards = updated;
    });
    await _storageService.saveFlashcards(flashcards);
  }

  Future<void> editFlashcard(Flashcard updatedFlashcard) async {
    final updated = flashcards.map((flashcard) {
      if (flashcard.id == updatedFlashcard.id) {
        return updatedFlashcard;
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

    return StudyScreen(
      flashcards: flashcards,
      onManage: () {
        setState(() {
          showingList = true;
        });
      },
    );
  }
}
