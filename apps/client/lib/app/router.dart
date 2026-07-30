import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/shell.dart';
import 'package:idle_rpg/features/battle/battle_screen.dart';
import 'package:idle_rpg/features/hero/hero_screen.dart';
import 'package:idle_rpg/features/upgrades/upgrades_screen.dart';

/// The three places a player can be.
///
/// Paths are stable strings because a push notification (`T-061`) will need to
/// deep-link straight into one of them.
abstract final class Routes {
  static const battle = '/battle';
  static const hero = '/hero';
  static const upgrades = '/upgrades';

  static const tabs = [battle, hero, upgrades];
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.battle,
    routes: [
      // A shell, not three separate pages: the resource bar and the tab bar
      // stay mounted across navigation, so the numbers never restart or flash
      // while the player switches tabs.
      ShellRoute(
        builder: (context, state, child) =>
            GameShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: Routes.battle,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BattleScreen()),
          ),
          GoRoute(
            path: Routes.hero,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HeroScreen()),
          ),
          GoRoute(
            path: Routes.upgrades,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UpgradesScreen()),
          ),
        ],
      ),
    ],
  );
}
