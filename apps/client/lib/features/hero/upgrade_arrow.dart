import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// The green arrow that means "this is better than what you have".
///
/// One shape everywhere it appears — on a bag cell, on a slot with something
/// better waiting for it, on a fresh pull. A player learns the arrow once.
class UpgradeArrow extends StatelessWidget {
  const UpgradeArrow({this.size = 14, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 4,
      height: size + 4,
      decoration: BoxDecoration(
        color: GamePalette.patina,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: GamePalette.patina.withValues(alpha: 0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(Icons.arrow_upward, size: size, color: GamePalette.forgeDark),
    );
  }
}
