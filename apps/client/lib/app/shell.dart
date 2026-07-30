import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/router.dart';
import 'package:idle_rpg/app/theme.dart';
import 'package:idle_rpg/widgets/resource_bar.dart';

/// The frame every screen sits inside: resources on top, tabs at the bottom.
///
/// The resource bar is part of the shell rather than of each screen because in
/// an idle game the numbers going up *are* the game. They must stay visible and
/// keep counting while the player is reading anything else.
class GameShell extends StatelessWidget {
  const GameShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int get _selectedIndex {
    final index = Routes.tabs.indexOf(location);
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ResourceBar(),
            const Divider(),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => context.go(Routes.tabs[index]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.gps_fixed_outlined),
            selectedIcon: Icon(Icons.gps_fixed),
            label: 'BATTLE',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'HERO',
          ),
          NavigationDestination(
            icon: Icon(Icons.hardware_outlined),
            selectedIcon: Icon(Icons.hardware),
            label: 'FORGE',
          ),
        ],
      ),
    );
  }
}

/// A screen that has nothing in it yet.
///
/// Says what will live here rather than showing a spinner or a blank panel: an
/// empty screen is an invitation, and a placeholder that explains itself is
/// easier to review than one that does not.
class ComingSoon extends StatelessWidget {
  const ComingSoon({required this.title, required this.blurb, super.key});

  final String title;
  final String blurb;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 12),
            Text(
              blurb,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: GamePalette.ash),
            ),
          ],
        ),
      ),
    );
  }
}
