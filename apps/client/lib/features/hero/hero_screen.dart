import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/hero_figure.dart';
import 'package:idle_rpg/features/hero/inventory_sheet.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/slot_button.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The hero in full: every slot, every number, and the bag.
///
/// Home carries the slots the player touches between fights; this screen is
/// where they come to read the whole build at once. The lamp is deliberately
/// not here — it lives on home, where the loop is, and a second copy would
/// leave the player wondering whether the two do the same thing.
class HeroScreen extends ConsumerWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final stats = heroCombatStats(state, config);
    final slots = config.slots.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final half = (slots.length / 2).ceil();

    return Column(
      children: [
        _StatStrip(stats: stats, level: state.heroLevel),
        _ExperienceBar(progress: levelProgress(state, config)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SlotColumn(
                  slots: slots.take(half).toList(),
                  config: config,
                  state: state,
                ),
                Expanded(child: HeroFigure(level: state.heroLevel)),
                _SlotColumn(
                  slots: slots.skip(half).toList(),
                  config: config,
                  state: state,
                ),
              ],
            ),
          ),
        ),
        _ActionRow(state: state),
      ],
    );
  }
}

/// A column of slots down one side of the hero.
class _SlotColumn extends StatelessWidget {
  const _SlotColumn({
    required this.slots,
    required this.config,
    required this.state,
  });

  final List<SlotConfig> slots;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final slot in slots)
              SlotButton(
                slot: slot,
                config: config,
                state: state,
                // Same rule as the home grid: a full slot opens the item, an
                // empty one opens the bag to fill it.
                onTap: () {
                  final wornId = state.equipped[slot.id];
                  if (wornId == null) {
                    InventorySheet.show(context, slot: slot);
                  } else {
                    ItemCard.show(context, itemId: wornId, slot: slot);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// The numbers that matter, across one line.
class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.stats, required this.level});

  final CombatStats stats;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Stat(label: 'LEVEL', value: '$level'),
          _Stat(label: 'ATTACK', value: stats.attack.format()),
          _Stat(label: 'HEALTH', value: stats.maxHp.format()),
          _Stat(label: 'CRIT', value: '${(stats.critChance * 100).round()}%'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 2),
        Text(value, style: counterStyle(context, fontSize: 16)),
      ],
    );
  }
}

/// How far to the next level. A bar says it without the player reading a number.
class _ExperienceBar extends StatelessWidget {
  const _ExperienceBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 5,
          backgroundColor: GamePalette.forgeRaised,
          valueColor: const AlwaysStoppedAnimation(GamePalette.patina),
        ),
      ),
    );
  }
}

/// The one thing a player does from this screen.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.state});

  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => InventorySheet.show(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: GamePalette.bone,
            side: const BorderSide(color: GamePalette.forgeRaised),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: Text('BAG  ${state.inventory.length}'),
        ),
      ),
    );
  }
}
