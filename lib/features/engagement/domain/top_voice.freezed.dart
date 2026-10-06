// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'top_voice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopVoice {

/// The `TopVoiceShown` row id. This is what gets stamped, and what Open
/// Plexa sends as `topVoiceId` — the two surfaces must agree on it or they
/// disagree about the same five posts.
 String get shownId;/// The `TopVoicePost` id. Not used for anything the client decides; kept
/// because the wire carries it and dropping a field silently is how a
/// model and its server drift.
 String get postId; String get postUrl; String get authorName; String get authorHandle;/// One of the forty ids in `core/engagement/top_voice_categories.dart`.
 String get category; String get postContent;/// The post's opening line, when the import captured one. Rendered as the
/// headline above the body.
 String? get firstLine;/// ISO 8601. Rendered as LinkedIn's own shorthand — "2h", "3d".
 String get postedAt;/// Null when the batch generated but this one's comment did not come back.
/// The row is still the user's for the day — losing the pick would hand
/// them the same post tomorrow and charge for it twice — so the card has
/// to render without a draft.
 String? get comment;/// ISO 8601 when the user opened this to comment. Null means outstanding.
 String? get actedAt;
/// Create a copy of TopVoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopVoiceCopyWith<TopVoice> get copyWith => _$TopVoiceCopyWithImpl<TopVoice>(this as TopVoice, _$identity);

  /// Serializes this TopVoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopVoice&&(identical(other.shownId, shownId) || other.shownId == shownId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorHandle, authorHandle) || other.authorHandle == authorHandle)&&(identical(other.category, category) || other.category == category)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.actedAt, actedAt) || other.actedAt == actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shownId,postId,postUrl,authorName,authorHandle,category,postContent,firstLine,postedAt,comment,actedAt);

@override
String toString() {
  return 'TopVoice(shownId: $shownId, postId: $postId, postUrl: $postUrl, authorName: $authorName, authorHandle: $authorHandle, category: $category, postContent: $postContent, firstLine: $firstLine, postedAt: $postedAt, comment: $comment, actedAt: $actedAt)';
}


}

