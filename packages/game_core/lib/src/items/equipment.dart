import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/balance/slot_config.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/items/item_config.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Outcome of an equip attempt.
@immutable
class EquipResult {
  const EquipResult({
    required this.state,
    required this.equipped,
    this.replaced,
  });

  final PlayerState state;

  /// Whether the item was actually put on.
  final bool equipped;

  /// The item that was already in the slot, now back in the inventory.
  ///
  /// Named so the UI can say what was swapped out rather than leaving the
  /// player to notice a stat change and work it out.
  final String? replaced;
}

/// Puts the item with [itemId] into its slot.
///
/// A slot holds one item; equipping into an occupied slot returns the previous
/// one to the inventory rather than destroying it.
///
/// Refuses — rather than throws — when the item is not in the inventory or its
/// config is unknown. Both are ordinary outcomes of a stale client: the player
/// may have upgraded away the item on another device, and the server will reach
/// the same conclusion when it validates the intent (`T-032`).
EquipResult equipItem(
  PlayerState state,
  String itemId,
  BalanceConfig config, {
  String? intoSlot,
}) {
  final owned = state.inventory[itemId];
  if (owned == null) {
    return EquipResult(state: state, equipped: false);
  }

  final item = config.items[owned.configId];
  if (item == null) {
    return EquipResult(state: state, equipped: false);
  }

  final slot = _slotFor(state, config, item.slot, intoSlot);
  if (slot == null) {
    return EquipResult(state: state, equipped: false);
  }

  if (state.equipped[slot.id] == itemId) {
    // Already worn: not a failure, just nothing to do.
    return EquipResult(state: state, equipped: true);
  }

  // Wearing it elsewhere already (ring1 when asked for ring2) has to vacate
  // the old slot, or one item would be counted twice.
  final equipped = Map<String, String>.of(state.equipped)
    ..removeWhere((_, worn) => worn == itemId)
    ..[slot.id] = itemId;

  return EquipResult(
    state: state.copyWith(equipped: equipped),
    equipped: true,
    replaced: state.equipped[slot.id],
  );
}

/// Picks which slot an item of [kind] should go into.
///
/// With two slots of the same kind, an empty one is preferred: asking to wear
/// a second ring should fill the free finger rather than replace the first.
SlotConfig? _slotFor(
  PlayerState state,
  BalanceConfig config,
  String kind,
  String? requested,
) {
  final candidates = config.slots
      .where((slot) => slot.itemKind == kind)
      .toList();
  if (candidates.isEmpty) return null;

  if (requested != null) {
    for (final slot in candidates) {
      if (slot.id == requested) return slot;
    }
    return null;
  }

  for (final slot in candidates) {
    if (!state.equipped.containsKey(slot.id)) return slot;
  }
  return candidates.first;
}

/// Takes whatever is in [slot] off.
///
/// The item stays in the inventory — nothing is destroyed by unequipping.
PlayerState unequipSlot(PlayerState state, String slot) {
  if (!state.equipped.containsKey(slot)) return state;

  final remaining = Map<String, String>.of(state.equipped)..remove(slot);
  return state.copyWith(equipped: remaining);
}

/// Combined stats of everything currently worn.
///
/// Silently skips slots holding an item the config no longer knows, so a
/// balance update that removes an item degrades the hero rather than crashing
/// the game for everyone who owned it.
ItemStats equippedStats(PlayerState state, BalanceConfig config) {
  var total = ItemStats.empty;

  for (final itemId in state.equipped.values) {
    final owned = state.inventory[itemId];
    if (owned == null) continue;

    final item = config.items[owned.configId];
    final rarity = config.rarities[item?.rarity];
    if (item == null || rarity == null) continue;

    total += item.statsAt(level: owned.level, rarity: rarity);
  }

  return total;
}

