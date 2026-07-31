import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/hero/upgrade_arrow.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The hero, with everything they are wearing down one side.
///
/// Home shows the gear as a grid because it has a fight to fit around it. Here
/// there is nothing else to fit, so the slots run down the left and the hero
/// stands beside them — the arrangement a player expects when they go looking
/// for "my character" rather than "my next tap".
class HeroPage extends ConsumerWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final slots = config.slots.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    final stats = heroCombatStats(state, config);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GamePalette.forgeSurface,
        foregroundColor: GamePalette.bone,
        title: Text('HERO', style: Theme.of(context).textTheme.labelSmall),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 96,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(10, 12, 4, 12),
                    children: [
                      for (final slot in slots)
                        _SlotTile(slot: slot, config: config, state: state),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                    child: Column(
                      children: [
                        Expanded(child: _Figure(level: state.heroLevel)),
                        const SizedBox(height: 12),
                        _Stats(stats: stats),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One slot, wide enough to name what is in it.
class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.slot,
    required this.config,
    required this.state,
  });

  final SlotConfig slot;
  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context) {
    final wornId = state.equipped[slot.id];
    final owned = wornId == null ? null : state.inventory[wornId];
    final item = owned == null ? null : config.items[owned.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
    final filled = owned != null;
    final better = hasUpgradeFor(state, slot.id, config);

    return GestureDetector(
      onTap: filled
          ? () => ItemCard.show(context, itemId: owned.id, slot: slot)
          : null,
      child: Container(
        height: 62,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? rarityColour(rank) : GamePalette.forgeRaised,
            width: filled ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.id.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontSize: 8),
                ),
                const SizedBox(height: 3),
                Text(
                  filled ? shortName(owned.configId) : 'empty',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
                    color: filled ? rarityColour(rank) : GamePalette.ash,
                  ),
                ),
                if (filled && owned.level > 0)
                  Text(
                    '+${owned.level}',
                    style: counterStyle(context, fontSize: 9),
                  ),
              ],
            ),
            if (better)
              const Positioned(right: 0, top: 0, child: UpgradeArrow(size: 10)),
          ],
        ),
      ),
    );
  }
}

/// Where the hero's art goes once there is any.
class _Figure extends StatelessWidget {
  const _Figure({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 150,
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [GamePalette.emberBright, GamePalette.emberDim],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: GamePalette.emberBright.withValues(alpha: 0.25),
                  blurRadius: 40,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: GamePalette.forgeDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GamePalette.gold),
              ),
              child: Text(
                'LV $level',
                style: counterStyle(
                  context,
                  fontSize: 12,
                  color: GamePalette.gold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Every combat stat, not only the loud two.
///
/// Dodge and armour decide fights the player never sees the dice of, and a
/// build screen that hides them cannot be used to make a decision.
class _Stats extends StatelessWidget {
  const _Stats({required this.stats});

  final CombatStats stats;

  @override
  Widget build(BuildContext context) {
    String percent(double value) => '${(value * 100).toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Column(
        children: [
          _Line(label: 'ATTACK', value: stats.attack.format()),
          _Line(label: 'HEALTH', value: stats.maxHp.format()),
          _Line(
            label: 'SWINGS / SEC',
            value: stats.attacksPerSecond.toStringAsFixed(2),
          ),
          _Line(label: 'CRIT', value: percent(stats.critChance)),
          _Line(
            label: 'CRIT DAMAGE',
            value: '×${stats.critFactor.toStringAsFixed(2)}',
          ),
          _Line(label: 'DODGE', value: percent(stats.dodgeChance)),
          _Line(label: 'ARMOUR', value: percent(stats.mitigation)),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 9),
            ),
          ),
          Text(value, style: counterStyle(context, fontSize: 13)),
        ],
      ),
    );
  }
}
