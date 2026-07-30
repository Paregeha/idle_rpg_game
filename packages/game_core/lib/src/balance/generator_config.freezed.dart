// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneratorConfig {

/// Key of the resource this generator adds to.
 String get produces;/// Output per second for a single unit at level 0.
@BigNumConverter() BigNum get baseRatePerSecond;/// Rate is multiplied by this, raised to the generator's level.
 double get levelMultiplier;/// Price of the first unit.
@BigNumConverter() BigNum get costBase;/// Price is multiplied by this for each unit already owned.
 double get costGrowth;
/// Create a copy of GeneratorConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratorConfigCopyWith<GeneratorConfig> get copyWith => _$GeneratorConfigCopyWithImpl<GeneratorConfig>(this as GeneratorConfig, _$identity);

  /// Serializes this GeneratorConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorConfig&&(identical(other.produces, produces) || other.produces == produces)&&(identical(other.baseRatePerSecond, baseRatePerSecond) || other.baseRatePerSecond == baseRatePerSecond)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.costBase, costBase) || other.costBase == costBase)&&(identical(other.costGrowth, costGrowth) || other.costGrowth == costGrowth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,produces,baseRatePerSecond,levelMultiplier,costBase,costGrowth);

@override
String toString() {
  return 'GeneratorConfig(produces: $produces, baseRatePerSecond: $baseRatePerSecond, levelMultiplier: $levelMultiplier, costBase: $costBase, costGrowth: $costGrowth)';
}


}

/// @nodoc
abstract mixin class $GeneratorConfigCopyWith<$Res>  {
  factory $GeneratorConfigCopyWith(GeneratorConfig value, $Res Function(GeneratorConfig) _then) = _$GeneratorConfigCopyWithImpl;
@useResult
$Res call({
 String produces,@BigNumConverter() BigNum baseRatePerSecond, double levelMultiplier,@BigNumConverter() BigNum costBase, double costGrowth
});




}
/// @nodoc
class _$GeneratorConfigCopyWithImpl<$Res>
    implements $GeneratorConfigCopyWith<$Res> {
  _$GeneratorConfigCopyWithImpl(this._self, this._then);

  final GeneratorConfig _self;
  final $Res Function(GeneratorConfig) _then;

/// Create a copy of GeneratorConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? produces = null,Object? baseRatePerSecond = null,Object? levelMultiplier = null,Object? costBase = null,Object? costGrowth = null,}) {
  return _then(_self.copyWith(
produces: null == produces ? _self.produces : produces // ignore: cast_nullable_to_non_nullable
as String,baseRatePerSecond: null == baseRatePerSecond ? _self.baseRatePerSecond : baseRatePerSecond // ignore: cast_nullable_to_non_nullable
as BigNum,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,costBase: null == costBase ? _self.costBase : costBase // ignore: cast_nullable_to_non_nullable
as BigNum,costGrowth: null == costGrowth ? _self.costGrowth : costGrowth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratorConfig].
extension GeneratorConfigPatterns on GeneratorConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratorConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratorConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratorConfig value)  $default,){
final _that = this;
switch (_that) {
case _GeneratorConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratorConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratorConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String produces, @BigNumConverter()  BigNum baseRatePerSecond,  double levelMultiplier, @BigNumConverter()  BigNum costBase,  double costGrowth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratorConfig() when $default != null:
return $default(_that.produces,_that.baseRatePerSecond,_that.levelMultiplier,_that.costBase,_that.costGrowth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String produces, @BigNumConverter()  BigNum baseRatePerSecond,  double levelMultiplier, @BigNumConverter()  BigNum costBase,  double costGrowth)  $default,) {final _that = this;
switch (_that) {
case _GeneratorConfig():
return $default(_that.produces,_that.baseRatePerSecond,_that.levelMultiplier,_that.costBase,_that.costGrowth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String produces, @BigNumConverter()  BigNum baseRatePerSecond,  double levelMultiplier, @BigNumConverter()  BigNum costBase,  double costGrowth)?  $default,) {final _that = this;
switch (_that) {
case _GeneratorConfig() when $default != null:
return $default(_that.produces,_that.baseRatePerSecond,_that.levelMultiplier,_that.costBase,_that.costGrowth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratorConfig extends GeneratorConfig {
  const _GeneratorConfig({required this.produces, @BigNumConverter() required this.baseRatePerSecond, this.levelMultiplier = 1.0, @BigNumConverter() this.costBase = BigNum.one, this.costGrowth = 1.07}): super._();
  factory _GeneratorConfig.fromJson(Map<String, dynamic> json) => _$GeneratorConfigFromJson(json);

/// Key of the resource this generator adds to.
@override final  String produces;
/// Output per second for a single unit at level 0.
@override@BigNumConverter() final  BigNum baseRatePerSecond;
/// Rate is multiplied by this, raised to the generator's level.
@override@JsonKey() final  double levelMultiplier;
/// Price of the first unit.
@override@JsonKey()@BigNumConverter() final  BigNum costBase;
/// Price is multiplied by this for each unit already owned.
@override@JsonKey() final  double costGrowth;

/// Create a copy of GeneratorConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratorConfigCopyWith<_GeneratorConfig> get copyWith => __$GeneratorConfigCopyWithImpl<_GeneratorConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratorConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratorConfig&&(identical(other.produces, produces) || other.produces == produces)&&(identical(other.baseRatePerSecond, baseRatePerSecond) || other.baseRatePerSecond == baseRatePerSecond)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.costBase, costBase) || other.costBase == costBase)&&(identical(other.costGrowth, costGrowth) || other.costGrowth == costGrowth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,produces,baseRatePerSecond,levelMultiplier,costBase,costGrowth);

@override
String toString() {
  return 'GeneratorConfig(produces: $produces, baseRatePerSecond: $baseRatePerSecond, levelMultiplier: $levelMultiplier, costBase: $costBase, costGrowth: $costGrowth)';
}


}

/// @nodoc
abstract mixin class _$GeneratorConfigCopyWith<$Res> implements $GeneratorConfigCopyWith<$Res> {
  factory _$GeneratorConfigCopyWith(_GeneratorConfig value, $Res Function(_GeneratorConfig) _then) = __$GeneratorConfigCopyWithImpl;
@override @useResult
$Res call({
 String produces,@BigNumConverter() BigNum baseRatePerSecond, double levelMultiplier,@BigNumConverter() BigNum costBase, double costGrowth
});




}
/// @nodoc
class __$GeneratorConfigCopyWithImpl<$Res>
    implements _$GeneratorConfigCopyWith<$Res> {
  __$GeneratorConfigCopyWithImpl(this._self, this._then);

  final _GeneratorConfig _self;
  final $Res Function(_GeneratorConfig) _then;

/// Create a copy of GeneratorConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? produces = null,Object? baseRatePerSecond = null,Object? levelMultiplier = null,Object? costBase = null,Object? costGrowth = null,}) {
  return _then(_GeneratorConfig(
produces: null == produces ? _self.produces : produces // ignore: cast_nullable_to_non_nullable
as String,baseRatePerSecond: null == baseRatePerSecond ? _self.baseRatePerSecond : baseRatePerSecond // ignore: cast_nullable_to_non_nullable
as BigNum,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,costBase: null == costBase ? _self.costBase : costBase // ignore: cast_nullable_to_non_nullable
as BigNum,costGrowth: null == costGrowth ? _self.costGrowth : costGrowth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
