import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'battle_event.freezed.dart';
part 'battle_event.g.dart';

/// Who a swing came from or landed on.
enum BattleSide { hero, monster }

/// What happened on one swing.
enum BattleEventKind { hit, crit, dodge, death }

/// One entry in the battle journal.
///
/// [atMs] is milliseconds from the start of the fight. The client plays the
/// journal back against these timecodes — it never decides what happens, which
/// is why skipping or speeding up the animation cannot change the outcome.
@freezed
abstract class BattleEvent with _$BattleEvent {
  const factory BattleEvent({
    /// Milliseconds since the fight began.
    required int atMs,
    required BattleEventKind kind,

    /// Who swung. For a death, the side that landed the killing blow.
    required BattleSide source,

    /// Who it landed on. For a death, the side that died.
    required BattleSide target,

    /// Which monster in the group, when [target] is the monster side.
    ///
    /// A fight is against a group, so "the monster was hit" is not enough for
    /// the scene to know which shape to flinch — and a skill that hits three
    /// at once produces three events at the same timecode.
    @Default(0) int targetIndex,

    /// Damage dealt. Zero for a dodge or a death marker.
    @BigNumConverter() @Default(BigNum.zero) BigNum damage,
  }) = _BattleEvent;

  factory BattleEvent.fromJson(Map<String, dynamic> json) =>
      _$BattleEventFromJson(json);
}
