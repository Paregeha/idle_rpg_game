import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/balance/monster_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// What a kill paid out.
@immutable
class DropResult {
  const DropResult({required this.state, this.lamps = BigNum.zero});

  final PlayerState state;

  /// Lamps the kill dropped. Zero when the roll missed.
  final BigNum lamps;

  bool get dropped => lamps > BigNum.zero;
}

/// Rolls a monster's drop after a kill.
///
/// Kills drop **lamps**, not gear. The lamp is where items come from, so a
/// kill that handed over an item directly would make the lamp — and the
/// currency it costs — beside the point.
///
/// This is also the only thing that pays lamps at all. Without it the lamp had
/// no source beyond the handful granted at the start, so a player who spent
/// them could never get another item as long as they played.
///
/// Uses the RNG carried in the state, so the server reaches the same verdict
/// from the same save (`T-032`) — a client-rolled drop would be trivial to
/// fake.
DropResult rollDrop(
  PlayerState state,
  MonsterConfig monster,
  BalanceConfig config,
) {
  if (monster.dropChance <= 0) return DropResult(state: state);

  final rng = state.random();
  if (rng.nextDouble() >= monster.dropChance) {
    // The roll still consumed a draw, so the state advances either way —
    // otherwise a losing roll would replay forever from the same position.
    return DropResult(state: state.copyWith(rngState: rng.state));
  }

  final resource = config.lamp.costResource;
  final held = state.resources[resource] ?? BigNum.zero;

  return DropResult(
    state: state.copyWith(
      resources: {...state.resources, resource: held + BigNum.one},
      rngState: rng.state,
    ),
    lamps: BigNum.one,
  );
}
