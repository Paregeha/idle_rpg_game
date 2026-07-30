import 'package:flutter/material.dart';
import 'package:idle_rpg/app/shell.dart';

/// Equipment and stats. Filled in with the progression screens (`T-025`).
class HeroScreen extends StatelessWidget {
  const HeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoon(
      title: 'Hero',
      blurb: 'Gear, stats and party. What the hero carries into the fight.',
    );
  }
}
