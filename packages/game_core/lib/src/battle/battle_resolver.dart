import 'package:game_core/src/battle/battle_event.dart';
import 'package:game_core/src/battle/battle_result.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/random/seeded_random.dart';
import 'package:game_core/src/skills/skills.dart';

/// Damage of one swing.
///
/// Formula: `attack * critFactor * (1 - mitigation)`.
///
/// [critFactor] is `1` for a normal hit. [mitigation] is clamped into `0..1`:
/// a value above 1 would otherwise turn a hit into healing, which is the kind
/// of thing a tuning pass produces by accident.
BigNum damageOf({
  required BigNum attack,
  required double critFactor,
  required double mitigation,
}) {
  final absorbed = mitigation.clamp(0.0, 1.0);
  if (absorbed == 1.0) return BigNum.zero;

  return attack *
      BigNum.fromDouble(critFactor) *
      BigNum.fromDouble(1 - absorbed);
}

/// Resolves an entire fight up front and returns its journal.
///
/// The hero fights a **group**. A wave is several monsters at once, which is
/// what makes an area-of-effect skill mean anything later — a resolver that
/// only knows about one target would have to be rewritten to add them.
///
/// Nothing here is animated or timed against a real clock: the whole fight is
/// decided in one pass and the client plays the result back. That is what makes
/// a 2x button or a skipped animation unable to change the outcome, and what
/// lets the server recompute the same fight to check a claim.
///
/// Randomness comes from [rng], whose state travels with the player's save, so
/// the same fight replays identically anywhere (rule 5).
///
/// [skills] fire on their own cooldowns alongside the hero's swings. A cast is
/// a certainty — it rolls neither dodge nor crit — so adding one to a fight
/// cannot shift where every later swing lands in the random sequence. Its power
/// comes from the multiplier, not from luck.
///
/// [maxDuration] stops a fight that cannot end.
BattleResult resolveBattle({
  required CombatStats hero,
  required List<CombatStats> monsters,
  required SeededRandom rng,
  List<ActiveSkill> skills = const [],
  Duration maxDuration = const Duration(minutes: 2),
}) {
  if (monsters.isEmpty) {
    return const BattleResult(
      outcome: BattleOutcome.heroWon,
      events: [],
      durationMs: 0,
    );
  }

  final events = <BattleEvent>[];
  var heroHp = hero.maxHp;
  final monsterHp = [for (final monster in monsters) monster.maxHp];

  final heroIntervalMs = _intervalMs(hero.attacksPerSecond);
  final monsterIntervals = [
    for (final monster in monsters) _intervalMs(monster.attacksPerSecond),
  ];
  final limitMs = maxDuration.inMilliseconds;

  var nextHeroSwingMs = heroIntervalMs;
  final nextMonsterSwingMs = [...monsterIntervals];
  // Casts start one cooldown in, like swings do: a fight that opens with every
  // skill already firing would make the cooldown itself meaningless.
  final nextCastMs = [for (final skill in skills) skill.cooldownMs];
  var outcome = BattleOutcome.timeout;
  var atMs = 0;

  bool alive(int index) => monsterHp[index] > BigNum.zero;
  int? firstAlive() {
    for (var i = 0; i < monsterHp.length; i++) {
      if (alive(i)) return i;
    }
    return null;
  }

  while (true) {
    // Whoever swings next drives the clock. Ties go to the hero, which only
    // matters when both would land a killing blow on the same tick.
    var soonest = nextHeroSwingMs;
    var attackerIndex = -1;
    var castIndex = -1;

    // Strict `<`, checked in a fixed order, so ties resolve the same way every
    // time: hero swing, then skills, then monsters. A tie broken by map order
    // would be a fight the server could not reproduce.
    for (var i = 0; i < nextCastMs.length; i++) {
      if (nextCastMs[i] < soonest) {
        soonest = nextCastMs[i];
        castIndex = i;
        attackerIndex = -1;
      }
    }

    for (var i = 0; i < monsters.length; i++) {
      if (!alive(i)) continue;
      if (nextMonsterSwingMs[i] < soonest) {
        soonest = nextMonsterSwingMs[i];
        attackerIndex = i;
        castIndex = -1;
      }
    }

    atMs = soonest;
    if (atMs > limitMs) {
      atMs = limitMs;
      break;
    }

    if (castIndex != -1) {
      final skill = skills[castIndex];
      nextCastMs[castIndex] += skill.cooldownMs;

      final targets = <int>[];
      for (var i = 0; i < monsterHp.length; i++) {
        if (!alive(i)) continue;
        targets.add(i);
        if (!skill.hitsEveryone && targets.length >= skill.targets) break;
      }

      if (targets.isEmpty) {
        outcome = BattleOutcome.heroWon;
        break;
      }

      for (final target in targets) {
        final damage = damageOf(
          attack: hero.attack * BigNum.fromDouble(skill.damageMultiplier),
          critFactor: 1,
          mitigation: monsters[target].mitigation,
        );

        events.add(
          BattleEvent(
            atMs: atMs,
            kind: BattleEventKind.skill,
            source: BattleSide.hero,
            target: BattleSide.monster,
            targetIndex: target,
            damage: damage,
            skillId: skill.id,
          ),
        );

        monsterHp[target] -= damage;
        if (monsterHp[target] <= BigNum.zero) {
          events.add(
            BattleEvent(
              atMs: atMs,
              kind: BattleEventKind.death,
              source: BattleSide.hero,
              target: BattleSide.monster,
              targetIndex: target,
            ),
          );
        }
      }

      if (firstAlive() == null) {
        outcome = BattleOutcome.heroWon;
        break;
      }
    } else if (attackerIndex == -1) {
      nextHeroSwingMs += heroIntervalMs;

      final target = firstAlive();
      if (target == null) {
        outcome = BattleOutcome.heroWon;
        break;
      }

      final died = _swing(
        events: events,
        rng: rng,
        atMs: atMs,
        attacker: hero,
        defender: monsters[target],
        source: BattleSide.hero,
        target: BattleSide.monster,
        targetIndex: target,
        applyDamage: (damage) => monsterHp[target] -= damage,
        isDead: () => monsterHp[target] <= BigNum.zero,
      );

      if (died && firstAlive() == null) {
        outcome = BattleOutcome.heroWon;
        break;
      }
    } else {
      nextMonsterSwingMs[attackerIndex] += monsterIntervals[attackerIndex];

      final died = _swing(
        events: events,
        rng: rng,
        atMs: atMs,
        attacker: monsters[attackerIndex],
        defender: hero,
        source: BattleSide.monster,
        target: BattleSide.hero,
        targetIndex: attackerIndex,
        applyDamage: (damage) => heroHp -= damage,
        isDead: () => heroHp <= BigNum.zero,
      );

      if (died) {
        outcome = BattleOutcome.heroLost;
        break;
      }
    }
  }

  return BattleResult(
    outcome: outcome,
    events: List<BattleEvent>.unmodifiable(events),
    durationMs: atMs,
  );
}

