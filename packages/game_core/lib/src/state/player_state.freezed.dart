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

 int get lastTickAtMs; int get rngSeed; int get version;/// Milliseconds left over from the last tick that did not complete a whole
/// simulation step.
///
/// Progress is paid out in fixed one-second steps. Without carrying the
/// remainder, a client ticking at 30 Hz would round away a fraction of
/// every frame and drift measurably behind the server within a session.
 int get carryOverMs;@BigNumConverter() Map<String, BigNum> get resources; Map<String, GeneratorState> get generators; Map<String, int> get upgrades;/// Everything earned since the last prestige reset, per resource.
///
/// Tracked separately from [resources] because the prestige award is a
/// function of what the run *produced*, not of what is left after spending
/// it. Rewarding the balance on hand would punish the player for buying
/// the upgrades the run exists to buy.
@BigNumConverter() Map<String, BigNum> get earnedThisRun;/// Chapter, stage and wave: where the player is in the world.
 int get chapter; int get stage;/// Waves cleared in this stage. At `wavesPerStage` the boss is next.
 int get wave;/// Skill levels, by skill id.
///
/// Reserved now and filled in with the skill system later. Adding a field
/// to the save format is a JSON edit today and a database migration once
/// the server owns this state.
 Map<String, int> get skills;/// The hero's own level, earned by killing things.
 int get heroLevel;/// Experience banked towards the next level.
///
/// Only the remainder is kept, not a lifetime total: the total would be a
/// second number saying the same thing, and the two would drift apart the
/// first time a level formula changes.
@BigNumConverter() BigNum get heroExperience;/// Every item the player owns, by its instance id.
 Map<String, OwnedItem> get inventory;/// Slot name to the instance id worn in it.
///
/// Stored as slot -> item rather than a flag on the item so a slot can only
/// ever hold one thing: the invariant is in the shape of the data instead
/// of in code that has to remember to enforce it.
 Map<String, String> get equipped;/// Live RNG state, so randomness resumes rather than restarting.
///
/// Empty means "not drawn from yet"; the generator is then seeded from
/// [rngSeed]. Storing only the seed would make every lamp open after a
/// reload produce the same item.
 List<int> get rngState;/// Items created so far, used to mint ids.
///
/// A counter rather than a clock or a random value: the server has to
/// arrive at the same ids from the same state (`T-032`).
 int get itemsCreated;/// Opens since the pity rarity last dropped.
 int get pityCounter; PrestigeState get prestige;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.lastTickAtMs, lastTickAtMs) || other.lastTickAtMs == lastTickAtMs)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.version, version) || other.version == version)&&(identical(other.carryOverMs, carryOverMs) || other.carryOverMs == carryOverMs)&&const DeepCollectionEquality().equals(other.resources, resources)&&const DeepCollectionEquality().equals(other.generators, generators)&&const DeepCollectionEquality().equals(other.upgrades, upgrades)&&const DeepCollectionEquality().equals(other.earnedThisRun, earnedThisRun)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.wave, wave) || other.wave == wave)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.heroLevel, heroLevel) || other.heroLevel == heroLevel)&&(identical(other.heroExperience, heroExperience) || other.heroExperience == heroExperience)&&const DeepCollectionEquality().equals(other.inventory, inventory)&&const DeepCollectionEquality().equals(other.equipped, equipped)&&const DeepCollectionEquality().equals(other.rngState, rngState)&&(identical(other.itemsCreated, itemsCreated) || other.itemsCreated == itemsCreated)&&(identical(other.pityCounter, pityCounter) || other.pityCounter == pityCounter)&&(identical(other.prestige, prestige) || other.prestige == prestige));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,lastTickAtMs,rngSeed,version,carryOverMs,const DeepCollectionEquality().hash(resources),const DeepCollectionEquality().hash(generators),const DeepCollectionEquality().hash(upgrades),const DeepCollectionEquality().hash(earnedThisRun),chapter,stage,wave,const DeepCollectionEquality().hash(skills),heroLevel,heroExperience,const DeepCollectionEquality().hash(inventory),const DeepCollectionEquality().hash(equipped),const DeepCollectionEquality().hash(rngState),itemsCreated,pityCounter,prestige]);

