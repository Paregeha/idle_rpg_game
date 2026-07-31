import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              children: [
                for (final key in config.materialResources)
                  _MaterialRow(resourceKey: key),
                const Padding(
                  padding: EdgeInsets.fromLTRB(4, 14, 4, 0),
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

class _MaterialRow extends ConsumerWidget {
  const _MaterialRow({required this.resourceKey});

  final String resourceKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final held = ref.watch(resourceProvider(resourceKey));

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: GamePalette.patina),
              gradient: const LinearGradient(
                colors: [Color(0x334FB3A0), GamePalette.forgeDark],
              ),
            ),
            child: const Icon(
              Icons.hexagon_outlined,
              size: 17,
              color: GamePalette.patina,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              resourceKey.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Text(held.format(), style: counterStyle(context, fontSize: 15)),
        ],
      ),
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
