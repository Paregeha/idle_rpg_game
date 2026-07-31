import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/hero/inventory_sheet.dart';
import 'package:idle_rpg/features/hero/item_tile.dart';
import 'package:idle_rpg/state/game_controller.dart';

/// The lamp, sitting where the player's thumb already is.
///
/// The most-pressed control in the game gets the bottom centre, with its own
/// currency count on it: a button that has to open a dialog to say you cannot
/// afford it has wasted the tap it just took.
class LampPanel extends ConsumerWidget {
  const LampPanel({required this.config, required this.state, super.key});

  final BalanceConfig config;
  final PlayerState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cost = config.lamp.costAmount;
    final balance = state.resources[config.lamp.costResource] ?? BigNum.zero;
    final affordable = balance >= cost;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
      child: Row(
        children: [
          _SideButton(
            icon: Icons.inventory_2_outlined,
            label: '${state.inventory.length}',
            onTap: () => InventorySheet.show(context),
          ),
          Expanded(
            child: GestureDetector(
              onTap: affordable ? () => _open(context, ref) : null,
              child: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: affordable
                        ? [GamePalette.emberBright, GamePalette.emberDim]
                        : [GamePalette.forgeRaised, GamePalette.forgeSurface],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: affordable
                      ? [
                          BoxShadow(
                            color: GamePalette.emberBright.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 20,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode,
                      size: 20,
                      color: affordable ? GamePalette.bone : GamePalette.ash,
                    ),
                    const SizedBox(width: 8),
                    // Scales down rather than clipping: on a narrow phone the
                    // label still reads, and the count keeps its own room.
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'LIGHT THE LAMP',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: affordable
                                ? GamePalette.bone
                                : GamePalette.ash,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: GamePalette.forgeDark.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        balance.format(),
                        style: counterStyle(context, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _SideButton(
            icon: Icons.auto_fix_high,
            label: 'BEST',
            onTap: () => _equipBest(context, ref),
          ),
        ],
      ),
    );
  }

  void _equipBest(BuildContext context, WidgetRef ref) {
    final changed = ref.read(gameControllerProvider.notifier).equipBest();
    final plural = changed == 1 ? '' : 's';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          changed == 0
              ? 'Already wearing the best you have'
              : 'Equipped $changed item$plural',
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
        duration: const Duration(seconds: 2),
        content: Text(
          result.wasPity
              ? '${shortName(result.item!.configId)} — guaranteed'
              : shortName(result.item!.configId),
          style: TextStyle(color: rarityColour(rank)),
        ),
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 60,
        decoration: BoxDecoration(
          color: GamePalette.forgeSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: GamePalette.forgeRaised),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17, color: GamePalette.ash),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: GamePalette.ash),
            ),
          ],
        ),
      ),
    );
  }
}
