// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerState {

 int get lastTickAtMs; int get rngSeed; int get version;@BigNumConverter() Map<String, BigNum> get resources; Map<String, GeneratorState> get generators; Map<String, int> get upgrades; List<HeroState> get heroes; PrestigeState get prestige;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.lastTickAtMs, lastTickAtMs) || other.lastTickAtMs == lastTickAtMs)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.resources, resources)&&const DeepCollectionEquality().equals(other.generators, generators)&&const DeepCollectionEquality().equals(other.upgrades, upgrades)&&const DeepCollectionEquality().equals(other.heroes, heroes)&&(identical(other.prestige, prestige) || other.prestige == prestige));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastTickAtMs,rngSeed,version,const DeepCollectionEquality().hash(resources),const DeepCollectionEquality().hash(generators),const DeepCollectionEquality().hash(upgrades),const DeepCollectionEquality().hash(heroes),prestige);

@override
String toString() {
  return 'PlayerState(lastTickAtMs: $lastTickAtMs, rngSeed: $rngSeed, version: $version, resources: $resources, generators: $generators, upgrades: $upgrades, heroes: $heroes, prestige: $prestige)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 int lastTickAtMs, int rngSeed, int version,@BigNumConverter() Map<String, BigNum> resources, Map<String, GeneratorState> generators, Map<String, int> upgrades, List<HeroState> heroes, PrestigeState prestige
});


$PrestigeStateCopyWith<$Res> get prestige;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastTickAtMs = null,Object? rngSeed = null,Object? version = null,Object? resources = null,Object? generators = null,Object? upgrades = null,Object? heroes = null,Object? prestige = null,}) {
  return _then(_self.copyWith(
lastTickAtMs: null == lastTickAtMs ? _self.lastTickAtMs : lastTickAtMs // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,generators: null == generators ? _self.generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorState>,upgrades: null == upgrades ? _self.upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,heroes: null == heroes ? _self.heroes : heroes // ignore: cast_nullable_to_non_nullable
as List<HeroState>,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
as PrestigeState,
  ));
}
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrestigeStateCopyWith<$Res> get prestige {
  
  return $PrestigeStateCopyWith<$Res>(_self.prestige, (value) {
    return _then(_self.copyWith(prestige: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int lastTickAtMs,  int rngSeed,  int version, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades,  List<HeroState> heroes,  PrestigeState prestige)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.resources,_that.generators,_that.upgrades,_that.heroes,_that.prestige);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int lastTickAtMs,  int rngSeed,  int version, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades,  List<HeroState> heroes,  PrestigeState prestige)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.resources,_that.generators,_that.upgrades,_that.heroes,_that.prestige);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int lastTickAtMs,  int rngSeed,  int version, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades,  List<HeroState> heroes,  PrestigeState prestige)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.resources,_that.generators,_that.upgrades,_that.heroes,_that.prestige);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerState implements PlayerState {
  const _PlayerState({required this.lastTickAtMs, required this.rngSeed, this.version = stateSchemaVersion, @BigNumConverter() final  Map<String, BigNum> resources = const <String, BigNum>{}, final  Map<String, GeneratorState> generators = const <String, GeneratorState>{}, final  Map<String, int> upgrades = const <String, int>{}, final  List<HeroState> heroes = const <HeroState>[], this.prestige = const PrestigeState()}): _resources = resources,_generators = generators,_upgrades = upgrades,_heroes = heroes;
  factory _PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);

@override final  int lastTickAtMs;
@override final  int rngSeed;
@override@JsonKey() final  int version;
 final  Map<String, BigNum> _resources;
@override@JsonKey()@BigNumConverter() Map<String, BigNum> get resources {
  if (_resources is EqualUnmodifiableMapView) return _resources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_resources);
}

 final  Map<String, GeneratorState> _generators;
@override@JsonKey() Map<String, GeneratorState> get generators {
  if (_generators is EqualUnmodifiableMapView) return _generators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_generators);
}

 final  Map<String, int> _upgrades;
@override@JsonKey() Map<String, int> get upgrades {
  if (_upgrades is EqualUnmodifiableMapView) return _upgrades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_upgrades);
}

 final  List<HeroState> _heroes;
@override@JsonKey() List<HeroState> get heroes {
  if (_heroes is EqualUnmodifiableListView) return _heroes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_heroes);
}

@override@JsonKey() final  PrestigeState prestige;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.lastTickAtMs, lastTickAtMs) || other.lastTickAtMs == lastTickAtMs)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._resources, _resources)&&const DeepCollectionEquality().equals(other._generators, _generators)&&const DeepCollectionEquality().equals(other._upgrades, _upgrades)&&const DeepCollectionEquality().equals(other._heroes, _heroes)&&(identical(other.prestige, prestige) || other.prestige == prestige));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastTickAtMs,rngSeed,version,const DeepCollectionEquality().hash(_resources),const DeepCollectionEquality().hash(_generators),const DeepCollectionEquality().hash(_upgrades),const DeepCollectionEquality().hash(_heroes),prestige);

@override
String toString() {
  return 'PlayerState(lastTickAtMs: $lastTickAtMs, rngSeed: $rngSeed, version: $version, resources: $resources, generators: $generators, upgrades: $upgrades, heroes: $heroes, prestige: $prestige)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 int lastTickAtMs, int rngSeed, int version,@BigNumConverter() Map<String, BigNum> resources, Map<String, GeneratorState> generators, Map<String, int> upgrades, List<HeroState> heroes, PrestigeState prestige
});


@override $PrestigeStateCopyWith<$Res> get prestige;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastTickAtMs = null,Object? rngSeed = null,Object? version = null,Object? resources = null,Object? generators = null,Object? upgrades = null,Object? heroes = null,Object? prestige = null,}) {
  return _then(_PlayerState(
lastTickAtMs: null == lastTickAtMs ? _self.lastTickAtMs : lastTickAtMs // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,resources: null == resources ? _self._resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,generators: null == generators ? _self._generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorState>,upgrades: null == upgrades ? _self._upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,heroes: null == heroes ? _self._heroes : heroes // ignore: cast_nullable_to_non_nullable
as List<HeroState>,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
as PrestigeState,
  ));
}

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrestigeStateCopyWith<$Res> get prestige {
  
  return $PrestigeStateCopyWith<$Res>(_self.prestige, (value) {
    return _then(_self.copyWith(prestige: value));
  });
}
}

// dart format on
