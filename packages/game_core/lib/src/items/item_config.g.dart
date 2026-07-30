// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RarityConfig _$RarityConfigFromJson(Map<String, dynamic> json) =>
    _RarityConfig(
      statMultiplier: (json['statMultiplier'] as num?)?.toDouble() ?? 1.0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RarityConfigToJson(_RarityConfig instance) =>
    <String, dynamic>{
      'statMultiplier': instance.statMultiplier,
      'rank': instance.rank,
    };

_ItemStats _$ItemStatsFromJson(Map<String, dynamic> json) => _ItemStats(
  flatAttack: json['flatAttack'] == null
      ? BigNum.zero
      : const BigNumConverter().fromJson(json['flatAttack'] as String),
  flatHp: json['flatHp'] == null
      ? BigNum.zero
      : const BigNumConverter().fromJson(json['flatHp'] as String),
  attackMultiplier: (json['attackMultiplier'] as num?)?.toDouble() ?? 1.0,
  hpMultiplier: (json['hpMultiplier'] as num?)?.toDouble() ?? 1.0,
  critChance: (json['critChance'] as num?)?.toDouble() ?? 0.0,
  critFactor: (json['critFactor'] as num?)?.toDouble() ?? 0.0,
  dodgeChance: (json['dodgeChance'] as num?)?.toDouble() ?? 0.0,
  mitigation: (json['mitigation'] as num?)?.toDouble() ?? 0.0,
  attacksPerSecond: (json['attacksPerSecond'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$ItemStatsToJson(_ItemStats instance) =>
    <String, dynamic>{
      'flatAttack': const BigNumConverter().toJson(instance.flatAttack),
      'flatHp': const BigNumConverter().toJson(instance.flatHp),
      'attackMultiplier': instance.attackMultiplier,
      'hpMultiplier': instance.hpMultiplier,
      'critChance': instance.critChance,
      'critFactor': instance.critFactor,
      'dodgeChance': instance.dodgeChance,
      'mitigation': instance.mitigation,
      'attacksPerSecond': instance.attacksPerSecond,
    };

_ItemConfig _$ItemConfigFromJson(Map<String, dynamic> json) => _ItemConfig(
  slot: json['slot'] as String,
  rarity: json['rarity'] as String,
  stats: json['stats'] == null
      ? ItemStats.empty
      : ItemStats.fromJson(json['stats'] as Map<String, dynamic>),
  levelMultiplier: (json['levelMultiplier'] as num?)?.toDouble() ?? 1.12,
  maxLevel: (json['maxLevel'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$ItemConfigToJson(_ItemConfig instance) =>
    <String, dynamic>{
      'slot': instance.slot,
      'rarity': instance.rarity,
      'stats': instance.stats.toJson(),
      'levelMultiplier': instance.levelMultiplier,
      'maxLevel': instance.maxLevel,
    };
