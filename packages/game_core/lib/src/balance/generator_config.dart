import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'generator_config.freezed.dart';
part 'generator_config.g.dart';

/// Balance numbers for one kind of generator.
///
/// Production per second is `baseRatePerSecond * owned * levelMultiplier^level`
/// — linear in time, which is what lets the simulator use a closed form instead
/// of stepping through every second.
@freezed
abstract class GeneratorConfig with _$GeneratorConfig {
  const factory GeneratorConfig({
    /// Key of the resource this generator adds to.
    required String produces,

    /// Output per second for a single unit at level 0.
    @BigNumConverter() required BigNum baseRatePerSecond,

    /// Rate is multiplied by this, raised to the generator's level.
    @Default(1.0) double levelMultiplier,
  }) = _GeneratorConfig;

  factory GeneratorConfig.fromJson(Map<String, dynamic> json) =>
      _$GeneratorConfigFromJson(json);
}
