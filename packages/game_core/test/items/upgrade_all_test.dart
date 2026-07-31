import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'armour', order: 1),
    SlotConfig(id: 'wings', order: 2),
  ],
  rarities: const {'common': RarityConfig()},
  items: const {
    'blade': ItemConfig(slot: 'weapon', rarity: 'common'),
    'vest': ItemConfig(slot: 'armour', rarity: 'common'),
    'pinions': ItemConfig(slot: 'wings', rarity: 'common'),
  },
  itemUpgrade: ItemUpgradeConfig(
    costBase: BigNum.fromDouble(100),
    costGrowth: 2,
    costResourceByKind: const {'wings': 'crystals'},
    costBaseByKind: {'wings': BigNum.fromDouble(5)},
  ),
);

PlayerState state({double gold = 0, double crystals = 0}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  resources: {
    'gold': BigNum.fromDouble(gold),
    'crystals': BigNum.fromDouble(crystals),
  },
  inventory: const {
    'i0': OwnedItem(id: 'i0', configId: 'blade'),
    'i1': OwnedItem(id: 'i1', configId: 'vest'),
    'i2': OwnedItem(id: 'i2', configId: 'pinions'),
  },
  equipped: const {'weapon': 'i0', 'armour': 'i1', 'wings': 'i2'},
);

void main() {
  group('what a kind costs', () {
    test('gear is paid for in the usual resource', () {
      expect(config().itemUpgrade.costResourceFor('weapon'), 'gold');
      expect(
        config().itemUpgrade.costForKind('weapon', 0),
        BigNum.fromDouble(100),
      );
    });

    test('an outfit piece has its own resource and its own price', () {
      // A crystal price cannot sit on the gold curve — a hundred thousand
      // crystals is not a price, it is a wall.
      expect(config().itemUpgrade.costResourceFor('wings'), 'crystals');
      expect(
        config().itemUpgrade.costForKind('wings', 0),
        BigNum.fromDouble(5),
      );
    });

    test('upgrading takes it out of the right pocket', () {
      final result = upgradeItem(
        state(gold: 1000, crystals: 10),
        'i2',
        config(),
      );

      expect(result.upgraded, isTrue);
      expect(result.state.resources['crystals'], BigNum.fromDouble(5));
      expect(
        result.state.resources['gold'],
        BigNum.fromDouble(1000),
        reason: 'gold pays for gear, not for wings',
      );
    });

    test('gold does not buy an outfit piece', () {
      final result = upgradeItem(state(gold: 1000000000), 'i2', config());

      expect(result.refusal, UpgradeRefusal.cannotAfford);
    });
  });

  group('upgrading everything', () {
    test('spreads levels round the gear rather than one item', () {
      // 400 gold: a first pass lifts both to +1 for 100 each, and the second
      // affords one more at 200. Poured into the sword alone it would have
      // bought 100 + 200 and stopped, leaving the armour untouched.
      final result = upgradeAll(state(gold: 400), config());

      expect(result.levels, 3);
      expect(result.state.inventory['i0']!.level, 2);
      expect(result.state.inventory['i1']!.level, 1);
      expect(result.state.resources['gold'], BigNum.zero);
    });

    test('keeps going while the gold lasts', () {
      final result = upgradeAll(state(gold: 1000000), config());

      expect(result.levels, greaterThan(2));
      expect(
        (result.state.inventory['i0']!.level -
                result.state.inventory['i1']!.level)
            .abs(),
        lessThanOrEqualTo(1),
        reason: 'evenly stronger, not one enormous sword',
      );
    });

    test('never touches what crystals pay for', () {
      // Spending a premium currency is a decision, and a button that spends
      // it as a side effect is the kind of thing that gets refunded.
      final result = upgradeAll(
        state(gold: 1000000, crystals: 1000000),
        config(),
      );

      expect(result.state.inventory['i2']!.level, 0);
      expect(result.state.resources['crystals'], BigNum.fromDouble(1000000));
    });

    test('does nothing, and says so, when nothing can be paid for', () {
      final before = state();
      final result = upgradeAll(before, config());

      expect(result.levels, 0);
      expect(result.state, before);
    });

    test('leaves an empty slot alone', () {
      final bare = state(gold: 1000000).copyWith(equipped: const {});
      final result = upgradeAll(bare, config());

      expect(result.levels, 0);
    });

    test('is pure', () {
      final before = state(gold: 1000000);
      final snapshot = before.toJson();

      upgradeAll(before, config());

      expect(before.toJson(), snapshot);
    });
  });

  group('config validation', () {
    test('refuses a price for a kind no slot accepts', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "slots": [{"id": "weapon"}],
  "itemUpgrade": {"costResourceByKind": {"ghost": "gems"}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a base price of zero', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "slots": [{"id": "wings"}],
  "itemUpgrade": {"costBaseByKind": {"wings": "0e0"}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
