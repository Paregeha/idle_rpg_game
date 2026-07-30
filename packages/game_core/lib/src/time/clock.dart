/// Source of the current time for game logic.
///
/// Game logic never calls `DateTime.now()`. It takes a [Clock], so a test can
/// run thirty days of progress in a millisecond, and so the server can drive
/// the simulation from its own time rather than a device's — a device clock is
/// the cheapest thing in the world for a player to move forward.
///
/// Time is always UTC milliseconds since the epoch. See rule 3 in CLAUDE.md.
abstract interface class Clock {
  /// Milliseconds since the Unix epoch, UTC.
  int get nowMs;
}

/// A clock that only moves when a test moves it.
class FakeClock implements Clock {
  FakeClock(this._nowMs);

  int _nowMs;

  @override
  int get nowMs => _nowMs;

  /// Moves the clock forward by [duration].
  ///
  /// Rejects a negative duration: time going backwards is never something a
  /// test means to do, and it silently breaks any elapsed-time arithmetic.
  void advance(Duration duration) {
    if (duration.isNegative) {
      throw ArgumentError.value(duration, 'duration', 'must not be negative');
    }
    _nowMs += duration.inMilliseconds;
  }

  /// Jumps to an absolute instant, in UTC milliseconds since the epoch.
  set nowMs(int millisecondsSinceEpoch) => _nowMs = millisecondsSinceEpoch;
}
