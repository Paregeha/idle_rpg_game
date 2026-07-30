// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owned_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnedItem {

/// Unique among this player's items.
 String get id;/// Key into `BalanceConfig.items`.
 String get configId;/// Upgrade level (`T-083`).
 int get level;
/// Create a copy of OwnedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnedItemCopyWith<OwnedItem> get copyWith => _$OwnedItemCopyWithImpl<OwnedItem>(this as OwnedItem, _$identity);

  /// Serializes this OwnedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.configId, configId) || other.configId == configId)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,configId,level);

@override
String toString() {
  return 'OwnedItem(id: $id, configId: $configId, level: $level)';
}


}

/// @nodoc
abstract mixin class $OwnedItemCopyWith<$Res>  {
  factory $OwnedItemCopyWith(OwnedItem value, $Res Function(OwnedItem) _then) = _$OwnedItemCopyWithImpl;
@useResult
$Res call({
 String id, String configId, int level
});




}
/// @nodoc
class _$OwnedItemCopyWithImpl<$Res>
    implements $OwnedItemCopyWith<$Res> {
  _$OwnedItemCopyWithImpl(this._self, this._then);

  final OwnedItem _self;
  final $Res Function(OwnedItem) _then;

/// Create a copy of OwnedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? configId = null,Object? level = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,configId: null == configId ? _self.configId : configId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnedItem].
extension OwnedItemPatterns on OwnedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnedItem value)  $default,){
final _that = this;
switch (_that) {
case _OwnedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnedItem value)?  $default,){
final _that = this;
switch (_that) {
case _OwnedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String configId,  int level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnedItem() when $default != null:
return $default(_that.id,_that.configId,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String configId,  int level)  $default,) {final _that = this;
switch (_that) {
case _OwnedItem():
return $default(_that.id,_that.configId,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String configId,  int level)?  $default,) {final _that = this;
switch (_that) {
case _OwnedItem() when $default != null:
return $default(_that.id,_that.configId,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnedItem implements OwnedItem {
  const _OwnedItem({required this.id, required this.configId, this.level = 0});
  factory _OwnedItem.fromJson(Map<String, dynamic> json) => _$OwnedItemFromJson(json);

/// Unique among this player's items.
@override final  String id;
/// Key into `BalanceConfig.items`.
@override final  String configId;
/// Upgrade level (`T-083`).
@override@JsonKey() final  int level;

/// Create a copy of OwnedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnedItemCopyWith<_OwnedItem> get copyWith => __$OwnedItemCopyWithImpl<_OwnedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.configId, configId) || other.configId == configId)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,configId,level);

@override
String toString() {
  return 'OwnedItem(id: $id, configId: $configId, level: $level)';
}


}

/// @nodoc
abstract mixin class _$OwnedItemCopyWith<$Res> implements $OwnedItemCopyWith<$Res> {
  factory _$OwnedItemCopyWith(_OwnedItem value, $Res Function(_OwnedItem) _then) = __$OwnedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String configId, int level
});




}
/// @nodoc
class __$OwnedItemCopyWithImpl<$Res>
    implements _$OwnedItemCopyWith<$Res> {
  __$OwnedItemCopyWithImpl(this._self, this._then);

  final _OwnedItem _self;
  final $Res Function(_OwnedItem) _then;

/// Create a copy of OwnedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? configId = null,Object? level = null,}) {
  return _then(_OwnedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,configId: null == configId ? _self.configId : configId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
