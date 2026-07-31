// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skill_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SkillConfig {

/// Rarity key, shared with items so one colour means one thing.
 String get rarity;/// Hero level at which the skill may be used at all.
///
/// A skill dropped before then is still collected: copies bank, and the
/// skill switches on when the player gets there. Refusing the drop would
/// mean a boss kill that paid nothing.
 int get unlockAtLevel;/// Seconds between casts.
 double get cooldownSeconds;/// Swing damage multiplier at level 1.
 double get damageMultiplier;/// Multiplier gained per level, compounding.
 double get levelMultiplier;/// How many monsters one cast lands on. Zero means the whole wave.
///
/// Zero rather than a large number: "everything" must not stop being true
/// the day a wave grows to seven.
 int get targets;/// Levels this skill can reach.
 int get maxLevel;/// Duplicate copies the first upgrade costs.
 int get copiesBase;/// Copies cost is multiplied by this per level already reached.
 double get copiesGrowth;
/// Create a copy of SkillConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillConfigCopyWith<SkillConfig> get copyWith => _$SkillConfigCopyWithImpl<SkillConfig>(this as SkillConfig, _$identity);

  /// Serializes this SkillConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillConfig&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.unlockAtLevel, unlockAtLevel) || other.unlockAtLevel == unlockAtLevel)&&(identical(other.cooldownSeconds, cooldownSeconds) || other.cooldownSeconds == cooldownSeconds)&&(identical(other.damageMultiplier, damageMultiplier) || other.damageMultiplier == damageMultiplier)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.targets, targets) || other.targets == targets)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel)&&(identical(other.copiesBase, copiesBase) || other.copiesBase == copiesBase)&&(identical(other.copiesGrowth, copiesGrowth) || other.copiesGrowth == copiesGrowth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rarity,unlockAtLevel,cooldownSeconds,damageMultiplier,levelMultiplier,targets,maxLevel,copiesBase,copiesGrowth);

@override
String toString() {
  return 'SkillConfig(rarity: $rarity, unlockAtLevel: $unlockAtLevel, cooldownSeconds: $cooldownSeconds, damageMultiplier: $damageMultiplier, levelMultiplier: $levelMultiplier, targets: $targets, maxLevel: $maxLevel, copiesBase: $copiesBase, copiesGrowth: $copiesGrowth)';
}


}

