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
    );

Map<String, dynamic> _$GeneratorConfigToJson(_GeneratorConfig instance) =>
    <String, dynamic>{
      'produces': instance.produces,
      'baseRatePerSecond': const BigNumConverter().toJson(
        instance.baseRatePerSecond,
      ),
      'levelMultiplier': instance.levelMultiplier,
    };
