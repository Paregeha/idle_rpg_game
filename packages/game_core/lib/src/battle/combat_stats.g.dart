// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combat_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CombatStats _$CombatStatsFromJson(Map<String, dynamic> json) => _CombatStats(
  attack: const BigNumConverter().fromJson(json['attack'] as String),
  attacksPerSecond: (json['attacksPerSecond'] as num?)?.toDouble() ?? 1.0,
  critChance: (json['critChance'] as num?)?.toDouble() ?? 0.0,
  critFactor: (json['critFactor'] as num?)?.toDouble() ?? 2.0,
  mitigation: (json['mitigation'] as num?)?.toDouble() ?? 0.0,
  dodgeChance: (json['dodgeChance'] as num?)?.toDouble() ?? 0.0,
  maxHp: json['maxHp'] == null
      ? BigNum.one
      : const BigNumConverter().fromJson(json['maxHp'] as String),
);

Map<String, dynamic> _$CombatStatsToJson(_CombatStats instance) =>
    <String, dynamic>{
      'attack': const BigNumConverter().toJson(instance.attack),
      'attacksPerSecond': instance.attacksPerSecond,
      'critChance': instance.critChance,
      'critFactor': instance.critFactor,
      'mitigation': instance.mitigation,
      'dodgeChance': instance.dodgeChance,
      'maxHp': const BigNumConverter().toJson(instance.maxHp),
    };
