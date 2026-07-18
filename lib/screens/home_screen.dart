import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStudyExisting;
  final VoidCallback onAddNew;

  const HomeScreen({
    super.key,
    required this.onStudyExisting,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ready to build your flashcards?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Choose whether you want to review already written cards or create new ones first.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onStudyExisting,
                icon: const Text('📘', style: TextStyle(fontSize: 22)),
                label: const Text(
                  'Show prior questions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textDark,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: onAddNew,
                icon: const Text('✏️', style: TextStyle(fontSize: 22)),
                label: const Text(
                  'Add new flashcards',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'If you already have notes or sample questions, choose the first option to start reviewing them immediately.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
