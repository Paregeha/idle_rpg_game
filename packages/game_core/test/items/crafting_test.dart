import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

BalanceConfig config({int unlockAtHeroLevel = 0}) => BalanceConfig(
  slots: const [SlotConfig(id: 'wings')],
  rarities: const {'legendary': RarityConfig(rank: 3)},
  items: const {
    'wings': ItemConfig(
      slot: 'wings',
      rarity: 'legendary',
      sources: ['craft'],
    ),
  },
  recipes: {
    'wings': RecipeConfig(
      produces: 'wings',
      unlockAtHeroLevel: unlockAtHeroLevel,
      costs: {
        'scrap': BigNum.fromDouble(100),
        'gold': BigNum.fromDouble(500),
      },
    ),
  },
);

PlayerState state({double scrap = 1000, double gold = 5000, int level = 50}) =>
    PlayerState(
      lastTickAtMs: 0,
      rngSeed: 1,
      heroLevel: level,
      resources: {
        'scrap': BigNum.fromDouble(scrap),
        'gold': BigNum.fromDouble(gold),
      },
    );

void main() {
  group('the forge', () {
    test('makes the item and charges every cost', () {
      final result = craft(state(), 'wings', config());

      expect(result.crafted, isTrue);
      expect(result.item!.configId, 'wings');
      expect(result.state.inventory, hasLength(1));
      expect(result.state.resources['scrap'], BigNum.fromDouble(900));
      expect(result.state.resources['gold'], BigNum.fromDouble(4500));
    });

    test('refuses when any one cost is short, and charges nothing', () {
      // Charging for the part it could afford would be taking payment for
      // something the player did not receive.
      final before = state(scrap: 10);
      final result = craft(before, 'wings', config());

      expect(result.refusal, CraftRefusal.cannotAfford);
      expect(result.state, before);
    });

    test('refuses below the hero level the recipe asks for', () {
      final result = craft(
        state(level: 5),
        'wings',
        config(unlockAtHeroLevel: 20),
      );

      expect(result.refusal, CraftRefusal.lockedByLevel);
    });

    test('refuses a recipe nothing defines', () {
      expect(
        craft(state(), 'nothing', config()).refusal,
        CraftRefusal.unknownRecipe,
      );
    });

    test('is pure', () {
      final before = state();
      final snapshot = before.toJson();

      craft(before, 'wings', config());

      expect(before.toJson(), snapshot);
    });

    test('what it makes can actually be worn', () {
      final made = craft(state(), 'wings', config()).state;
      final id = made.inventory.keys.single;

      expect(equipItem(made, id, config()).equipped, isTrue);
    });
  });

  group('minting', () {
    test('ids come from the counter, not from chance', () {
      // The server has to arrive at the same ids from the same state.
      final first = mintItem(state(), 'wings');
      final second = mintItem(first.state, 'wings');

      expect(first.item.id, 'item-0');
      expect(second.item.id, 'item-1');
      expect(second.state.itemsCreated, 2);
    });

    test('the forge, the lamp and a kill share one counter', () {
      // Three ways to create an item would be three places for their ids to
      // collide.
      final crafted = craft(state(), 'wings', config()).state;
      final next = mintItem(crafted, 'wings');

      expect(next.item.id, 'item-1');
      expect(next.state.inventory.keys, ['item-0', 'item-1']);
    });
  });

  group('config validation', () {
    test('refuses a recipe that makes an item nothing defines', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "recipes": {"x": {"produces": "ghost", "costs": {"a": "1e0"}}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a recipe that costs nothing', () {
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"c": {}},
  "slots": [{"id": "wings"}],
  "items": {"w": {"slot": "wings", "rarity": "c"}},
  "recipes": {"x": {"produces": "w"}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses a craft-only item no recipe makes', () {
      // Otherwise the slot it fills can never be filled at all.
      expect(
        () => BalanceConfig.parse('''
{ "version": 1, "rarities": {"c": {}},
  "slots": [{"id": "wings"}],
  "items": {"w": {"slot": "wings", "rarity": "c", "sources": ["craft"]}} }
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
