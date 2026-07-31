import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/upgrade_arrow.dart';
import 'package:idle_rpg/features/home/lamp_pull.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> ready(
  WidgetTester tester, {
  Map<String, OwnedItem> inventory = const {},
  Map<String, String> equipped = const {},
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    inventory: inventory,
    equipped: equipped,
    resources: {'gems': BigNum.fromDouble(500)},
  );
  await tester.pumpAndSettle();

  return controller;
}

Future<void> pull(WidgetTester tester) async {
  // The button becomes DECIDE once something is waiting, so this taps
  // whichever it is.
  await tester.tap(find.byIcon(Icons.light_mode));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('a pull is shown against what is already worn', (tester) async {
    // Showing the new item alone would make the player close it, open the
    // slot, and compare by memory.
    await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );
    await pull(tester);

    expect(find.byType(LampPull), findsOneWidget);
    expect(find.text('WEARING'), findsOneWidget);
    expect(find.text('NEW'), findsOneWidget);
  });

  testWidgets('with the slot empty it says so rather than showing nothing', (
    tester,
  ) async {
    await ready(tester);
    await pull(tester);

    expect(find.text('nothing'), findsOneWidget);
  });

  testWidgets('WEAR IT puts it on', (tester) async {
    final controller = await ready(tester);
    await pull(tester);

    await tester.tap(find.text('WEAR IT'));
    await tester.pumpAndSettle();

    expect(controller.state!.equipped, isNotEmpty);
    expect(find.byType(LampPull), findsNothing);
  });

  testWidgets('SELL breaks it down instead', (tester) async {
    final controller = await ready(tester);
    await pull(tester);

    await tester.tap(find.textContaining('SELL'));
    await tester.pumpAndSettle();

    expect(controller.state!.equipped, isEmpty);
    expect(controller.state!.inventory, isEmpty);
    expect(controller.state!.resources['scrap']! > BigNum.zero, isTrue);
  });

  testWidgets('wearing a new one sells what it replaced', (tester) async {
    // One of each kind, always. The replaced item cannot go back to a bag
    // that does not hold gear.
    final controller = await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );

    await pull(tester);
    await tester.tap(find.text('WEAR IT'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory.containsKey('i0'), isFalse);
    expect(controller.state!.equipped.values, isNotEmpty);
    expect(controller.state!.resources['scrap']! > BigNum.zero, isTrue);
  });

  testWidgets('nothing is left undecided once the screen closes', (
    tester,
  ) async {
    final controller = await ready(tester);

    await pull(tester);
    await tester.tap(find.text('WEAR IT'));
    await tester.pumpAndSettle();

    expect(pendingItems(controller.state!), isEmpty);
    expect(find.byType(LampPull), findsNothing);
  });

  testWidgets('a better item is marked with the arrow', (tester) async {
    // One arrow, one meaning: the bag, the slots and a pull all ask the same
    // function whether something is worth wearing.
    await ready(tester);
    await pull(tester);

    // Scoped to the pull: the slot behind it now wears one too, which is the
    // point — the same rule lit both.
    expect(
      find.descendant(
        of: find.byType(LampPull),
        matching: find.byType(UpgradeArrow),
      ),
      findsOneWidget,
    );
  });

  testWidgets('it says which item wearing this would sell', (tester) async {
    await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );
    await pull(tester);

    expect(find.textContaining('Wearing this sells'), findsOneWidget);
  });

  testWidgets('with the slot empty it says nothing about selling', (
    tester,
  ) async {
    await ready(tester);
    await pull(tester);

    expect(find.textContaining('Wearing this sells'), findsNothing);
  });

  testWidgets('it cannot be walked away from', (tester) async {
    // The bag holds decisions, not gear, and walking away is what left
    // something undecided in the first place.
    final controller = await ready(tester);
    await pull(tester);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(find.byType(LampPull), findsOneWidget);
    expect(pendingItems(controller.state!), hasLength(1));
  });

  testWidgets('the bag button counts what is undecided, not what is owned', (
    tester,
  ) async {
    // Everything else is on the hero; counting that here would read as
    // clutter the player has to clear.
    await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );

    expect(find.text('0'), findsWidgets);
  });

  testWidgets('a queue is walked through one at a time', (tester) async {
    final controller = await ready(
      tester,
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'blade'),
        'i1': OwnedItem(id: 'i1', configId: 'blade'),
      },
    );

    await pull(tester);
    expect(find.textContaining('WAITING'), findsOneWidget);

    await tester.tap(find.textContaining('SELL'));
    await tester.pumpAndSettle();
    expect(find.byType(LampPull), findsOneWidget);

    await tester.tap(find.textContaining('SELL'));
    await tester.pumpAndSettle();
    expect(find.byType(LampPull), findsNothing);
    expect(pendingItems(controller.state!), isEmpty);
  });
}
