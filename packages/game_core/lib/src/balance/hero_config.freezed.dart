// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeroConfig {

@BigNumConverter() BigNum get baseAttack;@BigNumConverter() BigNum get baseHp;/// Attack and health are both multiplied by this per generator unit owned.
 double get perUnitMultiplier; double get attacksPerSecond; double get critChance; double get critFactor; double get mitigation; double get dodgeChance;/// Experience needed to reach level 1.
@BigNumConverter() BigNum get expBase;/// The requirement is multiplied by this per level already reached.
///
/// Above 1 so levels slow down; the curve is what stops a player from
/// out-levelling the content in an afternoon.
 double get expGrowth;/// Attack and health are multiplied by this per hero level.
 double get statPerLevel;
/// Create a copy of HeroConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeroConfigCopyWith<HeroConfig> get copyWith => _$HeroConfigCopyWithImpl<HeroConfig>(this as HeroConfig, _$identity);

  /// Serializes this HeroConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeroConfig&&(identical(other.baseAttack, baseAttack) || other.baseAttack == baseAttack)&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.perUnitMultiplier, perUnitMultiplier) || other.perUnitMultiplier == perUnitMultiplier)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.expBase, expBase) || other.expBase == expBase)&&(identical(other.expGrowth, expGrowth) || other.expGrowth == expGrowth)&&(identical(other.statPerLevel, statPerLevel) || other.statPerLevel == statPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseAttack,baseHp,perUnitMultiplier,attacksPerSecond,critChance,critFactor,mitigation,dodgeChance,expBase,expGrowth,statPerLevel);

@override
String toString() {
  return 'HeroConfig(baseAttack: $baseAttack, baseHp: $baseHp, perUnitMultiplier: $perUnitMultiplier, attacksPerSecond: $attacksPerSecond, critChance: $critChance, critFactor: $critFactor, mitigation: $mitigation, dodgeChance: $dodgeChance, expBase: $expBase, expGrowth: $expGrowth, statPerLevel: $statPerLevel)';
}


}

