import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// The fight the player is standing in front of.
@immutable
class Encounter {
  const Encounter({
    required this.monsterId,
    required this.level,
    required this.monsters,
    required this.isBoss,
    required this.reward,
    required this.experience,
  });

  final String monsterId;
  final int level;

  /// Everything in this wave. A boss fights alone.
  final List<CombatStats> monsters;

  final bool isBoss;

  /// Paid out for clearing the wave.
  final BigNum reward;

  /// Experience for clearing the wave.
  final BigNum experience;
}

/// Builds the encounter for wherever the player currently is.
///
/// Returns null when the config has no monsters to draw from, which is a
/// misconfiguration rather than a state a player can reach.
Encounter? encounterFor(PlayerState state, BalanceConfig config) {
  final progression = config.progression;
  final onBoss = state.wave >= progression.wavesPerStage;

  final monsterId = onBoss
      ? progression.bossFor(chapter: state.chapter, stage: state.stage)
      : progression.monsterFor(chapter: state.chapter, stage: state.stage);
  final monster = monsterId == null ? null : config.monsters[monsterId];
  if (monster == null) return null;

  final level =
      progression.levelFor(chapter: state.chapter, stage: state.stage) +
      (onBoss ? progression.bossLevelBonus : 0);

  final stats = CombatStats(
    attack: monster.attackFor(level),
    maxHp: monster.hpFor(level),
    attacksPerSecond: monster.attacksPerSecond,
    mitigation: monster.mitigation,
    dodgeChance: monster.dodgeChance,
  );

  // A boss stands alone; ordinary waves come as a group, which is what gives
  // an area skill something to hit.
  final count = onBoss ? 1 : progression.monstersPerWave;
  final group = BigNum.fromDouble(count.toDouble());
  final reward = monster.rewardFor(level) * group;
  final experience = monster.expFor(level) * group;

  return Encounter(
    monsterId: monsterId!,
    level: level,
    monsters: List<CombatStats>.filled(count, stats),
    isBoss: onBoss,
    reward: reward,
    experience: experience,
  );
}

/// Moves the player forward after a won fight.
///
/// Advancement is automatic: clearing a wave moves to the next, clearing the
/// boss opens the next stage, and stages roll into chapters. A player never
/// picks a stage from a list, so there is no way to be stuck on a screen
/// wondering what to press.
PlayerState advanceAfterWin(PlayerState state, BalanceConfig config) {
  final progression = config.progression;

  if (state.wave < progression.wavesPerStage) {
    return state.copyWith(wave: state.wave + 1);
  }

  // The boss is down: next stage.
  if (state.stage < progression.stagesPerChapter) {
    return state.copyWith(stage: state.stage + 1, wave: 0);
  }

  return state.copyWith(chapter: state.chapter + 1, stage: 1, wave: 0);
}

/// What happens after a loss.
///
/// The player repeats the wave rather than being pushed back. Losing already
/// costs time, and in an idle game the fix is to go build something — taking
/// progress away on top of that reads as punishment for playing.
PlayerState afterLoss(PlayerState state, BalanceConfig config) => state;

/// A readable label for the current position, e.g. `3-7`.
String stageLabel(PlayerState state) => '${state.chapter}-${state.stage}';
