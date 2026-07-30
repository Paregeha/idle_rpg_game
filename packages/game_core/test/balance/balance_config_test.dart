import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

String json({
  String version = '"version": 1',
  String offlineCap = '"offlineCapMs": 28800000',
  String generators = '''
"generators": {
      "miner": {
        "produces": "gold",
        "baseRatePerSecond": "1e0",
        "levelMultiplier": 1.15,
        "costBase": "1e1",
        "costGrowth": 1.07
      }
    }''',
  String monsters = '''
"monsters": {
      "slime": {
        "baseHp": "1e1",
        "hpGrowth": 1.55,
        "rewardBase": "1e0",
        "rewardGrowth": 1.45,
        "dropChance": 0.1
      }
    }''',
  // A config with generators but no starting loadout is refused, so every
  // fixture needs one unless it is the fixture testing that rule.
  String start = '"start": { "generators": { "miner": 1 } }',
}) => '{ $version, $offlineCap, $generators, $monsters, $start }';

void main() {
  group('parsing', () {
    test('reads a well-formed config', () {
      final config = BalanceConfig.parse(json());

      expect(config.version, 1);
      expect(config.offlineCapMs, const Duration(hours: 8).inMilliseconds);
      expect(config.generators['miner']!.produces, 'gold');
      expect(config.generators['miner']!.costGrowth, 1.07);
      expect(config.monsters['slime']!.dropChance, 0.1);
    });

    test('BigNum fields keep their magnitude', () {
      final config = BalanceConfig.parse(
        json(
          generators: '''
"generators": {
      "vault": {
        "produces": "gold",
        "baseRatePerSecond": "1.5e40",
        "costBase": "1e2",
        "costGrowth": 1.1
      }
    }''',
          start: '"start": { "generators": { "vault": 1 } }',
        ),
      );

      expect(config.generators['vault']!.baseRatePerSecond, BigNum(1.5, 40));
    });

    test('round-trips through toJson', () {
      final config = BalanceConfig.parse(json());

      expect(BalanceConfig.fromJson(config.toJson()), config);
    });
  });

  group('validation refuses a bad config', () {
    void expectRejected(String source, {String? mentioning}) {
      expect(
        () => BalanceConfig.parse(source),
        throwsA(
          isA<BalanceConfigException>().having(
            (e) => '${e.message} ${e.field}',
            'message',
            mentioning == null ? isNotEmpty : contains(mentioning),
          ),
        ),
      );
    }

    test('malformed JSON', () {
      expectRejected('{ not json');
    });

    test('a missing version', () {
      expectRejected('{ "generators": {} }', mentioning: 'version');
    });

    test('a version from the future', () {
      expectRejected(json(version: '"version": 999'), mentioning: 'version');
    });

    test('a non-positive offline cap', () {
      expectRejected(
        json(offlineCap: '"offlineCapMs": 0'),
        mentioning: 'offlineCapMs',
      );
    });

    test('a generator producing nothing', () {
      expectRejected(
        json(
          generators: '''
"generators": {
      "ghost": {
        "produces": "",
        "baseRatePerSecond": "1e0",
        "costBase": "1e1",
        "costGrowth": 1.07
      }
    }''',
          start: '"start": { "generators": { "ghost": 1 } }',
        ),
        mentioning: 'produces',
      );
    });

    test('a negative production rate', () {
      expectRejected(
        json(
          generators: '''
"generators": {
      "drain": {
        "produces": "gold",
        "baseRatePerSecond": "-1e0",
        "costBase": "1e1",
        "costGrowth": 1.07
      }
    }''',
          start: '"start": { "generators": { "drain": 1 } }',
        ),
        mentioning: 'baseRatePerSecond',
      );
    });

    test('a cost curve that does not grow', () {
      // growth <= 1 means an upgrade never gets more expensive, which removes
      // the progression entirely.
      expectRejected(
        json(
          generators: '''
"generators": {
      "free": {
        "produces": "gold",
        "baseRatePerSecond": "1e0",
        "costBase": "1e1",
        "costGrowth": 1.0
      }
    }''',
          start: '"start": { "generators": { "free": 1 } }',
        ),
        mentioning: 'costGrowth',
      );
    });

    test('a drop chance outside 0..1', () {
      expectRejected(
        json(
          monsters: '''
"monsters": {
      "slime": {
        "baseHp": "1e1",
        "hpGrowth": 1.5,
        "rewardBase": "1e0",
        "rewardGrowth": 1.4,
        "dropChance": 1.5
      }
    }''',
        ),
        mentioning: 'dropChance',
      );
    });

    test('monster hp that does not grow', () {
      expectRejected(
        json(
          monsters: '''
"monsters": {
      "slime": {
        "baseHp": "1e1",
        "hpGrowth": 0.9,
        "rewardBase": "1e0",
        "rewardGrowth": 1.4,
        "dropChance": 0.1
      }
    }''',
        ),
        mentioning: 'hpGrowth',
      );
    });

    test('the error names the field so the file can be fixed', () {
      try {
        BalanceConfig.parse(json(offlineCap: '"offlineCapMs": -5'));
        fail('should have thrown');
      } on BalanceConfigException catch (e) {
        expect(e.field, contains('offlineCapMs'));
        expect(e.toString(), contains('offlineCapMs'));
      }
    });
  });

  group('curves', () {
    late BalanceConfig config;

    setUp(() => config = BalanceConfig.parse(json()));

    test('generator cost follows base * growth^owned', () {
      final miner = config.generators['miner']!;

      expect(miner.costFor(0), BigNum.fromDouble(10));
      // 10 * 1.07^3
      expect(miner.costFor(3).toDouble(), closeTo(12.25043, 1e-5));
    });

    test('cost of the next unit always exceeds the previous', () {
      final miner = config.generators['miner']!;

      for (var owned = 0; owned < 50; owned++) {
        expect(miner.costFor(owned + 1) > miner.costFor(owned), isTrue);
      }
    });

    test('cost stays exact past what a double could hold', () {
      final miner = config.generators['miner']!;

      // 1.07^1000 is about 1e29, times the base.
      expect(miner.costFor(1000).exponent, greaterThan(20));
    });

    test('monster hp follows base * growth^level', () {
      final slime = config.monsters['slime']!;

      expect(slime.hpFor(0), BigNum.fromDouble(10));
      expect(slime.hpFor(2).toDouble(), closeTo(10 * 1.55 * 1.55, 1e-9));
    });

    test('monster reward follows its own curve', () {
      final slime = config.monsters['slime']!;

      expect(slime.rewardFor(0), BigNum.one);
      expect(slime.rewardFor(3).toDouble(), closeTo(1.45 * 1.45 * 1.45, 1e-9));
    });

    test('a negative level is refused rather than silently clamped', () {
      expect(
        () => config.generators['miner']!.costFor(-1),
        throwsArgumentError,
      );
      expect(() => config.monsters['slime']!.hpFor(-1), throwsArgumentError);
    });
  });
}
