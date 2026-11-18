// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_tasks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentPost {

 String get author; String get firstLine;/// Only once the level is done. Filtered to `https` by the server, and
/// opened only on a LinkedIn host by the app — `isLinkedInHost`.
 String? get postUrl;
/// Create a copy of CommentPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentPostCopyWith<CommentPost> get copyWith => _$CommentPostCopyWithImpl<CommentPost>(this as CommentPost, _$identity);

  /// Serializes this CommentPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentPost&&(identical(other.author, author) || other.author == author)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,firstLine,postUrl);

@override
String toString() {
  return 'CommentPost(author: $author, firstLine: $firstLine, postUrl: $postUrl)';
}


}

/// @nodoc
abstract mixin class $CommentPostCopyWith<$Res>  {
  factory $CommentPostCopyWith(CommentPost value, $Res Function(CommentPost) _then) = _$CommentPostCopyWithImpl;
@useResult
$Res call({
 String author, String firstLine, String? postUrl
});




}
/// @nodoc
class _$CommentPostCopyWithImpl<$Res>
    implements $CommentPostCopyWith<$Res> {
  _$CommentPostCopyWithImpl(this._self, this._then);

  final CommentPost _self;
  final $Res Function(CommentPost) _then;

/// Create a copy of CommentPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? author = null,Object? firstLine = null,Object? postUrl = freezed,}) {
  return _then(_self.copyWith(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,firstLine: null == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String,postUrl: freezed == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentPost].
extension CommentPostPatterns on CommentPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentPost value)  $default,){
final _that = this;
switch (_that) {
case _CommentPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentPost value)?  $default,){
final _that = this;
switch (_that) {
case _CommentPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String author,  String firstLine,  String? postUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentPost() when $default != null:
return $default(_that.author,_that.firstLine,_that.postUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String author,  String firstLine,  String? postUrl)  $default,) {final _that = this;
switch (_that) {
case _CommentPost():
return $default(_that.author,_that.firstLine,_that.postUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String author,  String firstLine,  String? postUrl)?  $default,) {final _that = this;
switch (_that) {
case _CommentPost() when $default != null:
return $default(_that.author,_that.firstLine,_that.postUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentPost implements CommentPost {
  const _CommentPost({this.author = '', this.firstLine = '', this.postUrl});
  factory _CommentPost.fromJson(Map<String, dynamic> json) => _$CommentPostFromJson(json);

@override@JsonKey() final  String author;
@override@JsonKey() final  String firstLine;
/// Only once the level is done. Filtered to `https` by the server, and
/// opened only on a LinkedIn host by the app — `isLinkedInHost`.
@override final  String? postUrl;

/// Create a copy of CommentPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentPostCopyWith<_CommentPost> get copyWith => __$CommentPostCopyWithImpl<_CommentPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentPost&&(identical(other.author, author) || other.author == author)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,firstLine,postUrl);

@override
String toString() {
  return 'CommentPost(author: $author, firstLine: $firstLine, postUrl: $postUrl)';
}


}

/// @nodoc
abstract mixin class _$CommentPostCopyWith<$Res> implements $CommentPostCopyWith<$Res> {
  factory _$CommentPostCopyWith(_CommentPost value, $Res Function(_CommentPost) _then) = __$CommentPostCopyWithImpl;
@override @useResult
$Res call({
 String author, String firstLine, String? postUrl
});




}
/// @nodoc
class __$CommentPostCopyWithImpl<$Res>
    implements _$CommentPostCopyWith<$Res> {
  __$CommentPostCopyWithImpl(this._self, this._then);

  final _CommentPost _self;
  final $Res Function(_CommentPost) _then;

/// Create a copy of CommentPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? author = null,Object? firstLine = null,Object? postUrl = freezed,}) {
  return _then(_CommentPost(
author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,firstLine: null == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String,postUrl: freezed == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CommentLevelView {

@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable) CommentLevelStatus get status;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentLevelReason? get reason; CommentPost? get post;/// The comment with `{{1}}` … `{{n}}` where the blanks go.
 String? get template; int? get blankCount;/// Answers and distractors, shuffled once for the day.
 List<String> get bank;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentFirstTry? get firstTry;/// Once done: the right word for each blank, in order.
 List<String> get answers;/// Once done: the finished comment, ready to copy.
 String? get comment;/// What the day's comment has paid.
 int? get pointsApplied;
/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentLevelViewCopyWith<CommentLevelView> get copyWith => _$CommentLevelViewCopyWithImpl<CommentLevelView>(this as CommentLevelView, _$identity);

  /// Serializes this CommentLevelView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentLevelView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.post, post) || other.post == post)&&(identical(other.template, template) || other.template == template)&&(identical(other.blankCount, blankCount) || other.blankCount == blankCount)&&const DeepCollectionEquality().equals(other.bank, bank)&&(identical(other.firstTry, firstTry) || other.firstTry == firstTry)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,post,template,blankCount,const DeepCollectionEquality().hash(bank),firstTry,const DeepCollectionEquality().hash(answers),comment,pointsApplied);

@override
String toString() {
  return 'CommentLevelView(status: $status, reason: $reason, post: $post, template: $template, blankCount: $blankCount, bank: $bank, firstTry: $firstTry, answers: $answers, comment: $comment, pointsApplied: $pointsApplied)';
}


}

/// @nodoc
abstract mixin class $CommentLevelViewCopyWith<$Res>  {
  factory $CommentLevelViewCopyWith(CommentLevelView value, $Res Function(CommentLevelView) _then) = _$CommentLevelViewCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable) CommentLevelStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentLevelReason? reason, CommentPost? post, String? template, int? blankCount, List<String> bank,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentFirstTry? firstTry, List<String> answers, String? comment, int? pointsApplied
});


$CommentPostCopyWith<$Res>? get post;

}
/// @nodoc
class _$CommentLevelViewCopyWithImpl<$Res>
    implements $CommentLevelViewCopyWith<$Res> {
  _$CommentLevelViewCopyWithImpl(this._self, this._then);

  final CommentLevelView _self;
  final $Res Function(CommentLevelView) _then;

/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? post = freezed,Object? template = freezed,Object? blankCount = freezed,Object? bank = null,Object? firstTry = freezed,Object? answers = null,Object? comment = freezed,Object? pointsApplied = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommentLevelStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CommentLevelReason?,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as CommentPost?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String?,blankCount: freezed == blankCount ? _self.blankCount : blankCount // ignore: cast_nullable_to_non_nullable
as int?,bank: null == bank ? _self.bank : bank // ignore: cast_nullable_to_non_nullable
as List<String>,firstTry: freezed == firstTry ? _self.firstTry : firstTry // ignore: cast_nullable_to_non_nullable
as CommentFirstTry?,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<String>,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentPostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $CommentPostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentLevelView].
extension CommentLevelViewPatterns on CommentLevelView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentLevelView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentLevelView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentLevelView value)  $default,){
final _that = this;
switch (_that) {
case _CommentLevelView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentLevelView value)?  $default,){
final _that = this;
switch (_that) {
case _CommentLevelView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable)  CommentLevelStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentLevelReason? reason,  CommentPost? post,  String? template,  int? blankCount,  List<String> bank, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentFirstTry? firstTry,  List<String> answers,  String? comment,  int? pointsApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentLevelView() when $default != null:
return $default(_that.status,_that.reason,_that.post,_that.template,_that.blankCount,_that.bank,_that.firstTry,_that.answers,_that.comment,_that.pointsApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable)  CommentLevelStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentLevelReason? reason,  CommentPost? post,  String? template,  int? blankCount,  List<String> bank, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentFirstTry? firstTry,  List<String> answers,  String? comment,  int? pointsApplied)  $default,) {final _that = this;
switch (_that) {
case _CommentLevelView():
return $default(_that.status,_that.reason,_that.post,_that.template,_that.blankCount,_that.bank,_that.firstTry,_that.answers,_that.comment,_that.pointsApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable)  CommentLevelStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentLevelReason? reason,  CommentPost? post,  String? template,  int? blankCount,  List<String> bank, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  CommentFirstTry? firstTry,  List<String> answers,  String? comment,  int? pointsApplied)?  $default,) {final _that = this;
switch (_that) {
case _CommentLevelView() when $default != null:
return $default(_that.status,_that.reason,_that.post,_that.template,_that.blankCount,_that.bank,_that.firstTry,_that.answers,_that.comment,_that.pointsApplied);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentLevelView extends CommentLevelView {
  const _CommentLevelView({@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable) this.status = CommentLevelStatus.unavailable, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.reason, this.post, this.template, this.blankCount, final  List<String> bank = const <String>[], @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.firstTry, final  List<String> answers = const <String>[], this.comment, this.pointsApplied}): _bank = bank,_answers = answers,super._();
  factory _CommentLevelView.fromJson(Map<String, dynamic> json) => _$CommentLevelViewFromJson(json);

@override@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable) final  CommentLevelStatus status;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  CommentLevelReason? reason;
@override final  CommentPost? post;
/// The comment with `{{1}}` … `{{n}}` where the blanks go.
@override final  String? template;
@override final  int? blankCount;
/// Answers and distractors, shuffled once for the day.
 final  List<String> _bank;
/// Answers and distractors, shuffled once for the day.
@override@JsonKey() List<String> get bank {
  if (_bank is EqualUnmodifiableListView) return _bank;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bank);
}

@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  CommentFirstTry? firstTry;
/// Once done: the right word for each blank, in order.
 final  List<String> _answers;
/// Once done: the right word for each blank, in order.
@override@JsonKey() List<String> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}

