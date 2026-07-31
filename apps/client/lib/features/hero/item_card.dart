import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/router.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';

/// One item, held up over a darkened screen.
///
/// Upgrading used to happen on a row in a list, which reads as a settings
/// screen: the thing being improved was a line of text. Here the item is the
/// whole subject — framed, named by its rarity, with what the next level buys
/// spelled out beside what it gives now. The fight stays visible behind it, so
/// the player never leaves the game to spend gold on it.
class ItemCard extends ConsumerWidget {
  const ItemCard({required this.itemId, this.slot, super.key});

  /// The owned item, not its config: level and spares belong to this copy.
  final String itemId;

  /// The slot it was opened from, if any. Swapping goes back to that slot.
  final SlotConfig? slot;

  static Future<void> show(
    BuildContext context, {
    required String itemId,
    SlotConfig? slot,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (context) => ItemCard(itemId: itemId, slot: slot),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final owned = state.inventory[itemId];
    final item = owned == null ? null : config.items[owned.configId];
    final rarity = item == null ? null : config.rarities[item.rarity];
    // The item can vanish under the card: a spare copy eaten by an upgrade
    // started from somewhere else. Closing beats showing a card about nothing.
    if (owned == null || item == null || rarity == null) {
      return const SizedBox.shrink();
    }

    final colour = rarityColour(rarity.rank);
    final maxed = owned.level >= item.maxLevel;
    final now = item.statsAt(level: owned.level, rarity: rarity);
    final next = maxed
        ? now
        : item.statsAt(level: owned.level + 1, rarity: rarity);

    // The upgrade itself decides whether it would go through. Asking it beats
    // a second copy of the rules that can disagree with the button.
    final attempt = upgradeItem(state, itemId, config);
    final upgrade = config.itemUpgrade;
    final spares = spareCopiesOf(state, itemId).length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: GamePalette.forgeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colour.withValues(alpha: 0.55), width: 2),
            boxShadow: [
              BoxShadow(
                color: colour.withValues(alpha: 0.18),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                owned: owned,
                item: item,
                rarity: rarity,
                rarityCount: config.rarities.length,
              ),
              const Divider(height: 1),
              _Stats(now: now, next: next, showNext: !maxed),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    if (!maxed) ...[
                      _CostRow(
                        spares: spares,
                        needed: upgrade.duplicatesPerLevel,
                        cost: upgrade.costFor(owned.level),
                        costResource: upgrade.costResource,
                      ),
                      const SizedBox(height: 12),
                    ],
                    _UpgradeButton(
                      level: owned.level,
                      maxed: maxed,
                      refusal: attempt.refusal,
                      onPressed: () => ref
                          .read(gameControllerProvider.notifier)
                          .upgrade(itemId),
                    ),
                    const SizedBox(height: 10),
                    _Footer(
                      slot: slot,
                      isWorn: state.equipped.containsValue(itemId),
                      onEquip: () => ref
                          .read(gameControllerProvider.notifier)
                          .equip(itemId, intoSlot: slot?.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The frame, the name and how rare it is.
class _Header extends StatelessWidget {
  const _Header({
    required this.owned,
    required this.item,
    required this.rarity,
    required this.rarityCount,
  });

  final OwnedItem owned;
  final ItemConfig item;
  final RarityConfig rarity;
  final int rarityCount;

  @override
  Widget build(BuildContext context) {
    final colour = rarityColour(rarity.rank);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Frame(colour: colour, kind: item.slot, level: owned.level),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortName(owned.configId),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colour,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.rarity.toUpperCase()} · ${item.slot.toUpperCase()}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 8),
                _Stars(filled: rarity.rank + 1, total: rarityCount),
                const SizedBox(height: 8),
                _LevelTrack(level: owned.level, maxLevel: item.maxLevel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Where the art goes once there is any.
///
/// Until then, a rarity-tinted frame with the icon for its kind. A grey square
/// with a word in it would say the game is unfinished; this says the slot has
/// something in it.
class _Frame extends StatelessWidget {
  const _Frame({required this.colour, required this.kind, required this.level});

  final Color colour;
  final String kind;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colour, width: 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colour.withValues(alpha: 0.28), GamePalette.forgeDark],
        ),
      ),
      child: Stack(
        children: [
          Center(child: Icon(itemKindIcon(kind), size: 34, color: colour)),
          if (level > 0)
            Positioned(
              right: 4,
              bottom: 3,
              child: Text(
                '+$level',
                style: counterStyle(context, fontSize: 14, color: colour),
              ),
            ),
        ],
      ),
    );
  }
}

/// Rarity as pips. One tier, one star — the same scale the config declares.
class _Stars extends StatelessWidget {
  const _Stars({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              i < filled ? Icons.star : Icons.star_border,
              size: 13,
              color: i < filled ? GamePalette.gold : GamePalette.forgeRaised,
            ),
          ),
      ],
    );
  }
}

/// How far this copy is from the ceiling the config sets.
class _LevelTrack extends StatelessWidget {
  const _LevelTrack({required this.level, required this.maxLevel});

  final int level;
  final int maxLevel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: maxLevel == 0 ? 0 : level / maxLevel,
              minHeight: 4,
              backgroundColor: GamePalette.forgeRaised,
              valueColor: const AlwaysStoppedAnimation(GamePalette.gold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$level/$maxLevel',
          style: counterStyle(context, fontSize: 11, color: GamePalette.ash),
        ),
      ],
    );
  }
}

