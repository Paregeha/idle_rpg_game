import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The hero: what is worn, what is owned, and the lamp that supplies both.
///
/// Equipment sits directly above the inventory rather than behind a separate
/// screen, so the effect of a change is visible in the same glance as the
/// change itself.
class HeroScreen extends ConsumerStatefulWidget {
  const HeroScreen({super.key});

  @override
  ConsumerState<HeroScreen> createState() => _HeroScreenState();
}

class _HeroScreenState extends ConsumerState<HeroScreen> {
  String? _slotFilter;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final stats = heroCombatStats(state, config);
    final inventory = state.inventory.values.where((owned) {
      if (_slotFilter == null) return true;
      return config.items[owned.configId]?.slot == _slotFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _StatLine(label: 'Attack', value: stats.attack.format()),
        _StatLine(label: 'Health', value: stats.maxHp.format()),
        _StatLine(
          label: 'Critical',
          value: '${(stats.critChance * 100).round()}%',
        ),
        const SizedBox(height: 18),
        _SlotRow(config: config, state: state),
        const SizedBox(height: 16),
        _LampButton(config: config),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('INVENTORY', style: Theme.of(context).textTheme.labelSmall),
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
        const SizedBox(height: 10),
        _SlotFilter(
          slots: config.slots,
          selected: _slotFilter,
          onChanged: (slot) => setState(() => _slotFilter = slot),
        ),
        const SizedBox(height: 12),
        if (inventory.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              state.inventory.isEmpty
                  ? 'Nothing yet. Light the lamp, or kill something.'
                  : 'Nothing in this slot.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
            ),
          )
        else
          for (final owned in inventory)
            ItemTile(
              owned: owned,
              config: config,
              state: state,
              isEquipped: state.equipped.containsValue(owned.id),
            ),
      ],
    );
  }

  void _equipBest() {
    final changed = ref.read(gameControllerProvider.notifier).equipBest();
    final plural = changed == 1 ? '' : 's';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          changed == 0
              ? 'Already wearing the best you have'
              : 'Equipped $changed item$plural',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: GamePalette.ash),
          ),
          Text(value, style: counterStyle(context, fontSize: 17)),
        ],
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  const _SlotRow({required this.config, required this.state});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final slot in config.slots)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Slot(slot: slot, config: config, state: state),
            ),
          ),
      ],
    );
  }
}

/// One worn item. Tapping takes it off.
class _Slot extends ConsumerWidget {
  const _Slot({required this.slot, required this.config, required this.state});

  final String slot;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wornId = state.equipped[slot];
    final owned = wornId == null ? null : state.inventory[wornId];
    final item = owned == null ? null : config.items[owned.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;

    return GestureDetector(
      onTap: wornId == null
          ? null
          : () => ref.read(gameControllerProvider.notifier).unequip(slot),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          border: Border.all(
            color: owned == null ? GamePalette.forgeRaised : rarityColour(rank),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              slot.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              owned == null ? '—' : shortName(owned.configId),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: owned == null ? GamePalette.ash : rarityColour(rank),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotFilter extends StatelessWidget {
  const _SlotFilter({
    required this.slots,
    required this.selected,
    required this.onChanged,
  });

  final List<String> slots;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final slot in <String?>[null, ...slots])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(slot == null ? 'ALL' : slot.toUpperCase()),
                selected: selected == slot,
                onSelected: (_) => onChanged(slot),
                backgroundColor: GamePalette.forgeSurface,
                selectedColor: GamePalette.emberDim,
                labelStyle: Theme.of(context).textTheme.labelSmall,
                side: BorderSide.none,
              ),
            ),
        ],
      ),
    );
  }
}

class _LampButton extends ConsumerWidget {
  const _LampButton({required this.config});

  final BalanceConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final cost = config.lamp.costAmount;
    final balance = state?.resources[config.lamp.costResource] ?? BigNum.zero;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: balance >= cost ? () => _open(context, ref) : null,
        style: FilledButton.styleFrom(
          backgroundColor: GamePalette.emberDim,
          disabledBackgroundColor: GamePalette.forgeRaised,
          foregroundColor: GamePalette.bone,
          disabledForegroundColor: GamePalette.ash,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'LIGHT THE LAMP  ·  ${cost.format()} ${config.lamp.costResource}',
          style: const TextStyle(letterSpacing: 0.8),
        ),
      ),
    );
  }

  void _open(BuildContext context, WidgetRef ref) {
    final result = ref.read(gameControllerProvider.notifier).openTheLamp();
    if (result == null || !result.opened) return;

    final item = config.items[result.item!.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: GamePalette.forgeRaised,
        duration: const Duration(seconds: 3),
        content: Text(
          // The pity guarantee is named when it fires. One the player never
          // sees is one they do not believe exists.
          result.wasPity
              ? '${shortName(result.item!.configId)} — guaranteed'
              : shortName(result.item!.configId),
          style: TextStyle(color: rarityColour(rank)),
        ),
      ),
    );
  }
}
