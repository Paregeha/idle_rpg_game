import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/features/battle/battle_game.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The fight, played back from a journal the core produced.
///
/// `GameWidget` is embedded inside a Flutter screen rather than the other way
/// round (rule 7): only this panel is a game engine, everything around it stays
/// ordinary Flutter.
class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({this.topInset = 0, super.key});

  /// Height at the top of the panel that something else is drawing over.
  ///
  /// Home floats the currencies and the stage over the scene, so the fight has
  /// to be staged below them — otherwise the hero trades blows behind the
  /// gold count and damage numbers land on the stage name.
  final double topInset;

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  BattleGame? _game;
  int _fightNumber = 0;

  void _startFight() {
    final config = ref.read(balanceConfigProvider).value;
    final state = ref.read(gameControllerProvider);
    if (config == null || state == null || config.monsters.isEmpty) return;

    final encounter = encounterFor(state, config);
    if (encounter == null) return;
    // One function answers "how strong is the hero", so this screen, the hero
    // screen and the server cannot drift apart.
    final heroStats = heroCombatStats(state, config);

    // Seeded from the player's own state, so the same save replays the same
    // fight and the server can recompute it later (`T-032`).
    final result = resolveBattle(
      hero: heroStats,
      monsters: encounter.monsters,
      rng: SeededRandom(state.rngSeed ^ (state.lastTickAtMs + _fightNumber)),
      // Which skills fire is a function of the save, like everything else the
      // fight reads — the scene never decides what the hero knows.
      skills: activeSkills(state, config),
      maxDuration: const Duration(seconds: 30),
    );

    setState(() {
      _fightNumber++;
      _game = BattleGame(
        result: result,
        heroMaxHp: heroStats.maxHp,
        monsterMaxHp: encounter.monsters.first.maxHp,
        monsterCount: encounter.monsters.length,
        topInset: widget.topInset,
        onFinished: () => _onFightFinished(won: result.heroWon),
      );
    });
  }

  void _onFightFinished({required bool won}) {
    ref.read(gameControllerProvider.notifier).resolveFight(won: won);

    // Let the death animation land before the next fight starts.
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _startFight();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    if (state == null) return const SizedBox.shrink();

    if (_game == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startFight());
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Expanded(
          child: GameWidget(key: ValueKey(_game), game: _game!),
        ),
      ],
    );
  }
}

/// Names the current fight and counts the ones already won.
///
/// Deliberately not the last fight's outcome: the next fight starts as soon as
/// the previous one ends, so a "VICTORY" label would describe a fight that is
/// no longer on screen.
