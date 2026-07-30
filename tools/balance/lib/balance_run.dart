import 'package:balance_tools/player_profile.dart';
import 'package:game_core/game_core.dart';

/// One day of a modelled playthrough.
class DayReport {
  const DayReport({
    required this.day,
    required this.resources,
    required this.unitsOwned,
    required this.prestigeCurrency,
    required this.timeToNextUpgrade,
    required this.offlineForfeited,
  });

  final int day;
  final Map<String, BigNum> resources;

  /// Total generator units owned — the closest thing to a "level" while the
  /// player's power is the sum of what they have built.
  final int unitsOwned;

  final BigNum prestigeCurrency;

  /// How long until the cheapest next unit is affordable at the current rate.
  /// Null when nothing is affordable in any reasonable time.
  final Duration? timeToNextUpgrade;

  /// Progress lost to the offline cap on this day.
  final Duration offlineForfeited;
}

/// Runs [days] of play for [profile] and returns one row per day.
///
/// The modelled player is deliberately greedy: whenever they are in a session
/// they buy as much as they can afford, cheapest generator first. A real player
/// is worse at this, so these numbers are the optimistic edge of the curve —
/// which is the useful edge, because a balance that is too slow for this player
/// is far too slow for everyone else.
List<DayReport> runProfile({
  required PlayerProfile profile,
  required BalanceConfig config,
  required int days,
}) {
  var state = newGame(nowMs: 0, rngSeed: 1, config: config);
  final reports = <DayReport>[];

  for (var day = 1; day <= days; day++) {
    var forfeited = Duration.zero;

    for (var session = 0; session < profile.sessionsPerDay; session++) {
      // Come back after being away, then play.
      final away = session == 0
          ? profile.overnightGap
          : profile.gapBetweenSessions;

      final report = applyOfflineProgress(
        state,
        nowMs: state.lastTickAtMs + away.inMilliseconds,
        config: config,
        capMultiplier: profile.offlineCapMultiplier,
      );
      state = report.state;
      forfeited += report.forfeited;

      state = simulate(state, profile.sessionLength, config).state;
      state = _spendEverything(state, config);
    }

    reports.add(
      DayReport(
        day: day,
        resources: Map<String, BigNum>.of(state.resources),
        unitsOwned: state.generators.values.fold(0, (sum, g) => sum + g.owned),
        prestigeCurrency: prestigeCurrencyFor(state, config),
        timeToNextUpgrade: _timeToNextUpgrade(state, config),
        offlineForfeited: forfeited,
      ),
    );
  }

  return reports;
}

/// Buys until nothing more is affordable, cheapest generator first.
PlayerState _spendEverything(PlayerState state, BalanceConfig config) {
  var current = state;

  // Bounded so a pathological config cannot hang the tool.
  for (var pass = 0; pass < 1000; pass++) {
    var boughtAnything = false;

    final byPrice = config.generators.entries.toList()
      ..sort((a, b) {
        final ownedA = current.generators[a.key]?.owned ?? 0;
        final ownedB = current.generators[b.key]?.owned ?? 0;
        return a.value.costFor(ownedA).compareTo(b.value.costFor(ownedB));
      });

    for (final entry in byPrice) {
      final affordable = maxAffordable(current, entry.key, config);
      if (affordable == 0) continue;

      final result = buyGenerator(
        current,
        entry.key,
        config,
        count: affordable,
      );
      if (result.succeeded) {
        current = result.state;
        boughtAnything = true;
      }
    }

    if (!boughtAnything) break;
  }

  return current;
}

/// How long until the cheapest unaffordable unit can be bought.
Duration? _timeToNextUpgrade(PlayerState state, BalanceConfig config) {
  Duration? best;

  for (final entry in config.generators.entries) {
    final owned = state.generators[entry.key]?.owned ?? 0;
    final price = entry.value.costFor(owned);
    final balance = state.resources[entry.value.produces] ?? BigNum.zero;
    if (balance >= price) return Duration.zero;

    final rate = _incomeFor(entry.value.produces, state, config);
    if (rate.isZero || rate.isNegative) continue;

    final seconds = ((price - balance) / rate).toDouble();
    if (!seconds.isFinite || seconds > const Duration(days: 3650).inSeconds) {
      continue;
    }

    final wait = Duration(seconds: seconds.ceil());
    if (best == null || wait < best) best = wait;
  }

  return best;
}

BigNum _incomeFor(String resource, PlayerState state, BalanceConfig config) {
  var total = BigNum.zero;
  final bonus = prestigeMultiplier(state.prestige, config);

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
