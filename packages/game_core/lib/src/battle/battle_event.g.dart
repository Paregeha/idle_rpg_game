// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BattleEvent _$BattleEventFromJson(Map<String, dynamic> json) => _BattleEvent(
  atMs: (json['atMs'] as num).toInt(),
  kind: $enumDecode(_$BattleEventKindEnumMap, json['kind']),
  source: $enumDecode(_$BattleSideEnumMap, json['source']),
  target: $enumDecode(_$BattleSideEnumMap, json['target']),
  damage: json['damage'] == null
      ? BigNum.zero
      : const BigNumConverter().fromJson(json['damage'] as String),
);

Map<String, dynamic> _$BattleEventToJson(_BattleEvent instance) =>
    <String, dynamic>{
      'atMs': instance.atMs,
      'kind': _$BattleEventKindEnumMap[instance.kind]!,
      'source': _$BattleSideEnumMap[instance.source]!,
      'target': _$BattleSideEnumMap[instance.target]!,
      'damage': const BigNumConverter().toJson(instance.damage),
    };

const _$BattleEventKindEnumMap = {
  BattleEventKind.hit: 'hit',
  BattleEventKind.crit: 'crit',
  BattleEventKind.dodge: 'dodge',
  BattleEventKind.death: 'death',
};

const _$BattleSideEnumMap = {
  BattleSide.hero: 'hero',
  BattleSide.monster: 'monster',
};
