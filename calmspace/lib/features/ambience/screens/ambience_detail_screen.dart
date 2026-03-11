import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_theme.dart';
import '../../player/screens/session_player_screen.dart';

class AmbienceDetailScreen extends ConsumerWidget {
  final Ambience ambience;

  const AmbienceDetailScreen({
    super.key,
    required this.ambience,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ── Hero Image App Bar ───────────────────────────
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: AppTheme.background,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Hero Image
                    Image.asset(
                      ambience.imagePath,
                      fit: BoxFit.cover,
                      cacheWidth: 800,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          color: AppTheme.surface,
                          child: const Icon(
                            Icons.landscape_outlined,
                            color: AppTheme.textSecondary,
                            size: 60,
                          ),
                        );
                      },
                    ),
                    // Bottom gradient for smooth transition
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            AppTheme.background,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            // ── Content ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Tag + Duration Row ───────────────────
                    Row(
                      children: [
                        // Tag chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMD,
                            vertical: AppTheme.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.getTagColor(ambience.tag)
                                .withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSM),
                            border: Border.all(
                              color: AppTheme.getTagColor(ambience.tag)
                                  .withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            ambience.tag,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.getTagColor(ambience.tag),
                            ),
                          ),
                        ),
      
                        const SizedBox(width: AppTheme.spacingSM),
      
                        // Duration
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ambience.durationSeconds ~/ 60} min',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
      
                    const SizedBox(height: AppTheme.spacingMD),
      
                    // ── Title ────────────────────────────────
                    Text(
                      ambience.title,
                      style: AppTheme.headingLarge,
                    ),
      
                    const SizedBox(height: AppTheme.spacingMD),
      
                    // ── Description ──────────────────────────
                    Text(
                      ambience.description,
                      style: AppTheme.bodyLarge.copyWith(
                        height: 1.6,
                        color: AppTheme.textSecondary,
                      ),
                    ),
      
                    const SizedBox(height: AppTheme.spacingLG),
      
                    // ── Sensory Recipe ───────────────────────
                    Text(
                      'Sensory Recipe',
                      style: AppTheme.headingSmall,
                    ),
      
                    const SizedBox(height: AppTheme.spacingMD),
      
                    // Sensory chips
                    Wrap(
                      spacing: AppTheme.spacingSM,
                      runSpacing: AppTheme.spacingSM,
                      children: ambience.sensoryChips.map((chip) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMD,
                            vertical: AppTheme.spacingSM,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusXL),
                            border: Border.all(
                              color: AppTheme.divider,
                            ),
                          ),
                          child: Text(
                            chip,
                            style: AppTheme.labelMedium,
                          ),
                        );
                      }).toList(),
                    ),
      
                    const SizedBox(height: AppTheme.spacingXL),
      
                    // ── Start Session Button ─────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // We'll wire this to session player later
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SessionPlayerScreen(ambience: ambience),
                              ),
                            );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusLG),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Start Session',
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
          ],
        ),
      ),
    );
  }
}
