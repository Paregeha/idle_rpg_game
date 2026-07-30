import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Accumulating 3600 additions and doing one multiplication are different
/// floating-point journeys to the same number, so the acceptance criterion for
/// T-013 allows 1e-6 relative error rather than bit equality.
Matcher closeToBigNum(BigNum expected, {double tolerance = 1e-6}) {
  return predicate<BigNum>((actual) {
    if (expected.isZero) return actual.isZero;
    return ((actual - expected).abs() / expected.abs()).toDouble() <= tolerance;
  }, 'within $tolerance relative error of ${expected.format()}');
}

BalanceConfig config() => BalanceConfig(
  generators: {
    // 1 gold/second per unit owned, doubling with each level.
    'miner': const GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
      levelMultiplier: 2,
    ),
    'gemmer': GeneratorConfig(
      produces: 'gems',
      baseRatePerSecond: BigNum(5, -1),
      levelMultiplier: 1.5,
    ),
  },
);

PlayerState state({
  int owned = 1,
  int level = 0,
  int carryOverMs = 0,
  Map<String, BigNum>? resources,
}) => PlayerState(
  lastTickAtMs: 1770000000000,
  rngSeed: 42,
  carryOverMs: carryOverMs,
  resources: resources ?? const {},
  generators: {'miner': GeneratorState(level: level, owned: owned)},
);

