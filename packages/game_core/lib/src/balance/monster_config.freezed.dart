// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monster_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonsterConfig {

/// Health at level 0.
@BigNumConverter() BigNum get baseHp;/// Health is multiplied by this per level.
 double get hpGrowth;/// Reward for a kill at level 0.
@BigNumConverter() BigNum get rewardBase;/// Reward is multiplied by this per level.
 double get rewardGrowth;/// Probability in `0..1` that a kill drops an item.
 double get dropChance;
/// Create a copy of MonsterConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonsterConfigCopyWith<MonsterConfig> get copyWith => _$MonsterConfigCopyWithImpl<MonsterConfig>(this as MonsterConfig, _$identity);

  /// Serializes this MonsterConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterConfig&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.hpGrowth, hpGrowth) || other.hpGrowth == hpGrowth)&&(identical(other.rewardBase, rewardBase) || other.rewardBase == rewardBase)&&(identical(other.rewardGrowth, rewardGrowth) || other.rewardGrowth == rewardGrowth)&&(identical(other.dropChance, dropChance) || other.dropChance == dropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseHp,hpGrowth,rewardBase,rewardGrowth,dropChance);

@override
String toString() {
  return 'MonsterConfig(baseHp: $baseHp, hpGrowth: $hpGrowth, rewardBase: $rewardBase, rewardGrowth: $rewardGrowth, dropChance: $dropChance)';
}


}

/// @nodoc
abstract mixin class $MonsterConfigCopyWith<$Res>  {
  factory $MonsterConfigCopyWith(MonsterConfig value, $Res Function(MonsterConfig) _then) = _$MonsterConfigCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum baseHp, double hpGrowth,@BigNumConverter() BigNum rewardBase, double rewardGrowth, double dropChance
});




}
/// @nodoc
class _$MonsterConfigCopyWithImpl<$Res>
    implements $MonsterConfigCopyWith<$Res> {
  _$MonsterConfigCopyWithImpl(this._self, this._then);

  final MonsterConfig _self;
  final $Res Function(MonsterConfig) _then;

/// Create a copy of MonsterConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseHp = null,Object? hpGrowth = null,Object? rewardBase = null,Object? rewardGrowth = null,Object? dropChance = null,}) {
  return _then(_self.copyWith(
baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,hpGrowth: null == hpGrowth ? _self.hpGrowth : hpGrowth // ignore: cast_nullable_to_non_nullable
as double,rewardBase: null == rewardBase ? _self.rewardBase : rewardBase // ignore: cast_nullable_to_non_nullable
as BigNum,rewardGrowth: null == rewardGrowth ? _self.rewardGrowth : rewardGrowth // ignore: cast_nullable_to_non_nullable
as double,dropChance: null == dropChance ? _self.dropChance : dropChance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonsterConfig].
extension MonsterConfigPatterns on MonsterConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonsterConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonsterConfig value)  $default,){
final _that = this;
switch (_that) {
case _MonsterConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonsterConfig value)?  $default,){
final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth,  double dropChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.dropChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth,  double dropChance)  $default,) {final _that = this;
switch (_that) {
case _MonsterConfig():
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.dropChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth,  double dropChance)?  $default,) {final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.dropChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterConfig extends MonsterConfig {
  const _MonsterConfig({@BigNumConverter() required this.baseHp, required this.hpGrowth, @BigNumConverter() required this.rewardBase, required this.rewardGrowth, this.dropChance = 0.0}): super._();
  factory _MonsterConfig.fromJson(Map<String, dynamic> json) => _$MonsterConfigFromJson(json);

/// Health at level 0.
@override@BigNumConverter() final  BigNum baseHp;
/// Health is multiplied by this per level.
@override final  double hpGrowth;
/// Reward for a kill at level 0.
@override@BigNumConverter() final  BigNum rewardBase;
/// Reward is multiplied by this per level.
@override final  double rewardGrowth;
/// Probability in `0..1` that a kill drops an item.
@override@JsonKey() final  double dropChance;

/// Create a copy of MonsterConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonsterConfigCopyWith<_MonsterConfig> get copyWith => __$MonsterConfigCopyWithImpl<_MonsterConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonsterConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterConfig&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.hpGrowth, hpGrowth) || other.hpGrowth == hpGrowth)&&(identical(other.rewardBase, rewardBase) || other.rewardBase == rewardBase)&&(identical(other.rewardGrowth, rewardGrowth) || other.rewardGrowth == rewardGrowth)&&(identical(other.dropChance, dropChance) || other.dropChance == dropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseHp,hpGrowth,rewardBase,rewardGrowth,dropChance);

@override
String toString() {
  return 'MonsterConfig(baseHp: $baseHp, hpGrowth: $hpGrowth, rewardBase: $rewardBase, rewardGrowth: $rewardGrowth, dropChance: $dropChance)';
}


}

/// @nodoc
abstract mixin class _$MonsterConfigCopyWith<$Res> implements $MonsterConfigCopyWith<$Res> {
  factory _$MonsterConfigCopyWith(_MonsterConfig value, $Res Function(_MonsterConfig) _then) = __$MonsterConfigCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum baseHp, double hpGrowth,@BigNumConverter() BigNum rewardBase, double rewardGrowth, double dropChance
});




}
/// @nodoc
class __$MonsterConfigCopyWithImpl<$Res>
    implements _$MonsterConfigCopyWith<$Res> {
  __$MonsterConfigCopyWithImpl(this._self, this._then);

  final _MonsterConfig _self;
  final $Res Function(_MonsterConfig) _then;

/// Create a copy of MonsterConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseHp = null,Object? hpGrowth = null,Object? rewardBase = null,Object? rewardGrowth = null,Object? dropChance = null,}) {
  return _then(_MonsterConfig(
baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,hpGrowth: null == hpGrowth ? _self.hpGrowth : hpGrowth // ignore: cast_nullable_to_non_nullable
as double,rewardBase: null == rewardBase ? _self.rewardBase : rewardBase // ignore: cast_nullable_to_non_nullable
as BigNum,rewardGrowth: null == rewardGrowth ? _self.rewardGrowth : rewardGrowth // ignore: cast_nullable_to_non_nullable
as double,dropChance: null == dropChance ? _self.dropChance : dropChance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
