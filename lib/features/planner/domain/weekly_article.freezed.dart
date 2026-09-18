// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyArticle {

 String get id; int get weekNumber; int get season;/// The headline. Chosen by the SEASON plan, not the week — all ten weeks
/// are titled in one model call so they read as one arc.
 String get title;/// The arguable claim the article defends. A topic says what the week is
/// ABOUT; a thesis says what it CLAIMS.
 String? get thesis;/// The body, 1200–1800 words. What the user pastes into LinkedIn.
 String get body; List<String> get sections;/// 'ready' once written; stamped published only by the user.
 String get status; String? get publishedAt; String? get publishedUrl;
/// Create a copy of WeeklyArticle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyArticleCopyWith<WeeklyArticle> get copyWith => _$WeeklyArticleCopyWithImpl<WeeklyArticle>(this as WeeklyArticle, _$identity);

  /// Serializes this WeeklyArticle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.title, title) || other.title == title)&&(identical(other.thesis, thesis) || other.thesis == thesis)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.publishedUrl, publishedUrl) || other.publishedUrl == publishedUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,title,thesis,body,const DeepCollectionEquality().hash(sections),status,publishedAt,publishedUrl);

@override
String toString() {
  return 'WeeklyArticle(id: $id, weekNumber: $weekNumber, season: $season, title: $title, thesis: $thesis, body: $body, sections: $sections, status: $status, publishedAt: $publishedAt, publishedUrl: $publishedUrl)';
}


}

