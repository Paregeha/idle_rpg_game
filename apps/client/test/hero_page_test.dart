import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/hero_page.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/home/player_bar.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> openHero(
  WidgetTester tester, {
  Map<String, OwnedItem> inventory = const {
    'i0': OwnedItem(id: 'i0', configId: 'blade'),
  },
  Map<String, String> equipped = const {'weapon': 'i0'},
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    inventory: inventory,
    equipped: equipped,
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byType(PlayerBar));
  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('the player bar opens the hero page', (tester) async {
    await openHero(tester);

    expect(find.byType(HeroPage), findsOneWidget);
  });

  testWidgets('every slot is listed, worn or not', (tester) async {
    await openHero(tester);

    for (final slot in testBalanceConfig.slots) {
      expect(find.text(slot.id.toUpperCase()), findsOneWidget, reason: slot.id);
    }
    expect(find.text('empty'), findsWidgets);
  });

  testWidgets('a worn slot names what is in it and opens it', (tester) async {
    await openHero(tester);

    expect(find.text('Blade'), findsOneWidget);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();

    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('every combat stat is named, not just the loud two', (
    tester,
  ) async {
    // Dodge and armour decide fights the player never sees the dice of.
    await openHero(tester);

    for (final label in [
      'ATTACK',
      'HEALTH',
      'SWINGS / SEC',
      'CRIT',
      'CRIT DAMAGE',
      'DODGE',
      'ARMOUR',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('the numbers are the ones the fight reads', (tester) async {
    // Not a second formula: the page and the resolver both call
    // heroCombatStats, so a page that flatters the hero is impossible.
    final controller = await openHero(tester);
    final stats = heroCombatStats(controller.state!, testBalanceConfig);

    expect(find.text(stats.attack.format()), findsOneWidget);
    expect(find.text(stats.maxHp.format()), findsOneWidget);
  });

  testWidgets('it comes back to where the player was', (tester) async {
    await openHero(tester);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(HeroPage), findsNothing);
    expect(find.byType(PlayerBar), findsOneWidget);
  });
}
