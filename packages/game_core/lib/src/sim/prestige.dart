import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:game_core/src/state/prestige_state.dart';

/// Prestige currency a reset would award right now.
///
/// Formula: `(earnedThisRun[resource] / currencyBase) ^ currencyExponent`,
/// and zero below `currencyBase`.
///
/// The award is a function of what the run *produced*, not of what is left
/// unspent — rewarding the balance on hand would punish the player for buying
/// the upgrades the run exists to buy.
///
/// `currencyExponent` below 1 compresses runaway runs. That is what stops one
/// very long session from being worth more than several deliberate ones, which
/// is the difference between a loop the player chooses to repeat and a loop
/// they feel obliged to grind.
BigNum prestigeCurrencyFor(PlayerState state, BalanceConfig config) {
  final prestige = config.prestige;
  final earned = state.earnedThisRun[prestige.resource] ?? BigNum.zero;
  if (earned.isZero || earned.isNegative) return BigNum.zero;

  final ratio = earned / prestige.currencyBase;
  if (ratio <= BigNum.zero) return BigNum.zero;

  return ratio.pow(prestige.currencyExponent);
}

/// Production multiplier the accumulated prestige currency is worth.
///
/// Formula: `1 + currency * bonusPerPoint`.
///
/// Applied to every generator in `simulate`, which is what makes each run after
/// a reset faster than the one before it.
BigNum prestigeMultiplier(PrestigeState prestige, BalanceConfig config) {
  if (prestige.currency.isZero) return BigNum.one;
  return BigNum.one + prestige.currency * config.prestige.bonusPerPoint;
}

/// Resets the run, banking the prestige award.
///
/// Survives the reset: prestige currency, permanent upgrades, the reset count,
/// the player's identity and the clock. Wiped: resources, generators, upgrades
/// and the run tally.
///
/// Throws [StateError] when the reset would award nothing. Without that a
/// player could reset repeatedly at no cost and watch the counter climb with no
/// progress behind it — and every one of those resets would be a write the
/// server has to process.
PlayerState applyPrestige(PlayerState state, BalanceConfig config) {
  final award = prestigeCurrencyFor(state, config);
  if (award.isZero || award.isNegative) {
    throw StateError(
      'prestige would award nothing; this run has not earned enough of '
      '"${config.prestige.resource}" yet',
    );
  }

  return state.copyWith(
    resources: const {},
    generators: const {},
    upgrades: const {},
    earnedThisRun: const {},
    carryOverMs: 0,
    prestige: state.prestige.copyWith(
      currency: state.prestige.currency + award,
      resets: state.prestige.resets + 1,
    ),
  );
}
