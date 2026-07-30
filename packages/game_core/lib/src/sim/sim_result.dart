import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// What one call to `simulate` produced.
///
/// [gains] is kept separate from [state] because the offline report (`T-014`)
/// and the "while you were away" screen need to know what *changed*, not only
/// where the player ended up.
@immutable
class SimResult {
  const SimResult({
    required this.state,
    required this.gains,
    required this.stepsSimulated,
  });

  /// The state after the elapsed time.
  final PlayerState state;

  /// Resources added during this call, keyed the same way as the state's.
  final Map<String, BigNum> gains;

  /// Whole one-second steps that were paid out.
  ///
  /// Zero when the elapsed time did not complete a step; the remainder is in
  /// `state.carryOverMs`.
  final int stepsSimulated;
}
