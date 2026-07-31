import 'package:game_core/game_core.dart';
import 'package:test/test.dart';

PlayerState sample() => PlayerState(
  lastTickAtMs: 1770000000000,
  rngSeed: 20260730,
  resources: {'gold': BigNum(1.5, 12), 'gems': BigNum(4, 2)},
  generators: {
    'miner': const GeneratorState(level: 12, owned: 40),
    'smelter': const GeneratorState(level: 3, owned: 2),
  },
  upgrades: {'pickaxe': 3, 'cart': 1},
  prestige: PrestigeState(
    currency: BigNum(9.87, 5),
    resets: 3,
    permanentUpgrades: const {'greed': 2},
  ),
);

void main() {
  group('PlayerState', () {
    test('carries every field the simulation needs', () {
      final s = sample();

      expect(s.lastTickAtMs, 1770000000000);
      expect(s.rngSeed, 20260730);
      expect(s.resources['gold'], BigNum(1.5, 12));
      expect(s.generators['miner']!.level, 12);
      expect(s.upgrades['pickaxe'], 3);
      expect(s.prestige.resets, 3);
    });

    test('version defaults to the current schema version', () {
      expect(sample().version, stateSchemaVersion);
    });

    test('version can be pinned to an older schema', () {
      expect(sample().copyWith(version: 0).version, 0);
    });

    test('copyWith leaves the original untouched', () {
      final original = sample();
      final changed = original.copyWith(rngSeed: 1);

      expect(changed.rngSeed, 1);
      expect(original.rngSeed, 20260730, reason: 'state must never mutate');
      expect(changed.resources, original.resources);
    });

    test('equality is structural', () {
      expect(sample(), sample());
      expect(sample().hashCode, sample().hashCode);
      expect(sample(), isNot(sample().copyWith(rngSeed: 99)));
    });

    test('a fresh state starts empty but valid', () {
      const fresh = PlayerState(lastTickAtMs: 0, rngSeed: 7);

      expect(fresh.resources, isEmpty);
      expect(fresh.generators, isEmpty);
      expect(fresh.upgrades, isEmpty);
      expect(fresh.prestige, const PrestigeState());
      expect(fresh.version, stateSchemaVersion);
    });
  });

  group('json round-trip', () {
    test('restores an identical state', () {
      final original = sample();

      final restored = PlayerState.fromJson(original.toJson());

      expect(restored, original);
    });

    test('survives a magnitude no double could hold', () {
      final original = sample().copyWith(
        resources: {'gold': BigNum(1.23456789, 4000)},
      );

      final restored = PlayerState.fromJson(original.toJson());

      expect(restored.resources['gold'], BigNum(1.23456789, 4000));
      expect(restored, original);
    });

    test('BigNum is stored as a string, not a lossy number', () {
      final json = sample().toJson();

      expect((json['resources']! as Map)['gold'], isA<String>());
    });

    test('version travels with the state', () {
      final json = sample().copyWith(version: 0).toJson();

      expect(json['version'], 0);
      expect(PlayerState.fromJson(json).version, 0);
    });

    test('nested models round-trip too', () {
      final restored = PlayerState.fromJson(sample().toJson());

      expect(
        restored.generators['smelter'],
        const GeneratorState(level: 3, owned: 2),
      );
      expect(restored.prestige.currency, BigNum(9.87, 5));
    });
  });

  group('nested models', () {
    test('GeneratorState round-trips', () {
      const g = GeneratorState(level: 5, owned: 9);

      expect(GeneratorState.fromJson(g.toJson()), g);
      expect(g.copyWith(level: 6).level, 6);
      expect(g.level, 5);
    });

    test('PrestigeState round-trips and defaults to empty', () {
      const empty = PrestigeState();

      expect(empty.currency, BigNum.zero);
      expect(empty.resets, 0);
      expect(empty.permanentUpgrades, isEmpty);
      expect(PrestigeState.fromJson(empty.toJson()), empty);
    });
  });
}
