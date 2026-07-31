import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

/// Gives the player the blade, worn, plus whatever gold is asked for.
Future<GameController> armed(WidgetTester tester, {double gold = 1e6}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
    equipped: const {'weapon': 'i0'},
    resources: {'gold': BigNum.fromDouble(gold), 'gems': BigNum.fromDouble(5)},
  );
  await tester.pumpAndSettle();

  return controller;
}

/// Opens the card the way a player does: by tapping the slot they are wearing.
Future<void> openCard(WidgetTester tester) async {
  await tester.tap(find.text('Blade').first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a worn slot opens the item, not the bag', (tester) async {
    await armed(tester);
    await openCard(tester);

    expect(find.byType(ItemCard), findsOneWidget);
    expect(find.text('BAG'), findsNothing);
  });

  testWidgets('shows what the next level buys', (tester) async {
    await armed(tester);
    await openCard(tester);

    final item = testBalanceConfig.items['blade']!;
    const rarity = RarityConfig();
    final now = item.statsAt(level: 0, rarity: rarity).flatAttack;
    final next = item.statsAt(level: 1, rarity: rarity).flatAttack;

    expect(find.text(now.format()), findsOneWidget);
    expect(
      find.text(next.format()),
      findsOneWidget,
      reason: 'a card that only shows today gives no reason to press upgrade',
    );
  });

  testWidgets('upgrading raises the level in place', (tester) async {
    final controller = await armed(tester);
    await openCard(tester);

    await tester.tap(find.textContaining('UPGRADE'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory['i0']!.level, 1);
    expect(
      find.byType(ItemCard),
      findsOneWidget,
      reason: 'the card stays open so the next level can be pressed too',
    );
    expect(find.textContaining('+2'), findsWidgets);
  });

  testWidgets('says why instead of failing silently', (tester) async {
    // The button asks the upgrade itself whether it would go through, so the
    // reason on it cannot drift away from the reason it is refused.
    await armed(tester, gold: 0);
    await openCard(tester);

    expect(find.text('NOT ENOUGH GOLD'), findsOneWidget);

    final button = tester.widget<TextButton>(
      find.ancestor(
        of: find.text('NOT ENOUGH GOLD'),
        matching: find.byType(TextButton),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('a worn item can be taken off from its card', (tester) async {
    // The slot grid had no way to do it at all: a player who could put
    // something on and never take it off would conclude the slot was stuck.
    final controller = await armed(tester);
    await openCard(tester);

    expect(find.text('TAKE OFF'), findsOneWidget);

    await tester.tap(find.text('TAKE OFF'));
    await tester.pumpAndSettle();

    expect(controller.state!.equipped, isEmpty);
    expect(
      controller.state!.inventory.containsKey('i0'),
      isTrue,
      reason: 'taking it off must not destroy it',
    );
  });

  testWidgets('an undecided item is offered EQUIP, not TAKE OFF', (
    tester,
  ) async {
    final controller = await armed(tester);
    controller.state = controller.state!.copyWith(equipped: const {});
    await tester.pumpAndSettle();

    // Nothing is worn, so the item is waiting on a decision and the lamp is
    // where it is asked about.
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('WEAR IT'), findsOneWidget);
    expect(find.text('TAKE OFF'), findsNothing);
  });

  testWidgets('a maxed item offers nothing more to buy', (tester) async {
    final controller = await armed(tester);
    final maxLevel = testBalanceConfig.items['blade']!.maxLevel;
    controller.state = controller.state!.copyWith(
      inventory: {
        'i0': OwnedItem(id: 'i0', configId: 'blade', level: maxLevel),
      },
    );
    await tester.pumpAndSettle();
    await openCard(tester);

    expect(find.text('FULLY UPGRADED'), findsOneWidget);
    expect(find.text('COST'), findsNothing);
  });
}
