import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// How often the local view of the state is advanced.
///
/// 30 Hz is smooth enough for counters and cheap enough to run continuously.
/// It is a *display* rate, not a simulation rate: `simulate` pays progress in
/// whole seconds and carries the remainder, so ticking faster or slower cannot
/// change how much the player earns (ADR-007).
const Duration tickInterval = Duration(milliseconds: 33);

/// Owns the player's state while the app is in the foreground.
///
/// The client simulates locally only so the numbers move smoothly. The server
/// remains the authority and will overwrite this on every sync (ADR-001) — no
/// gameplay decision may be made from this state alone.
class GameController extends Notifier<PlayerState?> {
  Timer? _ticker;
  int _lastTickMs = 0;

  @override
  PlayerState? build() {
    // Riverpod disposes the notifier when nothing listens; a timer left running
    // would keep a dead state advancing and hold the object alive.
    ref.onDispose(stopTicking);
    return null;
  }

  BalanceConfig? get _config => ref.read(balanceConfigProvider).value;

  Clock get _clock => ref.read(clockProvider);

  /// Starts a fresh game, or resumes an existing state after an absence.
  void load({PlayerState? saved}) {
    final config = _config;
    if (config == null) return;

    final nowMs = _clock.nowMs;

    if (saved == null) {
      state = newGame(nowMs: nowMs, rngSeed: nowMs, config: config);
    } else {
      state = applyOfflineProgress(saved, nowMs: nowMs, config: config).state;
    }

    _lastTickMs = nowMs;
  }

  void startTicking() {
    if (_ticker != null) return;
    _lastTickMs = _clock.nowMs;
    _ticker = Timer.periodic(tickInterval, (_) => tick());
  }

  void stopTicking() {
    _ticker?.cancel();
    _ticker = null;
  }

  bool get isTicking => _ticker != null;

  /// Advances by however long actually passed, not by the nominal interval.
  ///
  /// A dropped frame or a busy main thread makes a timer fire late; crediting a
  /// flat 33 ms per tick would quietly lose that time, and the client would
  /// drift behind the server over a session.
  void tick() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return;

    final nowMs = _clock.nowMs;
    final elapsed = nowMs - _lastTickMs;
    if (elapsed <= 0) return;

    _lastTickMs = nowMs;
    state = simulate(current, Duration(milliseconds: elapsed), config).state;
  }

  /// Called when the app goes to the background.
  ///
  /// Stopping the timer is the whole battery story: a 30 Hz timer that keeps
  /// running behind a locked screen burns power for a screen nobody is looking
  /// at, and earns the player nothing that the offline calculation would not
  /// give them anyway.
  void onPaused() => stopTicking();

  /// Called when the app comes back.
  ///
  /// Credits the gap through the offline path rather than by ticking, so the
  /// cap applies. Ticking through hours of absence would both take a while and
  /// hand out uncapped progress.
  OfflineReport? onResumed() {
    final current = state;
    final config = _config;
    if (current == null || config == null) return null;

    final report = applyOfflineProgress(
      current,
      nowMs: _clock.nowMs,
      config: config,
    );

    state = report.state;
    _lastTickMs = _clock.nowMs;
    startTicking();
    return report;
  }
}

final gameControllerProvider = NotifierProvider<GameController, PlayerState?>(
  GameController.new,
);

/// A single resource, so a counter rebuilds only when its own number changes.
///
/// Watching the whole state from the resource bar would rebuild it 30 times a
/// second even when nothing it displays has moved.
final resourceProvider = Provider.family<BigNum, String>((ref, key) {
  final state = ref.watch(gameControllerProvider);
  return state?.resources[key] ?? BigNum.zero;
});
