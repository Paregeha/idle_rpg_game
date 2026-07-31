// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BalanceConfig {

/// Schema version of this config.
 int get version; Map<String, GeneratorConfig> get generators; Map<String, MonsterConfig> get monsters; PrestigeConfig get prestige; HeroConfig get hero; ProgressionConfig get progression; LampConfig get lamp;/// Currencies shown in the top bar, in order.
///
/// Data, because which currencies exist is a balance decision. A currency
/// the player spends but cannot see is the sort of thing that reads as a
/// bug — the lamp cost gems the bar never showed until this was added.
 List<String> get displayedResources; ItemUpgradeConfig get itemUpgrade;/// Equipment slots. Data rather than an enum: adding a slot must be a
/// change to this file, not a code change.
 List<SlotConfig> get slots; Map<String, RarityConfig> get rarities; Map<String, ItemConfig> get items;/// Skills the hero can learn, by id.
 Map<String, SkillConfig> get skills;/// Where skill copies come from: the pack, bosses and monsters.
 SkillPackConfig get skillPack;/// What breaking an item down pays.
 SalvageConfig get salvage;/// What the forge can make, by recipe id.
 Map<String, RecipeConfig> get recipes;/// Resources that are crafting materials rather than currencies.
///
/// Data, because which of them exist is a balance decision. The bag shows
/// these on its own tab; the top row shows `displayedResources`.
 List<String> get materialResources; StartConfig get start;/// How much of an absence is paid out, in milliseconds.
///
/// The cap is what keeps an idle game a game: without it, returning after a
/// month would hand over a month of progress and skip the part the player
/// is here for.
 int get offlineCapMs;
/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BalanceConfigCopyWith<BalanceConfig> get copyWith => _$BalanceConfigCopyWithImpl<BalanceConfig>(this as BalanceConfig, _$identity);

  /// Serializes this BalanceConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BalanceConfig&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.generators, generators)&&const DeepCollectionEquality().equals(other.monsters, monsters)&&(identical(other.prestige, prestige) || other.prestige == prestige)&&(identical(other.hero, hero) || other.hero == hero)&&(identical(other.progression, progression) || other.progression == progression)&&(identical(other.lamp, lamp) || other.lamp == lamp)&&const DeepCollectionEquality().equals(other.displayedResources, displayedResources)&&(identical(other.itemUpgrade, itemUpgrade) || other.itemUpgrade == itemUpgrade)&&const DeepCollectionEquality().equals(other.slots, slots)&&const DeepCollectionEquality().equals(other.rarities, rarities)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.skills, skills)&&(identical(other.skillPack, skillPack) || other.skillPack == skillPack)&&(identical(other.salvage, salvage) || other.salvage == salvage)&&const DeepCollectionEquality().equals(other.recipes, recipes)&&const DeepCollectionEquality().equals(other.materialResources, materialResources)&&(identical(other.start, start) || other.start == start)&&(identical(other.offlineCapMs, offlineCapMs) || other.offlineCapMs == offlineCapMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,version,const DeepCollectionEquality().hash(generators),const DeepCollectionEquality().hash(monsters),prestige,hero,progression,lamp,const DeepCollectionEquality().hash(displayedResources),itemUpgrade,const DeepCollectionEquality().hash(slots),const DeepCollectionEquality().hash(rarities),const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(skills),skillPack,salvage,const DeepCollectionEquality().hash(recipes),const DeepCollectionEquality().hash(materialResources),start,offlineCapMs]);

@override
String toString() {
  return 'BalanceConfig(version: $version, generators: $generators, monsters: $monsters, prestige: $prestige, hero: $hero, progression: $progression, lamp: $lamp, displayedResources: $displayedResources, itemUpgrade: $itemUpgrade, slots: $slots, rarities: $rarities, items: $items, skills: $skills, skillPack: $skillPack, salvage: $salvage, recipes: $recipes, materialResources: $materialResources, start: $start, offlineCapMs: $offlineCapMs)';
}


}

