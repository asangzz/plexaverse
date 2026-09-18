// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostMetricsEntity {

 int get impressions; int get engagements; int get likes; int get comments; int get reposts;
/// Create a copy of PostMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMetricsEntityCopyWith<PostMetricsEntity> get copyWith => _$PostMetricsEntityCopyWithImpl<PostMetricsEntity>(this as PostMetricsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMetricsEntity&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.reposts, reposts) || other.reposts == reposts));
}


@override
int get hashCode => Object.hash(runtimeType,impressions,engagements,likes,comments,reposts);

@override
String toString() {
  return 'PostMetricsEntity(impressions: $impressions, engagements: $engagements, likes: $likes, comments: $comments, reposts: $reposts)';
}


}

/// @nodoc
abstract mixin class $PostMetricsEntityCopyWith<$Res>  {
  factory $PostMetricsEntityCopyWith(PostMetricsEntity value, $Res Function(PostMetricsEntity) _then) = _$PostMetricsEntityCopyWithImpl;
@useResult
$Res call({
 int impressions, int engagements, int likes, int comments, int reposts
});




}
/// @nodoc
class _$PostMetricsEntityCopyWithImpl<$Res>
    implements $PostMetricsEntityCopyWith<$Res> {
  _$PostMetricsEntityCopyWithImpl(this._self, this._then);

  final PostMetricsEntity _self;
  final $Res Function(PostMetricsEntity) _then;

/// Create a copy of PostMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? impressions = null,Object? engagements = null,Object? likes = null,Object? comments = null,Object? reposts = null,}) {
  return _then(_self.copyWith(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostMetricsEntity].
extension PostMetricsEntityPatterns on PostMetricsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMetricsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMetricsEntity value)  $default,){
final _that = this;
switch (_that) {
case _PostMetricsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMetricsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PostMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int impressions,  int engagements,  int likes,  int comments,  int reposts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMetricsEntity() when $default != null:
return $default(_that.impressions,_that.engagements,_that.likes,_that.comments,_that.reposts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int impressions,  int engagements,  int likes,  int comments,  int reposts)  $default,) {final _that = this;
switch (_that) {
case _PostMetricsEntity():
return $default(_that.impressions,_that.engagements,_that.likes,_that.comments,_that.reposts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int impressions,  int engagements,  int likes,  int comments,  int reposts)?  $default,) {final _that = this;
switch (_that) {
case _PostMetricsEntity() when $default != null:
return $default(_that.impressions,_that.engagements,_that.likes,_that.comments,_that.reposts);case _:
  return null;

}
}

}

/// @nodoc


class _PostMetricsEntity extends PostMetricsEntity {
  const _PostMetricsEntity({this.impressions = 0, this.engagements = 0, this.likes = 0, this.comments = 0, this.reposts = 0}): super._();
  

@override@JsonKey() final  int impressions;
@override@JsonKey() final  int engagements;
@override@JsonKey() final  int likes;
@override@JsonKey() final  int comments;
@override@JsonKey() final  int reposts;

/// Create a copy of PostMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMetricsEntityCopyWith<_PostMetricsEntity> get copyWith => __$PostMetricsEntityCopyWithImpl<_PostMetricsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMetricsEntity&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.reposts, reposts) || other.reposts == reposts));
}


@override
int get hashCode => Object.hash(runtimeType,impressions,engagements,likes,comments,reposts);

@override
String toString() {
  return 'PostMetricsEntity(impressions: $impressions, engagements: $engagements, likes: $likes, comments: $comments, reposts: $reposts)';
}


}

