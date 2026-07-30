import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// A fighter on screen, drawn as a shape until sprites arrive (`T-024`).
///
/// Everything about how a combatant looks lives here, so swapping the shape
/// for a `SpriteAnimationComponent` later touches this file and nothing else —
/// the playback logic in `BattleGame` never draws anything itself.
class CombatantComponent extends PositionComponent {
  CombatantComponent({
    required this.colour,
    required this.facingRight,
    required super.position,
  }) : super(size: Vector2(64, 96), anchor: Anchor.center);

  final Color colour;
  final bool facingRight;

  late final _HealthBar _healthBar;
  late final RectangleComponent _body;

  bool _dead = false;

  @override
  Future<void> onLoad() async {
    _body = RectangleComponent(
      size: size.clone(),
      paint: Paint()..color = colour,
    );

    // A notch on the leading edge, so the two silhouettes read as facing each
    // other rather than as two identical blocks.
    final blade = RectangleComponent(
      size: Vector2(10, 34),
      position: Vector2(facingRight ? size.x : -10, size.y * 0.3),
      paint: Paint()..color = colour.withValues(alpha: 0.55),
    );

    _healthBar = _HealthBar(
      width: size.x * 1.3,
      position: Vector2(-size.x * 0.15, -18),
    );

    await addAll([_body, blade, _healthBar]);
  }

  void setHealthFraction(double fraction) => _healthBar.fraction = fraction;

  /// A step towards the target and back — reads as a swing without animation.
  void lunge() {
    if (_dead) return;
    final distance = facingRight ? 22.0 : -22.0;

    add(
      MoveByEffect(
        Vector2(distance, 0),
        EffectController(duration: 0.08, alternate: true),
      ),
    );
  }

  /// A brief flash on taking damage.
  void flinch() {
    if (_dead) return;
    _body.add(
      ColorEffect(
        GamePalette.bone,
        EffectController(duration: 0.06, alternate: true),
        opacityTo: 0.7,
      ),
    );
  }

  /// A sidestep, so a dodge is visibly different from a miss.
  void dodge() {
    if (_dead) return;
    add(
      MoveByEffect(
        Vector2(0, -18),
        EffectController(duration: 0.12, alternate: true),
      ),
    );
  }

  void die() {
    if (_dead) return;
    _dead = true;
    _healthBar.fraction = 0;

    add(OpacityEffect.fadeOut(EffectController(duration: 0.35), target: _body));
    add(MoveByEffect(Vector2(0, 26), EffectController(duration: 0.35)));
  }
}

class _HealthBar extends PositionComponent {
  _HealthBar({required double width, required Vector2 position})
    : super(size: Vector2(width, 6), position: position);

  double _fraction = 1;

  set fraction(double value) => _fraction = value.clamp(0.0, 1.0);

  @override
  void render(Canvas canvas) {
    final track = Paint()..color = GamePalette.forgeRaised;
    final fill = Paint()
      ..color = _fraction > 0.3
          ? GamePalette.emberBright
          : GamePalette.emberDim;

    canvas
      ..drawRect(size.toRect(), track)
      ..drawRect(Rect.fromLTWH(0, 0, size.x * _fraction, size.y), fill);
  }
}
