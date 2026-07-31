import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/home/lamp_pull.dart';
import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/router.dart';
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
            onTap: () => context.push(Routes.inventory),
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
            onTap: () => _equipBest(ref),
          ),
        ],
      ),
    );
  }

  // Equipping the best of what is already owned reports nothing: the result
  // is on screen already, and a bar sliding up from the bottom would land on
  // the two controls the player is holding.
  void _equipBest(WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).equipBest();
  }

  /// A pull does get a screen. The decision after one is always "is this
  /// better than what I have", and answering it by memory is what makes a
  /// player stop opening the bag at all.
  void _open(BuildContext context, WidgetRef ref) {
    final result = ref.read(gameControllerProvider.notifier).openTheLamp();
    final drawn = result?.item;
    if (drawn == null) return;

    LampPull.show(context, itemId: drawn.id);
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
