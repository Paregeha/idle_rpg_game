import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Tough enough to survive the fights that are not about the hero dying —
/// with the default 1 HP every fight would end on the monster's first swing,
/// which would make most of these tests pass for the wrong reason.
CombatStats get _hero => CombatStats(attack: BigNum.one, maxHp: BigNum(1, 4));

CombatStats monster({
  double hp = 10,
  double attack = 1,
  double mitigation = 0,
  double dodgeChance = 0,
  double attacksPerSecond = 1,
}) => CombatStats(
  attack: BigNum.fromDouble(attack),
  attacksPerSecond: attacksPerSecond,
  mitigation: mitigation,
  dodgeChance: dodgeChance,
  maxHp: BigNum.fromDouble(hp),
);

void main() {
  group('damage formula', () {
    // atk * critFactor * (1 - mitigation)
    final cases = <String, ({double atk, double crit, double mit, double out})>{
      'plain hit': (atk: 100, crit: 1, mit: 0, out: 100),
      'critical hit doubles': (atk: 100, crit: 2, mit: 0, out: 200),
      'half mitigated': (atk: 100, crit: 1, mit: 0.5, out: 50),
      'crit through mitigation': (atk: 100, crit: 2, mit: 0.25, out: 150),
      'full mitigation absorbs all': (atk: 100, crit: 1, mit: 1, out: 0),
      'fractional crit factor': (atk: 80, crit: 1.5, mit: 0.2, out: 96),
    };

    for (final entry in cases.entries) {
      final c = entry.value;
      test(entry.key, () {
        expect(
          damageOf(
            attack: BigNum.fromDouble(c.atk),
            critFactor: c.crit,
            mitigation: c.mit,
          ),
          BigNum.fromDouble(c.out),
        );
      });
    }

    test('mitigation above 1 never heals the target', () {
      expect(
        damageOf(
          attack: BigNum.fromDouble(100),
          critFactor: 1,
          mitigation: 1.5,
        ),
        BigNum.zero,
      );
    });

    test('holds at magnitudes double cannot', () {
      expect(
        damageOf(attack: BigNum(1, 100), critFactor: 2, mitigation: 0.5),
        BigNum(1, 100),
      );
    });
  });

  group('the journal', () {
    test('records every swing with a timecode', () {
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 3),
        rng: SeededRandom(1),
      );

      expect(result.events, isNotEmpty);
      expect(result.events.first.atMs, greaterThanOrEqualTo(0));
      for (var i = 1; i < result.events.length; i++) {
        expect(
          result.events[i].atMs,
          greaterThanOrEqualTo(result.events[i - 1].atMs),
          reason: 'timecodes must never go backwards',
        );
      }
    });

    test('ends with a death', () {
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 3),
        rng: SeededRandom(1),
      );

      expect(result.events.last.kind, BattleEventKind.death);
    });

    test('a guaranteed crit is recorded as a crit', () {
      final result = resolveBattle(
        hero: _hero.copyWith(critChance: 1),
        monster: monster(hp: 100),
        rng: SeededRandom(1),
      );

      final heroSwings = result.events.where(
        (e) => e.source == BattleSide.hero,
      );
      expect(
        heroSwings.where((e) => e.kind == BattleEventKind.crit),
        isNotEmpty,
      );
      expect(
        heroSwings.where((e) => e.kind == BattleEventKind.hit),
        isEmpty,
      );
    });

    test('a guaranteed dodge is recorded as a dodge', () {
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 100, dodgeChance: 1),
        rng: SeededRandom(1),
        maxDuration: const Duration(seconds: 5),
      );

      final atMonster = result.events.where(
        (e) => e.target == BattleSide.monster,
      );
      expect(atMonster, isNotEmpty);
      expect(
        atMonster.every((e) => e.kind == BattleEventKind.dodge),
        isTrue,
        reason: 'a monster that always dodges can never be hit',
      );
      expect(result.outcome, BattleOutcome.timeout);
    });

    test('events carry the damage dealt', () {
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 5),
        rng: SeededRandom(1),
      );

      final firstHit = result.events.firstWhere(
        (e) => e.kind == BattleEventKind.hit,
      );
      expect(firstHit.damage, BigNum.one);
    });

    test('attack speed sets the spacing of timecodes', () {
      final result = resolveBattle(
        hero: _hero.copyWith(attacksPerSecond: 2),
        monster: monster(hp: 3),
        rng: SeededRandom(1),
      );

      final heroSwings = result.events
          .where((e) => e.source == BattleSide.hero)
          .toList();
      expect(heroSwings[1].atMs - heroSwings[0].atMs, 500);
    });
  });

  group('determinism', () {
    test('the same seed produces an identical journal', () {
      BattleResult run() => resolveBattle(
        hero: _hero.copyWith(critChance: 0.5),
        monster: monster(hp: 50, dodgeChance: 0.2, attack: 2),
        rng: SeededRandom(20260730),
      );

      final a = run();
      final b = run();

      expect(a.events.length, b.events.length);
      for (var i = 0; i < a.events.length; i++) {
        expect(a.events[i].kind, b.events[i].kind);
        expect(a.events[i].atMs, b.events[i].atMs);
        expect(a.events[i].damage, b.events[i].damage);
      }
      expect(a.outcome, b.outcome);
    });

    test('a different seed can produce a different journal', () {
      final a = resolveBattle(
        hero: _hero.copyWith(critChance: 0.5),
        monster: monster(hp: 200, dodgeChance: 0.3),
        rng: SeededRandom(1),
      );
      final b = resolveBattle(
        hero: _hero.copyWith(critChance: 0.5),
        monster: monster(hp: 200, dodgeChance: 0.3),
        rng: SeededRandom(2),
      );

      expect(
        a.events.map((e) => e.kind).toList(),
        isNot(b.events.map((e) => e.kind).toList()),
      );
    });

    test('the result is complete before anything is played back', () {
      // The whole point: a client renders this, it does not produce it.
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 20),
        rng: SeededRandom(5),
      );

      expect(result.outcome, isNotNull);
      expect(result.duration.inMilliseconds, result.events.last.atMs);
      expect(result.events, isNotEmpty);
    });
  });

  group('outcomes', () {
    test('the hero wins when the monster dies first', () {
      final result = resolveBattle(
        hero: _hero,
        monster: monster(hp: 3, attack: 0),
        rng: SeededRandom(1),
      );

      expect(result.outcome, BattleOutcome.heroWon);
      expect(result.events.last.target, BattleSide.monster);
    });

    test('the hero loses when out-damaged', () {
      final result = resolveBattle(
        hero: _hero.copyWith(maxHp: BigNum.fromDouble(2)),
        monster: monster(hp: 1000, attack: 10),
        rng: SeededRandom(1),
      );

      expect(result.outcome, BattleOutcome.heroLost);
      expect(result.events.last.target, BattleSide.hero);
    });

    test('a stalemate times out instead of running forever', () {
      final result = resolveBattle(
        hero: _hero.copyWith(attack: BigNum.zero),
        monster: monster(hp: 100, attack: 0),
        rng: SeededRandom(1),
        maxDuration: const Duration(seconds: 3),
      );

      expect(result.outcome, BattleOutcome.timeout);
      expect(result.duration, lessThanOrEqualTo(const Duration(seconds: 3)));
    });

    test('a fight that cannot end is still cheap to resolve', () {
      final stopwatch = Stopwatch()..start();

      resolveBattle(
        hero: _hero.copyWith(attack: BigNum.zero),
        monster: monster(hp: 100, attack: 0, attacksPerSecond: 20),
        rng: SeededRandom(1),
        maxDuration: const Duration(minutes: 10),
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });
  });
}
