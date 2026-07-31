// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressionConfig _$ProgressionConfigFromJson(
  Map<String, dynamic> json,
) => _ProgressionConfig(
  wavesPerStage: (json['wavesPerStage'] as num?)?.toInt() ?? 5,
  monstersPerWave: (json['monstersPerWave'] as num?)?.toInt() ?? 3,
  stagesPerChapter: (json['stagesPerChapter'] as num?)?.toInt() ?? 10,
  monsters:
      (json['monsters'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  bosses:
      (json['bosses'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  levelPerStage: (json['levelPerStage'] as num?)?.toInt() ?? 1,
  bossLevelBonus: (json['bossLevelBonus'] as num?)?.toInt() ?? 2,
);

Map<String, dynamic> _$ProgressionConfigToJson(_ProgressionConfig instance) =>
    <String, dynamic>{
      'wavesPerStage': instance.wavesPerStage,
      'monstersPerWave': instance.monstersPerWave,
      'stagesPerChapter': instance.stagesPerChapter,
      'monsters': instance.monsters,
      'bosses': instance.bosses,
      'levelPerStage': instance.levelPerStage,
      'bossLevelBonus': instance.bossLevelBonus,
    };
