import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/skills/skill_card.dart';
import 'package:idle_rpg/state/game_controller.dart';

import 'support/test_app.dart';

Future<GameController> withSkills(
  WidgetTester tester, {
  Map<String, int> skills = const {},
  Map<String, int> copies = const {},
  int heroLevel = 20,
  double gems = 1000,
}) async {
  await pumpGame(tester);
  final controller = containerOf(tester).read(gameControllerProvider.notifier);

  controller.state = controller.state!.copyWith(
    heroLevel: heroLevel,
    skills: skills,
    skillCopies: copies,
    resources: {'gems': BigNum.fromDouble(gems)},
  );
  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('a locked slot names the level it opens at', (tester) async {
    // "Come back at 12" is a goal. "Locked" is a wall.
    await withSkills(tester, heroLevel: 1);

    expect(find.text('12'), findsWidgets);
    expect(find.byIcon(Icons.lock_outline), findsWidgets);
  });

  testWidgets('a learned skill shows its level instead of a padlock', (
    tester,
  ) async {
    await withSkills(tester, skills: {'jab': 3});

    expect(find.text('3'), findsWidgets);
  });

  testWidgets('tapping a slot opens the skill', (tester) async {
    await withSkills(tester, skills: {'jab': 1});

    await tester.tap(find.byIcon(Icons.bolt).first);
    await tester.pumpAndSettle();

    expect(find.byType(SkillCard), findsOneWidget);
  });

  testWidgets('the card upgrades in place and spends the copies', (
    tester,
  ) async {
    final controller = await withSkills(
      tester,
      skills: {'jab': 1},
      copies: {'jab': 9},
    );

    await tester.tap(find.byIcon(Icons.bolt).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('UPGRADE'));
    await tester.pumpAndSettle();

    expect(controller.state!.skills['jab'], 2);
    expect(controller.state!.skillCopies['jab'], lessThan(9));
    expect(
      find.byType(SkillCard),
      findsOneWidget,
      reason: 'the card stays open so the next level can be pressed too',
    );
  });

  testWidgets('the card says why instead of failing silently', (tester) async {
    await withSkills(tester, skills: {'jab': 1});

    await tester.tap(find.byIcon(Icons.bolt).first);
    await tester.pumpAndSettle();

    expect(find.text('NEEDS MORE COPIES'), findsOneWidget);
  });

  testWidgets('a pack costs gems and gives a copy', (tester) async {
    final controller = await withSkills(tester, gems: 500);
    final before = controller.state!.resources['gems']!;

    await tester.tap(find.byIcon(Icons.auto_awesome_motion));
    await tester.pumpAndSettle();

    expect(controller.state!.resources['gems']! < before, isTrue);
    expect(controller.state!.skills, isNotEmpty);
  });

  testWidgets('a pack cannot be bought without gems', (tester) async {
    final controller = await withSkills(tester, gems: 0);

    await tester.tap(find.byIcon(Icons.auto_awesome_motion));
    await tester.pumpAndSettle();

    expect(controller.state!.skills, isEmpty);
  });
}
