import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/sim/sim_result.dart';
import 'package:game_core/src/state/player_state.dart';

/// Length of one simulation step. Progress is only ever paid in whole steps.
const Duration simulationStep = Duration(seconds: 1);

/// Advances [state] by [dt] and returns the new state plus what was gained.
///
/// This one function serves the live client tick, the offline catch-up and the
/// server's authoritative recomputation. There is deliberately no second
/// implementation: a separate "fast path" for long spans is exactly how a
/// client and a server start disagreeing (ADR-001).
///
/// **Pure.** [state] is never mutated; the result is a new value.
///
/// **Fixed steps with carry-over.** Elapsed time is added to
/// `state.carryOverMs`, whole seconds are paid out, and the remainder is
/// carried. This is what makes many small ticks agree exactly with one large
/// one: a client running at 30 Hz would otherwise round away part of every
/// frame and drift behind the server within a session.
///
/// **Closed form, not iteration.** Generator output is linear in time, so a
/// span of any length costs one multiplication rather than one loop iteration
/// per second — thirty days would otherwise be 2.6 million steps. Iteration
/// becomes necessary only once a mechanic has a threshold inside the span (an
/// automatic level-up, say); there is none yet, and adding one means splitting
/// the span at the threshold rather than stepping through all of it.
///
/// Production per generator per second:
/// `baseRatePerSecond * owned * levelMultiplier^level`
SimResult simulate(PlayerState state, Duration dt, BalanceConfig config) {
  if (dt <= Duration.zero) {
    return SimResult(state: state, gains: const {}, stepsSimulated: 0);
  }

  final availableMs = state.carryOverMs + dt.inMilliseconds;
  final steps = availableMs ~/ simulationStep.inMilliseconds;
  final carryOverMs = availableMs % simulationStep.inMilliseconds;

  final gains = <String, BigNum>{};
  if (steps > 0) {
    final elapsedSeconds = BigNum.fromDouble(steps.toDouble());

    for (final entry in state.generators.entries) {
      final generator = config.generators[entry.key];
      // A generator with no config entry produces nothing. This happens when a
      // save predates a balance change that removed it; dropping the payout is
      // the conservative choice, and losing the save is not.
      if (generator == null) continue;

      // The formula lives on the config, not here: `simulator.dart` must stay
      // free of balance numbers so a change ships as data (rule 6).
      final ratePerSecond = generator.ratePerSecond(
        owned: entry.value.owned,
        level: entry.value.level,
      );
      if (ratePerSecond.isZero) continue;

      final produced = ratePerSecond * elapsedSeconds;
      if (produced.isZero) continue;

      gains[generator.produces] =
          (gains[generator.produces] ?? BigNum.zero) + produced;
    }
  }

  final resources = Map<String, BigNum>.of(state.resources);
  for (final gain in gains.entries) {
    resources[gain.key] = (resources[gain.key] ?? BigNum.zero) + gain.value;
  }

  return SimResult(
    state: state.copyWith(
      lastTickAtMs: state.lastTickAtMs + dt.inMilliseconds,
      carryOverMs: carryOverMs,
      resources: resources,
    ),
    gains: gains,
    stepsSimulated: steps,
  );
}
