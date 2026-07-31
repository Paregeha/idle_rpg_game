import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Tough enough that these fights are about the casts, not about dying.
CombatStats get hero =>
    CombatStats(attack: BigNum.fromDouble(10), maxHp: BigNum(1, 9));

CombatStats monster({
  double hp = 1e6,
  double attack = 1,
  double mitigation = 0,
}) => CombatStats(
  attack: BigNum.fromDouble(attack),
  mitigation: mitigation,
  maxHp: BigNum.fromDouble(hp),
);

const cleave = ActiveSkill(
  id: 'cleave',
  cooldownMs: 3000,
  damageMultiplier: 5,
  targets: 0,
);

const jab = ActiveSkill(id: 'jab', cooldownMs: 2000, damageMultiplier: 3);

BattleResult fight({
  List<ActiveSkill> skills = const [],
  int monsters = 3,
  double hp = 1e6,
  int seconds = 10,
}) => resolveBattle(
  hero: hero,
  monsters: [for (var i = 0; i < monsters; i++) monster(hp: hp)],
  rng: SeededRandom(42),
  skills: skills,
  maxDuration: Duration(seconds: seconds),
);

List<BattleEvent> castsIn(BattleResult result) =>
    result.events.where((e) => e.kind == BattleEventKind.skill).toList();

void main() {
  group('casting', () {
    test('a skill lands as its own kind of event, named', () {
      // Not a hit with a big number: a player who cannot tell a cast from a
      // lucky crit has no reason to believe the skill does anything.
      final casts = castsIn(fight(skills: [jab]));

      expect(casts, isNotEmpty);
      expect(casts.every((e) => e.skillId == 'jab'), isTrue);
      expect(casts.every((e) => e.source == BattleSide.hero), isTrue);
    });

    test('it fires on its cooldown, not on the hero swing', () {
      final casts = castsIn(fight(skills: [jab]));

      expect(casts.map((e) => e.atMs), [2000, 4000, 6000, 8000, 10000]);
    });

    test('the first cast waits a full cooldown', () {
      // A fight that opens with every skill already firing would make the
      // cooldown itself meaningless.
      final casts = castsIn(fight(skills: [jab]));

      expect(casts.first.atMs, jab.cooldownMs);
    });

    test('an area skill hits everyone at the same timecode', () {
      final casts = castsIn(fight(skills: [cleave], seconds: 3));

      expect(casts, hasLength(3));
      expect(casts.map((e) => e.targetIndex), [0, 1, 2]);
      expect(casts.map((e) => e.atMs).toSet(), {3000});
    });

    test('a single-target skill hits one', () {
      final casts = castsIn(fight(skills: [jab], seconds: 2));

      expect(casts, hasLength(1));
      expect(casts.single.targetIndex, 0);
    });

    test('two skills both fire, each on its own cooldown', () {
      final casts = castsIn(fight(skills: [cleave, jab], seconds: 6));

      expect(casts.where((e) => e.skillId == 'jab').map((e) => e.atMs), [
        2000,
        4000,
        6000,
      ]);
      expect(
        casts.where((e) => e.skillId == 'cleave').map((e) => e.atMs).toSet(),
        {3000, 6000},
      );
    });

    test('a cast that kills marks the death', () {
      final result = fight(skills: [jab], monsters: 1, hp: 40, seconds: 3);
      final events = result.events;
      final killIndex = events.indexWhere(
        (e) => e.kind == BattleEventKind.skill && e.damage > BigNum.zero,
      );
      final death = events.indexWhere((e) => e.kind == BattleEventKind.death);

      expect(death, greaterThan(killIndex));
      expect(result.outcome, BattleOutcome.heroWon);
    });

    test('mitigation applies to a cast as it does to a swing', () {
      final full = resolveBattle(
        hero: hero,
        monsters: [monster()],
        rng: SeededRandom(1),
        skills: const [jab],
        maxDuration: const Duration(seconds: 2),
      );
      final armoured = resolveBattle(
        hero: hero,
        monsters: [monster(mitigation: 0.5)],
        rng: SeededRandom(1),
        skills: const [jab],
        maxDuration: const Duration(seconds: 2),
      );

      expect(
        castsIn(armoured).single.damage < castsIn(full).single.damage,
        isTrue,
      );
    });
  });

  group('determinism', () {
    test('the same seed gives the same journal', () {
      final a = fight(skills: [cleave, jab]);
      final b = fight(skills: [cleave, jab]);

      expect(a.events.length, b.events.length);
      for (var i = 0; i < a.events.length; i++) {
        expect(a.events[i], b.events[i], reason: 'event $i');
      }
    });

    test('adding a skill does not shift the swings around it', () {
      // A cast rolls neither dodge nor crit, so it consumes no draws. If it
      // did, adding a skill would silently re-roll every later swing and two
      // players with the same save would see different fights.
      List<BattleEvent> swingsOf(BattleResult result) =>
          result.events.where((e) => e.kind != BattleEventKind.skill).toList();

      final without = swingsOf(fight());
      final with_ = swingsOf(fight(skills: [jab]));

      expect(with_.length, without.length);
      for (var i = 0; i < without.length; i++) {
        expect(with_[i].kind, without[i].kind, reason: 'event $i kind');
        expect(with_[i].atMs, without[i].atMs, reason: 'event $i time');
        expect(with_[i].damage, without[i].damage, reason: 'event $i damage');
      }
    });

    test('a fight with no skills has no casts in it at all', () {
      // The parameter defaults to empty, so every fight resolved before skills
      // existed still resolves to exactly the same journal.
      final a = resolveBattle(
        hero: hero,
        monsters: [monster()],
        rng: SeededRandom(9),
        maxDuration: const Duration(seconds: 5),
      );

      expect(a.events, isNotEmpty);
      expect(a.events.any((e) => e.kind == BattleEventKind.skill), isFalse);
    });
  });
}
