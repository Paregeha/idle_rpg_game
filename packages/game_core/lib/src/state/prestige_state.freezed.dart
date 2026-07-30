// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prestige_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrestigeState {

@BigNumConverter() BigNum get currency; int get resets; Map<String, int> get permanentUpgrades;
/// Create a copy of PrestigeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrestigeStateCopyWith<PrestigeState> get copyWith => _$PrestigeStateCopyWithImpl<PrestigeState>(this as PrestigeState, _$identity);

  /// Serializes this PrestigeState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrestigeState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.resets, resets) || other.resets == resets)&&const DeepCollectionEquality().equals(other.permanentUpgrades, permanentUpgrades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currency,resets,const DeepCollectionEquality().hash(permanentUpgrades));

@override
String toString() {
  return 'PrestigeState(currency: $currency, resets: $resets, permanentUpgrades: $permanentUpgrades)';
}


}

/// @nodoc
abstract mixin class $PrestigeStateCopyWith<$Res>  {
  factory $PrestigeStateCopyWith(PrestigeState value, $Res Function(PrestigeState) _then) = _$PrestigeStateCopyWithImpl;
@useResult
$Res call({
@BigNumConverter() BigNum currency, int resets, Map<String, int> permanentUpgrades
});




}
/// @nodoc
class _$PrestigeStateCopyWithImpl<$Res>
    implements $PrestigeStateCopyWith<$Res> {
  _$PrestigeStateCopyWithImpl(this._self, this._then);

  final PrestigeState _self;
  final $Res Function(PrestigeState) _then;

/// Create a copy of PrestigeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = null,Object? resets = null,Object? permanentUpgrades = null,}) {
  return _then(_self.copyWith(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as BigNum,resets: null == resets ? _self.resets : resets // ignore: cast_nullable_to_non_nullable
as int,permanentUpgrades: null == permanentUpgrades ? _self.permanentUpgrades : permanentUpgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [PrestigeState].
extension PrestigeStatePatterns on PrestigeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrestigeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrestigeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrestigeState value)  $default,){
final _that = this;
switch (_that) {
case _PrestigeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrestigeState value)?  $default,){
final _that = this;
switch (_that) {
case _PrestigeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum currency,  int resets,  Map<String, int> permanentUpgrades)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrestigeState() when $default != null:
return $default(_that.currency,_that.resets,_that.permanentUpgrades);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@BigNumConverter()  BigNum currency,  int resets,  Map<String, int> permanentUpgrades)  $default,) {final _that = this;
switch (_that) {
case _PrestigeState():
return $default(_that.currency,_that.resets,_that.permanentUpgrades);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@BigNumConverter()  BigNum currency,  int resets,  Map<String, int> permanentUpgrades)?  $default,) {final _that = this;
switch (_that) {
case _PrestigeState() when $default != null:
return $default(_that.currency,_that.resets,_that.permanentUpgrades);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrestigeState implements PrestigeState {
  const _PrestigeState({@BigNumConverter() this.currency = BigNum.zero, this.resets = 0, final  Map<String, int> permanentUpgrades = const <String, int>{}}): _permanentUpgrades = permanentUpgrades;
  factory _PrestigeState.fromJson(Map<String, dynamic> json) => _$PrestigeStateFromJson(json);

@override@JsonKey()@BigNumConverter() final  BigNum currency;
@override@JsonKey() final  int resets;
 final  Map<String, int> _permanentUpgrades;
@override@JsonKey() Map<String, int> get permanentUpgrades {
  if (_permanentUpgrades is EqualUnmodifiableMapView) return _permanentUpgrades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_permanentUpgrades);
}


/// Create a copy of PrestigeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrestigeStateCopyWith<_PrestigeState> get copyWith => __$PrestigeStateCopyWithImpl<_PrestigeState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrestigeStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrestigeState&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.resets, resets) || other.resets == resets)&&const DeepCollectionEquality().equals(other._permanentUpgrades, _permanentUpgrades));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currency,resets,const DeepCollectionEquality().hash(_permanentUpgrades));

@override
String toString() {
  return 'PrestigeState(currency: $currency, resets: $resets, permanentUpgrades: $permanentUpgrades)';
}


}

/// @nodoc
abstract mixin class _$PrestigeStateCopyWith<$Res> implements $PrestigeStateCopyWith<$Res> {
  factory _$PrestigeStateCopyWith(_PrestigeState value, $Res Function(_PrestigeState) _then) = __$PrestigeStateCopyWithImpl;
@override @useResult
$Res call({
@BigNumConverter() BigNum currency, int resets, Map<String, int> permanentUpgrades
});




}
/// @nodoc
class __$PrestigeStateCopyWithImpl<$Res>
    implements _$PrestigeStateCopyWith<$Res> {
  __$PrestigeStateCopyWithImpl(this._self, this._then);

  final _PrestigeState _self;
  final $Res Function(_PrestigeState) _then;

/// Create a copy of PrestigeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = null,Object? resets = null,Object? permanentUpgrades = null,}) {
  return _then(_PrestigeState(
currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as BigNum,resets: null == resets ? _self.resets : resets // ignore: cast_nullable_to_non_nullable
as int,permanentUpgrades: null == permanentUpgrades ? _self._permanentUpgrades : permanentUpgrades // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
