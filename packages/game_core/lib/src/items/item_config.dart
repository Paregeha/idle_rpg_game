import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'item_config.freezed.dart';
part 'item_config.g.dart';

/// What a rarity is worth.
///
/// Rarities are data, not an enum. Adding a tier above legendary, or retuning
/// what epic is worth, has to be a change to the balance file — a code change
/// would need a store release for what is a weekly tuning decision.
@freezed
abstract class RarityConfig with _$RarityConfig {
  const factory RarityConfig({
    /// Every stat on the item is multiplied by this.
    @Default(1.0) double statMultiplier,

    /// Ordering for display and for "equip best". Higher is better.
    @Default(0) int rank,
  }) = _RarityConfig;

  factory RarityConfig.fromJson(Map<String, dynamic> json) =>
      _$RarityConfigFromJson(json);
}

/// Stat changes an item brings.
///
/// Multipliers and flat additions are separate because they behave differently
/// as the game scales: a flat +10 attack is everything at the start and nothing
/// by day three, while a x1.2 keeps its meaning forever. Both exist so balance
/// can choose which lever an item pulls.
@freezed
abstract class ItemStats with _$ItemStats {
  const factory ItemStats({
    @BigNumConverter() @Default(BigNum.zero) BigNum flatAttack,
    @BigNumConverter() @Default(BigNum.zero) BigNum flatHp,
    @Default(1.0) double attackMultiplier,
    @Default(1.0) double hpMultiplier,
    @Default(0.0) double critChance,
    @Default(0.0) double critFactor,
    @Default(0.0) double dodgeChance,
    @Default(0.0) double mitigation,
    @Default(0.0) double attacksPerSecond,
  }) = _ItemStats;

  const ItemStats._();

  factory ItemStats.fromJson(Map<String, dynamic> json) =>
      _$ItemStatsFromJson(json);

  /// Scales everything that should scale, leaving probabilities alone.
  ///
  /// A rarity multiplier must not touch crit chance or dodge: multiplying a
  /// probability by 3 produces a value above 1, which is not a stronger item
  /// but a broken one.
  ItemStats scaled(double factor) {
    if (factor == 1) return this;
    final scale = BigNum.fromDouble(factor);

    return ItemStats(
      flatAttack: flatAttack * scale,
      flatHp: flatHp * scale,
      attackMultiplier: 1 + (attackMultiplier - 1) * factor,
      hpMultiplier: 1 + (hpMultiplier - 1) * factor,
      critChance: critChance,
      critFactor: critFactor,
      dodgeChance: dodgeChance,
      mitigation: mitigation,
      attacksPerSecond: attacksPerSecond,
    );
  }

  /// Sums two sets of stats as a character would wear them.
  ItemStats operator +(ItemStats other) => ItemStats(
    flatAttack: flatAttack + other.flatAttack,
    flatHp: flatHp + other.flatHp,
    attackMultiplier: attackMultiplier * other.attackMultiplier,
    hpMultiplier: hpMultiplier * other.hpMultiplier,
    critChance: critChance + other.critChance,
    critFactor: critFactor + other.critFactor,
    dodgeChance: dodgeChance + other.dodgeChance,
    mitigation: mitigation + other.mitigation,
    attacksPerSecond: attacksPerSecond + other.attacksPerSecond,
  );

  static const empty = ItemStats();
}

/// One kind of item.
@freezed
abstract class ItemConfig with _$ItemConfig {
  const factory ItemConfig({
    /// Kind of item this is, matched against a slot's `accepts`.
    ///
    /// Named `slot` for the common case where the kind and the slot share a
    /// name (`weapon`, `helm`); a ring is kind `ring` and fits `ring1` or
    /// `ring2`.
    required String slot,

    /// Key into `BalanceConfig.rarities`.
    required String rarity,

    /// Where this item can come from: `lamp`, `craft`, `shop`, `event`.
    ///
    /// Without this the lamp can hand out wings that are supposed to be
    /// crafted and skins that are supposed to be bought — the first pull would
    /// give away the thing the shop sells.
    @Default(<String>['lamp']) List<String> sources,

    /// Stats at level 0, before the rarity multiplier.
    @Default(ItemStats.empty) ItemStats stats,

    /// Stats are multiplied by this per upgrade level (`T-083`).
    @Default(1.12) double levelMultiplier,

    /// Highest level this item can reach.
    @Default(20) int maxLevel,
  }) = _ItemConfig;

  const ItemConfig._();

  factory ItemConfig.fromJson(Map<String, dynamic> json) =>
      _$ItemConfigFromJson(json);

  /// Stats this item actually contributes at [level] for its rarity.
  ///
  /// Formula: `stats * rarity.statMultiplier * levelMultiplier^level`.
  ItemStats statsAt({required int level, required RarityConfig rarity}) {
    if (level < 0) {
      throw ArgumentError.value(level, 'level', 'must not be negative');
    }

    final levelScale = _pow(levelMultiplier, level);
    return stats.scaled(rarity.statMultiplier * levelScale);
  }
}

double _pow(double base, int exponent) {
  var result = 1.0;
  for (var i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
