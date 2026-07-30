import 'package:freezed_annotation/freezed_annotation.dart';

part 'owned_item.freezed.dart';
part 'owned_item.g.dart';

/// One physical copy of an item the player owns.
///
/// Separate from `ItemConfig` because a player can own two of the same sword at
/// different upgrade levels, and equipping one must not equip the other. The
/// id is assigned when the item is created and never reused, so an intent can
/// name exactly which copy it means — which matters once the server is
/// validating those intents (`T-032`).
@freezed
abstract class OwnedItem with _$OwnedItem {
  const factory OwnedItem({
    /// Unique among this player's items.
    required String id,

    /// Key into `BalanceConfig.items`.
    required String configId,

    /// Upgrade level (`T-083`).
    @Default(0) int level,
  }) = _OwnedItem;

  factory OwnedItem.fromJson(Map<String, dynamic> json) =>
      _$OwnedItemFromJson(json);
}