/// @nodoc
abstract mixin class $WeeklyArticleCopyWith<$Res>  {
  factory $WeeklyArticleCopyWith(WeeklyArticle value, $Res Function(WeeklyArticle) _then) = _$WeeklyArticleCopyWithImpl;
@useResult
$Res call({
 String id, int weekNumber, int season, String title, String? thesis, String body, List<String> sections, String status, String? publishedAt, String? publishedUrl
});




}
/// @nodoc
class _$WeeklyArticleCopyWithImpl<$Res>
    implements $WeeklyArticleCopyWith<$Res> {
  _$WeeklyArticleCopyWithImpl(this._self, this._then);

  final WeeklyArticle _self;
  final $Res Function(WeeklyArticle) _then;

/// Create a copy of WeeklyArticle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? title = null,Object? thesis = freezed,Object? body = null,Object? sections = null,Object? status = null,Object? publishedAt = freezed,Object? publishedUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thesis: freezed == thesis ? _self.thesis : thesis // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,publishedUrl: freezed == publishedUrl ? _self.publishedUrl : publishedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyArticle].
extension WeeklyArticlePatterns on WeeklyArticle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyArticle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyArticle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyArticle value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyArticle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyArticle value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyArticle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  String title,  String? thesis,  String body,  List<String> sections,  String status,  String? publishedAt,  String? publishedUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyArticle() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.title,_that.thesis,_that.body,_that.sections,_that.status,_that.publishedAt,_that.publishedUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  String title,  String? thesis,  String body,  List<String> sections,  String status,  String? publishedAt,  String? publishedUrl)  $default,) {final _that = this;
switch (_that) {
case _WeeklyArticle():
return $default(_that.id,_that.weekNumber,_that.season,_that.title,_that.thesis,_that.body,_that.sections,_that.status,_that.publishedAt,_that.publishedUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int weekNumber,  int season,  String title,  String? thesis,  String body,  List<String> sections,  String status,  String? publishedAt,  String? publishedUrl)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyArticle() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.title,_that.thesis,_that.body,_that.sections,_that.status,_that.publishedAt,_that.publishedUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyArticle extends WeeklyArticle {
  const _WeeklyArticle({required this.id, required this.weekNumber, required this.season, this.title = '', this.thesis, this.body = '', final  List<String> sections = const <String>[], this.status = 'ready', this.publishedAt, this.publishedUrl}): _sections = sections,super._();
  factory _WeeklyArticle.fromJson(Map<String, dynamic> json) => _$WeeklyArticleFromJson(json);

@override final  String id;
@override final  int weekNumber;
@override final  int season;
/// The headline. Chosen by the SEASON plan, not the week — all ten weeks
/// are titled in one model call so they read as one arc.
@override@JsonKey() final  String title;
/// The arguable claim the article defends. A topic says what the week is
/// ABOUT; a thesis says what it CLAIMS.
@override final  String? thesis;
/// The body, 1200–1800 words. What the user pastes into LinkedIn.
@override@JsonKey() final  String body;
 final  List<String> _sections;
@override@JsonKey() List<String> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

/// 'ready' once written; stamped published only by the user.
@override@JsonKey() final  String status;
@override final  String? publishedAt;
@override final  String? publishedUrl;

/// Create a copy of WeeklyArticle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyArticleCopyWith<_WeeklyArticle> get copyWith => __$WeeklyArticleCopyWithImpl<_WeeklyArticle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyArticleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyArticle&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.title, title) || other.title == title)&&(identical(other.thesis, thesis) || other.thesis == thesis)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.status, status) || other.status == status)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.publishedUrl, publishedUrl) || other.publishedUrl == publishedUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,title,thesis,body,const DeepCollectionEquality().hash(_sections),status,publishedAt,publishedUrl);

@override
String toString() {
  return 'WeeklyArticle(id: $id, weekNumber: $weekNumber, season: $season, title: $title, thesis: $thesis, body: $body, sections: $sections, status: $status, publishedAt: $publishedAt, publishedUrl: $publishedUrl)';
}


}

/// @nodoc
abstract mixin class _$WeeklyArticleCopyWith<$Res> implements $WeeklyArticleCopyWith<$Res> {
  factory _$WeeklyArticleCopyWith(_WeeklyArticle value, $Res Function(_WeeklyArticle) _then) = __$WeeklyArticleCopyWithImpl;
@override @useResult
$Res call({
 String id, int weekNumber, int season, String title, String? thesis, String body, List<String> sections, String status, String? publishedAt, String? publishedUrl
});




}
/// @nodoc
class __$WeeklyArticleCopyWithImpl<$Res>
    implements _$WeeklyArticleCopyWith<$Res> {
  __$WeeklyArticleCopyWithImpl(this._self, this._then);

  final _WeeklyArticle _self;
  final $Res Function(_WeeklyArticle) _then;

/// Create a copy of WeeklyArticle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? title = null,Object? thesis = freezed,Object? body = null,Object? sections = null,Object? status = null,Object? publishedAt = freezed,Object? publishedUrl = freezed,}) {
  return _then(_WeeklyArticle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,thesis: freezed == thesis ? _self.thesis : thesis // ignore: cast_nullable_to_non_nullable
as String?,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,publishedUrl: freezed == publishedUrl ? _self.publishedUrl : publishedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ArticleState {

 WeeklyArticle? get article; String? get newsletterName; String? get newsletterCreatedAt; bool get isFirstArticle; int get weekNumber; int get season;
/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleStateCopyWith<ArticleState> get copyWith => _$ArticleStateCopyWithImpl<ArticleState>(this as ArticleState, _$identity);

  /// Serializes this ArticleState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArticleState&&(identical(other.article, article) || other.article == article)&&(identical(other.newsletterName, newsletterName) || other.newsletterName == newsletterName)&&(identical(other.newsletterCreatedAt, newsletterCreatedAt) || other.newsletterCreatedAt == newsletterCreatedAt)&&(identical(other.isFirstArticle, isFirstArticle) || other.isFirstArticle == isFirstArticle)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,article,newsletterName,newsletterCreatedAt,isFirstArticle,weekNumber,season);

@override
String toString() {
  return 'ArticleState(article: $article, newsletterName: $newsletterName, newsletterCreatedAt: $newsletterCreatedAt, isFirstArticle: $isFirstArticle, weekNumber: $weekNumber, season: $season)';
}


}

/// @nodoc
abstract mixin class $ArticleStateCopyWith<$Res>  {
  factory $ArticleStateCopyWith(ArticleState value, $Res Function(ArticleState) _then) = _$ArticleStateCopyWithImpl;
@useResult
$Res call({
 WeeklyArticle? article, String? newsletterName, String? newsletterCreatedAt, bool isFirstArticle, int weekNumber, int season
});


$WeeklyArticleCopyWith<$Res>? get article;

}
/// @nodoc
class _$ArticleStateCopyWithImpl<$Res>
    implements $ArticleStateCopyWith<$Res> {
  _$ArticleStateCopyWithImpl(this._self, this._then);

  final ArticleState _self;
  final $Res Function(ArticleState) _then;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? article = freezed,Object? newsletterName = freezed,Object? newsletterCreatedAt = freezed,Object? isFirstArticle = null,Object? weekNumber = null,Object? season = null,}) {
  return _then(_self.copyWith(
article: freezed == article ? _self.article : article // ignore: cast_nullable_to_non_nullable
as WeeklyArticle?,newsletterName: freezed == newsletterName ? _self.newsletterName : newsletterName // ignore: cast_nullable_to_non_nullable
as String?,newsletterCreatedAt: freezed == newsletterCreatedAt ? _self.newsletterCreatedAt : newsletterCreatedAt // ignore: cast_nullable_to_non_nullable
as String?,isFirstArticle: null == isFirstArticle ? _self.isFirstArticle : isFirstArticle // ignore: cast_nullable_to_non_nullable
as bool,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyArticleCopyWith<$Res>? get article {
    if (_self.article == null) {
    return null;
  }

  return $WeeklyArticleCopyWith<$Res>(_self.article!, (value) {
    return _then(_self.copyWith(article: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArticleState].
extension ArticleStatePatterns on ArticleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArticleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArticleState value)  $default,){
final _that = this;
switch (_that) {
case _ArticleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArticleState value)?  $default,){
final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeeklyArticle? article,  String? newsletterName,  String? newsletterCreatedAt,  bool isFirstArticle,  int weekNumber,  int season)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
return $default(_that.article,_that.newsletterName,_that.newsletterCreatedAt,_that.isFirstArticle,_that.weekNumber,_that.season);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeeklyArticle? article,  String? newsletterName,  String? newsletterCreatedAt,  bool isFirstArticle,  int weekNumber,  int season)  $default,) {final _that = this;
switch (_that) {
case _ArticleState():
return $default(_that.article,_that.newsletterName,_that.newsletterCreatedAt,_that.isFirstArticle,_that.weekNumber,_that.season);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeeklyArticle? article,  String? newsletterName,  String? newsletterCreatedAt,  bool isFirstArticle,  int weekNumber,  int season)?  $default,) {final _that = this;
switch (_that) {
case _ArticleState() when $default != null:
return $default(_that.article,_that.newsletterName,_that.newsletterCreatedAt,_that.isFirstArticle,_that.weekNumber,_that.season);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArticleState extends ArticleState {
  const _ArticleState({this.article, this.newsletterName, this.newsletterCreatedAt, this.isFirstArticle = false, this.weekNumber = 1, this.season = 1}): super._();
  factory _ArticleState.fromJson(Map<String, dynamic> json) => _$ArticleStateFromJson(json);

@override final  WeeklyArticle? article;
@override final  String? newsletterName;
@override final  String? newsletterCreatedAt;
@override@JsonKey() final  bool isFirstArticle;
@override@JsonKey() final  int weekNumber;
@override@JsonKey() final  int season;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleStateCopyWith<_ArticleState> get copyWith => __$ArticleStateCopyWithImpl<_ArticleState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArticleState&&(identical(other.article, article) || other.article == article)&&(identical(other.newsletterName, newsletterName) || other.newsletterName == newsletterName)&&(identical(other.newsletterCreatedAt, newsletterCreatedAt) || other.newsletterCreatedAt == newsletterCreatedAt)&&(identical(other.isFirstArticle, isFirstArticle) || other.isFirstArticle == isFirstArticle)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,article,newsletterName,newsletterCreatedAt,isFirstArticle,weekNumber,season);

@override
String toString() {
  return 'ArticleState(article: $article, newsletterName: $newsletterName, newsletterCreatedAt: $newsletterCreatedAt, isFirstArticle: $isFirstArticle, weekNumber: $weekNumber, season: $season)';
}


}

/// @nodoc
abstract mixin class _$ArticleStateCopyWith<$Res> implements $ArticleStateCopyWith<$Res> {
  factory _$ArticleStateCopyWith(_ArticleState value, $Res Function(_ArticleState) _then) = __$ArticleStateCopyWithImpl;
@override @useResult
$Res call({
 WeeklyArticle? article, String? newsletterName, String? newsletterCreatedAt, bool isFirstArticle, int weekNumber, int season
});


@override $WeeklyArticleCopyWith<$Res>? get article;

}
/// @nodoc
class __$ArticleStateCopyWithImpl<$Res>
    implements _$ArticleStateCopyWith<$Res> {
  __$ArticleStateCopyWithImpl(this._self, this._then);

  final _ArticleState _self;
  final $Res Function(_ArticleState) _then;

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? article = freezed,Object? newsletterName = freezed,Object? newsletterCreatedAt = freezed,Object? isFirstArticle = null,Object? weekNumber = null,Object? season = null,}) {
  return _then(_ArticleState(
article: freezed == article ? _self.article : article // ignore: cast_nullable_to_non_nullable
as WeeklyArticle?,newsletterName: freezed == newsletterName ? _self.newsletterName : newsletterName // ignore: cast_nullable_to_non_nullable
as String?,newsletterCreatedAt: freezed == newsletterCreatedAt ? _self.newsletterCreatedAt : newsletterCreatedAt // ignore: cast_nullable_to_non_nullable
as String?,isFirstArticle: null == isFirstArticle ? _self.isFirstArticle : isFirstArticle // ignore: cast_nullable_to_non_nullable
as bool,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ArticleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyArticleCopyWith<$Res>? get article {
    if (_self.article == null) {
    return null;
  }

  return $WeeklyArticleCopyWith<$Res>(_self.article!, (value) {
    return _then(_self.copyWith(article: value));
  });
}
}

// dart format on
