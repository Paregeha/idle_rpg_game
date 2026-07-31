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
  // Bought with money, so it gets a colour nothing else uses — a premium
  // currency that looks like the free one is a refund request waiting to
  // happen.
  'premiumGems' => const Color(0xFFB07BD8),
  'lamps' => GamePalette.emberBright,
  // A material, not a currency: cold iron rather than one of the bright
  // colours the things you spend at a counter get.
  'scrap' => const Color(0xFF8FA3AD),
  _ => GamePalette.bone,
};

/// Short label for a currency, for places too narrow for the raw key.
String currencyLabel(String key) => switch (key) {
  'premiumGems' => 'CRYSTALS',
  _ => key.toUpperCase(),
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
          currencyLabel(resourceKey),
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
