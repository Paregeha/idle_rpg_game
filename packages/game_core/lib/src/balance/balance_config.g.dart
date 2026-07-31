// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BalanceConfig _$BalanceConfigFromJson(
  Map<String, dynamic> json,
) => _BalanceConfig(
  version: (json['version'] as num?)?.toInt() ?? supportedBalanceVersion,
  generators:
      (json['generators'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, GeneratorConfig.fromJson(e as Map<String, dynamic>)),
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
  hero: json['hero'] == null
      ? const HeroConfig()
      : HeroConfig.fromJson(json['hero'] as Map<String, dynamic>),
  lamp: json['lamp'] == null
      ? const LampConfig()
      : LampConfig.fromJson(json['lamp'] as Map<String, dynamic>),
  displayedResources:
      (json['displayedResources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  itemUpgrade: json['itemUpgrade'] == null
      ? const ItemUpgradeConfig()
      : ItemUpgradeConfig.fromJson(json['itemUpgrade'] as Map<String, dynamic>),
  slots:
      (json['slots'] as List<dynamic>?)
          ?.map((e) => SlotConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SlotConfig>[],
  rarities:
      (json['rarities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, RarityConfig.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, RarityConfig>{},
  items:
      (json['items'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ItemConfig.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, ItemConfig>{},
  start: json['start'] == null
      ? const StartConfig()
      : StartConfig.fromJson(json['start'] as Map<String, dynamic>),
  offlineCapMs: (json['offlineCapMs'] as num?)?.toInt() ?? _eightHoursMs,
);

Map<String, dynamic> _$BalanceConfigToJson(_BalanceConfig instance) =>
    <String, dynamic>{
      'version': instance.version,
      'generators': instance.generators.map((k, e) => MapEntry(k, e.toJson())),
      'monsters': instance.monsters.map((k, e) => MapEntry(k, e.toJson())),
      'prestige': instance.prestige.toJson(),
      'hero': instance.hero.toJson(),
      'lamp': instance.lamp.toJson(),
      'displayedResources': instance.displayedResources,
      'itemUpgrade': instance.itemUpgrade.toJson(),
      'slots': instance.slots.map((e) => e.toJson()).toList(),
      'rarities': instance.rarities.map((k, e) => MapEntry(k, e.toJson())),
      'items': instance.items.map((k, e) => MapEntry(k, e.toJson())),
      'start': instance.start.toJson(),
      'offlineCapMs': instance.offlineCapMs,
    };
