// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combat_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CombatStats {

/// Damage of one unmodified swing.
@BigNumConverter() BigNum get attack;/// Swings per second. Sets the spacing of events in the journal.
 double get attacksPerSecond;/// Probability in `0..1` that a swing crits.
 double get critChance;/// Damage multiplier applied on a crit.
 double get critFactor;/// Fraction of incoming damage absorbed, in `0..1`.
 double get mitigation;/// Probability in `0..1` of avoiding an incoming swing entirely.
 double get dodgeChance;/// Starting health.
@BigNumConverter() BigNum get maxHp;
/// Create a copy of CombatStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombatStatsCopyWith<CombatStats> get copyWith => _$CombatStatsCopyWithImpl<CombatStats>(this as CombatStats, _$identity);

  /// Serializes this CombatStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombatStats&&(identical(other.attack, attack) || other.attack == attack)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attack,attacksPerSecond,critChance,critFactor,mitigation,dodgeChance,maxHp);

@override
String toString() {
  return 'CombatStats(attack: $attack, attacksPerSecond: $attacksPerSecond, critChance: $critChance, critFactor: $critFactor, mitigation: $mitigation, dodgeChance: $dodgeChance, maxHp: $maxHp)';
}


}

/// @nodoc
abstract mixin class $CombatStatsCopyWith<$Res>  {
  factory $CombatStatsCopyWith(CombatStats value, $Res Function(CombatStats) _then) = _$CombatStatsCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum attack, double attacksPerSecond, double critChance, double critFactor, double mitigation, double dodgeChance,@BigNumConverter() BigNum maxHp
});




}
/// @nodoc
class _$CombatStatsCopyWithImpl<$Res>
    implements $CombatStatsCopyWith<$Res> {
  _$CombatStatsCopyWithImpl(this._self, this._then);

  final CombatStats _self;
  final $Res Function(CombatStats) _then;

/// Create a copy of CombatStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attack = null,Object? attacksPerSecond = null,Object? critChance = null,Object? critFactor = null,Object? mitigation = null,Object? dodgeChance = null,Object? maxHp = null,}) {
  return _then(_self.copyWith(
attack: null == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as BigNum,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as BigNum,
  ));
}

}


/// Adds pattern-matching-related methods to [CombatStats].
extension CombatStatsPatterns on CombatStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CombatStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CombatStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CombatStats value)  $default,){
final _that = this;
switch (_that) {
case _CombatStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CombatStats value)?  $default,){
final _that = this;
switch (_that) {
case _CombatStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum attack,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum maxHp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CombatStats() when $default != null:
return $default(_that.attack,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.maxHp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum attack,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum maxHp)  $default,) {final _that = this;
switch (_that) {
case _CombatStats():
return $default(_that.attack,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.maxHp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum attack,  double attacksPerSecond,  double critChance,  double critFactor,  double mitigation,  double dodgeChance, @BigNumConverter()  BigNum maxHp)?  $default,) {final _that = this;
switch (_that) {
case _CombatStats() when $default != null:
return $default(_that.attack,_that.attacksPerSecond,_that.critChance,_that.critFactor,_that.mitigation,_that.dodgeChance,_that.maxHp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CombatStats implements CombatStats {
  const _CombatStats({@BigNumConverter() required this.attack, this.attacksPerSecond = 1.0, this.critChance = 0.0, this.critFactor = 2.0, this.mitigation = 0.0, this.dodgeChance = 0.0, @BigNumConverter() this.maxHp = BigNum.one});
  factory _CombatStats.fromJson(Map<String, dynamic> json) => _$CombatStatsFromJson(json);

/// Damage of one unmodified swing.
@override@BigNumConverter() final  BigNum attack;
/// Swings per second. Sets the spacing of events in the journal.
@override@JsonKey() final  double attacksPerSecond;
/// Probability in `0..1` that a swing crits.
@override@JsonKey() final  double critChance;
/// Damage multiplier applied on a crit.
@override@JsonKey() final  double critFactor;
/// Fraction of incoming damage absorbed, in `0..1`.
@override@JsonKey() final  double mitigation;
/// Probability in `0..1` of avoiding an incoming swing entirely.
@override@JsonKey() final  double dodgeChance;
/// Starting health.
@override@JsonKey()@BigNumConverter() final  BigNum maxHp;

/// Create a copy of CombatStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CombatStatsCopyWith<_CombatStats> get copyWith => __$CombatStatsCopyWithImpl<_CombatStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CombatStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CombatStats&&(identical(other.attack, attack) || other.attack == attack)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.maxHp, maxHp) || other.maxHp == maxHp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attack,attacksPerSecond,critChance,critFactor,mitigation,dodgeChance,maxHp);

@override
String toString() {
  return 'CombatStats(attack: $attack, attacksPerSecond: $attacksPerSecond, critChance: $critChance, critFactor: $critFactor, mitigation: $mitigation, dodgeChance: $dodgeChance, maxHp: $maxHp)';
}


}

/// @nodoc
abstract mixin class _$CombatStatsCopyWith<$Res> implements $CombatStatsCopyWith<$Res> {
  factory _$CombatStatsCopyWith(_CombatStats value, $Res Function(_CombatStats) _then) = __$CombatStatsCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum attack, double attacksPerSecond, double critChance, double critFactor, double mitigation, double dodgeChance,@BigNumConverter() BigNum maxHp
});




}
/// @nodoc
class __$CombatStatsCopyWithImpl<$Res>
    implements _$CombatStatsCopyWith<$Res> {
  __$CombatStatsCopyWithImpl(this._self, this._then);

  final _CombatStats _self;
  final $Res Function(_CombatStats) _then;

/// Create a copy of CombatStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attack = null,Object? attacksPerSecond = null,Object? critChance = null,Object? critFactor = null,Object? mitigation = null,Object? dodgeChance = null,Object? maxHp = null,}) {
  return _then(_CombatStats(
attack: null == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as BigNum,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,maxHp: null == maxHp ? _self.maxHp : maxHp // ignore: cast_nullable_to_non_nullable
as BigNum,
  ));
}


}

// dart format on
