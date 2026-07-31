import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config({int wavesPerStage = 5, int monstersPerWave = 3}) =>
    BalanceConfig(
      monsters: {
        'slime': MonsterConfig(
          baseHp: BigNum.fromDouble(10),
          hpGrowth: 1.5,
          rewardBase: BigNum.fromDouble(10),
          rewardGrowth: 1.4,
        ),
        'wyrm': MonsterConfig(
          baseHp: BigNum.fromDouble(100),
          hpGrowth: 1.5,
          rewardBase: BigNum.fromDouble(100),
          rewardGrowth: 1.4,
          baseAttack: BigNum.fromDouble(5),
        ),
      },
      progression: ProgressionConfig(
        wavesPerStage: wavesPerStage,
        monstersPerWave: monstersPerWave,
        stagesPerChapter: 3,
        monsters: const ['slime'],
        bosses: const ['wyrm'],
      ),
    );

PlayerState at({int chapter = 1, int stage = 1, int wave = 0}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  chapter: chapter,
  stage: stage,
  wave: wave,
);

void main() {
  group('what the player faces', () {
    test('an ordinary wave is a group', () {
      final encounter = encounterFor(at(), config())!;

      expect(encounter.monsters, hasLength(3));
      expect(encounter.isBoss, isFalse);
      expect(encounter.monsterId, 'slime');
    });

    test('the boss comes after the last wave, and comes alone', () {
      final encounter = encounterFor(at(wave: 5), config())!;

      expect(encounter.isBoss, isTrue);
      expect(encounter.monsters, hasLength(1));
      expect(encounter.monsterId, 'wyrm');
    });

    test('the boss is tougher than the wave it guards', () {
      final wave = encounterFor(at(), config())!;
      final boss = encounterFor(at(wave: 5), config())!;

      expect(boss.level, greaterThan(wave.level));
    });

    test('later stages are harder', () {
      final early = encounterFor(at(), config())!;
      final later = encounterFor(at(stage: 3), config())!;

      expect(later.level, greaterThan(early.level));
      expect(later.monsters.first.maxHp > early.monsters.first.maxHp, isTrue);
    });

    test('the reward covers the whole group', () {
      final encounter = encounterFor(at(), config())!;
      final single = encounterFor(at(), config(monstersPerWave: 1))!;

      expect(encounter.reward, single.reward * BigNum.fromDouble(3));
    });

    test('a config with no monsters yields nothing rather than crashing', () {
      expect(encounterFor(at(), const BalanceConfig()), isNull);
    });
  });

  group('advancing', () {
    test('a won wave moves to the next', () {
      expect(advanceAfterWin(at(), config()).wave, 1);
    });

    test('beating the boss opens the next stage', () {
      final after = advanceAfterWin(at(wave: 5), config());

      expect(after.stage, 2);
      expect(after.wave, 0);
    });

    test('the last stage of a chapter rolls into the next chapter', () {
      final after = advanceAfterWin(at(stage: 3, wave: 5), config());

      expect(after.chapter, 2);
      expect(after.stage, 1);
      expect(after.wave, 0);
    });

    test('a loss repeats the wave rather than pushing back', () {
      // Losing already costs time; taking progress away on top reads as
      // punishment for playing.
      final here = at(stage: 2, wave: 3);

      expect(afterLoss(here, config()), here);
    });

    test('a full chapter takes waves times stages fights', () {
      var current = at();
      var fights = 0;

      while (current.chapter == 1) {
        current = advanceAfterWin(current, config());
        fights++;
      }

      // 3 stages x (5 waves + 1 boss)
      expect(fights, 18);
    });

    test('the label reads like a stage number', () {
      expect(stageLabel(at(chapter: 3, stage: 7)), '3-7');
    });
  });

  group('config validation', () {
    test('refuses a stage with no waves', () {
      expect(
        () => BalanceConfig.parse(
          '{"version": 1, "progression": {"wavesPerStage": 0}}',
        ),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a monster the config does not define', () {
      expect(
        () => BalanceConfig.parse(
          '{"version": 1, "progression": {"monsters": ["ghost"]}}',
        ),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
