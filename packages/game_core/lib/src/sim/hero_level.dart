import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// What granting experience did.
@immutable
class LevelUpResult {
  const LevelUpResult({required this.state, required this.levelsGained});

  final PlayerState state;

  /// How many levels the hero went up. Zero is the common case.
  ///
  /// Reported so the UI can celebrate a level-up. A level that happens
  /// silently is one the player never notices they earned.
  final int levelsGained;

  bool get leveledUp => levelsGained > 0;
}

/// Adds [amount] experience and applies any levels it earns.
///
/// Multiple levels at once are normal — a player returning from a long absence,
/// or one who just upgraded their gear, can clear several in a single kill. The
/// loop is bounded so a misconfigured curve cannot hang the game.
LevelUpResult grantExperience(
  PlayerState state,
  BigNum amount,
  BalanceConfig config,
) {
  if (amount.isZero || amount.isNegative) {
    return LevelUpResult(state: state, levelsGained: 0);
  }

  var level = state.heroLevel;
  var banked = state.heroExperience + amount;
  var gained = 0;

  // A level curve that never rises would otherwise loop forever; the validator
  // rejects that, and this bound makes a bad config slow rather than fatal.
  const maxLevelsPerGrant = 1000;

  while (gained < maxLevelsPerGrant) {
    final needed = config.hero.expForLevel(level);
    if (needed.isZero || needed.isNegative || banked < needed) break;

    banked -= needed;
    level++;
    gained++;
  }

  return LevelUpResult(
    state: state.copyWith(heroLevel: level, heroExperience: banked),
    levelsGained: gained,
  );
}

/// How far the hero is towards the next level, in `0..1`.
///
/// For a progress bar. Computed in [BigNum] and collapsed to a double only at
/// the end, because the requirement outgrows a double within a few dozen
/// levels.
double levelProgress(PlayerState state, BalanceConfig config) {
  final needed = config.hero.expForLevel(state.heroLevel);
  if (needed.isZero || needed.isNegative) return 0;
  if (state.heroExperience >= needed) return 1;

  return (state.heroExperience / needed).toDouble().clamp(0.0, 1.0);
}
