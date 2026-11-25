// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'levels_finished.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LevelsFinishedDay {

/// The journey day — the same numbering as `/roadmap/progress`
/// `currentDay`, so it is the row the figure belongs on.
 int get day;/// The levels path day it was read from, `YYYY-MM-DD` in the round's
/// timezone. Not drawn; kept for parity with the web.
 String get dayKey; int get done; int get offered;/// floor(100 × done ÷ offered).
 int get percent;
/// Create a copy of LevelsFinishedDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelsFinishedDayCopyWith<LevelsFinishedDay> get copyWith => _$LevelsFinishedDayCopyWithImpl<LevelsFinishedDay>(this as LevelsFinishedDay, _$identity);

  /// Serializes this LevelsFinishedDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelsFinishedDay&&(identical(other.day, day) || other.day == day)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.done, done) || other.done == done)&&(identical(other.offered, offered) || other.offered == offered)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,dayKey,done,offered,percent);

@override
String toString() {
  return 'LevelsFinishedDay(day: $day, dayKey: $dayKey, done: $done, offered: $offered, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $LevelsFinishedDayCopyWith<$Res>  {
  factory $LevelsFinishedDayCopyWith(LevelsFinishedDay value, $Res Function(LevelsFinishedDay) _then) = _$LevelsFinishedDayCopyWithImpl;
@useResult
$Res call({
 int day, String dayKey, int done, int offered, int percent
});




}
/// @nodoc
class _$LevelsFinishedDayCopyWithImpl<$Res>
    implements $LevelsFinishedDayCopyWith<$Res> {
  _$LevelsFinishedDayCopyWithImpl(this._self, this._then);

  final LevelsFinishedDay _self;
  final $Res Function(LevelsFinishedDay) _then;

/// Create a copy of LevelsFinishedDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? dayKey = null,Object? done = null,Object? offered = null,Object? percent = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,offered: null == offered ? _self.offered : offered // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelsFinishedDay].
extension LevelsFinishedDayPatterns on LevelsFinishedDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelsFinishedDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelsFinishedDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelsFinishedDay value)  $default,){
final _that = this;
switch (_that) {
case _LevelsFinishedDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelsFinishedDay value)?  $default,){
final _that = this;
switch (_that) {
case _LevelsFinishedDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  String dayKey,  int done,  int offered,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelsFinishedDay() when $default != null:
return $default(_that.day,_that.dayKey,_that.done,_that.offered,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  String dayKey,  int done,  int offered,  int percent)  $default,) {final _that = this;
switch (_that) {
case _LevelsFinishedDay():
return $default(_that.day,_that.dayKey,_that.done,_that.offered,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  String dayKey,  int done,  int offered,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _LevelsFinishedDay() when $default != null:
return $default(_that.day,_that.dayKey,_that.done,_that.offered,_that.percent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LevelsFinishedDay implements LevelsFinishedDay {
  const _LevelsFinishedDay({required this.day, this.dayKey = '', this.done = 0, this.offered = 0, this.percent = 0});
  factory _LevelsFinishedDay.fromJson(Map<String, dynamic> json) => _$LevelsFinishedDayFromJson(json);

/// The journey day — the same numbering as `/roadmap/progress`
/// `currentDay`, so it is the row the figure belongs on.
@override final  int day;
/// The levels path day it was read from, `YYYY-MM-DD` in the round's
/// timezone. Not drawn; kept for parity with the web.
@override@JsonKey() final  String dayKey;
@override@JsonKey() final  int done;
@override@JsonKey() final  int offered;
/// floor(100 × done ÷ offered).
@override@JsonKey() final  int percent;

/// Create a copy of LevelsFinishedDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelsFinishedDayCopyWith<_LevelsFinishedDay> get copyWith => __$LevelsFinishedDayCopyWithImpl<_LevelsFinishedDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelsFinishedDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelsFinishedDay&&(identical(other.day, day) || other.day == day)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.done, done) || other.done == done)&&(identical(other.offered, offered) || other.offered == offered)&&(identical(other.percent, percent) || other.percent == percent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,dayKey,done,offered,percent);

@override
String toString() {
  return 'LevelsFinishedDay(day: $day, dayKey: $dayKey, done: $done, offered: $offered, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$LevelsFinishedDayCopyWith<$Res> implements $LevelsFinishedDayCopyWith<$Res> {
  factory _$LevelsFinishedDayCopyWith(_LevelsFinishedDay value, $Res Function(_LevelsFinishedDay) _then) = __$LevelsFinishedDayCopyWithImpl;
@override @useResult
$Res call({
 int day, String dayKey, int done, int offered, int percent
});




}
/// @nodoc
class __$LevelsFinishedDayCopyWithImpl<$Res>
    implements _$LevelsFinishedDayCopyWith<$Res> {
  __$LevelsFinishedDayCopyWithImpl(this._self, this._then);

  final _LevelsFinishedDay _self;
  final $Res Function(_LevelsFinishedDay) _then;

/// Create a copy of LevelsFinishedDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? dayKey = null,Object? done = null,Object? offered = null,Object? percent = null,}) {
  return _then(_LevelsFinishedDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,offered: null == offered ? _self.offered : offered // ignore: cast_nullable_to_non_nullable
as int,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LevelsFinished {

/// Oldest first.
 List<LevelsFinishedDay> get days;
/// Create a copy of LevelsFinished
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelsFinishedCopyWith<LevelsFinished> get copyWith => _$LevelsFinishedCopyWithImpl<LevelsFinished>(this as LevelsFinished, _$identity);

  /// Serializes this LevelsFinished to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelsFinished&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'LevelsFinished(days: $days)';
}


}

/// @nodoc
abstract mixin class $LevelsFinishedCopyWith<$Res>  {
  factory $LevelsFinishedCopyWith(LevelsFinished value, $Res Function(LevelsFinished) _then) = _$LevelsFinishedCopyWithImpl;
@useResult
$Res call({
 List<LevelsFinishedDay> days
});




}
/// @nodoc
class _$LevelsFinishedCopyWithImpl<$Res>
    implements $LevelsFinishedCopyWith<$Res> {
  _$LevelsFinishedCopyWithImpl(this._self, this._then);

  final LevelsFinished _self;
  final $Res Function(LevelsFinished) _then;

/// Create a copy of LevelsFinished
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? days = null,}) {
  return _then(_self.copyWith(
days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<LevelsFinishedDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelsFinished].
extension LevelsFinishedPatterns on LevelsFinished {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelsFinished value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelsFinished() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelsFinished value)  $default,){
final _that = this;
switch (_that) {
case _LevelsFinished():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelsFinished value)?  $default,){
final _that = this;
switch (_that) {
case _LevelsFinished() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LevelsFinishedDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelsFinished() when $default != null:
return $default(_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LevelsFinishedDay> days)  $default,) {final _that = this;
switch (_that) {
case _LevelsFinished():
return $default(_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LevelsFinishedDay> days)?  $default,) {final _that = this;
switch (_that) {
case _LevelsFinished() when $default != null:
return $default(_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LevelsFinished extends LevelsFinished {
  const _LevelsFinished({final  List<LevelsFinishedDay> days = const <LevelsFinishedDay>[]}): _days = days,super._();
  factory _LevelsFinished.fromJson(Map<String, dynamic> json) => _$LevelsFinishedFromJson(json);

/// Oldest first.
 final  List<LevelsFinishedDay> _days;
/// Oldest first.
@override@JsonKey() List<LevelsFinishedDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of LevelsFinished
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelsFinishedCopyWith<_LevelsFinished> get copyWith => __$LevelsFinishedCopyWithImpl<_LevelsFinished>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelsFinishedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelsFinished&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'LevelsFinished(days: $days)';
}


}

/// @nodoc
abstract mixin class _$LevelsFinishedCopyWith<$Res> implements $LevelsFinishedCopyWith<$Res> {
  factory _$LevelsFinishedCopyWith(_LevelsFinished value, $Res Function(_LevelsFinished) _then) = __$LevelsFinishedCopyWithImpl;
@override @useResult
$Res call({
 List<LevelsFinishedDay> days
});




}
/// @nodoc
class __$LevelsFinishedCopyWithImpl<$Res>
    implements _$LevelsFinishedCopyWith<$Res> {
  __$LevelsFinishedCopyWithImpl(this._self, this._then);

  final _LevelsFinished _self;
  final $Res Function(_LevelsFinished) _then;

/// Create a copy of LevelsFinished
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? days = null,}) {
  return _then(_LevelsFinished(
days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<LevelsFinishedDay>,
  ));
}


}

// dart format on
