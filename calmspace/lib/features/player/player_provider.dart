import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ambience.dart';

// ─── Session State ─────────────────────────────────────────────────
// This class holds ALL session related data in one place
class SessionState {
  final Ambience? currentAmbience;
  final bool isPlaying;
  final bool isSessionActive;
  final int elapsedSeconds;

  const SessionState({
    this.currentAmbience,
    this.isPlaying = false,
    this.isSessionActive = false,
    this.elapsedSeconds = 0,
  });

  // copyWith lets us update ONE field without touching others
  SessionState copyWith({
    Ambience? currentAmbience,
    bool? isPlaying,
    bool? isSessionActive,
    int? elapsedSeconds,
  }) {
    return SessionState(
      currentAmbience: currentAmbience ?? this.currentAmbience,
      isPlaying: isPlaying ?? this.isPlaying,
      isSessionActive: isSessionActive ?? this.isSessionActive,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}

// ─── Session Notifier ──────────────────────────────────────────────
class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  void startSession(Ambience ambience) {
    state = SessionState(
      currentAmbience: ambience,
      isPlaying: true,
      isSessionActive: true,
      elapsedSeconds: 0,
    );
  }

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void updateElapsed(int seconds) {
    state = state.copyWith(elapsedSeconds: seconds);
  }

  void endSession() {
    state = const SessionState();
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);