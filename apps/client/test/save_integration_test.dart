@TestOn('vm')
library;

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_core/game_core.dart';
import 'package:idle_rpg/data/save_database.dart';
import 'package:idle_rpg/data/save_providers.dart';
import 'package:idle_rpg/state/game_controller.dart';
import 'package:idle_rpg/state/game_providers.dart';

final _config = BalanceConfig(
  generators: const {
    'miner': GeneratorConfig(
      produces: 'gold',
      baseRatePerSecond: BigNum.one,
      costBase: BigNum.one,
      costGrowth: 1.07,
    ),
  },
  start: const StartConfig(generators: {'miner': 1}),
);

void main() {
  late SaveDatabase db;

  setUp(() => db = SaveDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  ProviderContainer container(FakeClock clock) {
    final c = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(clock),
        balanceConfigProvider.overrideWith((ref) async => _config),
        // The same in-memory database across both "runs", which is what makes
        // this a cold-start test rather than two unrelated games.
        saveDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<GameController> boot(ProviderContainer c) async {
    await c.read(balanceConfigProvider.future);
    final controller = c.read(gameControllerProvider.notifier);
    await controller.restore();
    return controller;
  }

  test('a first run with no save starts a fresh game', () async {
    final controller = await boot(container(FakeClock(0)));

    expect(controller.state!.generators['miner']!.owned, 1);
    expect(controller.state!.resources['gold'] ?? BigNum.zero, BigNum.zero);
  });

  test('progress survives a cold start', () async {
    final clock = FakeClock(0);
    final first = await boot(container(clock));
    clock.advance(const Duration(minutes: 5));
    first
      ..tick()
      ..stopTicking();
    await first.saveNow();
    final before = first.state!;

    // Second launch: a new container, the same database file.
    final second = await boot(container(clock));

    expect(second.state!.resources['gold'], before.resources['gold']);
    expect(second.state!.generators, before.generators);
    expect(second.state!.rngSeed, before.rngSeed);
  });

  test('time spent closed is credited on the next launch', () async {
    final clock = FakeClock(0);
    final first = await boot(container(clock));
    await first.saveNow();

    clock.advance(const Duration(hours: 2));
    final second = await boot(container(clock));

    expect(
      second.state!.resources['gold'],
      BigNum.fromDouble(const Duration(hours: 2).inSeconds.toDouble()),
    );
  });

  test('a long closure is capped like any other absence', () async {
    final clock = FakeClock(0);
    final first = await boot(container(clock));
    await first.saveNow();

    clock.advance(const Duration(days: 5));
    final second = await boot(container(clock));

    expect(
      second.state!.resources['gold'],
      BigNum.fromDouble(const Duration(hours: 8).inSeconds.toDouble()),
    );
  });

  test('backgrounding writes a save even before the timer fires', () async {
    // The app may be killed while backgrounded and never get another chance.
    final clock = FakeClock(0);
    final c = container(clock);
    final controller = await boot(c);
    clock.advance(const Duration(minutes: 1));
    controller.tick();

    await controller.onPaused();

    final saved = await c.read(saveRepositoryProvider).load();
    expect(saved, isNotNull);
    expect(saved!.state.resources['gold'], BigNum.fromDouble(60));
  });

  test('backgrounding stops the autosave timer too', () async {
    final controller = await boot(container(FakeClock(0)))
      ..startAutosave();
    expect(controller.isAutosaving, isTrue);

    await controller.onPaused();

    expect(controller.isAutosaving, isFalse);
  });

  test(
    'an unreadable save starts a fresh game rather than refusing to boot',
    () async {
      final clock = FakeClock(0);
      final first = await boot(container(clock));
      await first.saveNow();
      await db.customStatement("UPDATE saves SET payload = 'not json'");

      final second = await boot(container(clock));

      expect(second.state, isNotNull, reason: 'the game must still start');
      expect(second.state!.generators['miner']!.owned, 1);
    },
  );
}
