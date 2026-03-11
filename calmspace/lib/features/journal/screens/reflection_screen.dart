import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_theme.dart';
import '../journal_provider.dart';
import 'journal_history_screen.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const ReflectionScreen({
    super.key,
    required this.ambience,
  });

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  final TextEditingController _journalController = TextEditingController();
  String? _selectedMood;
  bool _isSaving = false;

  static const List<Map<String, dynamic>> _moods = [
    {'label': 'Calm', 'emoji': '😌'},
    {'label': 'Grounded', 'emoji': '🌿'},
    {'label': 'Energized', 'emoji': '⚡'},
    {'label': 'Sleepy', 'emoji': '🌙'},
  ];

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  Future<void> _saveReflection() async {
    // Validate inputs
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a mood',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
        ),
      );
      return;
    }

    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please write something before saving',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    // Create journal entry
    final entry = JournalEntry(
      id: const Uuid().v4(),
      ambienceId: widget.ambience.id,
      ambienceTitle: widget.ambience.title,
      mood: _selectedMood!,
      journalText: _journalController.text.trim(),
      createdAt: DateTime.now(),
    );

    // Save via provider
    await ref.read(journalProvider.notifier).saveEntry(entry);

    setState(() => _isSaving = false);

    if (!mounted) return;

    // Navigate to journal history
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const JournalHistoryScreen(),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────
              const SizedBox(height: AppTheme.spacingLG),

              Text(
                'Reflect',
                style: AppTheme.headingLarge,
              ),

              const SizedBox(height: AppTheme.spacingXS),

              Text(
                widget.ambience.title,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXL),

              // ── Journal Prompt ───────────────────────────
              Text(
                'What is gently present\nwith you right now?',
                style: AppTheme.headingMedium.copyWith(
                  height: 1.4,
                ),
              ),

              const SizedBox(height: AppTheme.spacingLG),

              // ── Text Input ───────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: TextField(
                  controller: _journalController,
                  maxLines: 8,
                  style: AppTheme.bodyLarge.copyWith(height: 1.6),
                  decoration: InputDecoration(
                    hintText: 'Write freely...',
                    hintStyle: AppTheme.bodyMedium,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppTheme.spacingMD),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingLG),

              // ── Mood Selector ────────────────────────────
              Text(
                'How do you feel?',
                style: AppTheme.headingSmall,
              ),

              const SizedBox(height: AppTheme.spacingMD),

              Row(
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood['label'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood['label'] as String;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: AppTheme.spacingXS),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMD,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primary.withOpacity(0.15)
                              : AppTheme.surface,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMD),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.divider,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              mood['emoji'] as String,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            Text(
                              mood['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppTheme.spacingXL),

              // ── Save Button ──────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveReflection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingMD,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Reflection',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingLG),
            ],
          ),
        ),
      ),
    );
  }
}