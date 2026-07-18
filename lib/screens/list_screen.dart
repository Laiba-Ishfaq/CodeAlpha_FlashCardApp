import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/flashcard.dart';
import '../theme/app_theme.dart';

class ListScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  final Function(Flashcard) onAdd;
  final Function(Flashcard) onEdit;
  final Function(String id) onDelete;
  final VoidCallback? onBack;

  const ListScreen({
    super.key,
    required this.flashcards,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.onBack,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _uuid = const Uuid();

  void _showFlashcardSheet({Flashcard? flashcard}) {
    final questionController = TextEditingController(
      text: flashcard?.question ?? '',
    );
    final answerController = TextEditingController(
      text: flashcard?.answer ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flashcard == null ? 'Add Flashcard' : 'Edit Flashcard',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'Answer',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      final question = questionController.text.trim();
                      final answer = answerController.text.trim();

                      if (question.isEmpty || answer.isEmpty) {
                        return;
                      }

                      if (flashcard == null) {
                        widget.onAdd(
                          Flashcard(
                            id: _uuid.v4(),
                            question: question,
                            answer: answer,
                          ),
                        );
                      } else {
                        widget.onEdit(
                          flashcard.copyWith(
                            question: question,
                            answer: answer,
                          ),
                        );
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteDialog(Flashcard flashcard) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete this flashcard?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      widget.onDelete(flashcard.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Flashcards'),
        leading: widget.onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
      ),
      body: widget.flashcards.isEmpty
          ? const Center(
              child: Text(
                'No flashcards yet. Tap + to add one.',
                style: TextStyle(fontSize: 16, color: AppTheme.textDark),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = widget.flashcards[index];
                return Card(
                  color: AppTheme.cardBackground,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      flashcard.question,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      flashcard.answer,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: AppTheme.primary,
                          onPressed: () =>
                              _showFlashcardSheet(flashcard: flashcard),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: AppTheme.danger,
                          onPressed: () => _showDeleteDialog(flashcard),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _showFlashcardSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
