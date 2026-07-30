import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';

/// The strip of currencies that stays on screen wherever the player goes.
class ResourceBar extends StatelessWidget {
  const ResourceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          _Currency(
            resourceKey: 'gold',
            label: 'GOLD',
            colour: GamePalette.gold,
          ),
          SizedBox(width: 28),
          _Currency(
            resourceKey: 'gems',
            label: 'GEMS',
            colour: GamePalette.patina,
          ),
        ],
      ),
    );
  }
}

/// Watches one resource, so a tick that changes gold does not rebuild gems.
class _Currency extends ConsumerWidget {
  const _Currency({
    required this.resourceKey,
    required this.label,
    required this.colour,
  });

  final String resourceKey;
  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(resourceProvider(resourceKey));

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
