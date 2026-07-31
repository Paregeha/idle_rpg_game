// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeConfig {

/// Id of the item this produces.
 String get produces;/// What it takes, by resource. Materials and currency alike — the forge
/// does not care which of them the shop calls a currency.
@BigNumConverter() Map<String, BigNum> get costs;/// Hero level before the recipe can be used at all.
///
/// A recipe shown while it is still locked is a goal. One hidden until it
/// is available is a surprise, and a player cannot save towards a surprise.
 int get unlockAtHeroLevel;
/// Create a copy of RecipeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeConfigCopyWith<RecipeConfig> get copyWith => _$RecipeConfigCopyWithImpl<RecipeConfig>(this as RecipeConfig, _$identity);

  /// Serializes this RecipeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeConfig&&(identical(other.produces, produces) || other.produces == produces)&&const DeepCollectionEquality().equals(other.costs, costs)&&(identical(other.unlockAtHeroLevel, unlockAtHeroLevel) || other.unlockAtHeroLevel == unlockAtHeroLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,produces,const DeepCollectionEquality().hash(costs),unlockAtHeroLevel);

@override
String toString() {
  return 'RecipeConfig(produces: $produces, costs: $costs, unlockAtHeroLevel: $unlockAtHeroLevel)';
}


}

/// @nodoc
abstract mixin class $RecipeConfigCopyWith<$Res>  {
  factory $RecipeConfigCopyWith(RecipeConfig value, $Res Function(RecipeConfig) _then) = _$RecipeConfigCopyWithImpl;
@useResult
$Res call({
 String produces,@BigNumConverter() Map<String, BigNum> costs, int unlockAtHeroLevel
});




}
/// @nodoc
class _$RecipeConfigCopyWithImpl<$Res>
    implements $RecipeConfigCopyWith<$Res> {
  _$RecipeConfigCopyWithImpl(this._self, this._then);

  final RecipeConfig _self;
  final $Res Function(RecipeConfig) _then;

/// Create a copy of RecipeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? produces = null,Object? costs = null,Object? unlockAtHeroLevel = null,}) {
  return _then(_self.copyWith(
produces: null == produces ? _self.produces : produces // ignore: cast_nullable_to_non_nullable
as String,costs: null == costs ? _self.costs : costs // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,unlockAtHeroLevel: null == unlockAtHeroLevel ? _self.unlockAtHeroLevel : unlockAtHeroLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeConfig].
extension RecipeConfigPatterns on RecipeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeConfig value)  $default,){
final _that = this;
switch (_that) {
case _RecipeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String produces, @BigNumConverter()  Map<String, BigNum> costs,  int unlockAtHeroLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeConfig() when $default != null:
return $default(_that.produces,_that.costs,_that.unlockAtHeroLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String produces, @BigNumConverter()  Map<String, BigNum> costs,  int unlockAtHeroLevel)  $default,) {final _that = this;
switch (_that) {
case _RecipeConfig():
return $default(_that.produces,_that.costs,_that.unlockAtHeroLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String produces, @BigNumConverter()  Map<String, BigNum> costs,  int unlockAtHeroLevel)?  $default,) {final _that = this;
switch (_that) {
case _RecipeConfig() when $default != null:
return $default(_that.produces,_that.costs,_that.unlockAtHeroLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeConfig extends RecipeConfig {
  const _RecipeConfig({this.produces = '', @BigNumConverter() final  Map<String, BigNum> costs = const <String, BigNum>{}, this.unlockAtHeroLevel = 0}): _costs = costs,super._();
  factory _RecipeConfig.fromJson(Map<String, dynamic> json) => _$RecipeConfigFromJson(json);

/// Id of the item this produces.
@override@JsonKey() final  String produces;
/// What it takes, by resource. Materials and currency alike — the forge
/// does not care which of them the shop calls a currency.
 final  Map<String, BigNum> _costs;
/// What it takes, by resource. Materials and currency alike — the forge
/// does not care which of them the shop calls a currency.
@override@JsonKey()@BigNumConverter() Map<String, BigNum> get costs {
  if (_costs is EqualUnmodifiableMapView) return _costs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_costs);
}

/// Hero level before the recipe can be used at all.
///
/// A recipe shown while it is still locked is a goal. One hidden until it
/// is available is a surprise, and a player cannot save towards a surprise.
@override@JsonKey() final  int unlockAtHeroLevel;

/// Create a copy of RecipeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeConfigCopyWith<_RecipeConfig> get copyWith => __$RecipeConfigCopyWithImpl<_RecipeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeConfig&&(identical(other.produces, produces) || other.produces == produces)&&const DeepCollectionEquality().equals(other._costs, _costs)&&(identical(other.unlockAtHeroLevel, unlockAtHeroLevel) || other.unlockAtHeroLevel == unlockAtHeroLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,produces,const DeepCollectionEquality().hash(_costs),unlockAtHeroLevel);

@override
String toString() {
  return 'RecipeConfig(produces: $produces, costs: $costs, unlockAtHeroLevel: $unlockAtHeroLevel)';
}


}

/// @nodoc
abstract mixin class _$RecipeConfigCopyWith<$Res> implements $RecipeConfigCopyWith<$Res> {
  factory _$RecipeConfigCopyWith(_RecipeConfig value, $Res Function(_RecipeConfig) _then) = __$RecipeConfigCopyWithImpl;
@override @useResult
$Res call({
 String produces,@BigNumConverter() Map<String, BigNum> costs, int unlockAtHeroLevel
});




}
/// @nodoc
class __$RecipeConfigCopyWithImpl<$Res>
    implements _$RecipeConfigCopyWith<$Res> {
  __$RecipeConfigCopyWithImpl(this._self, this._then);

  final _RecipeConfig _self;
  final $Res Function(_RecipeConfig) _then;

/// Create a copy of RecipeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? produces = null,Object? costs = null,Object? unlockAtHeroLevel = null,}) {
  return _then(_RecipeConfig(
produces: null == produces ? _self.produces : produces // ignore: cast_nullable_to_non_nullable
as String,costs: null == costs ? _self._costs : costs // ignore: cast_nullable_to_non_nullable
as Map<String, BigNum>,unlockAtHeroLevel: null == unlockAtHeroLevel ? _self.unlockAtHeroLevel : unlockAtHeroLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