/// Once done: the finished comment, ready to copy.
@override final  String? comment;
/// What the day's comment has paid.
@override final  int? pointsApplied;

/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentLevelViewCopyWith<_CommentLevelView> get copyWith => __$CommentLevelViewCopyWithImpl<_CommentLevelView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentLevelViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentLevelView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.post, post) || other.post == post)&&(identical(other.template, template) || other.template == template)&&(identical(other.blankCount, blankCount) || other.blankCount == blankCount)&&const DeepCollectionEquality().equals(other._bank, _bank)&&(identical(other.firstTry, firstTry) || other.firstTry == firstTry)&&const DeepCollectionEquality().equals(other._answers, _answers)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,post,template,blankCount,const DeepCollectionEquality().hash(_bank),firstTry,const DeepCollectionEquality().hash(_answers),comment,pointsApplied);

@override
String toString() {
  return 'CommentLevelView(status: $status, reason: $reason, post: $post, template: $template, blankCount: $blankCount, bank: $bank, firstTry: $firstTry, answers: $answers, comment: $comment, pointsApplied: $pointsApplied)';
}


}

/// @nodoc
abstract mixin class _$CommentLevelViewCopyWith<$Res> implements $CommentLevelViewCopyWith<$Res> {
  factory _$CommentLevelViewCopyWith(_CommentLevelView value, $Res Function(_CommentLevelView) _then) = __$CommentLevelViewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: CommentLevelStatus.unavailable) CommentLevelStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentLevelReason? reason, CommentPost? post, String? template, int? blankCount, List<String> bank,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) CommentFirstTry? firstTry, List<String> answers, String? comment, int? pointsApplied
});


