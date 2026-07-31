import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'helm'),
  ],
  rarities: const {
    'common': RarityConfig(),
    'epic': RarityConfig(rank: 2, statMultiplier: 3),
  },
  items: const {
    'stick': ItemConfig(slot: 'weapon', rarity: 'common'),
    'blade': ItemConfig(slot: 'weapon', rarity: 'epic'),
    'cap': ItemConfig(slot: 'helm', rarity: 'common'),
  },
  salvage: SalvageConfig(
    levelMultiplier: 2,
    yields: {
      'common': {'gold': BigNum.fromDouble(10), 'scrap': BigNum.one},
      'epic': {'gold': BigNum.fromDouble(100), 'scrap': BigNum.fromDouble(5)},
    },
  ),
);

PlayerState state({
  Map<String, OwnedItem> inventory = const {},
  Map<String, String> equipped = const {},
}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  inventory: inventory,
  equipped: equipped,
);

const stick = OwnedItem(id: 'i0', configId: 'stick');
const blade = OwnedItem(id: 'i1', configId: 'blade');
const cap = OwnedItem(id: 'i2', configId: 'cap');

void main() {
  group('one item', () {
    test('pays what its rarity is worth and removes it', () {
      final result = salvageItem(
        state(inventory: const {'i0': stick}),
        'i0',
        config(),
      );

      expect(result.broken, 1);
      expect(result.gained['gold'], BigNum.fromDouble(10));
      expect(result.gained['scrap'], BigNum.one);
      expect(result.state.inventory, isEmpty);
      expect(result.state.resources['gold'], BigNum.fromDouble(10));
    });

    test('an upgraded item is worth more than a fresh one', () {
      // Levels cost duplicates and gold. Paying the same for both would make
      // upgrading anything a trap.
      final fresh = salvageItem(
        state(inventory: const {'i0': stick}),
        'i0',
        config(),
      );
      final levelled = salvageItem(
        state(
          inventory: const {
            'i0': OwnedItem(id: 'i0', configId: 'stick', level: 3),
          },
        ),
        'i0',
        config(),
      );

      expect(levelled.gained['gold']! > fresh.gained['gold']!, isTrue);
    });

    test('refuses to break what the hero is wearing', () {
      // Stripping a slot as a side effect is how a player finds out from a
      // weaker hero instead of from the game.
      final before = state(
        inventory: const {'i0': stick},
        equipped: const {'weapon': 'i0'},
      );
      final result = salvageItem(before, 'i0', config());

      expect(result.refusal, SalvageRefusal.equipped);
      expect(result.state, before);
    });

    test('refuses an item that does not exist', () {
      expect(
        salvageItem(state(), 'ghost', config()).refusal,
        SalvageRefusal.unknownItem,
      );
    });

    test('refuses a rarity the config pays nothing for', () {
      final noYields = config().copyWith(salvage: const SalvageConfig());
      final result = salvageItem(
        state(inventory: const {'i0': stick}),
        'i0',
        noYields,
      );

      expect(result.refusal, SalvageRefusal.nothingToGive);
      expect(result.state.inventory, isNotEmpty);
    });

    test('is pure', () {
      final before = state(inventory: const {'i0': stick});
      final snapshot = before.toJson();

      salvageItem(before, 'i0', config());

      expect(before.toJson(), snapshot);
    });
  });

  group('breaking down the junk', () {
    test('takes everything at or below the rank and leaves the rest', () {
      final result = salvageJunk(
        state(inventory: const {'i0': stick, 'i1': blade, 'i2': cap}),
        config(),
        maxRank: 0,
      );

      expect(result.broken, 2);
      expect(result.state.inventory.keys, ['i1']);
      expect(result.gained['gold'], BigNum.fromDouble(20));
    });

    test('never touches what is worn', () {
      final result = salvageJunk(
        state(
          inventory: const {'i0': stick, 'i2': cap},
          equipped: const {'weapon': 'i0'},
        ),
        config(),
        maxRank: 0,
      );

      expect(result.state.inventory.containsKey('i0'), isTrue);
      expect(result.broken, 1);
    });

    test('keeps spare copies of what is worn', () {
      // Those are what item upgrades eat. Eating them here would quietly close
      // the upgrade path the player is saving for.
      const spare = OwnedItem(id: 'i9', configId: 'stick');
      final result = salvageJunk(
        state(
          inventory: {'i0': stick, 'i9': spare},
          equipped: const {'weapon': 'i0'},
        ),
        config(),
        maxRank: 0,
      );

      expect(result.broken, 0);
      expect(result.state.inventory.keys, containsAll(['i0', 'i9']));
    });

    test('a rank below zero breaks nothing', () {
      final before = state(inventory: const {'i0': stick});

      expect(salvageJunk(before, config(), maxRank: -1).state, before);
    });

    test('the order it breaks things in does not depend on map order', () {
      // The server has to arrive at the same inventory from the same save.
      final one = salvageJunk(
        state(inventory: const {'i2': cap, 'i0': stick}),
        config(),
        maxRank: 0,
      );
      final other = salvageJunk(
        state(inventory: const {'i0': stick, 'i2': cap}),
        config(),
        maxRank: 0,
      );

      expect(one.state.inventory.keys, other.state.inventory.keys);
      expect(one.gained, other.gained);
    });
  });

  group('config validation', () {
    test('refuses a payout for a rarity that does not exist', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "salvage": {"yields": {"mythic": {"gold": "1e0"}}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a level curve that pays less for an upgraded item', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "salvage": {"levelMultiplier": 0.5} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a negative payout', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"common": {}},
  "salvage": {"yields": {"common": {"gold": "-1e0"}}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
