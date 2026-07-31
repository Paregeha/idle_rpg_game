import 'package:go_router/go_router.dart';
import 'package:idle_rpg/app/shell.dart';
import 'package:idle_rpg/features/hero/materials_screen.dart';
import 'package:idle_rpg/features/forge/forge_screen.dart';
import 'package:idle_rpg/features/home/home_screen.dart';
import 'package:idle_rpg/features/shop/shop_screen.dart';

/// The places a player can be.
///
/// Paths are stable strings because a push notification (`T-061`) will need to
/// deep-link straight into one of them.
abstract final class Routes {
  static const home = '/home';
  static const shop = '/shop';
  static const upgrades = '/upgrades';

  /// Materials. Outside the shell, so it covers the tabs and comes back with
  /// a back button — it is somewhere the player goes, not a fourth tab.
  static const materials = '/materials';

  /// Home first: the fight, the gear and the lamp are all on it, so most
  /// sessions never leave this tab.
  static const tabs = [home, shop, upgrades];
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      // A shell, not separate pages: the tab bar stays mounted across
      // navigation, so nothing restarts or flashes while the player switches.
      ShellRoute(
        builder: (context, state, child) =>
            GameShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: Routes.shop,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ShopScreen()),
          ),
          GoRoute(
            path: Routes.upgrades,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ForgeScreen()),
          ),
        ],
      ),
      GoRoute(
        path: Routes.materials,
        builder: (context, state) => const MaterialsScreen(),
      ),
    ],
  );
}
