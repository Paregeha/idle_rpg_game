// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progression_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProgressionConfig {

/// Ordinary waves before the boss of a stage.
 int get wavesPerStage;/// Monsters in one ordinary wave.
///
/// A group rather than a single monster, so an area skill has something to
/// hit — and so a wave reads as a fight rather than a formality.
 int get monstersPerWave;/// Stages before the chapter number goes up.
 int get stagesPerChapter;/// Ordinary monsters, cycled through as stages advance.
 List<String> get monsters;/// Bosses, cycled the same way.
 List<String> get bosses;/// Monster level added per stage cleared.
///
/// This is the difficulty curve: monster health and damage already scale
/// exponentially with level, so this number decides how fast the wall
/// arrives.
 int get levelPerStage;/// Boss level on top of the stage level.
 int get bossLevelBonus;
/// Create a copy of ProgressionConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressionConfigCopyWith<ProgressionConfig> get copyWith => _$ProgressionConfigCopyWithImpl<ProgressionConfig>(this as ProgressionConfig, _$identity);

  /// Serializes this ProgressionConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressionConfig&&(identical(other.wavesPerStage, wavesPerStage) || other.wavesPerStage == wavesPerStage)&&(identical(other.monstersPerWave, monstersPerWave) || other.monstersPerWave == monstersPerWave)&&(identical(other.stagesPerChapter, stagesPerChapter) || other.stagesPerChapter == stagesPerChapter)&&const DeepCollectionEquality().equals(other.monsters, monsters)&&const DeepCollectionEquality().equals(other.bosses, bosses)&&(identical(other.levelPerStage, levelPerStage) || other.levelPerStage == levelPerStage)&&(identical(other.bossLevelBonus, bossLevelBonus) || other.bossLevelBonus == bossLevelBonus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wavesPerStage,monstersPerWave,stagesPerChapter,const DeepCollectionEquality().hash(monsters),const DeepCollectionEquality().hash(bosses),levelPerStage,bossLevelBonus);

@override
String toString() {
  return 'ProgressionConfig(wavesPerStage: $wavesPerStage, monstersPerWave: $monstersPerWave, stagesPerChapter: $stagesPerChapter, monsters: $monsters, bosses: $bosses, levelPerStage: $levelPerStage, bossLevelBonus: $bossLevelBonus)';
}


}

