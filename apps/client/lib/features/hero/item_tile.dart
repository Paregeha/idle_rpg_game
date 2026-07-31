import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/state/game_controller.dart';

/// Colour for a rarity rank. Rank rather than name, so a config that adds a
/// tier does not need a new case here.
Color rarityColour(int rank) => switch (rank) {
  >= 3 => GamePalette.emberBright,
  2 => const Color(0xFFB07BD8),
  1 => GamePalette.patina,
  _ => GamePalette.ash,
};

/// "ember_brand" -> "Ember brand".
String shortName(String configId) {
  final words = configId.replaceAll('_', ' ');
  return words.substring(0, 1).toUpperCase() + words.substring(1);
}

/// One item in the inventory, with what equipping it would do.
class ItemTile extends ConsumerWidget {
  const ItemTile({
    required this.owned,
    required this.config,
    required this.state,
    required this.isEquipped,
    this.slot,
    super.key,
  });

  final OwnedItem owned;
  final BalanceConfig config;
  final PlayerState state;
  final bool isEquipped;

  /// Which slot the bag was opened from, if any.
  ///
  /// Without it, tapping a ring from the `ring2` panel could land it on the
  /// other finger, which is not what the player pointed at.
  final SlotConfig? slot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = config.items[owned.configId];
    final rarity = item == null ? null : config.rarities[item.rarity];
    if (item == null || rarity == null) return const SizedBox.shrink();

    final preview = _preview();

    return GestureDetector(
      // The row is a way in, not the place upgrades happen: a list line with a
      // "+" on it reads as a settings screen, not as gear.
      onTap: () => ItemCard.show(context, itemId: owned.id, slot: slot),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(6),
          border: Border(
            left: BorderSide(color: rarityColour(rarity.rank), width: 3),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        shortName(owned.configId),
                        style: TextStyle(
                          color: rarityColour(rarity.rank),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (owned.level > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '+${owned.level}',
                          style: counterStyle(context, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isEquipped ? 'worn · ${item.slot}' : preview.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isEquipped
                          ? GamePalette.ash
                          : (preview.better
                                ? GamePalette.patina
                                : GamePalette.ash),
                    ),
                  ),
                ],
              ),
            ),
            if (!isEquipped)
              _SmallButton(
                label: 'EQUIP',
                onPressed: () => ref
                    .read(gameControllerProvider.notifier)
                    .equip(owned.id, intoSlot: slot?.id),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: GamePalette.ash),
          ],
        ),
      ),
    );
  }

  /// What wearing this would change.
  ///
  /// Computed by actually running the equip and comparing, rather than by a
  /// second formula: a preview that disagrees with the result is worse than no
  /// preview at all.
  ///
  /// Reports every stat that moves, not just attack. Showing armour as
  /// "no change" because it happens not to add damage tells the player a
  /// useful item is useless.
  ({String label, bool better}) _preview() {
    final before = heroCombatStats(state, config);
    final after = heroCombatStats(
      equipItem(state, owned.id, config, intoSlot: slot?.id).state,
      config,
    );

    final parts = <String>[];
    var better = false;

    void add(String name, BigNum from, BigNum to) {
      if (to == from) return;
      final delta = to - from;
      final sign = delta.isNegative ? '' : '+';
      parts.add('$sign${delta.format()} $name');
      if (!delta.isNegative) better = true;
    }

    void addPercent(String name, double from, double to) {
      final delta = ((to - from) * 100).round();
      if (delta == 0) return;
      parts.add('${delta > 0 ? '+' : ''}$delta% $name');
      if (delta > 0) better = true;
    }

    add('attack', before.attack, after.attack);
    add('health', before.maxHp, after.maxHp);
    addPercent('crit', before.critChance, after.critChance);
    addPercent('dodge', before.dodgeChance, after.dodgeChance);

    return (
      label: parts.isEmpty ? 'no change' : parts.join(' · '),
      better: better,
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: GamePalette.emberDim,
        disabledBackgroundColor: GamePalette.forgeRaised,
        foregroundColor: GamePalette.bone,
        disabledForegroundColor: GamePalette.ash,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label, style: const TextStyle(letterSpacing: 0.6)),
    );
  }
}
