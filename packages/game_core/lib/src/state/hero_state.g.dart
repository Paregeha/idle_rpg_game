// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HeroState _$HeroStateFromJson(Map<String, dynamic> json) => _HeroState(
  id: json['id'] as String,
  level: (json['level'] as num?)?.toInt() ?? 1,
  experience: (json['experience'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$HeroStateToJson(_HeroState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'experience': instance.experience,
    };
