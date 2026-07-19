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
  String _searchQuery = '';
  int? _hoveredIndex;

  void _showFlashcardSheet({Flashcard? flashcard}) {
    final questionController = TextEditingController(
      text: flashcard?.question ?? '',
    );
    final answerController = TextEditingController(
      text: flashcard?.answer ?? '',
    );
    bool fav = flashcard?.favorite ?? false;

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
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flashcard == null ? 'Add Flashcard' : 'Edit Flashcard',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.title,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Build your study deck with clean, quick notes.',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.subtitle,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Checkbox(
                      value: fav,
                      onChanged: (v) => setState(() => fav = v ?? false),
                    ),
                    const SizedBox(width: 8),
                    const Text('Favorite'),
                  ],
                ),
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
                            favorite: fav,
                          ),
                        );
                      } else {
                        widget.onEdit(
                          flashcard.copyWith(
                            question: question,
                            answer: answer,
                            favorite: fav,
                          ),
                        );
                      }

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Save Flashcard'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Delete Flashcard?'),
          content: const Text('Are you sure you want to remove this card?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
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

  List<Flashcard> _buildFilteredFlashcards() {
    if (_searchQuery.isEmpty) {
      return widget.flashcards;
    }

    final query = _searchQuery.toLowerCase();
    return widget.flashcards.where((flashcard) {
      return flashcard.question.toLowerCase().contains(query) ||
          flashcard.answer.toLowerCase().contains(query);
    }).toList();
  }

  String _formatUpdatedLabelFromTimestamp(String? iso) {
    if (iso == null) return 'Updated: never';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Updated just now';
      if (diff.inHours < 1) return 'Updated ${diff.inMinutes} minutes ago';
      if (diff.inDays < 1) return 'Updated ${diff.inHours} hours ago';
      if (diff.inDays == 1) return 'Updated Yesterday';
      return 'Updated ${diff.inDays} days ago';
    } catch (e) {
      return 'Updated';
    }
  }

  String _buildCardTag(Flashcard flashcard) {
    final lower = flashcard.question.toLowerCase();
    if (lower.contains('flutter')) {
      return 'Flutter';
    }
    if (lower.contains('stateful')) {
      return 'Widgets';
    }
    if (lower.contains('widget')) {
      return 'Widgets';
    }
    return 'Study';
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Flashcards',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.title,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Create, edit and organize your study deck.',
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.subtitle,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${widget.flashcards.length} Flashcards',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() {
        _searchQuery = value;
      }),
      decoration: InputDecoration(
        hintText: 'Search Flashcards...',
        filled: true,
        fillColor: AppTheme.cardBackground,
        prefixIcon: const Icon(Icons.search, color: AppTheme.subtitle),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.title,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppTheme.subtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardTile(Flashcard flashcard, int index) {
    final hovered = _hoveredIndex == index;
    final tag = _buildCardTag(flashcard);

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredIndex = index;
      }),
      onExit: (_) => setState(() {
        _hoveredIndex = null;
      }),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: hovered ? 1.01 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: hovered
                ? Border.all(
                    color: AppTheme.secondary.withValues(alpha: 77),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.book, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${index + 1} Card',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.subtitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          flashcard.question,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.title,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    label: Text(tag),
                    backgroundColor: AppTheme.secondary.withValues(alpha: 30),
                    labelStyle: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Chip(
                    label: const Text('Beginner'),
                    backgroundColor: AppTheme.primary.withValues(alpha: 30),
                    labelStyle: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                flashcard.question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.title,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                flashcard.answer,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.subtitle,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatUpdatedLabelFromTimestamp(flashcard.updatedAt),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.subtitle,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showFlashcardSheet(flashcard: flashcard),
                    icon: const Icon(Icons.edit, size: 20),
                    color: AppTheme.primary,
                    tooltip: 'Edit',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showDeleteDialog(flashcard),
                    icon: const Icon(Icons.delete, size: 20),
                    color: AppTheme.danger,
                    tooltip: 'Delete',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final toggled = flashcard.copyWith(
                        favorite: !flashcard.favorite,
                      );
                      widget.onEdit(toggled);
                    },
                    icon: Icon(
                      flashcard.favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20,
                      color: flashcard.favorite
                          ? AppTheme.accent
                          : AppTheme.subtitle,
                    ),
                    tooltip: 'Toggle Favorite',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesRow() {
    final favorites = widget.flashcards.where((f) => f.favorite).toList();
    if (favorites.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Favorites',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final f = favorites[index];
              return GestureDetector(
                onTap: () => _showFlashcardSheet(flashcard: f),
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.question,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        f.answer,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppTheme.subtitle),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatUpdatedLabelFromTimestamp(f.updatedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.subtitle,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final toggled = f.copyWith(favorite: !f.favorite);
                              widget.onEdit(toggled);
                            },
                            icon: Icon(
                              f.favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppTheme.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: favorites.length,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories,
              color: AppTheme.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Flashcards Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.title,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start building your study deck.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.subtitle,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          FloatingActionButton.extended(
            onPressed: () => _showFlashcardSheet(),
            icon: const Icon(Icons.add),
            label: const Text('Add Flashcard'),
            backgroundColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFlashcards = _buildFilteredFlashcards();
    final editedCount = widget.flashcards
        .where((flashcard) => flashcard.editCount > 0)
        .length;
    final favoriteCount = widget.flashcards
        .where((flashcard) => flashcard.favorite)
        .length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text('Manage Flashcards'),
        leading: widget.onBack == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 24),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSummaryCard(
                    icon: Icons.auto_stories,
                    title: 'Cards',
                    value: '${widget.flashcards.length}',
                    color: AppTheme.primary,
                  ),
                  _buildSummaryCard(
                    icon: Icons.edit,
                    title: 'Edited',
                    value: '$editedCount',
                    color: AppTheme.secondary,
                  ),
                  _buildSummaryCard(
                    icon: Icons.star,
                    title: 'Favorites',
                    value: '$favoriteCount',
                    color: AppTheme.accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildFavoritesRow(),
            const SizedBox(height: 12),
            Expanded(
              child: filteredFlashcards.isEmpty
                  ? widget.flashcards.isEmpty
                        ? _buildEmptyState()
                        : Center(
                            child: Text(
                              'No cards match your search.',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppTheme.subtitle,
                              ),
                            ),
                          )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredFlashcards.length,
                      itemBuilder: (context, index) {
                        final flashcard = filteredFlashcards[index];
                        return _buildFlashcardTile(flashcard, index);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFlashcardSheet(),
        icon: const Icon(Icons.add),
        label: const Text('Add Flashcard'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }
}
