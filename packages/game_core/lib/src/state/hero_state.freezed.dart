// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeroState {

 String get id; int get level; int get experience;
/// Create a copy of HeroState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeroStateCopyWith<HeroState> get copyWith => _$HeroStateCopyWithImpl<HeroState>(this as HeroState, _$identity);

  /// Serializes this HeroState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeroState&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.experience, experience) || other.experience == experience));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,experience);

@override
String toString() {
  return 'HeroState(id: $id, level: $level, experience: $experience)';
}


}

/// @nodoc
abstract mixin class $HeroStateCopyWith<$Res>  {
  factory $HeroStateCopyWith(HeroState value, $Res Function(HeroState) _then) = _$HeroStateCopyWithImpl;
@useResult
$Res call({
 String id, int level, int experience
});




}
/// @nodoc
class _$HeroStateCopyWithImpl<$Res>
    implements $HeroStateCopyWith<$Res> {
  _$HeroStateCopyWithImpl(this._self, this._then);

  final HeroState _self;
  final $Res Function(HeroState) _then;

/// Create a copy of HeroState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? level = null,Object? experience = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HeroState].
extension HeroStatePatterns on HeroState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeroState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeroState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeroState value)  $default,){
final _that = this;
switch (_that) {
case _HeroState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeroState value)?  $default,){
final _that = this;
switch (_that) {
case _HeroState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int level,  int experience)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeroState() when $default != null:
return $default(_that.id,_that.level,_that.experience);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int level,  int experience)  $default,) {final _that = this;
switch (_that) {
case _HeroState():
return $default(_that.id,_that.level,_that.experience);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int level,  int experience)?  $default,) {final _that = this;
switch (_that) {
case _HeroState() when $default != null:
return $default(_that.id,_that.level,_that.experience);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeroState implements HeroState {
  const _HeroState({required this.id, this.level = 1, this.experience = 0});
  factory _HeroState.fromJson(Map<String, dynamic> json) => _$HeroStateFromJson(json);

@override final  String id;
@override@JsonKey() final  int level;
@override@JsonKey() final  int experience;

/// Create a copy of HeroState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeroStateCopyWith<_HeroState> get copyWith => __$HeroStateCopyWithImpl<_HeroState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeroStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeroState&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.experience, experience) || other.experience == experience));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,experience);

@override
String toString() {
  return 'HeroState(id: $id, level: $level, experience: $experience)';
}


}

/// @nodoc
abstract mixin class _$HeroStateCopyWith<$Res> implements $HeroStateCopyWith<$Res> {
  factory _$HeroStateCopyWith(_HeroState value, $Res Function(_HeroState) _then) = __$HeroStateCopyWithImpl;
@override @useResult
$Res call({
 String id, int level, int experience
});




}
/// @nodoc
class __$HeroStateCopyWithImpl<$Res>
    implements _$HeroStateCopyWith<$Res> {
  __$HeroStateCopyWithImpl(this._self, this._then);

  final _HeroState _self;
  final $Res Function(_HeroState) _then;

/// Create a copy of HeroState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? level = null,Object? experience = null,}) {
  return _then(_HeroState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
