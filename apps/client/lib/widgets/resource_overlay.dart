import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';

/// Currencies floating over the location.
///
/// Not a bar with its own background: the scene is the backdrop, and giving the
/// numbers a solid strip would cut the screen in two and steal height from the
/// thing the player is watching.
class ResourceOverlay extends ConsumerWidget {
  const ResourceOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shown = ref.watch(balanceConfigProvider).value?.displayedResources;
    if (shown == null || shown.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      child: Row(
        children: [
          for (final key in shown)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Pill(resourceKey: key),
            ),
        ],
      ),
    );
  }
}

/// One currency, on a dark lozenge so it stays readable over any backdrop.
class _Pill extends ConsumerWidget {
  const _Pill({required this.resourceKey});

  final String resourceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(resourceProvider(resourceKey));
    final colour = currencyColour(resourceKey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: GamePalette.forgeDark.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(value.format(), style: counterStyle(context, fontSize: 13)),
        ],
      ),
    );
  }
}
