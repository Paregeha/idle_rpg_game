import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/state/generator_state.dart';
import 'package:game_core/src/state/player_state.dart';

/// Builds the state of a brand new player from the balance config.
///
/// The starting loadout is a balance decision, not a code one: a player who
/// begins with nothing and no income can never afford the first generator, and
/// which generator opens the economy is exactly the sort of number that gets
/// retuned. The balance simulator found this the hard way — every profile sat
/// at zero forever until the config granted a starting generator.
///
/// [nowMs] must be server time, and [rngSeed] must be assigned by the server
/// too, so a player cannot reroll their luck by restarting.
PlayerState newGame({
  required int nowMs,
  required int rngSeed,
  required BalanceConfig config,
}) {
  return PlayerState(
    lastTickAtMs: nowMs,
    rngSeed: rngSeed,
    resources: Map.of(config.start.resources),
    generators: {
      for (final entry in config.start.generators.entries)
        entry.key: GeneratorState(owned: entry.value),
    },
  );
}
