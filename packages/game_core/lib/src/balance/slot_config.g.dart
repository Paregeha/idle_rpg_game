// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SlotConfig _$SlotConfigFromJson(Map<String, dynamic> json) => _SlotConfig(
  id: json['id'] as String,
  accepts: json['accepts'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SlotConfigToJson(_SlotConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accepts': instance.accepts,
      'order': instance.order,
    };
