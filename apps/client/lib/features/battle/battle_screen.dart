import 'package:flutter/material.dart';
import 'package:idle_rpg/app/shell.dart';

/// Where the hero fights. The Flame scene arrives in `T-023`.
class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoon(
      title: 'Battle',
      blurb:
          'The hero fights here. Damage numbers, the monster and its health '
          'bar land with the battle scene.',
    );
  }
}
