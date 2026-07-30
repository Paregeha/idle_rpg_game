import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
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
  start: const StartConfig(generators: {'miner': 1}),
);

/// Pumps the whole app with a fake clock and a stub config.
Future<FakeClock> pumpGame(WidgetTester tester) async {
  final clock = FakeClock(1770000000000);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(clock),
        balanceConfigProvider.overrideWith((ref) async => testBalanceConfig),
      ],
      child: const IdleRpgApp(),
    ),
  );
  await tester.pumpAndSettle();

  return clock;
}
