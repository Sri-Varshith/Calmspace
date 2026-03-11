import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience.dart';
import '../../../shared/theme/app_theme.dart';
import '../audio_service.dart';
import '../player_provider.dart';
import 'package:just_audio/just_audio.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const SessionPlayerScreen({
    super.key,
    required this.ambience,
  });

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService.instance;

  // Animation controller for breathing effect
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  // Session timer
  int _elapsedSeconds = 0;
  bool _sessionEnded = false;

  @override
  void initState() {
    super.initState();
    _setupBreathingAnimation();
    _startSession();
  }

  void _setupBreathingAnimation() {
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startSession() async {
    // Start audio
    await _audioService.loadAndPlay(widget.ambience.audioPath);

    // Update session provider
    ref.read(sessionProvider.notifier).startSession(widget.ambience);

    // Start timer using position stream
    _audioService.positionStream.listen((position) {
      if (!mounted || _sessionEnded) return;

      final elapsed = position.inSeconds % widget.ambience.durationSeconds;
      final totalElapsed = _elapsedSeconds;

      if (totalElapsed >= widget.ambience.durationSeconds) {
        _onSessionComplete();
        return;
      }

      setState(() {
        _elapsedSeconds = position.inSeconds
            .clamp(0, widget.ambience.durationSeconds);
      });

      ref.read(sessionProvider.notifier).updateElapsed(_elapsedSeconds);
    });
  }

  void _onSessionComplete() {
    if (_sessionEnded) return;
    _sessionEnded = true;
    _audioService.stop();
    _navigateToReflection();
  }

  Future<void> _showEndSessionDialog() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        ),
        title: Text(
          'End Session?',
          style: AppTheme.headingSmall,
        ),
        content: Text(
          'Are you sure you want to end this session early?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
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
            child: const Text(
              'End',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldEnd == true) {
      _sessionEnded = true;
      await _audioService.stop();
      _navigateToReflection();
    }
  }

  void _navigateToReflection() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'Reflection Screen Coming Soon',
              style: AppTheme.bodyLarge,
            ),
          ),
        ),
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
    final session = ref.watch(sessionProvider);
    final totalSeconds = widget.ambience.durationSeconds;
    final progress = totalSeconds > 0
        ? (_elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Image ───────────────────────────
          Image.asset(
            widget.ambience.imagePath,
            fit: BoxFit.cover,
            cacheWidth: 800,
            errorBuilder: (context, error, stack) =>
                Container(color: AppTheme.background),
          ),

          // ── Dark Overlay ───────────────────────────────
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

          // ── Breathing Animation ────────────────────────
              Center(
                child: AnimatedBuilder(
                  animation: _breathingAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer ring
                        Container(
                          width: 280 * _breathingAnimation.value + 100,
                          height: 280 * _breathingAnimation.value + 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.primary.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Middle ring
                        Container(
                          width: 180 * _breathingAnimation.value + 80,
                          height: 180 * _breathingAnimation.value + 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.primary.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Inner glowing core
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.primary
                                    .withOpacity(_breathingAnimation.value * 0.8),
                                AppTheme.accent
                                    .withOpacity(_breathingAnimation.value * 0.4),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary
                                    .withOpacity(_breathingAnimation.value * 0.5),
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

          // ── Main Content ───────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // ── Top Bar ───────────────────────────────
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
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.ambience.tag,
                        style: TextStyle(
                          color: AppTheme.getTagColor(widget.ambience.tag),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Ambience Title ────────────────────────
                Text(
                  widget.ambience.title,
                  style: AppTheme.headingLarge.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppTheme.spacingSM),

                Text(
                  'Session in progress',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),

                const Spacer(),

                // ── Player Controls ───────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLG,
                  ),
                  child: Column(
                    children: [
                      // Time indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_elapsedSeconds),
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            _formatTime(totalSeconds),
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spacingXS),

                      // Seek bar
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.primary,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: progress,
                          onChanged: (value) {
                            final seekTo =
                                (value * totalSeconds).round();
                            _audioService.seekTo(
                              Duration(seconds: seekTo),
                            );
                            setState(() {
                              _elapsedSeconds = seekTo;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: AppTheme.spacingLG),

                      // Play/Pause button
                      // Play/Pause button
                      StreamBuilder<PlayerState>(
                        stream: _audioService.playerStateStream,
                        builder: (context, snapshot) {
                          final isPlaying = snapshot.data?.playing ?? false;
                          return GestureDetector(
                            onTap: () async {
                              await _audioService.togglePlayPause();
                              ref.read(sessionProvider.notifier).togglePlayPause();
                            },
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.4),
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

                      // End Session button
                      TextButton(
                        onPressed: _showEndSessionDialog,
                        child: Text(
                          'End Session',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white54,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white54,
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