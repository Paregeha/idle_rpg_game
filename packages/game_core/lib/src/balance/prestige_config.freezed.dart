// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prestige_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrestigeConfig {

/// Which resource's lifetime earnings decide the award.
 String get resource;/// Earnings below this award nothing.
@BigNumConverter() BigNum get currencyBase;/// Exponent on the ratio. Below 1 it compresses runaway runs, which is
/// what keeps a single very long run from being worth more than several
/// deliberate ones.
 double get currencyExponent;/// Production multiplier gained per point of prestige currency.
@BigNumConverter() BigNum get bonusPerPoint;
/// Create a copy of PrestigeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrestigeConfigCopyWith<PrestigeConfig> get copyWith => _$PrestigeConfigCopyWithImpl<PrestigeConfig>(this as PrestigeConfig, _$identity);

  /// Serializes this PrestigeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrestigeConfig&&(identical(other.resource, resource) || other.resource == resource)&&(identical(other.currencyBase, currencyBase) || other.currencyBase == currencyBase)&&(identical(other.currencyExponent, currencyExponent) || other.currencyExponent == currencyExponent)&&(identical(other.bonusPerPoint, bonusPerPoint) || other.bonusPerPoint == bonusPerPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resource,currencyBase,currencyExponent,bonusPerPoint);

@override
String toString() {
  return 'PrestigeConfig(resource: $resource, currencyBase: $currencyBase, currencyExponent: $currencyExponent, bonusPerPoint: $bonusPerPoint)';
}


}

/// @nodoc
abstract mixin class $PrestigeConfigCopyWith<$Res>  {
  factory $PrestigeConfigCopyWith(PrestigeConfig value, $Res Function(PrestigeConfig) _then) = _$PrestigeConfigCopyWithImpl;
@useResult
$Res call({
 String resource,@BigNumConverter() BigNum currencyBase, double currencyExponent,@BigNumConverter() BigNum bonusPerPoint
});




}
/// @nodoc
class _$PrestigeConfigCopyWithImpl<$Res>
    implements $PrestigeConfigCopyWith<$Res> {
  _$PrestigeConfigCopyWithImpl(this._self, this._then);

  final PrestigeConfig _self;
  final $Res Function(PrestigeConfig) _then;

/// Create a copy of PrestigeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resource = null,Object? currencyBase = null,Object? currencyExponent = null,Object? bonusPerPoint = null,}) {
  return _then(_self.copyWith(
resource: null == resource ? _self.resource : resource // ignore: cast_nullable_to_non_nullable
as String,currencyBase: null == currencyBase ? _self.currencyBase : currencyBase // ignore: cast_nullable_to_non_nullable
as BigNum,currencyExponent: null == currencyExponent ? _self.currencyExponent : currencyExponent // ignore: cast_nullable_to_non_nullable
as double,bonusPerPoint: null == bonusPerPoint ? _self.bonusPerPoint : bonusPerPoint // ignore: cast_nullable_to_non_nullable
as BigNum,
  ));
}

}


/// Adds pattern-matching-related methods to [PrestigeConfig].
extension PrestigeConfigPatterns on PrestigeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrestigeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrestigeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrestigeConfig value)  $default,){
final _that = this;
switch (_that) {
case _PrestigeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrestigeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PrestigeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String resource, @BigNumConverter()  BigNum currencyBase,  double currencyExponent, @BigNumConverter()  BigNum bonusPerPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrestigeConfig() when $default != null:
return $default(_that.resource,_that.currencyBase,_that.currencyExponent,_that.bonusPerPoint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String resource, @BigNumConverter()  BigNum currencyBase,  double currencyExponent, @BigNumConverter()  BigNum bonusPerPoint)  $default,) {final _that = this;
switch (_that) {
case _PrestigeConfig():
return $default(_that.resource,_that.currencyBase,_that.currencyExponent,_that.bonusPerPoint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String resource, @BigNumConverter()  BigNum currencyBase,  double currencyExponent, @BigNumConverter()  BigNum bonusPerPoint)?  $default,) {final _that = this;
switch (_that) {
case _PrestigeConfig() when $default != null:
return $default(_that.resource,_that.currencyBase,_that.currencyExponent,_that.bonusPerPoint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrestigeConfig implements PrestigeConfig {
  const _PrestigeConfig({this.resource = 'gold', @BigNumConverter() this.currencyBase = BigNum.one, this.currencyExponent = 0.5, @BigNumConverter() this.bonusPerPoint = BigNum.zero});
  factory _PrestigeConfig.fromJson(Map<String, dynamic> json) => _$PrestigeConfigFromJson(json);

/// Which resource's lifetime earnings decide the award.
@override@JsonKey() final  String resource;
/// Earnings below this award nothing.
@override@JsonKey()@BigNumConverter() final  BigNum currencyBase;
/// Exponent on the ratio. Below 1 it compresses runaway runs, which is
/// what keeps a single very long run from being worth more than several
/// deliberate ones.
@override@JsonKey() final  double currencyExponent;
/// Production multiplier gained per point of prestige currency.
@override@JsonKey()@BigNumConverter() final  BigNum bonusPerPoint;

/// Create a copy of PrestigeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrestigeConfigCopyWith<_PrestigeConfig> get copyWith => __$PrestigeConfigCopyWithImpl<_PrestigeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrestigeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrestigeConfig&&(identical(other.resource, resource) || other.resource == resource)&&(identical(other.currencyBase, currencyBase) || other.currencyBase == currencyBase)&&(identical(other.currencyExponent, currencyExponent) || other.currencyExponent == currencyExponent)&&(identical(other.bonusPerPoint, bonusPerPoint) || other.bonusPerPoint == bonusPerPoint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resource,currencyBase,currencyExponent,bonusPerPoint);

@override
String toString() {
  return 'PrestigeConfig(resource: $resource, currencyBase: $currencyBase, currencyExponent: $currencyExponent, bonusPerPoint: $bonusPerPoint)';
}


}

/// @nodoc
abstract mixin class _$PrestigeConfigCopyWith<$Res> implements $PrestigeConfigCopyWith<$Res> {
  factory _$PrestigeConfigCopyWith(_PrestigeConfig value, $Res Function(_PrestigeConfig) _then) = __$PrestigeConfigCopyWithImpl;
@override @useResult
$Res call({
 String resource,@BigNumConverter() BigNum currencyBase, double currencyExponent,@BigNumConverter() BigNum bonusPerPoint
});




}
/// @nodoc
class __$PrestigeConfigCopyWithImpl<$Res>
    implements _$PrestigeConfigCopyWith<$Res> {
  __$PrestigeConfigCopyWithImpl(this._self, this._then);

  final _PrestigeConfig _self;
  final $Res Function(_PrestigeConfig) _then;

/// Create a copy of PrestigeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resource = null,Object? currencyBase = null,Object? currencyExponent = null,Object? bonusPerPoint = null,}) {
  return _then(_PrestigeConfig(
resource: null == resource ? _self.resource : resource // ignore: cast_nullable_to_non_nullable
as String,currencyBase: null == currencyBase ? _self.currencyBase : currencyBase // ignore: cast_nullable_to_non_nullable
as BigNum,currencyExponent: null == currencyExponent ? _self.currencyExponent : currencyExponent // ignore: cast_nullable_to_non_nullable
as double,bonusPerPoint: null == bonusPerPoint ? _self.bonusPerPoint : bonusPerPoint // ignore: cast_nullable_to_non_nullable
as BigNum,
  ));
}


}

// dart format on
