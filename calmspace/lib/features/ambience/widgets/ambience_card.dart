import 'package:flutter/material.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_theme.dart';
import '../screens/ambience_detail_screen.dart';

class AmbienceCard extends StatelessWidget {
  final Ambience ambience;

  const AmbienceCard({
    super.key,
    required this.ambience,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AmbienceDetailScreen(ambience: ambience),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          color: AppTheme.cardBackground,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail Image ──────────────────────────────
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Ambience image
                  Image.asset(
                    ambience.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppTheme.surface,
                        child: const Icon(
                          Icons.landscape_outlined,
                          color: AppTheme.textSecondary,
                          size: 40,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay so text is readable
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tag chip on top of image
                  Positioned(
                    top: AppTheme.spacingSM,
                    left: AppTheme.spacingSM,
                    child: _TagChip(tag: ambience.tag),
                  ),
                ],
              ),
            ),

            // ── Card Info ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ambience.title,
                    style: AppTheme.headingSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(ambience.durationSeconds),
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    return '$minutes min';
  }
}

// ── Tag Chip Widget ────────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.getTagColor(tag).withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}