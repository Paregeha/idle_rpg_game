import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/features/battle/battle_game.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

/// The fight, played back from a journal the core produced.
///
/// `GameWidget` is embedded inside a Flutter screen rather than the other way
/// round (rule 7): only this panel is a game engine, everything around it stays
/// ordinary Flutter.
class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({super.key});

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  BattleGame? _game;
  String _monsterId = '';
  int _fightNumber = 0;
  int _victories = 0;

  void _startFight() {
    final config = ref.read(balanceConfigProvider).value;
    final state = ref.read(gameControllerProvider);
    if (config == null || state == null || config.monsters.isEmpty) return;

    final monsterId = config.monsters.keys.first;
    final monster = config.monsters[monsterId]!;
    // One function answers "how strong is the hero", so this screen, the hero
    // screen and the server cannot drift apart.
    final heroStats = heroCombatStats(state, config);
    final monsterStats = CombatStats(
      attack: monster.attackFor(0),
      maxHp: monster.hpFor(0),
      attacksPerSecond: monster.attacksPerSecond,
      mitigation: monster.mitigation,
      dodgeChance: monster.dodgeChance,
    );

    // Seeded from the player's own state, so the same save replays the same
    // fight and the server can recompute it later (`T-032`).
    final result = resolveBattle(
      hero: heroStats,
      monster: monsterStats,
      rng: SeededRandom(state.rngSeed ^ (state.lastTickAtMs + _fightNumber)),
      maxDuration: const Duration(seconds: 30),
    );

    setState(() {
      _fightNumber++;
      _monsterId = monsterId;
      if (result.heroWon) _victories++;
      _game = BattleGame(
        result: result,
        heroMaxHp: heroStats.maxHp,
        monsterMaxHp: monsterStats.maxHp,
        onFinished: _onFightFinished,
      );
    });
  }

  void _onFightFinished() {
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
        _FightHeader(monsterId: _monsterId, victories: _victories),
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
class _FightHeader extends StatelessWidget {
  const _FightHeader({required this.monsterId, required this.victories});

  final String monsterId;
  final int victories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monsterId.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'SLAIN $victories',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: GamePalette.emberDim),
          ),
        ],
      ),
    );
  }
}