/// @nodoc
abstract mixin class $ProgressionConfigCopyWith<$Res>  {
  factory $ProgressionConfigCopyWith(ProgressionConfig value, $Res Function(ProgressionConfig) _then) = _$ProgressionConfigCopyWithImpl;
@useResult
$Res call({
 int wavesPerStage, int monstersPerWave, int stagesPerChapter, List<String> monsters, List<String> bosses, int levelPerStage, int bossLevelBonus
});




}
/// @nodoc
class _$ProgressionConfigCopyWithImpl<$Res>
    implements $ProgressionConfigCopyWith<$Res> {
  _$ProgressionConfigCopyWithImpl(this._self, this._then);

  final ProgressionConfig _self;
  final $Res Function(ProgressionConfig) _then;

/// Create a copy of ProgressionConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wavesPerStage = null,Object? monstersPerWave = null,Object? stagesPerChapter = null,Object? monsters = null,Object? bosses = null,Object? levelPerStage = null,Object? bossLevelBonus = null,}) {
  return _then(_self.copyWith(
wavesPerStage: null == wavesPerStage ? _self.wavesPerStage : wavesPerStage // ignore: cast_nullable_to_non_nullable
as int,monstersPerWave: null == monstersPerWave ? _self.monstersPerWave : monstersPerWave // ignore: cast_nullable_to_non_nullable
as int,stagesPerChapter: null == stagesPerChapter ? _self.stagesPerChapter : stagesPerChapter // ignore: cast_nullable_to_non_nullable
as int,monsters: null == monsters ? _self.monsters : monsters // ignore: cast_nullable_to_non_nullable
as List<String>,bosses: null == bosses ? _self.bosses : bosses // ignore: cast_nullable_to_non_nullable
as List<String>,levelPerStage: null == levelPerStage ? _self.levelPerStage : levelPerStage // ignore: cast_nullable_to_non_nullable
as int,bossLevelBonus: null == bossLevelBonus ? _self.bossLevelBonus : bossLevelBonus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgressionConfig].
extension ProgressionConfigPatterns on ProgressionConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressionConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressionConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressionConfig value)  $default,){
final _that = this;
switch (_that) {
case _ProgressionConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressionConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressionConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wavesPerStage,  int monstersPerWave,  int stagesPerChapter,  List<String> monsters,  List<String> bosses,  int levelPerStage,  int bossLevelBonus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressionConfig() when $default != null:
return $default(_that.wavesPerStage,_that.monstersPerWave,_that.stagesPerChapter,_that.monsters,_that.bosses,_that.levelPerStage,_that.bossLevelBonus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wavesPerStage,  int monstersPerWave,  int stagesPerChapter,  List<String> monsters,  List<String> bosses,  int levelPerStage,  int bossLevelBonus)  $default,) {final _that = this;
switch (_that) {
case _ProgressionConfig():
return $default(_that.wavesPerStage,_that.monstersPerWave,_that.stagesPerChapter,_that.monsters,_that.bosses,_that.levelPerStage,_that.bossLevelBonus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wavesPerStage,  int monstersPerWave,  int stagesPerChapter,  List<String> monsters,  List<String> bosses,  int levelPerStage,  int bossLevelBonus)?  $default,) {final _that = this;
switch (_that) {
case _ProgressionConfig() when $default != null:
return $default(_that.wavesPerStage,_that.monstersPerWave,_that.stagesPerChapter,_that.monsters,_that.bosses,_that.levelPerStage,_that.bossLevelBonus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProgressionConfig extends ProgressionConfig {
  const _ProgressionConfig({this.wavesPerStage = 5, this.monstersPerWave = 3, this.stagesPerChapter = 10, final  List<String> monsters = const <String>[], final  List<String> bosses = const <String>[], this.levelPerStage = 1, this.bossLevelBonus = 2}): _monsters = monsters,_bosses = bosses,super._();
  factory _ProgressionConfig.fromJson(Map<String, dynamic> json) => _$ProgressionConfigFromJson(json);

/// Ordinary waves before the boss of a stage.
@override@JsonKey() final  int wavesPerStage;
/// Monsters in one ordinary wave.
///
/// A group rather than a single monster, so an area skill has something to
/// hit — and so a wave reads as a fight rather than a formality.
@override@JsonKey() final  int monstersPerWave;
/// Stages before the chapter number goes up.
@override@JsonKey() final  int stagesPerChapter;
/// Ordinary monsters, cycled through as stages advance.
 final  List<String> _monsters;
/// Ordinary monsters, cycled through as stages advance.
@override@JsonKey() List<String> get monsters {
  if (_monsters is EqualUnmodifiableListView) return _monsters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monsters);
}

/// Bosses, cycled the same way.
 final  List<String> _bosses;
/// Bosses, cycled the same way.
@override@JsonKey() List<String> get bosses {
  if (_bosses is EqualUnmodifiableListView) return _bosses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bosses);
}

/// Monster level added per stage cleared.
///
/// This is the difficulty curve: monster health and damage already scale
/// exponentially with level, so this number decides how fast the wall
/// arrives.
@override@JsonKey() final  int levelPerStage;
/// Boss level on top of the stage level.
@override@JsonKey() final  int bossLevelBonus;

/// Create a copy of ProgressionConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressionConfigCopyWith<_ProgressionConfig> get copyWith => __$ProgressionConfigCopyWithImpl<_ProgressionConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgressionConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressionConfig&&(identical(other.wavesPerStage, wavesPerStage) || other.wavesPerStage == wavesPerStage)&&(identical(other.monstersPerWave, monstersPerWave) || other.monstersPerWave == monstersPerWave)&&(identical(other.stagesPerChapter, stagesPerChapter) || other.stagesPerChapter == stagesPerChapter)&&const DeepCollectionEquality().equals(other._monsters, _monsters)&&const DeepCollectionEquality().equals(other._bosses, _bosses)&&(identical(other.levelPerStage, levelPerStage) || other.levelPerStage == levelPerStage)&&(identical(other.bossLevelBonus, bossLevelBonus) || other.bossLevelBonus == bossLevelBonus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wavesPerStage,monstersPerWave,stagesPerChapter,const DeepCollectionEquality().hash(_monsters),const DeepCollectionEquality().hash(_bosses),levelPerStage,bossLevelBonus);

@override
String toString() {
  return 'ProgressionConfig(wavesPerStage: $wavesPerStage, monstersPerWave: $monstersPerWave, stagesPerChapter: $stagesPerChapter, monsters: $monsters, bosses: $bosses, levelPerStage: $levelPerStage, bossLevelBonus: $bossLevelBonus)';
}


}

/// @nodoc
abstract mixin class _$ProgressionConfigCopyWith<$Res> implements $ProgressionConfigCopyWith<$Res> {
  factory _$ProgressionConfigCopyWith(_ProgressionConfig value, $Res Function(_ProgressionConfig) _then) = __$ProgressionConfigCopyWithImpl;
@override @useResult
$Res call({
 int wavesPerStage, int monstersPerWave, int stagesPerChapter, List<String> monsters, List<String> bosses, int levelPerStage, int bossLevelBonus
});




}
/// @nodoc
class __$ProgressionConfigCopyWithImpl<$Res>
    implements _$ProgressionConfigCopyWith<$Res> {
  __$ProgressionConfigCopyWithImpl(this._self, this._then);

  final _ProgressionConfig _self;
  final $Res Function(_ProgressionConfig) _then;

/// Create a copy of ProgressionConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wavesPerStage = null,Object? monstersPerWave = null,Object? stagesPerChapter = null,Object? monsters = null,Object? bosses = null,Object? levelPerStage = null,Object? bossLevelBonus = null,}) {
  return _then(_ProgressionConfig(
wavesPerStage: null == wavesPerStage ? _self.wavesPerStage : wavesPerStage // ignore: cast_nullable_to_non_nullable
as int,monstersPerWave: null == monstersPerWave ? _self.monstersPerWave : monstersPerWave // ignore: cast_nullable_to_non_nullable
as int,stagesPerChapter: null == stagesPerChapter ? _self.stagesPerChapter : stagesPerChapter // ignore: cast_nullable_to_non_nullable
as int,monsters: null == monsters ? _self._monsters : monsters // ignore: cast_nullable_to_non_nullable
as List<String>,bosses: null == bosses ? _self._bosses : bosses // ignore: cast_nullable_to_non_nullable
as List<String>,levelPerStage: null == levelPerStage ? _self.levelPerStage : levelPerStage // ignore: cast_nullable_to_non_nullable
as int,bossLevelBonus: null == bossLevelBonus ? _self.bossLevelBonus : bossLevelBonus // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
