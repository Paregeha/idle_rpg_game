import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_core/game_core.dart';

/// The balance config the game is running against.
///
/// Loaded from `game_core`'s own asset rather than a copy inside the client, so
/// there is exactly one balance file and the server and the client cannot drift
/// apart. `T-035` replaces this with a server-issued config, keeping the asset
/// as the offline fallback.
final balanceConfigProvider = FutureProvider<BalanceConfig>((ref) async {
  final source = await rootBundle.loadString(
    'packages/game_core/assets/balance/v1.json',
  );
  return BalanceConfig.parse(source);
});

/// Source of time for the game loop.
///
/// Overridden with a `FakeClock` in tests. Real progress will be re-derived
/// from server time in `T-032`; the device clock only smooths the local view
/// between syncs.
final clockProvider = Provider<Clock>((ref) => const SystemClock());

/// Milliseconds into the fight currently on screen.
///
/// A notifier rather than provider state: the battle scene writes it every
/// frame, and rebuilding the whole skill row sixty times a second to move one
/// ring would cost more than the ring is worth. Widgets that care listen to it
/// directly and repaint alone.
///
/// Reset to zero when a new fight starts, so a cooldown drawn from it always
/// matches the fight being watched.
final fightClockProvider = Provider<ValueNotifier<double>>((ref) {
  final clock = ValueNotifier<double>(0);
  ref.onDispose(clock.dispose);
  return clock;
});
