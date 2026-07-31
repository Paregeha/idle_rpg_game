import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config({
  int unlockAtLevel = 0,
  int maxLevel = 10,
  int copiesBase = 2,
  double copiesGrowth = 2,
  double bossDropChance = 0,
  double monsterDropChance = 0,
  int pityThreshold = 0,
}) => BalanceConfig(
  rarities: const {'common': RarityConfig(), 'epic': RarityConfig(rank: 2)},
  skills: {
    'cleave': SkillConfig(
      unlockAtLevel: unlockAtLevel,
      maxLevel: maxLevel,
      copiesBase: copiesBase,
      copiesGrowth: copiesGrowth,
      targets: 0,
    ),
    'jab': SkillConfig(
      rarity: 'epic',
      unlockAtLevel: unlockAtLevel,
      maxLevel: maxLevel,
      copiesBase: copiesBase,
      copiesGrowth: copiesGrowth,
    ),
  },
  skillPack: SkillPackConfig(
    costAmount: 10,
    weights: const {'common': 1, 'epic': 1},
    pityThreshold: pityThreshold,
    pityRarity: pityThreshold > 0 ? 'epic' : '',
    bossDropChance: bossDropChance,
    monsterDropChance: monsterDropChance,
  ),
);

PlayerState state({
  Map<String, int> skills = const {},
  Map<String, int> copies = const {},
  double gems = 1000,
  int heroLevel = 10,
}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 7,
  heroLevel: heroLevel,
  skills: skills,
  skillCopies: copies,
  resources: {'gems': BigNum.fromDouble(gems)},
);

