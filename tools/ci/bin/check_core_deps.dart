import 'dart:io';

import 'package:ci_tools/core_deps_check.dart';

/// Fails the build if `game_core` ever gains a Flutter or Flame dependency.
///
/// Usage: `dart run ci_tools:check_core_deps [path/to/pubspec.yaml]`
/// Defaults to `packages/game_core/pubspec.yaml` relative to the repository
/// root, which is where CI invokes it from.
Future<void> main(List<String> args) async {
  final path = args.isEmpty ? 'packages/game_core/pubspec.yaml' : args.first;
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('check_core_deps: no pubspec at $path');
    exit(2);
  }

  final List<String> violations;
  try {
    violations = findForbiddenDependencies(file.readAsStringSync());
  } on FormatException catch (e) {
    stderr.writeln('check_core_deps: cannot read $path — ${e.message}');
    exit(2);
  }

  if (violations.isEmpty) {
    stdout.writeln('check_core_deps: $path is clean');
    return;
  }

  stderr
    ..writeln('check_core_deps: $path must not depend on Flutter or Flame.')
    ..writeln('Found: ${violations.join(', ')}')
    ..writeln(
      'game_core runs on a bare Dart VM inside the server; see rule 1 in '
      'CLAUDE.md.',
    );
  exit(1);
}
