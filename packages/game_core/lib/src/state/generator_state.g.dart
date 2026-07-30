// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneratorState _$GeneratorStateFromJson(Map<String, dynamic> json) =>
    _GeneratorState(
      level: (json['level'] as num?)?.toInt() ?? 0,
      owned: (json['owned'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GeneratorStateToJson(_GeneratorState instance) =>
    <String, dynamic>{'level': instance.level, 'owned': instance.owned};
