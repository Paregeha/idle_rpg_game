// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BalanceConfig {

 Map<String, GeneratorConfig> get generators;
/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceConfigCopyWith<BalanceConfig> get copyWith => _$BalanceConfigCopyWithImpl<BalanceConfig>(this as BalanceConfig, _$identity);

  /// Serializes this BalanceConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceConfig&&const DeepCollectionEquality().equals(other.generators, generators));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(generators));

@override
String toString() {
  return 'BalanceConfig(generators: $generators)';
}


}

/// @nodoc
abstract mixin class $BalanceConfigCopyWith<$Res>  {
  factory $BalanceConfigCopyWith(BalanceConfig value, $Res Function(BalanceConfig) _then) = _$BalanceConfigCopyWithImpl;
@useResult
$Res call({
 Map<String, GeneratorConfig> generators
});




}
/// @nodoc
class _$BalanceConfigCopyWithImpl<$Res>
    implements $BalanceConfigCopyWith<$Res> {
  _$BalanceConfigCopyWithImpl(this._self, this._then);

  final BalanceConfig _self;
  final $Res Function(BalanceConfig) _then;

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generators = null,}) {
  return _then(_self.copyWith(
generators: null == generators ? _self.generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorConfig>,
  ));
}

}


/// Adds pattern-matching-related methods to [BalanceConfig].
extension BalanceConfigPatterns on BalanceConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceConfig value)  $default,){
final _that = this;
switch (_that) {
case _BalanceConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, GeneratorConfig> generators)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
return $default(_that.generators);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, GeneratorConfig> generators)  $default,) {final _that = this;
switch (_that) {
case _BalanceConfig():
return $default(_that.generators);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, GeneratorConfig> generators)?  $default,) {final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
return $default(_that.generators);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceConfig implements BalanceConfig {
  const _BalanceConfig({final  Map<String, GeneratorConfig> generators = const <String, GeneratorConfig>{}}): _generators = generators;
  factory _BalanceConfig.fromJson(Map<String, dynamic> json) => _$BalanceConfigFromJson(json);

 final  Map<String, GeneratorConfig> _generators;
@override@JsonKey() Map<String, GeneratorConfig> get generators {
  if (_generators is EqualUnmodifiableMapView) return _generators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_generators);
}


/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceConfigCopyWith<_BalanceConfig> get copyWith => __$BalanceConfigCopyWithImpl<_BalanceConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceConfig&&const DeepCollectionEquality().equals(other._generators, _generators));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_generators));

@override
String toString() {
  return 'BalanceConfig(generators: $generators)';
}


}

/// @nodoc
abstract mixin class _$BalanceConfigCopyWith<$Res> implements $BalanceConfigCopyWith<$Res> {
  factory _$BalanceConfigCopyWith(_BalanceConfig value, $Res Function(_BalanceConfig) _then) = __$BalanceConfigCopyWithImpl;
@override @useResult
$Res call({
 Map<String, GeneratorConfig> generators
});




}
/// @nodoc
class __$BalanceConfigCopyWithImpl<$Res>
    implements _$BalanceConfigCopyWith<$Res> {
  __$BalanceConfigCopyWithImpl(this._self, this._then);

  final _BalanceConfig _self;
  final $Res Function(_BalanceConfig) _then;

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generators = null,}) {
  return _then(_BalanceConfig(
generators: null == generators ? _self._generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorConfig>,
  ));
}


}

// dart format on
