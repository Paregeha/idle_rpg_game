import 'package:yaml/yaml.dart';

/// Packages that must never appear in `game_core`, by exact name.
const Set<String> _forbiddenNames = {'flutter', 'flutter_test', 'flame'};

/// Packages under this prefix are Flame plugins (`flame_rive`, `flame_audio`).
/// Matching on the underscore keeps unrelated names like `flamingo` clean.
const String _forbiddenPrefix = 'flame_';

const List<String> _dependencySections = [
  'dependencies',
  'dev_dependencies',
  'dependency_overrides',
];

/// Returns the names of dependencies in [pubspecYaml] that `game_core` is not
/// allowed to have, sorted and deduplicated. Empty means the package is clean.
///
/// The core runs on a bare Dart VM inside the server, so a Flutter or Flame
/// dependency would break the server build — and, worse, would let UI concerns
/// leak into the one place that defines the rules of the game.
///
/// Throws a [FormatException] if [pubspecYaml] is not valid YAML.
List<String> findForbiddenDependencies(String pubspecYaml) {
  final YamlNode parsed;
  try {
    parsed = loadYamlNode(pubspecYaml);
  } on YamlException catch (e) {
    throw FormatException('pubspec is not valid YAML: ${e.message}');
  }

  if (parsed is! YamlMap) {
    throw const FormatException('pubspec must be a YAML map');
  }

  final violations = <String>{};
  for (final section in _dependencySections) {
    final node = parsed[section];
    if (node is! YamlMap) continue;

    for (final key in node.keys) {
      final name = key.toString();
      if (_forbiddenNames.contains(name) || name.startsWith(_forbiddenPrefix)) {
        violations.add(name);
      }
    }
  }

  return violations.toList()..sort();
}