void main() {
  group('contract', () {
    test('a non-positive dt changes nothing', () {
      final before = state(owned: 5);

      expect(simulate(before, Duration.zero, config()).state, before);
      expect(
        simulate(before, const Duration(seconds: -10), config()).state,
        before,
      );
    });

    test('is pure: the input state is never mutated', () {
      final before = state(owned: 5);
      final snapshot = before.toJson();

      simulate(before, const Duration(hours: 3), config());

      expect(before.toJson(), snapshot);
    });

    test('advances lastTickAtMs by the elapsed time', () {
      final result = simulate(state(), const Duration(minutes: 5), config());

      expect(
        result.state.lastTickAtMs,
        1770000000000 + const Duration(minutes: 5).inMilliseconds,
      );
    });

    test('reports what was gained', () {
      final result = simulate(
        state(owned: 3),
        const Duration(seconds: 10),
        config(),
      );

      expect(result.gains['gold'], BigNum.fromDouble(30));
    });

    test('a generator the config does not know is ignored, not fatal', () {
      final unknown = state().copyWith(
        generators: {'ghost': const GeneratorState(level: 1, owned: 99)},
      );

      final result = simulate(unknown, const Duration(hours: 1), config());

      expect(result.gains, isEmpty);
    });
  });

  group('production', () {
    test('accrues linearly with time', () {
      final result = simulate(
        state(owned: 2),
        const Duration(seconds: 60),
        config(),
      );

      expect(result.state.resources['gold'], BigNum.fromDouble(120));
    });

    test('scales with how many are owned', () {
      final one = simulate(state(), const Duration(seconds: 10), config());
      final ten = simulate(
        state(owned: 10),
        const Duration(seconds: 10),
        config(),
      );

      expect(ten.state.resources['gold'], BigNum.fromDouble(100));
      expect(one.state.resources['gold'], BigNum.fromDouble(10));
    });

    test('level multiplies the rate', () {
      // level 3 with multiplier 2 => 8x
      final result = simulate(
        state(level: 3),
        const Duration(seconds: 10),
        config(),
      );

      expect(result.state.resources['gold'], BigNum.fromDouble(80));
    });

    test('adds onto resources already held', () {
      final result = simulate(
        state(resources: {'gold': BigNum.fromDouble(100)}),
        const Duration(seconds: 5),
        config(),
      );

      expect(result.state.resources['gold'], BigNum.fromDouble(105));
    });

    test('several generators produce into their own resources', () {
      final twoGenerators = state().copyWith(
        generators: {
          'miner': const GeneratorState(owned: 1),
          'gemmer': const GeneratorState(owned: 4),
        },
      );

      final result = simulate(
        twoGenerators,
        const Duration(seconds: 10),
        config(),
      );

      expect(result.state.resources['gold'], BigNum.fromDouble(10));
      expect(result.state.resources['gems'], BigNum.fromDouble(20));
    });

    test('reaches magnitudes double could not hold', () {
      // level 200 with multiplier 2 is about 1.6e60 per second.
      final result = simulate(
        state(level: 200),
        const Duration(seconds: 1),
        config(),
      );

      expect(result.state.resources['gold']!.exponent, greaterThan(59));
    });
  });

  group('fixed steps and carry-over', () {
    test('a partial second pays nothing yet but is remembered', () {
      final result = simulate(
        state(),
        const Duration(milliseconds: 400),
        config(),
      );

      expect(result.state.resources['gold'], isNull);
      expect(result.state.carryOverMs, 400);
    });

    test('carried milliseconds complete a second later', () {
      var s = state();
      for (var i = 0; i < 5; i++) {
        s = simulate(s, const Duration(milliseconds: 400), config()).state;
      }

      // 5 x 400ms = 2000ms => exactly 2 seconds paid, nothing carried.
      expect(s.resources['gold'], BigNum.fromDouble(2));
      expect(s.carryOverMs, 0);
    });

    test('many tiny ticks do not drift away from one big tick', () {
      // 30 Hz for an hour, the client's real tick rate.
      var stepped = state();
      const tick = Duration(milliseconds: 33);
      var elapsed = 0;
      while (elapsed + tick.inMilliseconds <=
          const Duration(hours: 1).inMilliseconds) {
        stepped = simulate(stepped, tick, config()).state;
        elapsed += tick.inMilliseconds;
      }

      final atOnce = simulate(
        state(),
        Duration(milliseconds: elapsed),
        config(),
      ).state;

      expect(
        stepped.resources['gold'],
        closeToBigNum(atOnce.resources['gold']!),
      );
      expect(stepped.carryOverMs, atOnce.carryOverMs);
    });

    test('one hour matches 3600 one-second calls', () {
      var stepped = state(owned: 7, level: 2);
      for (var i = 0; i < 3600; i++) {
        stepped = simulate(stepped, const Duration(seconds: 1), config()).state;
      }

      final atOnce = simulate(
        state(owned: 7, level: 2),
        const Duration(hours: 1),
        config(),
      ).state;

      expect(
        stepped.resources['gold'],
        closeToBigNum(atOnce.resources['gold']!),
      );
      expect(stepped.lastTickAtMs, atOnce.lastTickAtMs);
    });

    test('carry-over never reaches a whole second', () {
      var s = state();
      for (var i = 0; i < 200; i++) {
        s = simulate(s, const Duration(milliseconds: 137), config()).state;
        expect(s.carryOverMs, lessThan(1000));
        expect(s.carryOverMs, greaterThanOrEqualTo(0));
      }
    });
  });

  group('long spans stay cheap', () {
    test('thirty days simulate in well under 50 ms', () {
      final start = state(owned: 25, level: 5);
      final stopwatch = Stopwatch()..start();

      final result = simulate(start, const Duration(days: 30), config());

      stopwatch.stop();
      expect(result.state.resources['gold'], isNotNull);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(50),
        reason: 'a linear generator must use a closed form, not 2.6M steps',
      );
    });

    test('cost does not grow with the span', () {
      final start = state(owned: 25, level: 5);

      final shortRun = Stopwatch()..start();
      simulate(start, const Duration(seconds: 1), config());
      shortRun.stop();

      final longRun = Stopwatch()..start();
      simulate(start, const Duration(days: 365), config());
      longRun.stop();

      expect(
        longRun.elapsedMicroseconds,
        lessThan(shortRun.elapsedMicroseconds + 5000),
        reason: 'a year must not cost meaningfully more than a second',
      );
    });

    test('a year of progress is still exact', () {
      final result = simulate(state(), const Duration(days: 365), config());

      expect(
        result.state.resources['gold'],
        BigNum.fromDouble(const Duration(days: 365).inSeconds.toDouble()),
      );
    });
  });
}
