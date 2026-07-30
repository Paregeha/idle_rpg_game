import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/battle/combatant_component.dart';
import 'package:idle_rpg/features/battle/damage_number.dart';

/// Plays a resolved battle back.
///
/// The fight was decided in full before this game existed (`T-016`); nothing
/// here can change the outcome. Speeding playback up, skipping it or killing
/// the app mid-animation only changes what the player *sees* — which is the
/// entire reason the resolver is separate from the scene.
///
/// Shapes stand in for sprites for now. The scene never draws anything itself;
/// combatants own their rendering, so swapping in animations later (`T-024`)
/// leaves this playback logic untouched.
class BattleGame extends FlameGame {
  BattleGame({
    required this.result,
    required this.heroMaxHp,
    required this.monsterMaxHp,
    this.onFinished,
    this.speed = 1.0,
  });

  /// The journal to play. Read-only input.
  final BattleResult result;

  final BigNum heroMaxHp;
  final BigNum monsterMaxHp;

  /// Called once the last event has been played.
  final VoidCallback? onFinished;

  /// Playback speed. Cosmetic only — see the class doc.
  final double speed;

  late final CombatantComponent _hero;
  late final CombatantComponent _monster;

  double _elapsedMs = 0;
  int _nextEvent = 0;
  BigNum _heroHp = BigNum.zero;
  BigNum _monsterHp = BigNum.zero;
  bool _finishedAnnounced = false;

  /// Events played so far. Exposed so tests can assert playback progress.
  int get eventsPlayed => _nextEvent;

  bool get isFinished => _nextEvent >= result.events.length;

  @override
  Color backgroundColor() => GamePalette.forgeDark;

  @override
  Future<void> onLoad() async {
    _heroHp = heroMaxHp;
    _monsterHp = monsterMaxHp;

    final centre = size / 2;
    _hero = CombatantComponent(
      colour: GamePalette.emberBright,
      facingRight: true,
      position: Vector2(centre.x - size.x * 0.22, centre.y),
    );
    _monster = CombatantComponent(
      colour: GamePalette.patina,
      facingRight: false,
      position: Vector2(centre.x + size.x * 0.22, centre.y),
    );

    await addAll([_hero, _monster]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isFinished) {
      _announceFinished();
      return;
    }

    _elapsedMs += dt * 1000 * speed;

    // Several events can share a timecode, and a slow frame can span many, so
    // this drains everything that is due rather than one per frame. Playing one
    // per frame would let the animation fall behind the journal on a stutter.
    while (_nextEvent < result.events.length &&
        result.events[_nextEvent].atMs <= _elapsedMs) {
      _play(result.events[_nextEvent]);
      _nextEvent++;
    }

    if (isFinished) _announceFinished();
  }

  void _announceFinished() {
    if (_finishedAnnounced) return;
    _finishedAnnounced = true;
    onFinished?.call();
  }

  void _play(BattleEvent event) {
    final attacker = event.source == BattleSide.hero ? _hero : _monster;
    final defender = event.target == BattleSide.hero ? _hero : _monster;

    switch (event.kind) {
      case BattleEventKind.hit:
      case BattleEventKind.crit:
        attacker.lunge();
        defender.flinch();
        _applyDamage(event);
        _showDamage(
          defender,
          event.damage,
          crit: event.kind == BattleEventKind.crit,
        );
      case BattleEventKind.dodge:
        attacker.lunge();
        defender.dodge();
      case BattleEventKind.death:
        defender.die();
    }
  }

  void _applyDamage(BattleEvent event) {
    if (event.target == BattleSide.hero) {
      _heroHp -= event.damage;
      _hero.setHealthFraction(_fraction(_heroHp, heroMaxHp));
    } else {
      _monsterHp -= event.damage;
      _monster.setHealthFraction(_fraction(_monsterHp, monsterMaxHp));
    }
  }

  /// Health left as a fraction, computed in [BigNum] and only then collapsed to
  /// a double — the health itself routinely exceeds what a double can hold.
  double _fraction(BigNum remaining, BigNum max) {
    if (max.isZero || remaining.isNegative || remaining.isZero) return 0;
    return (remaining / max).toDouble().clamp(0.0, 1.0);
  }

  void _showDamage(
    CombatantComponent target,
    BigNum damage, {
    required bool crit,
  }) {
    // Spread the numbers so a burst does not stack into an unreadable pile.
    final jitter = (_nextEvent % 5 - 2) * 14.0;

    add(
      DamageNumber(
        text: damage.format(),
        crit: crit,
        position: target.position + Vector2(jitter, -target.size.y * 0.6),
      ),
    );
  }
}