/// @nodoc
abstract mixin class $HeroConfigCopyWith<$Res>  {
  factory $HeroConfigCopyWith(HeroConfig value, $Res Function(HeroConfig) _then) = _$HeroConfigCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum baseAttack,@BigNumConverter() BigNum baseHp, double perUnitMultiplier, double attacksPerSecond, double critChance, double critFactor, double mitigation, double dodgeChance,@BigNumConverter() BigNum expBase, double expGrowth, double statPerLevel
});




}
/// @nodoc
class _$HeroConfigCopyWithImpl<$Res>
    implements $HeroConfigCopyWith<$Res> {
  _$HeroConfigCopyWithImpl(this._self, this._then);

  final HeroConfig _self;
  final $Res Function(HeroConfig) _then;

/// Create a copy of HeroConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseAttack = null,Object? baseHp = null,Object? perUnitMultiplier = null,Object? attacksPerSecond = null,Object? critChance = null,Object? critFactor = null,Object? mitigation = null,Object? dodgeChance = null,Object? expBase = null,Object? expGrowth = null,Object? statPerLevel = null,}) {
  return _then(_self.copyWith(
baseAttack: null == baseAttack ? _self.baseAttack : baseAttack // ignore: cast_nullable_to_non_nullable
as BigNum,baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,perUnitMultiplier: null == perUnitMultiplier ? _self.perUnitMultiplier : perUnitMultiplier // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,expBase: null == expBase ? _self.expBase : expBase // ignore: cast_nullable_to_non_nullable
as BigNum,expGrowth: null == expGrowth ? _self.expGrowth : expGrowth // ignore: cast_nullable_to_non_nullable
as double,statPerLevel: null == statPerLevel ? _self.statPerLevel : statPerLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [HeroConfig].
extension HeroConfigPatterns on HeroConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeroConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeroConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeroConfig value)  $default,){
final _that = this;
switch (_that) {
case _HeroConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeroConfig value)?  $default,){
final _that = this;
switch (_that) {
case _HeroConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseAttack, @BigNumConverter()  BigNum baseHp,  double perUnitMultiplier,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double statPerLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeroConfig() when $default != null:
return $default(_that.baseAttack,_that.baseHp,_that.perUnitMultiplier,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.statPerLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseAttack, @BigNumConverter()  BigNum baseHp,  double perUnitMultiplier,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double statPerLevel)  $default,) {final _that = this;
switch (_that) {
case _HeroConfig():
return $default(_that.baseAttack,_that.baseHp,_that.perUnitMultiplier,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.statPerLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum baseAttack, @BigNumConverter()  BigNum baseHp,  double perUnitMultiplier,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double statPerLevel)?  $default,) {final _that = this;
switch (_that) {
case _HeroConfig() when $default != null:
return $default(_that.baseAttack,_that.baseHp,_that.perUnitMultiplier,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.statPerLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeroConfig extends HeroConfig {
  const _HeroConfig({@BigNumConverter() this.baseAttack = BigNum.one, @BigNumConverter() this.baseHp = BigNum.one, this.perUnitMultiplier = 1.05, this.attacksPerSecond = 1.0, this.critChance = 0.1, this.critFactor = 2.0, this.mitigation = 0.0, this.dodgeChance = 0.05, @BigNumConverter() this.expBase = BigNum.one, this.expGrowth = 1.35, this.statPerLevel = 1.08}): super._();
  factory _HeroConfig.fromJson(Map<String, dynamic> json) => _$HeroConfigFromJson(json);

@override@JsonKey()@BigNumConverter() final  BigNum baseAttack;
@override@JsonKey()@BigNumConverter() final  BigNum baseHp;
/// Attack and health are both multiplied by this per generator unit owned.
@override@JsonKey() final  double perUnitMultiplier;
@override@JsonKey() final  double attacksPerSecond;
@override@JsonKey() final  double critChance;
@override@JsonKey() final  double critFactor;
@override@JsonKey() final  double mitigation;
@override@JsonKey() final  double dodgeChance;
/// Experience needed to reach level 1.
@override@JsonKey()@BigNumConverter() final  BigNum expBase;
/// The requirement is multiplied by this per level already reached.
///
/// Above 1 so levels slow down; the curve is what stops a player from
/// out-levelling the content in an afternoon.
@override@JsonKey() final  double expGrowth;
/// Attack and health are multiplied by this per hero level.
@override@JsonKey() final  double statPerLevel;

/// Create a copy of HeroConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeroConfigCopyWith<_HeroConfig> get copyWith => __$HeroConfigCopyWithImpl<_HeroConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeroConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeroConfig&&(identical(other.baseAttack, baseAttack) || other.baseAttack == baseAttack)&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.perUnitMultiplier, perUnitMultiplier) || other.perUnitMultiplier == perUnitMultiplier)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.expBase, expBase) || other.expBase == expBase)&&(identical(other.expGrowth, expGrowth) || other.expGrowth == expGrowth)&&(identical(other.statPerLevel, statPerLevel) || other.statPerLevel == statPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseAttack,baseHp,perUnitMultiplier,attacksPerSecond,critChance,critFactor,mitigation,dodgeChance,expBase,expGrowth,statPerLevel);

@override
String toString() {
  return 'HeroConfig(baseAttack: $baseAttack, baseHp: $baseHp, perUnitMultiplier: $perUnitMultiplier, attacksPerSecond: $attacksPerSecond, critChance: $critChance, critFactor: $critFactor, mitigation: $mitigation, dodgeChance: $dodgeChance, expBase: $expBase, expGrowth: $expGrowth, statPerLevel: $statPerLevel)';
}


}

/// @nodoc
abstract mixin class _$HeroConfigCopyWith<$Res> implements $HeroConfigCopyWith<$Res> {
  factory _$HeroConfigCopyWith(_HeroConfig value, $Res Function(_HeroConfig) _then) = __$HeroConfigCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum baseAttack,@BigNumConverter() BigNum baseHp, double perUnitMultiplier, double attacksPerSecond, double critChance, double critFactor, double mitigation, double dodgeChance,@BigNumConverter() BigNum expBase, double expGrowth, double statPerLevel
});




}
/// @nodoc
class __$HeroConfigCopyWithImpl<$Res>
    implements _$HeroConfigCopyWith<$Res> {
  __$HeroConfigCopyWithImpl(this._self, this._then);

  final _HeroConfig _self;
  final $Res Function(_HeroConfig) _then;

/// Create a copy of HeroConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseAttack = null,Object? baseHp = null,Object? perUnitMultiplier = null,Object? attacksPerSecond = null,Object? critChance = null,Object? critFactor = null,Object? mitigation = null,Object? dodgeChance = null,Object? expBase = null,Object? expGrowth = null,Object? statPerLevel = null,}) {
  return _then(_HeroConfig(
baseAttack: null == baseAttack ? _self.baseAttack : baseAttack // ignore: cast_nullable_to_non_nullable
as BigNum,baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,perUnitMultiplier: null == perUnitMultiplier ? _self.perUnitMultiplier : perUnitMultiplier // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,expBase: null == expBase ? _self.expBase : expBase // ignore: cast_nullable_to_non_nullable
as BigNum,expGrowth: null == expGrowth ? _self.expGrowth : expGrowth // ignore: cast_nullable_to_non_nullable
as double,statPerLevel: null == statPerLevel ? _self.statPerLevel : statPerLevel // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
