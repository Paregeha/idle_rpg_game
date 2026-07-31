import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/home/hero_card.dart';
import 'package:idle_rpg/features/home/player_bar.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('the player bar opens the hero', (tester) async {
    await pumpGame(tester);

    await tester.tap(find.byType(PlayerBar));
    await tester.pumpAndSettle();

    expect(find.byType(HeroCard), findsOneWidget);
  });

  testWidgets('it reports the same numbers the fight uses', (tester) async {
    // Not a second formula: the card and the resolver both read
    // heroCombatStats, so a card that flatters the hero is impossible.
    await pumpGame(tester);
    final controller = containerOf(
      tester,
    ).read(gameControllerProvider.notifier);
    controller.state = controller.state!.copyWith(
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PlayerBar));
    await tester.pumpAndSettle();

    final stats = heroCombatStats(controller.state!, testBalanceConfig);
    expect(find.text(stats.attack.format()), findsOneWidget);
    expect(find.text(stats.maxHp.format()), findsOneWidget);
  });

  testWidgets('every combat stat is named, not just the loud two', (
    tester,
  ) async {
    // Dodge and armour decide fights the player never sees the dice of. A
    // build screen that hides them cannot be used to make a decision.
    await pumpGame(tester);

    await tester.tap(find.byType(PlayerBar));
    await tester.pumpAndSettle();

    for (final label in [
      'ATTACK',
      'HEALTH',
      'SWINGS / SEC',
      'CRIT',
      'CRIT DAMAGE',
      'DODGE',
      'ARMOUR',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });
}
