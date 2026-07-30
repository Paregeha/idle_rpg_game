import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/balance/balance_exception.dart';
import 'package:game_core/src/balance/generator_config.dart';
import 'package:game_core/src/balance/hero_config.dart';
import 'package:game_core/src/balance/item_upgrade_config.dart';
import 'package:game_core/src/balance/lamp_config.dart';
import 'package:game_core/src/balance/monster_config.dart';
import 'package:game_core/src/balance/prestige_config.dart';
import 'package:game_core/src/balance/start_config.dart';
import 'package:game_core/src/items/item_config.dart';

part 'balance_config.freezed.dart';
part 'balance_config.g.dart';

const int _eightHoursMs = 8 * 60 * 60 * 1000;

/// Highest config schema this build understands.
///
/// The server can hand out a newer balance file than an old client knows how to
/// read (`T-035`). Refusing it outright beats guessing at fields that did not
/// exist when the client shipped.
const int supportedBalanceVersion = 1;

/// Every tunable number the simulation reads.
///
/// Balance lives in data, never in code (rule 6): the server can ship a change
/// without a store release, and the CLI simulator can sweep a config across
/// player profiles without launching the game.
@freezed
abstract class BalanceConfig with _$BalanceConfig {
  const factory BalanceConfig({
    /// Schema version of this config.
    @Default(supportedBalanceVersion) int version,

    @Default(<String, GeneratorConfig>{})
    Map<String, GeneratorConfig> generators,

    @Default(<String, MonsterConfig>{}) Map<String, MonsterConfig> monsters,

    @Default(PrestigeConfig()) PrestigeConfig prestige,

    @Default(HeroConfig()) HeroConfig hero,

    @Default(LampConfig()) LampConfig lamp,

    @Default(ItemUpgradeConfig()) ItemUpgradeConfig itemUpgrade,

    /// Equipment slots, in display order. Data rather than an enum: adding a
    /// fifth slot must be a change to this file, not a code change.
    @Default(<String>[]) List<String> slots,

    @Default(<String, RarityConfig>{}) Map<String, RarityConfig> rarities,

    @Default(<String, ItemConfig>{}) Map<String, ItemConfig> items,

    @Default(StartConfig()) StartConfig start,

    /// How much of an absence is paid out, in milliseconds.
    ///
    /// The cap is what keeps an idle game a game: without it, returning after a
    /// month would hand over a month of progress and skip the part the player
    /// is here for.
    @Default(_eightHoursMs) int offlineCapMs,
  }) = _BalanceConfig;

  const BalanceConfig._();

  factory BalanceConfig.fromJson(Map<String, dynamic> json) =>
      _$BalanceConfigFromJson(json);

  /// Parses and validates a balance file.
  ///
  /// Balance can be updated without a client release, so a broken file can
  /// reach a running game. Every problem is raised as a
  /// [BalanceConfigException] naming the offending field — a silent default
  /// would quietly change the economy for every player instead.
  factory BalanceConfig.parse(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw BalanceConfigException('not valid JSON: ${e.message}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const BalanceConfigException('expected a JSON object at the root');
    }

    if (decoded['version'] == null) {
      throw const BalanceConfigException(
        'missing; a config must state the schema it was written for',
        field: 'version',
      );
    }

    final BalanceConfig config;
    try {
      config = BalanceConfig.fromJson(decoded);
    } on Object catch (e) {
      throw BalanceConfigException('could not be read: $e');
    }

    config._validate();
    return config;
  }

