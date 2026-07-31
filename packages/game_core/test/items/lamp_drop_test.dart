import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config({String costResource = 'lamps'}) =>
    BalanceConfig(lamp: LampConfig(costResource: costResource));

MonsterConfig monster({double dropChance = 0}) => MonsterConfig(
  baseHp: BigNum.one,
  hpGrowth: 1.5,
  rewardBase: BigNum.one,
  rewardGrowth: 1.4,
  dropChance: dropChance,
);

PlayerState state() => const PlayerState(lastTickAtMs: 0, rngSeed: 5);

void main() {
  test('a chance of zero never pays', () {
    final before = state();

    expect(rollDrop(before, monster(), config()).state, before);
  });

  test('a certain drop pays a lamp and no gear', () {
    final result = rollDrop(state(), monster(dropChance: 1), config());

    expect(result.dropped, isTrue);
    expect(result.state.resources['lamps'], BigNum.one);
    expect(result.state.inventory, isEmpty);
  });

  test('lamps add up across kills', () {
    var current = state();
    for (var i = 0; i < 5; i++) {
      current = rollDrop(current, monster(dropChance: 1), config()).state;
    }

    expect(current.resources['lamps'], BigNum.fromDouble(5));
  });

  test('it pays into whatever resource the lamp costs', () {
    // A drop paid in a currency the lamp does not take would be a reward the
    // player cannot spend on the thing it exists for.
    final result = rollDrop(
      state(),
      monster(dropChance: 1),
      config(costResource: 'gems'),
    );

    expect(result.state.resources['gems'], BigNum.one);
  });

  test('a losing roll still advances the random state', () {
    // Otherwise the same losing roll replays forever and the player never
    // sees a drop at all.
    final before = state();
    final result = rollDrop(before, monster(dropChance: 0.0001), config());

    expect(result.dropped, isFalse);
    expect(result.state.rngState, isNot(before.rngState));
  });

  test('the same seed drops the same way', () {
    final a = rollDrop(state(), monster(dropChance: 0.5), config());
    final b = rollDrop(state(), monster(dropChance: 0.5), config());

    expect(a.dropped, b.dropped);
    expect(a.state.rngState, b.state.rngState);
  });

  test('is pure', () {
    final before = state();
    final snapshot = before.toJson();

    rollDrop(before, monster(dropChance: 1), config());

    expect(before.toJson(), snapshot);
  });
}
