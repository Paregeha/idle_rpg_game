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
    this.monsterCount = 1,
    this.topInset = 0,
    this.onFinished,
    this.speed = 1.0,
  });

  /// The journal to play. Read-only input.
  final BattleResult result;

  final BigNum heroMaxHp;
  final BigNum monsterMaxHp;

  /// How many monsters are in this wave. The scene has to show all of them, or
  /// the player watches a different fight from the one being resolved.
  final int monsterCount;

  /// Height at the top of the panel that widgets above the scene occupy.
  ///
  /// The fight is staged in what is left, so nothing is drawn behind them.
  final double topInset;

  /// Called once the last event has been played.
  final VoidCallback? onFinished;

  /// Playback speed. Cosmetic only — see the class doc.
  final double speed;

  late final CombatantComponent _hero;
  late final List<CombatantComponent> _monsters;

  double _elapsedMs = 0;
  int _nextEvent = 0;
  BigNum _heroHp = BigNum.zero;
  late final List<BigNum> _monsterHp;
  bool _finishedAnnounced = false;

  /// Events played so far. Exposed so tests can assert playback progress.
  int get eventsPlayed => _nextEvent;

  bool get isFinished => _nextEvent >= result.events.length;

  @override
  Color backgroundColor() => GamePalette.forgeDark;

  @override
  Future<void> onLoad() async {
    _heroHp = heroMaxHp;
    _monsterHp = List<BigNum>.filled(monsterCount, monsterMaxHp);

    // The stage is what is left below whatever floats over the scene.
    final stageHeight = (size.y - topInset).clamp(1.0, size.y);
    final centre = Vector2(size.x / 2, topInset + stageHeight / 2);

    _hero = CombatantComponent(
      colour: GamePalette.emberBright,
      facingRight: true,
      position: Vector2(centre.x - size.x * 0.26, centre.y),
    );

    // Spread across whatever height the stage actually has. A fixed spacing
    // pushed the outer monsters off the panel and over the rest of the screen
    // once the scene stopped being full-height.
    final spread = monsterCount <= 1
        ? 0.0
        : (stageHeight * 0.55) / (monsterCount - 1);

    _monsters = [
      for (var i = 0; i < monsterCount; i++)
        CombatantComponent(
          colour: GamePalette.patina,
          facingRight: false,
          position: Vector2(
            centre.x + size.x * (monsterCount == 1 ? 0.26 : 0.2),
            centre.y + (i - (monsterCount - 1) / 2) * spread,
          ),
        ),
    ];

    await addAll([_hero, ..._monsters]);
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

  CombatantComponent _monsterAt(int index) =>
      _monsters[index.clamp(0, _monsters.length - 1)];

  void _play(BattleEvent event) {
    final attacker = event.source == BattleSide.hero
        ? _hero
        : _monsterAt(event.targetIndex);
    final defender = event.target == BattleSide.hero
        ? _hero
        : _monsterAt(event.targetIndex);

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
      return;
    }

    final index = event.targetIndex.clamp(0, _monsterHp.length - 1);
    _monsterHp[index] -= event.damage;
    _monsterAt(
      index,
    ).setHealthFraction(_fraction(_monsterHp[index], monsterMaxHp));
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
    // Spread the numbers so a burst does not stack into an unreadable pile,
    // and keep them inside the panel: a number that floats out of the scene
    // lands on whatever widget is above it.
    final jitter = (_nextEvent % 5 - 2) * 14.0;
    final wanted = target.position + Vector2(jitter, -target.size.y * 0.6);
    // On a panel too short to hold both margins the bottom one wins, so the
    // clamp always gets a range it can satisfy.
    final lowest = size.y - 24;
    final highest = (topInset + 12).clamp(0.0, lowest);

    add(
      DamageNumber(
        text: damage.format(),
        crit: crit,
        position: Vector2(
          wanted.x.clamp(30.0, size.x - 30),
          wanted.y.clamp(highest, lowest),
        ),
      ),
    );
  }
}
