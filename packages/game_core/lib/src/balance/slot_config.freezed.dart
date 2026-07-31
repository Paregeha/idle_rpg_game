// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlotConfig {

/// Unique name of the slot, e.g. `ring2`.
 String get id;/// Item kind this slot takes. Empty means "the same as [id]", which is the
/// common case and keeps the config short.
 String get accepts;/// Display order. Slots are shown low-to-high.
 int get order;
/// Create a copy of SlotConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlotConfigCopyWith<SlotConfig> get copyWith => _$SlotConfigCopyWithImpl<SlotConfig>(this as SlotConfig, _$identity);

  /// Serializes this SlotConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlotConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.accepts, accepts) || other.accepts == accepts)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accepts,order);

@override
String toString() {
  return 'SlotConfig(id: $id, accepts: $accepts, order: $order)';
}


}

/// @nodoc
abstract mixin class $SlotConfigCopyWith<$Res>  {
  factory $SlotConfigCopyWith(SlotConfig value, $Res Function(SlotConfig) _then) = _$SlotConfigCopyWithImpl;
@useResult
$Res call({
 String id, String accepts, int order
});




}
/// @nodoc
class _$SlotConfigCopyWithImpl<$Res>
    implements $SlotConfigCopyWith<$Res> {
  _$SlotConfigCopyWithImpl(this._self, this._then);

  final SlotConfig _self;
  final $Res Function(SlotConfig) _then;

/// Create a copy of SlotConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accepts = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accepts: null == accepts ? _self.accepts : accepts // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SlotConfig].
extension SlotConfigPatterns on SlotConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlotConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlotConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlotConfig value)  $default,){
final _that = this;
switch (_that) {
case _SlotConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlotConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SlotConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String accepts,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlotConfig() when $default != null:
return $default(_that.id,_that.accepts,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String accepts,  int order)  $default,) {final _that = this;
switch (_that) {
case _SlotConfig():
return $default(_that.id,_that.accepts,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String accepts,  int order)?  $default,) {final _that = this;
switch (_that) {
case _SlotConfig() when $default != null:
return $default(_that.id,_that.accepts,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlotConfig extends SlotConfig {
  const _SlotConfig({required this.id, this.accepts = '', this.order = 0}): super._();
  factory _SlotConfig.fromJson(Map<String, dynamic> json) => _$SlotConfigFromJson(json);

/// Unique name of the slot, e.g. `ring2`.
@override final  String id;
/// Item kind this slot takes. Empty means "the same as [id]", which is the
/// common case and keeps the config short.
@override@JsonKey() final  String accepts;
/// Display order. Slots are shown low-to-high.
@override@JsonKey() final  int order;

/// Create a copy of SlotConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlotConfigCopyWith<_SlotConfig> get copyWith => __$SlotConfigCopyWithImpl<_SlotConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlotConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlotConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.accepts, accepts) || other.accepts == accepts)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,accepts,order);

@override
String toString() {
  return 'SlotConfig(id: $id, accepts: $accepts, order: $order)';
}


}

/// @nodoc
abstract mixin class _$SlotConfigCopyWith<$Res> implements $SlotConfigCopyWith<$Res> {
  factory _$SlotConfigCopyWith(_SlotConfig value, $Res Function(_SlotConfig) _then) = __$SlotConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String accepts, int order
});




}
/// @nodoc
class __$SlotConfigCopyWithImpl<$Res>
    implements _$SlotConfigCopyWith<$Res> {
  __$SlotConfigCopyWithImpl(this._self, this._then);

  final _SlotConfig _self;
  final $Res Function(_SlotConfig) _then;

/// Create a copy of SlotConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accepts = null,Object? order = null,}) {
  return _then(_SlotConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accepts: null == accepts ? _self.accepts : accepts // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
