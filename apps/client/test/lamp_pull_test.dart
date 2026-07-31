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
  await tester.tap(find.textContaining('LIGHT THE LAMP'));
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

  testWidgets('the sell-what-I-replace box is off until it is ticked', (
    tester,
  ) async {
    final controller = await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );
    expect(controller.state!.sellReplaced, isFalse);

    await pull(tester);
    await tester.tap(find.text('Sell what I replace'));
    await tester.pumpAndSettle();

    expect(controller.state!.sellReplaced, isTrue);
  });

  testWidgets('ticked, wearing the new one sells the old one', (tester) async {
    final controller = await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );
    controller.state = controller.state!.copyWith(sellReplaced: true);
    await tester.pumpAndSettle();

    await pull(tester);
    await tester.tap(find.text('WEAR IT'));
    await tester.pumpAndSettle();

    expect(
      controller.state!.inventory.containsKey('i0'),
      isFalse,
      reason: 'the replaced item was sold, as asked',
    );
    expect(controller.state!.equipped.values, isNotEmpty);
  });

  testWidgets('unticked, the old one goes back to the bag', (tester) async {
    final controller = await ready(
      tester,
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );

    await pull(tester);
    await tester.tap(find.text('WEAR IT'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory.containsKey('i0'), isTrue);
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

  testWidgets('the box is not offered when there is nothing to replace', (
    tester,
  ) async {
    // A tick box that does nothing teaches the player to ignore tick boxes.
    await ready(tester);
    await pull(tester);

    expect(find.text('Sell what I replace'), findsNothing);
  });

  testWidgets('walking away leaves the item in the bag', (tester) async {
    final controller = await ready(tester);
    await pull(tester);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory, hasLength(1));
    expect(controller.state!.equipped, isEmpty);
  });
}
