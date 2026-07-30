import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The forge: everything the player can buy.
///
/// Ordinary Flutter, not Flame (rule 7) — a scrolling list of buttons is what a
/// widget tree is good at and what a game engine is not.
class UpgradesScreen extends ConsumerWidget {
  const UpgradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);

    if (config == null || state == null) return const SizedBox.shrink();

    final entries = config.generators.entries.toList()
      ..sort((a, b) => a.value.costBase.compareTo(b.value.costBase));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) => _GeneratorRow(
        generatorId: entries[index].key,
        generator: entries[index].value,
        state: state,
        config: config,
      ),
    );
  }
}

class _GeneratorRow extends ConsumerWidget {
  const _GeneratorRow({
    required this.generatorId,
    required this.generator,
    required this.state,
    required this.config,
  });

  final String generatorId;
  final GeneratorConfig generator;
  final PlayerState state;
  final BalanceConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owned = state.generators[generatorId]?.owned ?? 0;
    final affordable = maxAffordable(state, generatorId, config);
    final wait = timeToAfford(
      state: state,
      config: config,
      generatorId: generatorId,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                generatorId.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                owned == 0 ? '—' : '$owned OWNED',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      generator.costFor(owned).format(),
                      style: counterStyle(
                        context,
                        fontSize: 18,
                        color: GamePalette.gold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _subtitle(owned, wait),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: affordable > 0
                            ? GamePalette.patina
                            : GamePalette.ash,
                      ),
                    ),
                  ],
                ),
              ),
              _BuyButtons(generatorId: generatorId, affordable: affordable),
            ],
          ),
        ],
      ),
    );
  }

  String _subtitle(int owned, Duration? wait) {
    if (wait == Duration.zero) return 'affordable now';
    if (wait == null) return owned == 0 ? 'no income yet' : 'out of reach';
    return 'next in ${formatWait(wait)}';
  }
}

class _BuyButtons extends ConsumerWidget {
  const _BuyButtons({required this.generatorId, required this.affordable});

  final String generatorId;
  final int affordable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);

    Widget button(String label, int count) {
      final enabled = count > 0 && affordable >= count;

      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: FilledButton(
          onPressed: enabled
              ? () => controller.buyGenerator(generatorId, count: count)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: GamePalette.emberDim,
            disabledBackgroundColor: GamePalette.forgeRaised,
            foregroundColor: GamePalette.bone,
            disabledForegroundColor: GamePalette.ash,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(label, style: const TextStyle(letterSpacing: 0.6)),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button('1', 1),
        button('10', 10),
        // MAX greys out at zero rather than disappearing: a button that comes
        // and goes is harder to aim at than one that stays put.
        button('MAX', affordable),
      ],
    );
  }
}
