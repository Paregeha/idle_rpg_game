import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/items/equipment.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Why an item was not broken down.
enum SalvageRefusal { unknownItem, equipped, nothingToGive }

/// What breaking items down produced.
@immutable
class SalvageResult {
  const SalvageResult({
    required this.state,
    this.broken = 0,
    this.gained = const {},
    this.refusal,
  });

  final PlayerState state;

  /// How many items were destroyed.
  final int broken;

  /// Resources paid, summed across everything broken.
  ///
  /// Returned so the screen can name what was gained. Gear that disappears
  /// without a word is how a player concludes the game ate their things.
  final Map<String, BigNum> gained;

  final SalvageRefusal? refusal;

  bool get salvaged => broken > 0;
}

/// Breaks one item down.
///
/// An equipped item is refused rather than quietly unequipped: stripping a slot
/// as a side effect is how a player finds out from a weaker hero instead of
/// from the game.
SalvageResult salvageItem(
  PlayerState state,
  String itemId,
  BalanceConfig config,
) {
  final owned = state.inventory[itemId];
  final item = owned == null ? null : config.items[owned.configId];
  if (owned == null || item == null) {
    return SalvageResult(state: state, refusal: SalvageRefusal.unknownItem);
  }
  if (state.equipped.containsValue(itemId)) {
    return SalvageResult(state: state, refusal: SalvageRefusal.equipped);
  }

  final payout = config.salvage.payoutFor(
    rarity: item.rarity,
    level: owned.level,
  );
  if (payout.isEmpty) {
    return SalvageResult(state: state, refusal: SalvageRefusal.nothingToGive);
  }

  final inventory = Map<String, OwnedItem>.of(state.inventory)..remove(itemId);

  return SalvageResult(
    state: state.copyWith(
      inventory: inventory,
      resources: _credit(state.resources, payout),
    ),
    broken: 1,
    gained: payout,
  );
}

/// Breaks down every unequipped item of rank [maxRank] or below.
///
/// Spare copies of something the hero is wearing are kept: those are what item
/// upgrades eat, and a salvage pass that ate them would quietly close the
/// upgrade path the player is saving for.
SalvageResult salvageJunk(
  PlayerState state,
  BalanceConfig config, {
  required int maxRank,
}) {
  if (maxRank < 0) return SalvageResult(state: state);

  final worn = state.equipped.values.toSet();
  final wornConfigIds = {
    for (final id in worn)
      if (state.inventory[id] != null) state.inventory[id]!.configId,
  };

  final doomed = <String>[];
  final gained = <String, BigNum>{};

  // Sorted, so the same save always breaks the same items in the same order —
  // the server has to arrive at the same inventory (`T-032`).
  final ids = state.inventory.keys.toList()..sort();

  for (final id in ids) {
    if (worn.contains(id)) continue;

    final owned = state.inventory[id]!;
    final item = config.items[owned.configId];
    if (item == null) continue;
    if (wornConfigIds.contains(owned.configId)) continue;

    final rank = config.rarities[item.rarity]?.rank ?? 0;
    if (rank > maxRank) continue;

    final payout = config.salvage.payoutFor(
      rarity: item.rarity,
      level: owned.level,
    );
    if (payout.isEmpty) continue;

    doomed.add(id);
    for (final entry in payout.entries) {
      gained[entry.key] = (gained[entry.key] ?? BigNum.zero) + entry.value;
    }
  }

  if (doomed.isEmpty) return SalvageResult(state: state);

  final inventory = Map<String, OwnedItem>.of(state.inventory);
  doomed.forEach(inventory.remove);

  return SalvageResult(
    state: state.copyWith(
      inventory: inventory,
      resources: _credit(state.resources, gained),
    ),
    broken: doomed.length,
    gained: gained,
  );
}

Map<String, BigNum> _credit(
  Map<String, BigNum> resources,
  Map<String, BigNum> payout,
) {
  final next = Map<String, BigNum>.of(resources);
  for (final entry in payout.entries) {
    next[entry.key] = (next[entry.key] ?? BigNum.zero) + entry.value;
  }
  return next;
}

/// Wears [itemId] and sells whatever came off.
///
/// One item of each kind, always. The replaced one cannot go back to the bag —
/// the bag holds decisions, not gear — and it cannot quietly vanish either, so
/// it is broken down and paid for.
///
/// Equipping and selling are one call because they have to happen together: if
/// only the first landed, the old item would sit in the bag having been
/// promised as sold.
SalvageResult equipAndSell(
  PlayerState state,
  String itemId,
  BalanceConfig config, {
  String? intoSlot,
}) {
  final result = equipItem(state, itemId, config, intoSlot: intoSlot);
  if (!result.equipped) return SalvageResult(state: state);

  final replaced = result.replaced;
  if (replaced == null) return SalvageResult(state: result.state);

  return salvageItem(result.state, replaced, config);
}
