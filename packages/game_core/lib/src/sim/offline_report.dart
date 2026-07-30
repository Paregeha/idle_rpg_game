import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// What the player earned while away, and what they missed.
///
/// [awayFor] and [creditedFor] are deliberately separate: the welcome-back
/// screen should be able to say "you were away 3 days, here is 8 hours of
/// progress" rather than quietly pretending the cap did not apply. Hiding it
/// reads as a bug to a player who can do the arithmetic.
@immutable
class OfflineReport {
  const OfflineReport({
    required this.state,
    required this.awayFor,
    required this.creditedFor,
    required this.gains,
    required this.wasCapped,
  });

  /// The state with the absence applied and the clock caught up.
  final PlayerState state;

  /// How long the player was actually gone.
  final Duration awayFor;

  /// How much of that was paid out, after the cap.
  final Duration creditedFor;

  /// What was earned, per resource.
  final Map<String, BigNum> gains;

  /// Whether the cap trimmed the payout.
  final bool wasCapped;

  /// Time that elapsed but was not credited.
  Duration get forfeited => awayFor - creditedFor;

  /// Whether there is anything worth showing a screen for.
  bool get isEmpty => gains.isEmpty;
}
