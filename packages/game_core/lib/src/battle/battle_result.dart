import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/battle/battle_event.dart';

part 'battle_result.freezed.dart';
part 'battle_result.g.dart';

/// How a fight ended.
enum BattleOutcome { heroWon, heroLost, timeout }

/// A fight, resolved in full before a single frame is drawn.
///
/// The client receives this and plays [events] back against their timecodes.
/// It is a recording, not a simulation: pressing 2x, skipping the animation or
/// closing the app mid-fight cannot change [outcome], because the outcome was
/// already decided (rule 5, and `T-024`).
@freezed
abstract class BattleResult with _$BattleResult {
  const factory BattleResult({
    required BattleOutcome outcome,
    required List<BattleEvent> events,

    /// Milliseconds the fight took in game time, not in wall time.
    required int durationMs,
  }) = _BattleResult;

  const BattleResult._();

  factory BattleResult.fromJson(Map<String, dynamic> json) =>
      _$BattleResultFromJson(json);

  Duration get duration => Duration(milliseconds: durationMs);

  bool get heroWon => outcome == BattleOutcome.heroWon;
}
