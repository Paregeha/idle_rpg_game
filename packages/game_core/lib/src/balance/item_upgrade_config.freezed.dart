// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_upgrade_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemUpgradeConfig {

/// Resource spent per level.
 String get costResource;/// Price of the first level.
@BigNumConverter() BigNum get costBase;/// Price is multiplied by this per level already reached.
 double get costGrowth;/// Resource a given item kind is paid for, when it is not [costResource].
///
/// Wings, skins and mounts cost crystals rather than gold. Keeping that in
/// data means "which of these is premium" is a balance decision, and the
/// screens can work it out rather than being told twice.
 Map<String, String> get costResourceByKind;/// First-level price for a kind that has its own resource.
///
/// A crystal price cannot be on the gold curve — a hundred thousand
/// crystals is not a price, it is a wall.
@BigNumConverter() Map<String, BigNum> get costBaseByKind;/// Spare copies consumed per level, on top of the resource cost.
///
/// Zero means duplicates are not required — which keeps the lamp useful
/// even for a player who never pulls the same item twice.
 int get duplicatesPerLevel;
/// Create a copy of ItemUpgradeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemUpgradeConfigCopyWith<ItemUpgradeConfig> get copyWith => _$ItemUpgradeConfigCopyWithImpl<ItemUpgradeConfig>(this as ItemUpgradeConfig, _$identity);

  /// Serializes this ItemUpgradeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemUpgradeConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costBase, costBase) || other.costBase == costBase)&&(identical(other.costGrowth, costGrowth) || other.costGrowth == costGrowth)&&const DeepCollectionEquality().equals(other.costResourceByKind, costResourceByKind)&&const DeepCollectionEquality().equals(other.costBaseByKind, costBaseByKind)&&(identical(other.duplicatesPerLevel, duplicatesPerLevel) || other.duplicatesPerLevel == duplicatesPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costBase,costGrowth,const DeepCollectionEquality().hash(costResourceByKind),const DeepCollectionEquality().hash(costBaseByKind),duplicatesPerLevel);

@override
String toString() {
  return 'ItemUpgradeConfig(costResource: $costResource, costBase: $costBase, costGrowth: $costGrowth, costResourceByKind: $costResourceByKind, costBaseByKind: $costBaseByKind, duplicatesPerLevel: $duplicatesPerLevel)';
}


}

