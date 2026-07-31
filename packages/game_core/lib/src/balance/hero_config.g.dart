// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeroConfig _$HeroConfigFromJson(Map<String, dynamic> json) => _HeroConfig(
  baseAttack: json['baseAttack'] == null
      ? BigNum.one
      : const BigNumConverter().fromJson(json['baseAttack'] as String),
  baseHp: json['baseHp'] == null
      ? BigNum.one
      : const BigNumConverter().fromJson(json['baseHp'] as String),
  perUnitMultiplier: (json['perUnitMultiplier'] as num?)?.toDouble() ?? 1.05,
  attacksPerSecond: (json['attacksPerSecond'] as num?)?.toDouble() ?? 1.0,
  critChance: (json['critChance'] as num?)?.toDouble() ?? 0.1,
  critFactor: (json['critFactor'] as num?)?.toDouble() ?? 2.0,
  mitigation: (json['mitigation'] as num?)?.toDouble() ?? 0.0,
  dodgeChance: (json['dodgeChance'] as num?)?.toDouble() ?? 0.05,
  expBase: json['expBase'] == null
      ? BigNum.one
      : const BigNumConverter().fromJson(json['expBase'] as String),
  expGrowth: (json['expGrowth'] as num?)?.toDouble() ?? 1.35,
  statPerLevel: (json['statPerLevel'] as num?)?.toDouble() ?? 1.08,
);

Map<String, dynamic> _$HeroConfigToJson(_HeroConfig instance) =>
    <String, dynamic>{
      'baseAttack': const BigNumConverter().toJson(instance.baseAttack),
      'baseHp': const BigNumConverter().toJson(instance.baseHp),
      'perUnitMultiplier': instance.perUnitMultiplier,
      'attacksPerSecond': instance.attacksPerSecond,
      'critChance': instance.critChance,
      'critFactor': instance.critFactor,
      'mitigation': instance.mitigation,
      'dodgeChance': instance.dodgeChance,
      'expBase': const BigNumConverter().toJson(instance.expBase),
      'expGrowth': instance.expGrowth,
      'statPerLevel': instance.statPerLevel,
    };
