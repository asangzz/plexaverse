// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostMetrics {

 int get impressions; int get comments; int get shares; int get reactions;
/// Create a copy of PostMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostMetricsCopyWith<PostMetrics> get copyWith => _$PostMetricsCopyWithImpl<PostMetrics>(this as PostMetrics, _$identity);

  /// Serializes this PostMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostMetrics&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.reactions, reactions) || other.reactions == reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressions,comments,shares,reactions);

@override
String toString() {
  return 'PostMetrics(impressions: $impressions, comments: $comments, shares: $shares, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class $PostMetricsCopyWith<$Res>  {
  factory $PostMetricsCopyWith(PostMetrics value, $Res Function(PostMetrics) _then) = _$PostMetricsCopyWithImpl;
@useResult
$Res call({
 int impressions, int comments, int shares, int reactions
});




}
/// @nodoc
class _$PostMetricsCopyWithImpl<$Res>
    implements $PostMetricsCopyWith<$Res> {
  _$PostMetricsCopyWithImpl(this._self, this._then);

  final PostMetrics _self;
  final $Res Function(PostMetrics) _then;

/// Create a copy of PostMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? impressions = null,Object? comments = null,Object? shares = null,Object? reactions = null,}) {
  return _then(_self.copyWith(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PostMetrics].
extension PostMetricsPatterns on PostMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostMetrics value)  $default,){
final _that = this;
switch (_that) {
case _PostMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _PostMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int impressions,  int comments,  int shares,  int reactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostMetrics() when $default != null:
return $default(_that.impressions,_that.comments,_that.shares,_that.reactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int impressions,  int comments,  int shares,  int reactions)  $default,) {final _that = this;
switch (_that) {
case _PostMetrics():
return $default(_that.impressions,_that.comments,_that.shares,_that.reactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int impressions,  int comments,  int shares,  int reactions)?  $default,) {final _that = this;
switch (_that) {
case _PostMetrics() when $default != null:
return $default(_that.impressions,_that.comments,_that.shares,_that.reactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostMetrics implements PostMetrics {
  const _PostMetrics({this.impressions = 0, this.comments = 0, this.shares = 0, this.reactions = 0});
  factory _PostMetrics.fromJson(Map<String, dynamic> json) => _$PostMetricsFromJson(json);

@override@JsonKey() final  int impressions;
@override@JsonKey() final  int comments;
@override@JsonKey() final  int shares;
@override@JsonKey() final  int reactions;

/// Create a copy of PostMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostMetricsCopyWith<_PostMetrics> get copyWith => __$PostMetricsCopyWithImpl<_PostMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostMetrics&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.reactions, reactions) || other.reactions == reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressions,comments,shares,reactions);

@override
String toString() {
  return 'PostMetrics(impressions: $impressions, comments: $comments, shares: $shares, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class _$PostMetricsCopyWith<$Res> implements $PostMetricsCopyWith<$Res> {
  factory _$PostMetricsCopyWith(_PostMetrics value, $Res Function(_PostMetrics) _then) = __$PostMetricsCopyWithImpl;
@override @useResult
$Res call({
 int impressions, int comments, int shares, int reactions
});




}
/// @nodoc
class __$PostMetricsCopyWithImpl<$Res>
    implements _$PostMetricsCopyWith<$Res> {
  __$PostMetricsCopyWithImpl(this._self, this._then);

  final _PostMetrics _self;
  final $Res Function(_PostMetrics) _then;

/// Create a copy of PostMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? impressions = null,Object? comments = null,Object? shares = null,Object? reactions = null,}) {
  return _then(_PostMetrics(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PostAuthor {

 String get id; String? get profileName;
/// Create a copy of PostAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostAuthorCopyWith<PostAuthor> get copyWith => _$PostAuthorCopyWithImpl<PostAuthor>(this as PostAuthor, _$identity);

  /// Serializes this PostAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileName);

@override
String toString() {
  return 'PostAuthor(id: $id, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class $PostAuthorCopyWith<$Res>  {
  factory $PostAuthorCopyWith(PostAuthor value, $Res Function(PostAuthor) _then) = _$PostAuthorCopyWithImpl;
@useResult
$Res call({
 String id, String? profileName
});




}
/// @nodoc
class _$PostAuthorCopyWithImpl<$Res>
    implements $PostAuthorCopyWith<$Res> {
  _$PostAuthorCopyWithImpl(this._self, this._then);

  final PostAuthor _self;
  final $Res Function(PostAuthor) _then;

/// Create a copy of PostAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostAuthor].
extension PostAuthorPatterns on PostAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostAuthor value)  $default,){
final _that = this;
switch (_that) {
case _PostAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _PostAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? profileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostAuthor() when $default != null:
return $default(_that.id,_that.profileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? profileName)  $default,) {final _that = this;
switch (_that) {
case _PostAuthor():
return $default(_that.id,_that.profileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? profileName)?  $default,) {final _that = this;
switch (_that) {
case _PostAuthor() when $default != null:
return $default(_that.id,_that.profileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostAuthor implements PostAuthor {
  const _PostAuthor({required this.id, this.profileName});
  factory _PostAuthor.fromJson(Map<String, dynamic> json) => _$PostAuthorFromJson(json);

@override final  String id;
@override final  String? profileName;

/// Create a copy of PostAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostAuthorCopyWith<_PostAuthor> get copyWith => __$PostAuthorCopyWithImpl<_PostAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.profileName, profileName) || other.profileName == profileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileName);

@override
String toString() {
  return 'PostAuthor(id: $id, profileName: $profileName)';
}


}

/// @nodoc
abstract mixin class _$PostAuthorCopyWith<$Res> implements $PostAuthorCopyWith<$Res> {
  factory _$PostAuthorCopyWith(_PostAuthor value, $Res Function(_PostAuthor) _then) = __$PostAuthorCopyWithImpl;
@override @useResult
$Res call({
 String id, String? profileName
});




}
/// @nodoc
class __$PostAuthorCopyWithImpl<$Res>
    implements _$PostAuthorCopyWith<$Res> {
  __$PostAuthorCopyWithImpl(this._self, this._then);

  final _PostAuthor _self;
  final $Res Function(_PostAuthor) _then;

/// Create a copy of PostAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileName = freezed,}) {
  return _then(_PostAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileName: freezed == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LibraryPost {

 String get id; String? get title; String get content; String? get imageUrl;/// The ~5–15 KB thumbnail the upload pipeline writes. Prefer it in a list;
/// a library of 50 rows must not pull 50 LinkedIn-sized artifacts.
 String? get imageThumbUrl; List<String> get imageUrls;@JsonKey(unknownEnumValue: PostLibraryStatus.draft) PostLibraryStatus get status; String? get linkedinUrl; DateTime get createdAt; DateTime? get updatedAt; DateTime? get publishedAt; DateTime? get scheduledFor; PostMetrics? get metrics;/// Detail payload only.
 PostAuthor? get account;
/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryPostCopyWith<LibraryPost> get copyWith => _$LibraryPostCopyWithImpl<LibraryPost>(this as LibraryPost, _$identity);

  /// Serializes this LibraryPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageThumbUrl, imageThumbUrl) || other.imageThumbUrl == imageThumbUrl)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,imageUrl,imageThumbUrl,const DeepCollectionEquality().hash(imageUrls),status,linkedinUrl,createdAt,updatedAt,publishedAt,scheduledFor,metrics,account);

@override
String toString() {
  return 'LibraryPost(id: $id, title: $title, content: $content, imageUrl: $imageUrl, imageThumbUrl: $imageThumbUrl, imageUrls: $imageUrls, status: $status, linkedinUrl: $linkedinUrl, createdAt: $createdAt, updatedAt: $updatedAt, publishedAt: $publishedAt, scheduledFor: $scheduledFor, metrics: $metrics, account: $account)';
}


}

/// @nodoc
abstract mixin class $LibraryPostCopyWith<$Res>  {
  factory $LibraryPostCopyWith(LibraryPost value, $Res Function(LibraryPost) _then) = _$LibraryPostCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String content, String? imageUrl, String? imageThumbUrl, List<String> imageUrls,@JsonKey(unknownEnumValue: PostLibraryStatus.draft) PostLibraryStatus status, String? linkedinUrl, DateTime createdAt, DateTime? updatedAt, DateTime? publishedAt, DateTime? scheduledFor, PostMetrics? metrics, PostAuthor? account
});


$PostMetricsCopyWith<$Res>? get metrics;$PostAuthorCopyWith<$Res>? get account;

}
/// @nodoc
class _$LibraryPostCopyWithImpl<$Res>
    implements $LibraryPostCopyWith<$Res> {
  _$LibraryPostCopyWithImpl(this._self, this._then);

  final LibraryPost _self;
  final $Res Function(LibraryPost) _then;

/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? content = null,Object? imageUrl = freezed,Object? imageThumbUrl = freezed,Object? imageUrls = null,Object? status = null,Object? linkedinUrl = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? publishedAt = freezed,Object? scheduledFor = freezed,Object? metrics = freezed,Object? account = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageThumbUrl: freezed == imageThumbUrl ? _self.imageThumbUrl : imageThumbUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostLibraryStatus,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as PostMetrics?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as PostAuthor?,
  ));
}
/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetricsCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $PostMetricsCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostAuthorCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $PostAuthorCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}


/// Adds pattern-matching-related methods to [LibraryPost].
extension LibraryPostPatterns on LibraryPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryPost value)  $default,){
final _that = this;
switch (_that) {
case _LibraryPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryPost value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String content,  String? imageUrl,  String? imageThumbUrl,  List<String> imageUrls, @JsonKey(unknownEnumValue: PostLibraryStatus.draft)  PostLibraryStatus status,  String? linkedinUrl,  DateTime createdAt,  DateTime? updatedAt,  DateTime? publishedAt,  DateTime? scheduledFor,  PostMetrics? metrics,  PostAuthor? account)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.imageUrl,_that.imageThumbUrl,_that.imageUrls,_that.status,_that.linkedinUrl,_that.createdAt,_that.updatedAt,_that.publishedAt,_that.scheduledFor,_that.metrics,_that.account);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String content,  String? imageUrl,  String? imageThumbUrl,  List<String> imageUrls, @JsonKey(unknownEnumValue: PostLibraryStatus.draft)  PostLibraryStatus status,  String? linkedinUrl,  DateTime createdAt,  DateTime? updatedAt,  DateTime? publishedAt,  DateTime? scheduledFor,  PostMetrics? metrics,  PostAuthor? account)  $default,) {final _that = this;
switch (_that) {
case _LibraryPost():
return $default(_that.id,_that.title,_that.content,_that.imageUrl,_that.imageThumbUrl,_that.imageUrls,_that.status,_that.linkedinUrl,_that.createdAt,_that.updatedAt,_that.publishedAt,_that.scheduledFor,_that.metrics,_that.account);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String content,  String? imageUrl,  String? imageThumbUrl,  List<String> imageUrls, @JsonKey(unknownEnumValue: PostLibraryStatus.draft)  PostLibraryStatus status,  String? linkedinUrl,  DateTime createdAt,  DateTime? updatedAt,  DateTime? publishedAt,  DateTime? scheduledFor,  PostMetrics? metrics,  PostAuthor? account)?  $default,) {final _that = this;
switch (_that) {
case _LibraryPost() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.imageUrl,_that.imageThumbUrl,_that.imageUrls,_that.status,_that.linkedinUrl,_that.createdAt,_that.updatedAt,_that.publishedAt,_that.scheduledFor,_that.metrics,_that.account);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryPost extends LibraryPost {
  const _LibraryPost({required this.id, this.title, this.content = '', this.imageUrl, this.imageThumbUrl, final  List<String> imageUrls = const <String>[], @JsonKey(unknownEnumValue: PostLibraryStatus.draft) this.status = PostLibraryStatus.draft, this.linkedinUrl, required this.createdAt, this.updatedAt, this.publishedAt, this.scheduledFor, this.metrics, this.account}): _imageUrls = imageUrls,super._();
  factory _LibraryPost.fromJson(Map<String, dynamic> json) => _$LibraryPostFromJson(json);

@override final  String id;
@override final  String? title;
@override@JsonKey() final  String content;
@override final  String? imageUrl;
/// The ~5–15 KB thumbnail the upload pipeline writes. Prefer it in a list;
/// a library of 50 rows must not pull 50 LinkedIn-sized artifacts.
@override final  String? imageThumbUrl;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey(unknownEnumValue: PostLibraryStatus.draft) final  PostLibraryStatus status;
@override final  String? linkedinUrl;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? publishedAt;
@override final  DateTime? scheduledFor;
@override final  PostMetrics? metrics;
/// Detail payload only.
@override final  PostAuthor? account;

/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryPostCopyWith<_LibraryPost> get copyWith => __$LibraryPostCopyWithImpl<_LibraryPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryPost&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.imageThumbUrl, imageThumbUrl) || other.imageThumbUrl == imageThumbUrl)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.metrics, metrics) || other.metrics == metrics)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,imageUrl,imageThumbUrl,const DeepCollectionEquality().hash(_imageUrls),status,linkedinUrl,createdAt,updatedAt,publishedAt,scheduledFor,metrics,account);

@override
String toString() {
  return 'LibraryPost(id: $id, title: $title, content: $content, imageUrl: $imageUrl, imageThumbUrl: $imageThumbUrl, imageUrls: $imageUrls, status: $status, linkedinUrl: $linkedinUrl, createdAt: $createdAt, updatedAt: $updatedAt, publishedAt: $publishedAt, scheduledFor: $scheduledFor, metrics: $metrics, account: $account)';
}


}

/// @nodoc
abstract mixin class _$LibraryPostCopyWith<$Res> implements $LibraryPostCopyWith<$Res> {
  factory _$LibraryPostCopyWith(_LibraryPost value, $Res Function(_LibraryPost) _then) = __$LibraryPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String content, String? imageUrl, String? imageThumbUrl, List<String> imageUrls,@JsonKey(unknownEnumValue: PostLibraryStatus.draft) PostLibraryStatus status, String? linkedinUrl, DateTime createdAt, DateTime? updatedAt, DateTime? publishedAt, DateTime? scheduledFor, PostMetrics? metrics, PostAuthor? account
});


@override $PostMetricsCopyWith<$Res>? get metrics;@override $PostAuthorCopyWith<$Res>? get account;

}
/// @nodoc
class __$LibraryPostCopyWithImpl<$Res>
    implements _$LibraryPostCopyWith<$Res> {
  __$LibraryPostCopyWithImpl(this._self, this._then);

  final _LibraryPost _self;
  final $Res Function(_LibraryPost) _then;

/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? content = null,Object? imageUrl = freezed,Object? imageThumbUrl = freezed,Object? imageUrls = null,Object? status = null,Object? linkedinUrl = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? publishedAt = freezed,Object? scheduledFor = freezed,Object? metrics = freezed,Object? account = freezed,}) {
  return _then(_LibraryPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageThumbUrl: freezed == imageThumbUrl ? _self.imageThumbUrl : imageThumbUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PostLibraryStatus,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as PostMetrics?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as PostAuthor?,
  ));
}

