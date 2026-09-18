// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposeStatus {

 ComposeBusy get busy;/// The line under the spinner. The web's exact strings: "Generating post
/// content...", "Designing your poster...".
 String? get progress;/// A message to show the user. Rendered in amber, never red — Zave has no
/// red, and a failed generation is "needs attention", not a destructive
/// state.
 String? get error;/// The server answered 402 INSUFFICIENT_XP. Distinct from [error] because
/// the remedy is different: the user has to top up, not retry.
 bool get insufficientXp;/// Set once a submission lands, and cleared the moment the user edits
/// again.
 ComposeOutcome? get outcome;/// What the in-flight submission is TRYING to be.
///
/// Three buttons share one save path, so without this they would all spin
/// together — a user who tapped "Save as draft" would watch "Submit for
/// approval" appear to be working. The spinner belongs on the button that
/// was pressed.
 ComposeOutcome? get intent;/// The id `POST /posts` returned. Carried so a company publish can tell
/// LinkedIn which row to stamp `published` on.
 String? get savedPostId;/// The live LinkedIn URL, after a company publish.
 String? get publishedUrl;
/// Create a copy of ComposeStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeStatusCopyWith<ComposeStatus> get copyWith => _$ComposeStatusCopyWithImpl<ComposeStatus>(this as ComposeStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeStatus&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.savedPostId, savedPostId) || other.savedPostId == savedPostId)&&(identical(other.publishedUrl, publishedUrl) || other.publishedUrl == publishedUrl));
}


@override
int get hashCode => Object.hash(runtimeType,busy,progress,error,insufficientXp,outcome,intent,savedPostId,publishedUrl);

@override
String toString() {
  return 'ComposeStatus(busy: $busy, progress: $progress, error: $error, insufficientXp: $insufficientXp, outcome: $outcome, intent: $intent, savedPostId: $savedPostId, publishedUrl: $publishedUrl)';
}


}

