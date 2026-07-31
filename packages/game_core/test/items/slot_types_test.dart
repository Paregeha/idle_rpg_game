import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => const BalanceConfig(
  slots: [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'ring1', accepts: 'ring'),
    SlotConfig(id: 'ring2', accepts: 'ring'),
  ],
  rarities: {'common': RarityConfig()},
  items: {
    'blade': ItemConfig(slot: 'weapon', rarity: 'common'),
    'band': ItemConfig(slot: 'ring', rarity: 'common', sources: ['shop']),
    'wings': ItemConfig(slot: 'weapon', rarity: 'common', sources: ['craft']),
  },
  lamp: LampConfig(weights: {'common': 1}),
);

PlayerState state() => const PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  inventory: {
    'r1': OwnedItem(id: 'r1', configId: 'band'),
    'r2': OwnedItem(id: 'r2', configId: 'band'),
    'w': OwnedItem(id: 'w', configId: 'blade'),
  },
);

void main() {
  group('two slots of the same kind', () {
    test('a second ring fills the free finger, not the first one', () {
      final first = equipItem(state(), 'r1', config()).state;

      final second = equipItem(first, 'r2', config());

      expect(second.state.equipped, {'ring1': 'r1', 'ring2': 'r2'});
      expect(second.replaced, isNull);
    });

    test('a specific slot can be asked for', () {
      final result = equipItem(state(), 'r1', config(), intoSlot: 'ring2');

      expect(result.state.equipped, {'ring2': 'r1'});
    });

    test('moving a worn ring to the other finger does not duplicate it', () {
      // Wearing one item in two slots would count its stats twice.
      final first = equipItem(state(), 'r1', config()).state;

      final moved = equipItem(first, 'r1', config(), intoSlot: 'ring2').state;

      expect(moved.equipped, {'ring2': 'r1'});
    });

    test('both full means the first is replaced', () {
      var current = equipItem(state(), 'r1', config()).state;
      current = equipItem(current, 'r2', config()).state;

      final third = equipItem(
        current.copyWith(
          inventory: {
            ...current.inventory,
            'r3': const OwnedItem(id: 'r3', configId: 'band'),
          },
        ),
        'r3',
        config(),
      );

      expect(third.state.equipped['ring1'], 'r3');
      expect(third.replaced, 'r1');
    });

    test('a slot that accepts nothing owned is refused', () {
      final orphan = state().copyWith(
        inventory: const {'x': OwnedItem(id: 'x', configId: 'unknown')},
      );

      expect(equipItem(orphan, 'x', config()).equipped, isFalse);
    });
  });

  group('sources', () {
    test('the lamp only gives what it is allowed to give', () {
      // Without this the first pull can hand over the thing the shop sells.
      var current = state().copyWith(
        resources: {'gems': BigNum.fromDouble(80)},
      );

      for (var i = 0; i < 60; i++) {
        final result = openLamp(current, config());
        expect(result.opened, isTrue);
        expect(
          config().items[result.item!.configId]!.sources,
          contains('lamp'),
        );
        current = result.state;
      }
    });

    test('a config where nothing is lamp-sourced refuses the open', () {
      const shopOnly = BalanceConfig(
        slots: [SlotConfig(id: 'weapon')],
        rarities: {'common': RarityConfig()},
        items: {
          'only': ItemConfig(
            slot: 'weapon',
            rarity: 'common',
            sources: ['shop'],
          ),
        },
        lamp: LampConfig(weights: {'common': 1}),
      );

      final result = openLamp(
        state().copyWith(resources: {'gems': BigNum.fromDouble(10)}),
        shopOnly,
      );

      expect(result.refusal, LampRefusal.noItemsConfigured);
      expect(
        result.state.resources['gems'],
        BigNum.fromDouble(10),
        reason: 'and the player is not charged',
      );
    });

    test('drops respect sources too', () {
      const monster = MonsterConfig(
        baseHp: BigNum.one,
        hpGrowth: 1.5,
        rewardBase: BigNum.one,
        rewardGrowth: 1.4,
        dropChance: 1,
      );

      var current = state();
      for (var i = 0; i < 20; i++) {
        final result = rollDrop(current, monster, config());
        expect(
          config().items[result.item!.configId]!.sources,
          contains('lamp'),
        );
        current = result.state;
      }
    });
  });

  group('config validation', () {
    test('refuses duplicate slot ids', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "slots": [{"id": "ring"}, {"id": "ring"}]
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses an item no slot accepts', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "slots": [{"id": "weapon"}],
  "rarities": {"common": {"statMultiplier": 1}},
  "items": {"tail": {"slot": "tail", "rarity": "common"}}
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses an item with no source', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "slots": [{"id": "weapon"}],
  "rarities": {"common": {"statMultiplier": 1}},
  "items": {"ghost": {"slot": "weapon", "rarity": "common", "sources": []}}
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('a slot accepting a kind is enough for the item to be valid', () {
      final config = BalanceConfig.parse('''
{
  "version": 1,
  "slots": [{"id": "ring1", "accepts": "ring"}],
  "rarities": {"common": {"statMultiplier": 1}},
  "items": {"band": {"slot": "ring", "rarity": "common"}}
}
''');

      expect(config.slots.single.itemKind, 'ring');
    });
  });
}
