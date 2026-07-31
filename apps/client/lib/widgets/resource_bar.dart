import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// Colour per currency. Falls back to bone for anything balance adds later,
/// so a new currency shows up readable rather than invisible.
Color currencyColour(String key) => switch (key) {
  'gold' => GamePalette.gold,
  'gems' => GamePalette.patina,
  'lamps' => GamePalette.emberBright,
  _ => GamePalette.bone,
};

/// The strip of currencies that stays on screen wherever the player goes.
///
/// Which currencies appear comes from the balance config. A currency the
/// player spends but never sees reads as a bug — the lamp charged for one the
/// bar did not show until this was driven by data.
class ResourceBar extends ConsumerWidget {
  const ResourceBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = ref.watch(balanceConfigProvider).value?.displayedResources;
    if (shown == null || shown.isEmpty) {
      return const SizedBox(height: 56);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          for (final key in shown)
            Padding(
              padding: const EdgeInsets.only(right: 26),
              child: _Currency(resourceKey: key),
            ),
        ],
      ),
    );
  }
}

/// Watches one resource, so a tick that changes gold does not rebuild the rest.
class _Currency extends ConsumerWidget {
  const _Currency({required this.resourceKey});

  final String resourceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(resourceProvider(resourceKey));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resourceKey.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 2),
        Text(
          value.format(),
          style: counterStyle(context, color: currencyColour(resourceKey)),
        ),
      ],
    );
  }
}
