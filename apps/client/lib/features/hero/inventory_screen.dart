import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// What the bag is divided into at the top level.
///
/// The player's first question is "what kind of thing am I looking for", and
/// only then "which one". Sorting one flat pile of everything answers the
/// second question while making the first one harder.
///
/// Adding a tab is one entry here plus the branch that fills it — runes, chests
/// and shards are all coming, and they must not land as more rows in a list of
/// swords.
enum BagTab {
  gear('GEAR', Icons.shield_outlined),
  materials('MATERIALS', Icons.science_outlined);

  const BagTab(this.label, this.icon);

  final String label;
  final IconData icon;
}

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
  BagTab _tab = BagTab.gear;
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
          _Tabs(
            selected: _tab,
            counts: {
              BagTab.gear: state.inventory.length,
              // Kinds the player actually holds, not kinds that exist: a tab
              // reading "1" with nothing in it is worse than one reading "0".
              BagTab.materials: config.materialResources
                  .where(
                    (key) =>
                        (state.resources[key] ?? BigNum.zero) > BigNum.zero,
                  )
                  .length,
            },
            onSelected: (tab) => setState(() => _tab = tab),
          ),
          Expanded(
            child: switch (_tab) {
              BagTab.gear => _GearTab(
                items: items,
                kinds: kinds,
                kind: _kind,
                onKind: (kind) => setState(() => _kind = kind),
                config: config,
                state: state,
                slot: slot,
              ),
              BagTab.materials => _MaterialsTab(config: config),
            },
          ),
          if (_tab == BagTab.gear)
            _BottomBar(
              enabled: state.inventory.isNotEmpty,
              junkLabel: _junkLabel(config, state.autoSalvageRank),
              onEquipBest: () =>
                  ref.read(gameControllerProvider.notifier).equipBest(),
              onSalvageJunk: state.autoSalvageRank < 0
                  ? null
                  : () => ref
                        .read(gameControllerProvider.notifier)
                        .salvageJunkUpTo(state.autoSalvageRank),
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

  /// Names the rank the salvage button will take, so it cannot be pressed
  /// blind. There is no undo for gear that has been broken down.
  String _junkLabel(BalanceConfig config, int rank) {
    if (rank < 0) return 'SALVAGE';

    final named = config.rarities.entries
        .where((entry) => entry.value.rank == rank)
        .map((entry) => entry.key.toUpperCase());

    return named.isEmpty ? 'SALVAGE' : 'SALVAGE ${named.first} ↓';
  }

  int _rank(OwnedItem owned, BalanceConfig config) {
    final item = config.items[owned.configId];
    return item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
  }
}

/// The top-level split, as one row of tabs.
///
/// Full width and always visible: what the bag holds should be readable before
/// the player scrolls, and a tab that only appears once it has contents teaches
/// them the game grew a feature behind their back.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final BagTab selected;
  final Map<BagTab, int> counts;
  final ValueChanged<BagTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GamePalette.forgeSurface,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          for (final tab in BagTab.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _Tab(
                  tab: tab,
                  count: counts[tab] ?? 0,
                  active: tab == selected,
                  onTap: () => onSelected(tab),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.tab,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final BagTab tab;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colour = active ? GamePalette.bone : GamePalette.ash;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: active ? GamePalette.emberDim : GamePalette.forgeDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? GamePalette.emberBright : GamePalette.forgeRaised,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, size: 15, color: colour),
            const SizedBox(width: 7),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tab.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: colour,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: counterStyle(context, fontSize: 12, color: colour),
            ),
          ],
        ),
      ),
    );
  }
}

/// Everything that goes on the hero, filtered by slot underneath.
class _GearTab extends StatelessWidget {
  const _GearTab({
    required this.items,
    required this.kinds,
    required this.kind,
    required this.onKind,
    required this.config,
    required this.state,
    required this.slot,
  });

  final List<OwnedItem> items;
  final List<String> kinds;
  final String? kind;
  final ValueChanged<String?> onKind;
  final BalanceConfig config;
  final PlayerState state;
  final SlotConfig? slot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Filters(kinds: kinds, selected: kind, onSelected: onKind),
        _AutoSalvageRule(config: config, chosen: state.autoSalvageRank),
        Expanded(
          child: items.isEmpty
              ? _Empty(bagIsEmpty: state.inventory.isEmpty)
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      ],
    );
  }
}

/// A tab that exists before the thing it holds does.
class _NotYet extends StatelessWidget {
  const _NotYet({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 34, color: GamePalette.forgeRaised),
            const SizedBox(height: 14),
            Text(
              message,
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

/// The standing rule: what gets broken down the moment it drops.
///
/// Off by default, and off is a real option rather than a hidden one. A game
/// that destroys gear nobody asked it to destroy is a game the player stops
/// trusting, so the rule names the rarity in full — COMMON means common and
/// everything below it.
class _AutoSalvageRule extends ConsumerWidget {
  const _AutoSalvageRule({required this.config, required this.chosen});

  final BalanceConfig config;
  final int chosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranks = config.rarities.entries.toList()
      ..sort((a, b) => a.value.rank.compareTo(b.value.rank));

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Row(
        children: [
          Text(
            'AUTO SALVAGE',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 24,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _RulePill(
                    label: 'OFF',
                    active: chosen < 0,
                    colour: GamePalette.ash,
                    onTap: () => ref
                        .read(gameControllerProvider.notifier)
                        .setAutoSalvageRank(-1),
                  ),
                  for (final entry in ranks)
                    _RulePill(
                      label: entry.key.toUpperCase(),
                      active: chosen == entry.value.rank,
                      colour: rarityColour(entry.value.rank),
                      onTap: () => ref
                          .read(gameControllerProvider.notifier)
                          .setAutoSalvageRank(entry.value.rank),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RulePill extends StatelessWidget {
  const _RulePill({
    required this.label,
    required this.active,
    required this.colour,
    required this.onTap,
  });

  final String label;
  final bool active;
  final Color colour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? colour.withValues(alpha: 0.22)
                : GamePalette.forgeDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? colour : GamePalette.forgeRaised,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              color: active ? GamePalette.bone : GamePalette.ash,
            ),
          ),
        ),
      ),
    );
  }
}

/// What breaking gear down has banked, and what it is for.
class _MaterialsTab extends ConsumerWidget {
  const _MaterialsTab({required this.config});

  final BalanceConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (config.materialResources.isEmpty) {
      return const _NotYet(
        icon: Icons.science_outlined,
        message: 'Crafting materials land here.\nNothing produces them yet.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      children: [
        for (final key in config.materialResources)
          _MaterialRow(resourceKey: key),
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 14, 4, 0),
          child: Text(
            'Breaking gear down pays these. Crafting will spend them.',
            style: TextStyle(fontSize: 11, color: GamePalette.ash),
          ),
        ),
      ],
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

/// Wear the best of it, or break down the rest.
class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onEquipBest,
    required this.onSalvageJunk,
    required this.junkLabel,
    required this.enabled,
  });

  final VoidCallback onEquipBest;

  /// Null when no standing rule is set: with no rank chosen there is nothing
  /// for it to take, and a button that silently does nothing is worse than a
  /// disabled one.
  final VoidCallback? onSalvageJunk;

  final String junkLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
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
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'EQUIP BEST',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: enabled ? onSalvageJunk : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: GamePalette.gold,
                    disabledForegroundColor: GamePalette.ash,
                    side: const BorderSide(color: GamePalette.forgeRaised),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      junkLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
