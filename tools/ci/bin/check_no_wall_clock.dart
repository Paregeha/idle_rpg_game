import 'dart:io';

import 'package:ci_tools/wall_clock_check.dart';

/// Fails the build if game logic reads the device clock.
///
/// Usage: `dart run ci_tools:check_no_wall_clock [lib dir]`
/// Defaults to `packages/game_core/lib`, relative to the repository root.
Future<void> main(List<String> args) async {
  final root = args.isEmpty ? 'packages/game_core/lib' : args.first;
  final dir = Directory(root);

  if (!dir.existsSync()) {
    stderr.writeln('check_no_wall_clock: no directory at $root');
    exit(2);
  }

  final uses = <WallClockUse>[];
  var scanned = 0;

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    // Generated sources are not hand-written game logic.
    if (entity.path.endsWith('.g.dart') ||
        entity.path.endsWith('.freezed.dart')) {
      continue;
    }
    scanned++;
    uses.addAll(findWallClockUses(entity.path, entity.readAsStringSync()));
  }

  if (uses.isEmpty) {
    stdout.writeln('check_no_wall_clock: $scanned files clean');
    return;
  }

  stderr.writeln(
    'check_no_wall_clock: game logic must not read the device '
    'clock. Take an injected Clock instead (rule 3 in CLAUDE.md).',
  );
  for (final use in uses) {
    stderr.writeln('  $use');
  }
  exit(1);
}
