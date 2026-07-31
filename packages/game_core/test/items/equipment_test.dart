import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'trinket'),
  ],
  rarities: const {
    'common': RarityConfig(),
    'epic': RarityConfig(statMultiplier: 5, rank: 2),
  },
  items: {
    'blade': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(10)),
    ),
    'greatsword': ItemConfig(
      slot: 'weapon',
      rarity: 'epic',
      stats: ItemStats(
        flatAttack: BigNum.fromDouble(40),
        attackMultiplier: 1.2,
      ),
    ),
    'ring': const ItemConfig(
      slot: 'trinket',
      rarity: 'common',
      stats: ItemStats(critChance: 0.05, dodgeChance: 0.4),
    ),
  },
  hero: HeroConfig(
    baseAttack: BigNum.fromDouble(100),
    baseHp: BigNum.fromDouble(500),
    perUnitMultiplier: 1,
    dodgeChance: 0.5,
  ),
);

PlayerState state({Map<String, OwnedItem>? inventory}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  inventory:
      inventory ??
      const {
        'i1': OwnedItem(id: 'i1', configId: 'blade'),
        'i2': OwnedItem(id: 'i2', configId: 'greatsword'),
        'i3': OwnedItem(id: 'i3', configId: 'ring'),
      },
);

void main() {
  group('equipping', () {
    test('puts an item in its slot', () {
      final result = equipItem(state(), 'i1', config());

      expect(result.equipped, isTrue);
      expect(result.state.equipped['weapon'], 'i1');
      expect(result.replaced, isNull);
    });

    test('one item per slot, and the old one comes back', () {
      final first = equipItem(state(), 'i1', config()).state;

      final second = equipItem(first, 'i2', config());

      expect(second.state.equipped['weapon'], 'i2');
      expect(second.replaced, 'i1');
      expect(
        second.state.inventory.containsKey('i1'),
        isTrue,
        reason: 'swapping must never eat the item that came off',
      );
    });

    test('items in different slots coexist', () {
      var current = equipItem(state(), 'i1', config()).state;
      current = equipItem(current, 'i3', config()).state;

      expect(current.equipped, {'weapon': 'i1', 'trinket': 'i3'});
    });

    test('equipping what is already worn is a no-op, not a failure', () {
      final first = equipItem(state(), 'i1', config()).state;

      final again = equipItem(first, 'i1', config());

      expect(again.equipped, isTrue);
      expect(again.state, first);
    });

    test('refuses an item the player does not own', () {
      // A stale client, or a device that upgraded the item away. The server
      // will reach the same conclusion, so this is a refusal and not a throw.
      final result = equipItem(state(), 'nothing', config());

      expect(result.equipped, isFalse);
      expect(result.state, state());
    });

    test('refuses an item whose config was removed by a balance update', () {
      final orphan = state(
        inventory: const {'i9': OwnedItem(id: 'i9', configId: 'deleted')},
      );

      expect(equipItem(orphan, 'i9', config()).equipped, isFalse);
    });

    test('is pure', () {
      final before = state();
      final snapshot = before.toJson();

      equipItem(before, 'i1', config());

      expect(before.toJson(), snapshot);
    });
  });

  group('unequipping', () {
    test('empties the slot but keeps the item', () {
      final worn = equipItem(state(), 'i1', config()).state;

      final bare = unequipSlot(worn, 'weapon');

      expect(bare.equipped, isEmpty);
      expect(bare.inventory.containsKey('i1'), isTrue);
    });

    test('an empty slot is left alone', () {
      final before = state();

      expect(unequipSlot(before, 'weapon'), before);
    });
  });

  group('what the gear is worth', () {
    test('nothing worn is no bonus', () {
      expect(equippedStats(state(), config()), ItemStats.empty);
    });

    test('adds up across slots', () {
      var current = equipItem(state(), 'i1', config()).state;
      current = equipItem(current, 'i3', config()).state;

      final gear = equippedStats(current, config());

      expect(gear.flatAttack, BigNum.fromDouble(10));
      expect(gear.critChance, closeTo(0.05, 1e-9));
    });

    test('rarity is applied', () {
      final worn = equipItem(state(), 'i2', config()).state;

      // 40 flat at 5x epic
      expect(equippedStats(worn, config()).flatAttack, BigNum.fromDouble(200));
    });

    test('an item the config forgot is skipped, not fatal', () {
      // A balance update that removes an item must degrade the hero, not crash
      // the game for everyone who owned it.
      final broken = state().copyWith(
        inventory: const {'i9': OwnedItem(id: 'i9', configId: 'deleted')},
        equipped: const {'weapon': 'i9'},
      );

      expect(equippedStats(broken, config()), ItemStats.empty);
    });
  });

  group('hero stats', () {
    test('gear raises attack', () {
      final bare = heroCombatStats(state(), config());
      final armed = heroCombatStats(
        equipItem(state(), 'i1', config()).state,
        config(),
      );

      expect(armed.attack, BigNum.fromDouble(110));
      expect(bare.attack, BigNum.fromDouble(100));
    });

    test('flat and percentage stack in the right order', () {
      // The multiplier applies after the flat bonus, or a late-game percentage
      // item would be worth almost nothing.
      //
      // Epic scales both parts: 40 flat becomes 200, and x1.2 becomes x2.0
      // (the +0.2 bonus scaled fivefold, per T-080). So (100 + 200) * 2.
      final armed = heroCombatStats(
        equipItem(state(), 'i2', config()).state,
        config(),
      );

      // Compared with a tolerance because 1.2 - 1 is 0.19999... in a double,
      // so the scaled multiplier lands a hair under 2.
      expect(armed.attack.toDouble(), closeTo(600, 1e-6));
    });

    test('dodge is clamped so a build cannot become untouchable', () {
      // Hero 0.5 plus a 0.4 trinket would be 0.9: a fight nobody can win or
      // lose is not a build, it is a stalemate.
      final armed = heroCombatStats(
        equipItem(state(), 'i3', config()).state,
        config(),
      );

      expect(armed.dodgeChance, 0.75);
    });

    test('the same numbers come out of one function everywhere', () {
      // Battle screen, hero screen and the server all call this, so they agree
      // by construction rather than by three implementations matching.
      final worn = equipItem(state(), 'i2', config()).state;

      expect(heroCombatStats(worn, config()), heroCombatStats(worn, config()));
    });
  });

  group('persistence', () {
    test('inventory and equipment round-trip', () {
      final worn = equipItem(state(), 'i2', config()).state.copyWith(
        inventory: {
          'i2': const OwnedItem(id: 'i2', configId: 'greatsword', level: 7),
        },
      );

      final restored = PlayerState.fromJson(worn.toJson());

      expect(restored, worn);
      expect(restored.inventory['i2']!.level, 7);
      expect(restored.equipped['weapon'], 'i2');
    });
  });
}
