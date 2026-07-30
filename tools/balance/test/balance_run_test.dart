@TestOn('vm')
library;

import 'dart:io';

import 'package:balance_tools/balance_run.dart';
import 'package:balance_tools/player_profile.dart';
import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

void main() {
  late BalanceConfig config;

  setUpAll(() {
    config = BalanceConfig.parse(
      File(
        '../../packages/game_core/assets/balance/v1.json',
      ).readAsStringSync(),
    );
  });

  group('profiles', () {
    test('all three are available by name', () {
      for (final name in ['casual', 'active', 'whale']) {
        expect(PlayerProfile.byName(name), isNotNull, reason: name);
      }
      expect(PlayerProfile.byName('nobody'), isNull);
    });

    test('a busier profile spends more time in the game', () {
      Duration playtime(PlayerProfile p) => p.sessionLength * p.sessionsPerDay;

      expect(
        playtime(PlayerProfile.active),
        greaterThan(playtime(PlayerProfile.casual)),
      );
      expect(
        playtime(PlayerProfile.whale),
        greaterThan(playtime(PlayerProfile.active)),
      );
    });
  });

  group('a run against the shipped balance', () {
    test('produces one row per day', () {
      final rows = runProfile(
        profile: PlayerProfile.casual,
        config: config,
        days: 7,
      );

      expect(rows, hasLength(7));
      expect(rows.first.day, 1);
      expect(rows.last.day, 7);
    });

    test('a new player actually gets going', () {
      // The whole point of the tool: catch a config where progress is
      // impossible. Before the config granted a starting generator, every
      // profile sat at zero forever and this test would have failed.
      final rows = runProfile(
        profile: PlayerProfile.casual,
        config: config,
        days: 3,
      );

      expect(rows.first.unitsOwned, greaterThan(0));
      expect(rows.last.unitsOwned, greaterThan(rows.first.unitsOwned));
    });

    test('progress never goes backwards', () {
      final rows = runProfile(
        profile: PlayerProfile.active,
        config: config,
        days: 14,
      );

      for (var i = 1; i < rows.length; i++) {
        expect(
          rows[i].unitsOwned,
          greaterThanOrEqualTo(rows[i - 1].unitsOwned),
          reason: 'day ${rows[i].day} owns fewer units than the day before',
        );
      }
    });

    test('a busier player is further ahead after two weeks', () {
      final casual = runProfile(
        profile: PlayerProfile.casual,
        config: config,
        days: 14,
      );
      final active = runProfile(
        profile: PlayerProfile.active,
        config: config,
        days: 14,
      );

      expect(active.last.unitsOwned, greaterThan(casual.last.unitsOwned));
    });

    test('the wait for the next upgrade grows as the curve bites', () {
      final rows = runProfile(
        profile: PlayerProfile.casual,
        config: config,
        days: 21,
      );

      final early = rows[1].timeToNextUpgrade;
      final late = rows.last.timeToNextUpgrade;

      expect(early, isNotNull);
      expect(late, isNotNull);
      expect(
        late,
        greaterThan(early!),
        reason: 'a curve that never slows down has no progression in it',
      );
    });

    test('a day never takes an unreasonable time to simulate', () {
      final stopwatch = Stopwatch()..start();

      runProfile(profile: PlayerProfile.whale, config: config, days: 30);

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });
  });
}
