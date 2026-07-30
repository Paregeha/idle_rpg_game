// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) => _PlayerState(
  lastTickAtMs: (json['lastTickAtMs'] as num).toInt(),
  rngSeed: (json['rngSeed'] as num).toInt(),
  version: (json['version'] as num?)?.toInt() ?? stateSchemaVersion,
  carryOverMs: (json['carryOverMs'] as num?)?.toInt() ?? 0,
  resources:
      (json['resources'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, const BigNumConverter().fromJson(e as String)),
      ) ??
      const <String, BigNum>{},
  generators:
      (json['generators'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GeneratorState.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, GeneratorState>{},
  upgrades:
      (json['upgrades'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  earnedThisRun:
      (json['earnedThisRun'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, const BigNumConverter().fromJson(e as String)),
      ) ??
      const <String, BigNum>{},
  heroes:
      (json['heroes'] as List<dynamic>?)
          ?.map((e) => HeroState.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <HeroState>[],
  inventory:
      (json['inventory'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, OwnedItem.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, OwnedItem>{},
  equipped:
      (json['equipped'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  prestige: json['prestige'] == null
      ? const PrestigeState()
      : PrestigeState.fromJson(json['prestige'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PlayerStateToJson(_PlayerState instance) =>
    <String, dynamic>{
      'lastTickAtMs': instance.lastTickAtMs,
      'rngSeed': instance.rngSeed,
      'version': instance.version,
      'carryOverMs': instance.carryOverMs,
      'resources': instance.resources.map(
        (k, e) => MapEntry(k, const BigNumConverter().toJson(e)),
      ),
      'generators': instance.generators.map((k, e) => MapEntry(k, e.toJson())),
      'upgrades': instance.upgrades,
      'earnedThisRun': instance.earnedThisRun.map(
        (k, e) => MapEntry(k, const BigNumConverter().toJson(e)),
      ),
      'heroes': instance.heroes.map((e) => e.toJson()).toList(),
      'inventory': instance.inventory.map((k, e) => MapEntry(k, e.toJson())),
      'equipped': instance.equipped,
      'prestige': instance.prestige.toJson(),
    };