/// @nodoc
abstract mixin class $ItemUpgradeConfigCopyWith<$Res>  {
  factory $ItemUpgradeConfigCopyWith(ItemUpgradeConfig value, $Res Function(ItemUpgradeConfig) _then) = _$ItemUpgradeConfigCopyWithImpl;
@useResult
$Res call({
 String costResource,@BigNumConverter() BigNum costBase, double costGrowth, Map<String, String> costResourceByKind,@BigNumConverter() Map<String, BigNum> costBaseByKind, int duplicatesPerLevel
});




}
/// @nodoc
class _$ItemUpgradeConfigCopyWithImpl<$Res>
    implements $ItemUpgradeConfigCopyWith<$Res> {
  _$ItemUpgradeConfigCopyWithImpl(this._self, this._then);

  final ItemUpgradeConfig _self;
  final $Res Function(ItemUpgradeConfig) _then;

/// Create a copy of ItemUpgradeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? costResource = null,Object? costBase = null,Object? costGrowth = null,Object? costResourceByKind = null,Object? costBaseByKind = null,Object? duplicatesPerLevel = null,}) {
  return _then(_self.copyWith(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costBase: null == costBase ? _self.costBase : costBase // ignore: cast_nullable_to_non_nullable
as BigNum,costGrowth: null == costGrowth ? _self.costGrowth : costGrowth // ignore: cast_nullable_to_non_nullable
as double,costResourceByKind: null == costResourceByKind ? _self.costResourceByKind : costResourceByKind // ignore: cast_nullable_to_non_nullable
as Map<String, String>,costBaseByKind: null == costBaseByKind ? _self.costBaseByKind : costBaseByKind // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,duplicatesPerLevel: null == duplicatesPerLevel ? _self.duplicatesPerLevel : duplicatesPerLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemUpgradeConfig].
extension ItemUpgradeConfigPatterns on ItemUpgradeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemUpgradeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemUpgradeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemUpgradeConfig value)  $default,){
final _that = this;
switch (_that) {
case _ItemUpgradeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemUpgradeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ItemUpgradeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String costResource, @BigNumConverter()  BigNum costBase,  double costGrowth,  Map<String, String> costResourceByKind, @BigNumConverter()  Map<String, BigNum> costBaseByKind,  int duplicatesPerLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemUpgradeConfig() when $default != null:
return $default(_that.costResource,_that.costBase,_that.costGrowth,_that.costResourceByKind,_that.costBaseByKind,_that.duplicatesPerLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String costResource, @BigNumConverter()  BigNum costBase,  double costGrowth,  Map<String, String> costResourceByKind, @BigNumConverter()  Map<String, BigNum> costBaseByKind,  int duplicatesPerLevel)  $default,) {final _that = this;
switch (_that) {
case _ItemUpgradeConfig():
return $default(_that.costResource,_that.costBase,_that.costGrowth,_that.costResourceByKind,_that.costBaseByKind,_that.duplicatesPerLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String costResource, @BigNumConverter()  BigNum costBase,  double costGrowth,  Map<String, String> costResourceByKind, @BigNumConverter()  Map<String, BigNum> costBaseByKind,  int duplicatesPerLevel)?  $default,) {final _that = this;
switch (_that) {
case _ItemUpgradeConfig() when $default != null:
return $default(_that.costResource,_that.costBase,_that.costGrowth,_that.costResourceByKind,_that.costBaseByKind,_that.duplicatesPerLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemUpgradeConfig extends ItemUpgradeConfig {
  const _ItemUpgradeConfig({this.costResource = 'gold', @BigNumConverter() this.costBase = BigNum.one, this.costGrowth = 1.6, final  Map<String, String> costResourceByKind = const <String, String>{}, @BigNumConverter() final  Map<String, BigNum> costBaseByKind = const <String, BigNum>{}, this.duplicatesPerLevel = 0}): _costResourceByKind = costResourceByKind,_costBaseByKind = costBaseByKind,super._();
  factory _ItemUpgradeConfig.fromJson(Map<String, dynamic> json) => _$ItemUpgradeConfigFromJson(json);

/// Resource spent per level.
@override@JsonKey() final  String costResource;
/// Price of the first level.
@override@JsonKey()@BigNumConverter() final  BigNum costBase;
/// Price is multiplied by this per level already reached.
@override@JsonKey() final  double costGrowth;
/// Resource a given item kind is paid for, when it is not [costResource].
///
/// Wings, skins and mounts cost crystals rather than gold. Keeping that in
/// data means "which of these is premium" is a balance decision, and the
/// screens can work it out rather than being told twice.
 final  Map<String, String> _costResourceByKind;
/// Resource a given item kind is paid for, when it is not [costResource].
///
/// Wings, skins and mounts cost crystals rather than gold. Keeping that in
/// data means "which of these is premium" is a balance decision, and the
/// screens can work it out rather than being told twice.
@override@JsonKey() Map<String, String> get costResourceByKind {
  if (_costResourceByKind is EqualUnmodifiableMapView) return _costResourceByKind;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_costResourceByKind);
}

/// First-level price for a kind that has its own resource.
///
/// A crystal price cannot be on the gold curve — a hundred thousand
/// crystals is not a price, it is a wall.
 final  Map<String, BigNum> _costBaseByKind;
/// First-level price for a kind that has its own resource.
///
/// A crystal price cannot be on the gold curve — a hundred thousand
/// crystals is not a price, it is a wall.
@override@JsonKey()@BigNumConverter() Map<String, BigNum> get costBaseByKind {
  if (_costBaseByKind is EqualUnmodifiableMapView) return _costBaseByKind;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_costBaseByKind);
}

/// Spare copies consumed per level, on top of the resource cost.
///
/// Zero means duplicates are not required — which keeps the lamp useful
/// even for a player who never pulls the same item twice.
@override@JsonKey() final  int duplicatesPerLevel;

/// Create a copy of ItemUpgradeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemUpgradeConfigCopyWith<_ItemUpgradeConfig> get copyWith => __$ItemUpgradeConfigCopyWithImpl<_ItemUpgradeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemUpgradeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemUpgradeConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costBase, costBase) || other.costBase == costBase)&&(identical(other.costGrowth, costGrowth) || other.costGrowth == costGrowth)&&const DeepCollectionEquality().equals(other._costResourceByKind, _costResourceByKind)&&const DeepCollectionEquality().equals(other._costBaseByKind, _costBaseByKind)&&(identical(other.duplicatesPerLevel, duplicatesPerLevel) || other.duplicatesPerLevel == duplicatesPerLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costBase,costGrowth,const DeepCollectionEquality().hash(_costResourceByKind),const DeepCollectionEquality().hash(_costBaseByKind),duplicatesPerLevel);

@override
String toString() {
  return 'ItemUpgradeConfig(costResource: $costResource, costBase: $costBase, costGrowth: $costGrowth, costResourceByKind: $costResourceByKind, costBaseByKind: $costBaseByKind, duplicatesPerLevel: $duplicatesPerLevel)';
}


}

/// @nodoc
abstract mixin class _$ItemUpgradeConfigCopyWith<$Res> implements $ItemUpgradeConfigCopyWith<$Res> {
  factory _$ItemUpgradeConfigCopyWith(_ItemUpgradeConfig value, $Res Function(_ItemUpgradeConfig) _then) = __$ItemUpgradeConfigCopyWithImpl;
@override @useResult
$Res call({
 String costResource,@BigNumConverter() BigNum costBase, double costGrowth, Map<String, String> costResourceByKind,@BigNumConverter() Map<String, BigNum> costBaseByKind, int duplicatesPerLevel
});




}
/// @nodoc
class __$ItemUpgradeConfigCopyWithImpl<$Res>
    implements _$ItemUpgradeConfigCopyWith<$Res> {
  __$ItemUpgradeConfigCopyWithImpl(this._self, this._then);

  final _ItemUpgradeConfig _self;
  final $Res Function(_ItemUpgradeConfig) _then;

/// Create a copy of ItemUpgradeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? costResource = null,Object? costBase = null,Object? costGrowth = null,Object? costResourceByKind = null,Object? costBaseByKind = null,Object? duplicatesPerLevel = null,}) {
  return _then(_ItemUpgradeConfig(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costBase: null == costBase ? _self.costBase : costBase // ignore: cast_nullable_to_non_nullable
as BigNum,costGrowth: null == costGrowth ? _self.costGrowth : costGrowth // ignore: cast_nullable_to_non_nullable
as double,costResourceByKind: null == costResourceByKind ? _self._costResourceByKind : costResourceByKind // ignore: cast_nullable_to_non_nullable
as Map<String, String>,costBaseByKind: null == costBaseByKind ? _self._costBaseByKind : costBaseByKind // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,duplicatesPerLevel: null == duplicatesPerLevel ? _self.duplicatesPerLevel : duplicatesPerLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