/// @nodoc
abstract mixin class $SkillConfigCopyWith<$Res>  {
  factory $SkillConfigCopyWith(SkillConfig value, $Res Function(SkillConfig) _then) = _$SkillConfigCopyWithImpl;
@useResult
$Res call({
 String rarity, int unlockAtLevel, double cooldownSeconds, double damageMultiplier, double levelMultiplier, int targets, int maxLevel, int copiesBase, double copiesGrowth
});




}
/// @nodoc
class _$SkillConfigCopyWithImpl<$Res>
    implements $SkillConfigCopyWith<$Res> {
  _$SkillConfigCopyWithImpl(this._self, this._then);

  final SkillConfig _self;
  final $Res Function(SkillConfig) _then;

/// Create a copy of SkillConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rarity = null,Object? unlockAtLevel = null,Object? cooldownSeconds = null,Object? damageMultiplier = null,Object? levelMultiplier = null,Object? targets = null,Object? maxLevel = null,Object? copiesBase = null,Object? copiesGrowth = null,}) {
  return _then(_self.copyWith(
rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,unlockAtLevel: null == unlockAtLevel ? _self.unlockAtLevel : unlockAtLevel // ignore: cast_nullable_to_non_nullable
as int,cooldownSeconds: null == cooldownSeconds ? _self.cooldownSeconds : cooldownSeconds // ignore: cast_nullable_to_non_nullable
as double,damageMultiplier: null == damageMultiplier ? _self.damageMultiplier : damageMultiplier // ignore: cast_nullable_to_non_nullable
as double,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as int,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,copiesBase: null == copiesBase ? _self.copiesBase : copiesBase // ignore: cast_nullable_to_non_nullable
as int,copiesGrowth: null == copiesGrowth ? _self.copiesGrowth : copiesGrowth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillConfig].
extension SkillConfigPatterns on SkillConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillConfig value)  $default,){
final _that = this;
switch (_that) {
case _SkillConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SkillConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rarity,  int unlockAtLevel,  double cooldownSeconds,  double damageMultiplier,  double levelMultiplier,  int targets,  int maxLevel,  int copiesBase,  double copiesGrowth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillConfig() when $default != null:
return $default(_that.rarity,_that.unlockAtLevel,_that.cooldownSeconds,_that.damageMultiplier,_that.levelMultiplier,_that.targets,_that.maxLevel,_that.copiesBase,_that.copiesGrowth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rarity,  int unlockAtLevel,  double cooldownSeconds,  double damageMultiplier,  double levelMultiplier,  int targets,  int maxLevel,  int copiesBase,  double copiesGrowth)  $default,) {final _that = this;
switch (_that) {
case _SkillConfig():
return $default(_that.rarity,_that.unlockAtLevel,_that.cooldownSeconds,_that.damageMultiplier,_that.levelMultiplier,_that.targets,_that.maxLevel,_that.copiesBase,_that.copiesGrowth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rarity,  int unlockAtLevel,  double cooldownSeconds,  double damageMultiplier,  double levelMultiplier,  int targets,  int maxLevel,  int copiesBase,  double copiesGrowth)?  $default,) {final _that = this;
switch (_that) {
case _SkillConfig() when $default != null:
return $default(_that.rarity,_that.unlockAtLevel,_that.cooldownSeconds,_that.damageMultiplier,_that.levelMultiplier,_that.targets,_that.maxLevel,_that.copiesBase,_that.copiesGrowth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillConfig extends SkillConfig {
  const _SkillConfig({this.rarity = 'common', this.unlockAtLevel = 0, this.cooldownSeconds = 6.0, this.damageMultiplier = 2.0, this.levelMultiplier = 1.15, this.targets = 1, this.maxLevel = 10, this.copiesBase = 2, this.copiesGrowth = 1.6}): super._();
  factory _SkillConfig.fromJson(Map<String, dynamic> json) => _$SkillConfigFromJson(json);

/// Rarity key, shared with items so one colour means one thing.
@override@JsonKey() final  String rarity;
/// Hero level at which the skill may be used at all.
///
/// A skill dropped before then is still collected: copies bank, and the
/// skill switches on when the player gets there. Refusing the drop would
/// mean a boss kill that paid nothing.
@override@JsonKey() final  int unlockAtLevel;
/// Seconds between casts.
@override@JsonKey() final  double cooldownSeconds;
/// Swing damage multiplier at level 1.
@override@JsonKey() final  double damageMultiplier;
/// Multiplier gained per level, compounding.
@override@JsonKey() final  double levelMultiplier;
/// How many monsters one cast lands on. Zero means the whole wave.
///
/// Zero rather than a large number: "everything" must not stop being true
/// the day a wave grows to seven.
@override@JsonKey() final  int targets;
/// Levels this skill can reach.
@override@JsonKey() final  int maxLevel;
/// Duplicate copies the first upgrade costs.
@override@JsonKey() final  int copiesBase;
/// Copies cost is multiplied by this per level already reached.
@override@JsonKey() final  double copiesGrowth;

/// Create a copy of SkillConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillConfigCopyWith<_SkillConfig> get copyWith => __$SkillConfigCopyWithImpl<_SkillConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillConfig&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.unlockAtLevel, unlockAtLevel) || other.unlockAtLevel == unlockAtLevel)&&(identical(other.cooldownSeconds, cooldownSeconds) || other.cooldownSeconds == cooldownSeconds)&&(identical(other.damageMultiplier, damageMultiplier) || other.damageMultiplier == damageMultiplier)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier)&&(identical(other.targets, targets) || other.targets == targets)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel)&&(identical(other.copiesBase, copiesBase) || other.copiesBase == copiesBase)&&(identical(other.copiesGrowth, copiesGrowth) || other.copiesGrowth == copiesGrowth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rarity,unlockAtLevel,cooldownSeconds,damageMultiplier,levelMultiplier,targets,maxLevel,copiesBase,copiesGrowth);

@override
String toString() {
  return 'SkillConfig(rarity: $rarity, unlockAtLevel: $unlockAtLevel, cooldownSeconds: $cooldownSeconds, damageMultiplier: $damageMultiplier, levelMultiplier: $levelMultiplier, targets: $targets, maxLevel: $maxLevel, copiesBase: $copiesBase, copiesGrowth: $copiesGrowth)';
}


}

/// @nodoc
abstract mixin class _$SkillConfigCopyWith<$Res> implements $SkillConfigCopyWith<$Res> {
  factory _$SkillConfigCopyWith(_SkillConfig value, $Res Function(_SkillConfig) _then) = __$SkillConfigCopyWithImpl;
@override @useResult
$Res call({
 String rarity, int unlockAtLevel, double cooldownSeconds, double damageMultiplier, double levelMultiplier, int targets, int maxLevel, int copiesBase, double copiesGrowth
});




}
/// @nodoc
class __$SkillConfigCopyWithImpl<$Res>
    implements _$SkillConfigCopyWith<$Res> {
  __$SkillConfigCopyWithImpl(this._self, this._then);

  final _SkillConfig _self;
  final $Res Function(_SkillConfig) _then;

/// Create a copy of SkillConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rarity = null,Object? unlockAtLevel = null,Object? cooldownSeconds = null,Object? damageMultiplier = null,Object? levelMultiplier = null,Object? targets = null,Object? maxLevel = null,Object? copiesBase = null,Object? copiesGrowth = null,}) {
  return _then(_SkillConfig(
rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,unlockAtLevel: null == unlockAtLevel ? _self.unlockAtLevel : unlockAtLevel // ignore: cast_nullable_to_non_nullable
as int,cooldownSeconds: null == cooldownSeconds ? _self.cooldownSeconds : cooldownSeconds // ignore: cast_nullable_to_non_nullable
as double,damageMultiplier: null == damageMultiplier ? _self.damageMultiplier : damageMultiplier // ignore: cast_nullable_to_non_nullable
as double,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,targets: null == targets ? _self.targets : targets // ignore: cast_nullable_to_non_nullable
as int,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,copiesBase: null == copiesBase ? _self.copiesBase : copiesBase // ignore: cast_nullable_to_non_nullable
as int,copiesGrowth: null == copiesGrowth ? _self.copiesGrowth : copiesGrowth // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SkillPackConfig {

/// Resource a pack costs. Gems, so the skill track has a currency of its
/// own rather than competing with gold for the same pile.
 String get costResource; double get costAmount;/// Relative weights per rarity key.
 Map<String, double> get weights;/// Packs without the pity rarity before it is guaranteed. Zero disables.
 int get pityThreshold; String get pityRarity;/// Chance a boss drops a copy, in `0..1`.
 double get bossDropChance;/// Chance an ordinary monster drops a copy, in `0..1`.
 double get monsterDropChance;
/// Create a copy of SkillPackConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkillPackConfigCopyWith<SkillPackConfig> get copyWith => _$SkillPackConfigCopyWithImpl<SkillPackConfig>(this as SkillPackConfig, _$identity);

  /// Serializes this SkillPackConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkillPackConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costAmount, costAmount) || other.costAmount == costAmount)&&const DeepCollectionEquality().equals(other.weights, weights)&&(identical(other.pityThreshold, pityThreshold) || other.pityThreshold == pityThreshold)&&(identical(other.pityRarity, pityRarity) || other.pityRarity == pityRarity)&&(identical(other.bossDropChance, bossDropChance) || other.bossDropChance == bossDropChance)&&(identical(other.monsterDropChance, monsterDropChance) || other.monsterDropChance == monsterDropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costAmount,const DeepCollectionEquality().hash(weights),pityThreshold,pityRarity,bossDropChance,monsterDropChance);

@override
String toString() {
  return 'SkillPackConfig(costResource: $costResource, costAmount: $costAmount, weights: $weights, pityThreshold: $pityThreshold, pityRarity: $pityRarity, bossDropChance: $bossDropChance, monsterDropChance: $monsterDropChance)';
}


}

/// @nodoc
abstract mixin class $SkillPackConfigCopyWith<$Res>  {
  factory $SkillPackConfigCopyWith(SkillPackConfig value, $Res Function(SkillPackConfig) _then) = _$SkillPackConfigCopyWithImpl;
@useResult
$Res call({
 String costResource, double costAmount, Map<String, double> weights, int pityThreshold, String pityRarity, double bossDropChance, double monsterDropChance
});




}
/// @nodoc
class _$SkillPackConfigCopyWithImpl<$Res>
    implements $SkillPackConfigCopyWith<$Res> {
  _$SkillPackConfigCopyWithImpl(this._self, this._then);

  final SkillPackConfig _self;
  final $Res Function(SkillPackConfig) _then;

/// Create a copy of SkillPackConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? costResource = null,Object? costAmount = null,Object? weights = null,Object? pityThreshold = null,Object? pityRarity = null,Object? bossDropChance = null,Object? monsterDropChance = null,}) {
  return _then(_self.copyWith(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costAmount: null == costAmount ? _self.costAmount : costAmount // ignore: cast_nullable_to_non_nullable
as double,weights: null == weights ? _self.weights : weights // ignore: cast_nullable_to_non_nullable
as Map<String, double>,pityThreshold: null == pityThreshold ? _self.pityThreshold : pityThreshold // ignore: cast_nullable_to_non_nullable
as int,pityRarity: null == pityRarity ? _self.pityRarity : pityRarity // ignore: cast_nullable_to_non_nullable
as String,bossDropChance: null == bossDropChance ? _self.bossDropChance : bossDropChance // ignore: cast_nullable_to_non_nullable
as double,monsterDropChance: null == monsterDropChance ? _self.monsterDropChance : monsterDropChance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SkillPackConfig].
extension SkillPackConfigPatterns on SkillPackConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkillPackConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkillPackConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkillPackConfig value)  $default,){
final _that = this;
switch (_that) {
case _SkillPackConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkillPackConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SkillPackConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String costResource,  double costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity,  double bossDropChance,  double monsterDropChance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkillPackConfig() when $default != null:
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity,_that.bossDropChance,_that.monsterDropChance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String costResource,  double costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity,  double bossDropChance,  double monsterDropChance)  $default,) {final _that = this;
switch (_that) {
case _SkillPackConfig():
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity,_that.bossDropChance,_that.monsterDropChance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String costResource,  double costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity,  double bossDropChance,  double monsterDropChance)?  $default,) {final _that = this;
switch (_that) {
case _SkillPackConfig() when $default != null:
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity,_that.bossDropChance,_that.monsterDropChance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkillPackConfig extends SkillPackConfig {
  const _SkillPackConfig({this.costResource = 'gems', this.costAmount = 100.0, final  Map<String, double> weights = const <String, double>{}, this.pityThreshold = 0, this.pityRarity = '', this.bossDropChance = 0.0, this.monsterDropChance = 0.0}): _weights = weights,super._();
  factory _SkillPackConfig.fromJson(Map<String, dynamic> json) => _$SkillPackConfigFromJson(json);

/// Resource a pack costs. Gems, so the skill track has a currency of its
/// own rather than competing with gold for the same pile.
@override@JsonKey() final  String costResource;
@override@JsonKey() final  double costAmount;
/// Relative weights per rarity key.
 final  Map<String, double> _weights;
/// Relative weights per rarity key.
@override@JsonKey() Map<String, double> get weights {
  if (_weights is EqualUnmodifiableMapView) return _weights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_weights);
}

/// Packs without the pity rarity before it is guaranteed. Zero disables.
@override@JsonKey() final  int pityThreshold;
@override@JsonKey() final  String pityRarity;
/// Chance a boss drops a copy, in `0..1`.
@override@JsonKey() final  double bossDropChance;
/// Chance an ordinary monster drops a copy, in `0..1`.
@override@JsonKey() final  double monsterDropChance;

/// Create a copy of SkillPackConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkillPackConfigCopyWith<_SkillPackConfig> get copyWith => __$SkillPackConfigCopyWithImpl<_SkillPackConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkillPackConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkillPackConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costAmount, costAmount) || other.costAmount == costAmount)&&const DeepCollectionEquality().equals(other._weights, _weights)&&(identical(other.pityThreshold, pityThreshold) || other.pityThreshold == pityThreshold)&&(identical(other.pityRarity, pityRarity) || other.pityRarity == pityRarity)&&(identical(other.bossDropChance, bossDropChance) || other.bossDropChance == bossDropChance)&&(identical(other.monsterDropChance, monsterDropChance) || other.monsterDropChance == monsterDropChance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costAmount,const DeepCollectionEquality().hash(_weights),pityThreshold,pityRarity,bossDropChance,monsterDropChance);

@override
String toString() {
  return 'SkillPackConfig(costResource: $costResource, costAmount: $costAmount, weights: $weights, pityThreshold: $pityThreshold, pityRarity: $pityRarity, bossDropChance: $bossDropChance, monsterDropChance: $monsterDropChance)';
}


}

/// @nodoc
abstract mixin class _$SkillPackConfigCopyWith<$Res> implements $SkillPackConfigCopyWith<$Res> {
  factory _$SkillPackConfigCopyWith(_SkillPackConfig value, $Res Function(_SkillPackConfig) _then) = __$SkillPackConfigCopyWithImpl;
@override @useResult
$Res call({
 String costResource, double costAmount, Map<String, double> weights, int pityThreshold, String pityRarity, double bossDropChance, double monsterDropChance
});




}
/// @nodoc
class __$SkillPackConfigCopyWithImpl<$Res>
    implements _$SkillPackConfigCopyWith<$Res> {
  __$SkillPackConfigCopyWithImpl(this._self, this._then);

  final _SkillPackConfig _self;
  final $Res Function(_SkillPackConfig) _then;

/// Create a copy of SkillPackConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? costResource = null,Object? costAmount = null,Object? weights = null,Object? pityThreshold = null,Object? pityRarity = null,Object? bossDropChance = null,Object? monsterDropChance = null,}) {
  return _then(_SkillPackConfig(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costAmount: null == costAmount ? _self.costAmount : costAmount // ignore: cast_nullable_to_non_nullable
as double,weights: null == weights ? _self._weights : weights // ignore: cast_nullable_to_non_nullable
as Map<String, double>,pityThreshold: null == pityThreshold ? _self.pityThreshold : pityThreshold // ignore: cast_nullable_to_non_nullable
as int,pityRarity: null == pityRarity ? _self.pityRarity : pityRarity // ignore: cast_nullable_to_non_nullable
as String,bossDropChance: null == bossDropChance ? _self.bossDropChance : bossDropChance // ignore: cast_nullable_to_non_nullable
as double,monsterDropChance: null == monsterDropChance ? _self.monsterDropChance : monsterDropChance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
