import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  generators: {
    'miner': GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
      costBase: BigNum.fromDouble(100),
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
  group('income', () {
    test('sums the generators producing a resource', () {
      expect(
        incomePerSecond(state(owned: 7), config(), 'gold'),
        BigNum.fromDouble(7),
      );
    });

    test('is zero for a resource nothing produces', () {
      expect(incomePerSecond(state(owned: 7), config(), 'gems'), BigNum.zero);
    });

    test('includes the prestige bonus', () {
      final veteran = state(owned: 1).copyWith(
        prestige: PrestigeState(currency: BigNum.fromDouble(10)),
      );
      final withBonus = BalanceConfig(
        generators: config().generators,
        prestige: PrestigeConfig(bonusPerPoint: BigNum.fromDouble(0.1)),
      );

      expect(
        incomePerSecond(veteran, withBonus, 'gold'),
        BigNum.fromDouble(2),
      );
    });
  });

  group('time to afford', () {
    test('is zero when already affordable', () {
      expect(
        timeToAfford(
          state: state(gold: 200, owned: 1),
          config: config(),
          generatorId: 'miner',
        ),
        Duration.zero,
      );
    });

    test('divides the shortfall by income', () {
      // Owning one already, so the next costs 100 * 2^1 = 200. With 40 in
      // hand and one unit earning 1/s, that is 160 seconds.
      expect(
        timeToAfford(
          state: state(gold: 40, owned: 1),
          config: config(),
          generatorId: 'miner',
        ),
        const Duration(seconds: 160),
      );
    });

    test('is null with no income, rather than a huge number', () {
      // "Never" is the honest answer; a very large number looks like an
      // estimate the player could wait out.
      expect(
        timeToAfford(
          state: state(),
          config: config(),
          generatorId: 'miner',
        ),
        isNull,
      );
    });

    test('accounts for a bulk purchase', () {
      final single = timeToAfford(
        state: state(owned: 1),
        config: config(),
        generatorId: 'miner',
      );
      final ten = timeToAfford(
        state: state(owned: 1),
        config: config(),
        generatorId: 'miner',
        count: 10,
      );

      expect(ten, greaterThan(single!));
    });

    test('is null for a generator the config does not know', () {
      expect(
        timeToAfford(
          state: state(owned: 1),
          config: config(),
          generatorId: 'ghost',
        ),
        isNull,
      );
    });

    test('caps absurd waits instead of reporting centuries', () {
      final crawling = state(owned: 1).copyWith(
        generators: const {'miner': GeneratorState(owned: 1)},
        resources: {'gold': BigNum.zero},
      );
      final expensive = BalanceConfig(
        generators: {
          'miner': GeneratorConfig(
            produces: 'gold',
            baseRatePerSecond: BigNum.one,
            costBase: BigNum(1, 30),
            costGrowth: 2,
          ),
        },
      );

      expect(
        timeToAfford(
          state: crawling,
          config: expensive,
          generatorId: 'miner',
        ),
        const Duration(days: 3650),
      );
    });
  });

  group('formatting a wait', () {
    test('rounds to a single unit', () {
      expect(formatWait(Duration.zero), 'now');
      expect(formatWait(const Duration(seconds: 45)), '45s');
      expect(formatWait(const Duration(minutes: 5)), '5m');
      expect(formatWait(const Duration(hours: 3)), '3h');
      expect(formatWait(const Duration(days: 4)), '4d');
      expect(formatWait(const Duration(days: 3650)), 'a long time');
    });

    test('never shows a precision that changes every second', () {
      // The digits would tick constantly as income accrues, which is motion
      // without information.
      expect(
        formatWait(const Duration(hours: 2, minutes: 14, seconds: 9)),
        '2h',
      );
    });
  });
}