@override
String toString() {
  return 'PlayerState(lastTickAtMs: $lastTickAtMs, rngSeed: $rngSeed, version: $version, carryOverMs: $carryOverMs, resources: $resources, generators: $generators, upgrades: $upgrades, earnedThisRun: $earnedThisRun, chapter: $chapter, stage: $stage, wave: $wave, skills: $skills, heroLevel: $heroLevel, heroExperience: $heroExperience, inventory: $inventory, equipped: $equipped, rngState: $rngState, itemsCreated: $itemsCreated, pityCounter: $pityCounter, prestige: $prestige)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 int lastTickAtMs, int rngSeed, int version, int carryOverMs,@BigNumConverter() Map<String, BigNum> resources, Map<String, GeneratorState> generators, Map<String, int> upgrades,@BigNumConverter() Map<String, BigNum> earnedThisRun, int chapter, int stage, int wave, Map<String, int> skills, int heroLevel,@BigNumConverter() BigNum heroExperience, Map<String, OwnedItem> inventory, Map<String, String> equipped, List<int> rngState, int itemsCreated, int pityCounter, PrestigeState prestige
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
@pragma('vm:prefer-inline') @override $Res call({Object? lastTickAtMs = null,Object? rngSeed = null,Object? version = null,Object? carryOverMs = null,Object? resources = null,Object? generators = null,Object? upgrades = null,Object? earnedThisRun = null,Object? chapter = null,Object? stage = null,Object? wave = null,Object? skills = null,Object? heroLevel = null,Object? heroExperience = null,Object? inventory = null,Object? equipped = null,Object? rngState = null,Object? itemsCreated = null,Object? pityCounter = null,Object? prestige = null,}) {
  return _then(_self.copyWith(
lastTickAtMs: null == lastTickAtMs ? _self.lastTickAtMs : lastTickAtMs // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,carryOverMs: null == carryOverMs ? _self.carryOverMs : carryOverMs // ignore: cast_nullable_to_non_nullable
as int,resources: null == resources ? _self.resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,generators: null == generators ? _self.generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorState>,upgrades: null == upgrades ? _self.upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,earnedThisRun: null == earnedThisRun ? _self.earnedThisRun : earnedThisRun // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as int,wave: null == wave ? _self.wave : wave // ignore: cast_nullable_to_non_nullable
as int,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, int>,heroLevel: null == heroLevel ? _self.heroLevel : heroLevel // ignore: cast_nullable_to_non_nullable
as int,heroExperience: null == heroExperience ? _self.heroExperience : heroExperience // ignore: cast_nullable_to_non_nullable
as BigNum,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as Map<String, OwnedItem>,equipped: null == equipped ? _self.equipped : equipped // ignore: cast_nullable_to_non_nullable
as Map<String, String>,rngState: null == rngState ? _self.rngState : rngState // ignore: cast_nullable_to_non_nullable
as List<int>,itemsCreated: null == itemsCreated ? _self.itemsCreated : itemsCreated // ignore: cast_nullable_to_non_nullable
as int,pityCounter: null == pityCounter ? _self.pityCounter : pityCounter // ignore: cast_nullable_to_non_nullable
as int,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int lastTickAtMs,  int rngSeed,  int version,  int carryOverMs, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades, @BigNumConverter()  Map<String, BigNum> earnedThisRun,  int chapter,  int stage,  int wave,  Map<String, int> skills,  int heroLevel, @BigNumConverter()  BigNum heroExperience,  Map<String, OwnedItem> inventory,  Map<String, String> equipped,  List<int> rngState,  int itemsCreated,  int pityCounter,  PrestigeState prestige)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.carryOverMs,_that.resources,_that.generators,_that.upgrades,_that.earnedThisRun,_that.chapter,_that.stage,_that.wave,_that.skills,_that.heroLevel,_that.heroExperience,_that.inventory,_that.equipped,_that.rngState,_that.itemsCreated,_that.pityCounter,_that.prestige);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int lastTickAtMs,  int rngSeed,  int version,  int carryOverMs, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades, @BigNumConverter()  Map<String, BigNum> earnedThisRun,  int chapter,  int stage,  int wave,  Map<String, int> skills,  int heroLevel, @BigNumConverter()  BigNum heroExperience,  Map<String, OwnedItem> inventory,  Map<String, String> equipped,  List<int> rngState,  int itemsCreated,  int pityCounter,  PrestigeState prestige)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.carryOverMs,_that.resources,_that.generators,_that.upgrades,_that.earnedThisRun,_that.chapter,_that.stage,_that.wave,_that.skills,_that.heroLevel,_that.heroExperience,_that.inventory,_that.equipped,_that.rngState,_that.itemsCreated,_that.pityCounter,_that.prestige);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int lastTickAtMs,  int rngSeed,  int version,  int carryOverMs, @BigNumConverter()  Map<String, BigNum> resources,  Map<String, GeneratorState> generators,  Map<String, int> upgrades, @BigNumConverter()  Map<String, BigNum> earnedThisRun,  int chapter,  int stage,  int wave,  Map<String, int> skills,  int heroLevel, @BigNumConverter()  BigNum heroExperience,  Map<String, OwnedItem> inventory,  Map<String, String> equipped,  List<int> rngState,  int itemsCreated,  int pityCounter,  PrestigeState prestige)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.lastTickAtMs,_that.rngSeed,_that.version,_that.carryOverMs,_that.resources,_that.generators,_that.upgrades,_that.earnedThisRun,_that.chapter,_that.stage,_that.wave,_that.skills,_that.heroLevel,_that.heroExperience,_that.inventory,_that.equipped,_that.rngState,_that.itemsCreated,_that.pityCounter,_that.prestige);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerState extends PlayerState {
  const _PlayerState({required this.lastTickAtMs, required this.rngSeed, this.version = stateSchemaVersion, this.carryOverMs = 0, @BigNumConverter() final  Map<String, BigNum> resources = const <String, BigNum>{}, final  Map<String, GeneratorState> generators = const <String, GeneratorState>{}, final  Map<String, int> upgrades = const <String, int>{}, @BigNumConverter() final  Map<String, BigNum> earnedThisRun = const <String, BigNum>{}, this.chapter = 1, this.stage = 1, this.wave = 0, final  Map<String, int> skills = const <String, int>{}, this.heroLevel = 0, @BigNumConverter() this.heroExperience = BigNum.zero, final  Map<String, OwnedItem> inventory = const <String, OwnedItem>{}, final  Map<String, String> equipped = const <String, String>{}, final  List<int> rngState = const <int>[], this.itemsCreated = 0, this.pityCounter = 0, this.prestige = const PrestigeState()}): _resources = resources,_generators = generators,_upgrades = upgrades,_earnedThisRun = earnedThisRun,_skills = skills,_inventory = inventory,_equipped = equipped,_rngState = rngState,super._();
  factory _PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);