void main() {
  group('copies', () {
    test('the first one teaches the skill instead of banking', () {
      final granted = grantSkillCopy(state(), 'cleave');

      expect(granted.learned, isTrue);
      expect(granted.state.skills['cleave'], 1);
      expect(
        granted.state.skillCopies['cleave'],
        anyOf(isNull, 0),
        reason: 'the copy was spent on learning it, not banked',
      );
    });

    test('every copy after it banks', () {
      var current = grantSkillCopy(state(), 'cleave').state;
      current = grantSkillCopy(current, 'cleave').state;
      current = grantSkillCopy(current, 'cleave').state;

      expect(current.skills['cleave'], 1);
      expect(current.skillCopies['cleave'], 2);
    });

    test('a copy of a skill too high a level to use is still kept', () {
      // A boss kill that paid nothing because the hero was two levels short
      // reads as the game losing the reward.
      final granted = grantSkillCopy(state(heroLevel: 0), 'cleave');

      expect(granted.state.skills['cleave'], 1);
      expect(
        activeSkills(granted.state, config(unlockAtLevel: 5)),
        isEmpty,
        reason: 'kept, but not yet firing',
      );
    });
  });

  group('upgrading', () {
    test('spends copies and raises the level', () {
      final result = upgradeSkill(
        state(skills: {'cleave': 1}, copies: {'cleave': 5}),
        'cleave',
        config(),
      );

      expect(result.level, 2);
      expect(result.spentCopies, 2);
      expect(result.state.skillCopies['cleave'], 3);
    });

    test('the price climbs with the level', () {
      // 2, then 4, then 8 at growth 2.
      var current = state(skills: {'cleave': 1}, copies: {'cleave': 14});
      for (var i = 0; i < 3; i++) {
        current = upgradeSkill(current, 'cleave', config()).state;
      }

      expect(current.skills['cleave'], 4);
      expect(current.skillCopies['cleave'], 0);
    });

    test('refuses without enough copies and changes nothing', () {
      final before = state(skills: {'cleave': 1}, copies: {'cleave': 1});
      final result = upgradeSkill(before, 'cleave', config());

      expect(result.refusal, SkillRefusal.notEnoughCopies);
      expect(result.state, before);
    });

    test('refuses a skill the player has never seen', () {
      expect(
        upgradeSkill(state(copies: {'cleave': 99}), 'cleave', config()).refusal,
        SkillRefusal.notLearned,
      );
    });

    test('refuses a skill the config does not define', () {
      expect(
        upgradeSkill(state(skills: {'ghost': 1}), 'ghost', config()).refusal,
        SkillRefusal.unknownSkill,
      );
    });

    test('refuses past the configured maximum', () {
      final result = upgradeSkill(
        state(skills: {'cleave': 3}, copies: {'cleave': 999}),
        'cleave',
        config(maxLevel: 3),
      );

      expect(result.refusal, SkillRefusal.alreadyMaxLevel);
    });

    test('is pure', () {
      final before = state(skills: {'cleave': 1}, copies: {'cleave': 9});
      final snapshot = before.toJson();

      upgradeSkill(before, 'cleave', config());

      expect(before.toJson(), snapshot);
    });

    test('ten upgrades in a row strengthen the skill monotonically', () {
      var current = state(skills: {'cleave': 1}, copies: {'cleave': 100000});
      var previous = 0.0;

      for (var level = 1; level <= 10; level++) {
        final power = config().skills['cleave']!.damageAt(level);
        expect(power, greaterThan(previous), reason: 'level $level');
        previous = power;

        if (level == 10) break;
        final result = upgradeSkill(current, 'cleave', config());
        expect(result.upgraded, isTrue, reason: 'upgrade $level was refused');
        current = result.state;
        expect(PlayerState.fromJson(current.toJson()), current);
      }

      expect(current.skills['cleave'], 10);
    });
  });

  group('what fires in a fight', () {
    test('a skill below its unlock level is left out entirely', () {
      final active = activeSkills(
        state(skills: {'cleave': 1}, heroLevel: 3),
        config(unlockAtLevel: 5),
      );

      expect(active, isEmpty);
    });

    test('order does not depend on map iteration', () {
      final one = activeSkills(
        state(skills: {'jab': 1, 'cleave': 1}),
        config(),
      );
      final other = activeSkills(
        state(skills: {'cleave': 1, 'jab': 1}),
        config(),
      );

      expect(one.map((s) => s.id), other.map((s) => s.id));
      expect(one.map((s) => s.id), ['cleave', 'jab']);
    });

    test('nothing fires with auto-cast off', () {
      // The fight is resolved in one pass before it is drawn, so there is no
      // moment during it at which a tap could land: off means the hero fights
      // on gear alone, not that casting moves to the player.
      final off = state(skills: {'jab': 1}).copyWith(autoCast: false);

      expect(activeSkills(off, config()), isEmpty);
      expect(
        activeSkills(off.copyWith(autoCast: true), config()),
        isNotEmpty,
        reason: 'the same save with it on must cast',
      );
    });

    test('a higher level casts harder', () {
      final low = activeSkills(state(skills: {'jab': 1}), config()).single;
      final high = activeSkills(state(skills: {'jab': 4}), config()).single;

      expect(high.damageMultiplier, greaterThan(low.damageMultiplier));
    });
  });

  group('packs', () {
    test('cost the configured resource and give a copy', () {
      final result = openSkillPack(state(gems: 10), config());

      expect(result.opened, isTrue);
      expect(result.state.resources['gems'], BigNum.zero);
      expect(config().skills.containsKey(result.skillId), isTrue);
    });

    test('refuse when the player cannot pay and change nothing', () {
      final before = state(gems: 1);
      final result = openSkillPack(before, config());

      expect(result.refusal, SkillPackRefusal.cannotAfford);
      expect(result.state, before);
    });

    test('the same seed gives the same sequence', () {
      var a = state();
      var b = state();
      final drawnA = <String>[];
      final drawnB = <String>[];

      for (var i = 0; i < 20; i++) {
        final resultA = openSkillPack(a, config());
        final resultB = openSkillPack(b, config());
        a = resultA.state;
        b = resultB.state;
        drawnA.add(resultA.skillId!);
        drawnB.add(resultB.skillId!);
      }

      expect(drawnA, drawnB);
    });

    test('pity guarantees the rarity once the threshold is reached', () {
      var current = state();
      for (var i = 0; i < 2; i++) {
        current = openSkillPack(current, config(pityThreshold: 3)).state;
      }

      final result = openSkillPack(current, config(pityThreshold: 3));

      expect(result.wasPity, isTrue);
      expect(config().skills[result.skillId]!.rarity, 'epic');
      expect(result.state.skillPity, 0);
    });
  });

  group('drops', () {
    test('a boss can drop a copy', () {
      final result = rollSkillDrop(
        state(),
        config(bossDropChance: 1),
        fromBoss: true,
      );

      expect(result.opened, isTrue);
      expect(result.state.skills, isNotEmpty);
    });

    test('an ordinary monster uses its own, lower chance', () {
      final never = rollSkillDrop(
        state(),
        config(bossDropChance: 1),
        fromBoss: false,
      );

      expect(
        never.opened,
        isFalse,
        reason: 'the boss chance must not leak onto ordinary monsters',
      );
    });

    test('a failed roll still advances the random state', () {
      // Otherwise the same losing roll replays forever and the player never
      // sees a drop at all.
      final before = state();
      final result = rollSkillDrop(
        before,
        config(monsterDropChance: 0.0001),
        fromBoss: false,
      );

      expect(result.opened, isFalse);
      expect(result.state.rngState, isNot(before.rngState));
    });

    test('costs nothing', () {
      final result = rollSkillDrop(
        state(gems: 500),
        config(bossDropChance: 1),
        fromBoss: true,
      );

      expect(result.state.resources['gems'], BigNum.fromDouble(500));
    });
  });

  group('config validation', () {
    test('refuses a cooldown of zero', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "skills": {"x": {"cooldownSeconds": 0}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a level curve that weakens the skill', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "skills": {"x": {"levelMultiplier": 0.9}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a rarity no rarity defines', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "skills": {"x": {"rarity": "mythic"}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a drop chance outside 0..1', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "skillPack": {"bossDropChance": 1.5} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses copies that get cheaper with level', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "skills": {"x": {"copiesGrowth": 0.5}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