@override $CommentPostCopyWith<$Res>? get post;

}
/// @nodoc
class __$CommentLevelViewCopyWithImpl<$Res>
    implements _$CommentLevelViewCopyWith<$Res> {
  __$CommentLevelViewCopyWithImpl(this._self, this._then);

  final _CommentLevelView _self;
  final $Res Function(_CommentLevelView) _then;

/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? post = freezed,Object? template = freezed,Object? blankCount = freezed,Object? bank = null,Object? firstTry = freezed,Object? answers = null,Object? comment = freezed,Object? pointsApplied = freezed,}) {
  return _then(_CommentLevelView(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommentLevelStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as CommentLevelReason?,post: freezed == post ? _self.post : post // ignore: cast_nullable_to_non_nullable
as CommentPost?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String?,blankCount: freezed == blankCount ? _self.blankCount : blankCount // ignore: cast_nullable_to_non_nullable
as int?,bank: null == bank ? _self._bank : bank // ignore: cast_nullable_to_non_nullable
as List<String>,firstTry: freezed == firstTry ? _self.firstTry : firstTry // ignore: cast_nullable_to_non_nullable
as CommentFirstTry?,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<String>,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of CommentLevelView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentPostCopyWith<$Res>? get post {
    if (_self.post == null) {
    return null;
  }

  return $CommentPostCopyWith<$Res>(_self.post!, (value) {
    return _then(_self.copyWith(post: value));
  });
}
}


/// @nodoc
mixin _$CommentBlank {

 String get value; bool get correct; String get answer;
/// Create a copy of CommentBlank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentBlankCopyWith<CommentBlank> get copyWith => _$CommentBlankCopyWithImpl<CommentBlank>(this as CommentBlank, _$identity);

  /// Serializes this CommentBlank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentBlank&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,correct,answer);

@override
String toString() {
  return 'CommentBlank(value: $value, correct: $correct, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $CommentBlankCopyWith<$Res>  {
  factory $CommentBlankCopyWith(CommentBlank value, $Res Function(CommentBlank) _then) = _$CommentBlankCopyWithImpl;
@useResult
$Res call({
 String value, bool correct, String answer
});




}
/// @nodoc
class _$CommentBlankCopyWithImpl<$Res>
    implements $CommentBlankCopyWith<$Res> {
  _$CommentBlankCopyWithImpl(this._self, this._then);

  final CommentBlank _self;
  final $Res Function(CommentBlank) _then;

/// Create a copy of CommentBlank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? correct = null,Object? answer = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentBlank].
extension CommentBlankPatterns on CommentBlank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentBlank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentBlank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentBlank value)  $default,){
final _that = this;
switch (_that) {
case _CommentBlank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentBlank value)?  $default,){
final _that = this;
switch (_that) {
case _CommentBlank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  bool correct,  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentBlank() when $default != null:
return $default(_that.value,_that.correct,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  bool correct,  String answer)  $default,) {final _that = this;
switch (_that) {
case _CommentBlank():
return $default(_that.value,_that.correct,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  bool correct,  String answer)?  $default,) {final _that = this;
switch (_that) {
case _CommentBlank() when $default != null:
return $default(_that.value,_that.correct,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentBlank implements CommentBlank {
  const _CommentBlank({this.value = '', this.correct = false, this.answer = ''});
  factory _CommentBlank.fromJson(Map<String, dynamic> json) => _$CommentBlankFromJson(json);

@override@JsonKey() final  String value;
@override@JsonKey() final  bool correct;
@override@JsonKey() final  String answer;

/// Create a copy of CommentBlank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentBlankCopyWith<_CommentBlank> get copyWith => __$CommentBlankCopyWithImpl<_CommentBlank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentBlankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentBlank&&(identical(other.value, value) || other.value == value)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,correct,answer);

@override
String toString() {
  return 'CommentBlank(value: $value, correct: $correct, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$CommentBlankCopyWith<$Res> implements $CommentBlankCopyWith<$Res> {
  factory _$CommentBlankCopyWith(_CommentBlank value, $Res Function(_CommentBlank) _then) = __$CommentBlankCopyWithImpl;
@override @useResult
$Res call({
 String value, bool correct, String answer
});




}
/// @nodoc
class __$CommentBlankCopyWithImpl<$Res>
    implements _$CommentBlankCopyWith<$Res> {
  __$CommentBlankCopyWithImpl(this._self, this._then);

  final _CommentBlank _self;
  final $Res Function(_CommentBlank) _then;

/// Create a copy of CommentBlank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? correct = null,Object? answer = null,}) {
  return _then(_CommentBlank(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CommentSubmitResult {

/// Every blank right.
 bool get correct;/// One per blank, in order.
 List<CommentBlank> get blanks;/// This was the day's first submission — the one that scores.
 bool get firstTry;/// What THIS submission paid.
 int get pointsApplied;/// The level after it: done, with the comment and the post's link, once
/// every blank is right.
 CommentLevelView get level;
/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentSubmitResultCopyWith<CommentSubmitResult> get copyWith => _$CommentSubmitResultCopyWithImpl<CommentSubmitResult>(this as CommentSubmitResult, _$identity);

  /// Serializes this CommentSubmitResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentSubmitResult&&(identical(other.correct, correct) || other.correct == correct)&&const DeepCollectionEquality().equals(other.blanks, blanks)&&(identical(other.firstTry, firstTry) || other.firstTry == firstTry)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,const DeepCollectionEquality().hash(blanks),firstTry,pointsApplied,level);

@override
String toString() {
  return 'CommentSubmitResult(correct: $correct, blanks: $blanks, firstTry: $firstTry, pointsApplied: $pointsApplied, level: $level)';
}


}

/// @nodoc
abstract mixin class $CommentSubmitResultCopyWith<$Res>  {
  factory $CommentSubmitResultCopyWith(CommentSubmitResult value, $Res Function(CommentSubmitResult) _then) = _$CommentSubmitResultCopyWithImpl;
@useResult
$Res call({
 bool correct, List<CommentBlank> blanks, bool firstTry, int pointsApplied, CommentLevelView level
});


$CommentLevelViewCopyWith<$Res> get level;

}
/// @nodoc
class _$CommentSubmitResultCopyWithImpl<$Res>
    implements $CommentSubmitResultCopyWith<$Res> {
  _$CommentSubmitResultCopyWithImpl(this._self, this._then);

  final CommentSubmitResult _self;
  final $Res Function(CommentSubmitResult) _then;

/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? blanks = null,Object? firstTry = null,Object? pointsApplied = null,Object? level = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,blanks: null == blanks ? _self.blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<CommentBlank>,firstTry: null == firstTry ? _self.firstTry : firstTry // ignore: cast_nullable_to_non_nullable
as bool,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CommentLevelView,
  ));
}
/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentLevelViewCopyWith<$Res> get level {
  
  return $CommentLevelViewCopyWith<$Res>(_self.level, (value) {
    return _then(_self.copyWith(level: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentSubmitResult].
extension CommentSubmitResultPatterns on CommentSubmitResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentSubmitResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentSubmitResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentSubmitResult value)  $default,){
final _that = this;
switch (_that) {
case _CommentSubmitResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentSubmitResult value)?  $default,){
final _that = this;
switch (_that) {
case _CommentSubmitResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool correct,  List<CommentBlank> blanks,  bool firstTry,  int pointsApplied,  CommentLevelView level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentSubmitResult() when $default != null:
return $default(_that.correct,_that.blanks,_that.firstTry,_that.pointsApplied,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool correct,  List<CommentBlank> blanks,  bool firstTry,  int pointsApplied,  CommentLevelView level)  $default,) {final _that = this;
switch (_that) {
case _CommentSubmitResult():
return $default(_that.correct,_that.blanks,_that.firstTry,_that.pointsApplied,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool correct,  List<CommentBlank> blanks,  bool firstTry,  int pointsApplied,  CommentLevelView level)?  $default,) {final _that = this;
switch (_that) {
case _CommentSubmitResult() when $default != null:
return $default(_that.correct,_that.blanks,_that.firstTry,_that.pointsApplied,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentSubmitResult implements CommentSubmitResult {
  const _CommentSubmitResult({this.correct = false, final  List<CommentBlank> blanks = const <CommentBlank>[], this.firstTry = false, this.pointsApplied = 0, required this.level}): _blanks = blanks;
  factory _CommentSubmitResult.fromJson(Map<String, dynamic> json) => _$CommentSubmitResultFromJson(json);

/// Every blank right.
@override@JsonKey() final  bool correct;
/// One per blank, in order.
 final  List<CommentBlank> _blanks;
/// One per blank, in order.
@override@JsonKey() List<CommentBlank> get blanks {
  if (_blanks is EqualUnmodifiableListView) return _blanks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blanks);
}

/// This was the day's first submission — the one that scores.
@override@JsonKey() final  bool firstTry;
/// What THIS submission paid.
@override@JsonKey() final  int pointsApplied;
/// The level after it: done, with the comment and the post's link, once
/// every blank is right.
@override final  CommentLevelView level;

/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentSubmitResultCopyWith<_CommentSubmitResult> get copyWith => __$CommentSubmitResultCopyWithImpl<_CommentSubmitResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentSubmitResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentSubmitResult&&(identical(other.correct, correct) || other.correct == correct)&&const DeepCollectionEquality().equals(other._blanks, _blanks)&&(identical(other.firstTry, firstTry) || other.firstTry == firstTry)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correct,const DeepCollectionEquality().hash(_blanks),firstTry,pointsApplied,level);

@override
String toString() {
  return 'CommentSubmitResult(correct: $correct, blanks: $blanks, firstTry: $firstTry, pointsApplied: $pointsApplied, level: $level)';
}


}

/// @nodoc
abstract mixin class _$CommentSubmitResultCopyWith<$Res> implements $CommentSubmitResultCopyWith<$Res> {
  factory _$CommentSubmitResultCopyWith(_CommentSubmitResult value, $Res Function(_CommentSubmitResult) _then) = __$CommentSubmitResultCopyWithImpl;
@override @useResult
$Res call({
 bool correct, List<CommentBlank> blanks, bool firstTry, int pointsApplied, CommentLevelView level
});


@override $CommentLevelViewCopyWith<$Res> get level;

}
/// @nodoc
class __$CommentSubmitResultCopyWithImpl<$Res>
    implements _$CommentSubmitResultCopyWith<$Res> {
  __$CommentSubmitResultCopyWithImpl(this._self, this._then);

  final _CommentSubmitResult _self;
  final $Res Function(_CommentSubmitResult) _then;

/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? blanks = null,Object? firstTry = null,Object? pointsApplied = null,Object? level = null,}) {
  return _then(_CommentSubmitResult(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,blanks: null == blanks ? _self._blanks : blanks // ignore: cast_nullable_to_non_nullable
as List<CommentBlank>,firstTry: null == firstTry ? _self.firstTry : firstTry // ignore: cast_nullable_to_non_nullable
as bool,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CommentLevelView,
  ));
}

/// Create a copy of CommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentLevelViewCopyWith<$Res> get level {
  
  return $CommentLevelViewCopyWith<$Res>(_self.level, (value) {
    return _then(_self.copyWith(level: value));
  });
}
}


/// @nodoc
mixin _$FeedCommentsView {

@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable) FeedCommentsStatus get status;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) FeedCommentsReason? get reason;/// How many links the day asks for.
 int get perDay;/// What the five pay IN TOTAL.
 int get points;/// What comment 1…5 pays; they sum to [points].
 List<int> get shares;/// What a false claim costs on top of what it paid. The warning before
/// the send button names it, and drops the clause when it is 0.
 int get penalty;/// Today's links so far, normalised, in the order sent.
 List<String> get links;/// What each of [links] paid. ABSENT on a day sent five-at-once (before
/// 11 Nov 2026) — null, not empty, so a page does not print "+0 XP"
/// beside links that were paid as one.
 List<int>? get linkPoints;/// What the day has paid so far.
 int? get pointsApplied; String? get revokeReason;/// The whole deduction a revoke wrote, as a positive number.
 int? get pointsDeducted;
/// Create a copy of FeedCommentsView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCommentsViewCopyWith<FeedCommentsView> get copyWith => _$FeedCommentsViewCopyWithImpl<FeedCommentsView>(this as FeedCommentsView, _$identity);

  /// Serializes this FeedCommentsView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedCommentsView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.perDay, perDay) || other.perDay == perDay)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other.shares, shares)&&(identical(other.penalty, penalty) || other.penalty == penalty)&&const DeepCollectionEquality().equals(other.links, links)&&const DeepCollectionEquality().equals(other.linkPoints, linkPoints)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.revokeReason, revokeReason) || other.revokeReason == revokeReason)&&(identical(other.pointsDeducted, pointsDeducted) || other.pointsDeducted == pointsDeducted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,perDay,points,const DeepCollectionEquality().hash(shares),penalty,const DeepCollectionEquality().hash(links),const DeepCollectionEquality().hash(linkPoints),pointsApplied,revokeReason,pointsDeducted);

@override
String toString() {
  return 'FeedCommentsView(status: $status, reason: $reason, perDay: $perDay, points: $points, shares: $shares, penalty: $penalty, links: $links, linkPoints: $linkPoints, pointsApplied: $pointsApplied, revokeReason: $revokeReason, pointsDeducted: $pointsDeducted)';
}


}

/// @nodoc
abstract mixin class $FeedCommentsViewCopyWith<$Res>  {
  factory $FeedCommentsViewCopyWith(FeedCommentsView value, $Res Function(FeedCommentsView) _then) = _$FeedCommentsViewCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable) FeedCommentsStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) FeedCommentsReason? reason, int perDay, int points, List<int> shares, int penalty, List<String> links, List<int>? linkPoints, int? pointsApplied, String? revokeReason, int? pointsDeducted
});




}
/// @nodoc
class _$FeedCommentsViewCopyWithImpl<$Res>
    implements $FeedCommentsViewCopyWith<$Res> {
  _$FeedCommentsViewCopyWithImpl(this._self, this._then);

  final FeedCommentsView _self;
  final $Res Function(FeedCommentsView) _then;

/// Create a copy of FeedCommentsView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? perDay = null,Object? points = null,Object? shares = null,Object? penalty = null,Object? links = null,Object? linkPoints = freezed,Object? pointsApplied = freezed,Object? revokeReason = freezed,Object? pointsDeducted = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedCommentsStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as FeedCommentsReason?,perDay: null == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as List<int>,penalty: null == penalty ? _self.penalty : penalty // ignore: cast_nullable_to_non_nullable
as int,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<String>,linkPoints: freezed == linkPoints ? _self.linkPoints : linkPoints // ignore: cast_nullable_to_non_nullable
as List<int>?,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,revokeReason: freezed == revokeReason ? _self.revokeReason : revokeReason // ignore: cast_nullable_to_non_nullable
as String?,pointsDeducted: freezed == pointsDeducted ? _self.pointsDeducted : pointsDeducted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedCommentsView].
extension FeedCommentsViewPatterns on FeedCommentsView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedCommentsView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedCommentsView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedCommentsView value)  $default,){
final _that = this;
switch (_that) {
case _FeedCommentsView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedCommentsView value)?  $default,){
final _that = this;
switch (_that) {
case _FeedCommentsView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable)  FeedCommentsStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  FeedCommentsReason? reason,  int perDay,  int points,  List<int> shares,  int penalty,  List<String> links,  List<int>? linkPoints,  int? pointsApplied,  String? revokeReason,  int? pointsDeducted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedCommentsView() when $default != null:
return $default(_that.status,_that.reason,_that.perDay,_that.points,_that.shares,_that.penalty,_that.links,_that.linkPoints,_that.pointsApplied,_that.revokeReason,_that.pointsDeducted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable)  FeedCommentsStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  FeedCommentsReason? reason,  int perDay,  int points,  List<int> shares,  int penalty,  List<String> links,  List<int>? linkPoints,  int? pointsApplied,  String? revokeReason,  int? pointsDeducted)  $default,) {final _that = this;
switch (_that) {
case _FeedCommentsView():
return $default(_that.status,_that.reason,_that.perDay,_that.points,_that.shares,_that.penalty,_that.links,_that.linkPoints,_that.pointsApplied,_that.revokeReason,_that.pointsDeducted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable)  FeedCommentsStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  FeedCommentsReason? reason,  int perDay,  int points,  List<int> shares,  int penalty,  List<String> links,  List<int>? linkPoints,  int? pointsApplied,  String? revokeReason,  int? pointsDeducted)?  $default,) {final _that = this;
switch (_that) {
case _FeedCommentsView() when $default != null:
return $default(_that.status,_that.reason,_that.perDay,_that.points,_that.shares,_that.penalty,_that.links,_that.linkPoints,_that.pointsApplied,_that.revokeReason,_that.pointsDeducted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedCommentsView extends FeedCommentsView {
  const _FeedCommentsView({@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable) this.status = FeedCommentsStatus.unavailable, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.reason, this.perDay = 5, this.points = 0, final  List<int> shares = const <int>[], this.penalty = 0, final  List<String> links = const <String>[], final  List<int>? linkPoints, this.pointsApplied, this.revokeReason, this.pointsDeducted}): _shares = shares,_links = links,_linkPoints = linkPoints,super._();
  factory _FeedCommentsView.fromJson(Map<String, dynamic> json) => _$FeedCommentsViewFromJson(json);

@override@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable) final  FeedCommentsStatus status;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  FeedCommentsReason? reason;
/// How many links the day asks for.
@override@JsonKey() final  int perDay;
/// What the five pay IN TOTAL.
@override@JsonKey() final  int points;
/// What comment 1…5 pays; they sum to [points].
 final  List<int> _shares;
/// What comment 1…5 pays; they sum to [points].
@override@JsonKey() List<int> get shares {
  if (_shares is EqualUnmodifiableListView) return _shares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shares);
}

/// What a false claim costs on top of what it paid. The warning before
/// the send button names it, and drops the clause when it is 0.
@override@JsonKey() final  int penalty;
/// Today's links so far, normalised, in the order sent.
 final  List<String> _links;
/// Today's links so far, normalised, in the order sent.
@override@JsonKey() List<String> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}

/// What each of [links] paid. ABSENT on a day sent five-at-once (before
/// 11 Nov 2026) — null, not empty, so a page does not print "+0 XP"
/// beside links that were paid as one.
 final  List<int>? _linkPoints;
/// What each of [links] paid. ABSENT on a day sent five-at-once (before
/// 11 Nov 2026) — null, not empty, so a page does not print "+0 XP"
/// beside links that were paid as one.
@override List<int>? get linkPoints {
  final value = _linkPoints;
  if (value == null) return null;
  if (_linkPoints is EqualUnmodifiableListView) return _linkPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// What the day has paid so far.
@override final  int? pointsApplied;
@override final  String? revokeReason;
/// The whole deduction a revoke wrote, as a positive number.
@override final  int? pointsDeducted;

/// Create a copy of FeedCommentsView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCommentsViewCopyWith<_FeedCommentsView> get copyWith => __$FeedCommentsViewCopyWithImpl<_FeedCommentsView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedCommentsViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedCommentsView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.perDay, perDay) || other.perDay == perDay)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other._shares, _shares)&&(identical(other.penalty, penalty) || other.penalty == penalty)&&const DeepCollectionEquality().equals(other._links, _links)&&const DeepCollectionEquality().equals(other._linkPoints, _linkPoints)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.revokeReason, revokeReason) || other.revokeReason == revokeReason)&&(identical(other.pointsDeducted, pointsDeducted) || other.pointsDeducted == pointsDeducted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,perDay,points,const DeepCollectionEquality().hash(_shares),penalty,const DeepCollectionEquality().hash(_links),const DeepCollectionEquality().hash(_linkPoints),pointsApplied,revokeReason,pointsDeducted);

@override
String toString() {
  return 'FeedCommentsView(status: $status, reason: $reason, perDay: $perDay, points: $points, shares: $shares, penalty: $penalty, links: $links, linkPoints: $linkPoints, pointsApplied: $pointsApplied, revokeReason: $revokeReason, pointsDeducted: $pointsDeducted)';
}


}

/// @nodoc
abstract mixin class _$FeedCommentsViewCopyWith<$Res> implements $FeedCommentsViewCopyWith<$Res> {
  factory _$FeedCommentsViewCopyWith(_FeedCommentsView value, $Res Function(_FeedCommentsView) _then) = __$FeedCommentsViewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: FeedCommentsStatus.unavailable) FeedCommentsStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) FeedCommentsReason? reason, int perDay, int points, List<int> shares, int penalty, List<String> links, List<int>? linkPoints, int? pointsApplied, String? revokeReason, int? pointsDeducted
});




}
/// @nodoc
class __$FeedCommentsViewCopyWithImpl<$Res>
    implements _$FeedCommentsViewCopyWith<$Res> {
  __$FeedCommentsViewCopyWithImpl(this._self, this._then);

  final _FeedCommentsView _self;
  final $Res Function(_FeedCommentsView) _then;

/// Create a copy of FeedCommentsView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? perDay = null,Object? points = null,Object? shares = null,Object? penalty = null,Object? links = null,Object? linkPoints = freezed,Object? pointsApplied = freezed,Object? revokeReason = freezed,Object? pointsDeducted = freezed,}) {
  return _then(_FeedCommentsView(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedCommentsStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as FeedCommentsReason?,perDay: null == perDay ? _self.perDay : perDay // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self._shares : shares // ignore: cast_nullable_to_non_nullable
as List<int>,penalty: null == penalty ? _self.penalty : penalty // ignore: cast_nullable_to_non_nullable
as int,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<String>,linkPoints: freezed == linkPoints ? _self._linkPoints : linkPoints // ignore: cast_nullable_to_non_nullable
as List<int>?,pointsApplied: freezed == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int?,revokeReason: freezed == revokeReason ? _self.revokeReason : revokeReason // ignore: cast_nullable_to_non_nullable
as String?,pointsDeducted: freezed == pointsDeducted ? _self.pointsDeducted : pointsDeducted // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FeedCommentSubmitResult {

 String get taskId;/// `done` once this was the fifth.
@JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open) FeedCommentSubmitStatus get status;/// Which comment of the day this was, 1…5.
 int get n;/// What the ledger paid for THIS comment; 0 while scoring is paused.
 int get pointsApplied;/// What the day has paid so far, this one included.
 int get dayPoints; List<String> get links;
/// Create a copy of FeedCommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedCommentSubmitResultCopyWith<FeedCommentSubmitResult> get copyWith => _$FeedCommentSubmitResultCopyWithImpl<FeedCommentSubmitResult>(this as FeedCommentSubmitResult, _$identity);

  /// Serializes this FeedCommentSubmitResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedCommentSubmitResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.n, n) || other.n == n)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.dayPoints, dayPoints) || other.dayPoints == dayPoints)&&const DeepCollectionEquality().equals(other.links, links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,n,pointsApplied,dayPoints,const DeepCollectionEquality().hash(links));

@override
String toString() {
  return 'FeedCommentSubmitResult(taskId: $taskId, status: $status, n: $n, pointsApplied: $pointsApplied, dayPoints: $dayPoints, links: $links)';
}


}

/// @nodoc
abstract mixin class $FeedCommentSubmitResultCopyWith<$Res>  {
  factory $FeedCommentSubmitResultCopyWith(FeedCommentSubmitResult value, $Res Function(FeedCommentSubmitResult) _then) = _$FeedCommentSubmitResultCopyWithImpl;
@useResult
$Res call({
 String taskId,@JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open) FeedCommentSubmitStatus status, int n, int pointsApplied, int dayPoints, List<String> links
});




}
/// @nodoc
class _$FeedCommentSubmitResultCopyWithImpl<$Res>
    implements $FeedCommentSubmitResultCopyWith<$Res> {
  _$FeedCommentSubmitResultCopyWithImpl(this._self, this._then);

  final FeedCommentSubmitResult _self;
  final $Res Function(FeedCommentSubmitResult) _then;

/// Create a copy of FeedCommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,Object? n = null,Object? pointsApplied = null,Object? dayPoints = null,Object? links = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedCommentSubmitStatus,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,dayPoints: null == dayPoints ? _self.dayPoints : dayPoints // ignore: cast_nullable_to_non_nullable
as int,links: null == links ? _self.links : links // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedCommentSubmitResult].
extension FeedCommentSubmitResultPatterns on FeedCommentSubmitResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedCommentSubmitResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedCommentSubmitResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedCommentSubmitResult value)  $default,){
final _that = this;
switch (_that) {
case _FeedCommentSubmitResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedCommentSubmitResult value)?  $default,){
final _that = this;
switch (_that) {
case _FeedCommentSubmitResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId, @JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open)  FeedCommentSubmitStatus status,  int n,  int pointsApplied,  int dayPoints,  List<String> links)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedCommentSubmitResult() when $default != null:
return $default(_that.taskId,_that.status,_that.n,_that.pointsApplied,_that.dayPoints,_that.links);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId, @JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open)  FeedCommentSubmitStatus status,  int n,  int pointsApplied,  int dayPoints,  List<String> links)  $default,) {final _that = this;
switch (_that) {
case _FeedCommentSubmitResult():
return $default(_that.taskId,_that.status,_that.n,_that.pointsApplied,_that.dayPoints,_that.links);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId, @JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open)  FeedCommentSubmitStatus status,  int n,  int pointsApplied,  int dayPoints,  List<String> links)?  $default,) {final _that = this;
switch (_that) {
case _FeedCommentSubmitResult() when $default != null:
return $default(_that.taskId,_that.status,_that.n,_that.pointsApplied,_that.dayPoints,_that.links);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedCommentSubmitResult implements FeedCommentSubmitResult {
  const _FeedCommentSubmitResult({this.taskId = '', @JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open) this.status = FeedCommentSubmitStatus.open, this.n = 1, this.pointsApplied = 0, this.dayPoints = 0, final  List<String> links = const <String>[]}): _links = links;
  factory _FeedCommentSubmitResult.fromJson(Map<String, dynamic> json) => _$FeedCommentSubmitResultFromJson(json);

@override@JsonKey() final  String taskId;
/// `done` once this was the fifth.
@override@JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open) final  FeedCommentSubmitStatus status;
/// Which comment of the day this was, 1…5.
@override@JsonKey() final  int n;
/// What the ledger paid for THIS comment; 0 while scoring is paused.
@override@JsonKey() final  int pointsApplied;
/// What the day has paid so far, this one included.
@override@JsonKey() final  int dayPoints;
 final  List<String> _links;
@override@JsonKey() List<String> get links {
  if (_links is EqualUnmodifiableListView) return _links;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_links);
}


