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
 double get rewardGrowth;/// Damage of one swing at level 0.
@BigNumConverter() BigNum get baseAttack;/// Attack is multiplied by this per level.
 double get attackGrowth;/// Swings per second.
 double get attacksPerSecond;/// Fraction of incoming damage absorbed, in `0..1`.
 double get mitigation;/// Probability in `0..1` of dodging a swing.
 double get dodgeChance;/// Experience for a kill at level 0.
///
/// Separate from the gold reward: levelling and earning are different
/// pacing levers, and tying them together removes one of them.
@BigNumConverter() BigNum get expBase;/// Experience is multiplied by this per level.
 double get expGrowth;/// Probability in `0..1` that a kill drops an item.
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonsterConfig&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.hpGrowth, hpGrowth) || other.hpGrowth == hpGrowth)&&(identical(other.rewardBase, rewardBase) || other.rewardBase == rewardBase)&&(identical(other.rewardGrowth, rewardGrowth) || other.rewardGrowth == rewardGrowth)&&(identical(other.baseAttack, baseAttack) || other.baseAttack == baseAttack)&&(identical(other.attackGrowth, attackGrowth) || other.attackGrowth == attackGrowth)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.expBase, expBase) || other.expBase == expBase)&&(identical(other.expGrowth, expGrowth) || other.expGrowth == expGrowth)&&(identical(other.dropChance, dropChance) || other.dropChance == dropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseHp,hpGrowth,rewardBase,rewardGrowth,baseAttack,attackGrowth,attacksPerSecond,mitigation,dodgeChance,expBase,expGrowth,dropChance);

@override
String toString() {
  return 'MonsterConfig(baseHp: $baseHp, hpGrowth: $hpGrowth, rewardBase: $rewardBase, rewardGrowth: $rewardGrowth, baseAttack: $baseAttack, attackGrowth: $attackGrowth, attacksPerSecond: $attacksPerSecond, mitigation: $mitigation, dodgeChance: $dodgeChance, expBase: $expBase, expGrowth: $expGrowth, dropChance: $dropChance)';
}


}

