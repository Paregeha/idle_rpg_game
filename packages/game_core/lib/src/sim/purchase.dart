import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/generator_state.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Outcome of a purchase attempt.
@immutable
class PurchaseResult {
  const PurchaseResult({
    required this.state,
    required this.bought,
    required this.spent,
  });

  /// The state after the purchase, unchanged if nothing was bought.
  final PlayerState state;

  /// How many units were bought. Zero means the attempt was refused.
  final int bought;

  /// What it cost. Zero when nothing was bought.
  final BigNum spent;

  bool get succeeded => bought > 0;
}

/// How many more units of [generatorId] the player can afford right now.
///
/// Used for the x1 / x10 / max buttons (`T-025`) and by the balance simulator
/// to model a player who spends whatever they have.
int maxAffordable(
  PlayerState state,
  String generatorId,
  BalanceConfig config,
) {
  final generator = config.generators[generatorId];
  if (generator == null) return 0;

  final balance = state.resources[generator.produces] ?? BigNum.zero;
  if (balance <= BigNum.zero) return 0;

  final owned = state.generators[generatorId]?.owned ?? 0;

  // Costs grow geometrically, so the count grows only logarithmically with the
  // balance: doubling in a loop reaches the answer in a few dozen steps even
  // for a balance at 1e60, where counting one at a time would not.
  var low = 0;
  var high = 1;
  while (generator.bulkCost(owned: owned, count: high) <= balance) {
    low = high;
    high *= 2;
    if (high > 1 << 30) break;
  }

  while (low < high - 1) {
    final middle = low + (high - low) ~/ 2;
    if (generator.bulkCost(owned: owned, count: middle) <= balance) {
      low = middle;
    } else {
      high = middle;
    }
  }

  return low;
}

/// Buys [count] units of [generatorId].
///
/// This is the shape every player action takes: the client asks for an
/// *intent* and the rules decide whether it holds. The server runs this exact
/// function against its own state in `T-032`, which is why it must never
/// partially succeed — a client that asked for 3 and silently got 2 would show
/// the player something the server disagrees with.
///
/// Returns a refusal (`bought == 0`) rather than throwing when the player
/// cannot afford it: being unable to pay is an ordinary outcome, not an error.
PurchaseResult buyGenerator(
  PlayerState state,
  String generatorId,
  BalanceConfig config, {
  int count = 1,
}) {
  if (count <= 0) {
    throw ArgumentError.value(count, 'count', 'must be positive');
  }

  final generator = config.generators[generatorId];
  if (generator == null) {
    return PurchaseResult(state: state, bought: 0, spent: BigNum.zero);
  }

  final owned = state.generators[generatorId]?.owned ?? 0;
  final price = generator.bulkCost(owned: owned, count: count);
  final balance = state.resources[generator.produces] ?? BigNum.zero;

  if (price > balance) {
    return PurchaseResult(state: state, bought: 0, spent: BigNum.zero);
  }

  final resources = Map<String, BigNum>.of(state.resources)
    ..[generator.produces] = balance - price;
  final generators = Map<String, GeneratorState>.of(state.generators);
  final existing = generators[generatorId] ?? const GeneratorState();
  generators[generatorId] = existing.copyWith(owned: existing.owned + count);

  return PurchaseResult(
    state: state.copyWith(resources: resources, generators: generators),
    bought: count,
    spent: price,
  );
}
