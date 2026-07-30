// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RarityConfig {

/// Every stat on the item is multiplied by this.
 double get statMultiplier;/// Ordering for display and for "equip best". Higher is better.
 int get rank;
/// Create a copy of RarityConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RarityConfigCopyWith<RarityConfig> get copyWith => _$RarityConfigCopyWithImpl<RarityConfig>(this as RarityConfig, _$identity);

  /// Serializes this RarityConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RarityConfig&&(identical(other.statMultiplier, statMultiplier) || other.statMultiplier == statMultiplier)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statMultiplier,rank);

@override
String toString() {
  return 'RarityConfig(statMultiplier: $statMultiplier, rank: $rank)';
}


}

/// @nodoc
abstract mixin class $RarityConfigCopyWith<$Res>  {
  factory $RarityConfigCopyWith(RarityConfig value, $Res Function(RarityConfig) _then) = _$RarityConfigCopyWithImpl;
@useResult
$Res call({
 double statMultiplier, int rank
});




}
/// @nodoc
class _$RarityConfigCopyWithImpl<$Res>
    implements $RarityConfigCopyWith<$Res> {
  _$RarityConfigCopyWithImpl(this._self, this._then);

  final RarityConfig _self;
  final $Res Function(RarityConfig) _then;

/// Create a copy of RarityConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statMultiplier = null,Object? rank = null,}) {
  return _then(_self.copyWith(
statMultiplier: null == statMultiplier ? _self.statMultiplier : statMultiplier // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RarityConfig].
extension RarityConfigPatterns on RarityConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RarityConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RarityConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RarityConfig value)  $default,){
final _that = this;
switch (_that) {
case _RarityConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RarityConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RarityConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double statMultiplier,  int rank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RarityConfig() when $default != null:
return $default(_that.statMultiplier,_that.rank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double statMultiplier,  int rank)  $default,) {final _that = this;
switch (_that) {
case _RarityConfig():
return $default(_that.statMultiplier,_that.rank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double statMultiplier,  int rank)?  $default,) {final _that = this;
switch (_that) {
case _RarityConfig() when $default != null:
return $default(_that.statMultiplier,_that.rank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RarityConfig implements RarityConfig {
  const _RarityConfig({this.statMultiplier = 1.0, this.rank = 0});
  factory _RarityConfig.fromJson(Map<String, dynamic> json) => _$RarityConfigFromJson(json);

/// Every stat on the item is multiplied by this.
@override@JsonKey() final  double statMultiplier;
/// Ordering for display and for "equip best". Higher is better.
@override@JsonKey() final  int rank;

/// Create a copy of RarityConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RarityConfigCopyWith<_RarityConfig> get copyWith => __$RarityConfigCopyWithImpl<_RarityConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RarityConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RarityConfig&&(identical(other.statMultiplier, statMultiplier) || other.statMultiplier == statMultiplier)&&(identical(other.rank, rank) || other.rank == rank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statMultiplier,rank);

@override
String toString() {
  return 'RarityConfig(statMultiplier: $statMultiplier, rank: $rank)';
}


}

/// @nodoc
abstract mixin class _$RarityConfigCopyWith<$Res> implements $RarityConfigCopyWith<$Res> {
  factory _$RarityConfigCopyWith(_RarityConfig value, $Res Function(_RarityConfig) _then) = __$RarityConfigCopyWithImpl;
@override @useResult
$Res call({
 double statMultiplier, int rank
});




}
/// @nodoc
class __$RarityConfigCopyWithImpl<$Res>
    implements _$RarityConfigCopyWith<$Res> {
  __$RarityConfigCopyWithImpl(this._self, this._then);

  final _RarityConfig _self;
  final $Res Function(_RarityConfig) _then;

/// Create a copy of RarityConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statMultiplier = null,Object? rank = null,}) {
  return _then(_RarityConfig(
statMultiplier: null == statMultiplier ? _self.statMultiplier : statMultiplier // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ItemStats {

@BigNumConverter() BigNum get flatAttack;@BigNumConverter() BigNum get flatHp; double get attackMultiplier; double get hpMultiplier; double get critChance; double get critFactor; double get dodgeChance; double get mitigation; double get attacksPerSecond;
/// Create a copy of ItemStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemStatsCopyWith<ItemStats> get copyWith => _$ItemStatsCopyWithImpl<ItemStats>(this as ItemStats, _$identity);

  /// Serializes this ItemStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemStats&&(identical(other.flatAttack, flatAttack) || other.flatAttack == flatAttack)&&(identical(other.flatHp, flatHp) || other.flatHp == flatHp)&&(identical(other.attackMultiplier, attackMultiplier) || other.attackMultiplier == attackMultiplier)&&(identical(other.hpMultiplier, hpMultiplier) || other.hpMultiplier == hpMultiplier)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flatAttack,flatHp,attackMultiplier,hpMultiplier,critChance,critFactor,dodgeChance,mitigation,attacksPerSecond);

@override
String toString() {
  return 'ItemStats(flatAttack: $flatAttack, flatHp: $flatHp, attackMultiplier: $attackMultiplier, hpMultiplier: $hpMultiplier, critChance: $critChance, critFactor: $critFactor, dodgeChance: $dodgeChance, mitigation: $mitigation, attacksPerSecond: $attacksPerSecond)';
}


}

/// @nodoc
abstract mixin class $ItemStatsCopyWith<$Res>  {
  factory $ItemStatsCopyWith(ItemStats value, $Res Function(ItemStats) _then) = _$ItemStatsCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum flatAttack,@BigNumConverter() BigNum flatHp, double attackMultiplier, double hpMultiplier, double critChance, double critFactor, double dodgeChance, double mitigation, double attacksPerSecond
});




}
/// @nodoc
class _$ItemStatsCopyWithImpl<$Res>
    implements $ItemStatsCopyWith<$Res> {
  _$ItemStatsCopyWithImpl(this._self, this._then);

  final ItemStats _self;
  final $Res Function(ItemStats) _then;

/// Create a copy of ItemStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flatAttack = null,Object? flatHp = null,Object? attackMultiplier = null,Object? hpMultiplier = null,Object? critChance = null,Object? critFactor = null,Object? dodgeChance = null,Object? mitigation = null,Object? attacksPerSecond = null,}) {
  return _then(_self.copyWith(
flatAttack: null == flatAttack ? _self.flatAttack : flatAttack // ignore: cast_nullable_to_non_nullable
as BigNum,flatHp: null == flatHp ? _self.flatHp : flatHp // ignore: cast_nullable_to_non_nullable
as BigNum,attackMultiplier: null == attackMultiplier ? _self.attackMultiplier : attackMultiplier // ignore: cast_nullable_to_non_nullable
as double,hpMultiplier: null == hpMultiplier ? _self.hpMultiplier : hpMultiplier // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemStats].
extension ItemStatsPatterns on ItemStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemStats value)  $default,){
final _that = this;
switch (_that) {
case _ItemStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemStats value)?  $default,){
final _that = this;
switch (_that) {
case _ItemStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum flatAttack, @BigNumConverter()  BigNum flatHp,  double attackMultiplier,  double hpMultiplier,  double critChance,  double critFactor,  double dodgeChance,  double mitigation,  double attacksPerSecond)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemStats() when $default != null:
return $default(_that.flatAttack,_that.flatHp,_that.attackMultiplier,_that.hpMultiplier,_that.critChance,_that.critFactor,_that.dodgeChance,_that.mitigation,_that.attacksPerSecond);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum flatAttack, @BigNumConverter()  BigNum flatHp,  double attackMultiplier,  double hpMultiplier,  double critChance,  double critFactor,  double dodgeChance,  double mitigation,  double attacksPerSecond)  $default,) {final _that = this;
switch (_that) {
case _ItemStats():
return $default(_that.flatAttack,_that.flatHp,_that.attackMultiplier,_that.hpMultiplier,_that.critChance,_that.critFactor,_that.dodgeChance,_that.mitigation,_that.attacksPerSecond);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum flatAttack, @BigNumConverter()  BigNum flatHp,  double attackMultiplier,  double hpMultiplier,  double critChance,  double critFactor,  double dodgeChance,  double mitigation,  double attacksPerSecond)?  $default,) {final _that = this;
switch (_that) {
case _ItemStats() when $default != null:
return $default(_that.flatAttack,_that.flatHp,_that.attackMultiplier,_that.hpMultiplier,_that.critChance,_that.critFactor,_that.dodgeChance,_that.mitigation,_that.attacksPerSecond);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemStats extends ItemStats {
  const _ItemStats({@BigNumConverter() this.flatAttack = BigNum.zero, @BigNumConverter() this.flatHp = BigNum.zero, this.attackMultiplier = 1.0, this.hpMultiplier = 1.0, this.critChance = 0.0, this.critFactor = 0.0, this.dodgeChance = 0.0, this.mitigation = 0.0, this.attacksPerSecond = 0.0}): super._();
  factory _ItemStats.fromJson(Map<String, dynamic> json) => _$ItemStatsFromJson(json);

@override@JsonKey()@BigNumConverter() final  BigNum flatAttack;
@override@JsonKey()@BigNumConverter() final  BigNum flatHp;
@override@JsonKey() final  double attackMultiplier;
@override@JsonKey() final  double hpMultiplier;
@override@JsonKey() final  double critChance;
@override@JsonKey() final  double critFactor;
@override@JsonKey() final  double dodgeChance;
@override@JsonKey() final  double mitigation;
@override@JsonKey() final  double attacksPerSecond;

/// Create a copy of ItemStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemStatsCopyWith<_ItemStats> get copyWith => __$ItemStatsCopyWithImpl<_ItemStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemStats&&(identical(other.flatAttack, flatAttack) || other.flatAttack == flatAttack)&&(identical(other.flatHp, flatHp) || other.flatHp == flatHp)&&(identical(other.attackMultiplier, attackMultiplier) || other.attackMultiplier == attackMultiplier)&&(identical(other.hpMultiplier, hpMultiplier) || other.hpMultiplier == hpMultiplier)&&(identical(other.critChance, critChance) || other.critChance == critChance)&&(identical(other.critFactor, critFactor) || other.critFactor == critFactor)&&(identical(other.dodgeChance, dodgeChance) || other.dodgeChance == dodgeChance)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.attacksPerSecond, attacksPerSecond) || other.attacksPerSecond == attacksPerSecond));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flatAttack,flatHp,attackMultiplier,hpMultiplier,critChance,critFactor,dodgeChance,mitigation,attacksPerSecond);

@override
String toString() {
  return 'ItemStats(flatAttack: $flatAttack, flatHp: $flatHp, attackMultiplier: $attackMultiplier, hpMultiplier: $hpMultiplier, critChance: $critChance, critFactor: $critFactor, dodgeChance: $dodgeChance, mitigation: $mitigation, attacksPerSecond: $attacksPerSecond)';
}


}

/// @nodoc
abstract mixin class _$ItemStatsCopyWith<$Res> implements $ItemStatsCopyWith<$Res> {
  factory _$ItemStatsCopyWith(_ItemStats value, $Res Function(_ItemStats) _then) = __$ItemStatsCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum flatAttack,@BigNumConverter() BigNum flatHp, double attackMultiplier, double hpMultiplier, double critChance, double critFactor, double dodgeChance, double mitigation, double attacksPerSecond
});




}
/// @nodoc
class __$ItemStatsCopyWithImpl<$Res>
    implements _$ItemStatsCopyWith<$Res> {
  __$ItemStatsCopyWithImpl(this._self, this._then);

  final _ItemStats _self;
  final $Res Function(_ItemStats) _then;

/// Create a copy of ItemStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flatAttack = null,Object? flatHp = null,Object? attackMultiplier = null,Object? hpMultiplier = null,Object? critChance = null,Object? critFactor = null,Object? dodgeChance = null,Object? mitigation = null,Object? attacksPerSecond = null,}) {
  return _then(_ItemStats(
flatAttack: null == flatAttack ? _self.flatAttack : flatAttack // ignore: cast_nullable_to_non_nullable
as BigNum,flatHp: null == flatHp ? _self.flatHp : flatHp // ignore: cast_nullable_to_non_nullable
as BigNum,attackMultiplier: null == attackMultiplier ? _self.attackMultiplier : attackMultiplier // ignore: cast_nullable_to_non_nullable
as double,hpMultiplier: null == hpMultiplier ? _self.hpMultiplier : hpMultiplier // ignore: cast_nullable_to_non_nullable
as double,critChance: null == critChance ? _self.critChance : critChance // ignore: cast_nullable_to_non_nullable
as double,critFactor: null == critFactor ? _self.critFactor : critFactor // ignore: cast_nullable_to_non_nullable
as double,dodgeChance: null == dodgeChance ? _self.dodgeChance : dodgeChance // ignore: cast_nullable_to_non_nullable
as double,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as double,attacksPerSecond: null == attacksPerSecond ? _self.attacksPerSecond : attacksPerSecond // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ItemConfig {

/// Which slot it occupies. Free-form so slots stay data.
 String get slot;/// Key into `BalanceConfig.rarities`.
 String get rarity;/// Stats at level 0, before the rarity multiplier.
 ItemStats get stats;/// Stats are multiplied by this per upgrade level (`T-083`).
 double get levelMultiplier;/// Highest level this item can reach.
 int get maxLevel;
/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemConfigCopyWith<ItemConfig> get copyWith => _$ItemConfigCopyWithImpl<ItemConfig>(this as ItemConfig, _$identity);

  /// Serializes this ItemConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemConfig&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slot,rarity,stats,levelMultiplier,maxLevel);

@override
String toString() {
  return 'ItemConfig(slot: $slot, rarity: $rarity, stats: $stats, levelMultiplier: $levelMultiplier, maxLevel: $maxLevel)';
}


}

/// @nodoc
abstract mixin class $ItemConfigCopyWith<$Res>  {
  factory $ItemConfigCopyWith(ItemConfig value, $Res Function(ItemConfig) _then) = _$ItemConfigCopyWithImpl;
@useResult
$Res call({
 String slot, String rarity, ItemStats stats, double levelMultiplier, int maxLevel
});


$ItemStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$ItemConfigCopyWithImpl<$Res>
    implements $ItemConfigCopyWith<$Res> {
  _$ItemConfigCopyWithImpl(this._self, this._then);

  final ItemConfig _self;
  final $Res Function(ItemConfig) _then;

/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slot = null,Object? rarity = null,Object? stats = null,Object? levelMultiplier = null,Object? maxLevel = null,}) {
  return _then(_self.copyWith(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ItemStats,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemStatsCopyWith<$Res> get stats {
  
  return $ItemStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemConfig].
extension ItemConfigPatterns on ItemConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemConfig value)  $default,){
final _that = this;
switch (_that) {
case _ItemConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ItemConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slot,  String rarity,  ItemStats stats,  double levelMultiplier,  int maxLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemConfig() when $default != null:
return $default(_that.slot,_that.rarity,_that.stats,_that.levelMultiplier,_that.maxLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slot,  String rarity,  ItemStats stats,  double levelMultiplier,  int maxLevel)  $default,) {final _that = this;
switch (_that) {
case _ItemConfig():
return $default(_that.slot,_that.rarity,_that.stats,_that.levelMultiplier,_that.maxLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slot,  String rarity,  ItemStats stats,  double levelMultiplier,  int maxLevel)?  $default,) {final _that = this;
switch (_that) {
case _ItemConfig() when $default != null:
return $default(_that.slot,_that.rarity,_that.stats,_that.levelMultiplier,_that.maxLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemConfig extends ItemConfig {
  const _ItemConfig({required this.slot, required this.rarity, this.stats = const ItemStats(), this.levelMultiplier = 1.12, this.maxLevel = 20}): super._();
  factory _ItemConfig.fromJson(Map<String, dynamic> json) => _$ItemConfigFromJson(json);

/// Which slot it occupies. Free-form so slots stay data.
@override final  String slot;
/// Key into `BalanceConfig.rarities`.
@override final  String rarity;
/// Stats at level 0, before the rarity multiplier.
@override@JsonKey() final  ItemStats stats;
/// Stats are multiplied by this per upgrade level (`T-083`).
@override@JsonKey() final  double levelMultiplier;
/// Highest level this item can reach.
@override@JsonKey() final  int maxLevel;

/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemConfigCopyWith<_ItemConfig> get copyWith => __$ItemConfigCopyWithImpl<_ItemConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemConfig&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,slot,rarity,stats,levelMultiplier,maxLevel);

@override
String toString() {
  return 'ItemConfig(slot: $slot, rarity: $rarity, stats: $stats, levelMultiplier: $levelMultiplier, maxLevel: $maxLevel)';
}


}

/// @nodoc
abstract mixin class _$ItemConfigCopyWith<$Res> implements $ItemConfigCopyWith<$Res> {
  factory _$ItemConfigCopyWith(_ItemConfig value, $Res Function(_ItemConfig) _then) = __$ItemConfigCopyWithImpl;
@override @useResult
$Res call({
 String slot, String rarity, ItemStats stats, double levelMultiplier, int maxLevel
});


@override $ItemStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$ItemConfigCopyWithImpl<$Res>
    implements _$ItemConfigCopyWith<$Res> {
  __$ItemConfigCopyWithImpl(this._self, this._then);

  final _ItemConfig _self;
  final $Res Function(_ItemConfig) _then;

/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? rarity = null,Object? stats = null,Object? levelMultiplier = null,Object? maxLevel = null,}) {
  return _then(_ItemConfig(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ItemStats,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ItemConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemStatsCopyWith<$Res> get stats {
  
  return $ItemStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
