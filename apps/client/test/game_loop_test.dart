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

ProviderContainer makeContainer(FakeClock clock) {
  final db = SaveDatabase(NativeDatabase.memory());
  addTearDown(db.close);

  final container = ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(clock),
      balanceConfigProvider.overrideWith((ref) async => _config),
      // Backgrounding writes a save, so even the loop tests need somewhere to
      // write it.
      saveDatabaseProvider.overrideWithValue(db),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Future<GameController> bootedController(ProviderContainer container) async {
  await container.read(balanceConfigProvider.future);
  final controller = container.read(gameControllerProvider.notifier)..load();
  return controller;
}

void main() {
  group('the loop', () {
    test('a new game starts from the balance config', () async {
      final clock = FakeClock(1770000000000);
      final controller = await bootedController(makeContainer(clock));

      expect(controller.state!.generators['miner']!.owned, 1);
      expect(controller.state!.lastTickAtMs, 1770000000000);
    });

    test('ticking accrues progress', () async {
      final clock = FakeClock(0);
      final controller = await bootedController(makeContainer(clock));

      clock.advance(const Duration(seconds: 5));
      controller.tick();

      expect(controller.state!.resources['gold'], BigNum.fromDouble(5));
    });

    test('credits the time that actually passed, not the nominal tick', () {
      // A busy main thread makes a timer fire late. Crediting a flat 33 ms
      // would quietly lose the difference and drift behind the server.
      final clock = FakeClock(0);
      final container = makeContainer(clock);

      return bootedController(container).then((controller) {
        clock.advance(const Duration(milliseconds: 500));
        controller.tick();
        clock.advance(const Duration(milliseconds: 500));
        controller.tick();

        expect(controller.state!.resources['gold'], BigNum.one);
      });
    });

    test('a tick with no elapsed time changes nothing', () async {
      final clock = FakeClock(0);
      final controller = await bootedController(makeContainer(clock));
      clock.advance(const Duration(seconds: 2));
      controller.tick();
      final after = controller.state;

      controller.tick();

      expect(controller.state, same(after));
    });

    test('many small ticks equal one big one', () async {
      final clockA = FakeClock(0);
      final stepped = await bootedController(makeContainer(clockA));
      for (var i = 0; i < 300; i++) {
        clockA.advance(tickInterval);
        stepped.tick();
      }

      final clockB = FakeClock(0);
      final atOnce = await bootedController(makeContainer(clockB));
      clockB.advance(tickInterval * 300);
      atOnce.tick();

      expect(stepped.state!.resources['gold'], atOnce.state!.resources['gold']);
    });
  });

  group('battery', () {
    test('going to the background stops the ticker', () async {
      final clock = FakeClock(0);
      final controller = await bootedController(makeContainer(clock))
        ..startTicking();
      expect(controller.isTicking, isTrue);

      await controller.onPaused();

      expect(
        controller.isTicking,
        isFalse,
        reason: 'a 30 Hz timer behind a locked screen is pure battery drain',
      );
    });

    test('coming back credits the gap through the offline path', () async {
      final clock = FakeClock(0);
      final controller = await bootedController(makeContainer(clock));
      await controller.onPaused();

      clock.advance(const Duration(hours: 3));
      final report = controller.onResumed();

      expect(report, isNotNull);
      expect(report!.creditedFor, const Duration(hours: 3));
      expect(
        controller.state!.resources['gold'],
        BigNum.fromDouble(const Duration(hours: 3).inSeconds.toDouble()),
      );
      expect(controller.isTicking, isTrue);
    });

    test('a long absence is capped, not ticked through', () async {
      final clock = FakeClock(0);
      final controller = await bootedController(makeContainer(clock));
      await controller.onPaused();

      clock.advance(const Duration(days: 2));
      final report = controller.onResumed();

      expect(report!.wasCapped, isTrue);
      expect(report.creditedFor, const Duration(hours: 8));
    });
  });

  group('rebuild scope', () {
    test(
      'a resource provider only changes when its own number moves',
      () async {
        final clock = FakeClock(0);
        final container = makeContainer(clock);
        final controller = await bootedController(container);

        var goldChanges = 0;
        var gemChanges = 0;
        container.listen(resourceProvider('gold'), (_, _) => goldChanges++);
        container.listen(resourceProvider('gems'), (_, _) => gemChanges++);

        clock.advance(const Duration(seconds: 3));
        controller.tick();
        // Riverpod delivers changes on the next microtask.
        await Future<void>.delayed(Duration.zero);

        expect(goldChanges, 1);
        expect(
          gemChanges,
          0,
          reason: 'nothing produces gems, so its counter must not rebuild',
        );
      },
    );
  });
}
