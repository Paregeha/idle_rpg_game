import 'package:freezed_annotation/freezed_annotation.dart';

part 'generator_state.freezed.dart';
part 'generator_state.g.dart';

/// One production building the player owns.
///
/// [owned] is how many copies were bought; [level] is how far the building has
/// been upgraded. Both feed the production formula, so both are plain integers
/// — a count of buildings never reaches the magnitudes resources do.
@freezed
abstract class GeneratorState with _$GeneratorState {
  const factory GeneratorState({
    @Default(0) int level,
    @Default(0) int owned,
  }) = _GeneratorState;

  factory GeneratorState.fromJson(Map<String, dynamic> json) =>
      _$GeneratorStateFromJson(json);
}
