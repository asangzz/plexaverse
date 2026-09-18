// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentDraft {

 String get comment; String get targetPostTitle; String get searchKeywords;/// Copied at least once. Purely local; see the class doc.
@JsonKey(includeFromJson: false, includeToJson: false) bool get isSent;/// The last text this draft taught to `/ai/style-memory`.
///
/// Seeded with the generated [comment] when the batch lands, so an
/// untouched draft never teaches the model its own output back. Only a
/// genuine user edit differs from it — which is the one thing worth
/// learning from.
@JsonKey(includeFromJson: false, includeToJson: false) String get taughtText;
/// Create a copy of CommentDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentDraftCopyWith<CommentDraft> get copyWith => _$CommentDraftCopyWithImpl<CommentDraft>(this as CommentDraft, _$identity);

  /// Serializes this CommentDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentDraft&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.targetPostTitle, targetPostTitle) || other.targetPostTitle == targetPostTitle)&&(identical(other.searchKeywords, searchKeywords) || other.searchKeywords == searchKeywords)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.taughtText, taughtText) || other.taughtText == taughtText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comment,targetPostTitle,searchKeywords,isSent,taughtText);

@override
String toString() {
  return 'CommentDraft(comment: $comment, targetPostTitle: $targetPostTitle, searchKeywords: $searchKeywords, isSent: $isSent, taughtText: $taughtText)';
}


}