/// @nodoc
abstract mixin class $BalanceConfigCopyWith<$Res>  {
  factory $BalanceConfigCopyWith(BalanceConfig value, $Res Function(BalanceConfig) _then) = _$BalanceConfigCopyWithImpl;
@useResult
$Res call({
 int version, Map<String, GeneratorConfig> generators, Map<String, MonsterConfig> monsters, PrestigeConfig prestige, HeroConfig hero, ProgressionConfig progression, LampConfig lamp, List<String> displayedResources, ItemUpgradeConfig itemUpgrade, List<SlotConfig> slots, Map<String, RarityConfig> rarities, Map<String, ItemConfig> items, Map<String, SkillConfig> skills, SkillPackConfig skillPack, SalvageConfig salvage, Map<String, RecipeConfig> recipes, List<String> materialResources, StartConfig start, int offlineCapMs
});


$PrestigeConfigCopyWith<$Res> get prestige;$HeroConfigCopyWith<$Res> get hero;$ProgressionConfigCopyWith<$Res> get progression;$LampConfigCopyWith<$Res> get lamp;$ItemUpgradeConfigCopyWith<$Res> get itemUpgrade;$SkillPackConfigCopyWith<$Res> get skillPack;$SalvageConfigCopyWith<$Res> get salvage;$StartConfigCopyWith<$Res> get start;

}
/// @nodoc
class _$BalanceConfigCopyWithImpl<$Res>
    implements $BalanceConfigCopyWith<$Res> {
  _$BalanceConfigCopyWithImpl(this._self, this._then);

  final BalanceConfig _self;
  final $Res Function(BalanceConfig) _then;

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? generators = null,Object? monsters = null,Object? prestige = null,Object? hero = null,Object? progression = null,Object? lamp = null,Object? displayedResources = null,Object? itemUpgrade = null,Object? slots = null,Object? rarities = null,Object? items = null,Object? skills = null,Object? skillPack = null,Object? salvage = null,Object? recipes = null,Object? materialResources = null,Object? start = null,Object? offlineCapMs = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,generators: null == generators ? _self.generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorConfig>,monsters: null == monsters ? _self.monsters : monsters // ignore: cast_nullable_to_non_nullable
as Map<String, MonsterConfig>,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
as PrestigeConfig,hero: null == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as HeroConfig,progression: null == progression ? _self.progression : progression // ignore: cast_nullable_to_non_nullable
as ProgressionConfig,lamp: null == lamp ? _self.lamp : lamp // ignore: cast_nullable_to_non_nullable
as LampConfig,displayedResources: null == displayedResources ? _self.displayedResources : displayedResources // ignore: cast_nullable_to_non_nullable
as List<String>,itemUpgrade: null == itemUpgrade ? _self.itemUpgrade : itemUpgrade // ignore: cast_nullable_to_non_nullable
as ItemUpgradeConfig,slots: null == slots ? _self.slots : slots // ignore: cast_nullable_to_non_nullable
as List<SlotConfig>,rarities: null == rarities ? _self.rarities : rarities // ignore: cast_nullable_to_non_nullable
as Map<String, RarityConfig>,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as Map<String, ItemConfig>,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, SkillConfig>,skillPack: null == skillPack ? _self.skillPack : skillPack // ignore: cast_nullable_to_non_nullable
as SkillPackConfig,salvage: null == salvage ? _self.salvage : salvage // ignore: cast_nullable_to_non_nullable
as SalvageConfig,recipes: null == recipes ? _self.recipes : recipes // ignore: cast_nullable_to_non_nullable
as Map<String, RecipeConfig>,materialResources: null == materialResources ? _self.materialResources : materialResources // ignore: cast_nullable_to_non_nullable
as List<String>,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as StartConfig,offlineCapMs: null == offlineCapMs ? _self.offlineCapMs : offlineCapMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrestigeConfigCopyWith<$Res> get prestige {
  
  return $PrestigeConfigCopyWith<$Res>(_self.prestige, (value) {
    return _then(_self.copyWith(prestige: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeroConfigCopyWith<$Res> get hero {
  
  return $HeroConfigCopyWith<$Res>(_self.hero, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressionConfigCopyWith<$Res> get progression {
  
  return $ProgressionConfigCopyWith<$Res>(_self.progression, (value) {
    return _then(_self.copyWith(progression: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LampConfigCopyWith<$Res> get lamp {
  
  return $LampConfigCopyWith<$Res>(_self.lamp, (value) {
    return _then(_self.copyWith(lamp: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemUpgradeConfigCopyWith<$Res> get itemUpgrade {
  
  return $ItemUpgradeConfigCopyWith<$Res>(_self.itemUpgrade, (value) {
    return _then(_self.copyWith(itemUpgrade: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkillPackConfigCopyWith<$Res> get skillPack {
  
  return $SkillPackConfigCopyWith<$Res>(_self.skillPack, (value) {
    return _then(_self.copyWith(skillPack: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalvageConfigCopyWith<$Res> get salvage {
  
  return $SalvageConfigCopyWith<$Res>(_self.salvage, (value) {
    return _then(_self.copyWith(salvage: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StartConfigCopyWith<$Res> get start {
  
  return $StartConfigCopyWith<$Res>(_self.start, (value) {
    return _then(_self.copyWith(start: value));
  });
}
}


/// Adds pattern-matching-related methods to [BalanceConfig].
extension BalanceConfigPatterns on BalanceConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BalanceConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BalanceConfig value)  $default,){
final _that = this;
switch (_that) {
case _BalanceConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BalanceConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  Map<String, GeneratorConfig> generators,  Map<String, MonsterConfig> monsters,  PrestigeConfig prestige,  HeroConfig hero,  ProgressionConfig progression,  LampConfig lamp,  List<String> displayedResources,  ItemUpgradeConfig itemUpgrade,  List<SlotConfig> slots,  Map<String, RarityConfig> rarities,  Map<String, ItemConfig> items,  Map<String, SkillConfig> skills,  SkillPackConfig skillPack,  SalvageConfig salvage,  Map<String, RecipeConfig> recipes,  List<String> materialResources,  StartConfig start,  int offlineCapMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
return $default(_that.version,_that.generators,_that.monsters,_that.prestige,_that.hero,_that.progression,_that.lamp,_that.displayedResources,_that.itemUpgrade,_that.slots,_that.rarities,_that.items,_that.skills,_that.skillPack,_that.salvage,_that.recipes,_that.materialResources,_that.start,_that.offlineCapMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  Map<String, GeneratorConfig> generators,  Map<String, MonsterConfig> monsters,  PrestigeConfig prestige,  HeroConfig hero,  ProgressionConfig progression,  LampConfig lamp,  List<String> displayedResources,  ItemUpgradeConfig itemUpgrade,  List<SlotConfig> slots,  Map<String, RarityConfig> rarities,  Map<String, ItemConfig> items,  Map<String, SkillConfig> skills,  SkillPackConfig skillPack,  SalvageConfig salvage,  Map<String, RecipeConfig> recipes,  List<String> materialResources,  StartConfig start,  int offlineCapMs)  $default,) {final _that = this;
switch (_that) {
case _BalanceConfig():
return $default(_that.version,_that.generators,_that.monsters,_that.prestige,_that.hero,_that.progression,_that.lamp,_that.displayedResources,_that.itemUpgrade,_that.slots,_that.rarities,_that.items,_that.skills,_that.skillPack,_that.salvage,_that.recipes,_that.materialResources,_that.start,_that.offlineCapMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  Map<String, GeneratorConfig> generators,  Map<String, MonsterConfig> monsters,  PrestigeConfig prestige,  HeroConfig hero,  ProgressionConfig progression,  LampConfig lamp,  List<String> displayedResources,  ItemUpgradeConfig itemUpgrade,  List<SlotConfig> slots,  Map<String, RarityConfig> rarities,  Map<String, ItemConfig> items,  Map<String, SkillConfig> skills,  SkillPackConfig skillPack,  SalvageConfig salvage,  Map<String, RecipeConfig> recipes,  List<String> materialResources,  StartConfig start,  int offlineCapMs)?  $default,) {final _that = this;
switch (_that) {
case _BalanceConfig() when $default != null:
return $default(_that.version,_that.generators,_that.monsters,_that.prestige,_that.hero,_that.progression,_that.lamp,_that.displayedResources,_that.itemUpgrade,_that.slots,_that.rarities,_that.items,_that.skills,_that.skillPack,_that.salvage,_that.recipes,_that.materialResources,_that.start,_that.offlineCapMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BalanceConfig extends BalanceConfig {
  const _BalanceConfig({this.version = supportedBalanceVersion, final  Map<String, GeneratorConfig> generators = const <String, GeneratorConfig>{}, final  Map<String, MonsterConfig> monsters = const <String, MonsterConfig>{}, this.prestige = const PrestigeConfig(), this.hero = const HeroConfig(), this.progression = const ProgressionConfig(), this.lamp = const LampConfig(), final  List<String> displayedResources = const <String>[], this.itemUpgrade = const ItemUpgradeConfig(), final  List<SlotConfig> slots = const <SlotConfig>[], final  Map<String, RarityConfig> rarities = const <String, RarityConfig>{}, final  Map<String, ItemConfig> items = const <String, ItemConfig>{}, final  Map<String, SkillConfig> skills = const <String, SkillConfig>{}, this.skillPack = const SkillPackConfig(), this.salvage = const SalvageConfig(), final  Map<String, RecipeConfig> recipes = const <String, RecipeConfig>{}, final  List<String> materialResources = const <String>[], this.start = const StartConfig(), this.offlineCapMs = _eightHoursMs}): _generators = generators,_monsters = monsters,_displayedResources = displayedResources,_slots = slots,_rarities = rarities,_items = items,_skills = skills,_recipes = recipes,_materialResources = materialResources,super._();
  factory _BalanceConfig.fromJson(Map<String, dynamic> json) => _$BalanceConfigFromJson(json);

/// Schema version of this config.
@override@JsonKey() final  int version;
 final  Map<String, GeneratorConfig> _generators;
@override@JsonKey() Map<String, GeneratorConfig> get generators {
  if (_generators is EqualUnmodifiableMapView) return _generators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_generators);
}

 final  Map<String, MonsterConfig> _monsters;
@override@JsonKey() Map<String, MonsterConfig> get monsters {
  if (_monsters is EqualUnmodifiableMapView) return _monsters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monsters);
}

@override@JsonKey() final  PrestigeConfig prestige;
@override@JsonKey() final  HeroConfig hero;
@override@JsonKey() final  ProgressionConfig progression;
@override@JsonKey() final  LampConfig lamp;
/// Currencies shown in the top bar, in order.
///
/// Data, because which currencies exist is a balance decision. A currency
/// the player spends but cannot see is the sort of thing that reads as a
/// bug — the lamp cost gems the bar never showed until this was added.
 final  List<String> _displayedResources;
/// Currencies shown in the top bar, in order.
///
/// Data, because which currencies exist is a balance decision. A currency
/// the player spends but cannot see is the sort of thing that reads as a
/// bug — the lamp cost gems the bar never showed until this was added.
@override@JsonKey() List<String> get displayedResources {
  if (_displayedResources is EqualUnmodifiableListView) return _displayedResources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_displayedResources);
}

@override@JsonKey() final  ItemUpgradeConfig itemUpgrade;
/// Equipment slots. Data rather than an enum: adding a slot must be a
/// change to this file, not a code change.
 final  List<SlotConfig> _slots;
/// Equipment slots. Data rather than an enum: adding a slot must be a
/// change to this file, not a code change.
@override@JsonKey() List<SlotConfig> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}

 final  Map<String, RarityConfig> _rarities;
@override@JsonKey() Map<String, RarityConfig> get rarities {
  if (_rarities is EqualUnmodifiableMapView) return _rarities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rarities);
}

 final  Map<String, ItemConfig> _items;
@override@JsonKey() Map<String, ItemConfig> get items {
  if (_items is EqualUnmodifiableMapView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_items);
}

/// Skills the hero can learn, by id.
 final  Map<String, SkillConfig> _skills;
/// Skills the hero can learn, by id.
@override@JsonKey() Map<String, SkillConfig> get skills {
  if (_skills is EqualUnmodifiableMapView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_skills);
}

/// Where skill copies come from: the pack, bosses and monsters.
@override@JsonKey() final  SkillPackConfig skillPack;
/// What breaking an item down pays.
@override@JsonKey() final  SalvageConfig salvage;
/// What the forge can make, by recipe id.
 final  Map<String, RecipeConfig> _recipes;
/// What the forge can make, by recipe id.
@override@JsonKey() Map<String, RecipeConfig> get recipes {
  if (_recipes is EqualUnmodifiableMapView) return _recipes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recipes);
}

/// Resources that are crafting materials rather than currencies.
///
/// Data, because which of them exist is a balance decision. The bag shows
/// these on its own tab; the top row shows `displayedResources`.
 final  List<String> _materialResources;
/// Resources that are crafting materials rather than currencies.
///
/// Data, because which of them exist is a balance decision. The bag shows
/// these on its own tab; the top row shows `displayedResources`.
@override@JsonKey() List<String> get materialResources {
  if (_materialResources is EqualUnmodifiableListView) return _materialResources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_materialResources);
}

@override@JsonKey() final  StartConfig start;
/// How much of an absence is paid out, in milliseconds.
///
/// The cap is what keeps an idle game a game: without it, returning after a
/// month would hand over a month of progress and skip the part the player
/// is here for.
@override@JsonKey() final  int offlineCapMs;

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BalanceConfigCopyWith<_BalanceConfig> get copyWith => __$BalanceConfigCopyWithImpl<_BalanceConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BalanceConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BalanceConfig&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._generators, _generators)&&const DeepCollectionEquality().equals(other._monsters, _monsters)&&(identical(other.prestige, prestige) || other.prestige == prestige)&&(identical(other.hero, hero) || other.hero == hero)&&(identical(other.progression, progression) || other.progression == progression)&&(identical(other.lamp, lamp) || other.lamp == lamp)&&const DeepCollectionEquality().equals(other._displayedResources, _displayedResources)&&(identical(other.itemUpgrade, itemUpgrade) || other.itemUpgrade == itemUpgrade)&&const DeepCollectionEquality().equals(other._slots, _slots)&&const DeepCollectionEquality().equals(other._rarities, _rarities)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._skills, _skills)&&(identical(other.skillPack, skillPack) || other.skillPack == skillPack)&&(identical(other.salvage, salvage) || other.salvage == salvage)&&const DeepCollectionEquality().equals(other._recipes, _recipes)&&const DeepCollectionEquality().equals(other._materialResources, _materialResources)&&(identical(other.start, start) || other.start == start)&&(identical(other.offlineCapMs, offlineCapMs) || other.offlineCapMs == offlineCapMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,version,const DeepCollectionEquality().hash(_generators),const DeepCollectionEquality().hash(_monsters),prestige,hero,progression,lamp,const DeepCollectionEquality().hash(_displayedResources),itemUpgrade,const DeepCollectionEquality().hash(_slots),const DeepCollectionEquality().hash(_rarities),const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_skills),skillPack,salvage,const DeepCollectionEquality().hash(_recipes),const DeepCollectionEquality().hash(_materialResources),start,offlineCapMs]);

@override
String toString() {
  return 'BalanceConfig(version: $version, generators: $generators, monsters: $monsters, prestige: $prestige, hero: $hero, progression: $progression, lamp: $lamp, displayedResources: $displayedResources, itemUpgrade: $itemUpgrade, slots: $slots, rarities: $rarities, items: $items, skills: $skills, skillPack: $skillPack, salvage: $salvage, recipes: $recipes, materialResources: $materialResources, start: $start, offlineCapMs: $offlineCapMs)';
}


}

/// @nodoc
abstract mixin class _$BalanceConfigCopyWith<$Res> implements $BalanceConfigCopyWith<$Res> {
  factory _$BalanceConfigCopyWith(_BalanceConfig value, $Res Function(_BalanceConfig) _then) = __$BalanceConfigCopyWithImpl;
@override @useResult
$Res call({
 int version, Map<String, GeneratorConfig> generators, Map<String, MonsterConfig> monsters, PrestigeConfig prestige, HeroConfig hero, ProgressionConfig progression, LampConfig lamp, List<String> displayedResources, ItemUpgradeConfig itemUpgrade, List<SlotConfig> slots, Map<String, RarityConfig> rarities, Map<String, ItemConfig> items, Map<String, SkillConfig> skills, SkillPackConfig skillPack, SalvageConfig salvage, Map<String, RecipeConfig> recipes, List<String> materialResources, StartConfig start, int offlineCapMs
});


@override $PrestigeConfigCopyWith<$Res> get prestige;@override $HeroConfigCopyWith<$Res> get hero;@override $ProgressionConfigCopyWith<$Res> get progression;@override $LampConfigCopyWith<$Res> get lamp;@override $ItemUpgradeConfigCopyWith<$Res> get itemUpgrade;@override $SkillPackConfigCopyWith<$Res> get skillPack;@override $SalvageConfigCopyWith<$Res> get salvage;@override $StartConfigCopyWith<$Res> get start;

}
/// @nodoc
class __$BalanceConfigCopyWithImpl<$Res>
    implements _$BalanceConfigCopyWith<$Res> {
  __$BalanceConfigCopyWithImpl(this._self, this._then);

  final _BalanceConfig _self;
  final $Res Function(_BalanceConfig) _then;

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? generators = null,Object? monsters = null,Object? prestige = null,Object? hero = null,Object? progression = null,Object? lamp = null,Object? displayedResources = null,Object? itemUpgrade = null,Object? slots = null,Object? rarities = null,Object? items = null,Object? skills = null,Object? skillPack = null,Object? salvage = null,Object? recipes = null,Object? materialResources = null,Object? start = null,Object? offlineCapMs = null,}) {
  return _then(_BalanceConfig(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,generators: null == generators ? _self._generators : generators // ignore: cast_nullable_to_non_nullable
as Map<String, GeneratorConfig>,monsters: null == monsters ? _self._monsters : monsters // ignore: cast_nullable_to_non_nullable
as Map<String, MonsterConfig>,prestige: null == prestige ? _self.prestige : prestige // ignore: cast_nullable_to_non_nullable
as PrestigeConfig,hero: null == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as HeroConfig,progression: null == progression ? _self.progression : progression // ignore: cast_nullable_to_non_nullable
as ProgressionConfig,lamp: null == lamp ? _self.lamp : lamp // ignore: cast_nullable_to_non_nullable
as LampConfig,displayedResources: null == displayedResources ? _self._displayedResources : displayedResources // ignore: cast_nullable_to_non_nullable
as List<String>,itemUpgrade: null == itemUpgrade ? _self.itemUpgrade : itemUpgrade // ignore: cast_nullable_to_non_nullable
as ItemUpgradeConfig,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<SlotConfig>,rarities: null == rarities ? _self._rarities : rarities // ignore: cast_nullable_to_non_nullable
as Map<String, RarityConfig>,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as Map<String, ItemConfig>,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as Map<String, SkillConfig>,skillPack: null == skillPack ? _self.skillPack : skillPack // ignore: cast_nullable_to_non_nullable
as SkillPackConfig,salvage: null == salvage ? _self.salvage : salvage // ignore: cast_nullable_to_non_nullable
as SalvageConfig,recipes: null == recipes ? _self._recipes : recipes // ignore: cast_nullable_to_non_nullable
as Map<String, RecipeConfig>,materialResources: null == materialResources ? _self._materialResources : materialResources // ignore: cast_nullable_to_non_nullable
as List<String>,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as StartConfig,offlineCapMs: null == offlineCapMs ? _self.offlineCapMs : offlineCapMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PrestigeConfigCopyWith<$Res> get prestige {
  
  return $PrestigeConfigCopyWith<$Res>(_self.prestige, (value) {
    return _then(_self.copyWith(prestige: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HeroConfigCopyWith<$Res> get hero {
  
  return $HeroConfigCopyWith<$Res>(_self.hero, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgressionConfigCopyWith<$Res> get progression {
  
  return $ProgressionConfigCopyWith<$Res>(_self.progression, (value) {
    return _then(_self.copyWith(progression: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LampConfigCopyWith<$Res> get lamp {
  
  return $LampConfigCopyWith<$Res>(_self.lamp, (value) {
    return _then(_self.copyWith(lamp: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemUpgradeConfigCopyWith<$Res> get itemUpgrade {
  
  return $ItemUpgradeConfigCopyWith<$Res>(_self.itemUpgrade, (value) {
    return _then(_self.copyWith(itemUpgrade: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SkillPackConfigCopyWith<$Res> get skillPack {
  
  return $SkillPackConfigCopyWith<$Res>(_self.skillPack, (value) {
    return _then(_self.copyWith(skillPack: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SalvageConfigCopyWith<$Res> get salvage {
  
  return $SalvageConfigCopyWith<$Res>(_self.salvage, (value) {
    return _then(_self.copyWith(salvage: value));
  });
}/// Create a copy of BalanceConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StartConfigCopyWith<$Res> get start {
  
  return $StartConfigCopyWith<$Res>(_self.start, (value) {
    return _then(_self.copyWith(start: value));
  });
}
}

// dart format on
