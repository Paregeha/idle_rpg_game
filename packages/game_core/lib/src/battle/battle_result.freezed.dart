// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battle_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BattleResult {

 BattleOutcome get outcome; List<BattleEvent> get events;/// Milliseconds the fight took in game time, not in wall time.
 int get durationMs;
/// Create a copy of BattleResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BattleResultCopyWith<BattleResult> get copyWith => _$BattleResultCopyWithImpl<BattleResult>(this as BattleResult, _$identity);

  /// Serializes this BattleResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BattleResult&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outcome,const DeepCollectionEquality().hash(events),durationMs);

@override
String toString() {
  return 'BattleResult(outcome: $outcome, events: $events, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $BattleResultCopyWith<$Res>  {
  factory $BattleResultCopyWith(BattleResult value, $Res Function(BattleResult) _then) = _$BattleResultCopyWithImpl;
@useResult
$Res call({
 BattleOutcome outcome, List<BattleEvent> events, int durationMs
});




}
/// @nodoc
class _$BattleResultCopyWithImpl<$Res>
    implements $BattleResultCopyWith<$Res> {
  _$BattleResultCopyWithImpl(this._self, this._then);

  final BattleResult _self;
  final $Res Function(BattleResult) _then;

/// Create a copy of BattleResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? events = null,Object? durationMs = null,}) {
  return _then(_self.copyWith(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as BattleOutcome,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<BattleEvent>,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BattleResult].
extension BattleResultPatterns on BattleResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BattleResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BattleResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BattleResult value)  $default,){
final _that = this;
switch (_that) {
case _BattleResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BattleResult value)?  $default,){
final _that = this;
switch (_that) {
case _BattleResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BattleOutcome outcome,  List<BattleEvent> events,  int durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BattleResult() when $default != null:
return $default(_that.outcome,_that.events,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BattleOutcome outcome,  List<BattleEvent> events,  int durationMs)  $default,) {final _that = this;
switch (_that) {
case _BattleResult():
return $default(_that.outcome,_that.events,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BattleOutcome outcome,  List<BattleEvent> events,  int durationMs)?  $default,) {final _that = this;
switch (_that) {
case _BattleResult() when $default != null:
return $default(_that.outcome,_that.events,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BattleResult extends BattleResult {
  const _BattleResult({required this.outcome, required final  List<BattleEvent> events, required this.durationMs}): _events = events,super._();
  factory _BattleResult.fromJson(Map<String, dynamic> json) => _$BattleResultFromJson(json);

@override final  BattleOutcome outcome;
 final  List<BattleEvent> _events;
@override List<BattleEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

/// Milliseconds the fight took in game time, not in wall time.
@override final  int durationMs;

/// Create a copy of BattleResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BattleResultCopyWith<_BattleResult> get copyWith => __$BattleResultCopyWithImpl<_BattleResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BattleResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BattleResult&&(identical(other.outcome, outcome) || other.outcome == outcome)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,outcome,const DeepCollectionEquality().hash(_events),durationMs);

@override
String toString() {
  return 'BattleResult(outcome: $outcome, events: $events, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$BattleResultCopyWith<$Res> implements $BattleResultCopyWith<$Res> {
  factory _$BattleResultCopyWith(_BattleResult value, $Res Function(_BattleResult) _then) = __$BattleResultCopyWithImpl;
@override @useResult
$Res call({
 BattleOutcome outcome, List<BattleEvent> events, int durationMs
});




}
/// @nodoc
class __$BattleResultCopyWithImpl<$Res>
    implements _$BattleResultCopyWith<$Res> {
  __$BattleResultCopyWithImpl(this._self, this._then);

  final _BattleResult _self;
  final $Res Function(_BattleResult) _then;

/// Create a copy of BattleResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? events = null,Object? durationMs = null,}) {
  return _then(_BattleResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as BattleOutcome,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<BattleEvent>,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