/// @nodoc
abstract mixin class $MonsterConfigCopyWith<$Res>  {
  factory $MonsterConfigCopyWith(MonsterConfig value, $Res Function(MonsterConfig) _then) = _$MonsterConfigCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum baseHp, double hpGrowth,@BigNumConverter() BigNum rewardBase, double rewardGrowth,@BigNumConverter() BigNum baseAttack, double attackGrowth, double attacksPerSecond, double mitigation, double dodgeChance,@BigNumConverter() BigNum expBase, double expGrowth, double dropChance
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
@pragma('vm:prefer-inline') @override $Res call({Object? baseHp = null,Object? hpGrowth = null,Object? rewardBase = null,Object? rewardGrowth = null,Object? baseAttack = null,Object? attackGrowth = null,Object? attacksPerSecond = null,Object? mitigation = null,Object? dodgeChance = null,Object? expBase = null,Object? expGrowth = null,Object? dropChance = null,}) {
  return _then(_self.copyWith(
baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,hpGrowth: null == hpGrowth ? _self.hpGrowth : hpGrowth // ignore: cast_nullable_to_non_nullable
as double,rewardBase: null == rewardBase ? _self.rewardBase : rewardBase // ignore: cast_nullable_to_non_nullable
as BigNum,rewardGrowth: null == rewardGrowth ? _self.rewardGrowth : rewardGrowth // ignore: cast_nullable_to_non_nullable
as double,baseAttack: null == baseAttack ? _self.baseAttack : baseAttack // ignore: cast_nullable_to_non_nullable
as BigNum,attackGrowth: null == attackGrowth ? _self.attackGrowth : attackGrowth // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,expBase: null == expBase ? _self.expBase : expBase // ignore: cast_nullable_to_non_nullable
as BigNum,expGrowth: null == expGrowth ? _self.expGrowth : expGrowth // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth, @BigNumConverter()  BigNum baseAttack,  double attackGrowth,  double attacksPerSecond,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double dropChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.baseAttack,_that.attackGrowth,_that.attacksPerSecond,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.dropChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth, @BigNumConverter()  BigNum baseAttack,  double attackGrowth,  double attacksPerSecond,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double dropChance)  $default,) {final _that = this;
switch (_that) {
case _MonsterConfig():
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.baseAttack,_that.attackGrowth,_that.attacksPerSecond,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.dropChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum baseHp,  double hpGrowth, @BigNumConverter()  BigNum rewardBase,  double rewardGrowth, @BigNumConverter()  BigNum baseAttack,  double attackGrowth,  double attacksPerSecond,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum expBase,  double expGrowth,  double dropChance)?  $default,) {final _that = this;
switch (_that) {
case _MonsterConfig() when $default != null:
return $default(_that.baseHp,_that.hpGrowth,_that.rewardBase,_that.rewardGrowth,_that.baseAttack,_that.attackGrowth,_that.attacksPerSecond,_that.mitigation,_that.dodgeChance,_that.expBase,_that.expGrowth,_that.dropChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonsterConfig extends MonsterConfig {
  const _MonsterConfig({@BigNumConverter() required this.baseHp, required this.hpGrowth, @BigNumConverter() required this.rewardBase, required this.rewardGrowth, @BigNumConverter() this.baseAttack = BigNum.one, this.attackGrowth = 1.4, this.attacksPerSecond = 0.8, this.mitigation = 0.0, this.dodgeChance = 0.0, @BigNumConverter() this.expBase = BigNum.one, this.expGrowth = 1.4, this.dropChance = 0.0}): super._();
  factory _MonsterConfig.fromJson(Map<String, dynamic> json) => _$MonsterConfigFromJson(json);

/// Health at level 0.
@override@BigNumConverter() final  BigNum baseHp;
/// Health is multiplied by this per level.
@override final  double hpGrowth;
/// Reward for a kill at level 0.
@override@BigNumConverter() final  BigNum rewardBase;
/// Reward is multiplied by this per level.
@override final  double rewardGrowth;
/// Damage of one swing at level 0.
@override@JsonKey()@BigNumConverter() final  BigNum baseAttack;
/// Attack is multiplied by this per level.
@override@JsonKey() final  double attackGrowth;
/// Swings per second.
@override@JsonKey() final  double attacksPerSecond;
/// Fraction of incoming damage absorbed, in `0..1`.
@override@JsonKey() final  double mitigation;
/// Probability in `0..1` of dodging a swing.
@override@JsonKey() final  double dodgeChance;
/// Experience for a kill at level 0.
///
/// Separate from the gold reward: levelling and earning are different
/// pacing levers, and tying them together removes one of them.
@override@JsonKey()@BigNumConverter() final  BigNum expBase;
/// Experience is multiplied by this per level.
@override@JsonKey() final  double expGrowth;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonsterConfig&&(identical(other.baseHp, baseHp) || other.baseHp == baseHp)&&(identical(other.hpGrowth, hpGrowth) || other.hpGrowth == hpGrowth)&&(identical(other.rewardBase, rewardBase) || other.rewardBase == rewardBase)&&(identical(other.rewardGrowth, rewardGrowth) || other.rewardGrowth == rewardGrowth)&&(identical(other.baseAttack, baseAttack) || other.baseAttack == baseAttack)&&(identical(other.attackGrowth, attackGrowth) || other.attackGrowth == attackGrowth)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.expBase, expBase) || other.expBase == expBase)&&(identical(other.expGrowth, expGrowth) || other.expGrowth == expGrowth)&&(identical(other.dropChance, dropChance) || other.dropChance == dropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseHp,hpGrowth,rewardBase,rewardGrowth,baseAttack,attackGrowth,attacksPerSecond,mitigation,dodgeChance,expBase,expGrowth,dropChance);

@override
String toString() {
  return 'MonsterConfig(baseHp: $baseHp, hpGrowth: $hpGrowth, rewardBase: $rewardBase, rewardGrowth: $rewardGrowth, baseAttack: $baseAttack, attackGrowth: $attackGrowth, attacksPerSecond: $attacksPerSecond, mitigation: $mitigation, dodgeChance: $dodgeChance, expBase: $expBase, expGrowth: $expGrowth, dropChance: $dropChance)';
}


}

/// @nodoc
abstract mixin class _$MonsterConfigCopyWith<$Res> implements $MonsterConfigCopyWith<$Res> {
  factory _$MonsterConfigCopyWith(_MonsterConfig value, $Res Function(_MonsterConfig) _then) = __$MonsterConfigCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum baseHp, double hpGrowth,@BigNumConverter() BigNum rewardBase, double rewardGrowth,@BigNumConverter() BigNum baseAttack, double attackGrowth, double attacksPerSecond, double mitigation, double dodgeChance,@BigNumConverter() BigNum expBase, double expGrowth, double dropChance
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
@override @pragma('vm:prefer-inline') $Res call({Object? baseHp = null,Object? hpGrowth = null,Object? rewardBase = null,Object? rewardGrowth = null,Object? baseAttack = null,Object? attackGrowth = null,Object? attacksPerSecond = null,Object? mitigation = null,Object? dodgeChance = null,Object? expBase = null,Object? expGrowth = null,Object? dropChance = null,}) {
  return _then(_MonsterConfig(
baseHp: null == baseHp ? _self.baseHp : baseHp // ignore: cast_nullable_to_non_nullable
as BigNum,hpGrowth: null == hpGrowth ? _self.hpGrowth : hpGrowth // ignore: cast_nullable_to_non_nullable
as double,rewardBase: null == rewardBase ? _self.rewardBase : rewardBase // ignore: cast_nullable_to_non_nullable
as BigNum,rewardGrowth: null == rewardGrowth ? _self.rewardGrowth : rewardGrowth // ignore: cast_nullable_to_non_nullable
as double,baseAttack: null == baseAttack ? _self.baseAttack : baseAttack // ignore: cast_nullable_to_non_nullable
as BigNum,attackGrowth: null == attackGrowth ? _self.attackGrowth : attackGrowth // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,expBase: null == expBase ? _self.expBase : expBase // ignore: cast_nullable_to_non_nullable
as BigNum,expGrowth: null == expGrowth ? _self.expGrowth : expGrowth // ignore: cast_nullable_to_non_nullable
as double,dropChance: null == dropChance ? _self.dropChance : dropChance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
