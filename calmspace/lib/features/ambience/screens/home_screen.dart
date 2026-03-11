import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ambience_provider.dart';
import '../widgets/ambience_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/tag_filter_chips.dart';
import '../../../shared/theme/app_theme.dart';
import '../../player/widgets/mini_player.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredAmbiencesProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingMD,
                    AppTheme.spacingLG,
                    AppTheme.spacingMD,
                    AppTheme.spacingMD,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CalmSpace', style: AppTheme.headingLarge),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text('Choose your ambience',
                          style: AppTheme.bodyMedium),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMD),
                  child: const AmbienceSearchBar(),
                ),
                const SizedBox(height: AppTheme.spacingMD),
                Padding(
                  padding:
                      const EdgeInsets.only(left: AppTheme.spacingMD),
                  child: const TagFilterChips(),
                ),
                const SizedBox(height: AppTheme.spacingMD),
                Expanded(
                  child: filteredAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Something went wrong',
                          style: AppTheme.bodyMedium),
                    ),
                    data: (ambiences) {
                      if (ambiences.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off_rounded,
                                  color: AppTheme.textSecondary, size: 48),
                              const SizedBox(height: AppTheme.spacingMD),
                              Text('No ambiences found',
                                  style: AppTheme.headingSmall),
                              const SizedBox(height: AppTheme.spacingSM),
                              Text('Try a different search or filter',
                                  style: AppTheme.bodyMedium),
                              const SizedBox(height: AppTheme.spacingLG),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .clearQuery();
                                  ref
                                      .read(selectedTagProvider.notifier)
                                      .clearTag();
                                },
                                child: const Text('Clear Filters',
                                    style: TextStyle(
                                        color: AppTheme.primary)),
                              ),
                            ],
                          ),
                        );
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.only(
                          left: AppTheme.spacingMD,
                          right: AppTheme.spacingMD,
                          bottom: 100,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppTheme.spacingMD,
                          mainAxisSpacing: AppTheme.spacingMD,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: ambiences.length,
                        itemBuilder: (context, index) {
                          return AmbienceCard(ambience: ambiences[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