  void _validate() {
    if (version < 1 || version > supportedBalanceVersion) {
      throw BalanceConfigException(
        'is $version, but this build understands up to '
        '$supportedBalanceVersion',
        field: 'version',
      );
    }

    if (offlineCapMs <= 0) {
      throw BalanceConfigException(
        'must be positive, got $offlineCapMs',
        field: 'offlineCapMs',
      );
    }

    for (final entry in generators.entries) {
      final path = 'generators.${entry.key}';
      final generator = entry.value;

      if (generator.produces.trim().isEmpty) {
        throw BalanceConfigException(
          'must name the resource it produces',
          field: '$path.produces',
        );
      }
      if (generator.baseRatePerSecond.isNegative ||
          generator.baseRatePerSecond.isZero) {
        throw BalanceConfigException(
          'must be positive, got ${generator.baseRatePerSecond.format()}',
          field: '$path.baseRatePerSecond',
        );
      }
      if (generator.levelMultiplier < 1) {
        throw BalanceConfigException(
          'must be at least 1, or levelling up would make things worse',
          field: '$path.levelMultiplier',
        );
      }
      if (generator.costBase.isNegative || generator.costBase.isZero) {
        throw BalanceConfigException(
          'must be positive',
          field: '$path.costBase',
        );
      }
      if (generator.costGrowth <= 1) {
        throw BalanceConfigException(
          'must exceed 1, otherwise units never get more expensive and the '
          'progression disappears',
          field: '$path.costGrowth',
        );
      }
    }

    for (final entry in start.generators.entries) {
      if (!generators.containsKey(entry.key)) {
        throw BalanceConfigException(
          'grants "${entry.key}", which no generator defines',
          field: 'start.generators.${entry.key}',
        );
      }
      if (entry.value <= 0) {
        throw BalanceConfigException(
          'must be positive, got ${entry.value}',
          field: 'start.generators.${entry.key}',
        );
      }
    }

    if (generators.isNotEmpty && start.generators.isEmpty) {
      throw const BalanceConfigException(
        'is empty, so a new player has no income and can never afford the '
        'first generator',
        field: 'start.generators',
      );
    }

    if (prestige.resource.trim().isEmpty) {
      throw const BalanceConfigException(
        'must name the resource the award is computed from',
        field: 'prestige.resource',
      );
    }
    if (prestige.currencyBase.isNegative || prestige.currencyBase.isZero) {
      throw const BalanceConfigException(
        'must be positive; it is the divisor of the award formula',
        field: 'prestige.currencyBase',
      );
    }
    if (prestige.currencyExponent <= 0) {
      throw BalanceConfigException(
        'must be positive, got ${prestige.currencyExponent}',
        field: 'prestige.currencyExponent',
      );
    }
    if (prestige.currencyExponent > 1) {
      throw const BalanceConfigException(
        'above 1 makes one very long run worth more than several deliberate '
        'ones, which turns the loop into a grind',
        field: 'prestige.currencyExponent',
      );
    }
    if (prestige.bonusPerPoint.isNegative) {
      throw const BalanceConfigException(
        'must not be negative, or prestiging would make the player weaker',
        field: 'prestige.bonusPerPoint',
      );
    }

    if (itemUpgrade.costGrowth < 1) {
      throw const BalanceConfigException(
        'below 1 means each level is cheaper than the last, so upgrading has '
        'no cost curve at all',
        field: 'itemUpgrade.costGrowth',
      );
    }
    if (itemUpgrade.duplicatesPerLevel < 0) {
      throw const BalanceConfigException(
        'must not be negative',
        field: 'itemUpgrade.duplicatesPerLevel',
      );
    }
    if (itemUpgrade.costBase.isNegative || itemUpgrade.costBase.isZero) {
      throw const BalanceConfigException(
        'must be positive',
        field: 'itemUpgrade.costBase',
      );
    }

    if (lamp.weights.isNotEmpty) {
      for (final entry in lamp.weights.entries) {
        if (!rarities.containsKey(entry.key)) {
          throw BalanceConfigException(
            'weights a rarity "${entry.key}" that does not exist',
            field: 'lamp.weights',
          );
        }
        if (entry.value < 0) {
          throw BalanceConfigException(
            'must not be negative',
            field: 'lamp.weights.${entry.key}',
          );
        }
      }
      if (lamp.totalWeight <= 0) {
        throw const BalanceConfigException(
          'sum to zero, so the lamp could never pick anything',
          field: 'lamp.weights',
        );
      }
    }
    if (lamp.pityThreshold < 0) {
      throw const BalanceConfigException(
        'must not be negative',
        field: 'lamp.pityThreshold',
      );
    }
    if (lamp.pityRarity.isNotEmpty && !rarities.containsKey(lamp.pityRarity)) {
      throw BalanceConfigException(
        'guarantees "${lamp.pityRarity}", which no rarity defines',
        field: 'lamp.pityRarity',
      );
    }

    for (final entry in rarities.entries) {
      if (entry.value.statMultiplier <= 0) {
        throw BalanceConfigException(
          'must be positive, or items of this rarity would be worthless',
          field: 'rarities.${entry.key}.statMultiplier',
        );
      }
    }

    for (final entry in items.entries) {
      final path = 'items.${entry.key}';
      final item = entry.value;

      if (!slots.contains(item.slot)) {
        throw BalanceConfigException(
          'is "${item.slot}", which is not one of the declared slots '
          '(${slots.join(', ')}) — the item could never be worn',
          field: '$path.slot',
        );
      }
      if (!rarities.containsKey(item.rarity)) {
        throw BalanceConfigException(
          'is "${item.rarity}", which no rarity defines',
          field: '$path.rarity',
        );
      }
      if (item.stats.flatAttack.isNegative || item.stats.flatHp.isNegative) {
        throw BalanceConfigException(
          'cannot be negative: an item that makes the hero weaker reads as a '
          'bug, not as a trade-off',
          field: '$path.stats',
        );
      }
      if (item.levelMultiplier < 1) {
        throw BalanceConfigException(
          'below 1 means upgrading an item makes it worse',
          field: '$path.levelMultiplier',
        );
      }
      if (item.maxLevel < 0) {
        throw BalanceConfigException(
          'must not be negative',
          field: '$path.maxLevel',
        );
      }
      if (item.stats.critChance < 0 || item.stats.critChance > 1) {
        throw BalanceConfigException(
          'must be a probability between 0 and 1',
          field: '$path.stats.critChance',
        );
      }
      if (item.stats.dodgeChance < 0 || item.stats.dodgeChance > 1) {
        throw BalanceConfigException(
          'must be a probability between 0 and 1',
          field: '$path.stats.dodgeChance',
        );
      }
    }

    if (hero.perUnitMultiplier < 1) {
      throw const BalanceConfigException(
        'below 1 means building generators makes the hero weaker',
        field: 'hero.perUnitMultiplier',
      );
    }
    if (hero.attacksPerSecond <= 0) {
      throw const BalanceConfigException(
        'must be positive, or the hero never swings',
        field: 'hero.attacksPerSecond',
      );
    }

    for (final entry in monsters.entries) {
      final path = 'monsters.${entry.key}';
      final monster = entry.value;

      if (monster.attacksPerSecond <= 0) {
        throw BalanceConfigException(
          'must be positive, or the monster is harmless and every fight is a '
          'formality',
          field: '$path.attacksPerSecond',
        );
      }

      if (monster.baseHp.isNegative || monster.baseHp.isZero) {
        throw BalanceConfigException('must be positive', field: '$path.baseHp');
      }
      if (monster.hpGrowth <= 1) {
        throw BalanceConfigException(
          'must exceed 1, or later monsters would be no harder than the first',
          field: '$path.hpGrowth',
        );
      }
      if (monster.rewardBase.isNegative || monster.rewardBase.isZero) {
        throw BalanceConfigException(
          'must be positive',
          field: '$path.rewardBase',
        );
      }
      if (monster.rewardGrowth <= 1) {
        throw BalanceConfigException(
          'must exceed 1, or deeper zones would pay no better',
          field: '$path.rewardGrowth',
        );
      }
      if (monster.dropChance < 0 || monster.dropChance > 1) {
        throw BalanceConfigException(
          'must be a probability between 0 and 1, got ${monster.dropChance}',
          field: '$path.dropChance',
        );
      }
    }
  }
}
