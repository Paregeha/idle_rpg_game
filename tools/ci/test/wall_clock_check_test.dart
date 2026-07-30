import 'package:ci_tools/wall_clock_check.dart';
import 'package:test/test.dart';

void main() {
  group('findWallClockUses', () {
    test('accepts a file with no wall-clock access', () {
      const source = '''
int elapsed(Clock clock, int since) => clock.nowMs - since;
''';

      expect(findWallClockUses('lib/src/sim/simulator.dart', source), isEmpty);
    });

    test('flags DateTime.now()', () {
      const source = '''
void tick() {
  final t = DateTime.now();
}
''';

      final hits = findWallClockUses('lib/src/sim/simulator.dart', source);

      expect(hits, hasLength(1));
      expect(hits.single.line, 2);
      expect(hits.single.match, contains('DateTime.now'));
    });

    test('flags DateTime.timestamp() too', () {
      const source = 'final t = DateTime.timestamp();';

      expect(findWallClockUses('lib/a.dart', source), hasLength(1));
    });

    test('flags Stopwatch, which is also a device clock', () {
      const source = 'final sw = Stopwatch()..start();';

      expect(findWallClockUses('lib/a.dart', source), hasLength(1));
    });

    test('reports every use, with line numbers', () {
      const source = '''
final a = DateTime.now();
final b = 1;
final c = DateTime.now();
''';

      final hits = findWallClockUses('lib/a.dart', source);

      expect(hits.map((h) => h.line), [1, 3]);
    });

    test('the system clock adapter is the one allowed exception', () {
      const source = '''
int get nowMs => DateTime.now().toUtc().millisecondsSinceEpoch;
''';

      expect(
        findWallClockUses('lib/src/time/system_clock.dart', source),
        isEmpty,
      );
    });

    test('the exemption is by path, not by filename anywhere', () {
      const source = 'final t = DateTime.now();';

      // A file that merely calls itself system_clock elsewhere in the tree
      // must not inherit the exemption.
      expect(
        findWallClockUses('lib/src/sim/fake_system_clock.dart', source),
        hasLength(1),
      );
    });

    test('ignores the word inside a comment', () {
      const source = '''
// Never call DateTime.now() here; take a Clock instead.
int elapsed(Clock c) => c.nowMs;
''';

      expect(findWallClockUses('lib/a.dart', source), isEmpty);
    });

    test('ignores a doc comment mentioning it', () {
      const source = '''
/// Unlike DateTime.now(), this is injectable.
int elapsed(Clock c) => c.nowMs;
''';

      expect(findWallClockUses('lib/a.dart', source), isEmpty);
    });
  });
}
