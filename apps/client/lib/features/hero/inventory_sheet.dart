import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The bag, opened over the hero rather than replacing them.
///
/// Tapping a slot opens it already filtered to that slot: the player asked
/// "what can go here", and answering with the whole bag makes them do the
/// filtering themselves.
class InventorySheet extends ConsumerStatefulWidget {
  const InventorySheet({this.slot, super.key});

  final SlotConfig? slot;

  static Future<void> show(BuildContext context, {SlotConfig? slot}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: GamePalette.forgeSurface,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: InventorySheet(slot: slot),
      ),
    );
  }

  @override
  ConsumerState<InventorySheet> createState() => _InventorySheetState();
}

class _InventorySheetState extends ConsumerState<InventorySheet> {
  late String? _kind = widget.slot?.itemKind;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final items = state.inventory.values.where((owned) {
      if (_kind == null) return true;
      return config.items[owned.configId]?.slot == _kind;
    }).toList();

    final kinds = config.slots.map((slot) => slot.itemKind).toSet().toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.slot == null ? 'BAG' : widget.slot!.id.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              TextButton(
                onPressed: state.inventory.isEmpty ? null : _equipBest,
                style: TextButton.styleFrom(
                  foregroundColor: GamePalette.patina,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('EQUIP BEST'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final kind in <String?>[null, ...kinds])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(kind == null ? 'ALL' : kind.toUpperCase()),
                      selected: _kind == kind,
                      onSelected: (_) => setState(() => _kind = kind),
                      backgroundColor: GamePalette.forgeDark,
                      selectedColor: GamePalette.emberDim,
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      side: BorderSide.none,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      state.inventory.isEmpty
                          ? 'Nothing yet. Light the lamp, or kill something.'
                          : 'Nothing that fits here.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
                    ),
                  )
                : ListView(
                    children: [
                      for (final owned in items)
                        ItemTile(
                          owned: owned,
                          config: config,
                          state: state,
                          isEquipped: state.equipped.containsValue(owned.id),
                          slot: widget.slot,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // No message: the list is right there, and the tiles that changed say
  // EQUIPPED the moment they do.
  void _equipBest() {
    ref.read(gameControllerProvider.notifier).equipBest();
  }
}
