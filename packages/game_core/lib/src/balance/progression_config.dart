import 'package:freezed_annotation/freezed_annotation.dart';

part 'progression_config.freezed.dart';
part 'progression_config.g.dart';

/// How the world is laid out: chapters, stages, waves.
///
/// Generated from a handful of numbers rather than listed stage by stage. An
/// idle game runs for hundreds of stages, and hand-writing them would mean
/// either a colossal config or an early wall where the list runs out.
@freezed
abstract class ProgressionConfig with _$ProgressionConfig {
  const factory ProgressionConfig({
    /// Ordinary waves before the boss of a stage.
    @Default(5) int wavesPerStage,

    /// Monsters in one ordinary wave.
    ///
    /// A group rather than a single monster, so an area skill has something to
    /// hit — and so a wave reads as a fight rather than a formality.
    @Default(3) int monstersPerWave,

    /// Stages before the chapter number goes up.
    @Default(10) int stagesPerChapter,

    /// Ordinary monsters, cycled through as stages advance.
    @Default(<String>[]) List<String> monsters,

    /// Bosses, cycled the same way.
    @Default(<String>[]) List<String> bosses,

    /// Monster level added per stage cleared.
    ///
    /// This is the difficulty curve: monster health and damage already scale
    /// exponentially with level, so this number decides how fast the wall
    /// arrives.
    @Default(1) int levelPerStage,

    /// Boss level on top of the stage level.
    @Default(2) int bossLevelBonus,
  }) = _ProgressionConfig;

  const ProgressionConfig._();

  factory ProgressionConfig.fromJson(Map<String, dynamic> json) =>
      _$ProgressionConfigFromJson(json);

  /// Zero-based index of a stage across all chapters.
  int stageIndex({required int chapter, required int stage}) =>
      (chapter - 1) * stagesPerChapter + (stage - 1);

  /// Monster level for a stage.
  int levelFor({required int chapter, required int stage}) =>
      stageIndex(chapter: chapter, stage: stage) * levelPerStage;

  /// Which ordinary monster shows up in a stage.
  String? monsterFor({required int chapter, required int stage}) {
    if (monsters.isEmpty) return null;
    return monsters[stageIndex(chapter: chapter, stage: stage) %
        monsters.length];
  }

  /// Which boss guards a stage.
  String? bossFor({required int chapter, required int stage}) {
    if (bosses.isEmpty) return null;
    return bosses[stageIndex(chapter: chapter, stage: stage) % bosses.length];
  }
}
