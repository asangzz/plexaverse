// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_overview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContestInfo {

 String get id;/// Admin-set, and editable while the contest runs.
 String get title;/// What first place wins. Editable at any time, so never cached locally.
 String get prizeTitle;/// An admin-pasted URL on any host.
 String? get prizeImageUrl;/// The first instant. Show [firstDayKey], not this.
 DateTime get startsAt;/// The EXCLUSIVE end — midnight after the last day. Formatted through a
/// viewer's clock it reads one day long, and in another timezone a day
/// off; show [lastDayKey] for the window. The web's "Results on" and
/// "Winner announced" lines are the one place it is read, as a date.
 DateTime get endsAt;/// The first and last playable day, `YYYY-MM-DD` in the contest's
/// timezone. What the window is shown as: read with `dayKeyDate`, never
/// through the device's timezone.
 String get firstDayKey; String get lastDayKey;/// How many finishers win the prize — a profile shoutout, recognition
/// only (owner, 22 Nov 2026). [rewardMonths] is kept for old rows only:
/// plan time is never a contest prize, and the server grants none.
 int get rewardTopN; int get rewardMonths;/// Scoring days before a plan is needed, counted from the join day.
 int get freeDays;/// The week-complete bonus (`rules.weekComplete`). Absent from an older
/// server, and then the join card leaves its rule out.
 int? get weekComplete;
/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<ContestInfo> get copyWith => _$ContestInfoCopyWithImpl<ContestInfo>(this as ContestInfo, _$identity);

  /// Serializes this ContestInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.prizeTitle, prizeTitle) || other.prizeTitle == prizeTitle)&&(identical(other.prizeImageUrl, prizeImageUrl) || other.prizeImageUrl == prizeImageUrl)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.firstDayKey, firstDayKey) || other.firstDayKey == firstDayKey)&&(identical(other.lastDayKey, lastDayKey) || other.lastDayKey == lastDayKey)&&(identical(other.rewardTopN, rewardTopN) || other.rewardTopN == rewardTopN)&&(identical(other.rewardMonths, rewardMonths) || other.rewardMonths == rewardMonths)&&(identical(other.freeDays, freeDays) || other.freeDays == freeDays)&&(identical(other.weekComplete, weekComplete) || other.weekComplete == weekComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,prizeTitle,prizeImageUrl,startsAt,endsAt,firstDayKey,lastDayKey,rewardTopN,rewardMonths,freeDays,weekComplete);

@override
String toString() {
  return 'ContestInfo(id: $id, title: $title, prizeTitle: $prizeTitle, prizeImageUrl: $prizeImageUrl, startsAt: $startsAt, endsAt: $endsAt, firstDayKey: $firstDayKey, lastDayKey: $lastDayKey, rewardTopN: $rewardTopN, rewardMonths: $rewardMonths, freeDays: $freeDays, weekComplete: $weekComplete)';
}


}

