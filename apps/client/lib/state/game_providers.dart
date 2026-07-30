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
