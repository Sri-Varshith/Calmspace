import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_theme.dart';
import '../player_provider.dart';
import '../audio_service.dart';
import '../screens/session_player_screen.dart';
import 'package:just_audio/just_audio.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    // Don't show if no active session
    if (!session.isSessionActive || session.currentAmbience == null) {
      return const SizedBox.shrink();
    }

    final ambience = session.currentAmbience!;
    final totalSeconds = ambience.durationSeconds;
    final progress = totalSeconds > 0
        ? (session.elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SessionPlayerScreen(ambience: ambience,resuming: true,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingSM,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
          border: Border.all(color: AppTheme.divider),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Main Row ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMD,
                vertical: AppTheme.spacingMD,
              ),
              child: Row(
                children: [
                  // Ambience thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    child: Image.asset(
                      ambience.imagePath,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      cacheWidth: 100,
                      errorBuilder: (context, error, stack) => Container(
                        width: 44,
                        height: 44,
                        color: AppTheme.cardBackground,
                        child: const Icon(
                          Icons.landscape_outlined,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: AppTheme.spacingMD),

                  // Title + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ambience.title,
                          style: AppTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Session active',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Play/Pause button
                  StreamBuilder<PlayerState>(
                    stream: AudioService.instance.playerStateStream,
                    builder: (context, snapshot) {
                      final isPlaying = snapshot.data?.playing ?? false;
                      return GestureDetector(
                        onTap: () async {
                          final wasPlaying = AudioService.instance.isPlaying;
                          await AudioService.instance.togglePlayPause();
                          ref.read(sessionProvider.notifier).togglePlayPause();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary.withOpacity(0.15),
                          ),
                          child: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: AppTheme.primary,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Thin Progress Bar ────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.radiusLG),
                bottomRight: Radius.circular(AppTheme.radiusLG),
              ),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.divider,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}