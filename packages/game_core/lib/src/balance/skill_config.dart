import 'package:freezed_annotation/freezed_annotation.dart';

part 'skill_config.freezed.dart';
part 'skill_config.g.dart';

/// One skill the hero can learn.
///
/// A skill is a cast, not a stat: it fires on its own cooldown during a fight
/// and lands as its own events in the journal. Passive bonuses would be a
/// second set of rules inside the resolver, so they are deliberately not this
/// — when they arrive they get their own type.
@freezed
abstract class SkillConfig with _$SkillConfig {
  const factory SkillConfig({
    /// Rarity key, shared with items so one colour means one thing.
    @Default('common') String rarity,

    /// Hero level at which the skill may be used at all.
    ///
    /// A skill dropped before then is still collected: copies bank, and the
    /// skill switches on when the player gets there. Refusing the drop would
    /// mean a boss kill that paid nothing.
    @Default(0) int unlockAtLevel,

    /// Seconds between casts.
    @Default(6.0) double cooldownSeconds,

    /// Swing damage multiplier at level 1.
    @Default(2.0) double damageMultiplier,

    /// Multiplier gained per level, compounding.
    @Default(1.15) double levelMultiplier,

    /// How many monsters one cast lands on. Zero means the whole wave.
    ///
    /// Zero rather than a large number: "everything" must not stop being true
    /// the day a wave grows to seven.
    @Default(1) int targets,

    /// Levels this skill can reach.
    @Default(10) int maxLevel,

    /// Duplicate copies the first upgrade costs.
    @Default(2) int copiesBase,

    /// Copies cost is multiplied by this per level already reached.
    @Default(1.6) double copiesGrowth,
  }) = _SkillConfig;

  const SkillConfig._();

  factory SkillConfig.fromJson(Map<String, dynamic> json) =>
      _$SkillConfigFromJson(json);

  /// Whether one cast lands on the whole wave.
  bool get hitsEveryone => targets <= 0;

  /// Duplicate copies needed to move from [level] to `level + 1`.
  ///
  /// Formula: `ceil(copiesBase * copiesGrowth^(level - 1))`, and always at
  /// least one — a curve that rounds down to zero would hand out free levels.
  int copiesFor(int level) {
    if (level < 1) {
      throw ArgumentError.value(level, 'level', 'must be at least 1');
    }

    var cost = copiesBase.toDouble();
    for (var i = 1; i < level; i++) {
      cost *= copiesGrowth;
    }
    return cost.ceil().clamp(1, 1 << 30);
  }

  /// Damage multiplier at [level].
  ///
  /// Formula: `damageMultiplier * levelMultiplier^(level - 1)`.
  double damageAt(int level) {
    if (level < 1) return 0;

    var value = damageMultiplier;
    for (var i = 1; i < level; i++) {
      value *= levelMultiplier;
    }
    return value;
  }

  int get cooldownMs => (cooldownSeconds * 1000).round();
}

/// The pack that sells skill copies.
@freezed
abstract class SkillPackConfig with _$SkillPackConfig {
  const factory SkillPackConfig({
    /// Resource a pack costs. Gems, so the skill track has a currency of its
    /// own rather than competing with gold for the same pile.
    @Default('gems') String costResource,

    @Default(100.0) double costAmount,

    /// Relative weights per rarity key.
    @Default(<String, double>{}) Map<String, double> weights,

    /// Packs without the pity rarity before it is guaranteed. Zero disables.
    @Default(0) int pityThreshold,

    @Default('') String pityRarity,

    /// Chance a boss drops a copy, in `0..1`.
    @Default(0.0) double bossDropChance,

    /// Chance an ordinary monster drops a copy, in `0..1`.
    @Default(0.0) double monsterDropChance,
  }) = _SkillPackConfig;

  const SkillPackConfig._();

  factory SkillPackConfig.fromJson(Map<String, dynamic> json) =>
      _$SkillPackConfigFromJson(json);

  bool get hasPity => pityThreshold > 0 && pityRarity.isNotEmpty;

  double get totalWeight =>
      weights.values.fold(0, (sum, weight) => sum + weight);
}
