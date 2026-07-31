// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BattleEvent {

/// Milliseconds since the fight began.
 int get atMs; BattleEventKind get kind;/// Who swung. For a death, the side that landed the killing blow.
 BattleSide get source;/// Who it landed on. For a death, the side that died.
 BattleSide get target;/// Which monster in the group, when [target] is the monster side.
///
/// A fight is against a group, so "the monster was hit" is not enough for
/// the scene to know which shape to flinch — and a skill that hits three
/// at once produces three events at the same timecode.
 int get targetIndex;/// Damage dealt. Zero for a dodge or a death marker.
@BigNumConverter() BigNum get damage;/// Which skill fired, for [BattleEventKind.skill]. Empty otherwise.
 String get skillId;
/// Create a copy of BattleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BattleEventCopyWith<BattleEvent> get copyWith => _$BattleEventCopyWithImpl<BattleEvent>(this as BattleEvent, _$identity);

  /// Serializes this BattleEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BattleEvent&&(identical(other.atMs, atMs) || other.atMs == atMs)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetIndex, targetIndex) || other.targetIndex == targetIndex)&&(identical(other.damage, damage) || other.damage == damage)&&(identical(other.skillId, skillId) || other.skillId == skillId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,atMs,kind,source,target,targetIndex,damage,skillId);

@override
String toString() {
  return 'BattleEvent(atMs: $atMs, kind: $kind, source: $source, target: $target, targetIndex: $targetIndex, damage: $damage, skillId: $skillId)';
}


}

/// @nodoc
abstract mixin class $BattleEventCopyWith<$Res>  {
  factory $BattleEventCopyWith(BattleEvent value, $Res Function(BattleEvent) _then) = _$BattleEventCopyWithImpl;
@useResult
$Res call({
 int atMs, BattleEventKind kind, BattleSide source, BattleSide target, int targetIndex,@BigNumConverter() BigNum damage, String skillId
});




}
/// @nodoc
class _$BattleEventCopyWithImpl<$Res>
    implements $BattleEventCopyWith<$Res> {
  _$BattleEventCopyWithImpl(this._self, this._then);

  final BattleEvent _self;
  final $Res Function(BattleEvent) _then;

/// Create a copy of BattleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? atMs = null,Object? kind = null,Object? source = null,Object? target = null,Object? targetIndex = null,Object? damage = null,Object? skillId = null,}) {
  return _then(_self.copyWith(
atMs: null == atMs ? _self.atMs : atMs // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BattleEventKind,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BattleSide,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as BattleSide,targetIndex: null == targetIndex ? _self.targetIndex : targetIndex // ignore: cast_nullable_to_non_nullable
as int,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as BigNum,skillId: null == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BattleEvent].
extension BattleEventPatterns on BattleEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BattleEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BattleEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BattleEvent value)  $default,){
final _that = this;
switch (_that) {
case _BattleEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BattleEvent value)?  $default,){
final _that = this;
switch (_that) {
case _BattleEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int atMs,  BattleEventKind kind,  BattleSide source,  BattleSide target,  int targetIndex, @BigNumConverter()  BigNum damage,  String skillId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BattleEvent() when $default != null:
return $default(_that.atMs,_that.kind,_that.source,_that.target,_that.targetIndex,_that.damage,_that.skillId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int atMs,  BattleEventKind kind,  BattleSide source,  BattleSide target,  int targetIndex, @BigNumConverter()  BigNum damage,  String skillId)  $default,) {final _that = this;
switch (_that) {
case _BattleEvent():
return $default(_that.atMs,_that.kind,_that.source,_that.target,_that.targetIndex,_that.damage,_that.skillId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int atMs,  BattleEventKind kind,  BattleSide source,  BattleSide target,  int targetIndex, @BigNumConverter()  BigNum damage,  String skillId)?  $default,) {final _that = this;
switch (_that) {
case _BattleEvent() when $default != null:
return $default(_that.atMs,_that.kind,_that.source,_that.target,_that.targetIndex,_that.damage,_that.skillId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BattleEvent implements BattleEvent {
  const _BattleEvent({required this.atMs, required this.kind, required this.source, required this.target, this.targetIndex = 0, @BigNumConverter() this.damage = BigNum.zero, this.skillId = ''});
  factory _BattleEvent.fromJson(Map<String, dynamic> json) => _$BattleEventFromJson(json);

/// Milliseconds since the fight began.
@override final  int atMs;
@override final  BattleEventKind kind;
/// Who swung. For a death, the side that landed the killing blow.
@override final  BattleSide source;
/// Who it landed on. For a death, the side that died.
@override final  BattleSide target;
/// Which monster in the group, when [target] is the monster side.
///
/// A fight is against a group, so "the monster was hit" is not enough for
/// the scene to know which shape to flinch — and a skill that hits three
/// at once produces three events at the same timecode.
@override@JsonKey() final  int targetIndex;
/// Damage dealt. Zero for a dodge or a death marker.
@override@JsonKey()@BigNumConverter() final  BigNum damage;
/// Which skill fired, for [BattleEventKind.skill]. Empty otherwise.
@override@JsonKey() final  String skillId;

/// Create a copy of BattleEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BattleEventCopyWith<_BattleEvent> get copyWith => __$BattleEventCopyWithImpl<_BattleEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BattleEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BattleEvent&&(identical(other.atMs, atMs) || other.atMs == atMs)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.source, source) || other.source == source)&&(identical(other.target, target) || other.target == target)&&(identical(other.targetIndex, targetIndex) || other.targetIndex == targetIndex)&&(identical(other.damage, damage) || other.damage == damage)&&(identical(other.skillId, skillId) || other.skillId == skillId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,atMs,kind,source,target,targetIndex,damage,skillId);

@override
String toString() {
  return 'BattleEvent(atMs: $atMs, kind: $kind, source: $source, target: $target, targetIndex: $targetIndex, damage: $damage, skillId: $skillId)';
}


}

/// @nodoc
abstract mixin class _$BattleEventCopyWith<$Res> implements $BattleEventCopyWith<$Res> {
  factory _$BattleEventCopyWith(_BattleEvent value, $Res Function(_BattleEvent) _then) = __$BattleEventCopyWithImpl;
@override @useResult
$Res call({
 int atMs, BattleEventKind kind, BattleSide source, BattleSide target, int targetIndex,@BigNumConverter() BigNum damage, String skillId
});




}
/// @nodoc
class __$BattleEventCopyWithImpl<$Res>
    implements _$BattleEventCopyWith<$Res> {
  __$BattleEventCopyWithImpl(this._self, this._then);

  final _BattleEvent _self;
  final $Res Function(_BattleEvent) _then;

/// Create a copy of BattleEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? atMs = null,Object? kind = null,Object? source = null,Object? target = null,Object? targetIndex = null,Object? damage = null,Object? skillId = null,}) {
  return _then(_BattleEvent(
atMs: null == atMs ? _self.atMs : atMs // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BattleEventKind,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as BattleSide,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as BattleSide,targetIndex: null == targetIndex ? _self.targetIndex : targetIndex // ignore: cast_nullable_to_non_nullable
as int,damage: null == damage ? _self.damage : damage // ignore: cast_nullable_to_non_nullable
as BigNum,skillId: null == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
