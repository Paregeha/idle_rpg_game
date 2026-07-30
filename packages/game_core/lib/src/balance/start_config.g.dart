// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StartConfig _$StartConfigFromJson(Map<String, dynamic> json) => _StartConfig(
  generators:
      (json['generators'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  resources:
      (json['resources'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, const BigNumConverter().fromJson(e as String)),
      ) ??
      const <String, BigNum>{},
);

Map<String, dynamic> _$StartConfigToJson(_StartConfig instance) =>
    <String, dynamic>{
      'generators': instance.generators,
      'resources': instance.resources.map(
        (k, e) => MapEntry(k, const BigNumConverter().toJson(e)),
      ),
    };
