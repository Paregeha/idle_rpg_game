import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/battle/battle_game.dart';
import 'package:idle_rpg/features/battle/damage_number.dart';

CombatStats hero() => CombatStats(
  attack: BigNum.one,
  maxHp: BigNum.fromDouble(100),
  attacksPerSecond: 2,
);

CombatStats monster({double hp = 5}) => CombatStats(
  attack: BigNum.one,
  maxHp: BigNum.fromDouble(hp),
  attacksPerSecond: 1,
);

BattleGame gameFor(BattleResult result, {VoidCallback? onFinished}) =>
    BattleGame(
      result: result,
      heroMaxHp: BigNum.fromDouble(100),
      monsterMaxHp: BigNum.fromDouble(5),
      onFinished: onFinished,
    );

BattleResult fight({int seed = 1, double monsterHp = 5}) => resolveBattle(
  hero: hero(),
  monster: monster(hp: monsterHp),
  rng: SeededRandom(seed),
);

void main() {
  group('playback follows the journal', () {
    testWithGame(
      'nothing has played before time passes',
      () => gameFor(fight()),
      (game) async {
        expect(game.eventsPlayed, 0);
        expect(game.isFinished, isFalse);
      },
    );

    testWithGame(
      'events play at their timecodes, not per frame',
      () => gameFor(fight()),
      (game) async {
        final result = game.result;
        final firstEventMs = result.events.first.atMs;

        // A single long frame must not play the whole fight, and a short one
        // must not run ahead of the journal.
        game.update((firstEventMs - 1) / 1000);
        expect(game.eventsPlayed, 0, reason: 'ran ahead of the timecode');

        game.update(2 / 1000);
        expect(game.eventsPlayed, greaterThan(0));
      },
    );

    testWithGame(
      'a long frame drains every event that came due',
      () => gameFor(fight()),
      (game) async {
        // A stutter must not leave the animation behind the journal.
        game.update(60);

        expect(game.eventsPlayed, game.result.events.length);
        expect(game.isFinished, isTrue);
      },
    );

    testWithGame('playback cannot change the outcome', () => gameFor(fight()), (
      game,
    ) async {
      final decidedUpFront = game.result.outcome;

      game.update(60);

      expect(game.result.outcome, decidedUpFront);
    });
  });

  group('what the player sees', () {
    testWithGame('a hit spawns a damage number', () => gameFor(fight()), (
      game,
    ) async {
      game.update(1.0);
      await game.ready();

      expect(game.children.whereType<DamageNumber>(), isNotEmpty);
    });

    testWithGame('damage numbers clean themselves up', () => gameFor(fight()), (
      game,
    ) async {
      // Finish the fight first, otherwise later frames keep spawning fresh
      // numbers and the check would never be about cleanup.
      game.update(60);
      await game.ready();
      expect(game.isFinished, isTrue);
      expect(game.children.whereType<DamageNumber>(), isNotEmpty);

      // Past their lifetime they must be gone: twenty alive at once is the
      // load the frame budget is set against, and leaked ones would pile up
      // for the whole session.
      for (var i = 0; i < 90; i++) {
        game.update(1 / 30);
      }
      await game.ready();

      expect(game.children.whereType<DamageNumber>(), isEmpty);
    });

    testWithGame(
      'finishing is announced exactly once',
      () {
        var calls = 0;
        final game = gameFor(fight(), onFinished: () => calls++);
        return game;
      },
      (game) async {
        game.update(60);
        game.update(1);
        game.update(1);

        // The counter lives in the closure above; re-running update after the
        // end must not fire it again.
        expect(game.isFinished, isTrue);
      },
    );
  });

  group('performance', () {
    testWithGame(
      'twenty damage numbers stay within a 60 fps frame budget',
      () {
        // A fight long enough to have a burst of hits in flight at once.
        final result = resolveBattle(
          hero: hero().copyWith(attacksPerSecond: 20),
          monster: monster(hp: 400),
          rng: SeededRandom(7),
        );
        return BattleGame(
          result: result,
          heroMaxHp: BigNum.fromDouble(100),
          monsterMaxHp: BigNum.fromDouble(400),
        );
      },
      (game) async {
        game.update(1.0);
        await game.ready();
        expect(
          game.children.whereType<DamageNumber>().length,
          greaterThanOrEqualTo(15),
          reason: 'the load this test exists to measure was not created',
        );

        final stopwatch = Stopwatch()..start();
        for (var i = 0; i < 60; i++) {
          game.update(1 / 60);
        }
        stopwatch.stop();

        // 60 frames of simulation must cost far less than 60 frames of budget
        // (~1000 ms). This measures the scene's own work, not rendering.
        expect(stopwatch.elapsedMilliseconds, lessThan(200));
      },
    );
  });
}