/// @nodoc
abstract mixin class $TopVoiceCopyWith<$Res>  {
  factory $TopVoiceCopyWith(TopVoice value, $Res Function(TopVoice) _then) = _$TopVoiceCopyWithImpl;
@useResult
$Res call({
 String shownId, String postId, String postUrl, String authorName, String authorHandle, String category, String postContent, String? firstLine, String postedAt, String? comment, String? actedAt
});




}
/// @nodoc
class _$TopVoiceCopyWithImpl<$Res>
    implements $TopVoiceCopyWith<$Res> {
  _$TopVoiceCopyWithImpl(this._self, this._then);

  final TopVoice _self;
  final $Res Function(TopVoice) _then;

/// Create a copy of TopVoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shownId = null,Object? postId = null,Object? postUrl = null,Object? authorName = null,Object? authorHandle = null,Object? category = null,Object? postContent = null,Object? firstLine = freezed,Object? postedAt = null,Object? comment = freezed,Object? actedAt = freezed,}) {
  return _then(_self.copyWith(
shownId: null == shownId ? _self.shownId : shownId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorHandle: null == authorHandle ? _self.authorHandle : authorHandle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,postContent: null == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String,firstLine: freezed == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String?,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TopVoice].
extension TopVoicePatterns on TopVoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopVoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopVoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopVoice value)  $default,){
final _that = this;
switch (_that) {
case _TopVoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopVoice value)?  $default,){
final _that = this;
switch (_that) {
case _TopVoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shownId,  String postId,  String postUrl,  String authorName,  String authorHandle,  String category,  String postContent,  String? firstLine,  String postedAt,  String? comment,  String? actedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopVoice() when $default != null:
return $default(_that.shownId,_that.postId,_that.postUrl,_that.authorName,_that.authorHandle,_that.category,_that.postContent,_that.firstLine,_that.postedAt,_that.comment,_that.actedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shownId,  String postId,  String postUrl,  String authorName,  String authorHandle,  String category,  String postContent,  String? firstLine,  String postedAt,  String? comment,  String? actedAt)  $default,) {final _that = this;
switch (_that) {
case _TopVoice():
return $default(_that.shownId,_that.postId,_that.postUrl,_that.authorName,_that.authorHandle,_that.category,_that.postContent,_that.firstLine,_that.postedAt,_that.comment,_that.actedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shownId,  String postId,  String postUrl,  String authorName,  String authorHandle,  String category,  String postContent,  String? firstLine,  String postedAt,  String? comment,  String? actedAt)?  $default,) {final _that = this;
switch (_that) {
case _TopVoice() when $default != null:
return $default(_that.shownId,_that.postId,_that.postUrl,_that.authorName,_that.authorHandle,_that.category,_that.postContent,_that.firstLine,_that.postedAt,_that.comment,_that.actedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopVoice extends TopVoice {
  const _TopVoice({this.shownId = '', this.postId = '', this.postUrl = '', this.authorName = '', this.authorHandle = '', this.category = '', this.postContent = '', this.firstLine, this.postedAt = '', this.comment, this.actedAt}): super._();
  factory _TopVoice.fromJson(Map<String, dynamic> json) => _$TopVoiceFromJson(json);

/// The `TopVoiceShown` row id. This is what gets stamped, and what Open
/// Plexa sends as `topVoiceId` — the two surfaces must agree on it or they
/// disagree about the same five posts.
@override@JsonKey() final  String shownId;
/// The `TopVoicePost` id. Not used for anything the client decides; kept
/// because the wire carries it and dropping a field silently is how a
/// model and its server drift.
@override@JsonKey() final  String postId;
@override@JsonKey() final  String postUrl;
@override@JsonKey() final  String authorName;
@override@JsonKey() final  String authorHandle;
/// One of the forty ids in `core/engagement/top_voice_categories.dart`.
@override@JsonKey() final  String category;
@override@JsonKey() final  String postContent;
/// The post's opening line, when the import captured one. Rendered as the
/// headline above the body.
@override final  String? firstLine;
/// ISO 8601. Rendered as LinkedIn's own shorthand — "2h", "3d".
@override@JsonKey() final  String postedAt;
/// Null when the batch generated but this one's comment did not come back.
/// The row is still the user's for the day — losing the pick would hand
/// them the same post tomorrow and charge for it twice — so the card has
/// to render without a draft.
@override final  String? comment;
/// ISO 8601 when the user opened this to comment. Null means outstanding.
@override final  String? actedAt;

/// Create a copy of TopVoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopVoiceCopyWith<_TopVoice> get copyWith => __$TopVoiceCopyWithImpl<_TopVoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopVoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopVoice&&(identical(other.shownId, shownId) || other.shownId == shownId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorHandle, authorHandle) || other.authorHandle == authorHandle)&&(identical(other.category, category) || other.category == category)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.actedAt, actedAt) || other.actedAt == actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shownId,postId,postUrl,authorName,authorHandle,category,postContent,firstLine,postedAt,comment,actedAt);

@override
String toString() {
  return 'TopVoice(shownId: $shownId, postId: $postId, postUrl: $postUrl, authorName: $authorName, authorHandle: $authorHandle, category: $category, postContent: $postContent, firstLine: $firstLine, postedAt: $postedAt, comment: $comment, actedAt: $actedAt)';
}


}

/// @nodoc
abstract mixin class _$TopVoiceCopyWith<$Res> implements $TopVoiceCopyWith<$Res> {
  factory _$TopVoiceCopyWith(_TopVoice value, $Res Function(_TopVoice) _then) = __$TopVoiceCopyWithImpl;
@override @useResult
$Res call({
 String shownId, String postId, String postUrl, String authorName, String authorHandle, String category, String postContent, String? firstLine, String postedAt, String? comment, String? actedAt
});




}
/// @nodoc
class __$TopVoiceCopyWithImpl<$Res>
    implements _$TopVoiceCopyWith<$Res> {
  __$TopVoiceCopyWithImpl(this._self, this._then);

  final _TopVoice _self;
  final $Res Function(_TopVoice) _then;

/// Create a copy of TopVoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shownId = null,Object? postId = null,Object? postUrl = null,Object? authorName = null,Object? authorHandle = null,Object? category = null,Object? postContent = null,Object? firstLine = freezed,Object? postedAt = null,Object? comment = freezed,Object? actedAt = freezed,}) {
  return _then(_TopVoice(
shownId: null == shownId ? _self.shownId : shownId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorHandle: null == authorHandle ? _self.authorHandle : authorHandle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,postContent: null == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String,firstLine: freezed == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String?,postedAt: null == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TopVoiceDay {

 List<TopVoice> get posts;/// False only when the user has chosen no subjects at all.
 bool get hasCategories;
/// Create a copy of TopVoiceDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopVoiceDayCopyWith<TopVoiceDay> get copyWith => _$TopVoiceDayCopyWithImpl<TopVoiceDay>(this as TopVoiceDay, _$identity);

  /// Serializes this TopVoiceDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopVoiceDay&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.hasCategories, hasCategories) || other.hasCategories == hasCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),hasCategories);

@override
String toString() {
  return 'TopVoiceDay(posts: $posts, hasCategories: $hasCategories)';
}


}

/// @nodoc
abstract mixin class $TopVoiceDayCopyWith<$Res>  {
  factory $TopVoiceDayCopyWith(TopVoiceDay value, $Res Function(TopVoiceDay) _then) = _$TopVoiceDayCopyWithImpl;
@useResult
$Res call({
 List<TopVoice> posts, bool hasCategories
});




}
/// @nodoc
class _$TopVoiceDayCopyWithImpl<$Res>
    implements $TopVoiceDayCopyWith<$Res> {
  _$TopVoiceDayCopyWithImpl(this._self, this._then);

  final TopVoiceDay _self;
  final $Res Function(TopVoiceDay) _then;

/// Create a copy of TopVoiceDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? hasCategories = null,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<TopVoice>,hasCategories: null == hasCategories ? _self.hasCategories : hasCategories // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TopVoiceDay].
extension TopVoiceDayPatterns on TopVoiceDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopVoiceDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopVoiceDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopVoiceDay value)  $default,){
final _that = this;
switch (_that) {
case _TopVoiceDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopVoiceDay value)?  $default,){
final _that = this;
switch (_that) {
case _TopVoiceDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TopVoice> posts,  bool hasCategories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopVoiceDay() when $default != null:
return $default(_that.posts,_that.hasCategories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TopVoice> posts,  bool hasCategories)  $default,) {final _that = this;
switch (_that) {
case _TopVoiceDay():
return $default(_that.posts,_that.hasCategories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TopVoice> posts,  bool hasCategories)?  $default,) {final _that = this;
switch (_that) {
case _TopVoiceDay() when $default != null:
return $default(_that.posts,_that.hasCategories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopVoiceDay extends TopVoiceDay {
  const _TopVoiceDay({final  List<TopVoice> posts = const <TopVoice>[], this.hasCategories = true}): _posts = posts,super._();
  factory _TopVoiceDay.fromJson(Map<String, dynamic> json) => _$TopVoiceDayFromJson(json);

 final  List<TopVoice> _posts;
@override@JsonKey() List<TopVoice> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

/// False only when the user has chosen no subjects at all.
@override@JsonKey() final  bool hasCategories;

/// Create a copy of TopVoiceDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopVoiceDayCopyWith<_TopVoiceDay> get copyWith => __$TopVoiceDayCopyWithImpl<_TopVoiceDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopVoiceDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopVoiceDay&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.hasCategories, hasCategories) || other.hasCategories == hasCategories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),hasCategories);

@override
String toString() {
  return 'TopVoiceDay(posts: $posts, hasCategories: $hasCategories)';
}


}

/// @nodoc
abstract mixin class _$TopVoiceDayCopyWith<$Res> implements $TopVoiceDayCopyWith<$Res> {
  factory _$TopVoiceDayCopyWith(_TopVoiceDay value, $Res Function(_TopVoiceDay) _then) = __$TopVoiceDayCopyWithImpl;
@override @useResult
$Res call({
 List<TopVoice> posts, bool hasCategories
});




}
/// @nodoc
class __$TopVoiceDayCopyWithImpl<$Res>
    implements _$TopVoiceDayCopyWith<$Res> {
  __$TopVoiceDayCopyWithImpl(this._self, this._then);

  final _TopVoiceDay _self;
  final $Res Function(_TopVoiceDay) _then;

/// Create a copy of TopVoiceDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? hasCategories = null,}) {
  return _then(_TopVoiceDay(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<TopVoice>,hasCategories: null == hasCategories ? _self.hasCategories : hasCategories // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
