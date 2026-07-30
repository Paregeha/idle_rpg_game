import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Subtracting across magnitudes is not exact — `100 - 70` lands on
/// `30.000000000000004`, because `1 - 0.7` is not exact in a double mantissa.
/// Invisible to a player (the formatter rounds it away) and irrelevant to the
/// economy, but worth asserting honestly rather than pretending otherwise.
Matcher closeToBigNum(BigNum expected, {double tolerance = 1e-9}) {
  return predicate<BigNum>((actual) {
    if (expected.isZero) return actual.isZero;
    return ((actual - expected).abs() / expected.abs()).toDouble() <= tolerance;
  }, 'within $tolerance of ${expected.format()}');
}

BalanceConfig config() => BalanceConfig(
  generators: {
    'miner': GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
      costBase: BigNum.fromDouble(10),
      costGrowth: 2,
    ),
  },
);

PlayerState state({double gold = 0, int owned = 0}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  resources: {'gold': BigNum.fromDouble(gold)},
  generators: {'miner': GeneratorState(owned: owned)},
);

void main() {
  group('affordability', () {
    test('counts how many can be bought', () {
      // 10 + 20 + 40 = 70
      expect(maxAffordable(state(gold: 70), 'miner', config()), 3);
      expect(maxAffordable(state(gold: 69), 'miner', config()), 2);
    });

    test('is zero when the first unit is out of reach', () {
      expect(maxAffordable(state(gold: 9), 'miner', config()), 0);
    });

    test('accounts for what is already owned', () {
      // owned 2 => next costs 40, then 80
      expect(maxAffordable(state(gold: 120, owned: 2), 'miner', config()), 2);
    });

    test('is zero for a generator the config does not know', () {
      expect(maxAffordable(state(gold: 1000000000), 'ghost', config()), 0);
    });

    test('copes with a balance far beyond double', () {
      final rich = state().copyWith(resources: {'gold': BigNum(1, 60)});

      expect(maxAffordable(rich, 'miner', config()), greaterThan(190));
    });
  });

  group('buying', () {
    test('deducts the cost and adds the units', () {
      final result = buyGenerator(state(gold: 100), 'miner', config());

      expect(result.bought, 1);
      expect(result.spent, BigNum.fromDouble(10));
      expect(result.state.resources['gold'], BigNum.fromDouble(90));
      expect(result.state.generators['miner']!.owned, 1);
    });

    test('buys several at the summed price', () {
      final result = buyGenerator(
        state(gold: 100),
        'miner',
        config(),
        count: 3,
      );

      expect(result.bought, 3);
      expect(result.spent, closeToBigNum(BigNum.fromDouble(70)));
      expect(
        result.state.resources['gold'],
        closeToBigNum(BigNum.fromDouble(30)),
      );
    });

    test('refuses when the player cannot afford it', () {
      final result = buyGenerator(state(gold: 5), 'miner', config());

      expect(result.bought, 0);
      expect(result.spent, BigNum.zero);
      expect(result.state, state(gold: 5), reason: 'nothing may change');
    });

    test('refuses a partial purchase rather than buying what fits', () {
      // Asking for 3 with only enough for 2 buys nothing: a client that asked
      // for 3 and silently got 2 would show the wrong thing.
      final result = buyGenerator(state(gold: 30), 'miner', config(), count: 3);

      expect(result.bought, 0);
      expect(result.state.resources['gold'], BigNum.fromDouble(30));
    });

    test('refuses an unknown generator', () {
      final result = buyGenerator(state(gold: 1000000000), 'ghost', config());

      expect(result.bought, 0);
    });

    test('refuses a non-positive count', () {
      expect(
        () => buyGenerator(state(gold: 100), 'miner', config(), count: 0),
        throwsArgumentError,
      );
    });

    test('is pure', () {
      final before = state(gold: 100);
      final snapshot = before.toJson();

      buyGenerator(before, 'miner', config());

      expect(before.toJson(), snapshot);
    });

    test('buying does not count towards the prestige award', () {
      // earnedThisRun tracks production, not the balance moving around.
      final result = buyGenerator(state(gold: 100), 'miner', config());

      expect(result.state.earnedThisRun, isEmpty);
    });

    test('buying max spends everything it can and no more', () {
      final howMany = maxAffordable(state(gold: 70), 'miner', config());
      final result = buyGenerator(
        state(gold: 70),
        'miner',
        config(),
        count: howMany,
      );

      expect(result.bought, 3);
      expect(result.state.resources['gold'], BigNum.zero);
      expect(maxAffordable(result.state, 'miner', config()), 0);
    });
  });
}
