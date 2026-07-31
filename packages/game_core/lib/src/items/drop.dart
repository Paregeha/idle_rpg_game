import 'package:game_core/src/balance/balance_config.dart';
import 'package:game_core/src/balance/monster_config.dart';
import 'package:game_core/src/items/lamp.dart';
import 'package:game_core/src/items/owned_item.dart';
import 'package:game_core/src/state/player_state.dart';
import 'package:meta/meta.dart';

/// What a kill produced.
@immutable
class DropResult {
  const DropResult({required this.state, this.item});

  final PlayerState state;

  /// The item that dropped, or null if nothing did.
  final OwnedItem? item;

  bool get dropped => item != null;
}

/// Rolls a monster's drop after a kill.
///
/// Shares the item-minting path with the lamp, so an item found in a fight and
/// an item pulled from the lamp are the same kind of thing, with ids from the
/// same counter. Two ways to create items would be two places for their ids to
/// collide.
///
/// Uses the RNG carried in the state, so the server reaches the same verdict
/// from the same save (`T-032`) — a client-rolled drop would be trivial to
/// fake.
DropResult rollDrop(
  PlayerState state,
  MonsterConfig monster,
  BalanceConfig config,
) {
  final droppable = config.items.entries
      .where((entry) => entry.value.sources.contains(lampSource))
      .toList();
  if (monster.dropChance <= 0 || droppable.isEmpty) {
    return DropResult(state: state);
  }

  final rng = state.random();
  if (rng.nextDouble() >= monster.dropChance) {
    // The roll still consumed a draw, so the state advances either way —
    // otherwise a losing roll would replay forever from the same position.
    return DropResult(state: state.copyWith(rngState: rng.state));
  }

  final drawn = droppable[rng.nextInt(droppable.length)];
  final id = 'item-${state.itemsCreated}';

  return DropResult(
    state: state.copyWith(
      inventory: {
        ...state.inventory,
        id: OwnedItem(id: id, configId: drawn.key),
      },
      itemsCreated: state.itemsCreated + 1,
      rngState: rng.state,
    ),
    item: OwnedItem(id: id, configId: drawn.key),
  );
}
