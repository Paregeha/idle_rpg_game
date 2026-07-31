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
      costResourceByKind:
          (json['costResourceByKind'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      costBaseByKind:
          (json['costBaseByKind'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, const BigNumConverter().fromJson(e as String)),
          ) ??
          const <String, BigNum>{},
      duplicatesPerLevel: (json['duplicatesPerLevel'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ItemUpgradeConfigToJson(_ItemUpgradeConfig instance) =>
    <String, dynamic>{
      'costResource': instance.costResource,
      'costBase': const BigNumConverter().toJson(instance.costBase),
      'costGrowth': instance.costGrowth,
      'costResourceByKind': instance.costResourceByKind,
      'costBaseByKind': instance.costBaseByKind.map(
        (k, e) => MapEntry(k, const BigNumConverter().toJson(e)),
      ),
      'duplicatesPerLevel': instance.duplicatesPerLevel,
    };
