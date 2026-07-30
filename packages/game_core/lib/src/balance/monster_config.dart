import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'monster_config.freezed.dart';
part 'monster_config.g.dart';

/// Balance numbers for one kind of monster.
@freezed
abstract class MonsterConfig with _$MonsterConfig {
  const factory MonsterConfig({
    /// Health at level 0.
    @BigNumConverter() required BigNum baseHp,

    /// Health is multiplied by this per level.
    required double hpGrowth,

    /// Reward for a kill at level 0.
    @BigNumConverter() required BigNum rewardBase,

    /// Reward is multiplied by this per level.
    required double rewardGrowth,

    /// Damage of one swing at level 0.
    @BigNumConverter() @Default(BigNum.one) BigNum baseAttack,

    /// Attack is multiplied by this per level.
    @Default(1.4) double attackGrowth,

    /// Swings per second.
    @Default(0.8) double attacksPerSecond,

    /// Fraction of incoming damage absorbed, in `0..1`.
    @Default(0.0) double mitigation,

    /// Probability in `0..1` of dodging a swing.
    @Default(0.0) double dodgeChance,

    /// Probability in `0..1` that a kill drops an item.
    @Default(0.0) double dropChance,
  }) = _MonsterConfig;

  const MonsterConfig._();

  factory MonsterConfig.fromJson(Map<String, dynamic> json) =>
      _$MonsterConfigFromJson(json);

  /// Health at [level].
  ///
  /// Formula: `baseHp * hpGrowth^level`.
  ///
  /// Growth is exponential while player damage grows exponentially too; the
  /// pacing comes from the gap between the two rates, not from either alone.
  BigNum hpFor(int level) {
    _requireNonNegative(level);
    return baseHp * BigNum.fromDouble(hpGrowth).pow(level);
  }

  /// Damage this monster deals at [level].
  ///
  /// Formula: `baseAttack * attackGrowth^level`.
  ///
  /// Kept below [hpFor]'s growth so that deeper zones kill a player through
  /// attrition rather than one-shotting them, which reads as unfair.
  BigNum attackFor(int level) {
    _requireNonNegative(level);
    return baseAttack * BigNum.fromDouble(attackGrowth).pow(level);
  }

  /// Reward for killing a monster at [level].
  ///
  /// Formula: `rewardBase * rewardGrowth^level`.
  ///
  /// Kept deliberately below [hpFor]'s growth in the shipped config, so that
  /// pushing into a new zone is a decision rather than a free upgrade.
  BigNum rewardFor(int level) {
    _requireNonNegative(level);
    return rewardBase * BigNum.fromDouble(rewardGrowth).pow(level);
  }
}

void _requireNonNegative(int level) {
  if (level < 0) {
    throw ArgumentError.value(level, 'level', 'must not be negative');
  }
}
