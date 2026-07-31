import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/forge/forge_screen.dart';
import 'package:idle_rpg/features/upgrades/upgrades_screen.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> openForge(
  WidgetTester tester, {
  double scrap = 500,
  double gold = 5000,
  int heroLevel = 50,
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    heroLevel: heroLevel,
    resources: {
      'scrap': BigNum.fromDouble(scrap),
      'gold': BigNum.fromDouble(gold),
    },
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('FORGE'));
  await tester.pumpAndSettle();

  return controller;
}

Future<void> openCraft(WidgetTester tester) async {
  await tester.tap(find.text('CRAFT'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the forge opens on income, with craft beside it', (
    tester,
  ) async {
    await openForge(tester);

    expect(find.byType(UpgradesScreen), findsOneWidget);
    for (final tab in ForgeTab.values) {
      expect(find.text(tab.label), findsOneWidget, reason: tab.label);
    }
  });

  testWidgets('a recipe makes the thing and charges every cost', (
    tester,
  ) async {
    final controller = await openForge(tester);
    await openCraft(tester);

    await tester.tap(find.text('FORGE IT'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, hasLength(1));
    expect(
      controller.state!.inventory.values.single.configId,
      testBalanceConfig.recipes.values.single.produces,
    );
    expect(
      controller.state!.resources['scrap']! < BigNum.fromDouble(500),
      isTrue,
    );
  });

  testWidgets('a recipe shows what is held against what it needs', (
    tester,
  ) async {
    // "You need 120" is a number. "You have 48 of 120" is a plan.
    await openForge(tester, scrap: 48);
    await openCraft(tester);

    final held = BigNum.fromDouble(48).format();
    final needed = testBalanceConfig.recipes.values.single.costs['scrap']!;
    expect(find.text('$held / ${needed.format()}'), findsOneWidget);
  });

  testWidgets('short of materials it says so and stays pressable by nobody', (
    tester,
  ) async {
    final controller = await openForge(tester, scrap: 1);
    await openCraft(tester);

    expect(find.text('NOT ENOUGH MATERIALS'), findsOneWidget);

    await tester.tap(find.text('NOT ENOUGH MATERIALS'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, isEmpty);
  });

  testWidgets('a locked recipe is shown, and names the level it wants', (
    tester,
  ) async {
    // A recipe hidden until it is available is a surprise, and a player
    // cannot save towards a surprise.
    await openForge(tester, heroLevel: 0);
    await openCraft(tester);

    expect(find.textContaining('HERO LV'), findsOneWidget);
    expect(find.textContaining('SCRAP'), findsWidgets);
  });

  testWidgets('materials are shown beside the currencies here', (tester) async {
    // A recipe is priced in both, so both have to be on screen.
    await openForge(tester);

    expect(find.byType(ResourceOverlayForForge), findsOneWidget);
    // Scrap is a material, not a currency, so it is not in the top row
    // anywhere else — the forge is where a recipe needs to see it.
    expect(
      testBalanceConfig.materialResources,
      isNot(contains(testBalanceConfig.displayedResources.first)),
    );
    expect(find.text(BigNum.fromDouble(500).format()), findsWidgets);
  });
}
