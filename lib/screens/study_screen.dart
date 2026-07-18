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
  bool _isAnimating = false;

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
    if (currentIndex > 0 && !_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        setState(() {
          currentIndex--;
          isAnswerVisible = false;
          _isAnimating = false;
        });
      });
    }
  }

  void _showNextCard() {
    if (currentIndex < widget.flashcards.length - 1 && !_isAnimating) {
      setState(() {
        _isAnimating = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        setState(() {
          currentIndex++;
          isAnswerVisible = false;
          _isAnimating = false;
        });
      });
    }
  }

  void _toggleAnswer() {
    if (_isAnimating) return;
    setState(() {
      _isAnimating = true;
    });
    Future.delayed(const Duration(milliseconds: 180), () {
      if (!mounted) return;
      setState(() {
        isAnswerVisible = !isAnswerVisible;
        _isAnimating = false;
      });
    });
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
        title: const Text('Flashcards'),
        actions: [
          TextButton(
            onPressed: widget.onManage,
            child: const Text(
              'Customize',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(icon: const Icon(Icons.list), onPressed: widget.onManage),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  key: ValueKey('${currentCard.id}-$isAnswerVisible'),
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _toggleAnswer,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: isAnswerVisible ? 180 : 0,
                      ),
                      duration: const Duration(milliseconds: 400),
                      builder: (context, value, child) {
                        final isFront = value < 90;
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(value * 3.1415926535 / 180),
                          child: Card(
                            color: AppTheme.cardBackground,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: Center(
                                  child: isFront
                                      ? Text(
                                          currentCard.question,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textDark,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Answer',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textMuted,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              currentCard.answer,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: AppTheme.textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
                onPressed: _toggleAnswer,
                child: Text(isAnswerVisible ? 'Hide Answer' : 'Show Answer'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex == 0 ? null : _showPreviousCard,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: currentIndex >= flashcards.length - 1
                        ? null
                        : _showNextCard,
                    child: const Text('Next'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Card ${currentIndex + 1} of ${flashcards.length}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
