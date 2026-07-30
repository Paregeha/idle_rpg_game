// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestige_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrestigeConfig _$PrestigeConfigFromJson(Map<String, dynamic> json) =>
    _PrestigeConfig(
      resource: json['resource'] as String? ?? 'gold',
      currencyBase: json['currencyBase'] == null
          ? BigNum.one
          : const BigNumConverter().fromJson(json['currencyBase'] as String),
      currencyExponent: (json['currencyExponent'] as num?)?.toDouble() ?? 0.5,
      bonusPerPoint: json['bonusPerPoint'] == null
          ? BigNum.zero
          : const BigNumConverter().fromJson(json['bonusPerPoint'] as String),
    );

Map<String, dynamic> _$PrestigeConfigToJson(_PrestigeConfig instance) =>
    <String, dynamic>{
      'resource': instance.resource,
      'currencyBase': const BigNumConverter().toJson(instance.currencyBase),
      'currencyExponent': instance.currencyExponent,
      'bonusPerPoint': const BigNumConverter().toJson(instance.bonusPerPoint),
    };
