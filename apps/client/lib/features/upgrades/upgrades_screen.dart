import 'package:flutter/material.dart';
import 'package:idle_rpg/app/shell.dart';

/// The forge: generators and their upgrades. Wired up in `T-025`.
class UpgradesScreen extends StatelessWidget {
  const UpgradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoon(
      title: 'Forge',
      blurb: 'Buy and upgrade what earns while you are away.',
    );
  }
}
