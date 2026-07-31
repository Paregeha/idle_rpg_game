@TestOn('vm')
library;

import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/data/save_database.dart';
import 'package:idle_rpg/data/save_repository.dart';

PlayerState sample() => PlayerState(
  lastTickAtMs: 1770000000000,
  rngSeed: 20260731,
  carryOverMs: 640,
  resources: {'gold': BigNum(1.5, 42), 'gems': BigNum(4, 2)},
  generators: const {'miner': GeneratorState(level: 3, owned: 27)},
  upgrades: const {'pickaxe': 2},
  earnedThisRun: {'gold': BigNum(9.9, 43)},
  prestige: PrestigeState(
    currency: BigNum.fromDouble(37),
    resets: 4,
    permanentUpgrades: const {'greed': 2},
  ),
);

void main() {
  late SaveDatabase db;
  late SaveRepository repo;

  setUp(() async {
    db = SaveDatabase(NativeDatabase.memory());
    repo = SaveRepository(db);
    await repo.initialise();
  });

  tearDown(() => db.close());

  group('round trip', () {
    test('a cold start restores the state exactly', () async {
      final original = sample();

      await repo.save(original, nowMs: 1);
      final restored = await repo.load();

      expect(restored, isNotNull);
      expect(restored!.state, original);
      expect(restored.state.toJson(), original.toJson());
    });

    test('survives magnitudes a double could not hold', () async {
      final huge = sample().copyWith(
        resources: {'gold': BigNum(1.23456789, 4000)},
      );

      await repo.save(huge, nowMs: 1);

      expect(
        (await repo.load())!.state.resources['gold'],
        BigNum(1.23456789, 4000),
      );
    });

    test('no save yet reads as nothing, not as an error', () async {
      expect(await repo.load(), isNull);
    });

    test('the newest save wins', () async {
      await repo.save(sample(), nowMs: 10);
      await repo.save(sample().copyWith(rngSeed: 999), nowMs: 20);

      expect((await repo.load())!.state.rngSeed, 999);
    });
  });

  group('durability', () {
    test('writes alternate between two slots', () async {
      // The point of alternating: a save never overwrites the row it might
      // have to fall back to.
      await repo.save(sample(), nowMs: 10);
      await repo.save(sample().copyWith(rngSeed: 2), nowMs: 20);

      final rows = await db
          .customSelect('SELECT slot FROM saves ORDER BY slot')
          .get();

      expect(rows.map((r) => r.read<int>('slot')), [0, 1]);
    });

    test('a damaged newest slot falls back to the older one', () async {
      await repo.save(sample(), nowMs: 10);
      await repo.save(sample().copyWith(rngSeed: 999), nowMs: 20);

      // Simulate a write torn off halfway by a kill.
      await db.customStatement(
        "UPDATE saves SET payload = '{\"lastTickAtMs\": 1, ' "
        'WHERE saved_at_ms = 20',
      );

      final restored = await repo.load();

      expect(restored, isNotNull, reason: 'the older slot is still good');
      expect(restored!.state.rngSeed, sample().rngSeed);
    });

    test('both slots damaged reads as no save, not as a crash', () async {
      await repo.save(sample(), nowMs: 10);
      await repo.save(sample(), nowMs: 20);
      await db.customStatement("UPDATE saves SET payload = 'rubbish'");

      expect(await repo.load(), isNull);
    });

    test('a payload that is valid JSON but not a state is refused', () async {
      await repo.save(sample(), nowMs: 10);
      await db.customStatement("UPDATE saves SET payload = '[1, 2, 3]'");

      expect(await repo.load(), isNull);
    });

    test('the stored payload is the state, not something lossy', () async {
      await repo.save(sample(), nowMs: 1);

      final row = await db
          .customSelect('SELECT payload FROM saves LIMIT 1')
          .getSingle();
      final decoded = jsonDecode(row.read<String>('payload'));

      expect(decoded, isA<Map<String, dynamic>>());
      expect(
        (decoded as Map<String, dynamic>)['resources'],
        isA<Map<String, dynamic>>(),
      );
    });

    test('clear wipes both slots', () async {
      await repo.save(sample(), nowMs: 10);
      await repo.save(sample(), nowMs: 20);

      await repo.clear();

      expect(await repo.load(), isNull);
    });
  });
}
