import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/sim/prestige.dart';
import 'package:game_core/src/state/player_state.dart';

/// Current income per second for [resource], including the prestige bonus.
BigNum incomePerSecond(
  PlayerState state,
  BalanceConfig config,
  String resource,
) {
  final bonus = prestigeMultiplier(state.prestige, config);
  var total = BigNum.zero;

  for (final entry in state.generators.entries) {
    final generator = config.generators[entry.key];
    if (generator == null || generator.produces != resource) continue;

    total +=
        generator.ratePerSecond(
          owned: entry.value.owned,
          level: entry.value.level,
        ) *
        bonus;
  }

  return total;
}

/// How long until the player can afford the next unit of [generatorId].
///
/// `Duration.zero` when it is already affordable, and null when there is no
/// income for that resource — in which case the honest answer is "never", not
/// a very large number that looks like a real estimate.
///
/// This is the single most useful number on an upgrade screen: it tells the
/// player whether to wait or to close the app, which in an idle game is the
/// actual decision they are making.
Duration? timeToAfford({
  required PlayerState state,
  required BalanceConfig config,
  required String generatorId,
  int count = 1,
}) {
  final generator = config.generators[generatorId];
  if (generator == null || count <= 0) return null;

  final owned = state.generators[generatorId]?.owned ?? 0;
  final price = generator.bulkCost(owned: owned, count: count);
  final balance = state.resources[generator.pricedIn] ?? BigNum.zero;
  if (balance >= price) return Duration.zero;

  final rate = incomePerSecond(state, config, generator.pricedIn);
  if (rate.isZero || rate.isNegative) return null;

  final seconds = ((price - balance) / rate).toDouble();
  if (!seconds.isFinite || seconds < 0) return null;

  // Past a point the number stops being information and starts being noise;
  // the UI shows "a long time" instead of a precise count of years.
  const cap = Duration(days: 3650);
  if (seconds > cap.inSeconds) return cap;

  return Duration(seconds: seconds.ceil());
}

/// A short, human reading of a wait.
///
/// Rounds to one unit on purpose: a player deciding whether to wait does not
/// need "2h 14m 09s", and the extra precision would change several times a
/// second as income ticks up.
String formatWait(Duration wait) {
  if (wait <= Duration.zero) return 'now';
  if (wait.inSeconds < 60) return '${wait.inSeconds}s';
  if (wait.inMinutes < 60) return '${wait.inMinutes}m';
  if (wait.inHours < 48) return '${wait.inHours}h';
  if (wait.inDays < 365) return '${wait.inDays}d';
  return 'a long time';
}
