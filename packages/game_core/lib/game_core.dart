/// The single source of truth for the rules of the game.
///
/// This library is pure Dart on purpose: the Serverpod backend re-runs the very
/// same simulation the client does, which is what lets the server recompute any
/// player's progress without trusting a stream of client events.
library;

export 'src/math/big_num.dart';

/// Schema version of [/* PlayerState */] persisted state.
///
/// Bump this whenever the shape of the saved state changes, so migrations can
/// tell old saves apart. Kept here until `T-011` introduces the state models.
const int gameCoreStateVersion = 1;
