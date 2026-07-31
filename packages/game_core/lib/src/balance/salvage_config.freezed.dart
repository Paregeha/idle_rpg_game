// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salvage_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalvageConfig {

/// Resources paid per rarity key: `rarity -> resource -> amount`.
///
/// A map rather than a fixed pair of numbers, because what salvage pays is
/// a balance decision: today gold and scrap, tomorrow whatever crafting
/// turns out to need.
@BigNumConverter() Map<String, Map<String, BigNum>> get yields;/// Multiplier per level the item had reached, compounding.
///
/// Levels cost duplicates and gold, so an upgraded item that paid the same
/// as a fresh one would make upgrading anything a trap.
 double get levelMultiplier;
/// Create a copy of SalvageConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalvageConfigCopyWith<SalvageConfig> get copyWith => _$SalvageConfigCopyWithImpl<SalvageConfig>(this as SalvageConfig, _$identity);

  /// Serializes this SalvageConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalvageConfig&&const DeepCollectionEquality().equals(other.yields, yields)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(yields),levelMultiplier);

@override
String toString() {
  return 'SalvageConfig(yields: $yields, levelMultiplier: $levelMultiplier)';
}


}

/// @nodoc
abstract mixin class $SalvageConfigCopyWith<$Res>  {
  factory $SalvageConfigCopyWith(SalvageConfig value, $Res Function(SalvageConfig) _then) = _$SalvageConfigCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() Map<String, Map<String, BigNum>> yields, double levelMultiplier
});




}
/// @nodoc
class _$SalvageConfigCopyWithImpl<$Res>
    implements $SalvageConfigCopyWith<$Res> {
  _$SalvageConfigCopyWithImpl(this._self, this._then);

  final SalvageConfig _self;
  final $Res Function(SalvageConfig) _then;

/// Create a copy of SalvageConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? yields = null,Object? levelMultiplier = null,}) {
  return _then(_self.copyWith(
yields: null == yields ? _self.yields : yields // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, BigNum>>,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SalvageConfig].
extension SalvageConfigPatterns on SalvageConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalvageConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalvageConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalvageConfig value)  $default,){
final _that = this;
switch (_that) {
case _SalvageConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalvageConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SalvageConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  Map<String, Map<String, BigNum>> yields,  double levelMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalvageConfig() when $default != null:
return $default(_that.yields,_that.levelMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  Map<String, Map<String, BigNum>> yields,  double levelMultiplier)  $default,) {final _that = this;
switch (_that) {
case _SalvageConfig():
return $default(_that.yields,_that.levelMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  Map<String, Map<String, BigNum>> yields,  double levelMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _SalvageConfig() when $default != null:
return $default(_that.yields,_that.levelMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalvageConfig extends SalvageConfig {
  const _SalvageConfig({@BigNumConverter() final  Map<String, Map<String, BigNum>> yields = const <String, Map<String, BigNum>>{}, this.levelMultiplier = 1.5}): _yields = yields,super._();
  factory _SalvageConfig.fromJson(Map<String, dynamic> json) => _$SalvageConfigFromJson(json);

/// Resources paid per rarity key: `rarity -> resource -> amount`.
///
/// A map rather than a fixed pair of numbers, because what salvage pays is
/// a balance decision: today gold and scrap, tomorrow whatever crafting
/// turns out to need.
 final  Map<String, Map<String, BigNum>> _yields;
/// Resources paid per rarity key: `rarity -> resource -> amount`.
///
/// A map rather than a fixed pair of numbers, because what salvage pays is
/// a balance decision: today gold and scrap, tomorrow whatever crafting
/// turns out to need.
@override@JsonKey()@BigNumConverter() Map<String, Map<String, BigNum>> get yields {
  if (_yields is EqualUnmodifiableMapView) return _yields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_yields);
}

/// Multiplier per level the item had reached, compounding.
///
/// Levels cost duplicates and gold, so an upgraded item that paid the same
/// as a fresh one would make upgrading anything a trap.
@override@JsonKey() final  double levelMultiplier;

/// Create a copy of SalvageConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalvageConfigCopyWith<_SalvageConfig> get copyWith => __$SalvageConfigCopyWithImpl<_SalvageConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalvageConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalvageConfig&&const DeepCollectionEquality().equals(other._yields, _yields)&&(identical(other.levelMultiplier, levelMultiplier) || other.levelMultiplier == levelMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_yields),levelMultiplier);

@override
String toString() {
  return 'SalvageConfig(yields: $yields, levelMultiplier: $levelMultiplier)';
}


}

/// @nodoc
abstract mixin class _$SalvageConfigCopyWith<$Res> implements $SalvageConfigCopyWith<$Res> {
  factory _$SalvageConfigCopyWith(_SalvageConfig value, $Res Function(_SalvageConfig) _then) = __$SalvageConfigCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() Map<String, Map<String, BigNum>> yields, double levelMultiplier
});




}
/// @nodoc
class __$SalvageConfigCopyWithImpl<$Res>
    implements _$SalvageConfigCopyWith<$Res> {
  __$SalvageConfigCopyWithImpl(this._self, this._then);

  final _SalvageConfig _self;
  final $Res Function(_SalvageConfig) _then;

/// Create a copy of SalvageConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? yields = null,Object? levelMultiplier = null,}) {
  return _then(_SalvageConfig(
yields: null == yields ? _self._yields : yields // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, BigNum>>,levelMultiplier: null == levelMultiplier ? _self.levelMultiplier : levelMultiplier // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
