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
  final price = upgrade.costFor(owned.level);
  final balance = state.resources[upgrade.costResource] ?? BigNum.zero;
  if (balance < price) {
    return UpgradeResult(state: state, refusal: UpgradeRefusal.cannotAfford);
  }

  final worn = state.equipped.values.toSet();
  final duplicates = state.inventory.values
      .where(
        (other) =>
            other.id != itemId &&
            other.configId == owned.configId &&
            !worn.contains(other.id),
      )
      .take(upgrade.duplicatesPerLevel)
      .map((other) => other.id)
      .toList();

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
      resources: {
        ...state.resources,
        upgrade.costResource: balance - price,
      },
    ),
    item: upgraded,
    consumed: duplicates,
  );
}
