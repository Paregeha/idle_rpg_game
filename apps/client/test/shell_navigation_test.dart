import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/battle/battle_screen.dart';
import 'package:idle_rpg/features/hero/hero_screen.dart';
import 'package:idle_rpg/features/upgrades/upgrades_screen.dart';
import 'package:idle_rpg/main.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: IdleRpgApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens on the battle tab', (tester) async {
    await pumpApp(tester);

    expect(find.byType(BattleScreen), findsOneWidget);
  });

  testWidgets('every tab is reachable', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('HERO'));
    await tester.pumpAndSettle();
    expect(find.byType(HeroScreen), findsOneWidget);

    await tester.tap(find.text('FORGE'));
    await tester.pumpAndSettle();
    expect(find.byType(UpgradesScreen), findsOneWidget);

    await tester.tap(find.text('BATTLE'));
    await tester.pumpAndSettle();
    expect(find.byType(BattleScreen), findsOneWidget);
  });

  testWidgets('the resource bar survives switching tabs', (tester) async {
    // It lives in the shell, so the counters keep running instead of being
    // torn down and rebuilt every time the player looks at another screen.
    await pumpApp(tester);
    final barBefore = tester.widget<ResourceBar>(find.byType(ResourceBar));

    await tester.tap(find.text('FORGE'));
    await tester.pumpAndSettle();

    expect(find.byType(ResourceBar), findsOneWidget);
    expect(
      tester.widget<ResourceBar>(find.byType(ResourceBar)),
      same(barBefore),
      reason: 'the bar must not be rebuilt when the tab changes',
    );
  });

  testWidgets('uses the forge palette, not stock Material', (tester) async {
    await pumpApp(tester);

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
    final theme = Theme.of(tester.element(find.byType(Scaffold).first));

    expect(
      scaffold.backgroundColor ?? theme.scaffoldBackgroundColor,
      GamePalette.forgeDark,
    );
    expect(theme.colorScheme.primary, GamePalette.emberBright);
  });

  testWidgets('an extreme system font size does not break the layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(3)),
        child: const ProviderScope(child: IdleRpgApp()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