/// One swing: dodge, then crit, then damage. Returns whether it killed.
bool _swing({
  required List<BattleEvent> events,
  required SeededRandom rng,
  required int atMs,
  required CombatStats attacker,
  required CombatStats defender,
  required BattleSide source,
  required BattleSide target,
  required int targetIndex,
  required void Function(BigNum damage) applyDamage,
  required bool Function() isDead,
}) {
  // Draw order matters for determinism: dodge is always rolled before crit, so
  // a change in one does not shift the other's position in the sequence.
  if (_roll(rng, defender.dodgeChance)) {
    events.add(
      BattleEvent(
        atMs: atMs,
        kind: BattleEventKind.dodge,
        source: source,
        target: target,
        targetIndex: targetIndex,
      ),
    );
    return false;
  }

  final crit = _roll(rng, attacker.critChance);
  final damage = damageOf(
    attack: attacker.attack,
    critFactor: crit ? attacker.critFactor : 1,
    mitigation: defender.mitigation,
  );

  events.add(
    BattleEvent(
      atMs: atMs,
      kind: crit ? BattleEventKind.crit : BattleEventKind.hit,
      source: source,
      target: target,
      targetIndex: targetIndex,
      damage: damage,
    ),
  );

  applyDamage(damage);
  if (!isDead()) return false;

  events.add(
    BattleEvent(
      atMs: atMs,
      kind: BattleEventKind.death,
      source: source,
      target: target,
      targetIndex: targetIndex,
    ),
  );
  return true;
}

/// A combatant that never swings is parked beyond any real fight rather than
/// dividing by zero.
int _intervalMs(double attacksPerSecond) {
  if (attacksPerSecond <= 0) return 1 << 30;
  final interval = (1000 / attacksPerSecond).round();
  return interval < 1 ? 1 : interval;
}

/// Consumes a draw for any chance strictly between 0 and 1.
///
/// Certainties short-circuit on purpose: a fight with `critChance: 1` must not
/// consume a different number of draws than one with `critChance: 0`, or the
/// two would desynchronise from the same seed.
bool _roll(SeededRandom rng, double chance) {
  if (chance <= 0) return false;
  if (chance >= 1) return true;
  return rng.nextDouble() < chance;
}
