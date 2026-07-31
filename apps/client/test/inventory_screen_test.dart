import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/inventory_screen.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/home/home_screen.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

/// Fills the bag with one of everything the test config knows about.
Future<GameController> stocked(WidgetTester tester) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    inventory: const {
      'i0': OwnedItem(id: 'i0', configId: 'blade'),
      'i1': OwnedItem(id: 'i1', configId: 'blade', level: 3),
    },
    equipped: const {'weapon': 'i1'},
  );
  await tester.pumpAndSettle();

  return controller;
}

Future<void> openBag(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.inventory_2_outlined));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the bag is a screen you come back from', (tester) async {
    await stocked(tester);
    await openBag(tester);

    expect(find.byType(InventoryScreen), findsOneWidget);
    expect(
      find.byType(HomeScreen),
      findsNothing,
      reason: 'a full screen, not a panel over the game',
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('every owned item gets a cell', (tester) async {
    await stocked(tester);
    await openBag(tester);

    expect(find.text('Blade'), findsNWidgets(2));
    expect(find.text('ON', skipOffstage: false), findsOneWidget);
  });

  testWidgets('a cell opens the item', (tester) async {
    await stocked(tester);
    await openBag(tester);

    await tester.tap(find.text('Blade').first);
    await tester.pumpAndSettle();

    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('opened from a slot, it starts filtered to that slot', (
    tester,
  ) async {
    // Answering "what fits here" with the whole bag makes the player do the
    // filtering the game already knows how to do.
    await stocked(tester);

    await tester.tap(find.text('trinket'));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryScreen), findsOneWidget);
    expect(find.textContaining('Nothing that fits here'), findsOneWidget);
  });

  testWidgets('the filter can be cleared once it is open', (tester) async {
    await stocked(tester);

    await tester.tap(find.text('trinket'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'ALL'));
    await tester.pumpAndSettle();

    expect(find.text('Blade'), findsNWidgets(2));
  });

  testWidgets('upgrading from the bag keeps the card open', (tester) async {
    // The card is pushed over the bag, which is itself a route. On the device
    // the upgrade closed it, so the player lost the item they were working on
    // after every single level.
    final controller = await stocked(tester);
    controller.state = controller.state!.copyWith(
      resources: {'gold': BigNum.fromDouble(1e9)},
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Blade').first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('UPGRADE'));
    await tester.pumpAndSettle();

    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('the bag is split by what kind of thing it holds', (
    tester,
  ) async {
    await stocked(tester);
    await openBag(tester);

    for (final tab in BagTab.values) {
      expect(find.text(tab.label), findsOneWidget, reason: tab.label);
    }
  });

  testWidgets('materials are their own tab, and say what they are for', (
    tester,
  ) async {
    await stocked(tester);
    await openBag(tester);

    await tester.tap(find.text('MATERIALS'));
    await tester.pumpAndSettle();

    for (final material in testBalanceConfig.materialResources) {
      expect(find.text(material.toUpperCase()), findsOneWidget);
    }
    expect(find.textContaining('Crafting will spend them'), findsOneWidget);
    expect(find.text('Blade'), findsNothing);
    expect(
      find.text('EQUIP BEST'),
      findsNothing,
      reason: 'nothing on this tab can be worn',
    );
  });

  testWidgets('switching back brings the gear and its filter', (tester) async {
    await stocked(tester);
    await openBag(tester);

    await tester.tap(find.text('MATERIALS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('GEAR'));
    await tester.pumpAndSettle();

    expect(find.text('Blade'), findsNWidgets(2));
    expect(find.widgetWithText(ChoiceChip, 'ALL'), findsOneWidget);
  });

  testWidgets('an empty bag says what to do about it', (tester) async {
    await pumpGame(tester);
    await openBag(tester);

    expect(find.textContaining('Light the lamp'), findsOneWidget);
  });
}
