// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'headshot_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HeadshotResult {

 List<String> get headshots; int get count; String get style; String get background;
/// Create a copy of HeadshotResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadshotResultCopyWith<HeadshotResult> get copyWith => _$HeadshotResultCopyWithImpl<HeadshotResult>(this as HeadshotResult, _$identity);

  /// Serializes this HeadshotResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadshotResult&&const DeepCollectionEquality().equals(other.headshots, headshots)&&(identical(other.count, count) || other.count == count)&&(identical(other.style, style) || other.style == style)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(headshots),count,style,background);

@override
String toString() {
  return 'HeadshotResult(headshots: $headshots, count: $count, style: $style, background: $background)';
}


}

/// @nodoc
abstract mixin class $HeadshotResultCopyWith<$Res>  {
  factory $HeadshotResultCopyWith(HeadshotResult value, $Res Function(HeadshotResult) _then) = _$HeadshotResultCopyWithImpl;
@useResult
$Res call({
 List<String> headshots, int count, String style, String background
});




}
/// @nodoc
class _$HeadshotResultCopyWithImpl<$Res>
    implements $HeadshotResultCopyWith<$Res> {
  _$HeadshotResultCopyWithImpl(this._self, this._then);

  final HeadshotResult _self;
  final $Res Function(HeadshotResult) _then;

/// Create a copy of HeadshotResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headshots = null,Object? count = null,Object? style = null,Object? background = null,}) {
  return _then(_self.copyWith(
headshots: null == headshots ? _self.headshots : headshots // ignore: cast_nullable_to_non_nullable
as List<String>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadshotResult].
extension HeadshotResultPatterns on HeadshotResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadshotResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadshotResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadshotResult value)  $default,){
final _that = this;
switch (_that) {
case _HeadshotResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadshotResult value)?  $default,){
final _that = this;
switch (_that) {
case _HeadshotResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> headshots,  int count,  String style,  String background)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadshotResult() when $default != null:
return $default(_that.headshots,_that.count,_that.style,_that.background);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> headshots,  int count,  String style,  String background)  $default,) {final _that = this;
switch (_that) {
case _HeadshotResult():
return $default(_that.headshots,_that.count,_that.style,_that.background);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> headshots,  int count,  String style,  String background)?  $default,) {final _that = this;
switch (_that) {
case _HeadshotResult() when $default != null:
return $default(_that.headshots,_that.count,_that.style,_that.background);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeadshotResult implements HeadshotResult {
  const _HeadshotResult({final  List<String> headshots = const <String>[], this.count = 0, this.style = 'professional', this.background = 'studio'}): _headshots = headshots;
  factory _HeadshotResult.fromJson(Map<String, dynamic> json) => _$HeadshotResultFromJson(json);

 final  List<String> _headshots;
@override@JsonKey() List<String> get headshots {
  if (_headshots is EqualUnmodifiableListView) return _headshots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_headshots);
}

@override@JsonKey() final  int count;
@override@JsonKey() final  String style;
@override@JsonKey() final  String background;

/// Create a copy of HeadshotResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadshotResultCopyWith<_HeadshotResult> get copyWith => __$HeadshotResultCopyWithImpl<_HeadshotResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeadshotResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadshotResult&&const DeepCollectionEquality().equals(other._headshots, _headshots)&&(identical(other.count, count) || other.count == count)&&(identical(other.style, style) || other.style == style)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_headshots),count,style,background);

@override
String toString() {
  return 'HeadshotResult(headshots: $headshots, count: $count, style: $style, background: $background)';
}


}

/// @nodoc
abstract mixin class _$HeadshotResultCopyWith<$Res> implements $HeadshotResultCopyWith<$Res> {
  factory _$HeadshotResultCopyWith(_HeadshotResult value, $Res Function(_HeadshotResult) _then) = __$HeadshotResultCopyWithImpl;
@override @useResult
$Res call({
 List<String> headshots, int count, String style, String background
});




}
/// @nodoc
class __$HeadshotResultCopyWithImpl<$Res>
    implements _$HeadshotResultCopyWith<$Res> {
  __$HeadshotResultCopyWithImpl(this._self, this._then);

  final _HeadshotResult _self;
  final $Res Function(_HeadshotResult) _then;

/// Create a copy of HeadshotResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headshots = null,Object? count = null,Object? style = null,Object? background = null,}) {
  return _then(_HeadshotResult(
headshots: null == headshots ? _self._headshots : headshots // ignore: cast_nullable_to_non_nullable
as List<String>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HeadshotSession {

 HeadshotStep get step;/// Reference photos as `data:image/…;base64,…` URIs, filled by
/// [HeadshotsController.pickPhoto] from the camera roll or the camera.
///
/// At least three are needed before the flow can generate — the server
/// rejects fewer, and `canGenerate` gates on it here so the user is told
/// before spending the round trip.
 List<String> get photos; HeadshotStyle get style; HeadshotBackground get background;/// The generated portraits, as data URIs.
 List<String> get results; bool get generating;/// `POST /roadmap/progress` in flight, and then done. Headshots is the
/// roadmap's Level 1 Step 5, and closing it out is part of the page.
 bool get finishing; bool get finished;/// Amber, never red.
 String? get error;/// 402 — the user needs more XP, not another attempt.
 bool get insufficientXp;
/// Create a copy of HeadshotSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadshotSessionCopyWith<HeadshotSession> get copyWith => _$HeadshotSessionCopyWithImpl<HeadshotSession>(this as HeadshotSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadshotSession&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.style, style) || other.style == style)&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.generating, generating) || other.generating == generating)&&(identical(other.finishing, finishing) || other.finishing == finishing)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp));
}


@override
int get hashCode => Object.hash(runtimeType,step,const DeepCollectionEquality().hash(photos),style,background,const DeepCollectionEquality().hash(results),generating,finishing,finished,error,insufficientXp);

@override
String toString() {
  return 'HeadshotSession(step: $step, photos: $photos, style: $style, background: $background, results: $results, generating: $generating, finishing: $finishing, finished: $finished, error: $error, insufficientXp: $insufficientXp)';
}


}

/// @nodoc
abstract mixin class $HeadshotSessionCopyWith<$Res>  {
  factory $HeadshotSessionCopyWith(HeadshotSession value, $Res Function(HeadshotSession) _then) = _$HeadshotSessionCopyWithImpl;
@useResult
$Res call({
 HeadshotStep step, List<String> photos, HeadshotStyle style, HeadshotBackground background, List<String> results, bool generating, bool finishing, bool finished, String? error, bool insufficientXp
});




}
/// @nodoc
class _$HeadshotSessionCopyWithImpl<$Res>
    implements $HeadshotSessionCopyWith<$Res> {
  _$HeadshotSessionCopyWithImpl(this._self, this._then);

  final HeadshotSession _self;
  final $Res Function(HeadshotSession) _then;

/// Create a copy of HeadshotSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? photos = null,Object? style = null,Object? background = null,Object? results = null,Object? generating = null,Object? finishing = null,Object? finished = null,Object? error = freezed,Object? insufficientXp = null,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as HeadshotStep,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as HeadshotStyle,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as HeadshotBackground,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<String>,generating: null == generating ? _self.generating : generating // ignore: cast_nullable_to_non_nullable
as bool,finishing: null == finishing ? _self.finishing : finishing // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadshotSession].
extension HeadshotSessionPatterns on HeadshotSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadshotSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadshotSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadshotSession value)  $default,){
final _that = this;
switch (_that) {
case _HeadshotSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadshotSession value)?  $default,){
final _that = this;
switch (_that) {
case _HeadshotSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HeadshotStep step,  List<String> photos,  HeadshotStyle style,  HeadshotBackground background,  List<String> results,  bool generating,  bool finishing,  bool finished,  String? error,  bool insufficientXp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadshotSession() when $default != null:
return $default(_that.step,_that.photos,_that.style,_that.background,_that.results,_that.generating,_that.finishing,_that.finished,_that.error,_that.insufficientXp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HeadshotStep step,  List<String> photos,  HeadshotStyle style,  HeadshotBackground background,  List<String> results,  bool generating,  bool finishing,  bool finished,  String? error,  bool insufficientXp)  $default,) {final _that = this;
switch (_that) {
case _HeadshotSession():
return $default(_that.step,_that.photos,_that.style,_that.background,_that.results,_that.generating,_that.finishing,_that.finished,_that.error,_that.insufficientXp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HeadshotStep step,  List<String> photos,  HeadshotStyle style,  HeadshotBackground background,  List<String> results,  bool generating,  bool finishing,  bool finished,  String? error,  bool insufficientXp)?  $default,) {final _that = this;
switch (_that) {
case _HeadshotSession() when $default != null:
return $default(_that.step,_that.photos,_that.style,_that.background,_that.results,_that.generating,_that.finishing,_that.finished,_that.error,_that.insufficientXp);case _:
  return null;

}
}

}

/// @nodoc


class _HeadshotSession extends HeadshotSession {
  const _HeadshotSession({this.step = HeadshotStep.upload, final  List<String> photos = const <String>[], this.style = HeadshotStyle.professional, this.background = HeadshotBackground.studio, final  List<String> results = const <String>[], this.generating = false, this.finishing = false, this.finished = false, this.error, this.insufficientXp = false}): _photos = photos,_results = results,super._();
  

@override@JsonKey() final  HeadshotStep step;
/// Reference photos as `data:image/…;base64,…` URIs, filled by
/// [HeadshotsController.pickPhoto] from the camera roll or the camera.
///
/// At least three are needed before the flow can generate — the server
/// rejects fewer, and `canGenerate` gates on it here so the user is told
/// before spending the round trip.
 final  List<String> _photos;
/// Reference photos as `data:image/…;base64,…` URIs, filled by
/// [HeadshotsController.pickPhoto] from the camera roll or the camera.
///
/// At least three are needed before the flow can generate — the server
/// rejects fewer, and `canGenerate` gates on it here so the user is told
/// before spending the round trip.
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  HeadshotStyle style;
@override@JsonKey() final  HeadshotBackground background;
/// The generated portraits, as data URIs.
 final  List<String> _results;
/// The generated portraits, as data URIs.
@override@JsonKey() List<String> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  bool generating;
/// `POST /roadmap/progress` in flight, and then done. Headshots is the
/// roadmap's Level 1 Step 5, and closing it out is part of the page.
@override@JsonKey() final  bool finishing;
@override@JsonKey() final  bool finished;
/// Amber, never red.
@override final  String? error;
/// 402 — the user needs more XP, not another attempt.
@override@JsonKey() final  bool insufficientXp;

/// Create a copy of HeadshotSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadshotSessionCopyWith<_HeadshotSession> get copyWith => __$HeadshotSessionCopyWithImpl<_HeadshotSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadshotSession&&(identical(other.step, step) || other.step == step)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.style, style) || other.style == style)&&(identical(other.background, background) || other.background == background)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.generating, generating) || other.generating == generating)&&(identical(other.finishing, finishing) || other.finishing == finishing)&&(identical(other.finished, finished) || other.finished == finished)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp));
}


@override
int get hashCode => Object.hash(runtimeType,step,const DeepCollectionEquality().hash(_photos),style,background,const DeepCollectionEquality().hash(_results),generating,finishing,finished,error,insufficientXp);

@override
String toString() {
  return 'HeadshotSession(step: $step, photos: $photos, style: $style, background: $background, results: $results, generating: $generating, finishing: $finishing, finished: $finished, error: $error, insufficientXp: $insufficientXp)';
}


}

/// @nodoc
abstract mixin class _$HeadshotSessionCopyWith<$Res> implements $HeadshotSessionCopyWith<$Res> {
  factory _$HeadshotSessionCopyWith(_HeadshotSession value, $Res Function(_HeadshotSession) _then) = __$HeadshotSessionCopyWithImpl;
@override @useResult
$Res call({
 HeadshotStep step, List<String> photos, HeadshotStyle style, HeadshotBackground background, List<String> results, bool generating, bool finishing, bool finished, String? error, bool insufficientXp
});




}
/// @nodoc
class __$HeadshotSessionCopyWithImpl<$Res>
    implements _$HeadshotSessionCopyWith<$Res> {
  __$HeadshotSessionCopyWithImpl(this._self, this._then);

  final _HeadshotSession _self;
  final $Res Function(_HeadshotSession) _then;

/// Create a copy of HeadshotSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? photos = null,Object? style = null,Object? background = null,Object? results = null,Object? generating = null,Object? finishing = null,Object? finished = null,Object? error = freezed,Object? insufficientXp = null,}) {
  return _then(_HeadshotSession(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as HeadshotStep,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as HeadshotStyle,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as HeadshotBackground,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<String>,generating: null == generating ? _self.generating : generating // ignore: cast_nullable_to_non_nullable
as bool,finishing: null == finishing ? _self.finishing : finishing // ignore: cast_nullable_to_non_nullable
as bool,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
