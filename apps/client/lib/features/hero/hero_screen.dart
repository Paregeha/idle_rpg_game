import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// What the hero brings to a fight, and where it comes from.
///
/// Every line names the thing that produces it, so the screen answers "how do I
/// get stronger" rather than only "how strong am I".
class HeroScreen extends ConsumerWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    final units = state.generators.values.fold(
      0,
      (sum, generator) => sum + generator.owned,
    );
    final stats = config.hero.statsFor(unitsOwned: units);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        Text('THE HERO', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 14),
        _Stat(label: 'Attack', value: stats.attack.format()),
        _Stat(label: 'Health', value: stats.maxHp.format()),
        _Stat(
          label: 'Swings',
          value: '${stats.attacksPerSecond.toStringAsFixed(1)}/s',
        ),
        _Stat(label: 'Critical', value: '${(stats.critChance * 100).round()}%'),
        _Stat(label: 'Dodge', value: '${(stats.dodgeChance * 100).round()}%'),
        const Divider(height: 32),
        _Stat(label: 'Backed by', value: '$units units'),
        _Stat(label: 'Prestige', value: state.prestige.currency.format()),
        const SizedBox(height: 10),
        Text(
          'Attack and health scale with every unit you own, so building the '
          'forge is how the hero gets stronger.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: GamePalette.ash),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
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
