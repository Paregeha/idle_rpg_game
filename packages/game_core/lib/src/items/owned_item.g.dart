// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owned_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnedItem _$OwnedItemFromJson(Map<String, dynamic> json) => _OwnedItem(
  id: json['id'] as String,
  configId: json['configId'] as String,
  level: (json['level'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OwnedItemToJson(_OwnedItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'configId': instance.configId,
      'level': instance.level,
    };
