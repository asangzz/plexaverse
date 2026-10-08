// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'compose_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneratedPost {

 String get content; String get category; String? get posterTitle; String get model; String get provider;
/// Create a copy of GeneratedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedPostCopyWith<GeneratedPost> get copyWith => _$GeneratedPostCopyWithImpl<GeneratedPost>(this as GeneratedPost, _$identity);

  /// Serializes this GeneratedPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedPost&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.model, model) || other.model == model)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,category,posterTitle,model,provider);

@override
String toString() {
  return 'GeneratedPost(content: $content, category: $category, posterTitle: $posterTitle, model: $model, provider: $provider)';
}


}

/// @nodoc
abstract mixin class $GeneratedPostCopyWith<$Res>  {
  factory $GeneratedPostCopyWith(GeneratedPost value, $Res Function(GeneratedPost) _then) = _$GeneratedPostCopyWithImpl;
@useResult
$Res call({
 String content, String category, String? posterTitle, String model, String provider
});




}
/// @nodoc
class _$GeneratedPostCopyWithImpl<$Res>
    implements $GeneratedPostCopyWith<$Res> {
  _$GeneratedPostCopyWithImpl(this._self, this._then);

  final GeneratedPost _self;
  final $Res Function(GeneratedPost) _then;

/// Create a copy of GeneratedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? category = null,Object? posterTitle = freezed,Object? model = null,Object? provider = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,posterTitle: freezed == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratedPost].
extension GeneratedPostPatterns on GeneratedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratedPost value)  $default,){
final _that = this;
switch (_that) {
case _GeneratedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratedPost value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String category,  String? posterTitle,  String model,  String provider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratedPost() when $default != null:
return $default(_that.content,_that.category,_that.posterTitle,_that.model,_that.provider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String category,  String? posterTitle,  String model,  String provider)  $default,) {final _that = this;
switch (_that) {
case _GeneratedPost():
return $default(_that.content,_that.category,_that.posterTitle,_that.model,_that.provider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String category,  String? posterTitle,  String model,  String provider)?  $default,) {final _that = this;
switch (_that) {
case _GeneratedPost() when $default != null:
return $default(_that.content,_that.category,_that.posterTitle,_that.model,_that.provider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratedPost implements GeneratedPost {
  const _GeneratedPost({this.content = '', this.category = '', this.posterTitle, this.model = '', this.provider = ''});
  factory _GeneratedPost.fromJson(Map<String, dynamic> json) => _$GeneratedPostFromJson(json);

@override@JsonKey() final  String content;
@override@JsonKey() final  String category;
@override final  String? posterTitle;
@override@JsonKey() final  String model;
@override@JsonKey() final  String provider;

/// Create a copy of GeneratedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratedPostCopyWith<_GeneratedPost> get copyWith => __$GeneratedPostCopyWithImpl<_GeneratedPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratedPost&&(identical(other.content, content) || other.content == content)&&(identical(other.category, category) || other.category == category)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.model, model) || other.model == model)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,category,posterTitle,model,provider);

@override
String toString() {
  return 'GeneratedPost(content: $content, category: $category, posterTitle: $posterTitle, model: $model, provider: $provider)';
}


}

/// @nodoc
abstract mixin class _$GeneratedPostCopyWith<$Res> implements $GeneratedPostCopyWith<$Res> {
  factory _$GeneratedPostCopyWith(_GeneratedPost value, $Res Function(_GeneratedPost) _then) = __$GeneratedPostCopyWithImpl;
@override @useResult
$Res call({
 String content, String category, String? posterTitle, String model, String provider
});




}
/// @nodoc
class __$GeneratedPostCopyWithImpl<$Res>
    implements _$GeneratedPostCopyWith<$Res> {
  __$GeneratedPostCopyWithImpl(this._self, this._then);

  final _GeneratedPost _self;
  final $Res Function(_GeneratedPost) _then;

/// Create a copy of GeneratedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? category = null,Object? posterTitle = freezed,Object? model = null,Object? provider = null,}) {
  return _then(_GeneratedPost(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,posterTitle: freezed == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PosterTagOption {

 String get tag; int get live;
/// Create a copy of PosterTagOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PosterTagOptionCopyWith<PosterTagOption> get copyWith => _$PosterTagOptionCopyWithImpl<PosterTagOption>(this as PosterTagOption, _$identity);

  /// Serializes this PosterTagOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PosterTagOption&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.live, live) || other.live == live));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,live);

@override
String toString() {
  return 'PosterTagOption(tag: $tag, live: $live)';
}


}

/// @nodoc
abstract mixin class $PosterTagOptionCopyWith<$Res>  {
  factory $PosterTagOptionCopyWith(PosterTagOption value, $Res Function(PosterTagOption) _then) = _$PosterTagOptionCopyWithImpl;
@useResult
$Res call({
 String tag, int live
});




}
/// @nodoc
class _$PosterTagOptionCopyWithImpl<$Res>
    implements $PosterTagOptionCopyWith<$Res> {
  _$PosterTagOptionCopyWithImpl(this._self, this._then);

  final PosterTagOption _self;
  final $Res Function(PosterTagOption) _then;

/// Create a copy of PosterTagOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? live = null,}) {
  return _then(_self.copyWith(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,live: null == live ? _self.live : live // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PosterTagOption].
extension PosterTagOptionPatterns on PosterTagOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PosterTagOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PosterTagOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PosterTagOption value)  $default,){
final _that = this;
switch (_that) {
case _PosterTagOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PosterTagOption value)?  $default,){
final _that = this;
switch (_that) {
case _PosterTagOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tag,  int live)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PosterTagOption() when $default != null:
return $default(_that.tag,_that.live);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tag,  int live)  $default,) {final _that = this;
switch (_that) {
case _PosterTagOption():
return $default(_that.tag,_that.live);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tag,  int live)?  $default,) {final _that = this;
switch (_that) {
case _PosterTagOption() when $default != null:
return $default(_that.tag,_that.live);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PosterTagOption extends PosterTagOption {
  const _PosterTagOption({this.tag = '', this.live = 0}): super._();
  factory _PosterTagOption.fromJson(Map<String, dynamic> json) => _$PosterTagOptionFromJson(json);

@override@JsonKey() final  String tag;
@override@JsonKey() final  int live;

/// Create a copy of PosterTagOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PosterTagOptionCopyWith<_PosterTagOption> get copyWith => __$PosterTagOptionCopyWithImpl<_PosterTagOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PosterTagOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PosterTagOption&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.live, live) || other.live == live));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,live);

@override
String toString() {
  return 'PosterTagOption(tag: $tag, live: $live)';
}


}

/// @nodoc
abstract mixin class _$PosterTagOptionCopyWith<$Res> implements $PosterTagOptionCopyWith<$Res> {
  factory _$PosterTagOptionCopyWith(_PosterTagOption value, $Res Function(_PosterTagOption) _then) = __$PosterTagOptionCopyWithImpl;
@override @useResult
$Res call({
 String tag, int live
});




}
/// @nodoc
class __$PosterTagOptionCopyWithImpl<$Res>
    implements _$PosterTagOptionCopyWith<$Res> {
  __$PosterTagOptionCopyWithImpl(this._self, this._then);

  final _PosterTagOption _self;
  final $Res Function(_PosterTagOption) _then;

/// Create a copy of PosterTagOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? live = null,}) {
  return _then(_PosterTagOption(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,live: null == live ? _self.live : live // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GeneratedPoster {

 String get imageUrl; String get posterTitle; String get model; String get provider;
/// Create a copy of GeneratedPoster
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedPosterCopyWith<GeneratedPoster> get copyWith => _$GeneratedPosterCopyWithImpl<GeneratedPoster>(this as GeneratedPoster, _$identity);

  /// Serializes this GeneratedPoster to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedPoster&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.model, model) || other.model == model)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,posterTitle,model,provider);

@override
String toString() {
  return 'GeneratedPoster(imageUrl: $imageUrl, posterTitle: $posterTitle, model: $model, provider: $provider)';
}


}

/// @nodoc
abstract mixin class $GeneratedPosterCopyWith<$Res>  {
  factory $GeneratedPosterCopyWith(GeneratedPoster value, $Res Function(GeneratedPoster) _then) = _$GeneratedPosterCopyWithImpl;
@useResult
$Res call({
 String imageUrl, String posterTitle, String model, String provider
});




}
/// @nodoc
class _$GeneratedPosterCopyWithImpl<$Res>
    implements $GeneratedPosterCopyWith<$Res> {
  _$GeneratedPosterCopyWithImpl(this._self, this._then);

  final GeneratedPoster _self;
  final $Res Function(GeneratedPoster) _then;

/// Create a copy of GeneratedPoster
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,Object? posterTitle = null,Object? model = null,Object? provider = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,posterTitle: null == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeneratedPoster].
extension GeneratedPosterPatterns on GeneratedPoster {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeneratedPoster value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeneratedPoster() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeneratedPoster value)  $default,){
final _that = this;
switch (_that) {
case _GeneratedPoster():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeneratedPoster value)?  $default,){
final _that = this;
switch (_that) {
case _GeneratedPoster() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String imageUrl,  String posterTitle,  String model,  String provider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeneratedPoster() when $default != null:
return $default(_that.imageUrl,_that.posterTitle,_that.model,_that.provider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String imageUrl,  String posterTitle,  String model,  String provider)  $default,) {final _that = this;
switch (_that) {
case _GeneratedPoster():
return $default(_that.imageUrl,_that.posterTitle,_that.model,_that.provider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String imageUrl,  String posterTitle,  String model,  String provider)?  $default,) {final _that = this;
switch (_that) {
case _GeneratedPoster() when $default != null:
return $default(_that.imageUrl,_that.posterTitle,_that.model,_that.provider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeneratedPoster implements GeneratedPoster {
  const _GeneratedPoster({this.imageUrl = '', this.posterTitle = '', this.model = '', this.provider = ''});
  factory _GeneratedPoster.fromJson(Map<String, dynamic> json) => _$GeneratedPosterFromJson(json);

@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String posterTitle;
@override@JsonKey() final  String model;
@override@JsonKey() final  String provider;

/// Create a copy of GeneratedPoster
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeneratedPosterCopyWith<_GeneratedPoster> get copyWith => __$GeneratedPosterCopyWithImpl<_GeneratedPoster>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedPosterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeneratedPoster&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.posterTitle, posterTitle) || other.posterTitle == posterTitle)&&(identical(other.model, model) || other.model == model)&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,posterTitle,model,provider);

@override
String toString() {
  return 'GeneratedPoster(imageUrl: $imageUrl, posterTitle: $posterTitle, model: $model, provider: $provider)';
}


}

/// @nodoc
abstract mixin class _$GeneratedPosterCopyWith<$Res> implements $GeneratedPosterCopyWith<$Res> {
  factory _$GeneratedPosterCopyWith(_GeneratedPoster value, $Res Function(_GeneratedPoster) _then) = __$GeneratedPosterCopyWithImpl;
@override @useResult
$Res call({
 String imageUrl, String posterTitle, String model, String provider
});




}
/// @nodoc
class __$GeneratedPosterCopyWithImpl<$Res>
    implements _$GeneratedPosterCopyWith<$Res> {
  __$GeneratedPosterCopyWithImpl(this._self, this._then);

  final _GeneratedPoster _self;
  final $Res Function(_GeneratedPoster) _then;

/// Create a copy of GeneratedPoster
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,Object? posterTitle = null,Object? model = null,Object? provider = null,}) {
  return _then(_GeneratedPoster(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,posterTitle: null == posterTitle ? _self.posterTitle : posterTitle // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UploadedImage {

 String get url; String? get thumbUrl;
/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadedImageCopyWith<UploadedImage> get copyWith => _$UploadedImageCopyWithImpl<UploadedImage>(this as UploadedImage, _$identity);

  /// Serializes this UploadedImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadedImage&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,thumbUrl);

@override
String toString() {
  return 'UploadedImage(url: $url, thumbUrl: $thumbUrl)';
}


}

/// @nodoc
abstract mixin class $UploadedImageCopyWith<$Res>  {
  factory $UploadedImageCopyWith(UploadedImage value, $Res Function(UploadedImage) _then) = _$UploadedImageCopyWithImpl;
@useResult
$Res call({
 String url, String? thumbUrl
});




}
/// @nodoc
class _$UploadedImageCopyWithImpl<$Res>
    implements $UploadedImageCopyWith<$Res> {
  _$UploadedImageCopyWithImpl(this._self, this._then);

  final UploadedImage _self;
  final $Res Function(UploadedImage) _then;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? thumbUrl = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadedImage].
extension UploadedImagePatterns on UploadedImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadedImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadedImage value)  $default,){
final _that = this;
switch (_that) {
case _UploadedImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadedImage value)?  $default,){
final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? thumbUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that.url,_that.thumbUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? thumbUrl)  $default,) {final _that = this;
switch (_that) {
case _UploadedImage():
return $default(_that.url,_that.thumbUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? thumbUrl)?  $default,) {final _that = this;
switch (_that) {
case _UploadedImage() when $default != null:
return $default(_that.url,_that.thumbUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadedImage implements UploadedImage {
  const _UploadedImage({this.url = '', this.thumbUrl});
  factory _UploadedImage.fromJson(Map<String, dynamic> json) => _$UploadedImageFromJson(json);

@override@JsonKey() final  String url;
@override final  String? thumbUrl;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadedImageCopyWith<_UploadedImage> get copyWith => __$UploadedImageCopyWithImpl<_UploadedImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadedImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadedImage&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,thumbUrl);

@override
String toString() {
  return 'UploadedImage(url: $url, thumbUrl: $thumbUrl)';
}


}

/// @nodoc
abstract mixin class _$UploadedImageCopyWith<$Res> implements $UploadedImageCopyWith<$Res> {
  factory _$UploadedImageCopyWith(_UploadedImage value, $Res Function(_UploadedImage) _then) = __$UploadedImageCopyWithImpl;
@override @useResult
$Res call({
 String url, String? thumbUrl
});




}
/// @nodoc
class __$UploadedImageCopyWithImpl<$Res>
    implements _$UploadedImageCopyWith<$Res> {
  __$UploadedImageCopyWithImpl(this._self, this._then);

  final _UploadedImage _self;
  final $Res Function(_UploadedImage) _then;

/// Create a copy of UploadedImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? thumbUrl = freezed,}) {
  return _then(_UploadedImage(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: freezed == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CreatedPost {

 String get id; String get status; String? get scheduledFor; String? get imageUrl;
/// Create a copy of CreatedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatedPostCopyWith<CreatedPost> get copyWith => _$CreatedPostCopyWithImpl<CreatedPost>(this as CreatedPost, _$identity);

  /// Serializes this CreatedPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,scheduledFor,imageUrl);

@override
String toString() {
  return 'CreatedPost(id: $id, status: $status, scheduledFor: $scheduledFor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $CreatedPostCopyWith<$Res>  {
  factory $CreatedPostCopyWith(CreatedPost value, $Res Function(CreatedPost) _then) = _$CreatedPostCopyWithImpl;
@useResult
$Res call({
 String id, String status, String? scheduledFor, String? imageUrl
});




}
/// @nodoc
class _$CreatedPostCopyWithImpl<$Res>
    implements $CreatedPostCopyWith<$Res> {
  _$CreatedPostCopyWithImpl(this._self, this._then);

  final CreatedPost _self;
  final $Res Function(CreatedPost) _then;

/// Create a copy of CreatedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? scheduledFor = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatedPost].
extension CreatedPostPatterns on CreatedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatedPost value)  $default,){
final _that = this;
switch (_that) {
case _CreatedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatedPost value)?  $default,){
final _that = this;
switch (_that) {
case _CreatedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  String? scheduledFor,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatedPost() when $default != null:
return $default(_that.id,_that.status,_that.scheduledFor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  String? scheduledFor,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _CreatedPost():
return $default(_that.id,_that.status,_that.scheduledFor,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  String? scheduledFor,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _CreatedPost() when $default != null:
return $default(_that.id,_that.status,_that.scheduledFor,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatedPost implements CreatedPost {
  const _CreatedPost({this.id = '', this.status = 'draft', this.scheduledFor, this.imageUrl});
  factory _CreatedPost.fromJson(Map<String, dynamic> json) => _$CreatedPostFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String status;
@override final  String? scheduledFor;
@override final  String? imageUrl;

/// Create a copy of CreatedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedPostCopyWith<_CreatedPost> get copyWith => __$CreatedPostCopyWithImpl<_CreatedPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatedPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,scheduledFor,imageUrl);

@override
String toString() {
  return 'CreatedPost(id: $id, status: $status, scheduledFor: $scheduledFor, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$CreatedPostCopyWith<$Res> implements $CreatedPostCopyWith<$Res> {
  factory _$CreatedPostCopyWith(_CreatedPost value, $Res Function(_CreatedPost) _then) = __$CreatedPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, String? scheduledFor, String? imageUrl
});




}
/// @nodoc
class __$CreatedPostCopyWithImpl<$Res>
    implements _$CreatedPostCopyWith<$Res> {
  __$CreatedPostCopyWithImpl(this._self, this._then);

  final _CreatedPost _self;
  final $Res Function(_CreatedPost) _then;

/// Create a copy of CreatedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? scheduledFor = freezed,Object? imageUrl = freezed,}) {
  return _then(_CreatedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CompanyPublishResult {

 bool get success; String get postUrn; String get postUrl;
/// Create a copy of CompanyPublishResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyPublishResultCopyWith<CompanyPublishResult> get copyWith => _$CompanyPublishResultCopyWithImpl<CompanyPublishResult>(this as CompanyPublishResult, _$identity);

  /// Serializes this CompanyPublishResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyPublishResult&&(identical(other.success, success) || other.success == success)&&(identical(other.postUrn, postUrn) || other.postUrn == postUrn)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,postUrn,postUrl);

@override
String toString() {
  return 'CompanyPublishResult(success: $success, postUrn: $postUrn, postUrl: $postUrl)';
}


}

/// @nodoc
abstract mixin class $CompanyPublishResultCopyWith<$Res>  {
  factory $CompanyPublishResultCopyWith(CompanyPublishResult value, $Res Function(CompanyPublishResult) _then) = _$CompanyPublishResultCopyWithImpl;
@useResult
$Res call({
 bool success, String postUrn, String postUrl
});




}
/// @nodoc
class _$CompanyPublishResultCopyWithImpl<$Res>
    implements $CompanyPublishResultCopyWith<$Res> {
  _$CompanyPublishResultCopyWithImpl(this._self, this._then);

  final CompanyPublishResult _self;
  final $Res Function(CompanyPublishResult) _then;

/// Create a copy of CompanyPublishResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? postUrn = null,Object? postUrl = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,postUrn: null == postUrn ? _self.postUrn : postUrn // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyPublishResult].
extension CompanyPublishResultPatterns on CompanyPublishResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyPublishResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyPublishResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyPublishResult value)  $default,){
final _that = this;
switch (_that) {
case _CompanyPublishResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyPublishResult value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyPublishResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  String postUrn,  String postUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyPublishResult() when $default != null:
return $default(_that.success,_that.postUrn,_that.postUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  String postUrn,  String postUrl)  $default,) {final _that = this;
switch (_that) {
case _CompanyPublishResult():
return $default(_that.success,_that.postUrn,_that.postUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  String postUrn,  String postUrl)?  $default,) {final _that = this;
switch (_that) {
case _CompanyPublishResult() when $default != null:
return $default(_that.success,_that.postUrn,_that.postUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyPublishResult implements CompanyPublishResult {
  const _CompanyPublishResult({this.success = false, this.postUrn = '', this.postUrl = ''});
  factory _CompanyPublishResult.fromJson(Map<String, dynamic> json) => _$CompanyPublishResultFromJson(json);

@override@JsonKey() final  bool success;
@override@JsonKey() final  String postUrn;
@override@JsonKey() final  String postUrl;

/// Create a copy of CompanyPublishResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyPublishResultCopyWith<_CompanyPublishResult> get copyWith => __$CompanyPublishResultCopyWithImpl<_CompanyPublishResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyPublishResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyPublishResult&&(identical(other.success, success) || other.success == success)&&(identical(other.postUrn, postUrn) || other.postUrn == postUrn)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,postUrn,postUrl);

@override
String toString() {
  return 'CompanyPublishResult(success: $success, postUrn: $postUrn, postUrl: $postUrl)';
}


}

/// @nodoc
abstract mixin class _$CompanyPublishResultCopyWith<$Res> implements $CompanyPublishResultCopyWith<$Res> {
  factory _$CompanyPublishResultCopyWith(_CompanyPublishResult value, $Res Function(_CompanyPublishResult) _then) = __$CompanyPublishResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, String postUrn, String postUrl
});




}
/// @nodoc
class __$CompanyPublishResultCopyWithImpl<$Res>
    implements _$CompanyPublishResultCopyWith<$Res> {
  __$CompanyPublishResultCopyWithImpl(this._self, this._then);

  final _CompanyPublishResult _self;
  final $Res Function(_CompanyPublishResult) _then;

/// Create a copy of CompanyPublishResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? postUrn = null,Object? postUrl = null,}) {
  return _then(_CompanyPublishResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,postUrn: null == postUrn ? _self.postUrn : postUrn // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
