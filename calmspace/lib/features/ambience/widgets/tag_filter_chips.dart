import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ambience_provider.dart';
import '../../../shared/theme/app_theme.dart';

class TagFilterChips extends ConsumerWidget {
  const TagFilterChips({super.key});

  static const List<String> tags = ['Focus', 'Calm', 'Sleep', 'Reset'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTag = ref.watch(selectedTagProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags.map((tag) {
          final isSelected = selectedTag == tag;
          final tagColor = AppTheme.getTagColor(tag);

          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingSM),
            child: GestureDetector(
              onTap: () {
                ref.read(selectedTagProvider.notifier).selectTag(tag);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMD,
                  vertical: AppTheme.spacingSM,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? tagColor
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                  border: Border.all(
                    color: isSelected
                        ? tagColor
                        : AppTheme.divider,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}