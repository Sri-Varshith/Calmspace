import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/ambience.dart';
import 'audio_service.dart';

class SessionState {
  final Ambience? currentAmbience;
  final bool isPlaying;
  final bool isSessionActive;
  final int elapsedSeconds;
  final bool isCompleted;

  const SessionState({
    this.currentAmbience,
    this.isPlaying = false,
    this.isSessionActive = false,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
  });

  SessionState copyWith({
    Ambience? currentAmbience,
    bool? isPlaying,
    bool? isSessionActive,
    int? elapsedSeconds,
    bool? isCompleted,
  }) {
    return SessionState(
      currentAmbience: currentAmbience ?? this.currentAmbience,
      isPlaying: isPlaying ?? this.isPlaying,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  Timer? _timer;

  @override
  SessionState build() => const SessionState();

  // Just sets state - audio handled in screen
void startSession(Ambience ambience) {
  _timer?.cancel();
  state = SessionState(
    currentAmbience: ambience,
    isPlaying: true,
    isSessionActive: true,
    elapsedSeconds: 0,
  );
  _startTimer(); // ← add this
}

  // Called from screen AFTER audio is ready
  void beginTimer() {
    _timer?.cancel();
    _startTimer();
  }

void _startTimer() {
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (!state.isPlaying) return;
    final newElapsed = state.elapsedSeconds + 1;
    final duration = state.currentAmbience?.durationSeconds ?? 0;
    if (newElapsed >= duration) {
      timer.cancel();
      AudioService.instance.stop();
      state = state.copyWith(
        isCompleted: true,
        isPlaying: false,
        isSessionActive: false,
      );
      return;
    }
    state = state.copyWith(elapsedSeconds: newElapsed);
  });
}

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    _startTimer();
  }

void updateElapsed(int seconds) {
  state = state.copyWith(elapsedSeconds: seconds);
  // Make sure timer is running
  if (_timer == null || !(_timer?.isActive ?? false)) {
    _startTimer();
  }
}

  void endSession() {
    _timer?.cancel();
    state = const SessionState();
  }

  void clearCompleted() {
    state = const SessionState();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);