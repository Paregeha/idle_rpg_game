// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceConfig _$BalanceConfigFromJson(Map<String, dynamic> json) =>
    _BalanceConfig(
      version: (json['version'] as num?)?.toInt() ?? supportedBalanceVersion,
      generators:
          (json['generators'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              GeneratorConfig.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const <String, GeneratorConfig>{},
      monsters:
          (json['monsters'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, MonsterConfig.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, MonsterConfig>{},
      prestige: json['prestige'] == null
          ? const PrestigeConfig()
          : PrestigeConfig.fromJson(json['prestige'] as Map<String, dynamic>),
      offlineCapMs: (json['offlineCapMs'] as num?)?.toInt() ?? _eightHoursMs,
    );

Map<String, dynamic> _$BalanceConfigToJson(_BalanceConfig instance) =>
    <String, dynamic>{
      'version': instance.version,
      'generators': instance.generators.map((k, e) => MapEntry(k, e.toJson())),
      'monsters': instance.monsters.map((k, e) => MapEntry(k, e.toJson())),
      'prestige': instance.prestige.toJson(),
      'offlineCapMs': instance.offlineCapMs,
    };
