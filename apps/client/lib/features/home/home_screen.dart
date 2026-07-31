import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/battle/battle_screen.dart';
import 'package:idle_rpg/features/home/equipment_grid.dart';
import 'package:idle_rpg/features/home/lamp_panel.dart';
import 'package:idle_rpg/features/home/player_bar.dart';
import 'package:idle_rpg/widgets/resource_overlay.dart';
import 'package:idle_rpg/features/home/skill_bar.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// Everything at once: who you are, where you are, the fight, your skills and
/// your gear.
///
/// The fight lives here rather than behind a tab. In an idle game the fight is
/// the thing that is always happening, and a player who has to navigate to see
/// it stops believing it is running at all.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Room kept at the top of the scene for the currencies and the stage strip.
  ///
  /// The fight is staged below it. Without that the hero traded blows behind
  /// the gold count and damage numbers landed on the stage name.
  static const double overlayHeight = 76;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(balanceConfigProvider).value;
    final state = ref.watch(gameControllerProvider);
    if (config == null || state == null) return const SizedBox.shrink();

    return Column(
      children: [
        PlayerBar(
          level: state.heroLevel,
          power: heroPower(state, config),
          progress: levelProgress(state, config),
        ),
        // The scene is the backdrop; currencies and the stage float over it
        // rather than sitting in strips of their own. Strips would cut the
        // screen into bands and steal height from the thing being watched.
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(
                child: BattleScreen(topInset: overlayHeight),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ResourceOverlay(),
                    const SizedBox(height: 6),
                    _StageStrip(state: state, config: config),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SkillBar(),
        EquipmentGrid(config: config, state: state),
        const SizedBox(height: 6),
        _QuestStrip(state: state, config: config),
        LampPanel(config: config, state: state),
      ],
    );
  }
}

/// Where the player is, and how far through the stage.
class _StageStrip extends StatelessWidget {
  const _StageStrip({required this.state, required this.config});

  final PlayerState state;
  final BalanceConfig config;

  @override
  Widget build(BuildContext context) {
    final waves = config.progression.wavesPerStage;
    final onBoss = state.wave >= waves;
    final monster = (encounterFor(state, config)?.monsterId ?? '')
        .toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: GamePalette.forgeDark.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(stageLabel(state), style: counterStyle(context, fontSize: 13)),
          const SizedBox(width: 8),
          Text(
            monster,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onBoss ? GamePalette.emberBright : GamePalette.ash,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: onBoss ? 1 : state.wave / waves,
                minHeight: 5,
                backgroundColor: GamePalette.forgeSurface,
                valueColor: AlwaysStoppedAnimation(
                  onBoss ? GamePalette.emberBright : GamePalette.gold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            onBoss ? 'BOSS' : '${state.wave}/$waves',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: onBoss ? GamePalette.emberBright : GamePalette.ash,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single running objective.
///
/// Placeholder until daily quests land (`T-060`). It reads from real state, so
/// the number moves — a fake progress bar is worse than none.
class _QuestStrip extends StatelessWidget {
  const _QuestStrip({required this.state, required this.config});

  final PlayerState state;
  final BalanceConfig config;

  @override
  Widget build(BuildContext context) {
    final cleared =
        config.progression.stageIndex(
              chapter: state.chapter,
              stage: state.stage,
            ) *
            (config.progression.wavesPerStage + 1) +
        state.wave;
    const target = 30;

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: GamePalette.forgeSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag_outlined, size: 14, color: GamePalette.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Clear $target waves',
              style: const TextStyle(fontSize: 12, color: GamePalette.ash),
            ),
          ),
          Text(
            '${cleared.clamp(0, target)}/$target',
            style: counterStyle(context, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
