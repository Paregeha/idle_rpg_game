import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Why an upgrade did not happen.
enum UpgradeRefusal {
  unknownItem,
  alreadyMaxLevel,
  cannotAfford,
  notEnoughDuplicates,
}

/// Outcome of an upgrade attempt.
@immutable
class UpgradeResult {
  const UpgradeResult({
    required this.state,
    this.item,
    this.refusal,
    this.consumed = const [],
  });

  final PlayerState state;

  /// The item at its new level, or null if the attempt was refused.
  final OwnedItem? item;

  final UpgradeRefusal? refusal;

  /// Ids of the duplicates that were consumed.
  ///
  /// Returned so the UI can say what was spent. Items disappearing without a
  /// word is how a player concludes the game ate their gear.
  final List<String> consumed;

  bool get upgraded => item != null;
}

/// Raises every gear item one level at a time, in slot order, while the
/// player can pay.
///
/// Round-robin rather than pouring everything into the first item: "upgrade
/// everything" should leave the hero evenly stronger, not with one enormous
/// sword. A pass that upgrades nothing ends it.
///
/// Kinds paid for in a premium currency are never touched. Spending crystals
/// is a decision, and a button that spends them as a side effect is the kind
/// of thing that gets refunded.
UpgradeAllResult upgradeAll(PlayerState state, BalanceConfig config) {
  final order = config.slots.toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  var current = state;
  var levels = 0;
  var again = true;

  while (again) {
    again = false;

    for (final slot in order) {
      if (config.itemUpgrade.isPremium(slot.itemKind)) continue;

      final wornId = current.equipped[slot.id];
      if (wornId == null) continue;

      final result = upgradeItem(current, wornId, config);
      if (!result.upgraded) continue;

      current = result.state;
      levels++;
      again = true;
    }
  }

  return UpgradeAllResult(state: current, levels: levels);
}

/// What an "upgrade everything" pass managed.
@immutable
class UpgradeAllResult {
  const UpgradeAllResult({required this.state, required this.levels});

  final PlayerState state;

  /// Levels gained across everything it touched.
  final int levels;
}

/// Spare copies of [itemId] an upgrade is allowed to eat.
///
/// Unequipped copies only, and never the item itself. The upgrade and the
/// screen that offers it both read this, so a card promising "2 spares" cannot
/// be refused by an upgrade that counted differently.
List<String> spareCopiesOf(PlayerState state, String itemId) {
  final owned = state.inventory[itemId];
  if (owned == null) return const [];

  final worn = state.equipped.values.toSet();
  return state.inventory.values
      .where(
        (other) =>
            other.id != itemId &&
            other.configId == owned.configId &&
            !worn.contains(other.id),
      )
      .map((other) => other.id)
      .toList();
}

/// Raises an item one level.
///
/// Duplicates are drawn from unequipped copies only. Eating the item the player
/// is wearing to upgrade another one would silently strip a slot, and they
/// would find out from a weaker hero rather than from the game.
UpgradeResult upgradeItem(
  PlayerState state,
  String itemId,
  BalanceConfig config,
) {
  final owned = state.inventory[itemId];
  final item = owned == null ? null : config.items[owned.configId];
  if (owned == null || item == null) {
    return UpgradeResult(state: state, refusal: UpgradeRefusal.unknownItem);
  }

  if (owned.level >= item.maxLevel) {
    return UpgradeResult(state: state, refusal: UpgradeRefusal.alreadyMaxLevel);
  }

  final upgrade = config.itemUpgrade;
  final resource = upgrade.costResourceFor(item.slot);
  final price = upgrade.costForKind(item.slot, owned.level);
  final balance = state.resources[resource] ?? BigNum.zero;
  if (balance < price) {
    return UpgradeResult(state: state, refusal: UpgradeRefusal.cannotAfford);
  }

  final duplicates = spareCopiesOf(
    state,
    itemId,
  ).take(upgrade.duplicatesPerLevel).toList();

  if (duplicates.length < upgrade.duplicatesPerLevel) {
    return UpgradeResult(
      state: state,
      refusal: UpgradeRefusal.notEnoughDuplicates,
    );
  }

  final inventory = Map<String, OwnedItem>.of(state.inventory);
  duplicates.forEach(inventory.remove);
  final upgraded = owned.copyWith(level: owned.level + 1);
  inventory[itemId] = upgraded;

  return UpgradeResult(
    state: state.copyWith(
      inventory: inventory,
      resources: {...state.resources, resource: balance - price},
    ),
    item: upgraded,
    consumed: duplicates,
  );
}