/// @nodoc
abstract mixin class $ContestInfoCopyWith<$Res>  {
  factory $ContestInfoCopyWith(ContestInfo value, $Res Function(ContestInfo) _then) = _$ContestInfoCopyWithImpl;
@useResult
$Res call({
 String id, String title, String prizeTitle, String? prizeImageUrl, DateTime startsAt, DateTime endsAt, String firstDayKey, String lastDayKey, int rewardTopN, int rewardMonths, int freeDays, int? weekComplete
});




}
/// @nodoc
class _$ContestInfoCopyWithImpl<$Res>
    implements $ContestInfoCopyWith<$Res> {
  _$ContestInfoCopyWithImpl(this._self, this._then);

  final ContestInfo _self;
  final $Res Function(ContestInfo) _then;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? prizeTitle = null,Object? prizeImageUrl = freezed,Object? startsAt = null,Object? endsAt = null,Object? firstDayKey = null,Object? lastDayKey = null,Object? rewardTopN = null,Object? rewardMonths = null,Object? freeDays = null,Object? weekComplete = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,prizeTitle: null == prizeTitle ? _self.prizeTitle : prizeTitle // ignore: cast_nullable_to_non_nullable
as String,prizeImageUrl: freezed == prizeImageUrl ? _self.prizeImageUrl : prizeImageUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstDayKey: null == firstDayKey ? _self.firstDayKey : firstDayKey // ignore: cast_nullable_to_non_nullable
as String,lastDayKey: null == lastDayKey ? _self.lastDayKey : lastDayKey // ignore: cast_nullable_to_non_nullable
as String,rewardTopN: null == rewardTopN ? _self.rewardTopN : rewardTopN // ignore: cast_nullable_to_non_nullable
as int,rewardMonths: null == rewardMonths ? _self.rewardMonths : rewardMonths // ignore: cast_nullable_to_non_nullable
as int,freeDays: null == freeDays ? _self.freeDays : freeDays // ignore: cast_nullable_to_non_nullable
as int,weekComplete: freezed == weekComplete ? _self.weekComplete : weekComplete // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestInfo].
extension ContestInfoPatterns on ContestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestInfo value)  $default,){
final _that = this;
switch (_that) {
case _ContestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String prizeTitle,  String? prizeImageUrl,  DateTime startsAt,  DateTime endsAt,  String firstDayKey,  String lastDayKey,  int rewardTopN,  int rewardMonths,  int freeDays,  int? weekComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
return $default(_that.id,_that.title,_that.prizeTitle,_that.prizeImageUrl,_that.startsAt,_that.endsAt,_that.firstDayKey,_that.lastDayKey,_that.rewardTopN,_that.rewardMonths,_that.freeDays,_that.weekComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String prizeTitle,  String? prizeImageUrl,  DateTime startsAt,  DateTime endsAt,  String firstDayKey,  String lastDayKey,  int rewardTopN,  int rewardMonths,  int freeDays,  int? weekComplete)  $default,) {final _that = this;
switch (_that) {
case _ContestInfo():
return $default(_that.id,_that.title,_that.prizeTitle,_that.prizeImageUrl,_that.startsAt,_that.endsAt,_that.firstDayKey,_that.lastDayKey,_that.rewardTopN,_that.rewardMonths,_that.freeDays,_that.weekComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String prizeTitle,  String? prizeImageUrl,  DateTime startsAt,  DateTime endsAt,  String firstDayKey,  String lastDayKey,  int rewardTopN,  int rewardMonths,  int freeDays,  int? weekComplete)?  $default,) {final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
return $default(_that.id,_that.title,_that.prizeTitle,_that.prizeImageUrl,_that.startsAt,_that.endsAt,_that.firstDayKey,_that.lastDayKey,_that.rewardTopN,_that.rewardMonths,_that.freeDays,_that.weekComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestInfo implements ContestInfo {
  const _ContestInfo({this.id = '', this.title = '', this.prizeTitle = '', this.prizeImageUrl, required this.startsAt, required this.endsAt, this.firstDayKey = '', this.lastDayKey = '', this.rewardTopN = 10, this.rewardMonths = 0, this.freeDays = 30, this.weekComplete});
  factory _ContestInfo.fromJson(Map<String, dynamic> json) => _$ContestInfoFromJson(json);

@override@JsonKey() final  String id;
/// Admin-set, and editable while the contest runs.
@override@JsonKey() final  String title;
/// What first place wins. Editable at any time, so never cached locally.
@override@JsonKey() final  String prizeTitle;
/// An admin-pasted URL on any host.
@override final  String? prizeImageUrl;
/// The first instant. Show [firstDayKey], not this.
@override final  DateTime startsAt;
/// The EXCLUSIVE end — midnight after the last day. Formatted through a
/// viewer's clock it reads one day long, and in another timezone a day
/// off; show [lastDayKey] for the window. The web's "Results on" and
/// "Winner announced" lines are the one place it is read, as a date.
@override final  DateTime endsAt;
/// The first and last playable day, `YYYY-MM-DD` in the contest's
/// timezone. What the window is shown as: read with `dayKeyDate`, never
/// through the device's timezone.
@override@JsonKey() final  String firstDayKey;
@override@JsonKey() final  String lastDayKey;
/// How many finishers win the prize — a profile shoutout, recognition
/// only (owner, 22 Nov 2026). [rewardMonths] is kept for old rows only:
/// plan time is never a contest prize, and the server grants none.
@override@JsonKey() final  int rewardTopN;
@override@JsonKey() final  int rewardMonths;
/// Scoring days before a plan is needed, counted from the join day.
@override@JsonKey() final  int freeDays;
/// The week-complete bonus (`rules.weekComplete`). Absent from an older
/// server, and then the join card leaves its rule out.
@override final  int? weekComplete;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestInfoCopyWith<_ContestInfo> get copyWith => __$ContestInfoCopyWithImpl<_ContestInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.prizeTitle, prizeTitle) || other.prizeTitle == prizeTitle)&&(identical(other.prizeImageUrl, prizeImageUrl) || other.prizeImageUrl == prizeImageUrl)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.firstDayKey, firstDayKey) || other.firstDayKey == firstDayKey)&&(identical(other.lastDayKey, lastDayKey) || other.lastDayKey == lastDayKey)&&(identical(other.rewardTopN, rewardTopN) || other.rewardTopN == rewardTopN)&&(identical(other.rewardMonths, rewardMonths) || other.rewardMonths == rewardMonths)&&(identical(other.freeDays, freeDays) || other.freeDays == freeDays)&&(identical(other.weekComplete, weekComplete) || other.weekComplete == weekComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,prizeTitle,prizeImageUrl,startsAt,endsAt,firstDayKey,lastDayKey,rewardTopN,rewardMonths,freeDays,weekComplete);

@override
String toString() {
  return 'ContestInfo(id: $id, title: $title, prizeTitle: $prizeTitle, prizeImageUrl: $prizeImageUrl, startsAt: $startsAt, endsAt: $endsAt, firstDayKey: $firstDayKey, lastDayKey: $lastDayKey, rewardTopN: $rewardTopN, rewardMonths: $rewardMonths, freeDays: $freeDays, weekComplete: $weekComplete)';
}


}

