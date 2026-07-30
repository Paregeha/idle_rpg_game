/// The single source of truth for the rules of the game.
///
/// This library is pure Dart on purpose: the Serverpod backend re-runs the very
/// same simulation the client does, which is what lets the server recompute any
/// player's progress without trusting a stream of client events.
library;

export 'src/balance/balance_config.dart';
export 'src/balance/generator_config.dart';
export 'src/math/big_num.dart';
export 'src/random/seeded_random.dart';
export 'src/sim/sim_result.dart';
export 'src/sim/simulator.dart';
export 'src/state/big_num_converter.dart';
export 'src/state/generator_state.dart';
export 'src/state/hero_state.dart';
export 'src/state/player_state.dart';
export 'src/state/prestige_state.dart';
export 'src/time/clock.dart';
export 'src/time/system_clock.dart';

/// Schema version of [/* PlayerState */] persisted state.
///
/// Bump this whenever the shape of the saved state changes, so migrations can
/// tell old saves apart. Kept here until `T-011` introduces the state models.
const int gameCoreStateVersion = 1;
