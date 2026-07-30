// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_upgrade_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemUpgradeConfig _$ItemUpgradeConfigFromJson(Map<String, dynamic> json) =>
    _ItemUpgradeConfig(
      costResource: json['costResource'] as String? ?? 'gold',
      costBase: json['costBase'] == null
          ? BigNum.one
          : const BigNumConverter().fromJson(json['costBase'] as String),
      costGrowth: (json['costGrowth'] as num?)?.toDouble() ?? 1.6,
      duplicatesPerLevel: (json['duplicatesPerLevel'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ItemUpgradeConfigToJson(_ItemUpgradeConfig instance) =>
    <String, dynamic>{
      'costResource': instance.costResource,
      'costBase': const BigNumConverter().toJson(instance.costBase),
      'costGrowth': instance.costGrowth,
      'duplicatesPerLevel': instance.duplicatesPerLevel,
    };
