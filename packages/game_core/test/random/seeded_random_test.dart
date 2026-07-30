import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  group('determinism', () {
    test('the same seed replays the same sequence', () {
      final a = SeededRandom(12345);
      final b = SeededRandom(12345);

      final first = List.generate(50, (_) => a.nextUint32());
      final second = List.generate(50, (_) => b.nextUint32());

      expect(second, first);
    });

    test('different seeds diverge', () {
      final a = SeededRandom(1);
      final b = SeededRandom(2);

      expect(
        List.generate(20, (_) => a.nextUint32()),
        isNot(List.generate(20, (_) => b.nextUint32())),
      );
    });

    /// A snapshot of this implementation, not a check against an outside
    /// reference — the seeding is ours, so no published vector would match.
    ///
    /// Its job is to make any change to the algorithm loud. Saved games carry
    /// an RNG state, so altering the step function would desynchronise every
    /// existing save from the server. If this test fails, the fix is to revert
    /// the change, not to regenerate the numbers.
    test('golden sequence for seed 42 never changes', () {
      final rng = SeededRandom(42);

      expect(List.generate(8, (_) => rng.nextUint32()), <int>[
        1882745384,
        338978560,
        2045474340,
        2714263000,
        303172323,
        2779341766,
        2278652673,
        1679085758,
      ]);
    });

    test('values stay inside the unsigned 32-bit range on every platform', () {
      final rng = SeededRandom(7);

      for (var i = 0; i < 1000; i++) {
        final v = rng.nextUint32();
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThanOrEqualTo(0xFFFFFFFF));
      }
    });
  });

  group('derived distributions', () {
    test('nextInt stays in range', () {
      final rng = SeededRandom(99);

      for (var i = 0; i < 1000; i++) {
        final v = rng.nextInt(6);
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThan(6));
      }
    });

    test('nextInt(1) is always zero', () {
      final rng = SeededRandom(3);

      expect(List.generate(10, (_) => rng.nextInt(1)), everyElement(0));
    });

    test('nextInt rejects a non-positive bound', () {
      final rng = SeededRandom(3);

      expect(() => rng.nextInt(0), throwsArgumentError);
      expect(() => rng.nextInt(-1), throwsArgumentError);
    });

    test('nextDouble stays in [0, 1)', () {
      final rng = SeededRandom(4);

      for (var i = 0; i < 1000; i++) {
        final v = rng.nextDouble();
        expect(v, greaterThanOrEqualTo(0.0));
        expect(v, lessThan(1.0));
      }
    });

    test('nextBool produces both outcomes', () {
      final rng = SeededRandom(5);
      final values = List.generate(200, (_) => rng.nextBool());

      expect(values, contains(true));
      expect(values, contains(false));
    });

    test('nextInt is roughly uniform', () {
      final rng = SeededRandom(2026);
      final buckets = List.filled(6, 0);

      for (var i = 0; i < 60000; i++) {
        buckets[rng.nextInt(6)]++;
      }

      // 10 000 expected per bucket; a 10% band catches a badly broken
      // generator without turning into a flaky statistical test.
      for (final count in buckets) {
        expect(count, greaterThan(9000));
        expect(count, lessThan(11000));
      }
    });
  });

  group('state round-trip', () {
    test('a captured state resumes the exact sequence', () {
      final rng = SeededRandom(777);
      List.generate(10, (_) => rng.nextUint32());

      final resumed = SeededRandom.fromState(rng.state);

      expect(
        List.generate(20, (_) => resumed.nextUint32()),
        List.generate(20, (_) => rng.nextUint32()),
      );
    });

    test('state survives a JSON-safe round-trip', () {
      final rng = SeededRandom(31337);
      List.generate(5, (_) => rng.nextUint32());

      final encoded = rng.state.toList();
      final resumed = SeededRandom.fromState(encoded);

      expect(resumed.nextUint32(), rng.nextUint32());
    });

    test('fromState rejects a malformed state', () {
      expect(() => SeededRandom.fromState(const [1, 2]), throwsArgumentError);
    });

    test('a fresh generator never starts in the all-zero state', () {
      // xorshift is stuck forever at all zeros; seed 0 must not produce it.
      final rng = SeededRandom(0);

      expect(rng.state.any((w) => w != 0), isTrue);
      expect(
        List.generate(10, (_) => rng.nextUint32()),
        isNot(everyElement(0)),
      );
    });
  });
}
