// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarPost {

 String get id; String? get title; String get content;/// The tiny (~5–15 KB) thumbnail. Decoded but **not rendered yet** — see
/// `CalendarPostTile`: `/posts` does not apply the `data:` guard that
/// `/api/calendar/posts` does, so a base64 blob can still arrive here and
/// `Image.network` cannot load one.
 String? get imageThumbUrl;@JsonKey(unknownEnumValue: CalendarPostStatus.draft) CalendarPostStatus get status; DateTime? get scheduledFor; DateTime? get publishedAt; String? get linkedinUrl;/// Why the publish failed. **Always null on mobile** — `ListedPost` does
/// not select it. The row still renders; it simply cannot explain itself.
 String? get failureReason;/// When it failed. Always null on mobile, same reason as [failureReason].
 DateTime? get failedAt; DateTime? get createdAt;
/// Create a copy of CalendarPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarPostCopyWith<CalendarPost> get copyWith => _$CalendarPostCopyWithImpl<CalendarPost>(this as CalendarPost, _$identity);

  /// Serializes this CalendarPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageThumbUrl, imageThumbUrl) || other.imageThumbUrl == imageThumbUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.failedAt, failedAt) || other.failedAt == failedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,imageThumbUrl,status,scheduledFor,publishedAt,linkedinUrl,failureReason,failedAt,createdAt);

