import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  generators: const {
    'miner': GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
    ),
  },
  prestige: PrestigeConfig(
    currencyBase: BigNum.fromDouble(100),
    bonusPerPoint: BigNum.fromDouble(0.1),
  ),
);

PlayerState state({int owned = 1}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 42,
  generators: {'miner': GeneratorState(owned: owned)},
);

void main() {
  group('earning towards a prestige', () {
    test('the run tracks what it earned, separately from what is held', () {
      final result = simulate(state(), const Duration(seconds: 10), config());

      expect(result.state.resources['gold'], BigNum.fromDouble(10));
      expect(result.state.earnedThisRun['gold'], BigNum.fromDouble(10));
    });

    test('spending does not reduce what the run earned', () {
      final earned = simulate(state(), const Duration(seconds: 10), config());
      final spent = earned.state.copyWith(resources: const {});

      expect(spent.earnedThisRun['gold'], BigNum.fromDouble(10));
    });
  });

  group('the prestige currency formula', () {
    test('is (earned / base) ^ exponent', () {
      // 10 000 earned, base 100, exponent 0.5 => sqrt(100) = 10
      final earned = state().copyWith(
        earnedThisRun: {'gold': BigNum.fromDouble(10000)},
      );

      expect(prestigeCurrencyFor(earned, config()), BigNum.fromDouble(10));
    });

    test('pays nothing below the base', () {
      final earned = state().copyWith(
        earnedThisRun: {'gold': BigNum.fromDouble(50)},
      );

      expect(prestigeCurrencyFor(earned, config()).toDouble(), lessThan(1));
    });

    test('pays nothing for a run that earned nothing', () {
      expect(prestigeCurrencyFor(state(), config()), BigNum.zero);
    });

    test('grows with the run, never shrinks', () {
      var previous = BigNum.zero;

      for (var earned = 100.0; earned < 1e9; earned *= 3) {
        final award = prestigeCurrencyFor(
          state().copyWith(earnedThisRun: {'gold': BigNum.fromDouble(earned)}),
          config(),
        );

        expect(award >= previous, isTrue);
        previous = award;
      }
    });

    test('handles magnitudes a double could not', () {
      final huge = state().copyWith(earnedThisRun: {'gold': BigNum(1, 200)});

      expect(prestigeCurrencyFor(huge, config()).exponent, 99);
    });
  });

  group('resetting', () {
    test('keeps prestige currency, adds the new award', () {
      final earned = state().copyWith(
        earnedThisRun: {'gold': BigNum.fromDouble(10000)},
        prestige: PrestigeState(currency: BigNum.fromDouble(5)),
      );

      final after = applyPrestige(earned, config());

      expect(after.prestige.currency, BigNum.fromDouble(15));
      expect(after.prestige.resets, 1);
    });

    test('keeps permanent upgrades', () {
      final earned = state().copyWith(
        earnedThisRun: {'gold': BigNum.fromDouble(10000)},
        prestige: const PrestigeState(permanentUpgrades: {'greed': 3}),
      );

      final after = applyPrestige(earned, config());

      expect(after.prestige.permanentUpgrades, {'greed': 3});
    });

    test('wipes resources, generators, upgrades and the run tally', () {
      final played = simulate(
        state(owned: 5),
        const Duration(hours: 1),
        config(),
      ).state.copyWith(upgrades: const {'pickaxe': 2});

      final after = applyPrestige(played, config());

      expect(after.resources, isEmpty);
      expect(after.generators, isEmpty);
      expect(after.upgrades, isEmpty);
      expect(after.earnedThisRun, isEmpty);
    });

    test('keeps identity and the clock', () {
      final played = simulate(
        state(),
        const Duration(hours: 1),
        config(),
      ).state;

      final after = applyPrestige(played, config());

      expect(after.lastTickAtMs, played.lastTickAtMs);
      expect(after.rngSeed, played.rngSeed);
      expect(after.version, played.version);
      expect(after.carryOverMs, 0);
    });

    test('refuses a reset that would award nothing', () {
      // Otherwise a player could reset repeatedly at zero cost and the counter
      // would climb without any progress behind it.
      expect(
        () => applyPrestige(state(), config()),
        throwsA(isA<StateError>()),
      );
    });

    test('is pure', () {
      final earned = state().copyWith(
        earnedThisRun: {'gold': BigNum.fromDouble(10000)},
      );
      final snapshot = earned.toJson();

      applyPrestige(earned, config());

      expect(earned.toJson(), snapshot);
    });
  });

  group('the bonus', () {
    test('is 1 with no prestige currency', () {
      expect(prestigeMultiplier(const PrestigeState(), config()), BigNum.one);
    });

    test('is 1 + currency * bonusPerPoint', () {
      final prestige = PrestigeState(currency: BigNum.fromDouble(10));

      expect(prestigeMultiplier(prestige, config()), BigNum.fromDouble(2));
    });

    test('speeds up production in the simulation', () {
      final fresh = simulate(state(), const Duration(seconds: 10), config());
      final veteran = simulate(
        state().copyWith(
          prestige: PrestigeState(currency: BigNum.fromDouble(10)),
        ),
        const Duration(seconds: 10),
        config(),
      );

      expect(
        veteran.state.resources['gold'],
        BigNum.fromDouble(20),
      );
      expect(fresh.state.resources['gold'], BigNum.fromDouble(10));
    });
  });

  group('ten cycles in a row', () {
    test('never break the state and each run is faster than the last', () {
      const runLength = Duration(hours: 2);
      var current = state(owned: 10);
      var previousEarned = BigNum.zero;
      var previousCurrency = BigNum.zero;

      for (var cycle = 0; cycle < 10; cycle++) {
        final played = simulate(current, runLength, config()).state;
        final earned = played.earnedThisRun['gold']!;

        expect(
          earned > previousEarned,
          isTrue,
          reason: 'cycle $cycle earned no more than the one before it',
        );

        final after = applyPrestige(played, config());

        expect(after.prestige.resets, cycle + 1);
        expect(after.prestige.currency > previousCurrency, isTrue);
        expect(after.resources, isEmpty);
        expect(after.earnedThisRun, isEmpty);
        // The state must stay loadable after every reset.
        expect(PlayerState.fromJson(after.toJson()), after);

        previousEarned = earned;
        previousCurrency = after.prestige.currency;
        // Rebuild the same generators to start the next run.
        current = after.copyWith(
          generators: const {'miner': GeneratorState(owned: 10)},
        );
      }
    });
  });
}
