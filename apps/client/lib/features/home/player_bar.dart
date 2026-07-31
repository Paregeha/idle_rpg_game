import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/router.dart';

/// Avatar, level, name and power, with the experience bar under them.
///
/// The topmost strip of the home screen. Power is a single number standing in
/// for the whole build — it is what a player compares against a wall they
/// cannot pass, and against other players later.
class PlayerBar extends StatelessWidget {
  const PlayerBar({
    required this.level,
    required this.power,
    required this.progress,
    super.key,
  });

  final int level;
  final BigNum power;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Power is one number standing in for the whole build. Tapping it asks
      // "made of what", and the hero page answers it in full.
      onTap: () => context.push(Routes.hero),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        color: GamePalette.forgeSurface,
        child: Row(
          children: [
            _Avatar(level: level),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Forgehand',
                        style: TextStyle(
                          color: GamePalette.bone,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.local_fire_department,
                        size: 13,
                        color: GamePalette.emberBright,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        power.format(),
                        style: counterStyle(
                          context,
                          fontSize: 13,
                          color: GamePalette.emberBright,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: GamePalette.forgeDark,
                      valueColor: const AlwaysStoppedAnimation(
                        GamePalette.patina,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [GamePalette.emberBright, GamePalette.emberDim],
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: GamePalette.gold, width: 1.5),
          ),
        ),
        Positioned(
          left: -2,
          bottom: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: GamePalette.forgeDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: GamePalette.gold, width: 1),
            ),
            child: Text(
              'Lv $level',
              style: counterStyle(
                context,
                fontSize: 9,
                color: GamePalette.gold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
