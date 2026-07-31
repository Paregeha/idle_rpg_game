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
  chapter: (json['chapter'] as num?)?.toInt() ?? 1,
  stage: (json['stage'] as num?)?.toInt() ?? 1,
  wave: (json['wave'] as num?)?.toInt() ?? 0,
  skills:
      (json['skills'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  skillCopies:
      (json['skillCopies'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  skillPity: (json['skillPity'] as num?)?.toInt() ?? 0,
  sellReplaced: json['sellReplaced'] as bool? ?? false,
  autoCast: json['autoCast'] as bool? ?? true,
  heroLevel: (json['heroLevel'] as num?)?.toInt() ?? 0,
  heroExperience: json['heroExperience'] == null
      ? BigNum.zero
      : const BigNumConverter().fromJson(json['heroExperience'] as String),
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
  rngState:
      (json['rngState'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  itemsCreated: (json['itemsCreated'] as num?)?.toInt() ?? 0,
  pityCounter: (json['pityCounter'] as num?)?.toInt() ?? 0,
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
      'chapter': instance.chapter,
      'stage': instance.stage,
      'wave': instance.wave,
      'skills': instance.skills,
      'skillCopies': instance.skillCopies,
      'skillPity': instance.skillPity,
      'sellReplaced': instance.sellReplaced,
      'autoCast': instance.autoCast,
      'heroLevel': instance.heroLevel,
      'heroExperience': const BigNumConverter().toJson(instance.heroExperience),
      'inventory': instance.inventory.map((k, e) => MapEntry(k, e.toJson())),
      'equipped': instance.equipped,
      'rngState': instance.rngState,
      'itemsCreated': instance.itemsCreated,
      'pityCounter': instance.pityCounter,
      'prestige': instance.prestige.toJson(),
    };
