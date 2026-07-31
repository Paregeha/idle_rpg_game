import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config({int maxLevel = 20}) => BalanceConfig(
  slots: const [
    SlotConfig(id: 'weapon'),
    SlotConfig(id: 'armour', order: 1),
  ],
  rarities: const {'common': RarityConfig()},
  items: {
    'blade': ItemConfig(
      slot: 'weapon',
      rarity: 'common',
      maxLevel: maxLevel,
      levelMultiplier: 1.5,
      stats: ItemStats(flatAttack: BigNum.fromDouble(100)),
    ),
    'vest': ItemConfig(
      slot: 'armour',
      rarity: 'common',
      maxLevel: maxLevel,
      levelMultiplier: 1.5,
      stats: ItemStats(flatHp: BigNum.fromDouble(100)),
    ),
  },
);

PlayerState state({int bladeLevel = 0}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  inventory: {
    'i0': OwnedItem(id: 'i0', configId: 'blade', level: bladeLevel),
    'i1': const OwnedItem(id: 'i1', configId: 'vest'),
  },
  equipped: const {'weapon': 'i0', 'armour': 'i1'},
);

void main() {
  test('an upgrade is worth a positive share of the hero', () {
    final gain = upgradeGain(state(), 'i0', config());

    expect(gain, greaterThan(0));
    expect(gain, lessThan(1));
  });

  test('health counts, so armour is worth something too', () {
    // Judging by attack alone would report every defensive upgrade as free
    // of benefit, which is the sort of number that stops being read.
    expect(upgradeGain(state(), 'i1', config()), greaterThan(0));
  });

  test('it is answered even when the player cannot pay', () {
    // That is exactly when they want to know what they are saving towards.
    final broke = state().copyWith(resources: const {});

    expect(upgradeGain(broke, 'i0', config()), greaterThan(0));
  });

  test('a maxed item promises nothing', () {
    expect(upgradeGain(state(bladeLevel: 3), 'i0', config(maxLevel: 3)), 0);
  });

  test('an item that does not exist promises nothing', () {
    expect(upgradeGain(state(), 'ghost', config()), 0);
  });

  test('it matches what upgrading actually does', () {
    // A promised gain that disagrees with the result is worse than none.
    final before = heroPower(state(), config());
    final promised = upgradeGain(state(), 'i0', config());

    final after = heroPower(
      upgradeItem(
        state().copyWith(resources: {'gold': BigNum.fromDouble(1000000000)}),
        'i0',
        config(),
      ).state,
      config(),
    );

    final actual = ((after - before) / before).toDouble();
    expect((actual - promised).abs(), lessThan(1e-9));
  });
}
