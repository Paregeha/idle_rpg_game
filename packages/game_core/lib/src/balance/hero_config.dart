import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'hero_config.freezed.dart';
part 'hero_config.g.dart';

/// How a hero's combat power is derived from their progression.
///
/// The hero fights with what the player has built, so attack and health scale
/// off the generators they own rather than off a separate combat currency —
/// one progression track instead of two competing ones.
@freezed
abstract class HeroConfig with _$HeroConfig {
  const factory HeroConfig({
    @BigNumConverter() @Default(BigNum.one) BigNum baseAttack,
    @BigNumConverter() @Default(BigNum.one) BigNum baseHp,

    /// Attack and health are both multiplied by this per generator unit owned.
    @Default(1.05) double perUnitMultiplier,

    @Default(1.0) double attacksPerSecond,
    @Default(0.1) double critChance,
    @Default(2.0) double critFactor,
    @Default(0.0) double mitigation,
    @Default(0.05) double dodgeChance,

    /// Experience needed to reach level 1.
    @BigNumConverter() @Default(BigNum.one) BigNum expBase,

    /// The requirement is multiplied by this per level already reached.
    ///
    /// Above 1 so levels slow down; the curve is what stops a player from
    /// out-levelling the content in an afternoon.
    @Default(1.35) double expGrowth,

    /// Attack and health are multiplied by this per hero level.
    @Default(1.08) double statPerLevel,
  }) = _HeroConfig;

  const HeroConfig._();

  factory HeroConfig.fromJson(Map<String, dynamic> json) =>
      _$HeroConfigFromJson(json);

  /// Experience needed to go from [level] to `level + 1`.
  ///
  /// Formula: `expBase * expGrowth^level`.
  BigNum expForLevel(int level) {
    if (level < 0) {
      throw ArgumentError.value(level, 'level', 'must not be negative');
    }
    return expBase * BigNum.fromDouble(expGrowth).pow(level);
  }

  /// Combat stats for a hero backed by [unitsOwned] generator units.
  ///
  /// Formula: `baseAttack * perUnitMultiplier^unitsOwned`, and the same for
  /// health. Exponential in units so that building keeps mattering, matched
  /// against monster health that also grows exponentially — the pacing is the
  /// gap between the two rates.
  CombatStats statsFor({required int unitsOwned, int level = 0}) {
    final scale =
        BigNum.fromDouble(perUnitMultiplier).pow(unitsOwned) *
        BigNum.fromDouble(statPerLevel).pow(level);

    return CombatStats(
      attack: baseAttack * scale,
      maxHp: baseHp * scale,
      attacksPerSecond: attacksPerSecond,
      critChance: critChance,
      critFactor: critFactor,
      mitigation: mitigation,
      dodgeChance: dodgeChance,
    );
  }
}