/// @nodoc
abstract mixin class $ComposeStatusCopyWith<$Res>  {
  factory $ComposeStatusCopyWith(ComposeStatus value, $Res Function(ComposeStatus) _then) = _$ComposeStatusCopyWithImpl;
@useResult
$Res call({
 ComposeBusy busy, String? progress, String? error, bool insufficientXp, ComposeOutcome? outcome, ComposeOutcome? intent, String? savedPostId, String? publishedUrl
});




}
/// @nodoc
class _$ComposeStatusCopyWithImpl<$Res>
    implements $ComposeStatusCopyWith<$Res> {
  _$ComposeStatusCopyWithImpl(this._self, this._then);

  final ComposeStatus _self;
  final $Res Function(ComposeStatus) _then;

/// Create a copy of ComposeStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = null,Object? progress = freezed,Object? error = freezed,Object? insufficientXp = null,Object? outcome = freezed,Object? intent = freezed,Object? savedPostId = freezed,Object? publishedUrl = freezed,}) {
  return _then(_self.copyWith(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as ComposeBusy,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ComposeOutcome?,intent: freezed == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as ComposeOutcome?,savedPostId: freezed == savedPostId ? _self.savedPostId : savedPostId // ignore: cast_nullable_to_non_nullable
as String?,publishedUrl: freezed == publishedUrl ? _self.publishedUrl : publishedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComposeStatus].
extension ComposeStatusPatterns on ComposeStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComposeStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComposeStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComposeStatus value)  $default,){
final _that = this;
switch (_that) {
case _ComposeStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComposeStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ComposeStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ComposeBusy busy,  String? progress,  String? error,  bool insufficientXp,  ComposeOutcome? outcome,  ComposeOutcome? intent,  String? savedPostId,  String? publishedUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComposeStatus() when $default != null:
return $default(_that.busy,_that.progress,_that.error,_that.insufficientXp,_that.outcome,_that.intent,_that.savedPostId,_that.publishedUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ComposeBusy busy,  String? progress,  String? error,  bool insufficientXp,  ComposeOutcome? outcome,  ComposeOutcome? intent,  String? savedPostId,  String? publishedUrl)  $default,) {final _that = this;
switch (_that) {
case _ComposeStatus():
return $default(_that.busy,_that.progress,_that.error,_that.insufficientXp,_that.outcome,_that.intent,_that.savedPostId,_that.publishedUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ComposeBusy busy,  String? progress,  String? error,  bool insufficientXp,  ComposeOutcome? outcome,  ComposeOutcome? intent,  String? savedPostId,  String? publishedUrl)?  $default,) {final _that = this;
switch (_that) {
case _ComposeStatus() when $default != null:
return $default(_that.busy,_that.progress,_that.error,_that.insufficientXp,_that.outcome,_that.intent,_that.savedPostId,_that.publishedUrl);case _:
  return null;

}
}

}

/// @nodoc


class _ComposeStatus extends ComposeStatus {
  const _ComposeStatus({this.busy = ComposeBusy.idle, this.progress, this.error, this.insufficientXp = false, this.outcome, this.intent, this.savedPostId, this.publishedUrl}): super._();
  

@override@JsonKey() final  ComposeBusy busy;
/// The line under the spinner. The web's exact strings: "Generating post
/// content...", "Designing your poster...".
@override final  String? progress;
/// A message to show the user. Rendered in amber, never red — Zave has no
/// red, and a failed generation is "needs attention", not a destructive
/// state.
@override final  String? error;
/// The server answered 402 INSUFFICIENT_XP. Distinct from [error] because
/// the remedy is different: the user has to top up, not retry.
@override@JsonKey() final  bool insufficientXp;
/// Set once a submission lands, and cleared the moment the user edits
/// again.
@override final  ComposeOutcome? outcome;
/// What the in-flight submission is TRYING to be.
///
/// Three buttons share one save path, so without this they would all spin
/// together — a user who tapped "Save as draft" would watch "Submit for
/// approval" appear to be working. The spinner belongs on the button that
/// was pressed.
@override final  ComposeOutcome? intent;
/// The id `POST /posts` returned. Carried so a company publish can tell
/// LinkedIn which row to stamp `published` on.
@override final  String? savedPostId;
/// The live LinkedIn URL, after a company publish.
@override final  String? publishedUrl;

/// Create a copy of ComposeStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComposeStatusCopyWith<_ComposeStatus> get copyWith => __$ComposeStatusCopyWithImpl<_ComposeStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComposeStatus&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.error, error) || other.error == error)&&(identical(other.insufficientXp, insufficientXp) || other.insufficientXp == insufficientXp)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.savedPostId, savedPostId) || other.savedPostId == savedPostId)&&(identical(other.publishedUrl, publishedUrl) || other.publishedUrl == publishedUrl));
}


@override
int get hashCode => Object.hash(runtimeType,busy,progress,error,insufficientXp,outcome,intent,savedPostId,publishedUrl);

@override
String toString() {
  return 'ComposeStatus(busy: $busy, progress: $progress, error: $error, insufficientXp: $insufficientXp, outcome: $outcome, intent: $intent, savedPostId: $savedPostId, publishedUrl: $publishedUrl)';
}


}

/// @nodoc
abstract mixin class _$ComposeStatusCopyWith<$Res> implements $ComposeStatusCopyWith<$Res> {
  factory _$ComposeStatusCopyWith(_ComposeStatus value, $Res Function(_ComposeStatus) _then) = __$ComposeStatusCopyWithImpl;
@override @useResult
$Res call({
 ComposeBusy busy, String? progress, String? error, bool insufficientXp, ComposeOutcome? outcome, ComposeOutcome? intent, String? savedPostId, String? publishedUrl
});




}
/// @nodoc
class __$ComposeStatusCopyWithImpl<$Res>
    implements _$ComposeStatusCopyWith<$Res> {
  __$ComposeStatusCopyWithImpl(this._self, this._then);

  final _ComposeStatus _self;
  final $Res Function(_ComposeStatus) _then;

/// Create a copy of ComposeStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = null,Object? progress = freezed,Object? error = freezed,Object? insufficientXp = null,Object? outcome = freezed,Object? intent = freezed,Object? savedPostId = freezed,Object? publishedUrl = freezed,}) {
  return _then(_ComposeStatus(
busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as ComposeBusy,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,insufficientXp: null == insufficientXp ? _self.insufficientXp : insufficientXp // ignore: cast_nullable_to_non_nullable
as bool,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as ComposeOutcome?,intent: freezed == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as ComposeOutcome?,savedPostId: freezed == savedPostId ? _self.savedPostId : savedPostId // ignore: cast_nullable_to_non_nullable
as String?,publishedUrl: freezed == publishedUrl ? _self.publishedUrl : publishedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
