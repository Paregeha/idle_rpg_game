import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/random/seeded_random.dart';
import 'package:game_core/src/skills/skills.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Why a pack did not open.
enum SkillPackRefusal { cannotAfford, noSkillsConfigured }

/// What a pack produced.
@immutable
class SkillPackResult {
  const SkillPackResult({
    required this.state,
    this.skillId,
    this.learned = false,
    this.refusal,
    this.wasPity = false,
  });

  final PlayerState state;

  /// The skill a copy was drawn for, or null if the pack was refused.
  final String? skillId;

  /// True when this copy taught the skill rather than banking as a duplicate.
  final bool learned;

  final SkillPackRefusal? refusal;

  /// Whether the pity counter forced this rarity.
  final bool wasPity;

  bool get opened => skillId != null;
}

/// Opens one skill pack.
///
/// Mirrors the lamp on purpose: same weighted draw, same pity guarantee, same
/// RNG carried in the save so the server reaches the same verdict. Two gachas
/// with two different sets of rules would be two sets of bugs.
///
/// What a pack gives is a **copy**, not the skill: the first copy teaches it,
/// the rest pay for its levels.
SkillPackResult openSkillPack(PlayerState state, BalanceConfig config) {
  final pack = config.skillPack;

  final price = BigNum.fromDouble(pack.costAmount);
  final balance = state.resources[pack.costResource] ?? BigNum.zero;
  if (balance < price) {
    return SkillPackResult(
      state: state,
      refusal: SkillPackRefusal.cannotAfford,
    );
  }
  if (config.skills.isEmpty || pack.totalWeight <= 0) {
    return SkillPackResult(
      state: state,
      refusal: SkillPackRefusal.noSkillsConfigured,
    );
  }

  final rng = state.random();
  final pityDue = pack.hasPity && state.skillPity >= pack.pityThreshold - 1;
  final rarity = pityDue ? pack.pityRarity : drawWeightedKey(rng, pack.weights);

  final drawn = pickSkillOfRarity(config, rarity, rng);
  final gotPityRarity = config.skills[drawn]!.rarity == pack.pityRarity;

  final granted = grantSkillCopy(
    state.copyWith(
      resources: {...state.resources, pack.costResource: balance - price},
      skillPity: gotPityRarity ? 0 : state.skillPity + 1,
      rngState: rng.state,
    ),
    drawn,
  );

  return SkillPackResult(
    state: granted.state,
    skillId: drawn,
    learned: granted.learned,
    wasPity: pityDue,
  );
}

/// Rolls whether a kill drops a skill copy.
///
/// Bosses drop often enough to be the reason to reach one; ordinary monsters
/// drop rarely enough that the pack still has a job. Both numbers are config.
///
/// The roll consumes a draw whether or not it lands, so a losing roll cannot
/// replay forever from the same position.
SkillPackResult rollSkillDrop(
  PlayerState state,
  BalanceConfig config, {
  required bool fromBoss,
}) {
  final pack = config.skillPack;
  final chance = fromBoss ? pack.bossDropChance : pack.monsterDropChance;

  if (chance <= 0 || config.skills.isEmpty || pack.totalWeight <= 0) {
    return SkillPackResult(state: state);
  }

  final rng = state.random();
  if (rng.nextDouble() >= chance) {
    return SkillPackResult(state: state.copyWith(rngState: rng.state));
  }

  final rarity = drawWeightedKey(rng, pack.weights);
  final drawn = pickSkillOfRarity(config, rarity, rng);
  final granted = grantSkillCopy(
    state.copyWith(rngState: rng.state),
    drawn,
  );

  return SkillPackResult(
    state: granted.state,
    skillId: drawn,
    learned: granted.learned,
  );
}

/// Picks a skill of [rarity], falling back to any skill.
///
/// A rarity with no skills behind it must not swallow the draw: the player
/// paid, or killed the boss, either way something has to come out.
@visibleForTesting
String pickSkillOfRarity(
  BalanceConfig config,
  String rarity,
  SeededRandom rng,
) {
  // Sorted, because a draw that depends on map iteration order is a draw the
  // server cannot reproduce.
  final all = config.skills.keys.toList()..sort();
  final matching = all
      .where((id) => config.skills[id]!.rarity == rarity)
      .toList();
  final pool = matching.isEmpty ? all : matching;

  return pool[rng.nextInt(pool.length)];
}

/// Picks a key by weight.
@visibleForTesting
String drawWeightedKey(SeededRandom rng, Map<String, double> weights) {
  final total = weights.values.fold<double>(0, (sum, w) => sum + w);
  var roll = rng.nextDouble() * total;

  for (final entry in weights.entries) {
    roll -= entry.value;
    if (roll < 0) return entry.key;
  }

  return weights.keys.last;
}