/// @nodoc
abstract mixin class _$ContestInfoCopyWith<$Res> implements $ContestInfoCopyWith<$Res> {
  factory _$ContestInfoCopyWith(_ContestInfo value, $Res Function(_ContestInfo) _then) = __$ContestInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String prizeTitle, String? prizeImageUrl, DateTime startsAt, DateTime endsAt, String firstDayKey, String lastDayKey, int rewardTopN, int rewardMonths, int freeDays, int? weekComplete
});




}
/// @nodoc
class __$ContestInfoCopyWithImpl<$Res>
    implements _$ContestInfoCopyWith<$Res> {
  __$ContestInfoCopyWithImpl(this._self, this._then);

  final _ContestInfo _self;
  final $Res Function(_ContestInfo) _then;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? prizeTitle = null,Object? prizeImageUrl = freezed,Object? startsAt = null,Object? endsAt = null,Object? firstDayKey = null,Object? lastDayKey = null,Object? rewardTopN = null,Object? rewardMonths = null,Object? freeDays = null,Object? weekComplete = freezed,}) {
  return _then(_ContestInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,prizeTitle: null == prizeTitle ? _self.prizeTitle : prizeTitle // ignore: cast_nullable_to_non_nullable
as String,prizeImageUrl: freezed == prizeImageUrl ? _self.prizeImageUrl : prizeImageUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstDayKey: null == firstDayKey ? _self.firstDayKey : firstDayKey // ignore: cast_nullable_to_non_nullable
as String,lastDayKey: null == lastDayKey ? _self.lastDayKey : lastDayKey // ignore: cast_nullable_to_non_nullable
as String,rewardTopN: null == rewardTopN ? _self.rewardTopN : rewardTopN // ignore: cast_nullable_to_non_nullable
as int,rewardMonths: null == rewardMonths ? _self.rewardMonths : rewardMonths // ignore: cast_nullable_to_non_nullable
as int,freeDays: null == freeDays ? _self.freeDays : freeDays // ignore: cast_nullable_to_non_nullable
as int,weekComplete: freezed == weekComplete ? _self.weekComplete : weekComplete // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$BoardReveal {

 bool get revealed;/// The day it opens, `YYYY-MM-DD` in the contest's timezone. Empty when
/// there is no contest to reveal.
 String get revealsOn;/// That day's contest day number.
 int get revealDay;
/// Create a copy of BoardReveal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardRevealCopyWith<BoardReveal> get copyWith => _$BoardRevealCopyWithImpl<BoardReveal>(this as BoardReveal, _$identity);

  /// Serializes this BoardReveal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardReveal&&(identical(other.revealed, revealed) || other.revealed == revealed)&&(identical(other.revealsOn, revealsOn) || other.revealsOn == revealsOn)&&(identical(other.revealDay, revealDay) || other.revealDay == revealDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revealed,revealsOn,revealDay);

@override
String toString() {
  return 'BoardReveal(revealed: $revealed, revealsOn: $revealsOn, revealDay: $revealDay)';
}


}

/// @nodoc
abstract mixin class $BoardRevealCopyWith<$Res>  {
  factory $BoardRevealCopyWith(BoardReveal value, $Res Function(BoardReveal) _then) = _$BoardRevealCopyWithImpl;
@useResult
$Res call({
 bool revealed, String revealsOn, int revealDay
});




}
/// @nodoc
class _$BoardRevealCopyWithImpl<$Res>
    implements $BoardRevealCopyWith<$Res> {
  _$BoardRevealCopyWithImpl(this._self, this._then);

  final BoardReveal _self;
  final $Res Function(BoardReveal) _then;

/// Create a copy of BoardReveal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revealed = null,Object? revealsOn = null,Object? revealDay = null,}) {
  return _then(_self.copyWith(
revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,revealsOn: null == revealsOn ? _self.revealsOn : revealsOn // ignore: cast_nullable_to_non_nullable
as String,revealDay: null == revealDay ? _self.revealDay : revealDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardReveal].
extension BoardRevealPatterns on BoardReveal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardReveal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardReveal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardReveal value)  $default,){
final _that = this;
switch (_that) {
case _BoardReveal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardReveal value)?  $default,){
final _that = this;
switch (_that) {
case _BoardReveal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool revealed,  String revealsOn,  int revealDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardReveal() when $default != null:
return $default(_that.revealed,_that.revealsOn,_that.revealDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool revealed,  String revealsOn,  int revealDay)  $default,) {final _that = this;
switch (_that) {
case _BoardReveal():
return $default(_that.revealed,_that.revealsOn,_that.revealDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool revealed,  String revealsOn,  int revealDay)?  $default,) {final _that = this;
switch (_that) {
case _BoardReveal() when $default != null:
return $default(_that.revealed,_that.revealsOn,_that.revealDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BoardReveal implements BoardReveal {
  const _BoardReveal({this.revealed = false, this.revealsOn = '', this.revealDay = 1});
  factory _BoardReveal.fromJson(Map<String, dynamic> json) => _$BoardRevealFromJson(json);

@override@JsonKey() final  bool revealed;
/// The day it opens, `YYYY-MM-DD` in the contest's timezone. Empty when
/// there is no contest to reveal.
@override@JsonKey() final  String revealsOn;
/// That day's contest day number.
@override@JsonKey() final  int revealDay;

/// Create a copy of BoardReveal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardRevealCopyWith<_BoardReveal> get copyWith => __$BoardRevealCopyWithImpl<_BoardReveal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BoardRevealToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardReveal&&(identical(other.revealed, revealed) || other.revealed == revealed)&&(identical(other.revealsOn, revealsOn) || other.revealsOn == revealsOn)&&(identical(other.revealDay, revealDay) || other.revealDay == revealDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revealed,revealsOn,revealDay);

@override
String toString() {
  return 'BoardReveal(revealed: $revealed, revealsOn: $revealsOn, revealDay: $revealDay)';
}


}

/// @nodoc
abstract mixin class _$BoardRevealCopyWith<$Res> implements $BoardRevealCopyWith<$Res> {
  factory _$BoardRevealCopyWith(_BoardReveal value, $Res Function(_BoardReveal) _then) = __$BoardRevealCopyWithImpl;
@override @useResult
$Res call({
 bool revealed, String revealsOn, int revealDay
});




}
/// @nodoc
class __$BoardRevealCopyWithImpl<$Res>
    implements _$BoardRevealCopyWith<$Res> {
  __$BoardRevealCopyWithImpl(this._self, this._then);

  final _BoardReveal _self;
  final $Res Function(_BoardReveal) _then;

/// Create a copy of BoardReveal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revealed = null,Object? revealsOn = null,Object? revealDay = null,}) {
  return _then(_BoardReveal(
revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as bool,revealsOn: null == revealsOn ? _self.revealsOn : revealsOn // ignore: cast_nullable_to_non_nullable
as String,revealDay: null == revealDay ? _self.revealDay : revealDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ContestEntryView {

 DateTime get joinedAt;/// The placement band at join (`A1`…`C2`). A label on the board; it
/// prices nothing — each lesson is multiplied by its own day's band.
 String get level;/// Contest XP. Never below zero: the server clamps every penalty.
 int get total;/// Null until the board opens. A rank is a comparison with everyone
/// else, and before the reveal the server does not even compute one.
 int? get rank;/// The daily lesson streak, live on the contest's clock: 0 once a day
/// went by without the lesson. Read, never derived.
 int get streak; int get bestStreak;/// First-attempt counts on the questions written for this learner — the
/// tie-break's accuracy.
 int get correctCount; int get wrongCount;/// Whole free scoring days left.
 int get freeDaysLeft;/// The free period is over and there is no live plan: contest XP has
/// stopped. Lessons and tasks still work; they record and pay nothing.
 bool get scoringPaused;
/// Create a copy of ContestEntryView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestEntryViewCopyWith<ContestEntryView> get copyWith => _$ContestEntryViewCopyWithImpl<ContestEntryView>(this as ContestEntryView, _$identity);

  /// Serializes this ContestEntryView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestEntryView&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.level, level) || other.level == level)&&(identical(other.total, total) || other.total == total)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.wrongCount, wrongCount) || other.wrongCount == wrongCount)&&(identical(other.freeDaysLeft, freeDaysLeft) || other.freeDaysLeft == freeDaysLeft)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,joinedAt,level,total,rank,streak,bestStreak,correctCount,wrongCount,freeDaysLeft,scoringPaused);

@override
String toString() {
  return 'ContestEntryView(joinedAt: $joinedAt, level: $level, total: $total, rank: $rank, streak: $streak, bestStreak: $bestStreak, correctCount: $correctCount, wrongCount: $wrongCount, freeDaysLeft: $freeDaysLeft, scoringPaused: $scoringPaused)';
}


}

/// @nodoc
abstract mixin class $ContestEntryViewCopyWith<$Res>  {
  factory $ContestEntryViewCopyWith(ContestEntryView value, $Res Function(ContestEntryView) _then) = _$ContestEntryViewCopyWithImpl;
@useResult
$Res call({
 DateTime joinedAt, String level, int total, int? rank, int streak, int bestStreak, int correctCount, int wrongCount, int freeDaysLeft, bool scoringPaused
});




}
/// @nodoc
class _$ContestEntryViewCopyWithImpl<$Res>
    implements $ContestEntryViewCopyWith<$Res> {
  _$ContestEntryViewCopyWithImpl(this._self, this._then);

  final ContestEntryView _self;
  final $Res Function(ContestEntryView) _then;

/// Create a copy of ContestEntryView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? joinedAt = null,Object? level = null,Object? total = null,Object? rank = freezed,Object? streak = null,Object? bestStreak = null,Object? correctCount = null,Object? wrongCount = null,Object? freeDaysLeft = null,Object? scoringPaused = null,}) {
  return _then(_self.copyWith(
joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,freeDaysLeft: null == freeDaysLeft ? _self.freeDaysLeft : freeDaysLeft // ignore: cast_nullable_to_non_nullable
as int,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestEntryView].
extension ContestEntryViewPatterns on ContestEntryView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestEntryView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestEntryView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestEntryView value)  $default,){
final _that = this;
switch (_that) {
case _ContestEntryView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestEntryView value)?  $default,){
final _that = this;
switch (_that) {
case _ContestEntryView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime joinedAt,  String level,  int total,  int? rank,  int streak,  int bestStreak,  int correctCount,  int wrongCount,  int freeDaysLeft,  bool scoringPaused)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestEntryView() when $default != null:
return $default(_that.joinedAt,_that.level,_that.total,_that.rank,_that.streak,_that.bestStreak,_that.correctCount,_that.wrongCount,_that.freeDaysLeft,_that.scoringPaused);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime joinedAt,  String level,  int total,  int? rank,  int streak,  int bestStreak,  int correctCount,  int wrongCount,  int freeDaysLeft,  bool scoringPaused)  $default,) {final _that = this;
switch (_that) {
case _ContestEntryView():
return $default(_that.joinedAt,_that.level,_that.total,_that.rank,_that.streak,_that.bestStreak,_that.correctCount,_that.wrongCount,_that.freeDaysLeft,_that.scoringPaused);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime joinedAt,  String level,  int total,  int? rank,  int streak,  int bestStreak,  int correctCount,  int wrongCount,  int freeDaysLeft,  bool scoringPaused)?  $default,) {final _that = this;
switch (_that) {
case _ContestEntryView() when $default != null:
return $default(_that.joinedAt,_that.level,_that.total,_that.rank,_that.streak,_that.bestStreak,_that.correctCount,_that.wrongCount,_that.freeDaysLeft,_that.scoringPaused);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestEntryView extends ContestEntryView {
  const _ContestEntryView({required this.joinedAt, this.level = 'B2', this.total = 0, this.rank, this.streak = 0, this.bestStreak = 0, this.correctCount = 0, this.wrongCount = 0, this.freeDaysLeft = 0, this.scoringPaused = false}): super._();
  factory _ContestEntryView.fromJson(Map<String, dynamic> json) => _$ContestEntryViewFromJson(json);

@override final  DateTime joinedAt;
/// The placement band at join (`A1`…`C2`). A label on the board; it
/// prices nothing — each lesson is multiplied by its own day's band.
@override@JsonKey() final  String level;
/// Contest XP. Never below zero: the server clamps every penalty.
@override@JsonKey() final  int total;
/// Null until the board opens. A rank is a comparison with everyone
/// else, and before the reveal the server does not even compute one.
@override final  int? rank;
/// The daily lesson streak, live on the contest's clock: 0 once a day
/// went by without the lesson. Read, never derived.
@override@JsonKey() final  int streak;
@override@JsonKey() final  int bestStreak;
/// First-attempt counts on the questions written for this learner — the
/// tie-break's accuracy.
@override@JsonKey() final  int correctCount;
@override@JsonKey() final  int wrongCount;
/// Whole free scoring days left.
@override@JsonKey() final  int freeDaysLeft;
/// The free period is over and there is no live plan: contest XP has
/// stopped. Lessons and tasks still work; they record and pay nothing.
@override@JsonKey() final  bool scoringPaused;

/// Create a copy of ContestEntryView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestEntryViewCopyWith<_ContestEntryView> get copyWith => __$ContestEntryViewCopyWithImpl<_ContestEntryView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestEntryViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestEntryView&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.level, level) || other.level == level)&&(identical(other.total, total) || other.total == total)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.streak, streak) || other.streak == streak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.wrongCount, wrongCount) || other.wrongCount == wrongCount)&&(identical(other.freeDaysLeft, freeDaysLeft) || other.freeDaysLeft == freeDaysLeft)&&(identical(other.scoringPaused, scoringPaused) || other.scoringPaused == scoringPaused));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,joinedAt,level,total,rank,streak,bestStreak,correctCount,wrongCount,freeDaysLeft,scoringPaused);

@override
String toString() {
  return 'ContestEntryView(joinedAt: $joinedAt, level: $level, total: $total, rank: $rank, streak: $streak, bestStreak: $bestStreak, correctCount: $correctCount, wrongCount: $wrongCount, freeDaysLeft: $freeDaysLeft, scoringPaused: $scoringPaused)';
}


}

/// @nodoc
abstract mixin class _$ContestEntryViewCopyWith<$Res> implements $ContestEntryViewCopyWith<$Res> {
  factory _$ContestEntryViewCopyWith(_ContestEntryView value, $Res Function(_ContestEntryView) _then) = __$ContestEntryViewCopyWithImpl;
@override @useResult
$Res call({
 DateTime joinedAt, String level, int total, int? rank, int streak, int bestStreak, int correctCount, int wrongCount, int freeDaysLeft, bool scoringPaused
});




}
/// @nodoc
class __$ContestEntryViewCopyWithImpl<$Res>
    implements _$ContestEntryViewCopyWith<$Res> {
  __$ContestEntryViewCopyWithImpl(this._self, this._then);

  final _ContestEntryView _self;
  final $Res Function(_ContestEntryView) _then;

/// Create a copy of ContestEntryView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? joinedAt = null,Object? level = null,Object? total = null,Object? rank = freezed,Object? streak = null,Object? bestStreak = null,Object? correctCount = null,Object? wrongCount = null,Object? freeDaysLeft = null,Object? scoringPaused = null,}) {
  return _then(_ContestEntryView(
joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,streak: null == streak ? _self.streak : streak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,wrongCount: null == wrongCount ? _self.wrongCount : wrongCount // ignore: cast_nullable_to_non_nullable
as int,freeDaysLeft: null == freeDaysLeft ? _self.freeDaysLeft : freeDaysLeft // ignore: cast_nullable_to_non_nullable
as int,scoringPaused: null == scoringPaused ? _self.scoringPaused : scoringPaused // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ContestOverview {

 ContestInfo get contest;@JsonKey(unknownEnumValue: ContestPhase.upcoming) ContestPhase get phase;/// Today's contest day, on the contest's clock; day 1 is the start date.
/// At or below zero before it starts, past the last day once it ended.
 int get dayNumber;/// Start to end, in days. **Never rendered**: the contest is shown by its
/// dates and its day count, never by its length — no "of N", no "N-day
/// contest" (the web's no-branding rule, guarded on both platforms).
 int get lengthDays; BoardReveal get board;/// Null when the caller has not joined.
 ContestEntryView? get entry;/// How many are taking part. Shown before the reveal too: it names and
/// ranks nobody.
 int get entrants;
/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestOverviewCopyWith<ContestOverview> get copyWith => _$ContestOverviewCopyWithImpl<ContestOverview>(this as ContestOverview, _$identity);

  /// Serializes this ContestOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestOverview&&(identical(other.contest, contest) || other.contest == contest)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.lengthDays, lengthDays) || other.lengthDays == lengthDays)&&(identical(other.board, board) || other.board == board)&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.entrants, entrants) || other.entrants == entrants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contest,phase,dayNumber,lengthDays,board,entry,entrants);

@override
String toString() {
  return 'ContestOverview(contest: $contest, phase: $phase, dayNumber: $dayNumber, lengthDays: $lengthDays, board: $board, entry: $entry, entrants: $entrants)';
}


}

/// @nodoc
abstract mixin class $ContestOverviewCopyWith<$Res>  {
  factory $ContestOverviewCopyWith(ContestOverview value, $Res Function(ContestOverview) _then) = _$ContestOverviewCopyWithImpl;
@useResult
$Res call({
 ContestInfo contest,@JsonKey(unknownEnumValue: ContestPhase.upcoming) ContestPhase phase, int dayNumber, int lengthDays, BoardReveal board, ContestEntryView? entry, int entrants
});


$ContestInfoCopyWith<$Res> get contest;$BoardRevealCopyWith<$Res> get board;$ContestEntryViewCopyWith<$Res>? get entry;

}
/// @nodoc
class _$ContestOverviewCopyWithImpl<$Res>
    implements $ContestOverviewCopyWith<$Res> {
  _$ContestOverviewCopyWithImpl(this._self, this._then);

  final ContestOverview _self;
  final $Res Function(ContestOverview) _then;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contest = null,Object? phase = null,Object? dayNumber = null,Object? lengthDays = null,Object? board = null,Object? entry = freezed,Object? entrants = null,}) {
  return _then(_self.copyWith(
contest: null == contest ? _self.contest : contest // ignore: cast_nullable_to_non_nullable
as ContestInfo,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ContestPhase,dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,lengthDays: null == lengthDays ? _self.lengthDays : lengthDays // ignore: cast_nullable_to_non_nullable
as int,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardReveal,entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as ContestEntryView?,entrants: null == entrants ? _self.entrants : entrants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res> get contest {
  
  return $ContestInfoCopyWith<$Res>(_self.contest, (value) {
    return _then(_self.copyWith(contest: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardRevealCopyWith<$Res> get board {
  
  return $BoardRevealCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestEntryViewCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $ContestEntryViewCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContestOverview].
extension ContestOverviewPatterns on ContestOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestOverview value)  $default,){
final _that = this;
switch (_that) {
case _ContestOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestOverview value)?  $default,){
final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContestInfo contest, @JsonKey(unknownEnumValue: ContestPhase.upcoming)  ContestPhase phase,  int dayNumber,  int lengthDays,  BoardReveal board,  ContestEntryView? entry,  int entrants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
return $default(_that.contest,_that.phase,_that.dayNumber,_that.lengthDays,_that.board,_that.entry,_that.entrants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContestInfo contest, @JsonKey(unknownEnumValue: ContestPhase.upcoming)  ContestPhase phase,  int dayNumber,  int lengthDays,  BoardReveal board,  ContestEntryView? entry,  int entrants)  $default,) {final _that = this;
switch (_that) {
case _ContestOverview():
return $default(_that.contest,_that.phase,_that.dayNumber,_that.lengthDays,_that.board,_that.entry,_that.entrants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContestInfo contest, @JsonKey(unknownEnumValue: ContestPhase.upcoming)  ContestPhase phase,  int dayNumber,  int lengthDays,  BoardReveal board,  ContestEntryView? entry,  int entrants)?  $default,) {final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
return $default(_that.contest,_that.phase,_that.dayNumber,_that.lengthDays,_that.board,_that.entry,_that.entrants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestOverview extends ContestOverview {
  const _ContestOverview({required this.contest, @JsonKey(unknownEnumValue: ContestPhase.upcoming) this.phase = ContestPhase.upcoming, this.dayNumber = 0, this.lengthDays = 0, this.board = const BoardReveal(), this.entry, this.entrants = 0}): super._();
  factory _ContestOverview.fromJson(Map<String, dynamic> json) => _$ContestOverviewFromJson(json);

@override final  ContestInfo contest;
@override@JsonKey(unknownEnumValue: ContestPhase.upcoming) final  ContestPhase phase;
/// Today's contest day, on the contest's clock; day 1 is the start date.
/// At or below zero before it starts, past the last day once it ended.
@override@JsonKey() final  int dayNumber;
/// Start to end, in days. **Never rendered**: the contest is shown by its
/// dates and its day count, never by its length — no "of N", no "N-day
/// contest" (the web's no-branding rule, guarded on both platforms).
@override@JsonKey() final  int lengthDays;
@override@JsonKey() final  BoardReveal board;
/// Null when the caller has not joined.
@override final  ContestEntryView? entry;
/// How many are taking part. Shown before the reveal too: it names and
/// ranks nobody.
@override@JsonKey() final  int entrants;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestOverviewCopyWith<_ContestOverview> get copyWith => __$ContestOverviewCopyWithImpl<_ContestOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestOverview&&(identical(other.contest, contest) || other.contest == contest)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber)&&(identical(other.lengthDays, lengthDays) || other.lengthDays == lengthDays)&&(identical(other.board, board) || other.board == board)&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.entrants, entrants) || other.entrants == entrants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contest,phase,dayNumber,lengthDays,board,entry,entrants);

@override
String toString() {
  return 'ContestOverview(contest: $contest, phase: $phase, dayNumber: $dayNumber, lengthDays: $lengthDays, board: $board, entry: $entry, entrants: $entrants)';
}


}

/// @nodoc
abstract mixin class _$ContestOverviewCopyWith<$Res> implements $ContestOverviewCopyWith<$Res> {
  factory _$ContestOverviewCopyWith(_ContestOverview value, $Res Function(_ContestOverview) _then) = __$ContestOverviewCopyWithImpl;
@override @useResult
$Res call({
 ContestInfo contest,@JsonKey(unknownEnumValue: ContestPhase.upcoming) ContestPhase phase, int dayNumber, int lengthDays, BoardReveal board, ContestEntryView? entry, int entrants
});


@override $ContestInfoCopyWith<$Res> get contest;@override $BoardRevealCopyWith<$Res> get board;@override $ContestEntryViewCopyWith<$Res>? get entry;

}
/// @nodoc
class __$ContestOverviewCopyWithImpl<$Res>
    implements _$ContestOverviewCopyWith<$Res> {
  __$ContestOverviewCopyWithImpl(this._self, this._then);

  final _ContestOverview _self;
  final $Res Function(_ContestOverview) _then;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contest = null,Object? phase = null,Object? dayNumber = null,Object? lengthDays = null,Object? board = null,Object? entry = freezed,Object? entrants = null,}) {
  return _then(_ContestOverview(
contest: null == contest ? _self.contest : contest // ignore: cast_nullable_to_non_nullable
as ContestInfo,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ContestPhase,dayNumber: null == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int,lengthDays: null == lengthDays ? _self.lengthDays : lengthDays // ignore: cast_nullable_to_non_nullable
as int,board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as BoardReveal,entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as ContestEntryView?,entrants: null == entrants ? _self.entrants : entrants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res> get contest {
  
  return $ContestInfoCopyWith<$Res>(_self.contest, (value) {
    return _then(_self.copyWith(contest: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BoardRevealCopyWith<$Res> get board {
  
  return $BoardRevealCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestEntryViewCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $ContestEntryViewCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

// dart format on
