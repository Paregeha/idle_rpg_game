// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lamp_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LampConfig {

/// Resource spent per open.
 String get costResource;@BigNumConverter() BigNum get costAmount;/// Relative weights per rarity key. Not probabilities — weights, so adding
/// a rarity does not require rebalancing every other number by hand.
 Map<String, double> get weights;/// Opens without the pity rarity before it is guaranteed.
///
/// Zero disables pity. A run of bad luck long enough to feel unfair is the
/// most common reason players quit a gacha, and it costs nothing to bound
/// it — the guarantee is cheaper than the churn.
 int get pityThreshold;/// Rarity the pity counter guarantees.
 String get pityRarity;
/// Create a copy of LampConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LampConfigCopyWith<LampConfig> get copyWith => _$LampConfigCopyWithImpl<LampConfig>(this as LampConfig, _$identity);

  /// Serializes this LampConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LampConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costAmount, costAmount) || other.costAmount == costAmount)&&const DeepCollectionEquality().equals(other.weights, weights)&&(identical(other.pityThreshold, pityThreshold) || other.pityThreshold == pityThreshold)&&(identical(other.pityRarity, pityRarity) || other.pityRarity == pityRarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costAmount,const DeepCollectionEquality().hash(weights),pityThreshold,pityRarity);

@override
String toString() {
  return 'LampConfig(costResource: $costResource, costAmount: $costAmount, weights: $weights, pityThreshold: $pityThreshold, pityRarity: $pityRarity)';
}


}

/// @nodoc
abstract mixin class $LampConfigCopyWith<$Res>  {
  factory $LampConfigCopyWith(LampConfig value, $Res Function(LampConfig) _then) = _$LampConfigCopyWithImpl;
@useResult
$Res call({
 String costResource,@BigNumConverter() BigNum costAmount, Map<String, double> weights, int pityThreshold, String pityRarity
});




}
/// @nodoc
class _$LampConfigCopyWithImpl<$Res>
    implements $LampConfigCopyWith<$Res> {
  _$LampConfigCopyWithImpl(this._self, this._then);

  final LampConfig _self;
  final $Res Function(LampConfig) _then;

/// Create a copy of LampConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? costResource = null,Object? costAmount = null,Object? weights = null,Object? pityThreshold = null,Object? pityRarity = null,}) {
  return _then(_self.copyWith(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costAmount: null == costAmount ? _self.costAmount : costAmount // ignore: cast_nullable_to_non_nullable
as BigNum,weights: null == weights ? _self.weights : weights // ignore: cast_nullable_to_non_nullable
as Map<String, double>,pityThreshold: null == pityThreshold ? _self.pityThreshold : pityThreshold // ignore: cast_nullable_to_non_nullable
as int,pityRarity: null == pityRarity ? _self.pityRarity : pityRarity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LampConfig].
extension LampConfigPatterns on LampConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LampConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LampConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LampConfig value)  $default,){
final _that = this;
switch (_that) {
case _LampConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LampConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LampConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String costResource, @BigNumConverter()  BigNum costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LampConfig() when $default != null:
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String costResource, @BigNumConverter()  BigNum costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity)  $default,) {final _that = this;
switch (_that) {
case _LampConfig():
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String costResource, @BigNumConverter()  BigNum costAmount,  Map<String, double> weights,  int pityThreshold,  String pityRarity)?  $default,) {final _that = this;
switch (_that) {
case _LampConfig() when $default != null:
return $default(_that.costResource,_that.costAmount,_that.weights,_that.pityThreshold,_that.pityRarity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LampConfig extends LampConfig {
  const _LampConfig({this.costResource = 'gems', @BigNumConverter() this.costAmount = BigNum.one, final  Map<String, double> weights = const <String, double>{}, this.pityThreshold = 0, this.pityRarity = ''}): _weights = weights,super._();
  factory _LampConfig.fromJson(Map<String, dynamic> json) => _$LampConfigFromJson(json);

/// Resource spent per open.
@override@JsonKey() final  String costResource;
@override@JsonKey()@BigNumConverter() final  BigNum costAmount;
/// Relative weights per rarity key. Not probabilities — weights, so adding
/// a rarity does not require rebalancing every other number by hand.
 final  Map<String, double> _weights;
/// Relative weights per rarity key. Not probabilities — weights, so adding
/// a rarity does not require rebalancing every other number by hand.
@override@JsonKey() Map<String, double> get weights {
  if (_weights is EqualUnmodifiableMapView) return _weights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_weights);
}

/// Opens without the pity rarity before it is guaranteed.
///
/// Zero disables pity. A run of bad luck long enough to feel unfair is the
/// most common reason players quit a gacha, and it costs nothing to bound
/// it — the guarantee is cheaper than the churn.
@override@JsonKey() final  int pityThreshold;
/// Rarity the pity counter guarantees.
@override@JsonKey() final  String pityRarity;

/// Create a copy of LampConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LampConfigCopyWith<_LampConfig> get copyWith => __$LampConfigCopyWithImpl<_LampConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LampConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LampConfig&&(identical(other.costResource, costResource) || other.costResource == costResource)&&(identical(other.costAmount, costAmount) || other.costAmount == costAmount)&&const DeepCollectionEquality().equals(other._weights, _weights)&&(identical(other.pityThreshold, pityThreshold) || other.pityThreshold == pityThreshold)&&(identical(other.pityRarity, pityRarity) || other.pityRarity == pityRarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,costResource,costAmount,const DeepCollectionEquality().hash(_weights),pityThreshold,pityRarity);

@override
String toString() {
  return 'LampConfig(costResource: $costResource, costAmount: $costAmount, weights: $weights, pityThreshold: $pityThreshold, pityRarity: $pityRarity)';
}


}

/// @nodoc
abstract mixin class _$LampConfigCopyWith<$Res> implements $LampConfigCopyWith<$Res> {
  factory _$LampConfigCopyWith(_LampConfig value, $Res Function(_LampConfig) _then) = __$LampConfigCopyWithImpl;
@override @useResult
$Res call({
 String costResource,@BigNumConverter() BigNum costAmount, Map<String, double> weights, int pityThreshold, String pityRarity
});




}
/// @nodoc
class __$LampConfigCopyWithImpl<$Res>
    implements _$LampConfigCopyWith<$Res> {
  __$LampConfigCopyWithImpl(this._self, this._then);

  final _LampConfig _self;
  final $Res Function(_LampConfig) _then;

/// Create a copy of LampConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? costResource = null,Object? costAmount = null,Object? weights = null,Object? pityThreshold = null,Object? pityRarity = null,}) {
  return _then(_LampConfig(
costResource: null == costResource ? _self.costResource : costResource // ignore: cast_nullable_to_non_nullable
as String,costAmount: null == costAmount ? _self.costAmount : costAmount // ignore: cast_nullable_to_non_nullable
as BigNum,weights: null == weights ? _self._weights : weights // ignore: cast_nullable_to_non_nullable
as Map<String, double>,pityThreshold: null == pityThreshold ? _self.pityThreshold : pityThreshold // ignore: cast_nullable_to_non_nullable
as int,pityRarity: null == pityRarity ? _self.pityRarity : pityRarity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
