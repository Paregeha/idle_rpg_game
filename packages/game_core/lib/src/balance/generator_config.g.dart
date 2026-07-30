// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneratorConfig _$GeneratorConfigFromJson(Map<String, dynamic> json) =>
    _GeneratorConfig(
      produces: json['produces'] as String,
      baseRatePerSecond: const BigNumConverter().fromJson(
        json['baseRatePerSecond'] as String,
      ),
      levelMultiplier: (json['levelMultiplier'] as num?)?.toDouble() ?? 1.0,
      costResource: json['costResource'] as String? ?? '',
      costBase: json['costBase'] == null
          ? BigNum.one
          : const BigNumConverter().fromJson(json['costBase'] as String),
      costGrowth: (json['costGrowth'] as num?)?.toDouble() ?? 1.07,
    );

Map<String, dynamic> _$GeneratorConfigToJson(_GeneratorConfig instance) =>
    <String, dynamic>{
      'produces': instance.produces,
      'baseRatePerSecond': const BigNumConverter().toJson(
        instance.baseRatePerSecond,
      ),
      'levelMultiplier': instance.levelMultiplier,
      'costResource': instance.costResource,
      'costBase': const BigNumConverter().toJson(instance.costBase),
      'costGrowth': instance.costGrowth,
    };
