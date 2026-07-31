import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// A damage number that floats up and fades.
///
/// Removes itself when the animation ends. Twenty of these can be alive at
/// once during a burst, so anything left behind would accumulate for the whole
/// session — the acceptance criterion for `T-023` is 60 fps under exactly that
/// load.
class DamageNumber extends TextComponent {
  DamageNumber({
    required String text,
    required bool crit,
    required Vector2 position,
    this.fromSkill = false,
  }) : super(
         text: text,
         position: position,
         anchor: Anchor.center,
         textRenderer: TextPaint(
           style: TextStyle(
             fontSize: fromSkill ? 24 : (crit ? 26 : 18),
             fontWeight: fromSkill || crit ? FontWeight.w800 : FontWeight.w600,
             // A cast reads as the hero's own colour rather than the crit
             // colour: a player who cannot tell a skill from a lucky crit has
             // no reason to believe the skill does anything.
             color: fromSkill
                 ? GamePalette.patina
                 : (crit ? GamePalette.emberBright : GamePalette.bone),
             fontFeatures: const [FontFeature.tabularFigures()],
           ),
         ),
       );

  /// Whether this number came from a skill rather than a swing.
  final bool fromSkill;

  static const _lifetime = 0.8;

  @override
  Future<void> onLoad() async {
    add(
      MoveByEffect(
        Vector2(0, -52),
        EffectController(duration: _lifetime, curve: Curves.easeOut),
      ),
    );
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: _lifetime, curve: Curves.easeIn),
      ),
    );
    // Removal is its own effect rather than a callback on the fade: the fade
    // depends on the component supporting opacity, and a number that outlives
    // its animation would accumulate for the whole session.
    add(RemoveEffect(delay: _lifetime));
  }
}
