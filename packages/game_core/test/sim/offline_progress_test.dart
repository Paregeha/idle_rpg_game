import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

const _startedAtMs = 1770000000000;

BalanceConfig config({Duration cap = const Duration(hours: 8)}) =>
    BalanceConfig(
      offlineCapMs: cap.inMilliseconds,
      generators: const {
        // 1 gold per second per unit owned.
        'miner': GeneratorConfig(
          produces: 'gold',
          baseRatePerSecond: BigNum.one,
        ),
      },
    );

PlayerState state({int owned = 1, int carryOverMs = 0}) => PlayerState(
  lastTickAtMs: _startedAtMs,
  rngSeed: 42,
  carryOverMs: carryOverMs,
  generators: {'miner': GeneratorState(owned: owned)},
);

BigNum goldFor(Duration d) => BigNum.fromDouble(d.inSeconds.toDouble());

void main() {
  group('the cap', () {
    test(
      'three days away at an eight hour cap credits exactly eight hours',
      () {
        final report = applyOfflineProgress(
          state(),
          nowMs: _startedAtMs + const Duration(days: 3).inMilliseconds,
          config: config(),
        );

        expect(report.creditedFor, const Duration(hours: 8));
        expect(report.gains['gold'], goldFor(const Duration(hours: 8)));
        expect(report.wasCapped, isTrue);
      },
    );

    test('a short absence is credited in full', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs + const Duration(minutes: 30).inMilliseconds,
        config: config(),
      );

      expect(report.creditedFor, const Duration(minutes: 30));
      expect(report.gains['gold'], goldFor(const Duration(minutes: 30)));
      expect(report.wasCapped, isFalse);
    });

    test('an absence exactly at the cap is not treated as capped', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs + const Duration(hours: 8).inMilliseconds,
        config: config(),
      );

      expect(report.creditedFor, const Duration(hours: 8));
      expect(report.wasCapped, isFalse);
    });

    test('the cap comes from the config, not from code', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs + const Duration(days: 1).inMilliseconds,
        config: config(cap: const Duration(hours: 2)),
      );

      expect(report.creditedFor, const Duration(hours: 2));
    });

    test('a VIP multiplier extends the cap', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs + const Duration(days: 3).inMilliseconds,
        config: config(),
        capMultiplier: 2,
      );

      expect(report.creditedFor, const Duration(hours: 16));
      expect(report.gains['gold'], goldFor(const Duration(hours: 16)));
    });

    test('the multiplier cannot shrink the cap below zero', () {
      expect(
        () => applyOfflineProgress(
          state(),
          nowMs: _startedAtMs + 1000,
          config: config(),
          capMultiplier: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('time bookkeeping', () {
    test('the clock is caught up even when the payout was capped', () {
      final nowMs = _startedAtMs + const Duration(days: 3).inMilliseconds;

      final report = applyOfflineProgress(
        state(),
        nowMs: nowMs,
        config: config(),
      );

      expect(
        report.state.lastTickAtMs,
        nowMs,
        reason:
            'unclaimed time must not stay owed, or the next call would '
            'pay it out again',
      );
    });

    test('capped time is discarded, not carried', () {
      final nowMs = _startedAtMs + const Duration(days: 3).inMilliseconds;
      final first = applyOfflineProgress(
        state(),
        nowMs: nowMs,
        config: config(),
      );

      // Immediately coming back must not release more of the lost time.
      final second = applyOfflineProgress(
        first.state,
        nowMs: nowMs,
        config: config(),
      );

      expect(second.gains, isEmpty);
      expect(second.creditedFor, Duration.zero);
    });

    test('two absences in a row are each capped on their own', () {
      final firstReturn = _startedAtMs + const Duration(days: 3).inMilliseconds;
      final first = applyOfflineProgress(
        state(),
        nowMs: firstReturn,
        config: config(),
      );

      final secondReturn = firstReturn + const Duration(days: 3).inMilliseconds;
      final second = applyOfflineProgress(
        first.state,
        nowMs: secondReturn,
        config: config(),
      );

      expect(second.creditedFor, const Duration(hours: 8));
      expect(
        second.state.resources['gold'],
        goldFor(const Duration(hours: 16)),
      );
    });

    test('sub-second carry-over is preserved when nothing is capped', () {
      final report = applyOfflineProgress(
        state(carryOverMs: 500),
        nowMs: _startedAtMs + 700,
        config: config(),
      );

      // 500 carried + 700 elapsed = 1200ms => one second paid, 200 carried.
      expect(report.gains['gold'], BigNum.one);
      expect(report.state.carryOverMs, 200);
    });

    test('carry-over is cleared when the payout was capped', () {
      final report = applyOfflineProgress(
        state(carryOverMs: 900),
        nowMs: _startedAtMs + const Duration(days: 3).inMilliseconds,
        config: config(),
      );

      expect(
        report.state.carryOverMs,
        0,
        reason:
            'carrying a remainder past the cap would let short repeated '
            'visits leak extra progress',
      );
    });
  });

  group('degenerate input', () {
    test('a clock that did not move credits nothing', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs,
        config: config(),
      );

      expect(report.creditedFor, Duration.zero);
      expect(report.gains, isEmpty);
      expect(report.state, state());
    });

    test('a clock that went backwards is refused, not paid', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs - const Duration(days: 1).inMilliseconds,
        config: config(),
      );

      expect(report.gains, isEmpty);
      expect(
        report.state.lastTickAtMs,
        _startedAtMs,
        reason: 'never move the state clock backwards on a bad timestamp',
      );
    });

    test('a player with no generators gets an empty report', () {
      final idle = state().copyWith(generators: const {});

      final report = applyOfflineProgress(
        idle,
        nowMs: _startedAtMs + const Duration(hours: 4).inMilliseconds,
        config: config(),
      );

      expect(report.gains, isEmpty);
      expect(report.creditedFor, const Duration(hours: 4));
    });
  });

  group('the report', () {
    test('says how long the player was actually away', () {
      final report = applyOfflineProgress(
        state(),
        nowMs: _startedAtMs + const Duration(days: 3).inMilliseconds,
        config: config(),
      );

      expect(report.awayFor, const Duration(days: 3));
      expect(report.creditedFor, const Duration(hours: 8));
    });

    test('lists gains per resource for the welcome-back screen', () {
      final twoGenerators = state().copyWith(
        generators: const {
          'miner': GeneratorState(owned: 2),
          'gemmer': GeneratorState(owned: 1),
        },
      );
      final withGems = BalanceConfig(
        offlineCapMs: const Duration(hours: 8).inMilliseconds,
        generators: {
          ...config().generators,
          'gemmer': const GeneratorConfig(
            produces: 'gems',
            baseRatePerSecond: BigNum.one,
          ),
        },
      );

      final report = applyOfflineProgress(
        twoGenerators,
        nowMs: _startedAtMs + const Duration(minutes: 1).inMilliseconds,
        config: withGems,
      );

      expect(report.gains['gold'], BigNum.fromDouble(120));
      expect(report.gains['gems'], BigNum.fromDouble(60));
    });
  });
}
