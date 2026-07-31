// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillConfig _$SkillConfigFromJson(Map<String, dynamic> json) => _SkillConfig(
  rarity: json['rarity'] as String? ?? 'common',
  unlockAtLevel: (json['unlockAtLevel'] as num?)?.toInt() ?? 0,
  cooldownSeconds: (json['cooldownSeconds'] as num?)?.toDouble() ?? 6.0,
  damageMultiplier: (json['damageMultiplier'] as num?)?.toDouble() ?? 2.0,
  levelMultiplier: (json['levelMultiplier'] as num?)?.toDouble() ?? 1.15,
  targets: (json['targets'] as num?)?.toInt() ?? 1,
  maxLevel: (json['maxLevel'] as num?)?.toInt() ?? 10,
  copiesBase: (json['copiesBase'] as num?)?.toInt() ?? 2,
  copiesGrowth: (json['copiesGrowth'] as num?)?.toDouble() ?? 1.6,
);

Map<String, dynamic> _$SkillConfigToJson(_SkillConfig instance) =>
    <String, dynamic>{
      'rarity': instance.rarity,
      'unlockAtLevel': instance.unlockAtLevel,
      'cooldownSeconds': instance.cooldownSeconds,
      'damageMultiplier': instance.damageMultiplier,
      'levelMultiplier': instance.levelMultiplier,
      'targets': instance.targets,
      'maxLevel': instance.maxLevel,
      'copiesBase': instance.copiesBase,
      'copiesGrowth': instance.copiesGrowth,
    };

_SkillPackConfig _$SkillPackConfigFromJson(Map<String, dynamic> json) =>
    _SkillPackConfig(
      costResource: json['costResource'] as String? ?? 'gems',
      costAmount: (json['costAmount'] as num?)?.toDouble() ?? 100.0,
      weights:
          (json['weights'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      pityThreshold: (json['pityThreshold'] as num?)?.toInt() ?? 0,
      pityRarity: json['pityRarity'] as String? ?? '',
      bossDropChance: (json['bossDropChance'] as num?)?.toDouble() ?? 0.0,
      monsterDropChance: (json['monsterDropChance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SkillPackConfigToJson(_SkillPackConfig instance) =>
    <String, dynamic>{
      'costResource': instance.costResource,
      'costAmount': instance.costAmount,
      'weights': instance.weights,
      'pityThreshold': instance.pityThreshold,
      'pityRarity': instance.pityRarity,
      'bossDropChance': instance.bossDropChance,
      'monsterDropChance': instance.monsterDropChance,
    };
