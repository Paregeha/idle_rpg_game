import 'package:flutter/material.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';

/// The strip of currencies that stays on screen wherever the player goes.
///
/// Wired to live state in `T-021`; for now it renders whatever it is handed so
/// the layout and the number formatting can be reviewed on their own.
class ResourceBar extends StatelessWidget {
  const ResourceBar({this.resources = const {}, super.key});

  final Map<String, BigNum> resources;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          _Currency(
            label: 'GOLD',
            value: resources['gold'] ?? BigNum.zero,
            colour: GamePalette.gold,
          ),
          const SizedBox(width: 28),
          _Currency(
            label: 'GEMS',
            value: resources['gems'] ?? BigNum.zero,
            colour: GamePalette.patina,
          ),
        ],
      ),
    );
  }
}

class _Currency extends StatelessWidget {
  const _Currency({
    required this.label,
    required this.value,
    required this.colour,
  });

  final String label;
  final BigNum value;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(value.format(), style: counterStyle(context, color: colour)),
      ],
    );
  }
}
