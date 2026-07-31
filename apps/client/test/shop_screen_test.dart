import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/shop/shop_screen.dart';
import 'package:idle_rpg/features/skills/skill_card.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> openShop(
  WidgetTester tester, {
  double gems = 500,
  Map<String, int> skills = const {},
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    resources: {'gems': BigNum.fromDouble(gems)},
    skills: skills,
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('SHOP'));
  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('the shop is a tab of its own', (tester) async {
    await openShop(tester);

    expect(find.byType(ShopScreen), findsOneWidget);
  });

  testWidgets('it has counters, not just one page', (tester) async {
    // A navigation bar that appears the day the second thing ships teaches
    // the player the game moved under them.
    await openShop(tester);

    for (final tab in ShopTab.values) {
      expect(find.text(tab.label), findsOneWidget, reason: tab.label);
    }
  });

  testWidgets('the pack publishes its odds', (tester) async {
    // A player who cannot see them assumes the worst, and is usually right.
    await openShop(tester);

    for (final rarity in testBalanceConfig.skillPack.weights.keys) {
      expect(find.text(rarity.toUpperCase()), findsWidgets, reason: rarity);
    }
    expect(find.textContaining('%'), findsWidgets);
  });

  testWidgets('opening a pack spends the currency and gives a copy', (
    tester,
  ) async {
    final controller = await openShop(tester);
    final before = controller.state!.resources['gems']!;

    await tester.tap(find.text('OPEN'));
    await tester.pumpAndSettle();

    expect(controller.state!.resources['gems']! < before, isTrue);
    expect(controller.state!.skills, isNotEmpty);
  });

  testWidgets('with nothing to spend it says so instead of doing nothing', (
    tester,
  ) async {
    final controller = await openShop(tester, gems: 0);

    expect(find.text('NOT ENOUGH'), findsOneWidget);

    await tester.tap(find.text('NOT ENOUGH'));
    await tester.pumpAndSettle();

    expect(controller.state!.skills, isEmpty);
  });

  testWidgets('the pool shows every skill, owned or not', (tester) async {
    await openShop(tester, skills: {'jab': 2});

    for (final id in testBalanceConfig.skills.keys) {
      expect(find.textContaining(id.substring(1)), findsWidgets, reason: id);
    }
    expect(find.textContaining('LV 2'), findsOneWidget);
  });

  testWidgets('a skill in the pool opens its card', (tester) async {
    await openShop(tester, skills: {'jab': 1});

    await tester.tap(find.text('Jab'));
    await tester.pumpAndSettle();

    expect(find.byType(SkillCard), findsOneWidget);
  });
}
