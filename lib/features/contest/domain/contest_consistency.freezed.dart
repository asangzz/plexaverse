// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_consistency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsistencyWindow {

/// The first instant counted.
 DateTime get from;/// The EXCLUSIVE end. Shown as the instant before it — "until 16 Dec",
/// never the day after.
 DateTime get to;/// `trial | subscription | pass | calendar`. Shown nowhere.
 String get basis; bool get estimated;
/// Create a copy of ConsistencyWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsistencyWindowCopyWith<ConsistencyWindow> get copyWith => _$ConsistencyWindowCopyWithImpl<ConsistencyWindow>(this as ConsistencyWindow, _$identity);

  /// Serializes this ConsistencyWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsistencyWindow&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.estimated, estimated) || other.estimated == estimated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,basis,estimated);

@override
String toString() {
  return 'ConsistencyWindow(from: $from, to: $to, basis: $basis, estimated: $estimated)';
}


}

/// @nodoc
abstract mixin class $ConsistencyWindowCopyWith<$Res>  {
  factory $ConsistencyWindowCopyWith(ConsistencyWindow value, $Res Function(ConsistencyWindow) _then) = _$ConsistencyWindowCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, String basis, bool estimated
});




}
/// @nodoc
class _$ConsistencyWindowCopyWithImpl<$Res>
    implements $ConsistencyWindowCopyWith<$Res> {
  _$ConsistencyWindowCopyWithImpl(this._self, this._then);

  final ConsistencyWindow _self;
  final $Res Function(ConsistencyWindow) _then;

/// Create a copy of ConsistencyWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? basis = null,Object? estimated = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsistencyWindow].
extension ConsistencyWindowPatterns on ConsistencyWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsistencyWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsistencyWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsistencyWindow value)  $default,){
final _that = this;
switch (_that) {
case _ConsistencyWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsistencyWindow value)?  $default,){
final _that = this;
switch (_that) {
case _ConsistencyWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  String basis,  bool estimated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsistencyWindow() when $default != null:
return $default(_that.from,_that.to,_that.basis,_that.estimated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  String basis,  bool estimated)  $default,) {final _that = this;
switch (_that) {
case _ConsistencyWindow():
return $default(_that.from,_that.to,_that.basis,_that.estimated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  String basis,  bool estimated)?  $default,) {final _that = this;
switch (_that) {
case _ConsistencyWindow() when $default != null:
return $default(_that.from,_that.to,_that.basis,_that.estimated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsistencyWindow implements ConsistencyWindow {
  const _ConsistencyWindow({required this.from, required this.to, this.basis = '', this.estimated = false});
  factory _ConsistencyWindow.fromJson(Map<String, dynamic> json) => _$ConsistencyWindowFromJson(json);

/// The first instant counted.
@override final  DateTime from;
/// The EXCLUSIVE end. Shown as the instant before it — "until 16 Dec",
/// never the day after.
@override final  DateTime to;
/// `trial | subscription | pass | calendar`. Shown nowhere.
@override@JsonKey() final  String basis;
@override@JsonKey() final  bool estimated;

/// Create a copy of ConsistencyWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsistencyWindowCopyWith<_ConsistencyWindow> get copyWith => __$ConsistencyWindowCopyWithImpl<_ConsistencyWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsistencyWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsistencyWindow&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.basis, basis) || other.basis == basis)&&(identical(other.estimated, estimated) || other.estimated == estimated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,basis,estimated);

@override
String toString() {
  return 'ConsistencyWindow(from: $from, to: $to, basis: $basis, estimated: $estimated)';
}


}

/// @nodoc
abstract mixin class _$ConsistencyWindowCopyWith<$Res> implements $ConsistencyWindowCopyWith<$Res> {
  factory _$ConsistencyWindowCopyWith(_ConsistencyWindow value, $Res Function(_ConsistencyWindow) _then) = __$ConsistencyWindowCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, String basis, bool estimated
});




}
/// @nodoc
class __$ConsistencyWindowCopyWithImpl<$Res>
    implements _$ConsistencyWindowCopyWith<$Res> {
  __$ConsistencyWindowCopyWithImpl(this._self, this._then);

  final _ConsistencyWindow _self;
  final $Res Function(_ConsistencyWindow) _then;

/// Create a copy of ConsistencyWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? basis = null,Object? estimated = null,}) {
  return _then(_ConsistencyWindow(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,basis: null == basis ? _self.basis : basis // ignore: cast_nullable_to_non_nullable
as String,estimated: null == estimated ? _self.estimated : estimated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConsistencyToday {

 String get dayKey; int get earned; int get available;
/// Create a copy of ConsistencyToday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsistencyTodayCopyWith<ConsistencyToday> get copyWith => _$ConsistencyTodayCopyWithImpl<ConsistencyToday>(this as ConsistencyToday, _$identity);

  /// Serializes this ConsistencyToday to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsistencyToday&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayKey,earned,available);

@override
String toString() {
  return 'ConsistencyToday(dayKey: $dayKey, earned: $earned, available: $available)';
}


}

/// @nodoc
abstract mixin class $ConsistencyTodayCopyWith<$Res>  {
  factory $ConsistencyTodayCopyWith(ConsistencyToday value, $Res Function(ConsistencyToday) _then) = _$ConsistencyTodayCopyWithImpl;
@useResult
$Res call({
 String dayKey, int earned, int available
});




}
/// @nodoc
class _$ConsistencyTodayCopyWithImpl<$Res>
    implements $ConsistencyTodayCopyWith<$Res> {
  _$ConsistencyTodayCopyWithImpl(this._self, this._then);

  final ConsistencyToday _self;
  final $Res Function(ConsistencyToday) _then;

/// Create a copy of ConsistencyToday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayKey = null,Object? earned = null,Object? available = null,}) {
  return _then(_self.copyWith(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsistencyToday].
extension ConsistencyTodayPatterns on ConsistencyToday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsistencyToday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsistencyToday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsistencyToday value)  $default,){
final _that = this;
switch (_that) {
case _ConsistencyToday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsistencyToday value)?  $default,){
final _that = this;
switch (_that) {
case _ConsistencyToday() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayKey,  int earned,  int available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsistencyToday() when $default != null:
return $default(_that.dayKey,_that.earned,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayKey,  int earned,  int available)  $default,) {final _that = this;
switch (_that) {
case _ConsistencyToday():
return $default(_that.dayKey,_that.earned,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayKey,  int earned,  int available)?  $default,) {final _that = this;
switch (_that) {
case _ConsistencyToday() when $default != null:
return $default(_that.dayKey,_that.earned,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsistencyToday implements ConsistencyToday {
  const _ConsistencyToday({this.dayKey = '', this.earned = 0, this.available = 0});
  factory _ConsistencyToday.fromJson(Map<String, dynamic> json) => _$ConsistencyTodayFromJson(json);

@override@JsonKey() final  String dayKey;
@override@JsonKey() final  int earned;
@override@JsonKey() final  int available;

/// Create a copy of ConsistencyToday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsistencyTodayCopyWith<_ConsistencyToday> get copyWith => __$ConsistencyTodayCopyWithImpl<_ConsistencyToday>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsistencyTodayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsistencyToday&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayKey,earned,available);

@override
String toString() {
  return 'ConsistencyToday(dayKey: $dayKey, earned: $earned, available: $available)';
}


}

/// @nodoc
abstract mixin class _$ConsistencyTodayCopyWith<$Res> implements $ConsistencyTodayCopyWith<$Res> {
  factory _$ConsistencyTodayCopyWith(_ConsistencyToday value, $Res Function(_ConsistencyToday) _then) = __$ConsistencyTodayCopyWithImpl;
@override @useResult
$Res call({
 String dayKey, int earned, int available
});




}
/// @nodoc
class __$ConsistencyTodayCopyWithImpl<$Res>
    implements _$ConsistencyTodayCopyWith<$Res> {
  __$ConsistencyTodayCopyWithImpl(this._self, this._then);

  final _ConsistencyToday _self;
  final $Res Function(_ConsistencyToday) _then;

/// Create a copy of ConsistencyToday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayKey = null,Object? earned = null,Object? available = null,}) {
  return _then(_ConsistencyToday(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ConsistencyDay {

 String get dayKey; int get available; int get earned; int get pending; bool get paused; bool get today;
/// Create a copy of ConsistencyDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsistencyDayCopyWith<ConsistencyDay> get copyWith => _$ConsistencyDayCopyWithImpl<ConsistencyDay>(this as ConsistencyDay, _$identity);

  /// Serializes this ConsistencyDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsistencyDay&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.available, available) || other.available == available)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.today, today) || other.today == today));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayKey,available,earned,pending,paused,today);

@override
String toString() {
  return 'ConsistencyDay(dayKey: $dayKey, available: $available, earned: $earned, pending: $pending, paused: $paused, today: $today)';
}


}

/// @nodoc
abstract mixin class $ConsistencyDayCopyWith<$Res>  {
  factory $ConsistencyDayCopyWith(ConsistencyDay value, $Res Function(ConsistencyDay) _then) = _$ConsistencyDayCopyWithImpl;
@useResult
$Res call({
 String dayKey, int available, int earned, int pending, bool paused, bool today
});




}
/// @nodoc
class _$ConsistencyDayCopyWithImpl<$Res>
    implements $ConsistencyDayCopyWith<$Res> {
  _$ConsistencyDayCopyWithImpl(this._self, this._then);

  final ConsistencyDay _self;
  final $Res Function(ConsistencyDay) _then;

/// Create a copy of ConsistencyDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayKey = null,Object? available = null,Object? earned = null,Object? pending = null,Object? paused = null,Object? today = null,}) {
  return _then(_self.copyWith(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsistencyDay].
extension ConsistencyDayPatterns on ConsistencyDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsistencyDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsistencyDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsistencyDay value)  $default,){
final _that = this;
switch (_that) {
case _ConsistencyDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsistencyDay value)?  $default,){
final _that = this;
switch (_that) {
case _ConsistencyDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayKey,  int available,  int earned,  int pending,  bool paused,  bool today)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsistencyDay() when $default != null:
return $default(_that.dayKey,_that.available,_that.earned,_that.pending,_that.paused,_that.today);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayKey,  int available,  int earned,  int pending,  bool paused,  bool today)  $default,) {final _that = this;
switch (_that) {
case _ConsistencyDay():
return $default(_that.dayKey,_that.available,_that.earned,_that.pending,_that.paused,_that.today);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayKey,  int available,  int earned,  int pending,  bool paused,  bool today)?  $default,) {final _that = this;
switch (_that) {
case _ConsistencyDay() when $default != null:
return $default(_that.dayKey,_that.available,_that.earned,_that.pending,_that.paused,_that.today);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsistencyDay implements ConsistencyDay {
  const _ConsistencyDay({this.dayKey = '', this.available = 0, this.earned = 0, this.pending = 0, this.paused = false, this.today = false});
  factory _ConsistencyDay.fromJson(Map<String, dynamic> json) => _$ConsistencyDayFromJson(json);

@override@JsonKey() final  String dayKey;
@override@JsonKey() final  int available;
@override@JsonKey() final  int earned;
@override@JsonKey() final  int pending;
@override@JsonKey() final  bool paused;
@override@JsonKey() final  bool today;

/// Create a copy of ConsistencyDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsistencyDayCopyWith<_ConsistencyDay> get copyWith => __$ConsistencyDayCopyWithImpl<_ConsistencyDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsistencyDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsistencyDay&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.available, available) || other.available == available)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.paused, paused) || other.paused == paused)&&(identical(other.today, today) || other.today == today));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dayKey,available,earned,pending,paused,today);

@override
String toString() {
  return 'ConsistencyDay(dayKey: $dayKey, available: $available, earned: $earned, pending: $pending, paused: $paused, today: $today)';
}


}

/// @nodoc
abstract mixin class _$ConsistencyDayCopyWith<$Res> implements $ConsistencyDayCopyWith<$Res> {
  factory _$ConsistencyDayCopyWith(_ConsistencyDay value, $Res Function(_ConsistencyDay) _then) = __$ConsistencyDayCopyWithImpl;
@override @useResult
$Res call({
 String dayKey, int available, int earned, int pending, bool paused, bool today
});




}
/// @nodoc
class __$ConsistencyDayCopyWithImpl<$Res>
    implements _$ConsistencyDayCopyWith<$Res> {
  __$ConsistencyDayCopyWithImpl(this._self, this._then);

  final _ConsistencyDay _self;
  final $Res Function(_ConsistencyDay) _then;

/// Create a copy of ConsistencyDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayKey = null,Object? available = null,Object? earned = null,Object? pending = null,Object? paused = null,Object? today = null,}) {
  return _then(_ConsistencyDay(
dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,paused: null == paused ? _self.paused : paused // ignore: cast_nullable_to_non_nullable
as bool,today: null == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ConsistencyView {

@JsonKey(unknownEnumValue: ConsistencyState.off) ConsistencyState get state;@JsonKey(unknownEnumValue: ConsistencyMode.shadow) ConsistencyMode get mode;/// The line, in percent.
 int get threshold;/// Floored. Null unless [state] is measuring.
 int? get percent;/// Compare with this, never by re-deriving from [percent].
 bool? get atOrAbove; int get earned; int get available;/// Waiting for review — not counted yet.
 int get pending;/// Earned, but self-reported and not yet audited.
 int get unaudited;/// XP more that puts the learner on the line.
 int get toLine; int get countedDays; ConsistencyWindow? get window; ConsistencyToday? get today; bool? get joined; bool get scoringPaused;/// No contest is running now: days without one don't count.
 bool get noContestRunning; List<ConsistencyDay> get days;
/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsistencyViewCopyWith<ConsistencyView> get copyWith => _$ConsistencyViewCopyWithImpl<ConsistencyView>(this as ConsistencyView, _$identity);

  /// Serializes this ConsistencyView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsistencyView&&(identical(other.state, state) || other.state == state)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.atOrAbove, atOrAbove) || other.atOrAbove == atOrAbove)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.available, available) || other.available == available)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.unaudited, unaudited) || other.unaudited == unaudited)&&(identical(other.toLine, toLine) || other.toLine == toLine)&&(identical(other.countedDays, countedDays) || other.countedDays == countedDays)&&(identical(other.window, window) || other.window == window)&&(identical(other.today, today) || other.today == today)&&(identical(other.joined, joined) || other.joined == joined)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused)&&(identical(other.noContestRunning, noContestRunning) || other.noContestRunning == noContestRunning)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,mode,threshold,percent,atOrAbove,earned,available,pending,unaudited,toLine,countedDays,window,today,joined,scoringPaused,noContestRunning,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'ConsistencyView(state: $state, mode: $mode, threshold: $threshold, percent: $percent, atOrAbove: $atOrAbove, earned: $earned, available: $available, pending: $pending, unaudited: $unaudited, toLine: $toLine, countedDays: $countedDays, window: $window, today: $today, joined: $joined, scoringPaused: $scoringPaused, noContestRunning: $noContestRunning, days: $days)';
}


}

/// @nodoc
abstract mixin class $ConsistencyViewCopyWith<$Res>  {
  factory $ConsistencyViewCopyWith(ConsistencyView value, $Res Function(ConsistencyView) _then) = _$ConsistencyViewCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ConsistencyState.off) ConsistencyState state,@JsonKey(unknownEnumValue: ConsistencyMode.shadow) ConsistencyMode mode, int threshold, int? percent, bool? atOrAbove, int earned, int available, int pending, int unaudited, int toLine, int countedDays, ConsistencyWindow? window, ConsistencyToday? today, bool? joined, bool scoringPaused, bool noContestRunning, List<ConsistencyDay> days
});


$ConsistencyWindowCopyWith<$Res>? get window;$ConsistencyTodayCopyWith<$Res>? get today;

}
/// @nodoc
class _$ConsistencyViewCopyWithImpl<$Res>
    implements $ConsistencyViewCopyWith<$Res> {
  _$ConsistencyViewCopyWithImpl(this._self, this._then);

  final ConsistencyView _self;
  final $Res Function(ConsistencyView) _then;

/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? mode = null,Object? threshold = null,Object? percent = freezed,Object? atOrAbove = freezed,Object? earned = null,Object? available = null,Object? pending = null,Object? unaudited = null,Object? toLine = null,Object? countedDays = null,Object? window = freezed,Object? today = freezed,Object? joined = freezed,Object? scoringPaused = null,Object? noContestRunning = null,Object? days = null,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ConsistencyState,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ConsistencyMode,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int?,atOrAbove: freezed == atOrAbove ? _self.atOrAbove : atOrAbove // ignore: cast_nullable_to_non_nullable
as bool?,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,unaudited: null == unaudited ? _self.unaudited : unaudited // ignore: cast_nullable_to_non_nullable
as int,toLine: null == toLine ? _self.toLine : toLine // ignore: cast_nullable_to_non_nullable
as int,countedDays: null == countedDays ? _self.countedDays : countedDays // ignore: cast_nullable_to_non_nullable
as int,window: freezed == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as ConsistencyWindow?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as ConsistencyToday?,joined: freezed == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as bool?,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,noContestRunning: null == noContestRunning ? _self.noContestRunning : noContestRunning // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<ConsistencyDay>,
  ));
}
/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsistencyWindowCopyWith<$Res>? get window {
    if (_self.window == null) {
    return null;
  }

  return $ConsistencyWindowCopyWith<$Res>(_self.window!, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsistencyTodayCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $ConsistencyTodayCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConsistencyView].
extension ConsistencyViewPatterns on ConsistencyView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsistencyView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsistencyView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsistencyView value)  $default,){
final _that = this;
switch (_that) {
case _ConsistencyView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsistencyView value)?  $default,){
final _that = this;
switch (_that) {
case _ConsistencyView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ConsistencyState.off)  ConsistencyState state, @JsonKey(unknownEnumValue: ConsistencyMode.shadow)  ConsistencyMode mode,  int threshold,  int? percent,  bool? atOrAbove,  int earned,  int available,  int pending,  int unaudited,  int toLine,  int countedDays,  ConsistencyWindow? window,  ConsistencyToday? today,  bool? joined,  bool scoringPaused,  bool noContestRunning,  List<ConsistencyDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsistencyView() when $default != null:
return $default(_that.state,_that.mode,_that.threshold,_that.percent,_that.atOrAbove,_that.earned,_that.available,_that.pending,_that.unaudited,_that.toLine,_that.countedDays,_that.window,_that.today,_that.joined,_that.scoringPaused,_that.noContestRunning,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ConsistencyState.off)  ConsistencyState state, @JsonKey(unknownEnumValue: ConsistencyMode.shadow)  ConsistencyMode mode,  int threshold,  int? percent,  bool? atOrAbove,  int earned,  int available,  int pending,  int unaudited,  int toLine,  int countedDays,  ConsistencyWindow? window,  ConsistencyToday? today,  bool? joined,  bool scoringPaused,  bool noContestRunning,  List<ConsistencyDay> days)  $default,) {final _that = this;
switch (_that) {
case _ConsistencyView():
return $default(_that.state,_that.mode,_that.threshold,_that.percent,_that.atOrAbove,_that.earned,_that.available,_that.pending,_that.unaudited,_that.toLine,_that.countedDays,_that.window,_that.today,_that.joined,_that.scoringPaused,_that.noContestRunning,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ConsistencyState.off)  ConsistencyState state, @JsonKey(unknownEnumValue: ConsistencyMode.shadow)  ConsistencyMode mode,  int threshold,  int? percent,  bool? atOrAbove,  int earned,  int available,  int pending,  int unaudited,  int toLine,  int countedDays,  ConsistencyWindow? window,  ConsistencyToday? today,  bool? joined,  bool scoringPaused,  bool noContestRunning,  List<ConsistencyDay> days)?  $default,) {final _that = this;
switch (_that) {
case _ConsistencyView() when $default != null:
return $default(_that.state,_that.mode,_that.threshold,_that.percent,_that.atOrAbove,_that.earned,_that.available,_that.pending,_that.unaudited,_that.toLine,_that.countedDays,_that.window,_that.today,_that.joined,_that.scoringPaused,_that.noContestRunning,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsistencyView extends ConsistencyView {
  const _ConsistencyView({@JsonKey(unknownEnumValue: ConsistencyState.off) this.state = ConsistencyState.off, @JsonKey(unknownEnumValue: ConsistencyMode.shadow) this.mode = ConsistencyMode.shadow, this.threshold = 75, this.percent, this.atOrAbove, this.earned = 0, this.available = 0, this.pending = 0, this.unaudited = 0, this.toLine = 0, this.countedDays = 0, this.window, this.today, this.joined, this.scoringPaused = false, this.noContestRunning = false, final  List<ConsistencyDay> days = const <ConsistencyDay>[]}): _days = days,super._();
  factory _ConsistencyView.fromJson(Map<String, dynamic> json) => _$ConsistencyViewFromJson(json);

@override@JsonKey(unknownEnumValue: ConsistencyState.off) final  ConsistencyState state;
@override@JsonKey(unknownEnumValue: ConsistencyMode.shadow) final  ConsistencyMode mode;
/// The line, in percent.
@override@JsonKey() final  int threshold;
/// Floored. Null unless [state] is measuring.
@override final  int? percent;
/// Compare with this, never by re-deriving from [percent].
@override final  bool? atOrAbove;
@override@JsonKey() final  int earned;
@override@JsonKey() final  int available;
/// Waiting for review — not counted yet.
@override@JsonKey() final  int pending;
/// Earned, but self-reported and not yet audited.
@override@JsonKey() final  int unaudited;
/// XP more that puts the learner on the line.
@override@JsonKey() final  int toLine;
@override@JsonKey() final  int countedDays;
@override final  ConsistencyWindow? window;
@override final  ConsistencyToday? today;
@override final  bool? joined;
@override@JsonKey() final  bool scoringPaused;
/// No contest is running now: days without one don't count.
@override@JsonKey() final  bool noContestRunning;
 final  List<ConsistencyDay> _days;
@override@JsonKey() List<ConsistencyDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsistencyViewCopyWith<_ConsistencyView> get copyWith => __$ConsistencyViewCopyWithImpl<_ConsistencyView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsistencyViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsistencyView&&(identical(other.state, state) || other.state == state)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.atOrAbove, atOrAbove) || other.atOrAbove == atOrAbove)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.available, available) || other.available == available)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.unaudited, unaudited) || other.unaudited == unaudited)&&(identical(other.toLine, toLine) || other.toLine == toLine)&&(identical(other.countedDays, countedDays) || other.countedDays == countedDays)&&(identical(other.window, window) || other.window == window)&&(identical(other.today, today) || other.today == today)&&(identical(other.joined, joined) || other.joined == joined)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused)&&(identical(other.noContestRunning, noContestRunning) || other.noContestRunning == noContestRunning)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,state,mode,threshold,percent,atOrAbove,earned,available,pending,unaudited,toLine,countedDays,window,today,joined,scoringPaused,noContestRunning,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'ConsistencyView(state: $state, mode: $mode, threshold: $threshold, percent: $percent, atOrAbove: $atOrAbove, earned: $earned, available: $available, pending: $pending, unaudited: $unaudited, toLine: $toLine, countedDays: $countedDays, window: $window, today: $today, joined: $joined, scoringPaused: $scoringPaused, noContestRunning: $noContestRunning, days: $days)';
}


}

/// @nodoc
abstract mixin class _$ConsistencyViewCopyWith<$Res> implements $ConsistencyViewCopyWith<$Res> {
  factory _$ConsistencyViewCopyWith(_ConsistencyView value, $Res Function(_ConsistencyView) _then) = __$ConsistencyViewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ConsistencyState.off) ConsistencyState state,@JsonKey(unknownEnumValue: ConsistencyMode.shadow) ConsistencyMode mode, int threshold, int? percent, bool? atOrAbove, int earned, int available, int pending, int unaudited, int toLine, int countedDays, ConsistencyWindow? window, ConsistencyToday? today, bool? joined, bool scoringPaused, bool noContestRunning, List<ConsistencyDay> days
});


@override $ConsistencyWindowCopyWith<$Res>? get window;@override $ConsistencyTodayCopyWith<$Res>? get today;

}
/// @nodoc
class __$ConsistencyViewCopyWithImpl<$Res>
    implements _$ConsistencyViewCopyWith<$Res> {
  __$ConsistencyViewCopyWithImpl(this._self, this._then);

  final _ConsistencyView _self;
  final $Res Function(_ConsistencyView) _then;

/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? mode = null,Object? threshold = null,Object? percent = freezed,Object? atOrAbove = freezed,Object? earned = null,Object? available = null,Object? pending = null,Object? unaudited = null,Object? toLine = null,Object? countedDays = null,Object? window = freezed,Object? today = freezed,Object? joined = freezed,Object? scoringPaused = null,Object? noContestRunning = null,Object? days = null,}) {
  return _then(_ConsistencyView(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ConsistencyState,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ConsistencyMode,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int?,atOrAbove: freezed == atOrAbove ? _self.atOrAbove : atOrAbove // ignore: cast_nullable_to_non_nullable
as bool?,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,unaudited: null == unaudited ? _self.unaudited : unaudited // ignore: cast_nullable_to_non_nullable
as int,toLine: null == toLine ? _self.toLine : toLine // ignore: cast_nullable_to_non_nullable
as int,countedDays: null == countedDays ? _self.countedDays : countedDays // ignore: cast_nullable_to_non_nullable
as int,window: freezed == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as ConsistencyWindow?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as ConsistencyToday?,joined: freezed == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as bool?,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,noContestRunning: null == noContestRunning ? _self.noContestRunning : noContestRunning // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<ConsistencyDay>,
  ));
}

/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsistencyWindowCopyWith<$Res>? get window {
    if (_self.window == null) {
    return null;
  }

  return $ConsistencyWindowCopyWith<$Res>(_self.window!, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of ConsistencyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConsistencyTodayCopyWith<$Res>? get today {
    if (_self.today == null) {
    return null;
  }

  return $ConsistencyTodayCopyWith<$Res>(_self.today!, (value) {
    return _then(_self.copyWith(today: value));
  });
}
}

// dart format on
