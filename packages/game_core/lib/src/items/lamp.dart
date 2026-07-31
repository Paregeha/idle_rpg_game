import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/items/crafting.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/random/seeded_random.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Source key marking an item as obtainable from the lamp.
const String lampSource = 'lamp';

/// Source key for items that only appear during an event.
///
/// Mounts and the unique set live here: an item the lamp could produce is one
/// the shop cannot meaningfully sell, and an event reward that drops freely is
/// not a reward.
const String eventSource = 'event';

/// Source key for items sold rather than found.
const String shopSource = 'shop';

/// Why an open did not happen.
enum LampRefusal { cannotAfford, noItemsConfigured }

/// Outcome of opening the lamp.
@immutable
class LampResult {
  const LampResult({
    required this.state,
    this.item,
    this.refusal,
    this.wasPity = false,
  });

  final PlayerState state;

  /// What was drawn, or null if the open was refused.
  final OwnedItem? item;

  final LampRefusal? refusal;

  /// Whether the pity counter forced this rarity.
  ///
  /// Surfaced so the UI can say so. A guarantee the player never sees is a
  /// guarantee they do not believe exists.
  final bool wasPity;

  bool get opened => item != null;
}

/// Opens the lamp once.
///
/// Randomness comes from the RNG state carried in [PlayerState], not from a
/// fresh generator: a lamp seeded only by `rngSeed` would hand out the same
/// item on every open, and one seeded by the clock could not be checked by the
/// server (`T-032`).
///
/// Everything about the draw — the rarity weights, the pity threshold, the
/// price — is config, so the economy can be retuned without a release.
LampResult openLamp(PlayerState state, BalanceConfig config) {
  final lamp = config.lamp;

  final balance = state.resources[lamp.costResource] ?? BigNum.zero;
  if (balance < lamp.costAmount) {
    return LampResult(state: state, refusal: LampRefusal.cannotAfford);
  }
  // Only items the config says the lamp can produce. Without this the lamp
  // hands out wings meant to be crafted and skins meant to be bought.
  final available = config.items.entries
      .where((entry) => entry.value.sources.contains(lampSource))
      .toList();
  if (available.isEmpty || lamp.totalWeight <= 0) {
    return LampResult(state: state, refusal: LampRefusal.noItemsConfigured);
  }

  final rng = state.random();

  final pityDue = lamp.hasPity && state.pityCounter >= lamp.pityThreshold - 1;
  final rarity = pityDue ? lamp.pityRarity : _drawRarity(rng, lamp.weights);

  // A rarity with no items behind it must not swallow the open: fall back to
  // anything rather than charging the player for nothing.
  final candidates = available
      .where((entry) => entry.value.rarity == rarity)
      .toList();
  final pool = candidates.isEmpty ? available : candidates;
  final drawn = pool[rng.nextInt(pool.length)];

  final gotPityRarity = drawn.value.rarity == lamp.pityRarity;

  final minted = mintItem(
    state.copyWith(
      resources: {
        ...state.resources,
        lamp.costResource: balance - lamp.costAmount,
      },
      pityCounter: gotPityRarity ? 0 : state.pityCounter + 1,
      rngState: rng.state,
    ),
    drawn.key,
  );

  return LampResult(
    state: minted.state,
    item: minted.item,
    wasPity: pityDue,
  );
}

/// Picks a rarity by weight.
String _drawRarity(SeededRandom rng, Map<String, double> weights) {
  final total = weights.values.fold<double>(0, (sum, w) => sum + w);
  var roll = rng.nextDouble() * total;

  for (final entry in weights.entries) {
    roll -= entry.value;
    if (roll < 0) return entry.key;
  }

  // Floating-point rounding can leave roll fractionally above zero on the last
  // entry; returning it is correct rather than falling through to nothing.
  return weights.keys.last;
}