/// Create a copy of FeedCommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedCommentSubmitResultCopyWith<_FeedCommentSubmitResult> get copyWith => __$FeedCommentSubmitResultCopyWithImpl<_FeedCommentSubmitResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedCommentSubmitResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedCommentSubmitResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.n, n) || other.n == n)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.dayPoints, dayPoints) || other.dayPoints == dayPoints)&&const DeepCollectionEquality().equals(other._links, _links));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,n,pointsApplied,dayPoints,const DeepCollectionEquality().hash(_links));

@override
String toString() {
  return 'FeedCommentSubmitResult(taskId: $taskId, status: $status, n: $n, pointsApplied: $pointsApplied, dayPoints: $dayPoints, links: $links)';
}


}

/// @nodoc
abstract mixin class _$FeedCommentSubmitResultCopyWith<$Res> implements $FeedCommentSubmitResultCopyWith<$Res> {
  factory _$FeedCommentSubmitResultCopyWith(_FeedCommentSubmitResult value, $Res Function(_FeedCommentSubmitResult) _then) = __$FeedCommentSubmitResultCopyWithImpl;
@override @useResult
$Res call({
 String taskId,@JsonKey(unknownEnumValue: FeedCommentSubmitStatus.open) FeedCommentSubmitStatus status, int n, int pointsApplied, int dayPoints, List<String> links
});




}
/// @nodoc
class __$FeedCommentSubmitResultCopyWithImpl<$Res>
    implements _$FeedCommentSubmitResultCopyWith<$Res> {
  __$FeedCommentSubmitResultCopyWithImpl(this._self, this._then);

  final _FeedCommentSubmitResult _self;
  final $Res Function(_FeedCommentSubmitResult) _then;

/// Create a copy of FeedCommentSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,Object? n = null,Object? pointsApplied = null,Object? dayPoints = null,Object? links = null,}) {
  return _then(_FeedCommentSubmitResult(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FeedCommentSubmitStatus,n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,dayPoints: null == dayPoints ? _self.dayPoints : dayPoints // ignore: cast_nullable_to_non_nullable
as int,links: null == links ? _self._links : links // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ConnectTaskResult {

 String get taskId; String get status;/// What the ledger paid; 0 while scoring is paused, and on a repeat what
/// it paid the first time.
 int get pointsApplied;/// Already done today — nothing was paid by this request.
 bool get alreadyDone;
/// Create a copy of ConnectTaskResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectTaskResultCopyWith<ConnectTaskResult> get copyWith => _$ConnectTaskResultCopyWithImpl<ConnectTaskResult>(this as ConnectTaskResult, _$identity);

  /// Serializes this ConnectTaskResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectTaskResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.alreadyDone, alreadyDone) || other.alreadyDone == alreadyDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,pointsApplied,alreadyDone);

@override
String toString() {
  return 'ConnectTaskResult(taskId: $taskId, status: $status, pointsApplied: $pointsApplied, alreadyDone: $alreadyDone)';
}


}

/// @nodoc
abstract mixin class $ConnectTaskResultCopyWith<$Res>  {
  factory $ConnectTaskResultCopyWith(ConnectTaskResult value, $Res Function(ConnectTaskResult) _then) = _$ConnectTaskResultCopyWithImpl;
@useResult
$Res call({
 String taskId, String status, int pointsApplied, bool alreadyDone
});




}
/// @nodoc
class _$ConnectTaskResultCopyWithImpl<$Res>
    implements $ConnectTaskResultCopyWith<$Res> {
  _$ConnectTaskResultCopyWithImpl(this._self, this._then);

  final ConnectTaskResult _self;
  final $Res Function(ConnectTaskResult) _then;

/// Create a copy of ConnectTaskResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,Object? pointsApplied = null,Object? alreadyDone = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,alreadyDone: null == alreadyDone ? _self.alreadyDone : alreadyDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectTaskResult].
extension ConnectTaskResultPatterns on ConnectTaskResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectTaskResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectTaskResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectTaskResult value)  $default,){
final _that = this;
switch (_that) {
case _ConnectTaskResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectTaskResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectTaskResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String status,  int pointsApplied,  bool alreadyDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectTaskResult() when $default != null:
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.alreadyDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String status,  int pointsApplied,  bool alreadyDone)  $default,) {final _that = this;
switch (_that) {
case _ConnectTaskResult():
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.alreadyDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String status,  int pointsApplied,  bool alreadyDone)?  $default,) {final _that = this;
switch (_that) {
case _ConnectTaskResult() when $default != null:
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.alreadyDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectTaskResult implements ConnectTaskResult {
  const _ConnectTaskResult({this.taskId = '', this.status = 'done', this.pointsApplied = 0, this.alreadyDone = false});
  factory _ConnectTaskResult.fromJson(Map<String, dynamic> json) => _$ConnectTaskResultFromJson(json);

@override@JsonKey() final  String taskId;
@override@JsonKey() final  String status;
/// What the ledger paid; 0 while scoring is paused, and on a repeat what
/// it paid the first time.
@override@JsonKey() final  int pointsApplied;
/// Already done today — nothing was paid by this request.
@override@JsonKey() final  bool alreadyDone;

/// Create a copy of ConnectTaskResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectTaskResultCopyWith<_ConnectTaskResult> get copyWith => __$ConnectTaskResultCopyWithImpl<_ConnectTaskResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectTaskResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectTaskResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.alreadyDone, alreadyDone) || other.alreadyDone == alreadyDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,pointsApplied,alreadyDone);

@override
String toString() {
  return 'ConnectTaskResult(taskId: $taskId, status: $status, pointsApplied: $pointsApplied, alreadyDone: $alreadyDone)';
}


}

/// @nodoc
abstract mixin class _$ConnectTaskResultCopyWith<$Res> implements $ConnectTaskResultCopyWith<$Res> {
  factory _$ConnectTaskResultCopyWith(_ConnectTaskResult value, $Res Function(_ConnectTaskResult) _then) = __$ConnectTaskResultCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String status, int pointsApplied, bool alreadyDone
});




}
/// @nodoc
class __$ConnectTaskResultCopyWithImpl<$Res>
    implements _$ConnectTaskResultCopyWith<$Res> {
  __$ConnectTaskResultCopyWithImpl(this._self, this._then);

  final _ConnectTaskResult _self;
  final $Res Function(_ConnectTaskResult) _then;

/// Create a copy of ConnectTaskResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,Object? pointsApplied = null,Object? alreadyDone = null,}) {
  return _then(_ConnectTaskResult(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,alreadyDone: null == alreadyDone ? _self.alreadyDone : alreadyDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$InvitesSubmitResult {

 String get taskId; String get status;/// What the ledger paid; 0 while scoring is paused.
 int get pointsApplied;/// It replaced a screenshot sent under the old review flow.
 bool get replaced;
/// Create a copy of InvitesSubmitResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitesSubmitResultCopyWith<InvitesSubmitResult> get copyWith => _$InvitesSubmitResultCopyWithImpl<InvitesSubmitResult>(this as InvitesSubmitResult, _$identity);

  /// Serializes this InvitesSubmitResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitesSubmitResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.replaced, replaced) || other.replaced == replaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,pointsApplied,replaced);

@override
String toString() {
  return 'InvitesSubmitResult(taskId: $taskId, status: $status, pointsApplied: $pointsApplied, replaced: $replaced)';
}


}

/// @nodoc
abstract mixin class $InvitesSubmitResultCopyWith<$Res>  {
  factory $InvitesSubmitResultCopyWith(InvitesSubmitResult value, $Res Function(InvitesSubmitResult) _then) = _$InvitesSubmitResultCopyWithImpl;
@useResult
$Res call({
 String taskId, String status, int pointsApplied, bool replaced
});




}
/// @nodoc
class _$InvitesSubmitResultCopyWithImpl<$Res>
    implements $InvitesSubmitResultCopyWith<$Res> {
  _$InvitesSubmitResultCopyWithImpl(this._self, this._then);

  final InvitesSubmitResult _self;
  final $Res Function(InvitesSubmitResult) _then;

/// Create a copy of InvitesSubmitResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,Object? pointsApplied = null,Object? replaced = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,replaced: null == replaced ? _self.replaced : replaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitesSubmitResult].
extension InvitesSubmitResultPatterns on InvitesSubmitResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitesSubmitResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitesSubmitResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitesSubmitResult value)  $default,){
final _that = this;
switch (_that) {
case _InvitesSubmitResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitesSubmitResult value)?  $default,){
final _that = this;
switch (_that) {
case _InvitesSubmitResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String status,  int pointsApplied,  bool replaced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitesSubmitResult() when $default != null:
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.replaced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String status,  int pointsApplied,  bool replaced)  $default,) {final _that = this;
switch (_that) {
case _InvitesSubmitResult():
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.replaced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String status,  int pointsApplied,  bool replaced)?  $default,) {final _that = this;
switch (_that) {
case _InvitesSubmitResult() when $default != null:
return $default(_that.taskId,_that.status,_that.pointsApplied,_that.replaced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitesSubmitResult implements InvitesSubmitResult {
  const _InvitesSubmitResult({this.taskId = '', this.status = 'done', this.pointsApplied = 0, this.replaced = false});
  factory _InvitesSubmitResult.fromJson(Map<String, dynamic> json) => _$InvitesSubmitResultFromJson(json);

@override@JsonKey() final  String taskId;
@override@JsonKey() final  String status;
/// What the ledger paid; 0 while scoring is paused.
@override@JsonKey() final  int pointsApplied;
/// It replaced a screenshot sent under the old review flow.
@override@JsonKey() final  bool replaced;

/// Create a copy of InvitesSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitesSubmitResultCopyWith<_InvitesSubmitResult> get copyWith => __$InvitesSubmitResultCopyWithImpl<_InvitesSubmitResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitesSubmitResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitesSubmitResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pointsApplied, pointsApplied) || other.pointsApplied == pointsApplied)&&(identical(other.replaced, replaced) || other.replaced == replaced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,pointsApplied,replaced);

@override
String toString() {
  return 'InvitesSubmitResult(taskId: $taskId, status: $status, pointsApplied: $pointsApplied, replaced: $replaced)';
}


}

/// @nodoc
abstract mixin class _$InvitesSubmitResultCopyWith<$Res> implements $InvitesSubmitResultCopyWith<$Res> {
  factory _$InvitesSubmitResultCopyWith(_InvitesSubmitResult value, $Res Function(_InvitesSubmitResult) _then) = __$InvitesSubmitResultCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String status, int pointsApplied, bool replaced
});




}
/// @nodoc
class __$InvitesSubmitResultCopyWithImpl<$Res>
    implements _$InvitesSubmitResultCopyWith<$Res> {
  __$InvitesSubmitResultCopyWithImpl(this._self, this._then);

  final _InvitesSubmitResult _self;
  final $Res Function(_InvitesSubmitResult) _then;

/// Create a copy of InvitesSubmitResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,Object? pointsApplied = null,Object? replaced = null,}) {
  return _then(_InvitesSubmitResult(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pointsApplied: null == pointsApplied ? _self.pointsApplied : pointsApplied // ignore: cast_nullable_to_non_nullable
as int,replaced: null == replaced ? _self.replaced : replaced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PlanWeekDay {

/// WEEK_SHAPE's index: 0 = Monday … 6 = Sunday. The days ARRIVE in
/// calendar order, the week's Sunday first.
 int get index;/// "Wednesday".
 String get weekday;/// `YYYY-MM-DD`, the planner's own date for the slot, in the USER's
/// timezone.
 String get dayKey;@JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire) DayKind get kind; String? get title;/// The server's words: "Approved and scheduled", "Script ready", "Rest".
 String get status;/// Ready for its day. Drives the tick.
 bool get ready;/// What to do with it, and when its link is asked for — written by the
/// server, date included.
 String get instruction;
/// Create a copy of PlanWeekDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanWeekDayCopyWith<PlanWeekDay> get copyWith => _$PlanWeekDayCopyWithImpl<PlanWeekDay>(this as PlanWeekDay, _$identity);

  /// Serializes this PlanWeekDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanWeekDay&&(identical(other.index, index) || other.index == index)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,weekday,dayKey,kind,title,status,ready,instruction);

@override
String toString() {
  return 'PlanWeekDay(index: $index, weekday: $weekday, dayKey: $dayKey, kind: $kind, title: $title, status: $status, ready: $ready, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class $PlanWeekDayCopyWith<$Res>  {
  factory $PlanWeekDayCopyWith(PlanWeekDay value, $Res Function(PlanWeekDay) _then) = _$PlanWeekDayCopyWithImpl;
@useResult
$Res call({
 int index, String weekday, String dayKey,@JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire) DayKind kind, String? title, String status, bool ready, String instruction
});




}
/// @nodoc
class _$PlanWeekDayCopyWithImpl<$Res>
    implements $PlanWeekDayCopyWith<$Res> {
  _$PlanWeekDayCopyWithImpl(this._self, this._then);

  final PlanWeekDay _self;
  final $Res Function(PlanWeekDay) _then;

/// Create a copy of PlanWeekDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? weekday = null,Object? dayKey = null,Object? kind = null,Object? title = freezed,Object? status = null,Object? ready = null,Object? instruction = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanWeekDay].
extension PlanWeekDayPatterns on PlanWeekDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanWeekDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanWeekDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanWeekDay value)  $default,){
final _that = this;
switch (_that) {
case _PlanWeekDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanWeekDay value)?  $default,){
final _that = this;
switch (_that) {
case _PlanWeekDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String weekday,  String dayKey, @JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire)  DayKind kind,  String? title,  String status,  bool ready,  String instruction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanWeekDay() when $default != null:
return $default(_that.index,_that.weekday,_that.dayKey,_that.kind,_that.title,_that.status,_that.ready,_that.instruction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String weekday,  String dayKey, @JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire)  DayKind kind,  String? title,  String status,  bool ready,  String instruction)  $default,) {final _that = this;
switch (_that) {
case _PlanWeekDay():
return $default(_that.index,_that.weekday,_that.dayKey,_that.kind,_that.title,_that.status,_that.ready,_that.instruction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String weekday,  String dayKey, @JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire)  DayKind kind,  String? title,  String status,  bool ready,  String instruction)?  $default,) {final _that = this;
switch (_that) {
case _PlanWeekDay() when $default != null:
return $default(_that.index,_that.weekday,_that.dayKey,_that.kind,_that.title,_that.status,_that.ready,_that.instruction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanWeekDay implements PlanWeekDay {
  const _PlanWeekDay({this.index = 0, this.weekday = '', this.dayKey = '', @JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire) this.kind = DayKind.post, this.title, this.status = '', this.ready = false, this.instruction = ''});
  factory _PlanWeekDay.fromJson(Map<String, dynamic> json) => _$PlanWeekDayFromJson(json);

/// WEEK_SHAPE's index: 0 = Monday … 6 = Sunday. The days ARRIVE in
/// calendar order, the week's Sunday first.
@override@JsonKey() final  int index;
/// "Wednesday".
@override@JsonKey() final  String weekday;
/// `YYYY-MM-DD`, the planner's own date for the slot, in the USER's
/// timezone.
@override@JsonKey() final  String dayKey;
@override@JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire) final  DayKind kind;
@override final  String? title;
/// The server's words: "Approved and scheduled", "Script ready", "Rest".
@override@JsonKey() final  String status;
/// Ready for its day. Drives the tick.
@override@JsonKey() final  bool ready;
/// What to do with it, and when its link is asked for — written by the
/// server, date included.
@override@JsonKey() final  String instruction;

/// Create a copy of PlanWeekDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanWeekDayCopyWith<_PlanWeekDay> get copyWith => __$PlanWeekDayCopyWithImpl<_PlanWeekDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanWeekDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanWeekDay&&(identical(other.index, index) || other.index == index)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.dayKey, dayKey) || other.dayKey == dayKey)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.instruction, instruction) || other.instruction == instruction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,weekday,dayKey,kind,title,status,ready,instruction);

@override
String toString() {
  return 'PlanWeekDay(index: $index, weekday: $weekday, dayKey: $dayKey, kind: $kind, title: $title, status: $status, ready: $ready, instruction: $instruction)';
}


}

/// @nodoc
abstract mixin class _$PlanWeekDayCopyWith<$Res> implements $PlanWeekDayCopyWith<$Res> {
  factory _$PlanWeekDayCopyWith(_PlanWeekDay value, $Res Function(_PlanWeekDay) _then) = __$PlanWeekDayCopyWithImpl;
@override @useResult
$Res call({
 int index, String weekday, String dayKey,@JsonKey(fromJson: DayKind.parse, toJson: _dayKindWire) DayKind kind, String? title, String status, bool ready, String instruction
});




}
/// @nodoc
class __$PlanWeekDayCopyWithImpl<$Res>
    implements _$PlanWeekDayCopyWith<$Res> {
  __$PlanWeekDayCopyWithImpl(this._self, this._then);

  final _PlanWeekDay _self;
  final $Res Function(_PlanWeekDay) _then;

/// Create a copy of PlanWeekDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? weekday = null,Object? dayKey = null,Object? kind = null,Object? title = freezed,Object? status = null,Object? ready = null,Object? instruction = null,}) {
  return _then(_PlanWeekDay(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as String,dayKey: null == dayKey ? _self.dayKey : dayKey // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PlanWeekView {

@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable) PlanWeekStatus get status;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) PlanWeekReason? get reason;/// "Unlocks after …" while locked.
 String? get lockedDetail;/// The planner week planned — on a Sunday, the week it starts — and its
/// journey number.
 int get weekNumber; int get season;/// The week exists in the Planner. "I've planned this week" waits on it.
 bool get planned; String? get topic;/// A WEB path (`/planner?week=N`). The app opens its own Planner.
 String get plannerHref; List<PlanWeekDay> get days;
/// Create a copy of PlanWeekView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanWeekViewCopyWith<PlanWeekView> get copyWith => _$PlanWeekViewCopyWithImpl<PlanWeekView>(this as PlanWeekView, _$identity);

  /// Serializes this PlanWeekView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanWeekView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.lockedDetail, lockedDetail) || other.lockedDetail == lockedDetail)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.plannerHref, plannerHref) || other.plannerHref == plannerHref)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,lockedDetail,weekNumber,season,planned,topic,plannerHref,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'PlanWeekView(status: $status, reason: $reason, lockedDetail: $lockedDetail, weekNumber: $weekNumber, season: $season, planned: $planned, topic: $topic, plannerHref: $plannerHref, days: $days)';
}


}

/// @nodoc
abstract mixin class $PlanWeekViewCopyWith<$Res>  {
  factory $PlanWeekViewCopyWith(PlanWeekView value, $Res Function(PlanWeekView) _then) = _$PlanWeekViewCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable) PlanWeekStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) PlanWeekReason? reason, String? lockedDetail, int weekNumber, int season, bool planned, String? topic, String plannerHref, List<PlanWeekDay> days
});




}
/// @nodoc
class _$PlanWeekViewCopyWithImpl<$Res>
    implements $PlanWeekViewCopyWith<$Res> {
  _$PlanWeekViewCopyWithImpl(this._self, this._then);

  final PlanWeekView _self;
  final $Res Function(PlanWeekView) _then;

/// Create a copy of PlanWeekView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? lockedDetail = freezed,Object? weekNumber = null,Object? season = null,Object? planned = null,Object? topic = freezed,Object? plannerHref = null,Object? days = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanWeekStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as PlanWeekReason?,lockedDetail: freezed == lockedDetail ? _self.lockedDetail : lockedDetail // ignore: cast_nullable_to_non_nullable
as String?,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as bool,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,plannerHref: null == plannerHref ? _self.plannerHref : plannerHref // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<PlanWeekDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanWeekView].
extension PlanWeekViewPatterns on PlanWeekView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanWeekView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanWeekView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanWeekView value)  $default,){
final _that = this;
switch (_that) {
case _PlanWeekView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanWeekView value)?  $default,){
final _that = this;
switch (_that) {
case _PlanWeekView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable)  PlanWeekStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  PlanWeekReason? reason,  String? lockedDetail,  int weekNumber,  int season,  bool planned,  String? topic,  String plannerHref,  List<PlanWeekDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanWeekView() when $default != null:
return $default(_that.status,_that.reason,_that.lockedDetail,_that.weekNumber,_that.season,_that.planned,_that.topic,_that.plannerHref,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable)  PlanWeekStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  PlanWeekReason? reason,  String? lockedDetail,  int weekNumber,  int season,  bool planned,  String? topic,  String plannerHref,  List<PlanWeekDay> days)  $default,) {final _that = this;
switch (_that) {
case _PlanWeekView():
return $default(_that.status,_that.reason,_that.lockedDetail,_that.weekNumber,_that.season,_that.planned,_that.topic,_that.plannerHref,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable)  PlanWeekStatus status, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  PlanWeekReason? reason,  String? lockedDetail,  int weekNumber,  int season,  bool planned,  String? topic,  String plannerHref,  List<PlanWeekDay> days)?  $default,) {final _that = this;
switch (_that) {
case _PlanWeekView() when $default != null:
return $default(_that.status,_that.reason,_that.lockedDetail,_that.weekNumber,_that.season,_that.planned,_that.topic,_that.plannerHref,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanWeekView implements PlanWeekView {
  const _PlanWeekView({@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable) this.status = PlanWeekStatus.unavailable, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) this.reason, this.lockedDetail, this.weekNumber = 1, this.season = 1, this.planned = false, this.topic, this.plannerHref = '', final  List<PlanWeekDay> days = const <PlanWeekDay>[]}): _days = days;
  factory _PlanWeekView.fromJson(Map<String, dynamic> json) => _$PlanWeekViewFromJson(json);

@override@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable) final  PlanWeekStatus status;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) final  PlanWeekReason? reason;
/// "Unlocks after …" while locked.
@override final  String? lockedDetail;
/// The planner week planned — on a Sunday, the week it starts — and its
/// journey number.
@override@JsonKey() final  int weekNumber;
@override@JsonKey() final  int season;
/// The week exists in the Planner. "I've planned this week" waits on it.
@override@JsonKey() final  bool planned;
@override final  String? topic;
/// A WEB path (`/planner?week=N`). The app opens its own Planner.
@override@JsonKey() final  String plannerHref;
 final  List<PlanWeekDay> _days;
