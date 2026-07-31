import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'salvage_config.freezed.dart';
part 'salvage_config.g.dart';

/// What breaking an item down pays.
@freezed
abstract class SalvageConfig with _$SalvageConfig {
  const factory SalvageConfig({
    /// Resources paid per rarity key: `rarity -> resource -> amount`.
    ///
    /// A map rather than a fixed pair of numbers, because what salvage pays is
    /// a balance decision: today gold and scrap, tomorrow whatever crafting
    /// turns out to need.
    @BigNumConverter()
    @Default(<String, Map<String, BigNum>>{})
    Map<String, Map<String, BigNum>> yields,

    /// Multiplier per level the item had reached, compounding.
    ///
    /// Levels cost duplicates and gold, so an upgraded item that paid the same
    /// as a fresh one would make upgrading anything a trap.
    @Default(1.5) double levelMultiplier,
  }) = _SalvageConfig;

  const SalvageConfig._();

  factory SalvageConfig.fromJson(Map<String, dynamic> json) =>
      _$SalvageConfigFromJson(json);

  /// What one item of [rarity] at [level] pays.
  Map<String, BigNum> payoutFor({required String rarity, required int level}) {
    final base = yields[rarity];
    if (base == null || base.isEmpty) return const {};

    var scale = BigNum.one;
    for (var i = 0; i < level; i++) {
      scale *= BigNum.fromDouble(levelMultiplier);
    }

    return {
      for (final entry in base.entries) entry.key: entry.value * scale,
    };
  }
}
