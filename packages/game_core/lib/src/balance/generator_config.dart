import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'generator_config.freezed.dart';
part 'generator_config.g.dart';

/// Balance numbers for one kind of generator.
@freezed
abstract class GeneratorConfig with _$GeneratorConfig {
  const factory GeneratorConfig({
    /// Key of the resource this generator adds to.
    required String produces,

    /// Output per second for a single unit at level 0.
    @BigNumConverter() required BigNum baseRatePerSecond,

    /// Rate is multiplied by this, raised to the generator's level.
    @Default(1.0) double levelMultiplier,

    /// Price of the first unit.
    @BigNumConverter() @Default(BigNum.one) BigNum costBase,

    /// Price is multiplied by this for each unit already owned.
    @Default(1.07) double costGrowth,
  }) = _GeneratorConfig;

  const GeneratorConfig._();

  factory GeneratorConfig.fromJson(Map<String, dynamic> json) =>
      _$GeneratorConfigFromJson(json);

  /// Production per second for [owned] units at [level].
  ///
  /// Formula: `baseRatePerSecond * owned * levelMultiplier^level`.
  ///
  /// Linear in time, which is what lets the simulator settle any span with one
  /// multiplication instead of stepping second by second (ADR-007).
  BigNum ratePerSecond({required int owned, required int level}) {
    _requireNonNegative(owned, 'owned');
    _requireNonNegative(level, 'level');
    if (owned == 0) return BigNum.zero;

    return baseRatePerSecond *
        BigNum.fromDouble(owned.toDouble()) *
        BigNum.fromDouble(levelMultiplier).pow(level);
  }

  /// Price of the next unit when [owned] are already held.
  ///
  /// Formula: `costBase * costGrowth^owned`.
  ///
  /// Exponential against production that grows linearly with unit count — that
  /// gap is the whole pacing mechanism of the genre. `costGrowth` at or below
  /// 1 would make units effectively free forever, so the config validator
  /// rejects it.
  BigNum costFor(int owned) {
    _requireNonNegative(owned, 'owned');
    return costBase * BigNum.fromDouble(costGrowth).pow(owned);
  }

  /// Total price of buying [count] more units starting from [owned].
  ///
  /// Sums the geometric series rather than looping, so a "buy max" button
  /// costs the same whether the player is buying 1 or 10 000.
  BigNum bulkCost({required int owned, required int count}) {
    _requireNonNegative(owned, 'owned');
    _requireNonNegative(count, 'count');
    if (count == 0) return BigNum.zero;

    // costBase * growth^owned * (growth^count - 1) / (growth - 1)
    final growth = BigNum.fromDouble(costGrowth);
    final numerator = growth.pow(count) - BigNum.one;
    final denominator = growth - BigNum.one;
    return costFor(owned) * numerator / denominator;
  }
}

void _requireNonNegative(int value, String name) {
  if (value < 0) {
    throw ArgumentError.value(value, name, 'must not be negative');
  }
}