@override@JsonKey() List<PlanWeekDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of PlanWeekView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanWeekViewCopyWith<_PlanWeekView> get copyWith => __$PlanWeekViewCopyWithImpl<_PlanWeekView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanWeekViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanWeekView&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.lockedDetail, lockedDetail) || other.lockedDetail == lockedDetail)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.plannerHref, plannerHref) || other.plannerHref == plannerHref)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,lockedDetail,weekNumber,season,planned,topic,plannerHref,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'PlanWeekView(status: $status, reason: $reason, lockedDetail: $lockedDetail, weekNumber: $weekNumber, season: $season, planned: $planned, topic: $topic, plannerHref: $plannerHref, days: $days)';
}


}

/// @nodoc
abstract mixin class _$PlanWeekViewCopyWith<$Res> implements $PlanWeekViewCopyWith<$Res> {
  factory _$PlanWeekViewCopyWith(_PlanWeekView value, $Res Function(_PlanWeekView) _then) = __$PlanWeekViewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: PlanWeekStatus.unavailable) PlanWeekStatus status,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) PlanWeekReason? reason, String? lockedDetail, int weekNumber, int season, bool planned, String? topic, String plannerHref, List<PlanWeekDay> days
});




}
/// @nodoc
class __$PlanWeekViewCopyWithImpl<$Res>
    implements _$PlanWeekViewCopyWith<$Res> {
  __$PlanWeekViewCopyWithImpl(this._self, this._then);

  final _PlanWeekView _self;
  final $Res Function(_PlanWeekView) _then;

/// Create a copy of PlanWeekView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? lockedDetail = freezed,Object? weekNumber = null,Object? season = null,Object? planned = null,Object? topic = freezed,Object? plannerHref = null,Object? days = null,}) {
  return _then(_PlanWeekView(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanWeekStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as PlanWeekReason?,lockedDetail: freezed == lockedDetail ? _self.lockedDetail : lockedDetail // ignore: cast_nullable_to_non_nullable
as String?,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as bool,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,plannerHref: null == plannerHref ? _self.plannerHref : plannerHref // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<PlanWeekDay>,
  ));
}


}


