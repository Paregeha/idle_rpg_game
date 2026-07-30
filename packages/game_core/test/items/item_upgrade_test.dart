import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Money arithmetic across magnitudes is not exact in a double mantissa.
Matcher nearly(double expected) => predicate<BigNum>((actual) {
  if (expected == 0) return actual.isZero;
  final target = BigNum.fromDouble(expected);
  return ((actual - target).abs() / target.abs()).toDouble() <= 1e-9;
}, 'within 1e-9 of $expected');

BalanceConfig config({int duplicatesPerLevel = 0, int maxLevel = 20}) =>
    BalanceConfig(
      slots: const ['weapon'],
      rarities: const {'common': RarityConfig()},
      items: {
        'blade': ItemConfig(
          slot: 'weapon',
          rarity: 'common',
          maxLevel: maxLevel,
          stats: ItemStats(flatAttack: BigNum.fromDouble(10)),
        ),
      },
      itemUpgrade: ItemUpgradeConfig(
        costBase: BigNum.fromDouble(100),
        costGrowth: 2,
        duplicatesPerLevel: duplicatesPerLevel,
      ),
    );

PlayerState state({double gold = 1e9, int copies = 1}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  resources: {'gold': BigNum.fromDouble(gold)},
  inventory: {
    for (var i = 0; i < copies; i++)
      'i$i': OwnedItem(id: 'i$i', configId: 'blade'),
  },
);

void main() {
  group('upgrading', () {
    test('raises the level and charges for it', () {
      final result = upgradeItem(state(gold: 500), 'i0', config());

      expect(result.upgraded, isTrue);
      expect(result.item!.level, 1);
      expect(result.state.resources['gold'], nearly(400));
    });

    test('the price climbs with the level', () {
      // 100, then 200, then 400 at growth 2.
      var current = state(gold: 700);
      for (var i = 0; i < 3; i++) {
        current = upgradeItem(current, 'i0', config()).state;
      }

      expect(current.inventory['i0']!.level, 3);
      expect(current.resources['gold'], nearly(0));
    });

    test('refuses when the player cannot pay', () {
      final result = upgradeItem(state(gold: 50), 'i0', config());

      expect(result.refusal, UpgradeRefusal.cannotAfford);
      expect(result.state, state(gold: 50), reason: 'nothing may change');
    });

    test('refuses an unknown item', () {
      expect(
        upgradeItem(state(), 'nothing', config()).refusal,
        UpgradeRefusal.unknownItem,
      );
    });

    test('refuses past the configured maximum', () {
      var current = state();
      for (var i = 0; i < 3; i++) {
        current = upgradeItem(current, 'i0', config(maxLevel: 3)).state;
      }

      final result = upgradeItem(current, 'i0', config(maxLevel: 3));

      expect(result.refusal, UpgradeRefusal.alreadyMaxLevel);
      expect(current.inventory['i0']!.level, 3);
    });

    test('is pure', () {
      final before = state();
      final snapshot = before.toJson();

      upgradeItem(before, 'i0', config());

      expect(before.toJson(), snapshot);
    });
  });

  group('duplicates', () {
    test('are consumed when the config asks for them', () {
      final result = upgradeItem(
        state(copies: 3),
        'i0',
        config(duplicatesPerLevel: 1),
      );

      expect(result.upgraded, isTrue);
      expect(result.consumed, hasLength(1));
      expect(result.state.inventory, hasLength(2));
    });

    test('refuses when there are not enough spare copies', () {
      final result = upgradeItem(
        state(),
        'i0',
        config(duplicatesPerLevel: 1),
      );

      expect(result.refusal, UpgradeRefusal.notEnoughDuplicates);
      expect(result.state.inventory, hasLength(1));
    });

    test('never eats an equipped copy', () {
      // Otherwise upgrading one item silently strips a slot, and the player
      // finds out from a weaker hero rather than from the game.
      final withWorn = state(copies: 2).copyWith(
        equipped: const {'weapon': 'i1'},
      );

      final result = upgradeItem(withWorn, 'i0', config(duplicatesPerLevel: 1));

      expect(result.refusal, UpgradeRefusal.notEnoughDuplicates);
      expect(result.state.inventory.containsKey('i1'), isTrue);
    });

    test('never eats the item being upgraded', () {
      final result = upgradeItem(
        state(copies: 2),
        'i0',
        config(duplicatesPerLevel: 1),
      );

      expect(result.consumed, isNot(contains('i0')));
      expect(result.state.inventory.containsKey('i0'), isTrue);
    });
  });

  group('twenty upgrades in a row', () {
    test('strengthen the item monotonically and keep the state sound', () {
      const rarity = RarityConfig();
      var current = state(gold: 1000000000000, copies: 25);
      var previous = BigNum.zero;

      for (var level = 0; level < 20; level++) {
        final result = upgradeItem(
          current,
          'i0',
          config(duplicatesPerLevel: 1),
        );
        expect(result.upgraded, isTrue, reason: 'upgrade $level was refused');
        current = result.state;

        final item = config().items['blade']!;
        final stats = item.statsAt(
          level: current.inventory['i0']!.level,
          rarity: rarity,
        );
        expect(
          stats.flatAttack > previous,
          isTrue,
          reason: 'level ${current.inventory["i0"]!.level} is no stronger',
        );
        previous = stats.flatAttack;

        // The state must stay loadable after every step.
        expect(PlayerState.fromJson(current.toJson()), current);
      }

      expect(current.inventory['i0']!.level, 20);
    });
  });

  group('config validation', () {
    test('refuses a cost curve that gets cheaper', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "itemUpgrade": { "costGrowth": 0.8 } }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses negative duplicate requirements', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "itemUpgrade": { "duplicatesPerLevel": -1 } }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
