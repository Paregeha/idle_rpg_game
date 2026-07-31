import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The hero's numbers, held up over the game.
///
/// The player bar shows one power figure, which is enough to know whether a
/// wall moved but not enough to know why. This is where the parts are: attack,
/// health, and the probabilities that decide a fight the player never sees the
/// dice of.
///
/// A card rather than a tab. The numbers are read occasionally and compared
/// against a fight that is running — a screen the player has to leave to reach
/// would hide the fight they are reading them about.
class HeroCard extends ConsumerWidget {
  const HeroCard({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (context) => const HeroCard(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    // One function answers "how strong is the hero", so this card cannot
    // disagree with the fight.
    final stats = heroCombatStats(state, config);
    final worn = state.equipped.length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: GamePalette.forgeSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: GamePalette.gold.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Head(
                level: state.heroLevel,
                progress: levelProgress(state, config),
                worn: worn,
                slots: config.slots.length,
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    _Row(label: 'ATTACK', value: stats.attack.format()),
                    _Row(label: 'HEALTH', value: stats.maxHp.format()),
                    _Row(
                      label: 'SWINGS / SEC',
                      value: stats.attacksPerSecond.toStringAsFixed(2),
                    ),
                    _Row(label: 'CRIT', value: _percent(stats.critChance)),
                    _Row(
                      label: 'CRIT DAMAGE',
                      value: '×${stats.critFactor.toStringAsFixed(2)}',
                    ),
                    _Row(label: 'DODGE', value: _percent(stats.dodgeChance)),
                    _Row(label: 'ARMOUR', value: _percent(stats.mitigation)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: GamePalette.ash,
                      ),
                      child: const Text('CLOSE'),
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

  String _percent(double value) => '${(value * 100).toStringAsFixed(1)}%';
}

class _Head extends StatelessWidget {
  const _Head({
    required this.level,
    required this.progress,
    required this.worn,
    required this.slots,
  });

  final int level;
  final double progress;
  final int worn;
  final int slots;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GamePalette.emberBright, GamePalette.emberDim],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: GamePalette.gold, width: 1.5),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Forgehand',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: GamePalette.bone,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'LEVEL $level  ·  $worn/$slots WORN',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: GamePalette.forgeRaised,
                    valueColor: const AlwaysStoppedAnimation(
                      GamePalette.patina,
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

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.labelSmall),
          ),
          Text(value, style: counterStyle(context, fontSize: 14)),
        ],
      ),
    );
  }
}
