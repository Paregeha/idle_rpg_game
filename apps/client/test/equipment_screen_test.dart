import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<void> openHero(WidgetTester tester) async {
  await tester.tap(find.text('HERO'));
  await tester.pumpAndSettle();
}

/// Scrolls a control into view before tapping it. The hero screen is a list,
/// and an off-screen tap silently misses.
Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('an empty inventory says what to do about it', (tester) async {
    await pumpGame(tester);
    await openHero(tester);

    expect(find.textContaining('Light the lamp'), findsOneWidget);
  });

  testWidgets('every slot is shown, empty or not', (tester) async {
    await pumpGame(tester);
    await openHero(tester);

    for (final slot in testBalanceConfig.slots) {
      expect(find.text(slot.id.toUpperCase()), findsWidgets, reason: slot.id);
    }
  });

  testWidgets('the lamp gives an item and it appears in the inventory', (
    tester,
  ) async {
    await pumpGame(tester);
    await openHero(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    expect(controller.state!.inventory, hasLength(1));
    expect(find.text('EQUIP'), findsOneWidget);
  });

  testWidgets('the lamp is disabled with no gems', (tester) async {
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    controller.state = controller.state!.copyWith(resources: const {});
    await tester.pump();
    await openHero(tester);

    final button = tester.widget<FilledButton>(
      find.ancestor(
        of: find.textContaining('LIGHT THE LAMP'),
        matching: find.byType(FilledButton),
      ),
    );

    expect(button.onPressed, isNull);
  });

  testWidgets('equipping an item fills its slot and raises attack', (
    tester,
  ) async {
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    await openHero(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    final before = heroCombatStats(controller.state!, testBalanceConfig).attack;

    await tapVisible(tester, find.text('EQUIP'));

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
    await openHero(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    expect(controller.equipBest(), greaterThan(0));
    expect(
      controller.equipBest(),
      0,
      reason: 'the second pass has nothing better to put on',
    );
  });

  testWidgets('the slot filter narrows the list', (tester) async {
    await pumpGame(tester);
    await openHero(tester);

    await tapVisible(tester, find.textContaining('LIGHT THE LAMP'));

    // Filter to a slot the drawn item cannot be in.
    await tapVisible(tester, find.widgetWithText(ChoiceChip, 'TRINKET'));

    expect(find.textContaining('Nothing in this slot'), findsOneWidget);
  });
}
