// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BattleResult _$BattleResultFromJson(Map<String, dynamic> json) =>
    _BattleResult(
      outcome: $enumDecode(_$BattleOutcomeEnumMap, json['outcome']),
      events: (json['events'] as List<dynamic>)
          .map((e) => BattleEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      durationMs: (json['durationMs'] as num).toInt(),
    );

Map<String, dynamic> _$BattleResultToJson(_BattleResult instance) =>
    <String, dynamic>{
      'outcome': _$BattleOutcomeEnumMap[instance.outcome]!,
      'events': instance.events.map((e) => e.toJson()).toList(),
      'durationMs': instance.durationMs,
    };

const _$BattleOutcomeEnumMap = {
  BattleOutcome.heroWon: 'heroWon',
  BattleOutcome.heroLost: 'heroLost',
  BattleOutcome.timeout: 'timeout',
};
