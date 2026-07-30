// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneratorState {

 int get level; int get owned;
/// Create a copy of GeneratorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratorStateCopyWith<GeneratorState> get copyWith => _$GeneratorStateCopyWithImpl<GeneratorState>(this as GeneratorState, _$identity);

  /// Serializes this GeneratorState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorState&&(identical(other.level, level) || other.level == level)&&(identical(other.owned, owned) || other.owned == owned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,owned);

@override
String toString() {
  return 'GeneratorState(level: $level, owned: $owned)';
}


}

/// @nodoc
abstract mixin class $GeneratorStateCopyWith<$Res>  {
  factory $GeneratorStateCopyWith(GeneratorState value, $Res Function(GeneratorState) _then) = _$GeneratorStateCopyWithImpl;
@useResult
$Res call({
 int level, int owned
});




}
/// @nodoc
class _$GeneratorStateCopyWithImpl<$Res>
    implements $GeneratorStateCopyWith<$Res> {
  _$GeneratorStateCopyWithImpl(this._self, this._then);

  final GeneratorState _self;
  final $Res Function(GeneratorState) _then;

/// Create a copy of GeneratorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? owned = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,owned: null == owned ? _self.owned : owned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratorState].
extension GeneratorStatePatterns on GeneratorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratorState value)  $default,){
final _that = this;
switch (_that) {
case _GeneratorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratorState value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  int owned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratorState() when $default != null:
return $default(_that.level,_that.owned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  int owned)  $default,) {final _that = this;
switch (_that) {
case _GeneratorState():
return $default(_that.level,_that.owned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  int owned)?  $default,) {final _that = this;
switch (_that) {
case _GeneratorState() when $default != null:
return $default(_that.level,_that.owned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratorState implements GeneratorState {
  const _GeneratorState({this.level = 0, this.owned = 0});
  factory _GeneratorState.fromJson(Map<String, dynamic> json) => _$GeneratorStateFromJson(json);

@override@JsonKey() final  int level;
@override@JsonKey() final  int owned;

/// Create a copy of GeneratorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratorStateCopyWith<_GeneratorState> get copyWith => __$GeneratorStateCopyWithImpl<_GeneratorState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratorStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratorState&&(identical(other.level, level) || other.level == level)&&(identical(other.owned, owned) || other.owned == owned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,owned);

@override
String toString() {
  return 'GeneratorState(level: $level, owned: $owned)';
}


}

/// @nodoc
abstract mixin class _$GeneratorStateCopyWith<$Res> implements $GeneratorStateCopyWith<$Res> {
  factory _$GeneratorStateCopyWith(_GeneratorState value, $Res Function(_GeneratorState) _then) = __$GeneratorStateCopyWithImpl;
@override @useResult
$Res call({
 int level, int owned
});




}
/// @nodoc
class __$GeneratorStateCopyWithImpl<$Res>
    implements _$GeneratorStateCopyWith<$Res> {
  __$GeneratorStateCopyWithImpl(this._self, this._then);

  final _GeneratorState _self;
  final $Res Function(_GeneratorState) _then;

/// Create a copy of GeneratorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? owned = null,}) {
  return _then(_GeneratorState(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,owned: null == owned ? _self.owned : owned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
