import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ambience_provider.dart';
import '../../../shared/theme/app_theme.dart';

class AmbienceSearchBar extends ConsumerWidget {
  const AmbienceSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (value) {
        // Updates search query in provider
        // filteredAmbiencesProvider automatically recalculates
        ref.read(searchQueryProvider.notifier).updateQuery(value);
      },
      style: AppTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Search ambiences...',
        hintStyle: AppTheme.bodyMedium,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppTheme.textSecondary,
        ),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingMD,
        ),
      ),
    );
  }
}