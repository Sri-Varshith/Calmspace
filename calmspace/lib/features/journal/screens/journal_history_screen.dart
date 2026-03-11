import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../journal_provider.dart';
import '../../../data/models/journal_entry.dart';

class JournalHistoryScreen extends ConsumerWidget {
  const JournalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalState = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Journal', style: AppTheme.headingSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: journalState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            )
          : journalState.entries.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(AppTheme.spacingMD),
                  itemCount: journalState.entries.length,
                  itemBuilder: (context, index) {
                    return _JournalEntryCard(
                      entry: journalState.entries[index],
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.book_outlined,
            color: AppTheme.textSecondary,
            size: 48,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            'No reflections yet',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            'Start a session to begin',
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  const _JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => _JournalDetailScreen(entry: entry),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMD),
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Ambience title
                Text(
                  entry.ambienceTitle,
                  style: AppTheme.labelMedium,
                ),
                // Mood chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSM,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  ),
                  child: Text(
                    entry.mood,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingSM),

            // ── Journal Preview ───────────────────────────
            Text(
              entry.journalText,
              style: AppTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppTheme.spacingSM),

            // ── Date ─────────────────────────────────────
            Text(
              _formatDate(entry.createdAt),
              style: AppTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// ── Journal Detail Screen ──────────────────────────────────────────
class _JournalDetailScreen extends StatelessWidget {
  final JournalEntry entry;

  const _JournalDetailScreen({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.ambienceTitle, style: AppTheme.headingSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date ─────────────────────────────────────
            Text(
              _formatDate(entry.createdAt),
              style: AppTheme.bodySmall,
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // ── Mood ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
                vertical: AppTheme.spacingSM,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Text(
                entry.mood,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingLG),

            // ── Prompt ────────────────────────────────────
            Text(
              'What is gently present with you right now?',
              style: AppTheme.bodyMedium,
            ),

            const SizedBox(height: AppTheme.spacingMD),

            // ── Full Journal Text ─────────────────────────
            Text(
              entry.journalText,
              style: AppTheme.bodyLarge.copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
