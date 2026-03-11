import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_theme.dart';
import '../audio_service.dart';
import '../player_provider.dart';
import 'package:just_audio/just_audio.dart';
import '../../journal/screens/reflection_screen.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  final Ambience ambience;
  final bool resuming;

  const SessionPlayerScreen({
    super.key,
    required this.ambience,
    this.resuming = false,
  });

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService.instance;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _setupBreathingAnimation();
    Future.microtask(() {
      if (!widget.resuming) {
        _startSession();
      }
    });
  }

  void _setupBreathingAnimation() {
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _breathingAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(
          parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startSession() async {
    ref.read(sessionProvider.notifier).startSession(widget.ambience);
    await _audioService.loadAndPlay(widget.ambience.audioPath);
  }

  Future<void> _showEndSessionDialog() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Text('End Session?', style: AppTheme.headingSmall),
        content: Text(
          'Are you sure you want to end this session early?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
            ),
            child:
                const Text('End', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (shouldEnd == true) _navigateToReflection();
  }

  void _navigateToReflection() {
    if (!mounted) return;
    _audioService.stop();
    ref.read(sessionProvider.notifier).endSession();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReflectionScreen(ambience: widget.ambience),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Single source of truth - provider only
    final session = ref.watch(sessionProvider);
    final totalSeconds = widget.ambience.durationSeconds;
    final progress = totalSeconds > 0
        ? (session.elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    // Auto navigate when session completes
    if (session.isCompleted) {
      Future.microtask(() => _navigateToReflection());
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xAA000000),
                  Color(0xCC000000),
                  Color(0xEE000000),
                ],
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 400 * _breathingAnimation.value + 100,
                      height: 400 * _breathingAnimation.value + 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppTheme.primary.withOpacity(0.05),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                    Container(
                      width: 260 * _breathingAnimation.value + 80,
                      height: 260 * _breathingAnimation.value + 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppTheme.primary.withOpacity(0.1),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          AppTheme.primary.withOpacity(
                              _breathingAnimation.value * 0.8),
                          AppTheme.accent.withOpacity(
                              _breathingAnimation.value * 0.4),
                          Colors.transparent,
                        ]),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(
                                _breathingAnimation.value * 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMD),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.spacingSM),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusMD),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.ambience.tag,
                        style: TextStyle(
                          color:
                              AppTheme.getTagColor(widget.ambience.tag),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  widget.ambience.title,
                  style: AppTheme.headingLarge
                      .copyWith(color: Colors.white, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(
                  'Session in progress',
                  style:
                      AppTheme.bodyMedium.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLG),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatTime(session.elapsedSeconds),
                              style: AppTheme.bodyMedium
                                  .copyWith(color: Colors.white70)),
                          Text(_formatTime(totalSeconds),
                              style: AppTheme.bodyMedium
                                  .copyWith(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (value) {
                            final seekTo =
                                (value * totalSeconds).round();
                            _audioService
                                .seekTo(Duration(seconds: seekTo));
                            ref
                                .read(sessionProvider.notifier)
                                .updateElapsed(seekTo);
                          },
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLG),
                      StreamBuilder<PlayerState>(
                        stream: _audioService.playerStateStream,
                        builder: (context, snapshot) {
                          final isPlaying =
                              snapshot.data?.playing ?? false;
                          return GestureDetector(
                            onTap: () async {
                              final wasPlaying = _audioService.isPlaying;
                              await _audioService.togglePlayPause();
                              if (wasPlaying) {
                                ref
                                    .read(sessionProvider.notifier)
                                    .pauseTimer();
                              } else {
                                ref
                                    .read(sessionProvider.notifier)
                                    .resumeTimer();
                              }
                              ref
                                  .read(sessionProvider.notifier)
                                  .togglePlayPause();
                            },
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary
                                        .withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: AppTheme.background,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingXL),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _showEndSessionDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.white38, width: 1.5),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppTheme.spacingMD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusLG),
                            ),
                          ),
                          child: Text(
                            'End Session',
                            style: AppTheme.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLG),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}