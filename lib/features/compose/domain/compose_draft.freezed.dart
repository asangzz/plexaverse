// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComposeImage {

 String? get dataUri; String? get url;/// Drives the "AI generated" badge and whether Regenerate is offered.
 bool get aiGenerated;
/// Create a copy of ComposeImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeImageCopyWith<ComposeImage> get copyWith => _$ComposeImageCopyWithImpl<ComposeImage>(this as ComposeImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeImage&&(identical(other.dataUri, dataUri) || other.dataUri == dataUri)&&(identical(other.url, url) || other.url == url)&&(identical(other.aiGenerated, aiGenerated) || other.aiGenerated == aiGenerated));
}


@override
int get hashCode => Object.hash(runtimeType,dataUri,url,aiGenerated);

@override
String toString() {
  return 'ComposeImage(dataUri: $dataUri, url: $url, aiGenerated: $aiGenerated)';
}


}

/// @nodoc
abstract mixin class $ComposeImageCopyWith<$Res>  {
  factory $ComposeImageCopyWith(ComposeImage value, $Res Function(ComposeImage) _then) = _$ComposeImageCopyWithImpl;
@useResult
$Res call({
 String? dataUri, String? url, bool aiGenerated
});




}
/// @nodoc
class _$ComposeImageCopyWithImpl<$Res>
    implements $ComposeImageCopyWith<$Res> {
  _$ComposeImageCopyWithImpl(this._self, this._then);

  final ComposeImage _self;
  final $Res Function(ComposeImage) _then;

/// Create a copy of ComposeImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataUri = freezed,Object? url = freezed,Object? aiGenerated = null,}) {
  return _then(_self.copyWith(
dataUri: freezed == dataUri ? _self.dataUri : dataUri // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,aiGenerated: null == aiGenerated ? _self.aiGenerated : aiGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ComposeImage].
extension ComposeImagePatterns on ComposeImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComposeImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComposeImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComposeImage value)  $default,){
final _that = this;
switch (_that) {
case _ComposeImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComposeImage value)?  $default,){
final _that = this;
switch (_that) {
case _ComposeImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? dataUri,  String? url,  bool aiGenerated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComposeImage() when $default != null:
return $default(_that.dataUri,_that.url,_that.aiGenerated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? dataUri,  String? url,  bool aiGenerated)  $default,) {final _that = this;
switch (_that) {
case _ComposeImage():
return $default(_that.dataUri,_that.url,_that.aiGenerated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? dataUri,  String? url,  bool aiGenerated)?  $default,) {final _that = this;
switch (_that) {
case _ComposeImage() when $default != null:
return $default(_that.dataUri,_that.url,_that.aiGenerated);case _:
  return null;

}
}

}

/// @nodoc


class _ComposeImage extends ComposeImage {
  const _ComposeImage({this.dataUri, this.url, this.aiGenerated = true}): super._();
  

@override final  String? dataUri;
@override final  String? url;
/// Drives the "AI generated" badge and whether Regenerate is offered.
@override@JsonKey() final  bool aiGenerated;

/// Create a copy of ComposeImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComposeImageCopyWith<_ComposeImage> get copyWith => __$ComposeImageCopyWithImpl<_ComposeImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComposeImage&&(identical(other.dataUri, dataUri) || other.dataUri == dataUri)&&(identical(other.url, url) || other.url == url)&&(identical(other.aiGenerated, aiGenerated) || other.aiGenerated == aiGenerated));
}


@override
int get hashCode => Object.hash(runtimeType,dataUri,url,aiGenerated);

@override
String toString() {
  return 'ComposeImage(dataUri: $dataUri, url: $url, aiGenerated: $aiGenerated)';
}


}

/// @nodoc
abstract mixin class _$ComposeImageCopyWith<$Res> implements $ComposeImageCopyWith<$Res> {
  factory _$ComposeImageCopyWith(_ComposeImage value, $Res Function(_ComposeImage) _then) = __$ComposeImageCopyWithImpl;
@override @useResult
$Res call({
 String? dataUri, String? url, bool aiGenerated
});




}
/// @nodoc
class __$ComposeImageCopyWithImpl<$Res>
    implements _$ComposeImageCopyWith<$Res> {
  __$ComposeImageCopyWithImpl(this._self, this._then);

  final _ComposeImage _self;
  final $Res Function(_ComposeImage) _then;

/// Create a copy of ComposeImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataUri = freezed,Object? url = freezed,Object? aiGenerated = null,}) {
  return _then(_ComposeImage(
dataUri: freezed == dataUri ? _self.dataUri : dataUri // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,aiGenerated: null == aiGenerated ? _self.aiGenerated : aiGenerated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PosterPrompt {

 String get topic; String get content; String? get posterTitle; String? get userName; String? get profileImageUrl; String? get category;
/// Create a copy of PosterPrompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosterPromptCopyWith<PosterPrompt> get copyWith => _$PosterPromptCopyWithImpl<PosterPrompt>(this as PosterPrompt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosterPrompt&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.content, content) || other.content == content)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,topic,content,posterTitle,userName,profileImageUrl,category);

@override
String toString() {
  return 'PosterPrompt(topic: $topic, content: $content, posterTitle: $posterTitle, userName: $userName, profileImageUrl: $profileImageUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class $PosterPromptCopyWith<$Res>  {
  factory $PosterPromptCopyWith(PosterPrompt value, $Res Function(PosterPrompt) _then) = _$PosterPromptCopyWithImpl;
@useResult
$Res call({
 String topic, String content, String? posterTitle, String? userName, String? profileImageUrl, String? category
});




}
/// @nodoc
class _$PosterPromptCopyWithImpl<$Res>
    implements $PosterPromptCopyWith<$Res> {
  _$PosterPromptCopyWithImpl(this._self, this._then);

  final PosterPrompt _self;
  final $Res Function(PosterPrompt) _then;

/// Create a copy of PosterPrompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? content = null,Object? posterTitle = freezed,Object? userName = freezed,Object? profileImageUrl = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,posterTitle: freezed == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PosterPrompt].
extension PosterPromptPatterns on PosterPrompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosterPrompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosterPrompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosterPrompt value)  $default,){
final _that = this;
switch (_that) {
case _PosterPrompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosterPrompt value)?  $default,){
final _that = this;
switch (_that) {
case _PosterPrompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  String content,  String? posterTitle,  String? userName,  String? profileImageUrl,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosterPrompt() when $default != null:
return $default(_that.topic,_that.content,_that.posterTitle,_that.userName,_that.profileImageUrl,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  String content,  String? posterTitle,  String? userName,  String? profileImageUrl,  String? category)  $default,) {final _that = this;
switch (_that) {
case _PosterPrompt():
return $default(_that.topic,_that.content,_that.posterTitle,_that.userName,_that.profileImageUrl,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  String content,  String? posterTitle,  String? userName,  String? profileImageUrl,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _PosterPrompt() when $default != null:
return $default(_that.topic,_that.content,_that.posterTitle,_that.userName,_that.profileImageUrl,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _PosterPrompt implements PosterPrompt {
  const _PosterPrompt({this.topic = '', this.content = '', this.posterTitle, this.userName, this.profileImageUrl, this.category});
  

@override@JsonKey() final  String topic;
@override@JsonKey() final  String content;
@override final  String? posterTitle;
@override final  String? userName;
@override final  String? profileImageUrl;
@override final  String? category;

/// Create a copy of PosterPrompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosterPromptCopyWith<_PosterPrompt> get copyWith => __$PosterPromptCopyWithImpl<_PosterPrompt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosterPrompt&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.content, content) || other.content == content)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,topic,content,posterTitle,userName,profileImageUrl,category);

@override
String toString() {
  return 'PosterPrompt(topic: $topic, content: $content, posterTitle: $posterTitle, userName: $userName, profileImageUrl: $profileImageUrl, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PosterPromptCopyWith<$Res> implements $PosterPromptCopyWith<$Res> {
  factory _$PosterPromptCopyWith(_PosterPrompt value, $Res Function(_PosterPrompt) _then) = __$PosterPromptCopyWithImpl;
@override @useResult
$Res call({
 String topic, String content, String? posterTitle, String? userName, String? profileImageUrl, String? category
});




}
/// @nodoc
class __$PosterPromptCopyWithImpl<$Res>
    implements _$PosterPromptCopyWith<$Res> {
  __$PosterPromptCopyWithImpl(this._self, this._then);

  final _PosterPrompt _self;
  final $Res Function(_PosterPrompt) _then;

/// Create a copy of PosterPrompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? content = null,Object? posterTitle = freezed,Object? userName = freezed,Object? profileImageUrl = freezed,Object? category = freezed,}) {
  return _then(_PosterPrompt(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,posterTitle: freezed == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ComposeDraft {

 String get title; String get content; ComposeImage? get image;/// "Schedule for later". Off means publish through the normal approval
/// path as soon as it is approved.
 bool get scheduled;/// The day, at midnight. Null until the user picks one — a scheduled post
/// with no date is not submittable, which is why [scheduledFor] returns
/// null rather than guessing today.
 DateTime? get date;/// 'HH:mm', 24-hour. The web's default is 09:00 and so is this.
 String get time;/// Which LinkedIn connection publishes this. Null falls back to the
/// context's active account at save time.
 String? get accountId;/// Reused verbatim by Regenerate — see [PosterPrompt].
 PosterPrompt? get lastPosterPrompt;
/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComposeDraftCopyWith<ComposeDraft> get copyWith => _$ComposeDraftCopyWithImpl<ComposeDraft>(this as ComposeDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComposeDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.lastPosterPrompt, lastPosterPrompt) || other.lastPosterPrompt == lastPosterPrompt));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,image,scheduled,date,time,accountId,lastPosterPrompt);

@override
String toString() {
  return 'ComposeDraft(title: $title, content: $content, image: $image, scheduled: $scheduled, date: $date, time: $time, accountId: $accountId, lastPosterPrompt: $lastPosterPrompt)';
}


}

/// @nodoc
abstract mixin class $ComposeDraftCopyWith<$Res>  {
  factory $ComposeDraftCopyWith(ComposeDraft value, $Res Function(ComposeDraft) _then) = _$ComposeDraftCopyWithImpl;
@useResult
$Res call({
 String title, String content, ComposeImage? image, bool scheduled, DateTime? date, String time, String? accountId, PosterPrompt? lastPosterPrompt
});


$ComposeImageCopyWith<$Res>? get image;$PosterPromptCopyWith<$Res>? get lastPosterPrompt;

}
/// @nodoc
class _$ComposeDraftCopyWithImpl<$Res>
    implements $ComposeDraftCopyWith<$Res> {
  _$ComposeDraftCopyWithImpl(this._self, this._then);

  final ComposeDraft _self;
  final $Res Function(ComposeDraft) _then;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? content = null,Object? image = freezed,Object? scheduled = null,Object? date = freezed,Object? time = null,Object? accountId = freezed,Object? lastPosterPrompt = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ComposeImage?,scheduled: null == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,lastPosterPrompt: freezed == lastPosterPrompt ? _self.lastPosterPrompt : lastPosterPrompt // ignore: cast_nullable_to_non_nullable
as PosterPrompt?,
  ));
}
/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComposeImageCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ComposeImageCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosterPromptCopyWith<$Res>? get lastPosterPrompt {
    if (_self.lastPosterPrompt == null) {
    return null;
  }

  return $PosterPromptCopyWith<$Res>(_self.lastPosterPrompt!, (value) {
    return _then(_self.copyWith(lastPosterPrompt: value));
  });
}
}


/// Adds pattern-matching-related methods to [ComposeDraft].
extension ComposeDraftPatterns on ComposeDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComposeDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComposeDraft value)  $default,){
final _that = this;
switch (_that) {
case _ComposeDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComposeDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String content,  ComposeImage? image,  bool scheduled,  DateTime? date,  String time,  String? accountId,  PosterPrompt? lastPosterPrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
return $default(_that.title,_that.content,_that.image,_that.scheduled,_that.date,_that.time,_that.accountId,_that.lastPosterPrompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String content,  ComposeImage? image,  bool scheduled,  DateTime? date,  String time,  String? accountId,  PosterPrompt? lastPosterPrompt)  $default,) {final _that = this;
switch (_that) {
case _ComposeDraft():
return $default(_that.title,_that.content,_that.image,_that.scheduled,_that.date,_that.time,_that.accountId,_that.lastPosterPrompt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String content,  ComposeImage? image,  bool scheduled,  DateTime? date,  String time,  String? accountId,  PosterPrompt? lastPosterPrompt)?  $default,) {final _that = this;
switch (_that) {
case _ComposeDraft() when $default != null:
return $default(_that.title,_that.content,_that.image,_that.scheduled,_that.date,_that.time,_that.accountId,_that.lastPosterPrompt);case _:
  return null;

}
}

}

/// @nodoc


class _ComposeDraft extends ComposeDraft {
  const _ComposeDraft({this.title = '', this.content = '', this.image, this.scheduled = false, this.date, this.time = '09:00', this.accountId, this.lastPosterPrompt}): super._();
  

@override@JsonKey() final  String title;
@override@JsonKey() final  String content;
@override final  ComposeImage? image;
/// "Schedule for later". Off means publish through the normal approval
/// path as soon as it is approved.
@override@JsonKey() final  bool scheduled;
/// The day, at midnight. Null until the user picks one — a scheduled post
/// with no date is not submittable, which is why [scheduledFor] returns
/// null rather than guessing today.
@override final  DateTime? date;
/// 'HH:mm', 24-hour. The web's default is 09:00 and so is this.
@override@JsonKey() final  String time;
/// Which LinkedIn connection publishes this. Null falls back to the
/// context's active account at save time.
@override final  String? accountId;
/// Reused verbatim by Regenerate — see [PosterPrompt].
@override final  PosterPrompt? lastPosterPrompt;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComposeDraftCopyWith<_ComposeDraft> get copyWith => __$ComposeDraftCopyWithImpl<_ComposeDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComposeDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.lastPosterPrompt, lastPosterPrompt) || other.lastPosterPrompt == lastPosterPrompt));
}


@override
int get hashCode => Object.hash(runtimeType,title,content,image,scheduled,date,time,accountId,lastPosterPrompt);

@override
String toString() {
  return 'ComposeDraft(title: $title, content: $content, image: $image, scheduled: $scheduled, date: $date, time: $time, accountId: $accountId, lastPosterPrompt: $lastPosterPrompt)';
}


}

/// @nodoc
abstract mixin class _$ComposeDraftCopyWith<$Res> implements $ComposeDraftCopyWith<$Res> {
  factory _$ComposeDraftCopyWith(_ComposeDraft value, $Res Function(_ComposeDraft) _then) = __$ComposeDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, String content, ComposeImage? image, bool scheduled, DateTime? date, String time, String? accountId, PosterPrompt? lastPosterPrompt
});


