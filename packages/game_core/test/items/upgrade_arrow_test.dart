import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => BalanceConfig(
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'ring1', accepts: 'ring'),
    SlotConfig(id: 'ring2', accepts: 'ring'),
  ],
  rarities: const {'common': RarityConfig(), 'epic': RarityConfig(rank: 2)},
  items: {
    'stick': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(10)),
    ),
    'blade': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(50)),
    ),
    'plate': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      stats: ItemStats(flatHp: BigNum.fromDouble(500)),
    ),
    'band': ItemConfig(
      slot: 'ring',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(5)),
    ),
    'signet': ItemConfig(
      slot: 'ring',
      rarity: 'common',
      stats: ItemStats(flatAttack: BigNum.fromDouble(20)),
    ),
  },
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

void main() {
  test('anything is an upgrade over an empty slot', () {
    final result = isUpgrade(
      state(
        inventory: const {'i0': OwnedItem(id: 'i0', configId: 'stick')},
      ),
      'i0',
      config(),
    );

    expect(result, isTrue);
  });

  test('a stronger item beats the one being worn', () {
    final current = state(
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'stick'),
        'i1': OwnedItem(id: 'i1', configId: 'blade'),
      },
      equipped: const {'weapon': 'i0'},
    );

    expect(isUpgrade(current, 'i1', config()), isTrue);
    expect(isUpgrade(current, 'i0', config()), isFalse);
  });

  test('a weaker one does not', () {
    final current = state(
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'blade'),
        'i1': OwnedItem(id: 'i1', configId: 'stick'),
      },
      equipped: const {'weapon': 'i0'},
    );

    expect(isUpgrade(current, 'i1', config()), isFalse);
  });

  test('health counts, so a defensive item can be an upgrade', () {
    // Judging by attack alone would mark armour as never worth wearing.
    final current = state(
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'stick'),
        'i1': OwnedItem(id: 'i1', configId: 'plate'),
      },
      equipped: const {'weapon': 'i0'},
    );

    expect(isUpgrade(current, 'i1', config()), isTrue);
  });

  test('an upgraded common can beat a fresh better item', () {
    // Ranked by what it contributes, never by rarity.
    final current = state(
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'stick', level: 20),
        'i1': OwnedItem(id: 'i1', configId: 'blade'),
      },
      equipped: const {'weapon': 'i0'},
    );

    expect(isUpgrade(current, 'i1', config()), isFalse);
  });

  test('what is already worn is never an upgrade over itself', () {
    final current = state(
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
      equipped: const {'weapon': 'i0'},
    );

    expect(isUpgrade(current, 'i0', config()), isFalse);
  });

  test('with two rings on it is judged against the worse one', () {
    // The finger worth replacing is the weaker one, so an item between the
    // two is still an upgrade.
    final current = state(
      inventory: const {
        'i0': OwnedItem(id: 'i0', configId: 'band'),
        'i1': OwnedItem(id: 'i1', configId: 'signet'),
        'i2': OwnedItem(id: 'i2', configId: 'band', level: 3),
      },
      equipped: const {'ring1': 'i0', 'ring2': 'i1'},
    );

    expect(isUpgrade(current, 'i2', config()), isTrue);
  });

  test('an item no slot accepts is never an upgrade', () {
    final orphan = config().copyWith(slots: const [SlotConfig(id: 'helm')]);
    final current = state(
      inventory: const {'i0': OwnedItem(id: 'i0', configId: 'blade')},
    );

    expect(isUpgrade(current, 'i0', orphan), isFalse);
  });

  group('a slot knows when the bag holds better', () {
    test('says so when it does', () {
      final current = state(
        inventory: const {
          'i0': OwnedItem(id: 'i0', configId: 'stick'),
          'i1': OwnedItem(id: 'i1', configId: 'blade'),
        },
        equipped: const {'weapon': 'i0'},
      );

      expect(hasUpgradeFor(current, 'weapon', config()), isTrue);
    });

    test('and stays quiet when it does not', () {
      final current = state(
        inventory: const {
          'i0': OwnedItem(id: 'i0', configId: 'blade'),
          'i1': OwnedItem(id: 'i1', configId: 'stick'),
        },
        equipped: const {'weapon': 'i0'},
      );

      expect(hasUpgradeFor(current, 'weapon', config()), isFalse);
    });

    test('items for other slots do not light it up', () {
      final current = state(
        inventory: const {'i0': OwnedItem(id: 'i0', configId: 'signet')},
      );

      expect(hasUpgradeFor(current, 'weapon', config()), isFalse);
      expect(hasUpgradeFor(current, 'ring1', config()), isTrue);
    });
  });
}
