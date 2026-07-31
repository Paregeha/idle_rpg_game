import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// The hero, standing in the middle of their own equipment.
///
/// A placeholder silhouette until sprites arrive. It is drawn as one shape
/// rather than assembled from the equipped items on purpose: the layout has to
/// be reviewable now, and a figure built from twelve missing sprites would be
/// twelve grey rectangles instead of a character.
class HeroFigure extends StatelessWidget {
  const HeroFigure({required this.level, super.key});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GamePalette.emberBright, GamePalette.emberDim],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // The hero is the lit thing on a dark screen — the forge glow
              // reads as heat rather than as a drop shadow.
              BoxShadow(
                color: GamePalette.emberBright.withValues(alpha: 0.25),
                blurRadius: 36,
                spreadRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: GamePalette.forgeRaised,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('LV $level', style: counterStyle(context, fontSize: 13)),
        ),
      ],
    );
  }
}
