import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_core/src/math/big_num.dart';
import 'package:game_core/src/state/big_num_converter.dart';

part 'recipe_config.freezed.dart';
part 'recipe_config.g.dart';

/// One thing the forge can make.
@freezed
abstract class RecipeConfig with _$RecipeConfig {
  const factory RecipeConfig({
    /// Id of the item this produces.
    @Default('') String produces,

    /// What it takes, by resource. Materials and currency alike — the forge
    /// does not care which of them the shop calls a currency.
    @BigNumConverter() @Default(<String, BigNum>{}) Map<String, BigNum> costs,

    /// Hero level before the recipe can be used at all.
    ///
    /// A recipe shown while it is still locked is a goal. One hidden until it
    /// is available is a surprise, and a player cannot save towards a surprise.
    @Default(0) int unlockAtHeroLevel,
  }) = _RecipeConfig;

  const RecipeConfig._();

  factory RecipeConfig.fromJson(Map<String, dynamic> json) =>
      _$RecipeConfigFromJson(json);
}
