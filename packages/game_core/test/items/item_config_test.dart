import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

const _common = RarityConfig();
const _epic = RarityConfig(statMultiplier: 5, rank: 2);

ItemConfig sword({double levelMultiplier = 1.12}) => ItemConfig(
  slot: 'weapon',
  rarity: 'common',
  levelMultiplier: levelMultiplier,
  stats: ItemStats(
    flatAttack: BigNum.fromDouble(10),
    attackMultiplier: 1.2,
    critChance: 0.05,
  ),
);

void main() {
  group('stats at a level and rarity', () {
    test('common level 0 is the item as written', () {
      final stats = sword().statsAt(level: 0, rarity: _common);

      expect(stats.flatAttack, BigNum.fromDouble(10));
      expect(stats.attackMultiplier, closeTo(1.2, 1e-9));
    });

    test('rarity scales the flat stats', () {
      final stats = sword().statsAt(level: 0, rarity: _epic);

      expect(stats.flatAttack, BigNum.fromDouble(50));
    });

    test('rarity scales the bonus part of a multiplier, not the whole', () {
      // x1.2 at 5x rarity must become x2.0 (the +0.2 scaled), not x6.0 —
      // multiplying the whole multiplier compounds absurdly by legendary.
      final stats = sword().statsAt(level: 0, rarity: _epic);

      expect(stats.attackMultiplier, closeTo(2.0, 1e-9));
    });

    test('probabilities are never scaled by rarity', () {
      // A 5x on a 0.05 crit chance would be fine; a 5x on 0.3 would produce a
      // chance above 1, which is not a better item but a broken one.
      const generous = ItemConfig(
        slot: 'trinket',
        rarity: 'epic',
        stats: ItemStats(critChance: 0.3, dodgeChance: 0.25),
      );

      final stats = generous.statsAt(level: 0, rarity: _epic);

      expect(stats.critChance, 0.3);
      expect(stats.dodgeChance, 0.25);
    });

    test('levels multiply on top of rarity', () {
      // 10 * 5 (epic) * 1.12^3
      final stats = sword().statsAt(level: 3, rarity: _epic);

      expect(stats.flatAttack.toDouble(), closeTo(50 * 1.404928, 1e-6));
    });

    test('each level is stronger than the last', () {
      var previous = BigNum.zero;

      for (var level = 0; level <= 20; level++) {
        final stats = sword().statsAt(level: level, rarity: _common);
        expect(stats.flatAttack > previous, isTrue, reason: 'level $level');
        previous = stats.flatAttack;
      }
    });

    test('a negative level is refused rather than silently clamped', () {
      expect(
        () => sword().statsAt(level: -1, rarity: _common),
        throwsArgumentError,
      );
    });
  });

  group('combining stats', () {
    test('flat stats add and multipliers multiply', () {
      const a = ItemStats(attackMultiplier: 1.2, critChance: 0.05);
      const b = ItemStats(attackMultiplier: 1.5, critChance: 0.03);

      final total = a + b;

      expect(total.attackMultiplier, closeTo(1.8, 1e-9));
      expect(total.critChance, closeTo(0.08, 1e-9));
    });

    test('an empty set changes nothing', () {
      const worn = ItemStats(attackMultiplier: 1.3, critChance: 0.1);

      final total = worn + ItemStats.empty;

      expect(total.attackMultiplier, closeTo(1.3, 1e-9));
      expect(total.critChance, closeTo(0.1, 1e-9));
    });

    test('big flat stats survive their own magnitude', () {
      final huge = ItemStats(flatAttack: BigNum(5, 60));

      expect((huge + huge).flatAttack, BigNum(1, 61));
    });
  });

  group('config validation', () {
    String json(String items, {String slots = '[{"id": "weapon"}]'}) =>
        '''
{
  "version": 1,
  "slots": $slots,
  "rarities": { "common": { "statMultiplier": 1.0, "rank": 0 } },
  "items": $items
}
''';

    void expectRejected(String source, String field) {
      expect(
        () => BalanceConfig.parse(source),
        throwsA(
          isA<BalanceConfigException>().having((e) => e.field, 'field', field),
        ),
      );
    }

    test('accepts a well-formed item', () {
      final config = BalanceConfig.parse(
        json('{ "blade": { "slot": "weapon", "rarity": "common" } }'),
      );

      expect(config.items['blade']!.slot, 'weapon');
      expect(config.slots.single.id, 'weapon');
    });

    test('refuses an item in a slot that does not exist', () {
      // Otherwise the item exists, drops, and can never be worn.
      expectRejected(
        json('{ "ghost": { "slot": "tail", "rarity": "common" } }'),
        'items.ghost.slot',
      );
    });

    test('refuses an unknown rarity', () {
      expectRejected(
        json('{ "blade": { "slot": "weapon", "rarity": "mythic" } }'),
        'items.blade.rarity',
      );
    });

    test('refuses negative stats', () {
      expectRejected(
        json(
          '{ "cursed": { "slot": "weapon", "rarity": "common", '
          '"stats": { "flatAttack": "-5e0" } } }',
        ),
        'items.cursed.stats',
      );
    });

    test('refuses an upgrade curve that weakens the item', () {
      expectRejected(
        json(
          '{ "blade": { "slot": "weapon", "rarity": "common", '
          '"levelMultiplier": 0.9 } }',
        ),
        'items.blade.levelMultiplier',
      );
    });

    test('refuses an impossible probability', () {
      expectRejected(
        json(
          '{ "blade": { "slot": "weapon", "rarity": "common", '
          '"stats": { "critChance": 1.5 } } }',
        ),
        'items.blade.stats.critChance',
      );
    });

    test('refuses a worthless rarity', () {
      expect(
        () => BalanceConfig.parse('''
{
  "version": 1,
  "slots": [{"id": "weapon"}],
  "rarities": { "junk": { "statMultiplier": 0 } },
  "items": {}
}
'''),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