/// What it gives now, and what the next level would make of it.
class _Stats extends StatelessWidget {
  const _Stats({required this.now, required this.next, required this.showNext});

  final ItemStats now;
  final ItemStats next;
  final bool showNext;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    void big(String label, BigNum a, BigNum b) {
      if (a.isZero && b.isZero) return;
      rows.add(_StatRow(label: label, now: a.format(), next: b.format()));
    }

    void percent(String label, double a, double b) {
      if (a == 0 && b == 0) return;
      rows.add(
        _StatRow(
          label: label,
          now: '${(a * 100).toStringAsFixed(0)}%',
          next: '${(b * 100).toStringAsFixed(0)}%',
        ),
      );
    }

    void times(String label, double a, double b) {
      if (a == 1 && b == 1) return;
      rows.add(
        _StatRow(
          label: label,
          now: '×${a.toStringAsFixed(2)}',
          next: '×${b.toStringAsFixed(2)}',
        ),
      );
    }

    big('ATTACK', now.flatAttack, next.flatAttack);
    big('HEALTH', now.flatHp, next.flatHp);
    times('ATTACK ×', now.attackMultiplier, next.attackMultiplier);
    times('HEALTH ×', now.hpMultiplier, next.hpMultiplier);
    percent('CRIT', now.critChance, next.critChance);
    percent('CRIT DMG', now.critFactor, next.critFactor);
    percent('DODGE', now.dodgeChance, next.dodgeChance);
    percent('ARMOUR', now.mitigation, next.mitigation);
    percent('SPEED', now.attacksPerSecond, next.attacksPerSecond);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          for (final row in rows) row,
          if (rows.isEmpty)
            Text(
              'No stats yet',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
            ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.now, required this.next});

  final String label;
  final String now;
  final String next;

  @override
  Widget build(BuildContext context) {
    final grows = now != next;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
          ),
          Text(now, style: counterStyle(context, fontSize: 14)),
          if (grows) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_right_alt,
                size: 15,
                color: GamePalette.ash,
              ),
            ),
            Text(
              next,
              style: counterStyle(
                context,
                fontSize: 14,
                color: GamePalette.patina,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// What the next level costs, before it is pressed rather than after.
class _CostRow extends ConsumerWidget {
  const _CostRow({
    required this.spares,
    required this.needed,
    required this.cost,
    required this.costResource,
  });

  final int spares;
  final int needed;
  final BigNum cost;
  final String costResource;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(resourceProvider(costResource));
    final canPay = balance >= cost;

    return Column(
      children: [
        if (needed > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text('SPARES', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 10),
                for (var i = 0; i < needed; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Icon(
                      i < spares ? Icons.circle : Icons.circle_outlined,
                      size: 11,
                      color: i < spares
                          ? GamePalette.patina
                          : GamePalette.forgeRaised,
                    ),
                  ),
                const Spacer(),
                Text(
                  '$spares/$needed',
                  style: counterStyle(
                    context,
                    fontSize: 13,
                    color: spares >= needed
                        ? GamePalette.bone
                        : GamePalette.ash,
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Text('COST', style: Theme.of(context).textTheme.labelSmall),
            const Spacer(),
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: currencyColour(costResource),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              cost.format(),
              style: counterStyle(
                context,
                fontSize: 13,
                // Red would read as an error; ash reads as "not yet".
                color: canPay ? GamePalette.bone : GamePalette.ash,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The one big button, which says why when it cannot be pressed.
class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({
    required this.level,
    required this.maxed,
    required this.refusal,
    required this.onPressed,
  });

  final int level;
  final bool maxed;
  final UpgradeRefusal? refusal;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = switch (refusal) {
      null => 'UPGRADE  →  +${level + 1}',
      UpgradeRefusal.alreadyMaxLevel => 'FULLY UPGRADED',
      UpgradeRefusal.cannotAfford => 'NOT ENOUGH GOLD',
      UpgradeRefusal.notEnoughDuplicates => 'NEEDS A SPARE COPY',
      UpgradeRefusal.unknownItem => 'UNAVAILABLE',
    };
    final ready = refusal == null && !maxed;

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: ready
              ? const LinearGradient(
                  colors: [GamePalette.emberBright, GamePalette.emberDim],
                )
              : null,
          color: ready ? null : GamePalette.forgeRaised,
          boxShadow: ready
              ? [
                  BoxShadow(
                    color: GamePalette.emberBright.withValues(alpha: 0.28),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: TextButton(
          onPressed: ready ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: GamePalette.bone,
            disabledForegroundColor: GamePalette.ash,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

/// Wear it, or go and pick something else for the same slot.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.slot,
    required this.isWorn,
    required this.onEquip,
  });

  final SlotConfig? slot;
  final bool isWorn;
  final VoidCallback onEquip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isWorn && slot != null)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(Routes.inventoryFor(slot!.id));
            },
            style: TextButton.styleFrom(foregroundColor: GamePalette.patina),
            child: const Text('SWAP'),
          )
        else if (!isWorn)
          TextButton(
            onPressed: () {
              onEquip();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: GamePalette.patina),
            child: const Text('EQUIP'),
          )
        else
          const SizedBox.shrink(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: GamePalette.ash),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}
