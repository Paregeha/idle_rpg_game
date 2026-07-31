import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/data/save_database.dart';
import 'package:idle_rpg/data/save_providers.dart';
import 'package:idle_rpg/main.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// A small balance config, so widget tests do not depend on loading the real
/// asset — and so a change to the shipped numbers cannot break the UI tests.
final testBalanceConfig = BalanceConfig(
  generators: const {
    'miner': GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
      costBase: BigNum.one,
      costGrowth: 1.07,
    ),
  },
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'trinket'),
  ],
  rarities: const {'common': RarityConfig()},
  items: {
    'blade': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(25)),
    ),
  },
  skills: const {
    'jab': SkillConfig(copiesBase: 2, copiesGrowth: 2),
    'wave': SkillConfig(unlockAtLevel: 12, targets: 0),
  },
  skillPack: const SkillPackConfig(costAmount: 50, weights: {'common': 1}),
  lamp: const LampConfig(weights: {'common': 1}, costResource: 'gems'),
  displayedResources: const ['gold', 'gems'],
  start: StartConfig(
    generators: const {'miner': 1},
    resources: {'gems': BigNum.fromDouble(5)},
  ),
);

/// The container behind the running app, for reading controllers in a test.
ProviderContainer containerOf(WidgetTester tester) {
  return ProviderScope.containerOf(tester.element(find.byType(IdleRpgApp)));
}

/// Pumps the whole app with a fake clock and a stub config.
Future<FakeClock> pumpGame(WidgetTester tester) async {
  final clock = FakeClock(1770000000000);
  final db = SaveDatabase(NativeDatabase.memory());
  addTearDown(db.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(clock),
        balanceConfigProvider.overrideWith((ref) async => testBalanceConfig),
        // Launch restores a save, so widget tests need somewhere to read from.
        saveDatabaseProvider.overrideWithValue(db),
      ],
      child: const IdleRpgApp(),
    ),
  );
  await tester.pumpAndSettle();

  return clock;
}
