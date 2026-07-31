import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/materials_screen.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> withGear(
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

  return controller;
}

/// The card's own salvage button.
Finder get cardSalvage => find.descendant(
  of: find.byType(ItemCard),
  matching: find.textContaining('SALVAGE'),
);

void main() {
  testWidgets('worn gear is not offered for salvage', (tester) async {
    // Stripping a slot as a side effect is how a player finds out from a
    // weaker hero instead of from the game.
    await withGear(tester);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();

    expect(cardSalvage, findsNothing);
    expect(find.text('TAKE OFF'), findsOneWidget);
  });

  testWidgets('gear taken off is asked about, then broken down', (
    tester,
  ) async {
    final controller = await withGear(tester);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('TAKE OFF'));
    await tester.pumpAndSettle();

    // It is now waiting on a decision, and the lamp asks about it.
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.textContaining('SELL'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, isEmpty);
    expect(
      controller.state!.resources['scrap']! > BigNum.zero,
      isTrue,
      reason: 'breaking gear down is where materials come from',
    );
  });

  testWidgets('the bag holds materials and nothing else', (tester) async {
    // Gear does not live anywhere: it is on the hero or sold. What is worth
    // keeping is what breaking it down paid.
    await withGear(tester);

    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialsScreen), findsOneWidget);
    expect(find.text('BAG'), findsOneWidget);
    for (final material in testBalanceConfig.materialResources) {
      expect(find.text(material.toUpperCase()), findsOneWidget);
    }
  });

  testWidgets('it shows how much of each is banked', (tester) async {
    final controller = await withGear(tester);
    controller.state = controller.state!.copyWith(
      resources: {'scrap': BigNum.fromDouble(42)},
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.inventory_2_outlined));
    await tester.pumpAndSettle();

    expect(find.text(BigNum.fromDouble(42).format()), findsOneWidget);
  });
}
