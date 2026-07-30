import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'combat_stats.freezed.dart';
part 'combat_stats.g.dart';

/// Everything a combatant brings to a fight.
///
/// Derived from `PlayerState` plus the balance config for a hero, and straight
/// from `MonsterConfig` for a monster. Deliberately flat: the battle resolver
/// takes only these numbers, which keeps it free of any notion of inventories,
/// zones or progression.
@freezed
abstract class CombatStats with _$CombatStats {
  const factory CombatStats({
    /// Damage of one unmodified swing.
    @BigNumConverter() required BigNum attack,

    /// Swings per second. Sets the spacing of events in the journal.
    @Default(1.0) double attacksPerSecond,

    /// Probability in `0..1` that a swing crits.
    @Default(0.0) double critChance,

    /// Damage multiplier applied on a crit.
    @Default(2.0) double critFactor,

    /// Fraction of incoming damage absorbed, in `0..1`.
    @Default(0.0) double mitigation,

    /// Probability in `0..1` of avoiding an incoming swing entirely.
    @Default(0.0) double dodgeChance,

    /// Starting health.
    @BigNumConverter() @Default(BigNum.one) BigNum maxHp,
  }) = _CombatStats;

  factory CombatStats.fromJson(Map<String, dynamic> json) =>
      _$CombatStatsFromJson(json);
}
