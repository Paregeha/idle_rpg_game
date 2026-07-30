import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  group('FakeClock', () {
    test('reports the time it was given', () {
      final clock = FakeClock(1770000000000);

      expect(clock.nowMs, 1770000000000);
    });

    test('advances by a duration', () {
      final clock = FakeClock(1000)..advance(const Duration(seconds: 90));

      expect(clock.nowMs, 1000 + 90000);
    });

    test('can be set to an absolute instant', () {
      final clock = FakeClock(1000)..nowMs = 5000;

      expect(clock.nowMs, 5000);
    });

    test('refuses to travel backwards by accident', () {
      final clock = FakeClock(1000);

      expect(
        () => clock.advance(const Duration(seconds: -1)),
        throwsArgumentError,
      );
    });

    test('does not drift on its own', () {
      final clock = FakeClock(42);

      expect(clock.nowMs, 42);
      expect(clock.nowMs, 42, reason: 'reading the clock must not advance it');
    });
  });

  group('SystemClock', () {
    test('returns UTC milliseconds since epoch', () {
      const clock = SystemClock();
      final before = DateTime.now().toUtc().millisecondsSinceEpoch;

      final now = clock.nowMs;

      final after = DateTime.now().toUtc().millisecondsSinceEpoch;
      expect(now, greaterThanOrEqualTo(before));
      expect(now, lessThanOrEqualTo(after));
    });
  });

  test('both clocks satisfy the same contract', () {
    final clocks = <Clock>[const SystemClock(), FakeClock(0)];

    for (final clock in clocks) {
      expect(clock.nowMs, isA<int>());
    }
  });
}
