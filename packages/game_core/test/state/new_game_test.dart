import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  const config = BalanceConfig(
    generators: {
      'apprentice': GeneratorConfig(
        produces: 'gold',
        baseRatePerSecond: BigNum.one,
      ),
    },
    start: StartConfig(generators: {'apprentice': 2}),
  );

  test('grants the starting loadout from the config', () {
    final state = newGame(nowMs: 1770000000000, rngSeed: 7, config: config);

    expect(state.generators['apprentice']!.owned, 2);
    expect(state.lastTickAtMs, 1770000000000);
    expect(state.rngSeed, 7);
  });

  test('a new player can immediately earn', () {
    final state = newGame(nowMs: 0, rngSeed: 1, config: config);

    final after = simulate(state, const Duration(seconds: 10), config);

    expect(
      after.state.resources['gold'],
      BigNum.fromDouble(20),
      reason: 'a new player with no income can never afford anything',
    );
  });

  test('starts with a clean slate otherwise', () {
    final state = newGame(nowMs: 0, rngSeed: 1, config: config);

    expect(state.upgrades, isEmpty);
    expect(state.earnedThisRun, isEmpty);
    expect(state.prestige, const PrestigeState());
    expect(state.carryOverMs, 0);
    expect(state.version, stateSchemaVersion);
  });

  test('a config that grants nothing is refused at load', () {
    expect(
      () => BalanceConfig.parse('''
{
  "version": 1,
  "generators": {
    "miner": {
      "produces": "gold",
      "baseRatePerSecond": "1e0",
      "costBase": "1e1",
      "costGrowth": 1.07
    }
  }
}
'''),
      throwsA(
        isA<BalanceConfigException>().having(
          (e) => e.field,
          'field',
          'start.generators',
        ),
      ),
    );
  });

  test('a config granting an unknown generator is refused', () {
    expect(
      () => BalanceConfig.parse('''
{
  "version": 1,
  "generators": {
    "miner": {
      "produces": "gold",
      "baseRatePerSecond": "1e0",
      "costBase": "1e1",
      "costGrowth": 1.07
    }
  },
  "start": { "generators": { "ghost": 1 } }
}
'''),
      throwsA(isA<BalanceConfigException>()),
    );
  });
}
