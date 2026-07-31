import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The bag. It holds materials, because that is all there is to hold.
///
/// Gear does not live here: an item is either on the hero or sold as soon as
/// it is drawn, so a store of things to browse would only ever be empty. The
/// name stays the bag even so — it is where the player goes to see what they
/// have, and renaming the place would only make them look for the old one.
class MaterialsScreen extends ConsumerWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    if (config == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GamePalette.forgeSurface,
        foregroundColor: GamePalette.bone,
        title: Text('BAG', style: Theme.of(context).textTheme.labelSmall),
      ),
      body: config.materialResources.isEmpty
          ? const _Empty()
          : Column(
              children: [
                Expanded(
                  // Cells, like gear had: a wall of squares is taken in at a
                  // glance, and the count belongs on the thing it counts
                  // rather than at the far end of a row.
                  child: GridView.count(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.82,
                    children: [
                      for (final key in config.materialResources)
                        _MaterialCell(resourceKey: key),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Breaking gear down pays these. Crafting spends them.',
                    style: TextStyle(fontSize: 11, color: GamePalette.ash),
                  ),
                ),
              ],
            ),
    );
  }
}

/// One material, in a cell with its count on it.
class _MaterialCell extends ConsumerWidget {
  const _MaterialCell({required this.resourceKey});

  final String resourceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final held = ref.watch(resourceProvider(resourceKey));
    final has = held > BigNum.zero;
    // Dimmed at zero rather than hidden: a material the player has none of is
    // still one they can go and get.
    final colour = has ? GamePalette.patina : GamePalette.forgeRaised;

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: colour, width: 1.5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colour.withValues(alpha: 0.22), GamePalette.forgeDark],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.hexagon_outlined, size: 26, color: colour),
                ),
                Positioned(
                  right: 4,
                  bottom: 3,
                  child: Text(
                    held.format(),
                    style: counterStyle(
                      context,
                      fontSize: 12,
                      color: has ? GamePalette.bone : GamePalette.ash,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          resourceKey.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9,
            letterSpacing: 0.6,
            color: has ? GamePalette.bone : GamePalette.ash,
          ),
        ),
      ],
    );
  }
}

/// An empty screen is an invitation, not a blank panel.
class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.science_outlined,
              size: 34,
              color: GamePalette.forgeRaised,
            ),
            const SizedBox(height: 14),
            Text(
              'Nothing produces materials yet.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
            ),
          ],
        ),
      ),
    );
  }
}
