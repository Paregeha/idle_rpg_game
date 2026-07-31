import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/random/seeded_random.dart';
import 'package:game_core/src/state/big_num_converter.dart';
import 'package:game_core/src/state/generator_state.dart';
import 'package:game_core/src/state/prestige_state.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

/// Schema version of the persisted [PlayerState].
///
/// Bump on every change to the saved shape, so a migration can tell an old save
/// apart from a current one. Saves in the wild outlive any given release.
const int stateSchemaVersion = 1;

/// Everything the simulation needs to recompute a player's progress.
///
/// This is the whole input to `simulate()`: given a state and elapsed time, the
/// result is fully determined, which is what lets the server recompute progress
/// without trusting the client (ADR-001). Nothing here may be derived from the
/// device — [lastTickAtMs] is UTC milliseconds handed down by the server, and
/// [rngSeed] travels with the state so any randomness replays identically.
@freezed
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    required int lastTickAtMs,
    required int rngSeed,
    @Default(stateSchemaVersion) int version,

    /// Milliseconds left over from the last tick that did not complete a whole
    /// simulation step.
    ///
    /// Progress is paid out in fixed one-second steps. Without carrying the
    /// remainder, a client ticking at 30 Hz would round away a fraction of
    /// every frame and drift measurably behind the server within a session.
    @Default(0) int carryOverMs,
    @BigNumConverter()
    @Default(<String, BigNum>{})
    Map<String, BigNum> resources,
    @Default(<String, GeneratorState>{}) Map<String, GeneratorState> generators,
    @Default(<String, int>{}) Map<String, int> upgrades,

    /// Everything earned since the last prestige reset, per resource.
    ///
    /// Tracked separately from [resources] because the prestige award is a
    /// function of what the run *produced*, not of what is left after spending
    /// it. Rewarding the balance on hand would punish the player for buying
    /// the upgrades the run exists to buy.
    @BigNumConverter()
    @Default(<String, BigNum>{})
    Map<String, BigNum> earnedThisRun,

    /// Chapter, stage and wave: where the player is in the world.
    @Default(1) int chapter,
    @Default(1) int stage,

    /// Waves cleared in this stage. At `wavesPerStage` the boss is next.
    @Default(0) int wave,

    /// Skill levels, by skill id.
    ///
    /// Reserved now and filled in with the skill system later. Adding a field
    /// to the save format is a JSON edit today and a database migration once
    /// the server owns this state.
    @Default(<String, int>{}) Map<String, int> skills,

    /// Every item the player owns, by its instance id.
    @Default(<String, OwnedItem>{}) Map<String, OwnedItem> inventory,

    /// Slot name to the instance id worn in it.
    ///
    /// Stored as slot -> item rather than a flag on the item so a slot can only
    /// ever hold one thing: the invariant is in the shape of the data instead
    /// of in code that has to remember to enforce it.
    @Default(<String, String>{}) Map<String, String> equipped,

    /// Live RNG state, so randomness resumes rather than restarting.
    ///
    /// Empty means "not drawn from yet"; the generator is then seeded from
    /// [rngSeed]. Storing only the seed would make every lamp open after a
    /// reload produce the same item.
    @Default(<int>[]) List<int> rngState,

    /// Items created so far, used to mint ids.
    ///
    /// A counter rather than a clock or a random value: the server has to
    /// arrive at the same ids from the same state (`T-032`).
    @Default(0) int itemsCreated,

    /// Opens since the pity rarity last dropped.
    @Default(0) int pityCounter,
    @Default(PrestigeState()) PrestigeState prestige,
  }) = _PlayerState;

  const PlayerState._();

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  /// A generator resumed from this state's RNG position.
  ///
  /// Callers must write [SeededRandom.state] back, or the next draw repeats
  /// this one.
  SeededRandom random() => rngState.isEmpty
      ? SeededRandom(rngSeed)
      : SeededRandom.fromState(rngState);
}
