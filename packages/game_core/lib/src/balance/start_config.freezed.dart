// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartConfig {

/// Generators the player owns from the first second, by id and count.
 Map<String, int> get generators;/// Resources in the player's pocket at the start.
@BigNumConverter() Map<String, BigNum> get resources;
/// Create a copy of StartConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartConfigCopyWith<StartConfig> get copyWith => _$StartConfigCopyWithImpl<StartConfig>(this as StartConfig, _$identity);

  /// Serializes this StartConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartConfig&&const DeepCollectionEquality().equals(other.generators, generators)&&const DeepCollectionEquality().equals(other.resources, resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(generators),const DeepCollectionEquality().hash(resources));

@override
String toString() {
  return 'StartConfig(generators: $generators, resources: $resources)';
}


}

/// @nodoc
abstract mixin class $StartConfigCopyWith<$Res>  {
  factory $StartConfigCopyWith(StartConfig value, $Res Function(StartConfig) _then) = _$StartConfigCopyWithImpl;
@useResult
$Res call({
 Map<String, int> generators,@BigNumConverter() Map<String, BigNum> resources
});




}
/// @nodoc
class _$StartConfigCopyWithImpl<$Res>
    implements $StartConfigCopyWith<$Res> {
  _$StartConfigCopyWithImpl(this._self, this._then);

  final StartConfig _self;
  final $Res Function(StartConfig) _then;

/// Create a copy of StartConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generators = null,Object? resources = null,}) {
  return _then(_self.copyWith(
generators: null == generators ? _self.generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, int>,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,
  ));
}

}


/// Adds pattern-matching-related methods to [StartConfig].
extension StartConfigPatterns on StartConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartConfig value)  $default,){
final _that = this;
switch (_that) {
case _StartConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartConfig value)?  $default,){
final _that = this;
switch (_that) {
case _StartConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> generators, @BigNumConverter()  Map<String, BigNum> resources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartConfig() when $default != null:
return $default(_that.generators,_that.resources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> generators, @BigNumConverter()  Map<String, BigNum> resources)  $default,) {final _that = this;
switch (_that) {
case _StartConfig():
return $default(_that.generators,_that.resources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> generators, @BigNumConverter()  Map<String, BigNum> resources)?  $default,) {final _that = this;
switch (_that) {
case _StartConfig() when $default != null:
return $default(_that.generators,_that.resources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartConfig implements StartConfig {
  const _StartConfig({final  Map<String, int> generators = const <String, int>{}, @BigNumConverter() final  Map<String, BigNum> resources = const <String, BigNum>{}}): _generators = generators,_resources = resources;
  factory _StartConfig.fromJson(Map<String, dynamic> json) => _$StartConfigFromJson(json);

/// Generators the player owns from the first second, by id and count.
 final  Map<String, int> _generators;
/// Generators the player owns from the first second, by id and count.
@override@JsonKey() Map<String, int> get generators {
  if (_generators is EqualUnmodifiableMapView) return _generators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_generators);
}

/// Resources in the player's pocket at the start.
 final  Map<String, BigNum> _resources;
/// Resources in the player's pocket at the start.
@override@JsonKey()@BigNumConverter() Map<String, BigNum> get resources {
  if (_resources is EqualUnmodifiableMapView) return _resources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_resources);
}


/// Create a copy of StartConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartConfigCopyWith<_StartConfig> get copyWith => __$StartConfigCopyWithImpl<_StartConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartConfig&&const DeepCollectionEquality().equals(other._generators, _generators)&&const DeepCollectionEquality().equals(other._resources, _resources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_generators),const DeepCollectionEquality().hash(_resources));

@override
String toString() {
  return 'StartConfig(generators: $generators, resources: $resources)';
}


}

/// @nodoc
abstract mixin class _$StartConfigCopyWith<$Res> implements $StartConfigCopyWith<$Res> {
  factory _$StartConfigCopyWith(_StartConfig value, $Res Function(_StartConfig) _then) = __$StartConfigCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> generators,@BigNumConverter() Map<String, BigNum> resources
});




}
/// @nodoc
class __$StartConfigCopyWithImpl<$Res>
    implements _$StartConfigCopyWith<$Res> {
  __$StartConfigCopyWithImpl(this._self, this._then);

  final _StartConfig _self;
  final $Res Function(_StartConfig) _then;

/// Create a copy of StartConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generators = null,Object? resources = null,}) {
  return _then(_StartConfig(
generators: null == generators ? _self._generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, int>,resources: null == resources ? _self._resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,
  ));
}


}

// dart format on
