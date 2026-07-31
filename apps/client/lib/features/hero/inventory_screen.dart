import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The bag, as a wall of gear.
///
/// A screen rather than a sheet: the bag is where a player browses, and a
/// half-height panel they can accidentally drag away is a bad place to browse.
/// Cells rather than rows for the same reason — twelve squares are taken in at
/// a glance, twelve lines of text have to be read.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({this.slotId, super.key});

  /// Opened from a slot, if any: the grid starts filtered to what fits there.
  final String? slotId;

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String? _kind;
  bool _startedFiltered = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final slot = _slotFor(config);
    // The filter is seeded once from the slot, then belongs to the player: a
    // filter that resets itself on every rebuild cannot be cleared.
    if (!_startedFiltered) {
      _startedFiltered = true;
      _kind = slot?.itemKind;
    }

    final items = state.inventory.values.where((owned) {
      if (_kind == null) return true;
      return config.items[owned.configId]?.slot == _kind;
    }).toList();

    // Best first: the reason to open the bag is to find something better than
    // what is on, and that answer should be in the top row.
    items.sort((a, b) {
      final rankA = _rank(a, config);
      final rankB = _rank(b, config);
      if (rankA != rankB) return rankB.compareTo(rankA);
      return b.level.compareTo(a.level);
    });

    final kinds = config.slots.map((s) => s.itemKind).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GamePalette.forgeSurface,
        foregroundColor: GamePalette.bone,
        title: Text(
          slot == null ? 'BAG' : slot.id.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${state.inventory.length}',
                style: counterStyle(context, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _Filters(
            kinds: kinds,
            selected: _kind,
            onSelected: (kind) => setState(() => _kind = kind),
          ),
          Expanded(
            child: items.isEmpty
                ? _Empty(bagIsEmpty: state.inventory.isEmpty)
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.82,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, index) => _Cell(
                      owned: items[index],
                      config: config,
                      isWorn: state.equipped.containsValue(items[index].id),
                      slot: slot,
                    ),
                  ),
          ),
          _BottomBar(
            onEquipBest: () =>
                ref.read(gameControllerProvider.notifier).equipBest(),
            enabled: state.inventory.isNotEmpty,
          ),
        ],
      ),
    );
  }

  SlotConfig? _slotFor(BalanceConfig config) {
    if (widget.slotId == null) return null;
    for (final slot in config.slots) {
      if (slot.id == widget.slotId) return slot;
    }
    return null;
  }

  int _rank(OwnedItem owned, BalanceConfig config) {
    final item = config.items[owned.configId];
    return item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
  }
}

/// One cell: rarity frame, kind icon, level, and whether it is on the hero.
class _Cell extends StatelessWidget {
  const _Cell({
    required this.owned,
    required this.config,
    required this.isWorn,
    required this.slot,
  });

  final OwnedItem owned;
  final BalanceConfig config;
  final bool isWorn;
  final SlotConfig? slot;

  @override
  Widget build(BuildContext context) {
    final item = config.items[owned.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
    final colour = rarityColour(rank);

    return GestureDetector(
      onTap: () => ItemCard.show(context, itemId: owned.id, slot: slot),
      child: Column(
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
                  colors: [
                    colour.withValues(alpha: 0.22),
                    GamePalette.forgeDark,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      itemKindIcon(item?.slot ?? ''),
                      size: 26,
                      color: colour,
                    ),
                  ),
                  if (owned.level > 0)
                    Positioned(
                      right: 3,
                      bottom: 2,
                      child: Text(
                        '+${owned.level}',
                        style: counterStyle(
                          context,
                          fontSize: 11,
                          color: colour,
                        ),
                      ),
                    ),
                  if (isWorn)
                    Positioned(
                      left: 3,
                      top: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: GamePalette.patina,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ON',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: GamePalette.forgeDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            shortName(owned.configId),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: colour),
          ),
        ],
      ),
    );
  }
}

/// The kind filter, as one scrolling row.
class _Filters extends StatelessWidget {
  const _Filters({
    required this.kinds,
    required this.selected,
    required this.onSelected,
  });

  final List<String> kinds;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          for (final kind in <String?>[null, ...kinds])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(kind == null ? 'ALL' : kind.toUpperCase()),
                selected: selected == kind,
                onSelected: (_) => onSelected(kind),
                backgroundColor: GamePalette.forgeSurface,
                selectedColor: GamePalette.emberDim,
                labelStyle: Theme.of(context).textTheme.labelSmall,
                side: BorderSide.none,
                showCheckmark: false,
              ),
            ),
        ],
      ),
    );
  }
}

/// An empty screen is an invitation to act, not a blank panel.
class _Empty extends StatelessWidget {
  const _Empty({required this.bagIsEmpty});

  final bool bagIsEmpty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              bagIsEmpty ? Icons.light_mode : Icons.filter_alt_off,
              size: 34,
              color: GamePalette.forgeRaised,
            ),
            const SizedBox(height: 14),
            Text(
              bagIsEmpty
                  ? 'Nothing yet. Light the lamp, or kill something.'
                  : 'Nothing that fits here.',
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onEquipBest, required this.enabled});

  final VoidCallback onEquipBest;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton(
            onPressed: enabled ? onEquipBest : null,
            style: FilledButton.styleFrom(
              backgroundColor: GamePalette.emberDim,
              disabledBackgroundColor: GamePalette.forgeRaised,
              foregroundColor: GamePalette.bone,
              disabledForegroundColor: GamePalette.ash,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'EQUIP BEST',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
