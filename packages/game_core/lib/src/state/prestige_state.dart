import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'prestige_state.freezed.dart';
part 'prestige_state.g.dart';

/// What survives a prestige reset.
///
/// [currency] is earned from total progress and is spent on
/// [permanentUpgrades], which is why both outlive a reset while resources and
/// generators do not. See `T-017`.
@freezed
abstract class PrestigeState with _$PrestigeState {
  const factory PrestigeState({
    @BigNumConverter() @Default(BigNum.zero) BigNum currency,
    @Default(0) int resets,
    @Default(<String, int>{}) Map<String, int> permanentUpgrades,
  }) = _PrestigeState;

  factory PrestigeState.fromJson(Map<String, dynamic> json) =>
      _$PrestigeStateFromJson(json);
}
