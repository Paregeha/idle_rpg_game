import 'package:ci_tools/core_deps_check.dart';
import 'package:test/test.dart';

void main() {
  group('findForbiddenDependencies', () {
    test('accepts a clean core pubspec', () {
      const pubspec = '''
name: game_core
dependencies:
  meta: ^1.16.0
dev_dependencies:
  test: ^1.25.5
''';

      expect(findForbiddenDependencies(pubspec), isEmpty);
    });

    test('rejects a flutter dependency', () {
      const pubspec = '''
name: game_core
dependencies:
  flutter:
    sdk: flutter
''';

      expect(findForbiddenDependencies(pubspec), contains('flutter'));
    });

    test('rejects flutter_test hiding in dev_dependencies', () {
      const pubspec = '''
name: game_core
dev_dependencies:
  flutter_test:
    sdk: flutter
''';

      expect(findForbiddenDependencies(pubspec), contains('flutter_test'));
    });

    test('rejects any flame package by prefix', () {
      const pubspec = '''
name: game_core
dependencies:
  flame: ^1.18.0
  flame_rive: ^1.10.0
''';

      expect(
        findForbiddenDependencies(pubspec),
        containsAll(<String>['flame', 'flame_rive']),
      );
    });

    test('does not flag packages that merely start with similar letters', () {
      const pubspec = '''
name: game_core
dependencies:
  flutter_bloc_lookalike_flamingo: ^1.0.0
''';

      // `flamingo` is not a Flame package; matching must be on the `flame_`
      // prefix or the exact name, never a bare substring.
      expect(findForbiddenDependencies(pubspec), isEmpty);
    });

    test('reports every violation at once, sorted', () {
      const pubspec = '''
name: game_core
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.18.0
dev_dependencies:
  flutter_test:
    sdk: flutter
''';

      expect(
        findForbiddenDependencies(pubspec),
        <String>['flame', 'flutter', 'flutter_test'],
      );
    });

    test('treats a pubspec without dependency sections as clean', () {
      expect(findForbiddenDependencies('name: game_core\n'), isEmpty);
    });

    test('throws a readable error on malformed yaml', () {
      expect(
        () => findForbiddenDependencies('name: [unclosed\n'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
