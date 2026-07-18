import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/flashcard.dart';
import '../theme/app_theme.dart';

class StudyScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  final VoidCallback onManage;

  const StudyScreen({
    super.key,
    required this.flashcards,
    required this.onManage,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int currentIndex = 0;
  bool isAnswerVisible = false;
  @override
  void didUpdateWidget(covariant StudyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashcards.length != oldWidget.flashcards.length) {
      setState(() {
        currentIndex = 0;
        isAnswerVisible = false;
      });
    }
  }

  void _showPreviousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isAnswerVisible = false;
      });
    }
  }

  void _showNextCard() {
    if (currentIndex < widget.flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerVisible = false;
      });
    }
  }

  void _toggleAnswer() {
    setState(() {
      isAnswerVisible = !isAnswerVisible;
    });
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: const Text('Customize your study look'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                subtitle: const Text('App details and version'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = widget.flashcards;

    if (flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No flashcards yet. Tap manage to add one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: AppTheme.textDark),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: widget.onManage,
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentCard = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        title: const Text('📚 Flashcards'),
        actions: [
          TextButton.icon(
            onPressed: widget.onManage,
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Edit', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: widget.onManage,
        tooltip: 'Add flashcard',
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final selectedWidth = maxWidth < 600 ? maxWidth * 0.92 : 560.0;
          final cardHeight = selectedWidth * 0.72;
          final progress = (currentIndex + 1) / flashcards.length;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter Basics',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.auto_stories, color: Color(0xFF4A55A2)),
                    const SizedBox(width: 10),
                    Text(
                      '${flashcards.length} Cards',
                      style: TextStyle(
                        color: AppTheme.textDark.withAlpha(204),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${currentIndex + 1} / ${flashcards.length} Reviewed',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: selectedWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: AppTheme.background,
                          valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${(progress * 100).round()}% completed',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: SizedBox(
                    width: selectedWidth,
                    height: cardHeight,
                    child: GestureDetector(
                      onTap: _toggleAnswer,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: isAnswerVisible ? math.pi : 0,
                        ),
                        duration: const Duration(milliseconds: 450),
                        builder: (context, angle, child) {
                          final isFront = angle <= math.pi / 2;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF4A55A2),
                                    Color(0xFF3A43A0),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.16),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(24),
                              child: isFront
                                  ? _buildCardFace(
                                      title: currentCard.question,
                                      subtitle: 'Question',
                                      textColor: Colors.white,
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(math.pi),
                                      child: _buildCardFace(
                                        title: currentCard.answer,
                                        subtitle: 'Answer',
                                        textColor: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                    ),
                    onPressed: _toggleAnswer,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: Text(
                      isAnswerVisible ? 'Hide Answer' : 'Reveal Answer',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textDark,
                          backgroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: currentIndex == 0 ? null : _showPreviousCard,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textDark,
                          backgroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: currentIndex >= flashcards.length - 1
                            ? null
                            : _showNextCard,
                        icon: const Text('Next'),
                        label: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Card ${currentIndex + 1} of ${flashcards.length}',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardFace({
    required String title,
    String? subtitle,
    required Color textColor,
  }) {
    final artwork = subtitle == 'Answer' ? '💡' : '❓';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          artwork,
          style: TextStyle(
            color: textColor.withValues(alpha: 235),
            fontSize: 42,
            height: 1,
          ),
        ),
        const SizedBox(height: 14),
        if (subtitle != null) ...[
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
