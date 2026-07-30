import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'start_config.freezed.dart';
part 'start_config.g.dart';

/// What a brand new player begins with.
///
/// A player who starts with nothing and no income can never afford the first
/// generator — the economy has no entry point. Which generator they are given,
/// and how much they start with, is a balance decision, so it lives in the
/// config rather than in whatever code happens to create the first state.
@freezed
abstract class StartConfig with _$StartConfig {
  const factory StartConfig({
    /// Generators the player owns from the first second, by id and count.
    @Default(<String, int>{}) Map<String, int> generators,

    /// Resources in the player's pocket at the start.
    @BigNumConverter()
    @Default(<String, BigNum>{})
    Map<String, BigNum> resources,
  }) = _StartConfig;

  factory StartConfig.fromJson(Map<String, dynamic> json) =>
      _$StartConfigFromJson(json);
}
