import 'package:game_core/src/battle/battle_event.dart';
import 'package:game_core/src/battle/battle_result.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/random/seeded_random.dart';

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
/// Nothing here is animated, timed against a real clock or spread across
/// frames: the whole fight is decided in one pass, and the client plays the
/// result back (`T-023`). That is what makes a 2x button, a skipped animation
/// or a backgrounded app unable to change the outcome — and what lets the
/// server recompute the same fight to check a claim.
///
/// Randomness comes from [rng], whose state travels with the player's save, so
/// the same fight replays identically anywhere (rule 5).
///
/// [maxDuration] stops a fight that cannot end — two combatants who cannot hurt
/// each other would otherwise loop forever. The result is
/// [BattleOutcome.timeout], which the caller decides how to treat.
BattleResult resolveBattle({
  required CombatStats hero,
  required CombatStats monster,
  required SeededRandom rng,
  Duration maxDuration = const Duration(minutes: 2),
}) {
  final events = <BattleEvent>[];
  var heroHp = hero.maxHp;
  var monsterHp = monster.maxHp;

  final heroIntervalMs = _intervalMs(hero.attacksPerSecond);
  final monsterIntervalMs = _intervalMs(monster.attacksPerSecond);
  final limitMs = maxDuration.inMilliseconds;

  var nextHeroSwingMs = heroIntervalMs;
  var nextMonsterSwingMs = monsterIntervalMs;
  var outcome = BattleOutcome.timeout;
  var atMs = 0;

  while (true) {
    // Whoever swings next drives the clock forward. Ties go to the hero, which
    // only matters when both would land a killing blow on the same tick.
    final heroFirst = nextHeroSwingMs <= nextMonsterSwingMs;
    atMs = heroFirst ? nextHeroSwingMs : nextMonsterSwingMs;
    if (atMs > limitMs) {
      atMs = limitMs;
      break;
    }

    final attacker = heroFirst ? hero : monster;
    final defender = heroFirst ? monster : hero;
    final source = heroFirst ? BattleSide.hero : BattleSide.monster;
    final target = heroFirst ? BattleSide.monster : BattleSide.hero;

    if (heroFirst) {
      nextHeroSwingMs += heroIntervalMs;
    } else {
      nextMonsterSwingMs += monsterIntervalMs;
    }

    // Draw order matters for determinism: dodge is always rolled before crit,
    // so a change in one does not shift the other's position in the sequence.
    final dodged = _roll(rng, defender.dodgeChance);
    if (dodged) {
      events.add(
        BattleEvent(
          atMs: atMs,
          kind: BattleEventKind.dodge,
          source: source,
          target: target,
        ),
      );
      continue;
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
        damage: damage,
      ),
    );

    if (heroFirst) {
      monsterHp -= damage;
    } else {
      heroHp -= damage;
    }

    final defenderDead = heroFirst
        ? monsterHp <= BigNum.zero
        : heroHp <= BigNum.zero;
    if (defenderDead) {
      events.add(
        BattleEvent(
          atMs: atMs,
          kind: BattleEventKind.death,
          source: source,
          target: target,
        ),
      );
      outcome = heroFirst ? BattleOutcome.heroWon : BattleOutcome.heroLost;
      break;
    }
  }

  return BattleResult(
    outcome: outcome,
    events: List<BattleEvent>.unmodifiable(events),
    durationMs: atMs,
  );
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
