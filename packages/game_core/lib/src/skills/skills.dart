import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/balance/skill_config.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Why a skill upgrade did not happen.
enum SkillRefusal { unknownSkill, notLearned, alreadyMaxLevel, notEnoughCopies }

/// Outcome of an attempt to raise a skill.
@immutable
class SkillUpgradeResult {
  const SkillUpgradeResult({
    required this.state,
    this.level,
    this.refusal,
    this.spentCopies = 0,
  });

  final PlayerState state;

  /// The skill's new level, or null if the attempt was refused.
  final int? level;

  final SkillRefusal? refusal;

  /// Copies consumed. Returned so the screen can say what was spent.
  final int spentCopies;

  bool get upgraded => level != null;
}

/// What a copy of a skill did when it arrived.
@immutable
class SkillGrant {
  const SkillGrant({
    required this.state,
    required this.skillId,
    required this.learned,
  });

  final PlayerState state;

  /// Which skill the copy belongs to.
  final String skillId;

  /// True when this copy taught the skill rather than banking as a duplicate.
  final bool learned;
}

/// Grants one copy of [skillId].
///
/// The first copy teaches the skill at level 1; every copy after it banks as a
/// duplicate to be spent on an upgrade. A drop the player cannot use yet still
/// banks — a boss kill that paid nothing because the hero was two levels short
/// reads as the game losing the reward.
SkillGrant grantSkillCopy(PlayerState state, String skillId) {
  final known = state.skills.containsKey(skillId);

  if (!known) {
    return SkillGrant(
      state: state.copyWith(skills: {...state.skills, skillId: 1}),
      skillId: skillId,
      learned: true,
    );
  }

  final copies = (state.skillCopies[skillId] ?? 0) + 1;
  return SkillGrant(
    state: state.copyWith(skillCopies: {...state.skillCopies, skillId: copies}),
    skillId: skillId,
    learned: false,
  );
}

/// Raises a skill one level, paying in duplicate copies.
///
/// Copies only — no resource. Gold already buys generators and item levels,
/// and a third claim on the same pile would make every skill compete with the
/// upgrade screen instead of with the pack.
SkillUpgradeResult upgradeSkill(
  PlayerState state,
  String skillId,
  BalanceConfig config,
) {
  final skill = config.skills[skillId];
  if (skill == null) {
    return SkillUpgradeResult(
      state: state,
      refusal: SkillRefusal.unknownSkill,
    );
  }

  final level = state.skills[skillId];
  if (level == null) {
    return SkillUpgradeResult(state: state, refusal: SkillRefusal.notLearned);
  }
  if (level >= skill.maxLevel) {
    return SkillUpgradeResult(
      state: state,
      refusal: SkillRefusal.alreadyMaxLevel,
    );
  }

  final price = skill.copiesFor(level);
  final held = state.skillCopies[skillId] ?? 0;
  if (held < price) {
    return SkillUpgradeResult(
      state: state,
      refusal: SkillRefusal.notEnoughCopies,
    );
  }

  return SkillUpgradeResult(
    state: state.copyWith(
      skills: {...state.skills, skillId: level + 1},
      skillCopies: {...state.skillCopies, skillId: held - price},
    ),
    level: level + 1,
    spentCopies: price,
  );
}

/// The skills that actually fire in a fight right now.
///
/// A skill the hero has learned but not reached the level for is left out
/// rather than cast at reduced effect: a skill that half-works is harder to
/// reason about than one that is plainly not on yet.
List<ActiveSkill> activeSkills(PlayerState state, BalanceConfig config) {
  final active = <ActiveSkill>[];

  for (final entry in state.skills.entries) {
    final skill = config.skills[entry.key];
    if (skill == null) continue;
    if (state.heroLevel < skill.unlockAtLevel) continue;
    if (entry.value < 1) continue;

    active.add(
      ActiveSkill(
        id: entry.key,
        cooldownMs: skill.cooldownMs,
        damageMultiplier: skill.damageAt(entry.value),
        targets: skill.targets,
      ),
    );
  }

  // Sorted by id so the journal does not depend on map iteration order, which
  // the server has no reason to reproduce.
  active.sort((a, b) => a.id.compareTo(b.id));
  return active;
}

/// One skill as the resolver needs it: when it fires and what it does.
///
/// Deliberately not [SkillConfig] plus a level — the resolver should not have
/// to know how a level becomes a multiplier, and the server must be able to
/// replay a fight from exactly these numbers.
@immutable
class ActiveSkill {
  const ActiveSkill({
    required this.id,
    required this.cooldownMs,
    required this.damageMultiplier,
    this.targets = 1,
  });

  final String id;
  final int cooldownMs;
  final double damageMultiplier;

  /// Monsters one cast lands on. Zero means the whole wave.
  final int targets;

  bool get hitsEveryone => targets <= 0;

  @override
  bool operator ==(Object other) =>
      other is ActiveSkill &&
      other.id == id &&
      other.cooldownMs == cooldownMs &&
      other.damageMultiplier == damageMultiplier &&
      other.targets == targets;

  @override
  int get hashCode => Object.hash(id, cooldownMs, damageMultiplier, targets);
}
