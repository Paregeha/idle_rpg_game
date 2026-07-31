import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/inventory_sheet.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';
import 'package:idle_rpg/features/home/special_slots.dart';

/// The equipment panel: gear on the left, the special slots on the right.
///
/// A grid rather than columns beside the hero, because twelve slots plus a
/// battle scene do not both fit down the sides of a phone. Splitting ordinary
/// gear from wings, skin and runes also matches where they come from — one side
/// drops, the other is crafted or bought.
class EquipmentGrid extends ConsumerWidget {
  const EquipmentGrid({required this.config, required this.state, super.key});

  final BalanceConfig config;
  final PlayerState state;

  static const _specialKinds = {'wings', 'skin', 'rune', 'mount'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = config.slots.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final gear = slots
        .where((slot) => !_specialKinds.contains(slot.itemKind))
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _Grid(columns: 3, slots: gear, config: config, state: state),
          ),
          Container(
            width: 1,
            height: 157,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: GamePalette.forgeRaised,
          ),
          Expanded(
            flex: 2,
            child: SpecialSlots(config: config, state: state),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.slots,
    required this.config,
    required this.state,
  });

  final int columns;
  final List<SlotConfig> slots;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 1.45,
      children: [
        for (final slot in slots)
          _Cell(slot: slot, config: config, state: state),
      ],
    );
  }
}

/// One square. Shows the item's rarity as its border and its level as a badge,
/// which is all a player needs to compare two squares at a glance.
class _Cell extends ConsumerWidget {
  const _Cell({required this.slot, required this.config, required this.state});

  final SlotConfig slot;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wornId = state.equipped[slot.id];
    final owned = wornId == null ? null : state.inventory[wornId];
    final item = owned == null ? null : config.items[owned.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
    final filled = owned != null;

    return GestureDetector(
      // A full slot opens the item; an empty one opens the bag to fill it.
      // Tapping worn gear and getting a list of everything else is an answer
      // to a question the player did not ask.
      onTap: () => owned == null
          ? InventorySheet.show(context, slot: slot)
          : ItemCard.show(context, itemId: owned.id, slot: slot),
      child: Container(
        decoration: BoxDecoration(
          color: filled
              ? rarityColour(rank).withValues(alpha: 0.16)
              : GamePalette.forgeDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: filled ? rarityColour(rank) : GamePalette.forgeRaised,
            width: filled ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  filled ? shortName(owned.configId) : slot.id,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    height: 1.15,
                    color: filled ? GamePalette.bone : GamePalette.ash,
                    fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (filled)
              Positioned(
                left: 3,
                bottom: 2,
                child: Text(
                  'Lv.${owned.level}',
                  style: counterStyle(
                    context,
                    fontSize: 9,
                    color: GamePalette.gold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