/// @nodoc
abstract mixin class $CommentDraftCopyWith<$Res>  {
  factory $CommentDraftCopyWith(CommentDraft value, $Res Function(CommentDraft) _then) = _$CommentDraftCopyWithImpl;
@useResult
$Res call({
 String comment, String targetPostTitle, String searchKeywords,@JsonKey(includeFromJson: false, includeToJson: false) bool isSent,@JsonKey(includeFromJson: false, includeToJson: false) String taughtText
});




}
/// @nodoc
class _$CommentDraftCopyWithImpl<$Res>
    implements $CommentDraftCopyWith<$Res> {
  _$CommentDraftCopyWithImpl(this._self, this._then);

  final CommentDraft _self;
  final $Res Function(CommentDraft) _then;

/// Create a copy of CommentDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comment = null,Object? targetPostTitle = null,Object? searchKeywords = null,Object? isSent = null,Object? taughtText = null,}) {
  return _then(_self.copyWith(
comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,targetPostTitle: null == targetPostTitle ? _self.targetPostTitle : targetPostTitle // ignore: cast_nullable_to_non_nullable
as String,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as String,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,taughtText: null == taughtText ? _self.taughtText : taughtText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentDraft].
extension CommentDraftPatterns on CommentDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentDraft value)  $default,){
final _that = this;
switch (_that) {
case _CommentDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentDraft value)?  $default,){
final _that = this;
switch (_that) {
case _CommentDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String comment,  String targetPostTitle,  String searchKeywords, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent, @JsonKey(includeFromJson: false, includeToJson: false)  String taughtText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentDraft() when $default != null:
return $default(_that.comment,_that.targetPostTitle,_that.searchKeywords,_that.isSent,_that.taughtText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String comment,  String targetPostTitle,  String searchKeywords, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent, @JsonKey(includeFromJson: false, includeToJson: false)  String taughtText)  $default,) {final _that = this;
switch (_that) {
case _CommentDraft():
return $default(_that.comment,_that.targetPostTitle,_that.searchKeywords,_that.isSent,_that.taughtText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String comment,  String targetPostTitle,  String searchKeywords, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSent, @JsonKey(includeFromJson: false, includeToJson: false)  String taughtText)?  $default,) {final _that = this;
switch (_that) {
case _CommentDraft() when $default != null:
return $default(_that.comment,_that.targetPostTitle,_that.searchKeywords,_that.isSent,_that.taughtText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentDraft extends CommentDraft {
  const _CommentDraft({this.comment = '', this.targetPostTitle = '', this.searchKeywords = '', @JsonKey(includeFromJson: false, includeToJson: false) this.isSent = false, @JsonKey(includeFromJson: false, includeToJson: false) this.taughtText = ''}): super._();
  factory _CommentDraft.fromJson(Map<String, dynamic> json) => _$CommentDraftFromJson(json);

@override@JsonKey() final  String comment;
@override@JsonKey() final  String targetPostTitle;
@override@JsonKey() final  String searchKeywords;
/// Copied at least once. Purely local; see the class doc.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isSent;
/// The last text this draft taught to `/ai/style-memory`.
///
/// Seeded with the generated [comment] when the batch lands, so an
/// untouched draft never teaches the model its own output back. Only a
/// genuine user edit differs from it — which is the one thing worth
/// learning from.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String taughtText;

/// Create a copy of CommentDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentDraftCopyWith<_CommentDraft> get copyWith => __$CommentDraftCopyWithImpl<_CommentDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentDraft&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.targetPostTitle, targetPostTitle) || other.targetPostTitle == targetPostTitle)&&(identical(other.searchKeywords, searchKeywords) || other.searchKeywords == searchKeywords)&&(identical(other.isSent, isSent) || other.isSent == isSent)&&(identical(other.taughtText, taughtText) || other.taughtText == taughtText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comment,targetPostTitle,searchKeywords,isSent,taughtText);

@override
String toString() {
  return 'CommentDraft(comment: $comment, targetPostTitle: $targetPostTitle, searchKeywords: $searchKeywords, isSent: $isSent, taughtText: $taughtText)';
}


}

/// @nodoc
abstract mixin class _$CommentDraftCopyWith<$Res> implements $CommentDraftCopyWith<$Res> {
  factory _$CommentDraftCopyWith(_CommentDraft value, $Res Function(_CommentDraft) _then) = __$CommentDraftCopyWithImpl;
@override @useResult
$Res call({
 String comment, String targetPostTitle, String searchKeywords,@JsonKey(includeFromJson: false, includeToJson: false) bool isSent,@JsonKey(includeFromJson: false, includeToJson: false) String taughtText
});




}
/// @nodoc
class __$CommentDraftCopyWithImpl<$Res>
    implements _$CommentDraftCopyWith<$Res> {
  __$CommentDraftCopyWithImpl(this._self, this._then);

  final _CommentDraft _self;
  final $Res Function(_CommentDraft) _then;

/// Create a copy of CommentDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comment = null,Object? targetPostTitle = null,Object? searchKeywords = null,Object? isSent = null,Object? taughtText = null,}) {
  return _then(_CommentDraft(
comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,targetPostTitle: null == targetPostTitle ? _self.targetPostTitle : targetPostTitle // ignore: cast_nullable_to_non_nullable
as String,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as String,isSent: null == isSent ? _self.isSent : isSent // ignore: cast_nullable_to_non_nullable
as bool,taughtText: null == taughtText ? _self.taughtText : taughtText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CommentBatch {

 List<CommentDraft> get comments;/// The topic the SERVER picked from the user's niche. There is no manual
/// topic entry — the web's topic field is unreachable in practice because
/// the page auto-generates on mount.
 String get topic;/// True when this is today's stored batch, replayed at no cost.
 bool get cached;/// What a fresh batch would cost. Null until the server has priced one.
 int? get xpCost;
/// Create a copy of CommentBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentBatchCopyWith<CommentBatch> get copyWith => _$CommentBatchCopyWithImpl<CommentBatch>(this as CommentBatch, _$identity);

  /// Serializes this CommentBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentBatch&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.xpCost, xpCost) || other.xpCost == xpCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments),topic,cached,xpCost);

@override
String toString() {
  return 'CommentBatch(comments: $comments, topic: $topic, cached: $cached, xpCost: $xpCost)';
}


}

/// @nodoc
abstract mixin class $CommentBatchCopyWith<$Res>  {
  factory $CommentBatchCopyWith(CommentBatch value, $Res Function(CommentBatch) _then) = _$CommentBatchCopyWithImpl;
@useResult
$Res call({
 List<CommentDraft> comments, String topic, bool cached, int? xpCost
});




}
/// @nodoc
class _$CommentBatchCopyWithImpl<$Res>
    implements $CommentBatchCopyWith<$Res> {
  _$CommentBatchCopyWithImpl(this._self, this._then);

  final CommentBatch _self;
  final $Res Function(CommentBatch) _then;

/// Create a copy of CommentBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? topic = null,Object? cached = null,Object? xpCost = freezed,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentDraft>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,xpCost: freezed == xpCost ? _self.xpCost : xpCost // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentBatch].
extension CommentBatchPatterns on CommentBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentBatch value)  $default,){
final _that = this;
switch (_that) {
case _CommentBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentBatch value)?  $default,){
final _that = this;
switch (_that) {
case _CommentBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CommentDraft> comments,  String topic,  bool cached,  int? xpCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentBatch() when $default != null:
return $default(_that.comments,_that.topic,_that.cached,_that.xpCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CommentDraft> comments,  String topic,  bool cached,  int? xpCost)  $default,) {final _that = this;
switch (_that) {
case _CommentBatch():
return $default(_that.comments,_that.topic,_that.cached,_that.xpCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CommentDraft> comments,  String topic,  bool cached,  int? xpCost)?  $default,) {final _that = this;
switch (_that) {
case _CommentBatch() when $default != null:
return $default(_that.comments,_that.topic,_that.cached,_that.xpCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentBatch extends CommentBatch {
  const _CommentBatch({final  List<CommentDraft> comments = const <CommentDraft>[], this.topic = '', this.cached = false, this.xpCost}): _comments = comments,super._();
  factory _CommentBatch.fromJson(Map<String, dynamic> json) => _$CommentBatchFromJson(json);

 final  List<CommentDraft> _comments;
@override@JsonKey() List<CommentDraft> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

/// The topic the SERVER picked from the user's niche. There is no manual
/// topic entry — the web's topic field is unreachable in practice because
/// the page auto-generates on mount.
@override@JsonKey() final  String topic;
/// True when this is today's stored batch, replayed at no cost.
@override@JsonKey() final  bool cached;
/// What a fresh batch would cost. Null until the server has priced one.
@override final  int? xpCost;

/// Create a copy of CommentBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentBatchCopyWith<_CommentBatch> get copyWith => __$CommentBatchCopyWithImpl<_CommentBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentBatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentBatch&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.cached, cached) || other.cached == cached)&&(identical(other.xpCost, xpCost) || other.xpCost == xpCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),topic,cached,xpCost);

@override
String toString() {
  return 'CommentBatch(comments: $comments, topic: $topic, cached: $cached, xpCost: $xpCost)';
}


}

/// @nodoc
abstract mixin class _$CommentBatchCopyWith<$Res> implements $CommentBatchCopyWith<$Res> {
  factory _$CommentBatchCopyWith(_CommentBatch value, $Res Function(_CommentBatch) _then) = __$CommentBatchCopyWithImpl;
@override @useResult
$Res call({
 List<CommentDraft> comments, String topic, bool cached, int? xpCost
});




}
/// @nodoc
class __$CommentBatchCopyWithImpl<$Res>
    implements _$CommentBatchCopyWith<$Res> {
  __$CommentBatchCopyWithImpl(this._self, this._then);

  final _CommentBatch _self;
  final $Res Function(_CommentBatch) _then;

/// Create a copy of CommentBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? topic = null,Object? cached = null,Object? xpCost = freezed,}) {
  return _then(_CommentBatch(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentDraft>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as bool,xpCost: freezed == xpCost ? _self.xpCost : xpCost // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
