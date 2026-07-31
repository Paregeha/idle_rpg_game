import 'package:flutter/material.dart';
import 'package:idle_rpg/app/theme.dart';

/// The skill row: auto-cast toggle and the slots.
///
/// Slots are locked placeholders until the skill system lands. Shown now rather
/// than hidden, because a locked slot tells the player the game has more in it
/// — a row that appears from nowhere later does not.
class SkillBar extends StatelessWidget {
  const SkillBar({this.unlocked = 0, super.key});

  /// How many slots are usable. The rest render as locked.
  final int unlocked;

  static const _slots = 6;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(8, 6, 8, 4),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 38,
            decoration: BoxDecoration(
              color: GamePalette.emberDim,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text(
              'AUTO',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w700,
                color: GamePalette.bone,
              ),
            ),
          ),
          for (var i = 0; i < _slots; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _SkillSlot(locked: i >= unlocked),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkillSlot extends StatelessWidget {
  const _SkillSlot({required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: GamePalette.forgeDark,
        shape: BoxShape.circle,
        border: Border.all(
          color: locked ? GamePalette.forgeRaised : GamePalette.patina,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        locked ? Icons.lock_outline : Icons.auto_awesome,
        size: 15,
        color: locked ? GamePalette.ash : GamePalette.patina,
      ),
    );
  }
}