@override
String toString() {
  return 'CalendarPost(id: $id, title: $title, content: $content, imageThumbUrl: $imageThumbUrl, status: $status, scheduledFor: $scheduledFor, publishedAt: $publishedAt, linkedinUrl: $linkedinUrl, failureReason: $failureReason, failedAt: $failedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CalendarPostCopyWith<$Res>  {
  factory $CalendarPostCopyWith(CalendarPost value, $Res Function(CalendarPost) _then) = _$CalendarPostCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String content, String? imageThumbUrl,@JsonKey(unknownEnumValue: CalendarPostStatus.draft) CalendarPostStatus status, DateTime? scheduledFor, DateTime? publishedAt, String? linkedinUrl, String? failureReason, DateTime? failedAt, DateTime? createdAt
});




}
/// @nodoc
class _$CalendarPostCopyWithImpl<$Res>
    implements $CalendarPostCopyWith<$Res> {
  _$CalendarPostCopyWithImpl(this._self, this._then);

  final CalendarPost _self;
  final $Res Function(CalendarPost) _then;

/// Create a copy of CalendarPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? content = null,Object? imageThumbUrl = freezed,Object? status = null,Object? scheduledFor = freezed,Object? publishedAt = freezed,Object? linkedinUrl = freezed,Object? failureReason = freezed,Object? failedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageThumbUrl: freezed == imageThumbUrl ? _self.imageThumbUrl : imageThumbUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarPostStatus,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,failedAt: freezed == failedAt ? _self.failedAt : failedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarPost].
extension CalendarPostPatterns on CalendarPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarPost value)  $default,){
final _that = this;
switch (_that) {
case _CalendarPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarPost value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String content,  String? imageThumbUrl, @JsonKey(unknownEnumValue: CalendarPostStatus.draft)  CalendarPostStatus status,  DateTime? scheduledFor,  DateTime? publishedAt,  String? linkedinUrl,  String? failureReason,  DateTime? failedAt,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.imageThumbUrl,_that.status,_that.scheduledFor,_that.publishedAt,_that.linkedinUrl,_that.failureReason,_that.failedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String content,  String? imageThumbUrl, @JsonKey(unknownEnumValue: CalendarPostStatus.draft)  CalendarPostStatus status,  DateTime? scheduledFor,  DateTime? publishedAt,  String? linkedinUrl,  String? failureReason,  DateTime? failedAt,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CalendarPost():
return $default(_that.id,_that.title,_that.content,_that.imageThumbUrl,_that.status,_that.scheduledFor,_that.publishedAt,_that.linkedinUrl,_that.failureReason,_that.failedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String content,  String? imageThumbUrl, @JsonKey(unknownEnumValue: CalendarPostStatus.draft)  CalendarPostStatus status,  DateTime? scheduledFor,  DateTime? publishedAt,  String? linkedinUrl,  String? failureReason,  DateTime? failedAt,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CalendarPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.imageThumbUrl,_that.status,_that.scheduledFor,_that.publishedAt,_that.linkedinUrl,_that.failureReason,_that.failedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarPost extends CalendarPost {
  const _CalendarPost({required this.id, this.title, this.content = '', this.imageThumbUrl, @JsonKey(unknownEnumValue: CalendarPostStatus.draft) this.status = CalendarPostStatus.draft, this.scheduledFor, this.publishedAt, this.linkedinUrl, this.failureReason, this.failedAt, this.createdAt}): super._();
  factory _CalendarPost.fromJson(Map<String, dynamic> json) => _$CalendarPostFromJson(json);

@override final  String id;
@override final  String? title;
@override@JsonKey() final  String content;
/// The tiny (~5–15 KB) thumbnail. Decoded but **not rendered yet** — see
/// `CalendarPostTile`: `/posts` does not apply the `data:` guard that
/// `/api/calendar/posts` does, so a base64 blob can still arrive here and
/// `Image.network` cannot load one.
@override final  String? imageThumbUrl;
@override@JsonKey(unknownEnumValue: CalendarPostStatus.draft) final  CalendarPostStatus status;
@override final  DateTime? scheduledFor;
@override final  DateTime? publishedAt;
@override final  String? linkedinUrl;
/// Why the publish failed. **Always null on mobile** — `ListedPost` does
/// not select it. The row still renders; it simply cannot explain itself.
@override final  String? failureReason;
/// When it failed. Always null on mobile, same reason as [failureReason].
@override final  DateTime? failedAt;
@override final  DateTime? createdAt;

/// Create a copy of CalendarPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarPostCopyWith<_CalendarPost> get copyWith => __$CalendarPostCopyWithImpl<_CalendarPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageThumbUrl, imageThumbUrl) || other.imageThumbUrl == imageThumbUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.failedAt, failedAt) || other.failedAt == failedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,imageThumbUrl,status,scheduledFor,publishedAt,linkedinUrl,failureReason,failedAt,createdAt);

@override
String toString() {
  return 'CalendarPost(id: $id, title: $title, content: $content, imageThumbUrl: $imageThumbUrl, status: $status, scheduledFor: $scheduledFor, publishedAt: $publishedAt, linkedinUrl: $linkedinUrl, failureReason: $failureReason, failedAt: $failedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CalendarPostCopyWith<$Res> implements $CalendarPostCopyWith<$Res> {
  factory _$CalendarPostCopyWith(_CalendarPost value, $Res Function(_CalendarPost) _then) = __$CalendarPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String content, String? imageThumbUrl,@JsonKey(unknownEnumValue: CalendarPostStatus.draft) CalendarPostStatus status, DateTime? scheduledFor, DateTime? publishedAt, String? linkedinUrl, String? failureReason, DateTime? failedAt, DateTime? createdAt
});




}
/// @nodoc
class __$CalendarPostCopyWithImpl<$Res>
    implements _$CalendarPostCopyWith<$Res> {
  __$CalendarPostCopyWithImpl(this._self, this._then);

  final _CalendarPost _self;
  final $Res Function(_CalendarPost) _then;

/// Create a copy of CalendarPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? content = null,Object? imageThumbUrl = freezed,Object? status = null,Object? scheduledFor = freezed,Object? publishedAt = freezed,Object? linkedinUrl = freezed,Object? failureReason = freezed,Object? failedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_CalendarPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageThumbUrl: freezed == imageThumbUrl ? _self.imageThumbUrl : imageThumbUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CalendarPostStatus,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,failedAt: freezed == failedAt ? _self.failedAt : failedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
