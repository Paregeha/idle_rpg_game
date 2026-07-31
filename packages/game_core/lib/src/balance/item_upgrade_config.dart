import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'item_upgrade_config.freezed.dart';
part 'item_upgrade_config.g.dart';

/// What upgrading an item costs.
@freezed
abstract class ItemUpgradeConfig with _$ItemUpgradeConfig {
  const factory ItemUpgradeConfig({
    /// Resource spent per level.
    @Default('gold') String costResource,

    /// Price of the first level.
    @BigNumConverter() @Default(BigNum.one) BigNum costBase,

    /// Price is multiplied by this per level already reached.
    @Default(1.6) double costGrowth,

    /// Resource a given item kind is paid for, when it is not [costResource].
    ///
    /// Wings, skins and mounts cost crystals rather than gold. Keeping that in
    /// data means "which of these is premium" is a balance decision, and the
    /// screens can work it out rather than being told twice.
    @Default(<String, String>{}) Map<String, String> costResourceByKind,

    /// First-level price for a kind that has its own resource.
    ///
    /// A crystal price cannot be on the gold curve — a hundred thousand
    /// crystals is not a price, it is a wall.
    @BigNumConverter()
    @Default(<String, BigNum>{})
    Map<String, BigNum> costBaseByKind,

    /// Spare copies consumed per level, on top of the resource cost.
    ///
    /// Zero means duplicates are not required — which keeps the lamp useful
    /// even for a player who never pulls the same item twice.
    @Default(0) int duplicatesPerLevel,
  }) = _ItemUpgradeConfig;

  const ItemUpgradeConfig._();

  factory ItemUpgradeConfig.fromJson(Map<String, dynamic> json) =>
      _$ItemUpgradeConfigFromJson(json);

  /// Cost of moving an item from [level] to `level + 1`.
  ///
  /// Formula: `costBase * costGrowth^level`.
  BigNum costFor(int level) => costForKind('', level);

  /// What resource [kind] is upgraded with.
  String costResourceFor(String kind) =>
      costResourceByKind[kind] ?? costResource;

  /// Whether [kind] is paid for in something other than the usual resource.
  ///
  /// The one thing that decides what an "upgrade everything" pass may touch:
  /// spending a premium currency is a decision, never a side effect of one
  /// button.
  bool isPremium(String kind) => costResourceByKind.containsKey(kind);

  /// Cost of moving an item of [kind] from [level] to `level + 1`.
  BigNum costForKind(String kind, int level) {
    if (level < 0) {
      throw ArgumentError.value(level, 'level', 'must not be negative');
    }

    final base = costBaseByKind[kind] ?? costBase;
    return base * BigNum.fromDouble(costGrowth).pow(level);
  }
}
