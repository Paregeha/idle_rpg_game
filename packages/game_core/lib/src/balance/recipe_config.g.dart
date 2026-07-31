// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeConfig _$RecipeConfigFromJson(Map<String, dynamic> json) =>
    _RecipeConfig(
      produces: json['produces'] as String? ?? '',
      costs:
          (json['costs'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, const BigNumConverter().fromJson(e as String)),
          ) ??
          const <String, BigNum>{},
      unlockAtHeroLevel: (json['unlockAtHeroLevel'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RecipeConfigToJson(_RecipeConfig instance) =>
    <String, dynamic>{
      'produces': instance.produces,
      'costs': instance.costs.map(
        (k, e) => MapEntry(k, const BigNumConverter().toJson(e)),
      ),
      'unlockAtHeroLevel': instance.unlockAtHeroLevel,
    };