/// @nodoc
mixin _$PlanWeekResult {

 String get taskId; String get status;/// Already marked today — nothing changed.
 bool get alreadyDone;
/// Create a copy of PlanWeekResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanWeekResultCopyWith<PlanWeekResult> get copyWith => _$PlanWeekResultCopyWithImpl<PlanWeekResult>(this as PlanWeekResult, _$identity);

  /// Serializes this PlanWeekResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanWeekResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.alreadyDone, alreadyDone) || other.alreadyDone == alreadyDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,alreadyDone);

@override
String toString() {
  return 'PlanWeekResult(taskId: $taskId, status: $status, alreadyDone: $alreadyDone)';
}


}

/// @nodoc
abstract mixin class $PlanWeekResultCopyWith<$Res>  {
  factory $PlanWeekResultCopyWith(PlanWeekResult value, $Res Function(PlanWeekResult) _then) = _$PlanWeekResultCopyWithImpl;
@useResult
$Res call({
 String taskId, String status, bool alreadyDone
});




}
/// @nodoc
class _$PlanWeekResultCopyWithImpl<$Res>
    implements $PlanWeekResultCopyWith<$Res> {
  _$PlanWeekResultCopyWithImpl(this._self, this._then);

  final PlanWeekResult _self;
  final $Res Function(PlanWeekResult) _then;

/// Create a copy of PlanWeekResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? status = null,Object? alreadyDone = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,alreadyDone: null == alreadyDone ? _self.alreadyDone : alreadyDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanWeekResult].
extension PlanWeekResultPatterns on PlanWeekResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanWeekResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanWeekResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanWeekResult value)  $default,){
final _that = this;
switch (_that) {
case _PlanWeekResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanWeekResult value)?  $default,){
final _that = this;
switch (_that) {
case _PlanWeekResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String status,  bool alreadyDone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanWeekResult() when $default != null:
return $default(_that.taskId,_that.status,_that.alreadyDone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String status,  bool alreadyDone)  $default,) {final _that = this;
switch (_that) {
case _PlanWeekResult():
return $default(_that.taskId,_that.status,_that.alreadyDone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String status,  bool alreadyDone)?  $default,) {final _that = this;
switch (_that) {
case _PlanWeekResult() when $default != null:
return $default(_that.taskId,_that.status,_that.alreadyDone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanWeekResult implements PlanWeekResult {
  const _PlanWeekResult({this.taskId = '', this.status = 'done', this.alreadyDone = false});
  factory _PlanWeekResult.fromJson(Map<String, dynamic> json) => _$PlanWeekResultFromJson(json);

@override@JsonKey() final  String taskId;
@override@JsonKey() final  String status;
/// Already marked today — nothing changed.
@override@JsonKey() final  bool alreadyDone;

/// Create a copy of PlanWeekResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanWeekResultCopyWith<_PlanWeekResult> get copyWith => __$PlanWeekResultCopyWithImpl<_PlanWeekResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanWeekResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanWeekResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.status, status) || other.status == status)&&(identical(other.alreadyDone, alreadyDone) || other.alreadyDone == alreadyDone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,status,alreadyDone);

@override
String toString() {
  return 'PlanWeekResult(taskId: $taskId, status: $status, alreadyDone: $alreadyDone)';
}


}

/// @nodoc
abstract mixin class _$PlanWeekResultCopyWith<$Res> implements $PlanWeekResultCopyWith<$Res> {
  factory _$PlanWeekResultCopyWith(_PlanWeekResult value, $Res Function(_PlanWeekResult) _then) = __$PlanWeekResultCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String status, bool alreadyDone
});




}
/// @nodoc
class __$PlanWeekResultCopyWithImpl<$Res>
    implements _$PlanWeekResultCopyWith<$Res> {
  __$PlanWeekResultCopyWithImpl(this._self, this._then);

  final _PlanWeekResult _self;
  final $Res Function(_PlanWeekResult) _then;

/// Create a copy of PlanWeekResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? status = null,Object? alreadyDone = null,}) {
  return _then(_PlanWeekResult(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,alreadyDone: null == alreadyDone ? _self.alreadyDone : alreadyDone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ClaimResult {

 String get taskId; PostClaim get claim;
/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClaimResultCopyWith<ClaimResult> get copyWith => _$ClaimResultCopyWithImpl<ClaimResult>(this as ClaimResult, _$identity);

  /// Serializes this ClaimResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClaimResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.claim, claim) || other.claim == claim));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,claim);

@override
String toString() {
  return 'ClaimResult(taskId: $taskId, claim: $claim)';
}


}

/// @nodoc
abstract mixin class $ClaimResultCopyWith<$Res>  {
  factory $ClaimResultCopyWith(ClaimResult value, $Res Function(ClaimResult) _then) = _$ClaimResultCopyWithImpl;
@useResult
$Res call({
 String taskId, PostClaim claim
});


$PostClaimCopyWith<$Res> get claim;

}
/// @nodoc
class _$ClaimResultCopyWithImpl<$Res>
    implements $ClaimResultCopyWith<$Res> {
  _$ClaimResultCopyWithImpl(this._self, this._then);

  final ClaimResult _self;
  final $Res Function(ClaimResult) _then;

/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? claim = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,claim: null == claim ? _self.claim : claim // ignore: cast_nullable_to_non_nullable
as PostClaim,
  ));
}
/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostClaimCopyWith<$Res> get claim {
  
  return $PostClaimCopyWith<$Res>(_self.claim, (value) {
    return _then(_self.copyWith(claim: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClaimResult].
extension ClaimResultPatterns on ClaimResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClaimResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClaimResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClaimResult value)  $default,){
final _that = this;
switch (_that) {
case _ClaimResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClaimResult value)?  $default,){
final _that = this;
switch (_that) {
case _ClaimResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  PostClaim claim)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClaimResult() when $default != null:
return $default(_that.taskId,_that.claim);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  PostClaim claim)  $default,) {final _that = this;
switch (_that) {
case _ClaimResult():
return $default(_that.taskId,_that.claim);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  PostClaim claim)?  $default,) {final _that = this;
switch (_that) {
case _ClaimResult() when $default != null:
return $default(_that.taskId,_that.claim);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClaimResult implements ClaimResult {
  const _ClaimResult({this.taskId = '', required this.claim});
  factory _ClaimResult.fromJson(Map<String, dynamic> json) => _$ClaimResultFromJson(json);

@override@JsonKey() final  String taskId;
@override final  PostClaim claim;

/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClaimResultCopyWith<_ClaimResult> get copyWith => __$ClaimResultCopyWithImpl<_ClaimResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClaimResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClaimResult&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.claim, claim) || other.claim == claim));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,claim);

@override
String toString() {
  return 'ClaimResult(taskId: $taskId, claim: $claim)';
}


}

/// @nodoc
abstract mixin class _$ClaimResultCopyWith<$Res> implements $ClaimResultCopyWith<$Res> {
  factory _$ClaimResultCopyWith(_ClaimResult value, $Res Function(_ClaimResult) _then) = __$ClaimResultCopyWithImpl;
@override @useResult
$Res call({
 String taskId, PostClaim claim
});


@override $PostClaimCopyWith<$Res> get claim;

}
/// @nodoc
class __$ClaimResultCopyWithImpl<$Res>
    implements _$ClaimResultCopyWith<$Res> {
  __$ClaimResultCopyWithImpl(this._self, this._then);

  final _ClaimResult _self;
  final $Res Function(_ClaimResult) _then;

/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? claim = null,}) {
  return _then(_ClaimResult(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,claim: null == claim ? _self.claim : claim // ignore: cast_nullable_to_non_nullable
as PostClaim,
  ));
}

/// Create a copy of ClaimResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostClaimCopyWith<$Res> get claim {
  
  return $PostClaimCopyWith<$Res>(_self.claim, (value) {
    return _then(_self.copyWith(claim: value));
  });
}
}


