import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

/// Subtracting the level cost from banked experience is not exact across
/// magnitudes in a double mantissa.
Matcher nearly(double expected) => predicate<BigNum>((actual) {
  if (expected == 0) return actual.isZero;
  final target = BigNum.fromDouble(expected);
  return ((actual - target).abs() / target.abs()).toDouble() <= 1e-9;
}, 'within 1e-9 of $expected');

BalanceConfig config({double expGrowth = 2, double statPerLevel = 1.08}) =>
    BalanceConfig(
      hero: HeroConfig(
        baseAttack: BigNum.fromDouble(100),
        baseHp: BigNum.fromDouble(100),
        perUnitMultiplier: 1,
        expBase: BigNum.fromDouble(10),
        expGrowth: expGrowth,
        statPerLevel: statPerLevel,
      ),
    );

PlayerState state({int level = 0, double banked = 0}) => PlayerState(
  lastTickAtMs: 0,
  rngSeed: 1,
  heroLevel: level,
  heroExperience: BigNum.fromDouble(banked),
);

void main() {
  group('earning levels', () {
    test('experience below the requirement just banks', () {
      final result = grantExperience(state(), BigNum.fromDouble(4), config());

      expect(result.leveledUp, isFalse);
      expect(result.state.heroExperience, BigNum.fromDouble(4));
    });

    test('reaching the requirement levels up and keeps the remainder', () {
      final result = grantExperience(state(), BigNum.fromDouble(13), config());

      expect(result.levelsGained, 1);
      expect(result.state.heroLevel, 1);
      expect(result.state.heroExperience, nearly(3));
    });

    test('one big grant can clear several levels', () {
      // A player back from a long absence should not have to fight again to
      // collect levels they already earned.
      final result = grantExperience(state(), BigNum.fromDouble(70), config());

      expect(result.levelsGained, greaterThan(1));
      expect(result.state.heroLevel, result.levelsGained);
    });

    test('each level costs more than the last', () {
      final hero = config().hero;

      for (var level = 0; level < 30; level++) {
        expect(
          hero.expForLevel(level + 1) > hero.expForLevel(level),
          isTrue,
          reason: 'level $level',
        );
      }
    });

    test('zero or negative experience changes nothing', () {
      final before = state(banked: 5);

      expect(grantExperience(before, BigNum.zero, config()).state, before);
    });

    test('is pure', () {
      final before = state();
      final snapshot = before.toJson();

      grantExperience(before, BigNum.fromDouble(999), config());

      expect(before.toJson(), snapshot);
    });
  });

  group('what a level is worth', () {
    test('levels make the hero stronger', () {
      final novice = heroCombatStats(state(), config());
      final veteran = heroCombatStats(state(level: 10), config());

      expect(veteran.attack > novice.attack, isTrue);
      expect(veteran.maxHp > novice.maxHp, isTrue);
    });

    test('the gain compounds, not adds', () {
      // 1.08^10 on a base of 100.
      final veteran = heroCombatStats(state(level: 10), config());

      expect(veteran.attack.toDouble(), closeTo(215.89, 0.1));
    });
  });

  group('the progress bar', () {
    test('is zero on a fresh level and rises with experience', () {
      expect(levelProgress(state(), config()), 0);
      expect(levelProgress(state(banked: 5), config()), closeTo(0.5, 1e-9));
    });

    test('never exceeds one', () {
      expect(levelProgress(state(banked: 999), config()), 1);
    });

    test('survives a requirement bigger than a double', () {
      final far = state(level: 400, banked: 1);

      expect(levelProgress(far, config()), inInclusiveRange(0, 1));
    });
  });

  group('config validation', () {
    test('refuses a curve that gets cheaper', () {
      expect(
        () => BalanceConfig.parse('{"version": 1, "hero": {"expGrowth": 0.9}}'),
        throwsA(isA<BalanceConfigException>()),
      );
    });

    test('refuses levels that weaken the hero', () {
      expect(
        () => BalanceConfig.parse(
          '{"version": 1, "hero": {"statPerLevel": 0.9}}',
        ),
        throwsA(isA<BalanceConfigException>()),
      );
    });
  });
}