/// The hero's stats for a fight: progression plus equipment.
///
/// This is the one place that answers "how strong is the hero right now", so
/// the battle screen, the hero screen and the server all agree by construction
/// rather than by three implementations happening to match.
CombatStats heroCombatStats(PlayerState state, BalanceConfig config) {
  final units = state.generators.values.fold(
    0,
    (sum, generator) => sum + generator.owned,
  );
  final base = config.hero.statsFor(
    unitsOwned: units,
    level: state.heroLevel,
  );
  final gear = equippedStats(state, config);

  return base.copyWith(
    attack:
        (base.attack + gear.flatAttack) *
        BigNum.fromDouble(gear.attackMultiplier),
    maxHp: (base.maxHp + gear.flatHp) * BigNum.fromDouble(gear.hpMultiplier),
    // Probabilities are summed then clamped: three trinkets at 0.4 dodge each
    // would otherwise make the hero untouchable, which is not a build but a
    // broken fight.
    critChance: (base.critChance + gear.critChance).clamp(0.0, 1.0),
    critFactor: base.critFactor + gear.critFactor,
    dodgeChance: (base.dodgeChance + gear.dodgeChance).clamp(0.0, 0.75),
    mitigation: (base.mitigation + gear.mitigation).clamp(0.0, 0.9),
    attacksPerSecond: base.attacksPerSecond + gear.attacksPerSecond,
  );
}

/// How much an item is worth to the hero, as one number.
///
/// Attack plus a fraction of health plus what a multiplier is worth, so a
/// defensive item still counts for something. It is a comparison handle, not a
/// formula the fight uses — the fight reads the real stats.
///
/// Ranked by what the item actually contributes, never by rarity: an upgraded
/// common can beat a fresh epic, and sorting by rarity would quietly hand the
/// player the worse item.
double itemWorth(OwnedItem owned, BalanceConfig config) {
  final item = config.items[owned.configId];
  final rarity = config.rarities[item?.rarity];
  if (item == null || rarity == null) return -1;

  final stats = item.statsAt(level: owned.level, rarity: rarity);
  return stats.flatAttack.toDouble() +
      stats.flatHp.toDouble() * 0.2 +
      (stats.attackMultiplier - 1) * 500 +
      (stats.hpMultiplier - 1) * 100;
}

/// Whether wearing [itemId] would beat whatever is in its slot now.
///
/// Compares the items rather than simulating the hero twice: this is asked for
/// every cell in a bag that can hold fifty of them, on a screen that rebuilds
/// with the game clock.
///
/// An item already being worn is never an upgrade over itself.
bool isUpgrade(PlayerState state, String itemId, BalanceConfig config) {
  final owned = state.inventory[itemId];
  final item = owned == null ? null : config.items[owned.configId];
  if (owned == null || item == null) return false;
  if (state.equipped.containsValue(itemId)) return false;

  final worth = itemWorth(owned, config);

  // Against the weakest slot of the right kind: with two rings on, the one
  // worth replacing is the worse of them.
  double? weakest;
  var hasSlot = false;
  for (final slot in config.slots) {
    if (slot.itemKind != item.slot) continue;
    hasSlot = true;

    final wornId = state.equipped[slot.id];
    if (wornId == null) return true;

    final worn = state.inventory[wornId];
    final wornWorth = worn == null ? -1.0 : itemWorth(worn, config);
    if (weakest == null || wornWorth < weakest) weakest = wornWorth;
  }

  if (!hasSlot) return false;
  return worth > (weakest ?? -1);
}

/// Whether the bag holds something better than what [slotId] is wearing.
bool hasUpgradeFor(PlayerState state, String slotId, BalanceConfig config) {
  for (final entry in state.inventory.entries) {
    final item = config.items[entry.value.configId];
    if (item == null) continue;

    final slot = config.slots.where((s) => s.id == slotId);
    if (slot.isEmpty || slot.first.itemKind != item.slot) continue;
    if (isUpgrade(state, entry.key, config)) return true;
  }
  return false;
}

/// Items sitting in the bag with no decision made about them.
///
/// The bag is not storage: everything is either on the hero or sold. What is
/// left here is a pull the player walked away from, and the lamp will ask
/// about it before handing out another.
///
/// Sorted, so the same save always asks in the same order — the server has to
/// reach the same inventory (`T-032`).
List<String> pendingItems(PlayerState state) {
  final worn = state.equipped.values.toSet();
  return state.inventory.keys.where((id) => !worn.contains(id)).toList()
    ..sort();
}

/// One number standing in for how strong the hero is.
///
/// Attack plus a fraction of health, so a defensive item still moves it. A
/// comparison handle, not a formula the game uses for anything — the fight
/// reads the real stats.
BigNum heroPower(PlayerState state, BalanceConfig config) {
  final stats = heroCombatStats(state, config);
  return stats.attack + stats.maxHp * BigNum.fromDouble(0.2);
}
