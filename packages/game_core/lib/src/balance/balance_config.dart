import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/balance/generator_config.dart';

part 'balance_config.freezed.dart';
part 'balance_config.g.dart';

/// Every tunable number the simulation reads.
///
/// Balance lives in data, never in code (rule 6): the server can ship a new
/// config without a store release, and the CLI simulator can sweep a config
/// across player profiles without launching the game.
///
/// Schema validation and the shipped `assets/balance/v1.json` arrive with
/// `T-015`; this is the shape the simulator needs to exist first.
@freezed
abstract class BalanceConfig with _$BalanceConfig {
  const factory BalanceConfig({
    @Default(<String, GeneratorConfig>{})
    Map<String, GeneratorConfig> generators,
  }) = _BalanceConfig;

  factory BalanceConfig.fromJson(Map<String, dynamic> json) =>
      _$BalanceConfigFromJson(json);
}
