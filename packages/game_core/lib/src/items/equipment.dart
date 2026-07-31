import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/balance/slot_config.dart';
import 'package:game_core/src/battle/combat_stats.dart';
import 'package:game_core/src/items/item_config.dart';
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
  final base = config.hero.statsFor(unitsOwned: units);
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