@override $ComposeImageCopyWith<$Res>? get image;@override $PosterPromptCopyWith<$Res>? get lastPosterPrompt;

}
/// @nodoc
class __$ComposeDraftCopyWithImpl<$Res>
    implements _$ComposeDraftCopyWith<$Res> {
  __$ComposeDraftCopyWithImpl(this._self, this._then);

  final _ComposeDraft _self;
  final $Res Function(_ComposeDraft) _then;

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? content = null,Object? image = freezed,Object? scheduled = null,Object? date = freezed,Object? time = null,Object? accountId = freezed,Object? lastPosterPrompt = freezed,}) {
  return _then(_ComposeDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as ComposeImage?,scheduled: null == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,lastPosterPrompt: freezed == lastPosterPrompt ? _self.lastPosterPrompt : lastPosterPrompt // ignore: cast_nullable_to_non_nullable
as PosterPrompt?,
  ));
}

/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComposeImageCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $ComposeImageCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}/// Create a copy of ComposeDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PosterPromptCopyWith<$Res>? get lastPosterPrompt {
    if (_self.lastPosterPrompt == null) {
    return null;
  }

  return $PosterPromptCopyWith<$Res>(_self.lastPosterPrompt!, (value) {
    return _then(_self.copyWith(lastPosterPrompt: value));
  });
}
}

// dart format on
