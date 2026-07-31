import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> withBag(
  WidgetTester tester, {
  Map<String, OwnedItem> inventory = const {
    'i0': OwnedItem(id: 'i0', configId: 'blade'),
  },
  Map<String, String> equipped = const {},
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    inventory: inventory,
    equipped: equipped,
  );
  await tester.pumpAndSettle();

  return controller;
}

Future<void> openBag(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.inventory_2_outlined));
  await tester.pumpAndSettle();
}

/// The card's own salvage button. The bag screen also says SALVAGE, twice.
Finder get cardSalvage => find.descendant(
  of: find.byType(ItemCard),
  matching: find.textContaining('SALVAGE'),
);

Future<void> openCard(WidgetTester tester) async {
  await tester.tap(find.text('Blade').first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the card breaks an item down and says what it pays', (
    tester,
  ) async {
    final controller = await withBag(tester);
    await openBag(tester);
    await openCard(tester);

    expect(cardSalvage, findsOneWidget);

    await tester.tap(cardSalvage);
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, isEmpty);
    expect(
      controller.state!.resources['scrap']! > BigNum.zero,
      isTrue,
      reason: 'breaking gear down is where materials come from',
    );
  });

  testWidgets('worn gear is not offered for salvage', (tester) async {
    // Stripping a slot as a side effect is how a player finds out from a
    // weaker hero instead of from the game.
    await withBag(tester, equipped: const {'weapon': 'i0'});
    await openBag(tester);
    await openCard(tester);

    expect(cardSalvage, findsNothing);
  });

  testWidgets('a worn item opened from the bag can still be taken off', (
    tester,
  ) async {
    // Opened from the bag there is no slot to hand in, so the card has to work
    // out which slot is wearing it. Before that it offered only CLOSE.
    final controller = await withBag(tester, equipped: const {'weapon': 'i0'});
    await openBag(tester);
    await openCard(tester);

    await tester.tap(find.text('TAKE OFF'));
    await tester.pumpAndSettle();

    expect(controller.state!.equipped, isEmpty);
  });

  testWidgets('the standing rule starts off', (tester) async {
    final controller = await withBag(tester);

    expect(controller.state!.autoSalvageRank, -1);
  });

  testWidgets('choosing a rank clears the pile already sitting there', (
    tester,
  ) async {
    // A player who turns it on expects the pile they were looking at to go,
    // not only the next thing that drops.
    final controller = await withBag(tester);
    await openBag(tester);

    await tester.tap(find.widgetWithText(Container, 'COMMON').first);
    await tester.pumpAndSettle();

    expect(controller.state!.autoSalvageRank, 0);
    expect(controller.state!.inventory, isEmpty);
  });

  testWidgets('the rule keeps running as loot arrives', (tester) async {
    final controller = await withBag(tester, inventory: const {});
    controller.state = controller.state!.copyWith(autoSalvageRank: 0);

    controller.state = controller.state!.copyWith(
      inventory: const {'i9': OwnedItem(id: 'i9', configId: 'blade')},
    );
    controller.resolveFight(won: true);
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, isEmpty);
  });

  testWidgets('OFF means nothing is destroyed', (tester) async {
    final controller = await withBag(tester);
    await openBag(tester);

    await tester.tap(find.widgetWithText(Container, 'COMMON').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(Container, 'OFF').first);
    await tester.pumpAndSettle();

    expect(controller.state!.autoSalvageRank, -1);

    controller.state = controller.state!.copyWith(
      inventory: const {'i9': OwnedItem(id: 'i9', configId: 'blade')},
    );
    controller.resolveFight(won: true);
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, isNotEmpty);
  });

  testWidgets('the salvage button names the rank it will take', (tester) async {
    // There is no undo for gear that has been broken down, so it must not be
    // pressable blind.
    await withBag(tester);
    await openBag(tester);

    expect(find.text('SALVAGE'), findsOneWidget);

    await tester.tap(find.widgetWithText(Container, 'COMMON').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('SALVAGE COMMON'), findsOneWidget);
  });

  testWidgets('materials are a tab of the bag, not a currency on top', (
    tester,
  ) async {
    final controller = await withBag(tester);
    await openBag(tester);
    await openCard(tester);
    await tester.tap(cardSalvage);
    await tester.pumpAndSettle();

    await tester.tap(find.text('MATERIALS'));
    await tester.pumpAndSettle();

    expect(find.text('SCRAP'), findsOneWidget);
    // Scoped to the row: the tab header carries a count of its own, and a
    // bare text finder would happily match that instead.
    expect(
      find.descendant(
        of: find.ancestor(of: find.text('SCRAP'), matching: find.byType(Row)),
        matching: find.text(controller.state!.resources['scrap']!.format()),
      ),
      findsOneWidget,
    );
  });
}
