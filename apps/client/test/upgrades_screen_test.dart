import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<void> openForge(WidgetTester tester) async {
  await tester.tap(find.text('FORGE'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists what the player can buy', (tester) async {
    await pumpGame(tester);
    await openForge(tester);

    expect(find.text('MINER'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('10'), findsWidgets);
    expect(find.text('MAX'), findsWidgets);
  });

  testWidgets('buy buttons are disabled when the player cannot afford it', (
    tester,
  ) async {
    await pumpGame(tester);
    await openForge(tester);

    final buy = tester.widget<FilledButton>(
      find.ancestor(of: find.text('1'), matching: find.byType(FilledButton)),
    );

    expect(buy.onPressed, isNull, reason: 'a fresh player has no gold');
  });

  testWidgets('buying spends gold and adds a unit', (tester) async {
    final clock = await pumpGame(tester);
    final container = containerOf(tester);
    final controller = container.read(gameControllerProvider.notifier);

    // Earn enough for one more miner.
    clock.advance(const Duration(minutes: 10));
    controller.tick();
    await tester.pump();
    await openForge(tester);

    final before = controller.state!.resources['gold']!;
    await tester.tap(
      find.ancestor(of: find.text('1'), matching: find.byType(FilledButton)),
    );
    await tester.pumpAndSettle();

    expect(controller.state!.generators['miner']!.owned, 2);
    expect(controller.state!.resources['gold']! < before, isTrue);
  });

  testWidgets('the row says when the next unit is affordable', (tester) async {
    await pumpGame(tester);
    await openForge(tester);

    // A brand new player has income, so there is a real answer to show.
    expect(find.textContaining('next in'), findsWidgets);
  });

  testWidgets('MAX buys everything affordable at once', (tester) async {
    final clock = await pumpGame(tester);
    final container = containerOf(tester);
    final controller = container.read(gameControllerProvider.notifier);

    clock.advance(const Duration(hours: 1));
    controller.tick();
    await tester.pump();
    await openForge(tester);

    final affordable = controller.affordable('miner');
    expect(affordable, greaterThan(1), reason: 'the test needs a real choice');

    await tester.tap(
      find.ancestor(of: find.text('MAX'), matching: find.byType(FilledButton)),
    );
    await tester.pumpAndSettle();

    expect(controller.state!.generators['miner']!.owned, 1 + affordable);
    expect(controller.affordable('miner'), 0);
  });
}
