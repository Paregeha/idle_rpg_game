@TestOn('vm')
library;

import 'dart:io';

import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Guards the balance file that actually ships.
///
/// The validator is only useful if the file we hand to players goes through it,
/// so this loads the real asset rather than a fixture. VM-only: the core test
/// suite also runs compiled to JavaScript, where there is no filesystem.
void main() {
  late BalanceConfig config;

  setUpAll(() {
    config = BalanceConfig.parse(
      File('assets/balance/v1.json').readAsStringSync(),
    );
  });

  test('the shipped config is valid', () {
    expect(config.version, supportedBalanceVersion);
    expect(config.generators, isNotEmpty);
    expect(config.monsters, isNotEmpty);
  });

  test('the offline cap is the eight hours the design calls for', () {
    expect(config.offlineCapMs, const Duration(hours: 8).inMilliseconds);
  });

  test('every generator produces a resource some generator can pay for', () {
    final produced = config.generators.values.map((g) => g.produces).toSet();

    expect(produced, contains('gold'));
  });

  test('later generators cost more and produce more than earlier ones', () {
    final gold =
        config.generators.entries
            .where((e) => e.value.produces == 'gold')
            .toList()
          ..sort((a, b) => a.value.costBase.compareTo(b.value.costBase));

    for (var i = 1; i < gold.length; i++) {
      final previous = gold[i - 1].value;
      final current = gold[i].value;

      expect(
        current.baseRatePerSecond > previous.baseRatePerSecond,
        isTrue,
        reason:
            '${gold[i].key} costs more than ${gold[i - 1].key} but does '
            'not produce more',
      );
    }
  });

  test('monster health outgrows its reward', () {
    // If rewards grew at least as fast as health, pushing deeper would be a
    // free upgrade and the player would never need to build anything.
    for (final entry in config.monsters.entries) {
      expect(
        entry.value.hpGrowth,
        greaterThan(entry.value.rewardGrowth),
        reason: '${entry.key} pays out faster than it gets harder',
      );
    }
  });

  test('prestige actually pays off', () {
    expect(config.prestige.bonusPerPoint > BigNum.zero, isTrue);
    expect(config.prestige.currencyExponent, lessThanOrEqualTo(1));
    expect(
      config.generators.keys,
      contains(anything),
      reason: 'the prestige resource must be something a generator produces',
    );
    expect(
      config.generators.values.map((g) => g.produces),
      contains(config.prestige.resource),
    );
  });

  test('every generator can actually be bought', () {
    // A generator priced in what it produces can only be bought with its own
    // output, so the first one is unreachable forever. The gem shrine was
    // exactly that until the forge screen showed "no income yet" beside a pile
    // of gold.
    final produced = config.generators.values.map((g) => g.produces).toSet();

    for (final entry in config.generators.entries) {
      final generator = entry.value;
      if (generator.pricedIn != generator.produces) continue;

      final othersProduceIt = config.generators.entries.any(
        (other) =>
            other.key != entry.key &&
            other.value.produces == generator.pricedIn,
      );
      final grantedAtStart = config.start.generators.containsKey(entry.key);

      expect(
        othersProduceIt || grantedAtStart,
        isTrue,
        reason:
            '${entry.key} costs the ${generator.pricedIn} only it produces, '
            'so a player can never buy the first one',
      );
    }

    expect(produced, isNotEmpty);
  });

  test('drop chances are sane probabilities', () {
    for (final entry in config.monsters.entries) {
      expect(entry.value.dropChance, inInclusiveRange(0, 1));
    }
  });

  test('a first upgrade is reachable in the first minute of play', () {
    // The tutorial (T-065) has 90 seconds to get the player to their first
    // purchase. The cheapest generator has to fit inside that.
    final cheapest = config.generators.values
        .map((g) => g.costBase)
        .reduce((a, b) => a < b ? a : b);

    expect(cheapest.toDouble(), lessThanOrEqualTo(10));
  });
}
