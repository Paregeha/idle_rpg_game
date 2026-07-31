import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// Why the forge did not make something.
enum CraftRefusal { unknownRecipe, unknownItem, lockedByLevel, cannotAfford }

/// What the forge made.
@immutable
class CraftResult {
  const CraftResult({required this.state, this.item, this.refusal, this.spent});

  final PlayerState state;

  /// The item that came out, or null if the attempt was refused.
  final OwnedItem? item;

  final CraftRefusal? refusal;

  /// What it cost. Returned so the screen can say what was spent.
  final Map<String, BigNum>? spent;

  bool get crafted => item != null;
}

/// Makes one of whatever [recipeId] produces.
///
/// Crafting is the only way some slots are ever filled — wings are not in the
/// lamp and not in the shop — so a recipe that cannot be run is a slot the
/// player can never use.
CraftResult craft(PlayerState state, String recipeId, BalanceConfig config) {
  final recipe = config.recipes[recipeId];
  if (recipe == null) {
    return CraftResult(state: state, refusal: CraftRefusal.unknownRecipe);
  }
  if (!config.items.containsKey(recipe.produces)) {
    return CraftResult(state: state, refusal: CraftRefusal.unknownItem);
  }
  if (state.heroLevel < recipe.unlockAtHeroLevel) {
    return CraftResult(state: state, refusal: CraftRefusal.lockedByLevel);
  }

  for (final cost in recipe.costs.entries) {
    final held = state.resources[cost.key] ?? BigNum.zero;
    if (held < cost.value) {
      return CraftResult(state: state, refusal: CraftRefusal.cannotAfford);
    }
  }

  final resources = Map<String, BigNum>.of(state.resources);
  for (final cost in recipe.costs.entries) {
    resources[cost.key] = (resources[cost.key] ?? BigNum.zero) - cost.value;
  }

  final minted = mintItem(
    state.copyWith(resources: resources),
    recipe.produces,
  );

  return CraftResult(
    state: minted.state,
    item: minted.item,
    spent: recipe.costs,
  );
}

/// An item added to the bag, and the state that now holds it.
@immutable
class MintedItem {
  const MintedItem({required this.state, required this.item});

  final PlayerState state;
  final OwnedItem item;
}

/// Puts one new item of [configId] into the bag.
///
/// The single place items come into existence. The lamp, a kill and the forge
/// all mint through here, so an item found in a fight, pulled from the lamp and
/// made at the forge are the same kind of thing with ids from the same counter.
/// Three ways to create an item would be three places for their ids to collide.
///
/// The id comes from a counter rather than a clock or a random draw: the server
/// has to arrive at the same ids from the same state (`T-032`).
MintedItem mintItem(PlayerState state, String configId) {
  final id = 'item-${state.itemsCreated}';
  final item = OwnedItem(id: id, configId: configId);

  return MintedItem(
    state: state.copyWith(
      inventory: {...state.inventory, id: item},
      itemsCreated: state.itemsCreated + 1,
    ),
    item: item,
  );
}
