import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/item_visuals.dart';
import 'package:idle_rpg/features/hero/upgrade_arrow.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// What the lamp gave, next to what it would replace.
///
/// The decision after a pull is always the same one — is this better than what
/// I have — so the screen answers it before asking anything. Showing the new
/// item alone would make the player close it, open the slot, and compare by
/// memory.
class LampPull extends ConsumerWidget {
  const LampPull({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      // Not dismissible: the bag holds decisions, not gear, and walking away
      // is what left something undecided in the first place.
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => const LampPull(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    // Whatever is still undecided, oldest first. When the last one is dealt
    // with there is nothing left to ask about and the screen closes itself.
    final waiting = pendingItems(state);
    if (waiting.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
    }

    final itemId = waiting.first;
    final drawn = state.inventory[itemId];
    final item = drawn == null ? null : config.items[drawn.configId];
    if (drawn == null || item == null) return const SizedBox.shrink();

    final slot = _slotFor(config, item.slot);
    final wornId = slot == null ? null : state.equipped[slot.id];
    final worn = wornId == null ? null : state.inventory[wornId];

    final before = heroCombatStats(state, config);
    final after = heroCombatStats(
      equipItem(state, itemId, config, intoSlot: slot?.id).state,
      config,
    );
    // The same rule the bag and the slots use, so one arrow means one thing.
    final better = isUpgrade(state, itemId, config);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            waiting.length > 1
                ? 'FROM THE LAMP  ·  ${waiting.length} WAITING'
                : 'FROM THE LAMP',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _Side(
                  label: 'WEARING',
                  owned: worn,
                  config: config,
                  dim: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.arrow_right_alt,
                  color: GamePalette.ash,
                  size: 22,
                ),
              ),
              Expanded(
                child: _Side(
                  label: 'NEW',
                  owned: drawn,
                  config: config,
                  dim: false,
                  better: better,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Verdict(before: before, after: after, better: better),
          const SizedBox(height: 16),
          if (worn != null)
            Text(
              'Wearing this sells ${shortName(worn.configId)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
            ),
          const SizedBox(height: 12),
          _Actions(
            itemId: itemId,
            slotId: slot?.id,
            better: better,
            salvageValue: config.salvage.payoutFor(
              rarity: item.rarity,
              level: drawn.level,
            ),
          ),
        ],
      ),
    );
  }

  SlotConfig? _slotFor(BalanceConfig config, String kind) {
    // The slot it would actually land in: an empty one of the right kind if
    // there is one, so a second ring is compared against the empty finger.
    SlotConfig? fallback;
    for (final slot in config.slots) {
      if (slot.itemKind != kind) continue;
      fallback ??= slot;
    }
    return fallback;
  }
}

/// One item in the comparison, or the hole where one would be.
class _Side extends StatelessWidget {
  const _Side({
    required this.label,
    required this.owned,
    required this.config,
    required this.dim,
    this.better = false,
  });

  final String label;
  final OwnedItem? owned;
  final BalanceConfig config;
  final bool dim;
  final bool better;

  @override
  Widget build(BuildContext context) {
    final item = owned == null ? null : config.items[owned!.configId];
    final rank = item == null ? 0 : config.rarities[item.rarity]?.rank ?? 0;
    final colour = owned == null ? GamePalette.forgeRaised : rarityColour(rank);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelSmall),
            if (better) ...[
              const SizedBox(width: 6),
              const UpgradeArrow(size: 12),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 128,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: GamePalette.forgeSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colour, width: dim ? 1 : 2),
            boxShadow: dim
                ? null
                : [
                    BoxShadow(
                      color: colour.withValues(alpha: 0.3),
                      blurRadius: 24,
                    ),
                  ],
          ),
          child: owned == null
              ? Center(
                  child: Text(
                    'nothing',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      itemKindIcon(item?.slot ?? ''),
                      size: 34,
                      color: colour,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      shortName(owned!.configId),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colour,
                      ),
                    ),
                    if (owned!.level > 0)
                      Text(
                        '+${owned!.level}',
                        style: counterStyle(
                          context,
                          fontSize: 11,
                          color: GamePalette.gold,
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// What swapping would do to the hero, in the numbers the fight reads.
class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.before,
    required this.after,
    required this.better,
  });

  final CombatStats before;
  final CombatStats after;
  final bool better;

  @override
  Widget build(BuildContext context) {
    final parts = <String>[];
    void add(String name, BigNum from, BigNum to) {
      if (to == from) return;
      final delta = to - from;
      parts.add('${delta.isNegative ? '' : '+'}${delta.format()} $name');
    }

    add('ATK', before.attack, after.attack);
    add('HP', before.maxHp, after.maxHp);

    return Text(
      parts.isEmpty ? 'NO CHANGE' : parts.join('   '),
      style: counterStyle(
        context,
        fontSize: 13,
        color: parts.isEmpty
            ? GamePalette.ash
            : (better ? GamePalette.patina : GamePalette.ash),
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({
    required this.itemId,
    required this.slotId,
    required this.better,
    required this.salvageValue,
  });

  final String itemId;
  final String? slotId;
  final bool better;
  final Map<String, BigNum> salvageValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = salvageValue.entries.map((e) => e.value.format()).join(' · ');

    return Row(
      children: [
        Expanded(
          child: _Button(
            label: 'SELL  $price',
            filled: false,
            // No pop: the screen closes itself once nothing is waiting, so
            // a queue of five is five decisions, not five dialogs.
            onPressed: () =>
                ref.read(gameControllerProvider.notifier).salvage(itemId),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _Button(
            // Lit when it is an upgrade, plain when it is not. The player
            // still decides — the game just stops making them work it out.
            label: 'WEAR IT',
            filled: better,
            onPressed: slotId == null
                ? null
                : () => ref
                      .read(gameControllerProvider.notifier)
                      .equipReplacing(itemId, slotId: slotId),
          ),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          gradient: filled
              ? const LinearGradient(
                  colors: [GamePalette.emberBright, GamePalette.emberDim],
                )
              : null,
          color: filled ? null : GamePalette.forgeSurface,
          border: filled ? null : Border.all(color: GamePalette.forgeRaised),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: filled ? GamePalette.bone : GamePalette.gold,
            disabledForegroundColor: GamePalette.ash,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
