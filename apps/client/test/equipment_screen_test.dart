import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

/// Opens the bag from home, where it sits beside the lamp.
Future<void> openBag(WidgetTester tester) async {
  await tapVisible(tester, find.byIcon(Icons.inventory_2_outlined));
}

/// Scrolls a control into view before tapping it, and lets any snack bar clear
/// first — one left on screen silently swallows the next tap.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the bag says what to do when it is empty', (tester) async {
    await pumpGame(tester);
    await openBag(tester);

    expect(find.textContaining('Light the lamp'), findsOneWidget);
  });

  testWidgets('every slot is shown on home, empty or not', (tester) async {
    // There is no hero tab to hide them behind: the grid on home is the only
    // place gear is worn, so a slot missing from it cannot be filled at all.
    await pumpGame(tester);

    for (final slot in testBalanceConfig.slots) {
      expect(find.text(slot.id), findsWidgets, reason: slot.id);
    }
  });

  testWidgets('the lamp gives an item and it appears in the inventory', (
    tester,
  ) async {
    await pumpGame(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    expect(controller.state!.inventory, hasLength(1));
  });

  testWidgets('the lamp does nothing when it cannot be paid for', (
    tester,
  ) async {
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    controller.state = controller.state!.copyWith(resources: const {});
    await tester.pump();

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    expect(
      controller.state!.inventory,
      isEmpty,
      reason: 'a lamp with nothing to spend must not hand out an item',
    );
  });

  testWidgets('the lamp is only offered in one place', (tester) async {
    // Home owns the loop button. A second copy anywhere else would leave the
    // player wondering whether the two do the same thing.
    await pumpGame(tester);

    expect(find.textContaining('LIGHT THE LAMP'), findsOneWidget);
  });

  testWidgets('equipping an item fills its slot and raises attack', (
    tester,
  ) async {
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);

    final before = heroCombatStats(controller.state!, testBalanceConfig).attack;

    // The pull itself offers the choice now: the item is shown against what
    // is worn, and WEAR IT is the whole equip flow.
    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));
    await tapVisible(tester, find.text('WEAR IT'));

    expect(controller.state!.equipped, isNotEmpty);
    expect(
      heroCombatStats(controller.state!, testBalanceConfig).attack > before,
      isTrue,
    );
  });

  testWidgets('equip best does nothing twice in a row', (tester) async {
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    expect(controller.equipBest(), greaterThan(0));
    expect(
      controller.equipBest(),
      0,
      reason: 'the second pass has nothing better to put on',
    );
  });

  testWidgets('tapping a slot opens the bag already filtered to it', (
    tester,
  ) async {
    await pumpGame(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));
    // Step past the pull without taking it, then check the empty slot.
    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();

    // The drawn item is a weapon, so the trinket square must come up empty.
    await tapVisible(tester, find.text('trinket'));

    expect(find.textContaining('Nothing that fits here'), findsOneWidget);
  });
}