@override final  int lastTickAtMs;
@override final  int rngSeed;
@override@JsonKey() final  int version;
/// Milliseconds left over from the last tick that did not complete a whole
/// simulation step.
///
/// Progress is paid out in fixed one-second steps. Without carrying the
/// remainder, a client ticking at 30 Hz would round away a fraction of
/// every frame and drift measurably behind the server within a session.
@override@JsonKey() final  int carryOverMs;
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

/// Everything earned since the last prestige reset, per resource.
///
/// Tracked separately from [resources] because the prestige award is a
/// function of what the run *produced*, not of what is left after spending
/// it. Rewarding the balance on hand would punish the player for buying
/// the upgrades the run exists to buy.
 final  Map<String, BigNum> _earnedThisRun;
/// Everything earned since the last prestige reset, per resource.
///
/// Tracked separately from [resources] because the prestige award is a
/// function of what the run *produced*, not of what is left after spending
/// it. Rewarding the balance on hand would punish the player for buying
/// the upgrades the run exists to buy.
@override@JsonKey()@BigNumConverter() Map<String, BigNum> get earnedThisRun {
  if (_earnedThisRun is EqualUnmodifiableMapView) return _earnedThisRun;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_earnedThisRun);
}

/// Chapter, stage and wave: where the player is in the world.
@override@JsonKey() final  int chapter;
@override@JsonKey() final  int stage;
/// Waves cleared in this stage. At `wavesPerStage` the boss is next.
@override@JsonKey() final  int wave;
/// Skill levels, by skill id.
///
/// Reserved now and filled in with the skill system later. Adding a field
/// to the save format is a JSON edit today and a database migration once
/// the server owns this state.
 final  Map<String, int> _skills;
