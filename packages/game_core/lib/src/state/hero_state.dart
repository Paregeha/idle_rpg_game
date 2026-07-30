import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero_state.freezed.dart';
part 'hero_state.g.dart';

/// A hero in the player's party.
///
/// [id] refers to an entry in the balance config, never to a database row —
/// the state stays meaningful on its own so the server can simulate from it.
@freezed
abstract class HeroState with _$HeroState {
  const factory HeroState({
    required String id,
    @Default(1) int level,
    @Default(0) int experience,
  }) = _HeroState;

  factory HeroState.fromJson(Map<String, dynamic> json) =>
      _$HeroStateFromJson(json);
}
