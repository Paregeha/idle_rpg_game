import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';

/// One equipment slot, sized to sit in a column beside the hero.
///
/// Square and compact, because twelve of them have to fit around a figure on a
/// phone. The label is inside rather than beneath so the column stays dense.
class SlotButton extends ConsumerWidget {
  const SlotButton({
    required this.slot,
    required this.config,
    required this.state,
    required this.onTap,
    super.key,
  });

  final SlotConfig slot;
  final BalanceConfig config;
  final PlayerState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wornId = state.equipped[slot.id];
    final owned = wornId == null ? null : state.inventory[wornId];
    final item = owned == null ? null : config.items[owned.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
    final filled = owned != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? rarityColour(rank) : GamePalette.forgeRaised,
            width: filled ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              slot.id.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 9, letterSpacing: 1),
            ),
            const SizedBox(height: 2),
            Text(
              filled ? shortName(owned.configId) : 'empty',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: filled ? rarityColour(rank) : GamePalette.ash,
                fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (filled && owned.level > 0)
              Text(
                '+${owned.level}',
                style: counterStyle(context, fontSize: 10),
              ),
          ],
        ),
      ),
    );
  }
}
