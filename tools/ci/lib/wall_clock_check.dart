/// One forbidden wall-clock access found in a source file.
class WallClockUse {
  const WallClockUse({
    required this.file,
    required this.line,
    required this.match,
  });

  final String file;

  /// 1-indexed, so the message can be pasted into an editor.
  final int line;

  /// The offending source line, trimmed.
  final String match;

  @override
  String toString() => '$file:$line: $match';
}

/// The only file in `game_core` permitted to read the device clock.
///
/// Matched as a path suffix rather than a bare filename, so a
/// `fake_system_clock.dart` somewhere else cannot inherit the exemption.
const String _exemptPath = 'lib/src/time/system_clock.dart';

/// Ways to read the device clock, all of which defeat an injected `Clock`.
final RegExp _wallClockPattern = RegExp(
  r'\b(DateTime\s*\.\s*now|DateTime\s*\.\s*timestamp|Stopwatch\s*\()',
);

/// Returns every wall-clock access in [source], which came from [path].
///
/// Progress in an idle game is a function of elapsed time, so a device clock is
/// the cheapest possible cheat: move the phone's date forward and the game pays
/// out. Game logic therefore takes an injected `Clock` and the server decides
/// what time it is. See rule 3 in CLAUDE.md.
///
/// Comments are skipped — prose explaining the rule must not trip it.
List<WallClockUse> findWallClockUses(String path, String source) {
  final normalized = path.replaceAll(r'\', '/');
  if (normalized.endsWith(_exemptPath)) return const [];

  final uses = <WallClockUse>[];
  final lines = source.split('\n');
  var inBlockComment = false;

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];

    if (inBlockComment) {
      final end = line.indexOf('*/');
      if (end == -1) continue;
      line = line.substring(end + 2);
      inBlockComment = false;
    }

    final blockStart = line.indexOf('/*');
    if (blockStart != -1) {
      inBlockComment = !line.contains('*/', blockStart);
      line = line.substring(0, blockStart);
    }

    final lineComment = line.indexOf('//');
    if (lineComment != -1) line = line.substring(0, lineComment);

    final match = _wallClockPattern.firstMatch(line);
    if (match != null) {
      uses.add(
        WallClockUse(file: path, line: i + 1, match: lines[i].trim()),
      );
    }
  }

  return uses;
}
