// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_script.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoBeat {

/// Seconds from the start this beat begins.
 int get seconds;/// What the speaker says. One or two sentences.
 String get say;/// What is on screen — a cut, a demo, text, nothing.
 String get show;
/// Create a copy of VideoBeat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoBeatCopyWith<VideoBeat> get copyWith => _$VideoBeatCopyWithImpl<VideoBeat>(this as VideoBeat, _$identity);

  /// Serializes this VideoBeat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoBeat&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.say, say) || other.say == say)&&(identical(other.show, show) || other.show == show));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds,say,show);

@override
String toString() {
  return 'VideoBeat(seconds: $seconds, say: $say, show: $show)';
}


}

/// @nodoc
abstract mixin class $VideoBeatCopyWith<$Res>  {
  factory $VideoBeatCopyWith(VideoBeat value, $Res Function(VideoBeat) _then) = _$VideoBeatCopyWithImpl;
@useResult
$Res call({
 int seconds, String say, String show
});




}
/// @nodoc
class _$VideoBeatCopyWithImpl<$Res>
    implements $VideoBeatCopyWith<$Res> {
  _$VideoBeatCopyWithImpl(this._self, this._then);

  final VideoBeat _self;
  final $Res Function(VideoBeat) _then;

/// Create a copy of VideoBeat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seconds = null,Object? say = null,Object? show = null,}) {
  return _then(_self.copyWith(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,say: null == say ? _self.say : say // ignore: cast_nullable_to_non_nullable
as String,show: null == show ? _self.show : show // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoBeat].
extension VideoBeatPatterns on VideoBeat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoBeat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoBeat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoBeat value)  $default,){
final _that = this;
switch (_that) {
case _VideoBeat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoBeat value)?  $default,){
final _that = this;
switch (_that) {
case _VideoBeat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seconds,  String say,  String show)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoBeat() when $default != null:
return $default(_that.seconds,_that.say,_that.show);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seconds,  String say,  String show)  $default,) {final _that = this;
switch (_that) {
case _VideoBeat():
return $default(_that.seconds,_that.say,_that.show);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seconds,  String say,  String show)?  $default,) {final _that = this;
switch (_that) {
case _VideoBeat() when $default != null:
return $default(_that.seconds,_that.say,_that.show);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoBeat extends VideoBeat {
  const _VideoBeat({this.seconds = 0, this.say = '', this.show = ''}): super._();
  factory _VideoBeat.fromJson(Map<String, dynamic> json) => _$VideoBeatFromJson(json);

/// Seconds from the start this beat begins.
@override@JsonKey() final  int seconds;
/// What the speaker says. One or two sentences.
@override@JsonKey() final  String say;
/// What is on screen — a cut, a demo, text, nothing.
@override@JsonKey() final  String show;

/// Create a copy of VideoBeat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoBeatCopyWith<_VideoBeat> get copyWith => __$VideoBeatCopyWithImpl<_VideoBeat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoBeatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoBeat&&(identical(other.seconds, seconds) || other.seconds == seconds)&&(identical(other.say, say) || other.say == say)&&(identical(other.show, show) || other.show == show));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seconds,say,show);

@override
String toString() {
  return 'VideoBeat(seconds: $seconds, say: $say, show: $show)';
}


}

/// @nodoc
abstract mixin class _$VideoBeatCopyWith<$Res> implements $VideoBeatCopyWith<$Res> {
  factory _$VideoBeatCopyWith(_VideoBeat value, $Res Function(_VideoBeat) _then) = __$VideoBeatCopyWithImpl;
@override @useResult
$Res call({
 int seconds, String say, String show
});




}
/// @nodoc
class __$VideoBeatCopyWithImpl<$Res>
    implements _$VideoBeatCopyWith<$Res> {
  __$VideoBeatCopyWithImpl(this._self, this._then);

  final _VideoBeat _self;
  final $Res Function(_VideoBeat) _then;

/// Create a copy of VideoBeat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seconds = null,Object? say = null,Object? show = null,}) {
  return _then(_VideoBeat(
seconds: null == seconds ? _self.seconds : seconds // ignore: cast_nullable_to_non_nullable
as int,say: null == say ? _self.say : say // ignore: cast_nullable_to_non_nullable
as String,show: null == show ? _self.show : show // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VideoScript {

 String get id; int get weekNumber; int get season;/// 0–6, Monday-first, matching the plan's slot order.
 int get dayIndex; String get title;/// The first line. The single most load-bearing sentence in a short video
/// — it is what decides whether the next four seconds happen.
 String get hook; List<VideoBeat> get beats;/// What goes in the post alongside the video.
 String get caption;/// 'ready' once written; 'published' only once the user says so.
 String get status; String? get publishedAt;
/// Create a copy of VideoScript
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoScriptCopyWith<VideoScript> get copyWith => _$VideoScriptCopyWithImpl<VideoScript>(this as VideoScript, _$identity);

  /// Serializes this VideoScript to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoScript&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.title, title) || other.title == title)&&(identical(other.hook, hook) || other.hook == hook)&&const DeepCollectionEquality().equals(other.beats, beats)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,dayIndex,title,hook,const DeepCollectionEquality().hash(beats),caption,status,publishedAt);

@override
String toString() {
  return 'VideoScript(id: $id, weekNumber: $weekNumber, season: $season, dayIndex: $dayIndex, title: $title, hook: $hook, beats: $beats, caption: $caption, status: $status, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class $VideoScriptCopyWith<$Res>  {
  factory $VideoScriptCopyWith(VideoScript value, $Res Function(VideoScript) _then) = _$VideoScriptCopyWithImpl;
@useResult
$Res call({
 String id, int weekNumber, int season, int dayIndex, String title, String hook, List<VideoBeat> beats, String caption, String status, String? publishedAt
});




}
/// @nodoc
class _$VideoScriptCopyWithImpl<$Res>
    implements $VideoScriptCopyWith<$Res> {
  _$VideoScriptCopyWithImpl(this._self, this._then);

  final VideoScript _self;
  final $Res Function(VideoScript) _then;

/// Create a copy of VideoScript
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? dayIndex = null,Object? title = null,Object? hook = null,Object? beats = null,Object? caption = null,Object? status = null,Object? publishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hook: null == hook ? _self.hook : hook // ignore: cast_nullable_to_non_nullable
as String,beats: null == beats ? _self.beats : beats // ignore: cast_nullable_to_non_nullable
as List<VideoBeat>,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoScript].
extension VideoScriptPatterns on VideoScript {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoScript value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoScript() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoScript value)  $default,){
final _that = this;
switch (_that) {
case _VideoScript():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoScript value)?  $default,){
final _that = this;
switch (_that) {
case _VideoScript() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  int dayIndex,  String title,  String hook,  List<VideoBeat> beats,  String caption,  String status,  String? publishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoScript() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.dayIndex,_that.title,_that.hook,_that.beats,_that.caption,_that.status,_that.publishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  int dayIndex,  String title,  String hook,  List<VideoBeat> beats,  String caption,  String status,  String? publishedAt)  $default,) {final _that = this;
switch (_that) {
case _VideoScript():
return $default(_that.id,_that.weekNumber,_that.season,_that.dayIndex,_that.title,_that.hook,_that.beats,_that.caption,_that.status,_that.publishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int weekNumber,  int season,  int dayIndex,  String title,  String hook,  List<VideoBeat> beats,  String caption,  String status,  String? publishedAt)?  $default,) {final _that = this;
switch (_that) {
case _VideoScript() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.dayIndex,_that.title,_that.hook,_that.beats,_that.caption,_that.status,_that.publishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoScript extends VideoScript {
  const _VideoScript({this.id = '', this.weekNumber = 1, this.season = 1, this.dayIndex = 0, this.title = '', this.hook = '', final  List<VideoBeat> beats = const <VideoBeat>[], this.caption = '', this.status = 'ready', this.publishedAt}): _beats = beats,super._();
  factory _VideoScript.fromJson(Map<String, dynamic> json) => _$VideoScriptFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  int weekNumber;
@override@JsonKey() final  int season;
/// 0–6, Monday-first, matching the plan's slot order.
@override@JsonKey() final  int dayIndex;
@override@JsonKey() final  String title;
/// The first line. The single most load-bearing sentence in a short video
/// — it is what decides whether the next four seconds happen.
@override@JsonKey() final  String hook;
 final  List<VideoBeat> _beats;
@override@JsonKey() List<VideoBeat> get beats {
  if (_beats is EqualUnmodifiableListView) return _beats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beats);
}

/// What goes in the post alongside the video.
@override@JsonKey() final  String caption;
/// 'ready' once written; 'published' only once the user says so.
@override@JsonKey() final  String status;
@override final  String? publishedAt;

/// Create a copy of VideoScript
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoScriptCopyWith<_VideoScript> get copyWith => __$VideoScriptCopyWithImpl<_VideoScript>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoScriptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoScript&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.dayIndex, dayIndex) || other.dayIndex == dayIndex)&&(identical(other.title, title) || other.title == title)&&(identical(other.hook, hook) || other.hook == hook)&&const DeepCollectionEquality().equals(other._beats, _beats)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,dayIndex,title,hook,const DeepCollectionEquality().hash(_beats),caption,status,publishedAt);

@override
String toString() {
  return 'VideoScript(id: $id, weekNumber: $weekNumber, season: $season, dayIndex: $dayIndex, title: $title, hook: $hook, beats: $beats, caption: $caption, status: $status, publishedAt: $publishedAt)';
}


}

/// @nodoc
abstract mixin class _$VideoScriptCopyWith<$Res> implements $VideoScriptCopyWith<$Res> {
  factory _$VideoScriptCopyWith(_VideoScript value, $Res Function(_VideoScript) _then) = __$VideoScriptCopyWithImpl;
@override @useResult
$Res call({
 String id, int weekNumber, int season, int dayIndex, String title, String hook, List<VideoBeat> beats, String caption, String status, String? publishedAt
});




}
/// @nodoc
class __$VideoScriptCopyWithImpl<$Res>
    implements _$VideoScriptCopyWith<$Res> {
  __$VideoScriptCopyWithImpl(this._self, this._then);

  final _VideoScript _self;
  final $Res Function(_VideoScript) _then;

/// Create a copy of VideoScript
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? dayIndex = null,Object? title = null,Object? hook = null,Object? beats = null,Object? caption = null,Object? status = null,Object? publishedAt = freezed,}) {
  return _then(_VideoScript(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,dayIndex: null == dayIndex ? _self.dayIndex : dayIndex // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,hook: null == hook ? _self.hook : hook // ignore: cast_nullable_to_non_nullable
as String,beats: null == beats ? _self._beats : beats // ignore: cast_nullable_to_non_nullable
as List<VideoBeat>,caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
