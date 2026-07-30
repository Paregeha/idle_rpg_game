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
  BigNum costFor(int level) {
    if (level < 0) {
      throw ArgumentError.value(level, 'level', 'must not be negative');
    }
    return costBase * BigNum.fromDouble(costGrowth).pow(level);
  }
}
