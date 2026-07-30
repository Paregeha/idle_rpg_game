import 'package:game_core/src/time/clock.dart';

/// The real wall clock.
///
/// This is the ONLY place in `game_core` allowed to call `DateTime.now()`, and
/// CI enforces that (see `tools/ci/bin/check_no_wall_clock.dart`). It is an
/// adapter, not game logic: nothing here decides anything about the game, it
/// only reports the time so a caller can hand it to the simulation.
///
/// On the client this is a convenience for UI smoothness only. Anything that
/// counts towards progress must use the server's time — a device clock is
/// trivially moved forward by a player.
class SystemClock implements Clock {
  const SystemClock();

  @override
  int get nowMs => DateTime.now().toUtc().millisecondsSinceEpoch;
}