/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostMetricsCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $PostMetricsCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}/// Create a copy of LibraryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostAuthorCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $PostAuthorCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}

/// @nodoc
mixin _$PostPage {

 List<LibraryPost> get posts; String? get nextCursor; bool get hasMore;
/// Create a copy of PostPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostPageCopyWith<PostPage> get copyWith => _$PostPageCopyWithImpl<PostPage>(this as PostPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostPage&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),nextCursor,hasMore);

@override
String toString() {
  return 'PostPage(posts: $posts, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $PostPageCopyWith<$Res>  {
  factory $PostPageCopyWith(PostPage value, $Res Function(PostPage) _then) = _$PostPageCopyWithImpl;
@useResult
$Res call({
 List<LibraryPost> posts, String? nextCursor, bool hasMore
});




}
/// @nodoc
class _$PostPageCopyWithImpl<$Res>
    implements $PostPageCopyWith<$Res> {
  _$PostPageCopyWithImpl(this._self, this._then);

  final PostPage _self;
  final $Res Function(PostPage) _then;

/// Create a copy of PostPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<LibraryPost>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PostPage].
extension PostPagePatterns on PostPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostPage value)  $default,){
final _that = this;
switch (_that) {
case _PostPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostPage value)?  $default,){
final _that = this;
switch (_that) {
case _PostPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostPage() when $default != null:
return $default(_that.posts,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _PostPage():
return $default(_that.posts,_that.nextCursor,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _PostPage() when $default != null:
return $default(_that.posts,_that.nextCursor,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _PostPage implements PostPage {
  const _PostPage({final  List<LibraryPost> posts = const <LibraryPost>[], this.nextCursor, this.hasMore = false}): _posts = posts;
  

 final  List<LibraryPost> _posts;
@override@JsonKey() List<LibraryPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;

/// Create a copy of PostPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostPageCopyWith<_PostPage> get copyWith => __$PostPageCopyWithImpl<_PostPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostPage&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),nextCursor,hasMore);

@override
String toString() {
  return 'PostPage(posts: $posts, nextCursor: $nextCursor, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$PostPageCopyWith<$Res> implements $PostPageCopyWith<$Res> {
  factory _$PostPageCopyWith(_PostPage value, $Res Function(_PostPage) _then) = __$PostPageCopyWithImpl;
@override @useResult
$Res call({
 List<LibraryPost> posts, String? nextCursor, bool hasMore
});




}
/// @nodoc
class __$PostPageCopyWithImpl<$Res>
    implements _$PostPageCopyWith<$Res> {
  __$PostPageCopyWithImpl(this._self, this._then);

  final _PostPage _self;
  final $Res Function(_PostPage) _then;

/// Create a copy of PostPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? nextCursor = freezed,Object? hasMore = null,}) {
  return _then(_PostPage(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<LibraryPost>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
