import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'lamp_config.freezed.dart';
part 'lamp_config.g.dart';

/// The lamp: what it costs and what it gives.
@freezed
abstract class LampConfig with _$LampConfig {
  const factory LampConfig({
    /// Resource spent per open.
    @Default('gems') String costResource,

    @BigNumConverter() @Default(BigNum.one) BigNum costAmount,

    /// Relative weights per rarity key. Not probabilities — weights, so adding
    /// a rarity does not require rebalancing every other number by hand.
    @Default(<String, double>{}) Map<String, double> weights,

    /// Opens without the pity rarity before it is guaranteed.
    ///
    /// Zero disables pity. A run of bad luck long enough to feel unfair is the
    /// most common reason players quit a gacha, and it costs nothing to bound
    /// it — the guarantee is cheaper than the churn.
    @Default(0) int pityThreshold,

    /// Rarity the pity counter guarantees.
    @Default('') String pityRarity,
  }) = _LampConfig;

  const LampConfig._();

  factory LampConfig.fromJson(Map<String, dynamic> json) =>
      _$LampConfigFromJson(json);

  bool get hasPity => pityThreshold > 0 && pityRarity.isNotEmpty;

  double get totalWeight =>
      weights.values.fold(0, (sum, weight) => sum + weight);
}