/// Skill levels, by skill id.
///
/// Reserved now and filled in with the skill system later. Adding a field
/// to the save format is a JSON edit today and a database migration once
/// the server owns this state.
@override@JsonKey() Map<String, int> get skills {
  if (_skills is EqualUnmodifiableMapView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_skills);
}

/// The hero's own level, earned by killing things.
@override@JsonKey() final  int heroLevel;
/// Experience banked towards the next level.
///
/// Only the remainder is kept, not a lifetime total: the total would be a
/// second number saying the same thing, and the two would drift apart the
/// first time a level formula changes.
@override@JsonKey()@BigNumConverter() final  BigNum heroExperience;
/// Every item the player owns, by its instance id.
 final  Map<String, OwnedItem> _inventory;
/// Every item the player owns, by its instance id.
@override@JsonKey() Map<String, OwnedItem> get inventory {
  if (_inventory is EqualUnmodifiableMapView) return _inventory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_inventory);
}

/// Slot name to the instance id worn in it.
///
/// Stored as slot -> item rather than a flag on the item so a slot can only
/// ever hold one thing: the invariant is in the shape of the data instead
/// of in code that has to remember to enforce it.
 final  Map<String, String> _equipped;
/// Slot name to the instance id worn in it.
///
/// Stored as slot -> item rather than a flag on the item so a slot can only
/// ever hold one thing: the invariant is in the shape of the data instead
/// of in code that has to remember to enforce it.
@override@JsonKey() Map<String, String> get equipped {
  if (_equipped is EqualUnmodifiableMapView) return _equipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_equipped);
}

/// Live RNG state, so randomness resumes rather than restarting.
///
/// Empty means "not drawn from yet"; the generator is then seeded from
/// [rngSeed]. Storing only the seed would make every lamp open after a
/// reload produce the same item.
 final  List<int> _rngState;
/// Live RNG state, so randomness resumes rather than restarting.
///
/// Empty means "not drawn from yet"; the generator is then seeded from
/// [rngSeed]. Storing only the seed would make every lamp open after a
/// reload produce the same item.
@override@JsonKey() List<int> get rngState {
  if (_rngState is EqualUnmodifiableListView) return _rngState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rngState);
}

/// Items created so far, used to mint ids.
///
/// A counter rather than a clock or a random value: the server has to
/// arrive at the same ids from the same state (`T-032`).
@override@JsonKey() final  int itemsCreated;
/// Opens since the pity rarity last dropped.
@override@JsonKey() final  int pityCounter;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.lastTickAtMs, lastTickAtMs) || other.lastTickAtMs == lastTickAtMs)&&(identical(other.rngSeed, rngSeed) || other.rngSeed == rngSeed)&&(identical(other.version, version) || other.version == version)&&(identical(other.carryOverMs, carryOverMs) || other.carryOverMs == carryOverMs)&&const DeepCollectionEquality().equals(other._resources, _resources)&&const DeepCollectionEquality().equals(other._generators, _generators)&&const DeepCollectionEquality().equals(other._upgrades, _upgrades)&&const DeepCollectionEquality().equals(other._earnedThisRun, _earnedThisRun)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.wave, wave) || other.wave == wave)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.heroLevel, heroLevel) || other.heroLevel == heroLevel)&&(identical(other.heroExperience, heroExperience) || other.heroExperience == heroExperience)&&const DeepCollectionEquality().equals(other._inventory, _inventory)&&const DeepCollectionEquality().equals(other._equipped, _equipped)&&const DeepCollectionEquality().equals(other._rngState, _rngState)&&(identical(other.itemsCreated, itemsCreated) || other.itemsCreated == itemsCreated)&&(identical(other.pityCounter, pityCounter) || other.pityCounter == pityCounter)&&(identical(other.prestige, prestige) || other.prestige == prestige));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,lastTickAtMs,rngSeed,version,carryOverMs,const DeepCollectionEquality().hash(_resources),const DeepCollectionEquality().hash(_generators),const DeepCollectionEquality().hash(_upgrades),const DeepCollectionEquality().hash(_earnedThisRun),chapter,stage,wave,const DeepCollectionEquality().hash(_skills),heroLevel,heroExperience,const DeepCollectionEquality().hash(_inventory),const DeepCollectionEquality().hash(_equipped),const DeepCollectionEquality().hash(_rngState),itemsCreated,pityCounter,prestige]);

