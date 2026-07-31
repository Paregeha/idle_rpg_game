import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/hero/hero_page.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/home/player_bar.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> openHero(
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

  await tester.tap(find.text('HERO'));
  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('the hero is a tab of its own', (tester) async {
    await openHero(tester);

    expect(find.byType(HeroPage), findsOneWidget);
  });

  testWidgets('wings sit with the gear, skin and mount apart from it', (
    tester,
  ) async {
    // Wings are worn like the rest of the gear. A skin and a mount are not
    // equipment — they change how the hero looks and what they ride.
    await openHero(tester);

    expect(find.text('WINGS'), findsOneWidget);
    expect(find.text('SKIN'), findsOneWidget);
    expect(find.text('MOUNT'), findsOneWidget);
    expect(find.text('RUNE'), findsNothing, reason: 'a rune is not gear');
  });

  testWidgets('every slot but the rune is on the page', (tester) async {
    await openHero(tester);

    for (final slot in testBalanceConfig.slots) {
      if (slot.itemKind == 'rune') continue;
      expect(find.text(slot.id.toUpperCase()), findsOneWidget, reason: slot.id);
    }
    expect(find.text('empty'), findsWidgets);
  });

  testWidgets('the first tap picks a slot, the second opens it', (
    tester,
  ) async {
    // A page where every tap opened a dialog would make choosing something to
    // upgrade a four-tap job.
    final controller = await openHero(tester);
    controller.state = controller.state!.copyWith(
      resources: {'gold': BigNum.fromDouble(1e9)},
    );
    await tester.pumpAndSettle();

    expect(find.text('Blade'), findsOneWidget);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();
    expect(find.byType(ItemCard), findsNothing);
    expect(find.textContaining('UPGRADE WEAPON'), findsOneWidget);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();
    expect(find.byType(ItemCard), findsOneWidget);
  });

  testWidgets('with nothing picked the button says what it wants', (
    tester,
  ) async {
    await openHero(tester);

    expect(find.text('PICK A SLOT'), findsOneWidget);
    expect(find.text('—'), findsOneWidget, reason: 'and promises nothing');
  });

  testWidgets('the gain between the buttons is what the upgrade is worth', (
    tester,
  ) async {
    // Shown even when the price cannot be met: that is exactly when a player
    // wants to know what they are saving towards.
    final controller = await openHero(tester);

    await tester.tap(find.text('Blade'));
    await tester.pumpAndSettle();

    final gain = upgradeGain(controller.state!, 'i0', testBalanceConfig);
    expect(gain, greaterThan(0));
    expect(find.text('+${(gain * 100).toStringAsFixed(1)}%'), findsOneWidget);
    expect(find.text('NOT ENOUGH'), findsOneWidget);
  });

  testWidgets('UPGRADE ALL lifts the gear and leaves the outfit alone', (
    tester,
  ) async {
    // Wings, skins and mounts cost crystals. A button that spends a premium
    // currency as a side effect is the kind of thing that gets refunded.
    final controller = await openHero(tester);
    controller.state = controller.state!.copyWith(
      resources: {
        'gold': BigNum.fromDouble(1e9),
        'premiumGems': BigNum.fromDouble(1e6),
      },
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('UPGRADE ALL'));
    await tester.pumpAndSettle();

    expect(controller.state!.inventory['i0']!.level, greaterThan(0));
    expect(
      controller.state!.resources['premiumGems'],
      BigNum.fromDouble(1e6),
      reason: 'crystals are never spent by the sweep',
    );
  });

  testWidgets('every combat stat is named, not just the loud two', (
    tester,
  ) async {
    // Dodge and armour decide fights the player never sees the dice of.
    await openHero(tester);

    // The list scrolls, so the ones past the fold are offstage rather than
    // absent — a stat that had been dropped would still fail this.
    for (final label in [
      'ATTACK',
      'HEALTH',
      'SWINGS / SEC',
      'CRIT',
      'CRIT DAMAGE',
      'DODGE',
      'ARMOUR',
    ]) {
      expect(
        find.text(label, skipOffstage: false),
        findsOneWidget,
        reason: label,
      );
    }
  });

  testWidgets('the numbers are the ones the fight reads', (tester) async {
    // Not a second formula: the page and the resolver both call
    // heroCombatStats, so a page that flatters the hero is impossible.
    final controller = await openHero(tester);
    final stats = heroCombatStats(controller.state!, testBalanceConfig);

    expect(find.text(stats.attack.format()), findsOneWidget);
    expect(find.text(stats.maxHp.format()), findsOneWidget);
  });

  testWidgets('home is one tap away again', (tester) async {
    await openHero(tester);

    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();

    expect(find.byType(HeroPage), findsNothing);
    expect(find.byType(PlayerBar), findsOneWidget);
  });
}