/// @nodoc
mixin _$SkipResult {

/// The node skipped, as sent.
 String get nodeId;/// It was already skipped (a repeat, or another device): nothing new was
/// written. Still a success.
 bool get alreadySkipped;
/// Create a copy of SkipResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipResultCopyWith<SkipResult> get copyWith => _$SkipResultCopyWithImpl<SkipResult>(this as SkipResult, _$identity);

  /// Serializes this SkipResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipResult&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.alreadySkipped, alreadySkipped) || other.alreadySkipped == alreadySkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,alreadySkipped);

@override
String toString() {
  return 'SkipResult(nodeId: $nodeId, alreadySkipped: $alreadySkipped)';
}


}

/// @nodoc
abstract mixin class $SkipResultCopyWith<$Res>  {
  factory $SkipResultCopyWith(SkipResult value, $Res Function(SkipResult) _then) = _$SkipResultCopyWithImpl;
@useResult
$Res call({
 String nodeId, bool alreadySkipped
});




}
/// @nodoc
class _$SkipResultCopyWithImpl<$Res>
    implements $SkipResultCopyWith<$Res> {
  _$SkipResultCopyWithImpl(this._self, this._then);

  final SkipResult _self;
  final $Res Function(SkipResult) _then;

/// Create a copy of SkipResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? alreadySkipped = null,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,alreadySkipped: null == alreadySkipped ? _self.alreadySkipped : alreadySkipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SkipResult].
extension SkipResultPatterns on SkipResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SkipResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SkipResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SkipResult value)  $default,){
final _that = this;
switch (_that) {
case _SkipResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SkipResult value)?  $default,){
final _that = this;
switch (_that) {
case _SkipResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  bool alreadySkipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SkipResult() when $default != null:
return $default(_that.nodeId,_that.alreadySkipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  bool alreadySkipped)  $default,) {final _that = this;
switch (_that) {
case _SkipResult():
return $default(_that.nodeId,_that.alreadySkipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  bool alreadySkipped)?  $default,) {final _that = this;
switch (_that) {
case _SkipResult() when $default != null:
return $default(_that.nodeId,_that.alreadySkipped);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SkipResult implements SkipResult {
  const _SkipResult({this.nodeId = '', this.alreadySkipped = false});
  factory _SkipResult.fromJson(Map<String, dynamic> json) => _$SkipResultFromJson(json);

/// The node skipped, as sent.
@override@JsonKey() final  String nodeId;
/// It was already skipped (a repeat, or another device): nothing new was
/// written. Still a success.
@override@JsonKey() final  bool alreadySkipped;

/// Create a copy of SkipResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SkipResultCopyWith<_SkipResult> get copyWith => __$SkipResultCopyWithImpl<_SkipResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SkipResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SkipResult&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.alreadySkipped, alreadySkipped) || other.alreadySkipped == alreadySkipped));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,alreadySkipped);

@override
String toString() {
  return 'SkipResult(nodeId: $nodeId, alreadySkipped: $alreadySkipped)';
}


}

/// @nodoc
abstract mixin class _$SkipResultCopyWith<$Res> implements $SkipResultCopyWith<$Res> {
  factory _$SkipResultCopyWith(_SkipResult value, $Res Function(_SkipResult) _then) = __$SkipResultCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, bool alreadySkipped
});




}
/// @nodoc
class __$SkipResultCopyWithImpl<$Res>
    implements _$SkipResultCopyWith<$Res> {
  __$SkipResultCopyWithImpl(this._self, this._then);

  final _SkipResult _self;
  final $Res Function(_SkipResult) _then;

/// Create a copy of SkipResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? alreadySkipped = null,}) {
  return _then(_SkipResult(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,alreadySkipped: null == alreadySkipped ? _self.alreadySkipped : alreadySkipped // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
