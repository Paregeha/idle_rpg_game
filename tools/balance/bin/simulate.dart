import 'dart:io';

import 'package:args/args.dart';
import 'package:balance_tools/balance_run.dart';
import 'package:balance_tools/player_profile.dart';
import 'package:game_core/game_core.dart';

/// Balance simulator.
///
/// Prints a CSV of a modelled playthrough so a balance change can be reviewed
/// as a diff of two runs, without launching the game. This is the tool the
/// curves get tuned with — a config that reads fine and plays badly is the
/// normal failure mode, and only a run like this shows it (`docs/balance.md`).
///
/// Usage:
///   dart run simulate --days 30 --profile casual
///   dart run simulate --days 90 --profile all --config path/to/v2.json
Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('days', abbr: 'd', defaultsTo: '30', help: 'Days to simulate.')
    ..addOption(
      'profile',
      abbr: 'p',
      defaultsTo: 'casual',
      allowed: [...PlayerProfile.all.map((p) => p.name), 'all'],
      help: 'Which modelled player to run.',
    )
    ..addOption(
      'config',
      abbr: 'c',
      defaultsTo: '../../packages/game_core/assets/balance/v1.json',
      help: 'Balance file to run against.',
    )
    ..addFlag('help', abbr: 'h', negatable: false);

  final ArgResults options;
  try {
    options = parser.parse(args);
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(parser.usage);
    exit(64);
  }

  if (options.flag('help')) {
    stdout.writeln(parser.usage);
    return;
  }

  final days = int.tryParse(options.option('days')!);
  if (days == null || days <= 0) {
    stderr.writeln('--days must be a positive integer');
    exit(64);
  }

  final configFile = File(options.option('config')!);
  if (!configFile.existsSync()) {
    stderr.writeln('no balance file at ${configFile.path}');
    exit(66);
  }

  final BalanceConfig config;
  try {
    config = BalanceConfig.parse(configFile.readAsStringSync());
  } on BalanceConfigException catch (e) {
    stderr.writeln(e.toString());
    exit(65);
  }

  final requested = options.option('profile')!;
  final profiles = requested == 'all'
      ? PlayerProfile.all
      : [PlayerProfile.byName(requested)!];

  stdout.writeln(
    'profile,day,units_owned,gold,prestige_currency,'
    'next_upgrade_seconds,offline_forfeited_hours',
  );

  for (final profile in profiles) {
    final rows = runProfile(profile: profile, config: config, days: days);

    for (final row in rows) {
      final gold = row.resources['gold'] ?? BigNum.zero;
      final next = row.timeToNextUpgrade;

      stdout.writeln(
        [
          profile.name,
          row.day,
          row.unitsOwned,
          gold.serialize(),
          row.prestigeCurrency.serialize(),
          if (next == null) '' else next.inSeconds,
          (row.offlineForfeited.inMinutes / 60).toStringAsFixed(1),
        ].join(','),
      );
    }
  }
}
