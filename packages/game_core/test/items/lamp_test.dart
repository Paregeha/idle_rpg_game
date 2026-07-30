import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Subtracting across magnitudes is not exact in a double mantissa: 100 - 1
/// lands a hair off 99. Invisible to a player, worth stating honestly here.
Matcher nearly(double expected) => predicate<BigNum>((actual) {
  if (expected == 0) return actual.isZero;
  final target = BigNum.fromDouble(expected);
  return ((actual - target).abs() / target.abs()).toDouble() <= 1e-9;
}, 'within 1e-9 of $expected');

BalanceConfig config({
  int pityThreshold = 0,
  Map<String, double>? weights,
}) => BalanceConfig(
  slots: const ['weapon'],
  rarities: const {
    'common': RarityConfig(),
    'rare': RarityConfig(statMultiplier: 2, rank: 1),
    'legendary': RarityConfig(statMultiplier: 10, rank: 3),
  },
  items: const {
    'stick': ItemConfig(slot: 'weapon', rarity: 'common'),
    'blade': ItemConfig(slot: 'weapon', rarity: 'rare'),
    'wyrmfang': ItemConfig(slot: 'weapon', rarity: 'legendary'),
  },
  lamp: LampConfig(
    weights: weights ?? const {'common': 70, 'rare': 25, 'legendary': 5},
    pityThreshold: pityThreshold,
    pityRarity: 'legendary',
  ),
);

PlayerState state({double gems = 100, int seed = 42}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: seed,
  resources: {'gems': BigNum.fromDouble(gems)},
);

void main() {
  group('opening', () {
    test('gives an item and charges for it', () {
      final result = openLamp(state(), config());

      expect(result.opened, isTrue);
      expect(result.state.inventory, hasLength(1));
      expect(result.state.resources['gems'], nearly(99));
    });

    test('refuses when the player cannot pay', () {
      final result = openLamp(state(gems: 0), config());

      expect(result.opened, isFalse);
      expect(result.refusal, LampRefusal.cannotAfford);
      expect(result.state, state(gems: 0), reason: 'nothing may change');
    });

    test('refuses when nothing is configured to drop', () {
      const empty = BalanceConfig(slots: ['weapon']);

      final result = openLamp(state(), empty);

      expect(result.refusal, LampRefusal.noItemsConfigured);
      expect(
        result.state.resources['gems'],
        nearly(100),
        reason: 'a player must never be charged for nothing',
      );
    });

    test('is pure', () {
      final before = state();
      final snapshot = before.toJson();

      openLamp(before, config());

      expect(before.toJson(), snapshot);
    });
  });

  group('determinism', () {
    test('the same state gives the same item', () {
      final a = openLamp(state(), config());
      final b = openLamp(state(), config());

      expect(a.item!.configId, b.item!.configId);
      expect(a.item!.id, b.item!.id);
    });

    test('consecutive opens differ, because the RNG state advances', () {
      // Storing only the seed would hand out the same item forever.
      var current = state();
      final drawn = <String>[];

      for (var i = 0; i < 12; i++) {
        final result = openLamp(current, config());
        current = result.state;
        drawn.add(result.item!.configId);
      }

      expect(drawn.toSet().length, greaterThan(1));
    });

    test('a reloaded save continues the sequence, not restarts it', () {
      var live = state();
      for (var i = 0; i < 5; i++) {
        live = openLamp(live, config()).state;
      }

      final reloaded = PlayerState.fromJson(live.toJson());

      expect(
        openLamp(reloaded, config()).item!.configId,
        openLamp(live, config()).item!.configId,
      );
    });

    test('ids come from a counter, so the server can replay them', () {
      var current = state();
      final ids = <String>[];

      for (var i = 0; i < 4; i++) {
        final result = openLamp(current, config());
        current = result.state;
        ids.add(result.item!.id);
      }

      expect(ids, ['item-0', 'item-1', 'item-2', 'item-3']);
      expect(current.itemsCreated, 4);
    });
  });

  group('the distribution', () {
    test('10 000 opens land near the configured weights', () {
      var current = state(gems: 20000);
      final counts = <String, int>{};

      for (var i = 0; i < 10000; i++) {
        final result = openLamp(current, config());
        current = result.state;
        final rarity = config().items[result.item!.configId]!.rarity;
        counts[rarity] = (counts[rarity] ?? 0) + 1;
      }

      // 70 / 25 / 5, with a band wide enough not to flake but tight enough to
      // catch a genuinely wrong table.
      expect(counts['common']! / 10000, closeTo(0.70, 0.03));
      expect(counts['rare']! / 10000, closeTo(0.25, 0.03));
      expect(counts['legendary']! / 10000, closeTo(0.05, 0.02));
    });

    test('a zero weight never drops', () {
      var current = state(gems: 500);
      final withoutLegendary = config(
        weights: const {'common': 50, 'rare': 50, 'legendary': 0},
      );

      for (var i = 0; i < 400; i++) {
        final result = openLamp(current, withoutLegendary);
        current = result.state;
        expect(
          withoutLegendary.items[result.item!.configId]!.rarity,
          isNot('legendary'),
        );
      }
    });
  });

  group('pity', () {
    test('guarantees the rarity once the threshold is reached', () {
      var current = state(gems: 200);
      final withPity = config(
        pityThreshold: 10,
        // Legendary is impossible by weight, so only pity can produce it.
        weights: const {'common': 100, 'rare': 0, 'legendary': 0},
      );

      var sawPity = false;
      for (var i = 0; i < 10; i++) {
        final result = openLamp(current, withPity);
        current = result.state;
        if (result.wasPity) {
          sawPity = true;
          expect(withPity.items[result.item!.configId]!.rarity, 'legendary');
        }
      }

      expect(
        sawPity,
        isTrue,
        reason: 'ten opens at a threshold of ten must trigger the guarantee',
      );
    });

    test('the counter resets after the rarity drops', () {
      var current = state(gems: 200);
      final withPity = config(
        pityThreshold: 5,
        weights: const {'common': 100, 'rare': 0, 'legendary': 0},
      );

      for (var i = 0; i < 5; i++) {
        current = openLamp(current, withPity).state;
      }

      expect(current.pityCounter, 0);
    });

    test('the counter advances on an unlucky open', () {
      final unlucky = config(
        pityThreshold: 50,
        weights: const {'common': 100, 'rare': 0, 'legendary': 0},
      );

      final result = openLamp(state(), unlucky);

      expect(result.state.pityCounter, 1);
      expect(result.wasPity, isFalse);
    });

    test('no pity configured means the counter is meaningless, not broken', () {
      var current = state();

      for (var i = 0; i < 20; i++) {
        current = openLamp(current, config()).state;
      }

      expect(current.inventory, hasLength(20));
    });
  });

  group('config validation', () {
    test('refuses weights on a rarity that does not exist', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "rarities": { "common": { "statMultiplier": 1 } },
  "lamp": { "weights": { "mythic": 5 } }
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a pity rarity that does not exist', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "rarities": { "common": { "statMultiplier": 1 } },
  "lamp": { "weights": { "common": 1 }, "pityThreshold": 10,
            "pityRarity": "mythic" }
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses weights that sum to zero', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "rarities": { "common": { "statMultiplier": 1 } },
  "lamp": { "weights": { "common": 0 } }
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
