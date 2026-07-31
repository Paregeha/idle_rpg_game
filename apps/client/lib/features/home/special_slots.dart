import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/inventory_sheet.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';

/// The special slots, each sized to what it holds.
///
/// Wings and rune are ordinary squares, the skin is a tall portrait and the
/// mount is a wide landscape. The shape is the label: a player finds the mount
/// because it is the only wide box, not because they read the word.
class SpecialSlots extends StatelessWidget {
  const SpecialSlots({required this.config, required this.state, super.key});

  final BalanceConfig config;
  final PlayerState state;

  SlotConfig? _slot(String kind) {
    for (final slot in config.slots) {
      if (slot.itemKind == kind) return slot;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final wings = _slot('wings');
    final rune = _slot('rune');
    final skin = _slot('skin');
    final mount = _slot('mount');

    return Column(
      children: [
        SizedBox(
          height: 106,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    if (wings != null)
                      Expanded(
                        child: SpecialCell(
                          slot: wings,
                          config: config,
                          state: state,
                        ),
                      ),
                    const SizedBox(height: 5),
                    if (rune != null)
                      Expanded(
                        child: SpecialCell(
                          slot: rune,
                          config: config,
                          state: state,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              // The skin is two cells tall: it changes how the hero looks, so
              // it gets the space a portrait needs once art exists.
              Expanded(
                child: skin == null
                    ? const SizedBox.shrink()
                    : SpecialCell(slot: skin, config: config, state: state),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // The mount is two cells wide, for the same reason: a creature is drawn
        // lying along the horizontal, not standing in a square.
        SizedBox(
          height: 46,
          child: mount == null
              ? const SizedBox.shrink()
              : SpecialCell(slot: mount, config: config, state: state),
        ),
      ],
    );
  }
}

/// A slot cell that fills whatever box it is given.
class SpecialCell extends ConsumerWidget {
  const SpecialCell({
    required this.slot,
    required this.config,
    required this.state,
    super.key,
  });

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
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
