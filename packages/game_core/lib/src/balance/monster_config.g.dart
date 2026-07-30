// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monster_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonsterConfig _$MonsterConfigFromJson(Map<String, dynamic> json) =>
    _MonsterConfig(
      baseHp: const BigNumConverter().fromJson(json['baseHp'] as String),
      hpGrowth: (json['hpGrowth'] as num).toDouble(),
      rewardBase: const BigNumConverter().fromJson(
        json['rewardBase'] as String,
      ),
      rewardGrowth: (json['rewardGrowth'] as num).toDouble(),
      baseAttack: json['baseAttack'] == null
          ? BigNum.one
          : const BigNumConverter().fromJson(json['baseAttack'] as String),
      attackGrowth: (json['attackGrowth'] as num?)?.toDouble() ?? 1.4,
      attacksPerSecond: (json['attacksPerSecond'] as num?)?.toDouble() ?? 0.8,
      mitigation: (json['mitigation'] as num?)?.toDouble() ?? 0.0,
      dodgeChance: (json['dodgeChance'] as num?)?.toDouble() ?? 0.0,
      dropChance: (json['dropChance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$MonsterConfigToJson(_MonsterConfig instance) =>
    <String, dynamic>{
      'baseHp': const BigNumConverter().toJson(instance.baseHp),
      'hpGrowth': instance.hpGrowth,
      'rewardBase': const BigNumConverter().toJson(instance.rewardBase),
      'rewardGrowth': instance.rewardGrowth,
      'baseAttack': const BigNumConverter().toJson(instance.baseAttack),
      'attackGrowth': instance.attackGrowth,
      'attacksPerSecond': instance.attacksPerSecond,
      'mitigation': instance.mitigation,
      'dodgeChance': instance.dodgeChance,
      'dropChance': instance.dropChance,
    };