/// @nodoc
abstract mixin class _$PostMetricsEntityCopyWith<$Res> implements $PostMetricsEntityCopyWith<$Res> {
  factory _$PostMetricsEntityCopyWith(_PostMetricsEntity value, $Res Function(_PostMetricsEntity) _then) = __$PostMetricsEntityCopyWithImpl;
@override @useResult
$Res call({
 int impressions, int engagements, int likes, int comments, int reposts
});




}
/// @nodoc
class __$PostMetricsEntityCopyWithImpl<$Res>
    implements _$PostMetricsEntityCopyWith<$Res> {
  __$PostMetricsEntityCopyWithImpl(this._self, this._then);

  final _PostMetricsEntity _self;
  final $Res Function(_PostMetricsEntity) _then;

/// Create a copy of PostMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? impressions = null,Object? engagements = null,Object? likes = null,Object? comments = null,Object? reposts = null,}) {
  return _then(_PostMetricsEntity(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$PostEntity {

 int get id; String? get remoteId; String get content; String? get hookLine; PostStatus get status; String get platform; DateTime? get scheduledAt; DateTime? get publishedAt; String? get errorMessage; PostMetricsEntity? get metrics; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostEntityCopyWith<PostEntity> get copyWith => _$PostEntityCopyWithImpl<PostEntity>(this as PostEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.content, content) || other.content == content)&&(identical(other.hookLine, hookLine) || other.hookLine == hookLine)&&(identical(other.status, status) || other.status == status)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,remoteId,content,hookLine,status,platform,scheduledAt,publishedAt,errorMessage,metrics,createdAt,updatedAt);

@override
String toString() {
  return 'PostEntity(id: $id, remoteId: $remoteId, content: $content, hookLine: $hookLine, status: $status, platform: $platform, scheduledAt: $scheduledAt, publishedAt: $publishedAt, errorMessage: $errorMessage, metrics: $metrics, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PostEntityCopyWith<$Res>  {
  factory $PostEntityCopyWith(PostEntity value, $Res Function(PostEntity) _then) = _$PostEntityCopyWithImpl;
@useResult
$Res call({
 int id, String? remoteId, String content, String? hookLine, PostStatus status, String platform, DateTime? scheduledAt, DateTime? publishedAt, String? errorMessage, PostMetricsEntity? metrics, DateTime createdAt, DateTime updatedAt
});


$PostMetricsEntityCopyWith<$Res>? get metrics;

}
/// @nodoc
class _$PostEntityCopyWithImpl<$Res>
    implements $PostEntityCopyWith<$Res> {
  _$PostEntityCopyWithImpl(this._self, this._then);

  final PostEntity _self;
  final $Res Function(PostEntity) _then;

/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? remoteId = freezed,Object? content = null,Object? hookLine = freezed,Object? status = null,Object? platform = null,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? errorMessage = freezed,Object? metrics = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,hookLine: freezed == hookLine ? _self.hookLine : hookLine // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostStatus,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as PostMetricsEntity?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetricsEntityCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $PostMetricsEntityCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostEntity].
extension PostEntityPatterns on PostEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostEntity value)  $default,){
final _that = this;
switch (_that) {
case _PostEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PostEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? remoteId,  String content,  String? hookLine,  PostStatus status,  String platform,  DateTime? scheduledAt,  DateTime? publishedAt,  String? errorMessage,  PostMetricsEntity? metrics,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostEntity() when $default != null:
return $default(_that.id,_that.remoteId,_that.content,_that.hookLine,_that.status,_that.platform,_that.scheduledAt,_that.publishedAt,_that.errorMessage,_that.metrics,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? remoteId,  String content,  String? hookLine,  PostStatus status,  String platform,  DateTime? scheduledAt,  DateTime? publishedAt,  String? errorMessage,  PostMetricsEntity? metrics,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PostEntity():
return $default(_that.id,_that.remoteId,_that.content,_that.hookLine,_that.status,_that.platform,_that.scheduledAt,_that.publishedAt,_that.errorMessage,_that.metrics,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? remoteId,  String content,  String? hookLine,  PostStatus status,  String platform,  DateTime? scheduledAt,  DateTime? publishedAt,  String? errorMessage,  PostMetricsEntity? metrics,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PostEntity() when $default != null:
return $default(_that.id,_that.remoteId,_that.content,_that.hookLine,_that.status,_that.platform,_that.scheduledAt,_that.publishedAt,_that.errorMessage,_that.metrics,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PostEntity extends PostEntity {
  const _PostEntity({required this.id, this.remoteId, required this.content, this.hookLine, this.status = PostStatus.draft, this.platform = 'linkedin', this.scheduledAt, this.publishedAt, this.errorMessage, this.metrics, required this.createdAt, required this.updatedAt}): super._();
  

@override final  int id;
@override final  String? remoteId;
@override final  String content;
@override final  String? hookLine;
@override@JsonKey() final  PostStatus status;
@override@JsonKey() final  String platform;
@override final  DateTime? scheduledAt;
@override final  DateTime? publishedAt;
@override final  String? errorMessage;
@override final  PostMetricsEntity? metrics;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostEntityCopyWith<_PostEntity> get copyWith => __$PostEntityCopyWithImpl<_PostEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.content, content) || other.content == content)&&(identical(other.hookLine, hookLine) || other.hookLine == hookLine)&&(identical(other.status, status) || other.status == status)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,remoteId,content,hookLine,status,platform,scheduledAt,publishedAt,errorMessage,metrics,createdAt,updatedAt);

@override
String toString() {
  return 'PostEntity(id: $id, remoteId: $remoteId, content: $content, hookLine: $hookLine, status: $status, platform: $platform, scheduledAt: $scheduledAt, publishedAt: $publishedAt, errorMessage: $errorMessage, metrics: $metrics, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PostEntityCopyWith<$Res> implements $PostEntityCopyWith<$Res> {
  factory _$PostEntityCopyWith(_PostEntity value, $Res Function(_PostEntity) _then) = __$PostEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String? remoteId, String content, String? hookLine, PostStatus status, String platform, DateTime? scheduledAt, DateTime? publishedAt, String? errorMessage, PostMetricsEntity? metrics, DateTime createdAt, DateTime updatedAt
});


@override $PostMetricsEntityCopyWith<$Res>? get metrics;

}
/// @nodoc
class __$PostEntityCopyWithImpl<$Res>
    implements _$PostEntityCopyWith<$Res> {
  __$PostEntityCopyWithImpl(this._self, this._then);

  final _PostEntity _self;
  final $Res Function(_PostEntity) _then;

/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? remoteId = freezed,Object? content = null,Object? hookLine = freezed,Object? status = null,Object? platform = null,Object? scheduledAt = freezed,Object? publishedAt = freezed,Object? errorMessage = freezed,Object? metrics = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PostEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,remoteId: freezed == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,hookLine: freezed == hookLine ? _self.hookLine : hookLine // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostStatus,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as PostMetricsEntity?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of PostEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetricsEntityCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $PostMetricsEntityCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}

// dart format on
