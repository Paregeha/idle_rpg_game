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
      dropChance: (json['dropChance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$MonsterConfigToJson(_MonsterConfig instance) =>
    <String, dynamic>{
      'baseHp': const BigNumConverter().toJson(instance.baseHp),
      'hpGrowth': instance.hpGrowth,
      'rewardBase': const BigNumConverter().toJson(instance.rewardBase),
      'rewardGrowth': instance.rewardGrowth,
      'dropChance': instance.dropChance,
    };
