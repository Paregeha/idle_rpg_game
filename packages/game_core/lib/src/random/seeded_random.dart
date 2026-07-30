/// Deterministic pseudo-random generator, identical on every platform.
///
/// `dart:math`'s `Random(seed)` does not promise the same sequence across the
/// VM and a JavaScript runtime, which would let a client and the server draw
/// different numbers from the same state — exactly the divergence rule 5 in
/// CLAUDE.md exists to prevent. So the algorithm lives here.
///
/// xorshift128 is the right shape for that promise: it uses only shifts and
/// XOR. A 32×32 multiply would overflow JavaScript's 53-bit integer precision
/// and silently produce different results, so there is deliberately no
/// multiplication anywhere in the step function. Every intermediate is forced
/// back into 32 unsigned bits with `toUnsigned(32)`, which behaves the same on
/// both platforms.
///
/// Not cryptographically secure, and not meant to be — the server recomputes
/// every outcome anyway, so predicting a roll gains a player nothing.
class SeededRandom {
  /// Creates a generator from an integer [seed].
  ///
  /// The seed is spread across four words with distinct constants, then the
  /// generator is stepped a few times so that neighbouring seeds do not start
  /// out producing similar sequences. Seed `0` is safe: the constants
  /// guarantee the state is never all zeros, which xorshift can never leave.
  factory SeededRandom(int seed) {
    final s = seed.toUnsigned(32);
    final random = SeededRandom._([
      (s ^ 0x9E3779B9).toUnsigned(32),
      (s ^ 0x243F6A88).toUnsigned(32),
      (s ^ 0xB7E15162).toUnsigned(32),
      (s ^ 0x8F1BBCDC).toUnsigned(32),
    ]);
    for (var i = 0; i < 16; i++) {
      random.nextUint32();
    }
    return random;
  }

  /// Resumes a generator from a state captured with [state].
  ///
  /// This is what makes a saved game deterministic: storing the original seed
  /// alone would replay the sequence from the beginning after every load.
  factory SeededRandom.fromState(List<int> state) {
    if (state.length != _stateWords) {
      throw ArgumentError.value(
        state,
        'state',
        'expected $_stateWords words, got ${state.length}',
      );
    }
    for (final word in state) {
      if (word < 0 || word > 0xFFFFFFFF) {
        throw ArgumentError.value(state, 'state', 'word out of 32-bit range');
      }
    }
    if (state.every((word) => word == 0)) {
      throw ArgumentError.value(state, 'state', 'all-zero state is a dead end');
    }
    return SeededRandom._(List<int>.of(state));
  }

  SeededRandom._(this._state);

  static const int _stateWords = 4;

  final List<int> _state;

  /// A snapshot of the internal state, safe to persist as plain integers.
  List<int> get state => List<int>.unmodifiable(_state);

  /// The next raw draw, in `[0, 2^32)`.
  int nextUint32() {
    var t = _state[0];
    final s = _state[3];

    t = (t ^ (t << 11)).toUnsigned(32);
    t = t ^ (t >> 8);

    _state[0] = _state[1];
    _state[1] = _state[2];
    _state[2] = s;
    _state[3] = (s ^ (s >> 19) ^ t).toUnsigned(32);

    return _state[3];
  }

  /// A uniform integer in `[0, max)`.
  ///
  /// Draws are rejected rather than folded with `%`, so the distribution stays
  /// exactly uniform instead of leaning towards the low values.
  int nextInt(int max) {
    if (max <= 0) {
      throw ArgumentError.value(max, 'max', 'must be positive');
    }
    const range = 0x100000000;
    final limit = range - (range % max);

    int draw;
    do {
      draw = nextUint32();
    } while (draw >= limit);

    return draw % max;
  }

  /// A uniform double in `[0, 1)`.
  double nextDouble() => nextUint32() / 0x100000000;

  /// A coin flip.
  bool nextBool() => nextUint32() & 1 == 1;
}
