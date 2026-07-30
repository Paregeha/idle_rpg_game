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
  }) = _HeroConfig;

  const HeroConfig._();

  factory HeroConfig.fromJson(Map<String, dynamic> json) =>
      _$HeroConfigFromJson(json);

  /// Combat stats for a hero backed by [unitsOwned] generator units.
  ///
  /// Formula: `baseAttack * perUnitMultiplier^unitsOwned`, and the same for
  /// health. Exponential in units so that building keeps mattering, matched
  /// against monster health that also grows exponentially — the pacing is the
  /// gap between the two rates.
  CombatStats statsFor({required int unitsOwned}) {
    final scale = BigNum.fromDouble(perUnitMultiplier).pow(unitsOwned);

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
