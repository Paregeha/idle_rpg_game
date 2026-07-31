import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/battle/battle_screen.dart';
import 'package:idle_rpg/features/home/home_screen.dart';
import 'package:idle_rpg/features/home/resource_overlay.dart';
import 'package:idle_rpg/features/upgrades/upgrades_screen.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('opens on home, with the fight already running', (tester) async {
    // In an idle game the fight is the thing that is always happening. A
    // player who has to navigate to see it stops believing it is running.
    await pumpGame(tester);

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(BattleScreen), findsOneWidget);
  });

  testWidgets('every tab is reachable', (tester) async {
    await pumpGame(tester);

    await tester.tap(find.text('FORGE'));
    await tester.pumpAndSettle();
    expect(find.byType(UpgradesScreen), findsOneWidget);

    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('the currencies are shown once, over the scene', (tester) async {
    // They belong to home, not to the shell: two copies of the same number is
    // how a player starts wondering which of them is the real balance.
    await pumpGame(tester);
    expect(find.byType(ResourceOverlay), findsOneWidget);

    await tester.tap(find.text('FORGE'));
    await tester.pumpAndSettle();
    expect(find.byType(ResourceOverlay), findsNothing);
  });

  testWidgets('uses the forge palette, not stock Material', (tester) async {
    await pumpGame(tester);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    final theme = Theme.of(tester.element(find.byType(Scaffold).first));

    expect(
      scaffold.backgroundColor ?? theme.scaffoldBackgroundColor,
      GamePalette.forgeDark,
    );
    expect(theme.colorScheme.primary, GamePalette.emberBright);
  });

  testWidgets('a small phone does not break the layout', (tester) async {
    // 360×640 is the floor we support. Home stacks a scene, a skill row, the
    // gear grid and the lamp, so it is the screen that runs out of room first.
    tester.view.physicalSize = const Size(360 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await pumpGame(tester);

    expect(tester.takeException(), isNull);
  });
}