@override
String toString() {
  return 'PlayerState(lastTickAtMs: $lastTickAtMs, rngSeed: $rngSeed, version: $version, carryOverMs: $carryOverMs, resources: $resources, generators: $generators, upgrades: $upgrades, earnedThisRun: $earnedThisRun, chapter: $chapter, stage: $stage, wave: $wave, skills: $skills, heroLevel: $heroLevel, heroExperience: $heroExperience, inventory: $inventory, equipped: $equipped, rngState: $rngState, itemsCreated: $itemsCreated, pityCounter: $pityCounter, prestige: $prestige)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 int lastTickAtMs, int rngSeed, int version, int carryOverMs,@BigNumConverter() Map<String, BigNum> resources, Map<String, GeneratorState> generators, Map<String, int> upgrades,@BigNumConverter() Map<String, BigNum> earnedThisRun, int chapter, int stage, int wave, Map<String, int> skills, int heroLevel,@BigNumConverter() BigNum heroExperience, Map<String, OwnedItem> inventory, Map<String, String> equipped, List<int> rngState, int itemsCreated, int pityCounter, PrestigeState prestige
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
@override @pragma('vm:prefer-inline') $Res call({Object? lastTickAtMs = null,Object? rngSeed = null,Object? version = null,Object? carryOverMs = null,Object? resources = null,Object? generators = null,Object? upgrades = null,Object? earnedThisRun = null,Object? chapter = null,Object? stage = null,Object? wave = null,Object? skills = null,Object? heroLevel = null,Object? heroExperience = null,Object? inventory = null,Object? equipped = null,Object? rngState = null,Object? itemsCreated = null,Object? pityCounter = null,Object? prestige = null,}) {
  return _then(_PlayerState(
lastTickAtMs: null == lastTickAtMs ? _self.lastTickAtMs : lastTickAtMs // ignore: cast_nullable_to_non_nullable
as int,rngSeed: null == rngSeed ? _self.rngSeed : rngSeed // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,carryOverMs: null == carryOverMs ? _self.carryOverMs : carryOverMs // ignore: cast_nullable_to_non_nullable
as int,resources: null == resources ? _self._resources : resources // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,generators: null == generators ? _self._generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorState>,upgrades: null == upgrades ? _self._upgrades : upgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,earnedThisRun: null == earnedThisRun ? _self._earnedThisRun : earnedThisRun // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as int,wave: null == wave ? _self.wave : wave // ignore: cast_nullable_to_non_nullable
as int,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, int>,heroLevel: null == heroLevel ? _self.heroLevel : heroLevel // ignore: cast_nullable_to_non_nullable
as int,heroExperience: null == heroExperience ? _self.heroExperience : heroExperience // ignore: cast_nullable_to_non_nullable
as BigNum,inventory: null == inventory ? _self._inventory : inventory // ignore: cast_nullable_to_non_nullable
as Map<String, OwnedItem>,equipped: null == equipped ? _self._equipped : equipped // ignore: cast_nullable_to_non_nullable
as Map<String, String>,rngState: null == rngState ? _self._rngState : rngState // ignore: cast_nullable_to_non_nullable
as List<int>,itemsCreated: null == itemsCreated ? _self.itemsCreated : itemsCreated // ignore: cast_nullable_to_non_nullable
as int,pityCounter: null == pityCounter ? _self.pityCounter : pityCounter // ignore: cast_nullable_to_non_nullable
as int,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
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
