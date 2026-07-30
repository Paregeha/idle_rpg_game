import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/sim/offline_report.dart';
import 'package:game_core/src/sim/simulator.dart';
import 'package:game_core/src/state/player_state.dart';

/// Credits the time a player spent away and returns a report for the
/// "while you were away" screen.
///
/// [nowMs] is UTC milliseconds and must come from the server. Deriving it from
/// the device would make the whole payout a single settings change away for the
/// player (rule 3).
///
/// Absence is credited up to `config.offlineCapMs`, scaled by [capMultiplier]
/// for VIP. The cap is what keeps an idle game a game: without it, returning
/// after a month would hand over a month of progress and skip the part the
/// player is actually here for.
///
/// Time beyond the cap is **discarded, not banked**. The state's clock is moved
/// all the way to [nowMs] even when the payout was trimmed, so that unclaimed
/// time cannot be collected again by simply calling this a second time.
OfflineReport applyOfflineProgress(
  PlayerState state, {
  required int nowMs,
  required BalanceConfig config,
  double capMultiplier = 1.0,
}) {
  if (capMultiplier < 0) {
    throw ArgumentError.value(
      capMultiplier,
      'capMultiplier',
      'must not be negative',
    );
  }

  final awayMs = nowMs - state.lastTickAtMs;

  // A timestamp before the last tick means a bad clock or a replayed request.
  // Refuse it rather than paying out, and leave the state's clock alone: moving
  // it backwards would hand out the same span twice on the next honest call.
  if (awayMs <= 0) {
    return OfflineReport(
      state: state,
      awayFor: Duration.zero,
      creditedFor: Duration.zero,
      gains: const {},
      wasCapped: false,
    );
  }

  final capMs = (config.offlineCapMs * capMultiplier).floor();
  final creditedMs = awayMs > capMs ? capMs : awayMs;
  final wasCapped = awayMs > capMs;

  final result = simulate(state, Duration(milliseconds: creditedMs), config);

  return OfflineReport(
    state: result.state.copyWith(
      // Catch the clock all the way up, not just to the credited span.
      lastTickAtMs: nowMs,
      // A remainder only makes sense for time that was actually paid. Keeping
      // it after a trim would let repeated short visits leak extra progress.
      carryOverMs: wasCapped ? 0 : result.state.carryOverMs,
    ),
    awayFor: Duration(milliseconds: awayMs),
    creditedFor: Duration(milliseconds: creditedMs),
    gains: Map<String, BigNum>.unmodifiable(result.gains),
    wasCapped: wasCapped,
  );
}
