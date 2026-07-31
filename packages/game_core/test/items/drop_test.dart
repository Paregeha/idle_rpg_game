import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config() => const BalanceConfig(
  slots: [SlotConfig(id: 'weapon')],
  rarities: {'common': RarityConfig()},
  items: {
    'stick': ItemConfig(slot: 'weapon', rarity: 'common'),
    'blade': ItemConfig(slot: 'weapon', rarity: 'common'),
  },
);

MonsterConfig monster({double dropChance = 0.5}) => MonsterConfig(
  baseHp: BigNum.one,
  hpGrowth: 1.5,
  rewardBase: BigNum.one,
  rewardGrowth: 1.4,
  dropChance: dropChance,
);

PlayerState state({int seed = 42}) =>
    PlayerState(lastTickAtMs: 0, rngSeed: seed);

void main() {
  test('a monster that never drops produces nothing', () {
    final result = rollDrop(state(), monster(dropChance: 0), config());

    expect(result.dropped, isFalse);
    expect(result.state, state(), reason: 'not even the RNG should move');
  });

  test('a guaranteed drop always produces an item', () {
    final result = rollDrop(state(), monster(dropChance: 1), config());

    expect(result.dropped, isTrue);
    expect(result.state.inventory, hasLength(1));
  });

  test('drops land near the configured chance', () {
    var current = state();
    var drops = 0;

    for (var i = 0; i < 4000; i++) {
      final result = rollDrop(current, monster(dropChance: 0.25), config());
      current = result.state;
      if (result.dropped) drops++;
    }

    expect(drops / 4000, closeTo(0.25, 0.03));
  });

  test('a failed roll still advances the RNG', () {
    // Otherwise an unlucky roll would replay from the same position forever and
    // the player would never see a drop again.
    var current = state();
    var sawDrop = false;

    for (var i = 0; i < 60; i++) {
      final result = rollDrop(current, monster(dropChance: 0.2), config());
      current = result.state;
      if (result.dropped) sawDrop = true;
    }

    expect(sawDrop, isTrue);
  });

  test('ids continue the same counter the lamp uses', () {
    // One minting path, so a fight drop and a lamp pull can never collide.
    final fromLamp = openLamp(
      state().copyWith(resources: {'gems': BigNum.fromDouble(5)}),
      config().copyWith(
        lamp: const LampConfig(weights: {'common': 1}),
      ),
    ).state;

    final result = rollDrop(fromLamp, monster(dropChance: 1), config());

    expect(result.item!.id, 'item-1');
    expect(result.state.itemsCreated, 2);
  });

  test('the same state gives the same drop', () {
    final a = rollDrop(state(), monster(dropChance: 1), config());
    final b = rollDrop(state(), monster(dropChance: 1), config());

    expect(a.item!.configId, b.item!.configId);
  });

  test('is pure', () {
    final before = state();
    final snapshot = before.toJson();

    rollDrop(before, monster(dropChance: 1), config());

    expect(before.toJson(), snapshot);
  });
}
