import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'prestige_config.freezed.dart';
part 'prestige_config.g.dart';

/// Balance numbers for the prestige loop.
@freezed
abstract class PrestigeConfig with _$PrestigeConfig {
  const factory PrestigeConfig({
    /// Which resource's lifetime earnings decide the award.
    @Default('gold') String resource,

    /// Earnings below this award nothing.
    @BigNumConverter() @Default(BigNum.one) BigNum currencyBase,

    /// Exponent on the ratio. Below 1 it compresses runaway runs, which is
    /// what keeps a single very long run from being worth more than several
    /// deliberate ones.
    @Default(0.5) double currencyExponent,

    /// Production multiplier gained per point of prestige currency.
    @BigNumConverter() @Default(BigNum.zero) BigNum bonusPerPoint,
  }) = _PrestigeConfig;

  factory PrestigeConfig.fromJson(Map<String, dynamic> json) =>
      _$PrestigeConfigFromJson(json);
}
