import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_card.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/hero/upgrade_arrow.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The hero in the middle, with what they are wearing around them.
///
/// Home shows the gear as a grid because it has a fight to fit around it. Here
/// there is nothing else to fit, so the character gets the centre and the
/// slots frame them — the arrangement a player expects when they go looking
/// for "my character" rather than "my next tap".
///
/// Wings join the gear columns — they are worn like the rest of it. The skin
/// and the mount sit above the stats on their own: neither is equipment, they
/// change how the hero looks and what they ride. The rune is deliberately not
/// here at all — it is not gear and gets its own place.
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

    // Split by the order the config gives, so adding a slot lands somewhere
    // sensible without a code change.
    const apart = {'skin', 'mount'};
    const elsewhere = {'rune'};
    final gear = slots
        .where((s) => !apart.contains(s.itemKind))
        .where((s) => !elsewhere.contains(s.itemKind))
        .toList();
    final half = (gear.length / 2).ceil();
    final outfit = slots.where((s) => apart.contains(s.itemKind)).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Column(
                    slots: gear.take(half).toList(),
                    config: config,
                    state: state,
                  ),
                  Expanded(child: _Figure(level: state.heroLevel)),
                  _Column(
                    slots: gear.skip(half).toList(),
                    config: config,
                    state: state,
                  ),
                ],
              ),
            ),
            if (outfit.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
                child: Row(
                  children: [
                    for (final slot in outfit)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: _SlotTile(
                            slot: slot,
                            config: config,
                            state: state,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            // Full width: the numbers are read across, and a narrow column
            // squeezed between the gear made every one of them wrap.
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: _Stats(stats: stats),
            ),
          ],
        ),
      ),
    );
  }
}

/// One side of the hero.
class _Column extends StatelessWidget {
  const _Column({
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
      width: 92,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        children: [
          for (final slot in slots)
            _SlotTile(slot: slot, config: config, state: state),
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

    final lines = <(String, String)>[
      ('ATTACK', stats.attack.format()),
      ('HEALTH', stats.maxHp.format()),
      ('SWINGS / SEC', stats.attacksPerSecond.toStringAsFixed(2)),
      ('CRIT', percent(stats.critChance)),
      ('CRIT DAMAGE', '\u00d7${stats.critFactor.toStringAsFixed(2)}'),
      ('DODGE', percent(stats.dodgeChance)),
      ('ARMOUR', percent(stats.mitigation)),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GamePalette.forgeRaised),
      ),
      child: Column(
        children: [
          for (final line in lines) _Line(label: line.$1, value: line.$2),
        ],
      ),
    );
  }
}

/// One stat, with a dotted run between the name and the number.
///
/// Across a full-width row the eye loses which value belongs to which label;
/// the dots carry it across. This is why printed tables of contents have had
/// them for four hundred years.
class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 10),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CustomPaint(size: Size.fromHeight(2), painter: _Leader()),
            ),
          ),
          Text(value, style: counterStyle(context, fontSize: 14)),
        ],
      ),
    );
  }
}

/// Evenly spaced dots along the middle of whatever room is left.
class _Leader extends CustomPainter {
  const _Leader();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GamePalette.forgeRaised
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const step = 6.0;
    // Right to left, so the run always ends flush against the number rather
    // than leaving a ragged gap that reads as a mistake.
    for (var x = size.width; x >= 0; x -= step) {
      canvas.drawPoints(PointMode.points, [Offset(x, size.height / 2)], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Leader oldDelegate) => false;
}
