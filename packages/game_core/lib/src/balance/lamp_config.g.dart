// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lamp_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LampConfig _$LampConfigFromJson(Map<String, dynamic> json) => _LampConfig(
  costResource: json['costResource'] as String? ?? 'gems',
  costAmount: json['costAmount'] == null
      ? BigNum.one
      : const BigNumConverter().fromJson(json['costAmount'] as String),
  weights:
      (json['weights'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const <String, double>{},
  pityThreshold: (json['pityThreshold'] as num?)?.toInt() ?? 0,
  pityRarity: json['pityRarity'] as String? ?? '',
);

Map<String, dynamic> _$LampConfigToJson(_LampConfig instance) =>
    <String, dynamic>{
      'costResource': instance.costResource,
      'costAmount': const BigNumConverter().toJson(instance.costAmount),
      'weights': instance.weights,
      'pityThreshold': instance.pityThreshold,
      'pityRarity': instance.pityRarity,
    };
