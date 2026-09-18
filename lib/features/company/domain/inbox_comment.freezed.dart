// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboxComment {

 String get id; String get text;/// Epoch milliseconds. The server defaults it to "now" when LinkedIn omits
/// the timestamp, so it is non-nullable.
 int get createdAt; String get suggestedReply; String get suggestedReaction;
/// Create a copy of InboxComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxCommentCopyWith<InboxComment> get copyWith => _$InboxCommentCopyWithImpl<InboxComment>(this as InboxComment, _$identity);

  /// Serializes this InboxComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxComment&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.suggestedReply, suggestedReply) || other.suggestedReply == suggestedReply)&&(identical(other.suggestedReaction, suggestedReaction) || other.suggestedReaction == suggestedReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,suggestedReply,suggestedReaction);

@override
String toString() {
  return 'InboxComment(id: $id, text: $text, createdAt: $createdAt, suggestedReply: $suggestedReply, suggestedReaction: $suggestedReaction)';
}


}

/// @nodoc
abstract mixin class $InboxCommentCopyWith<$Res>  {
  factory $InboxCommentCopyWith(InboxComment value, $Res Function(InboxComment) _then) = _$InboxCommentCopyWithImpl;
@useResult
$Res call({
 String id, String text, int createdAt, String suggestedReply, String suggestedReaction
});




}
/// @nodoc
class _$InboxCommentCopyWithImpl<$Res>
    implements $InboxCommentCopyWith<$Res> {
  _$InboxCommentCopyWithImpl(this._self, this._then);

  final InboxComment _self;
  final $Res Function(InboxComment) _then;

/// Create a copy of InboxComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? suggestedReply = null,Object? suggestedReaction = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,suggestedReply: null == suggestedReply ? _self.suggestedReply : suggestedReply // ignore: cast_nullable_to_non_nullable
as String,suggestedReaction: null == suggestedReaction ? _self.suggestedReaction : suggestedReaction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxComment].
extension InboxCommentPatterns on InboxComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxComment value)  $default,){
final _that = this;
switch (_that) {
case _InboxComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxComment value)?  $default,){
final _that = this;
switch (_that) {
case _InboxComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  int createdAt,  String suggestedReply,  String suggestedReaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxComment() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.suggestedReply,_that.suggestedReaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  int createdAt,  String suggestedReply,  String suggestedReaction)  $default,) {final _that = this;
switch (_that) {
case _InboxComment():
return $default(_that.id,_that.text,_that.createdAt,_that.suggestedReply,_that.suggestedReaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  int createdAt,  String suggestedReply,  String suggestedReaction)?  $default,) {final _that = this;
switch (_that) {
case _InboxComment() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.suggestedReply,_that.suggestedReaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboxComment extends InboxComment {
  const _InboxComment({required this.id, this.text = '', this.createdAt = 0, this.suggestedReply = '', this.suggestedReaction = 'LIKE'}): super._();
  factory _InboxComment.fromJson(Map<String, dynamic> json) => _$InboxCommentFromJson(json);

@override final  String id;
@override@JsonKey() final  String text;
/// Epoch milliseconds. The server defaults it to "now" when LinkedIn omits
/// the timestamp, so it is non-nullable.
@override@JsonKey() final  int createdAt;
@override@JsonKey() final  String suggestedReply;
@override@JsonKey() final  String suggestedReaction;

/// Create a copy of InboxComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxCommentCopyWith<_InboxComment> get copyWith => __$InboxCommentCopyWithImpl<_InboxComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboxCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxComment&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.suggestedReply, suggestedReply) || other.suggestedReply == suggestedReply)&&(identical(other.suggestedReaction, suggestedReaction) || other.suggestedReaction == suggestedReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,suggestedReply,suggestedReaction);

@override
String toString() {
  return 'InboxComment(id: $id, text: $text, createdAt: $createdAt, suggestedReply: $suggestedReply, suggestedReaction: $suggestedReaction)';
}


}

/// @nodoc
abstract mixin class _$InboxCommentCopyWith<$Res> implements $InboxCommentCopyWith<$Res> {
  factory _$InboxCommentCopyWith(_InboxComment value, $Res Function(_InboxComment) _then) = __$InboxCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, int createdAt, String suggestedReply, String suggestedReaction
});




}
/// @nodoc
class __$InboxCommentCopyWithImpl<$Res>
    implements _$InboxCommentCopyWith<$Res> {
  __$InboxCommentCopyWithImpl(this._self, this._then);

  final _InboxComment _self;
  final $Res Function(_InboxComment) _then;

/// Create a copy of InboxComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? suggestedReply = null,Object? suggestedReaction = null,}) {
  return _then(_InboxComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,suggestedReply: null == suggestedReply ? _self.suggestedReply : suggestedReply // ignore: cast_nullable_to_non_nullable
as String,suggestedReaction: null == suggestedReaction ? _self.suggestedReaction : suggestedReaction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReplyOutcome {

 String get targetUrn; bool get success; String? get error;
/// Create a copy of ReplyOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplyOutcomeCopyWith<ReplyOutcome> get copyWith => _$ReplyOutcomeCopyWithImpl<ReplyOutcome>(this as ReplyOutcome, _$identity);

  /// Serializes this ReplyOutcome to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplyOutcome&&(identical(other.targetUrn, targetUrn) || other.targetUrn == targetUrn)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetUrn,success,error);

@override
String toString() {
  return 'ReplyOutcome(targetUrn: $targetUrn, success: $success, error: $error)';
}


}

/// @nodoc
abstract mixin class $ReplyOutcomeCopyWith<$Res>  {
  factory $ReplyOutcomeCopyWith(ReplyOutcome value, $Res Function(ReplyOutcome) _then) = _$ReplyOutcomeCopyWithImpl;
@useResult
$Res call({
 String targetUrn, bool success, String? error
});




}
/// @nodoc
class _$ReplyOutcomeCopyWithImpl<$Res>
    implements $ReplyOutcomeCopyWith<$Res> {
  _$ReplyOutcomeCopyWithImpl(this._self, this._then);

  final ReplyOutcome _self;
  final $Res Function(ReplyOutcome) _then;

/// Create a copy of ReplyOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetUrn = null,Object? success = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
targetUrn: null == targetUrn ? _self.targetUrn : targetUrn // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplyOutcome].
extension ReplyOutcomePatterns on ReplyOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplyOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplyOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplyOutcome value)  $default,){
final _that = this;
switch (_that) {
case _ReplyOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplyOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _ReplyOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String targetUrn,  bool success,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplyOutcome() when $default != null:
return $default(_that.targetUrn,_that.success,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String targetUrn,  bool success,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ReplyOutcome():
return $default(_that.targetUrn,_that.success,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String targetUrn,  bool success,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ReplyOutcome() when $default != null:
return $default(_that.targetUrn,_that.success,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplyOutcome implements ReplyOutcome {
  const _ReplyOutcome({required this.targetUrn, this.success = false, this.error});
  factory _ReplyOutcome.fromJson(Map<String, dynamic> json) => _$ReplyOutcomeFromJson(json);

@override final  String targetUrn;
@override@JsonKey() final  bool success;
@override final  String? error;

/// Create a copy of ReplyOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplyOutcomeCopyWith<_ReplyOutcome> get copyWith => __$ReplyOutcomeCopyWithImpl<_ReplyOutcome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplyOutcomeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplyOutcome&&(identical(other.targetUrn, targetUrn) || other.targetUrn == targetUrn)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetUrn,success,error);

@override
String toString() {
  return 'ReplyOutcome(targetUrn: $targetUrn, success: $success, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ReplyOutcomeCopyWith<$Res> implements $ReplyOutcomeCopyWith<$Res> {
  factory _$ReplyOutcomeCopyWith(_ReplyOutcome value, $Res Function(_ReplyOutcome) _then) = __$ReplyOutcomeCopyWithImpl;
@override @useResult
$Res call({
 String targetUrn, bool success, String? error
});




}
/// @nodoc
class __$ReplyOutcomeCopyWithImpl<$Res>
    implements _$ReplyOutcomeCopyWith<$Res> {
  __$ReplyOutcomeCopyWithImpl(this._self, this._then);

  final _ReplyOutcome _self;
  final $Res Function(_ReplyOutcome) _then;

/// Create a copy of ReplyOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetUrn = null,Object? success = null,Object? error = freezed,}) {
  return _then(_ReplyOutcome(
targetUrn: null == targetUrn ? _self.targetUrn : targetUrn // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
