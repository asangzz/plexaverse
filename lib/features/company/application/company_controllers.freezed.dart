// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_controllers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InboxState {

 List<InboxComment> get comments;/// Comment URN → the reply body currently in its editor. Seeded from the
/// AI draft, then owned by the user.
 Map<String, String> get drafts;/// Reactions that landed in this session.
 Set<String> get reacted;/// Reactions LinkedIn answered 409 on — this company had already reacted,
/// from another device or before the app existed. A success, not an error.
 Set<String> get alreadyReacted;/// Reactions in flight. Per-URN because "React All" is a sequential loop
/// of one call per comment and each row spins on its own.
 Set<String> get reacting; bool get publishing; bool get reactingAll;/// A one-shot message for the screen to surface and clear: "3 replies
/// published", "1 reply failed to push".
 String? get notice;
/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxStateCopyWith<InboxState> get copyWith => _$InboxStateCopyWithImpl<InboxState>(this as InboxState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxState&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.drafts, drafts)&&const DeepCollectionEquality().equals(other.reacted, reacted)&&const DeepCollectionEquality().equals(other.alreadyReacted, alreadyReacted)&&const DeepCollectionEquality().equals(other.reacting, reacting)&&(identical(other.publishing, publishing) || other.publishing == publishing)&&(identical(other.reactingAll, reactingAll) || other.reactingAll == reactingAll)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(drafts),const DeepCollectionEquality().hash(reacted),const DeepCollectionEquality().hash(alreadyReacted),const DeepCollectionEquality().hash(reacting),publishing,reactingAll,notice);

@override
String toString() {
  return 'InboxState(comments: $comments, drafts: $drafts, reacted: $reacted, alreadyReacted: $alreadyReacted, reacting: $reacting, publishing: $publishing, reactingAll: $reactingAll, notice: $notice)';
}


}

/// @nodoc
abstract mixin class $InboxStateCopyWith<$Res>  {
  factory $InboxStateCopyWith(InboxState value, $Res Function(InboxState) _then) = _$InboxStateCopyWithImpl;
@useResult
$Res call({
 List<InboxComment> comments, Map<String, String> drafts, Set<String> reacted, Set<String> alreadyReacted, Set<String> reacting, bool publishing, bool reactingAll, String? notice
});




}
/// @nodoc
class _$InboxStateCopyWithImpl<$Res>
    implements $InboxStateCopyWith<$Res> {
  _$InboxStateCopyWithImpl(this._self, this._then);

  final InboxState _self;
  final $Res Function(InboxState) _then;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? drafts = null,Object? reacted = null,Object? alreadyReacted = null,Object? reacting = null,Object? publishing = null,Object? reactingAll = null,Object? notice = freezed,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<InboxComment>,drafts: null == drafts ? _self.drafts : drafts // ignore: cast_nullable_to_non_nullable
as Map<String, String>,reacted: null == reacted ? _self.reacted : reacted // ignore: cast_nullable_to_non_nullable
as Set<String>,alreadyReacted: null == alreadyReacted ? _self.alreadyReacted : alreadyReacted // ignore: cast_nullable_to_non_nullable
as Set<String>,reacting: null == reacting ? _self.reacting : reacting // ignore: cast_nullable_to_non_nullable
as Set<String>,publishing: null == publishing ? _self.publishing : publishing // ignore: cast_nullable_to_non_nullable
as bool,reactingAll: null == reactingAll ? _self.reactingAll : reactingAll // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxState].
extension InboxStatePatterns on InboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxState value)  $default,){
final _that = this;
switch (_that) {
case _InboxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxState value)?  $default,){
final _that = this;
switch (_that) {
case _InboxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InboxComment> comments,  Map<String, String> drafts,  Set<String> reacted,  Set<String> alreadyReacted,  Set<String> reacting,  bool publishing,  bool reactingAll,  String? notice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxState() when $default != null:
return $default(_that.comments,_that.drafts,_that.reacted,_that.alreadyReacted,_that.reacting,_that.publishing,_that.reactingAll,_that.notice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InboxComment> comments,  Map<String, String> drafts,  Set<String> reacted,  Set<String> alreadyReacted,  Set<String> reacting,  bool publishing,  bool reactingAll,  String? notice)  $default,) {final _that = this;
switch (_that) {
case _InboxState():
return $default(_that.comments,_that.drafts,_that.reacted,_that.alreadyReacted,_that.reacting,_that.publishing,_that.reactingAll,_that.notice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InboxComment> comments,  Map<String, String> drafts,  Set<String> reacted,  Set<String> alreadyReacted,  Set<String> reacting,  bool publishing,  bool reactingAll,  String? notice)?  $default,) {final _that = this;
switch (_that) {
case _InboxState() when $default != null:
return $default(_that.comments,_that.drafts,_that.reacted,_that.alreadyReacted,_that.reacting,_that.publishing,_that.reactingAll,_that.notice);case _:
  return null;

}
}

}

/// @nodoc


class _InboxState extends InboxState {
  const _InboxState({final  List<InboxComment> comments = const <InboxComment>[], final  Map<String, String> drafts = const <String, String>{}, final  Set<String> reacted = const <String>{}, final  Set<String> alreadyReacted = const <String>{}, final  Set<String> reacting = const <String>{}, this.publishing = false, this.reactingAll = false, this.notice}): _comments = comments,_drafts = drafts,_reacted = reacted,_alreadyReacted = alreadyReacted,_reacting = reacting,super._();
  

 final  List<InboxComment> _comments;
@override@JsonKey() List<InboxComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

/// Comment URN → the reply body currently in its editor. Seeded from the
/// AI draft, then owned by the user.
 final  Map<String, String> _drafts;
/// Comment URN → the reply body currently in its editor. Seeded from the
/// AI draft, then owned by the user.
@override@JsonKey() Map<String, String> get drafts {
  if (_drafts is EqualUnmodifiableMapView) return _drafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_drafts);
}

/// Reactions that landed in this session.
 final  Set<String> _reacted;
/// Reactions that landed in this session.
@override@JsonKey() Set<String> get reacted {
  if (_reacted is EqualUnmodifiableSetView) return _reacted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_reacted);
}

/// Reactions LinkedIn answered 409 on — this company had already reacted,
/// from another device or before the app existed. A success, not an error.
 final  Set<String> _alreadyReacted;
/// Reactions LinkedIn answered 409 on — this company had already reacted,
/// from another device or before the app existed. A success, not an error.
@override@JsonKey() Set<String> get alreadyReacted {
  if (_alreadyReacted is EqualUnmodifiableSetView) return _alreadyReacted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_alreadyReacted);
}

/// Reactions in flight. Per-URN because "React All" is a sequential loop
/// of one call per comment and each row spins on its own.
 final  Set<String> _reacting;
/// Reactions in flight. Per-URN because "React All" is a sequential loop
/// of one call per comment and each row spins on its own.
@override@JsonKey() Set<String> get reacting {
  if (_reacting is EqualUnmodifiableSetView) return _reacting;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_reacting);
}

@override@JsonKey() final  bool publishing;
@override@JsonKey() final  bool reactingAll;
/// A one-shot message for the screen to surface and clear: "3 replies
/// published", "1 reply failed to push".
@override final  String? notice;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxStateCopyWith<_InboxState> get copyWith => __$InboxStateCopyWithImpl<_InboxState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxState&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._drafts, _drafts)&&const DeepCollectionEquality().equals(other._reacted, _reacted)&&const DeepCollectionEquality().equals(other._alreadyReacted, _alreadyReacted)&&const DeepCollectionEquality().equals(other._reacting, _reacting)&&(identical(other.publishing, publishing) || other.publishing == publishing)&&(identical(other.reactingAll, reactingAll) || other.reactingAll == reactingAll)&&(identical(other.notice, notice) || other.notice == notice));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_drafts),const DeepCollectionEquality().hash(_reacted),const DeepCollectionEquality().hash(_alreadyReacted),const DeepCollectionEquality().hash(_reacting),publishing,reactingAll,notice);

@override
String toString() {
  return 'InboxState(comments: $comments, drafts: $drafts, reacted: $reacted, alreadyReacted: $alreadyReacted, reacting: $reacting, publishing: $publishing, reactingAll: $reactingAll, notice: $notice)';
}


}

/// @nodoc
abstract mixin class _$InboxStateCopyWith<$Res> implements $InboxStateCopyWith<$Res> {
  factory _$InboxStateCopyWith(_InboxState value, $Res Function(_InboxState) _then) = __$InboxStateCopyWithImpl;
@override @useResult
$Res call({
 List<InboxComment> comments, Map<String, String> drafts, Set<String> reacted, Set<String> alreadyReacted, Set<String> reacting, bool publishing, bool reactingAll, String? notice
});




}
/// @nodoc
class __$InboxStateCopyWithImpl<$Res>
    implements _$InboxStateCopyWith<$Res> {
  __$InboxStateCopyWithImpl(this._self, this._then);

  final _InboxState _self;
  final $Res Function(_InboxState) _then;

/// Create a copy of InboxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? drafts = null,Object? reacted = null,Object? alreadyReacted = null,Object? reacting = null,Object? publishing = null,Object? reactingAll = null,Object? notice = freezed,}) {
  return _then(_InboxState(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<InboxComment>,drafts: null == drafts ? _self._drafts : drafts // ignore: cast_nullable_to_non_nullable
as Map<String, String>,reacted: null == reacted ? _self._reacted : reacted // ignore: cast_nullable_to_non_nullable
as Set<String>,alreadyReacted: null == alreadyReacted ? _self._alreadyReacted : alreadyReacted // ignore: cast_nullable_to_non_nullable
as Set<String>,reacting: null == reacting ? _self._reacting : reacting // ignore: cast_nullable_to_non_nullable
as Set<String>,publishing: null == publishing ? _self.publishing : publishing // ignore: cast_nullable_to_non_nullable
as bool,reactingAll: null == reactingAll ? _self.reactingAll : reactingAll // ignore: cast_nullable_to_non_nullable
as bool,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AdvocacyState {

 List<AdvocacyPost> get posts;/// Post ids with a reshare in flight.
 Set<String> get resharing;/// Post ids reshared in this session. Not server state: the API records
/// the XP award but exposes no "has this user already reshared" read, so
/// the button can only speak for this sitting.
 Set<String> get reshared;/// XP from the last successful reshare, for the toast. Null when there is
/// nothing to celebrate.
 int? get lastXpAward;/// A failure to show, in the server's own words where it gave them.
 String? get error;
/// Create a copy of AdvocacyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvocacyStateCopyWith<AdvocacyState> get copyWith => _$AdvocacyStateCopyWithImpl<AdvocacyState>(this as AdvocacyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvocacyState&&const DeepCollectionEquality().equals(other.posts, posts)&&const DeepCollectionEquality().equals(other.resharing, resharing)&&const DeepCollectionEquality().equals(other.reshared, reshared)&&(identical(other.lastXpAward, lastXpAward) || other.lastXpAward == lastXpAward)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),const DeepCollectionEquality().hash(resharing),const DeepCollectionEquality().hash(reshared),lastXpAward,error);

@override
String toString() {
  return 'AdvocacyState(posts: $posts, resharing: $resharing, reshared: $reshared, lastXpAward: $lastXpAward, error: $error)';
}


}

/// @nodoc
abstract mixin class $AdvocacyStateCopyWith<$Res>  {
  factory $AdvocacyStateCopyWith(AdvocacyState value, $Res Function(AdvocacyState) _then) = _$AdvocacyStateCopyWithImpl;
@useResult
$Res call({
 List<AdvocacyPost> posts, Set<String> resharing, Set<String> reshared, int? lastXpAward, String? error
});




}
/// @nodoc
class _$AdvocacyStateCopyWithImpl<$Res>
    implements $AdvocacyStateCopyWith<$Res> {
  _$AdvocacyStateCopyWithImpl(this._self, this._then);

  final AdvocacyState _self;
  final $Res Function(AdvocacyState) _then;

/// Create a copy of AdvocacyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? resharing = null,Object? reshared = null,Object? lastXpAward = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<AdvocacyPost>,resharing: null == resharing ? _self.resharing : resharing // ignore: cast_nullable_to_non_nullable
as Set<String>,reshared: null == reshared ? _self.reshared : reshared // ignore: cast_nullable_to_non_nullable
as Set<String>,lastXpAward: freezed == lastXpAward ? _self.lastXpAward : lastXpAward // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvocacyState].
extension AdvocacyStatePatterns on AdvocacyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvocacyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvocacyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvocacyState value)  $default,){
final _that = this;
switch (_that) {
case _AdvocacyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvocacyState value)?  $default,){
final _that = this;
switch (_that) {
case _AdvocacyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdvocacyPost> posts,  Set<String> resharing,  Set<String> reshared,  int? lastXpAward,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvocacyState() when $default != null:
return $default(_that.posts,_that.resharing,_that.reshared,_that.lastXpAward,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdvocacyPost> posts,  Set<String> resharing,  Set<String> reshared,  int? lastXpAward,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AdvocacyState():
return $default(_that.posts,_that.resharing,_that.reshared,_that.lastXpAward,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdvocacyPost> posts,  Set<String> resharing,  Set<String> reshared,  int? lastXpAward,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AdvocacyState() when $default != null:
return $default(_that.posts,_that.resharing,_that.reshared,_that.lastXpAward,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AdvocacyState extends AdvocacyState {
  const _AdvocacyState({final  List<AdvocacyPost> posts = const <AdvocacyPost>[], final  Set<String> resharing = const <String>{}, final  Set<String> reshared = const <String>{}, this.lastXpAward, this.error}): _posts = posts,_resharing = resharing,_reshared = reshared,super._();
  

 final  List<AdvocacyPost> _posts;
@override@JsonKey() List<AdvocacyPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

/// Post ids with a reshare in flight.
 final  Set<String> _resharing;
/// Post ids with a reshare in flight.
@override@JsonKey() Set<String> get resharing {
  if (_resharing is EqualUnmodifiableSetView) return _resharing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_resharing);
}

/// Post ids reshared in this session. Not server state: the API records
/// the XP award but exposes no "has this user already reshared" read, so
/// the button can only speak for this sitting.
 final  Set<String> _reshared;
/// Post ids reshared in this session. Not server state: the API records
/// the XP award but exposes no "has this user already reshared" read, so
/// the button can only speak for this sitting.
@override@JsonKey() Set<String> get reshared {
  if (_reshared is EqualUnmodifiableSetView) return _reshared;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_reshared);
}

/// XP from the last successful reshare, for the toast. Null when there is
/// nothing to celebrate.
@override final  int? lastXpAward;
/// A failure to show, in the server's own words where it gave them.
@override final  String? error;

/// Create a copy of AdvocacyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvocacyStateCopyWith<_AdvocacyState> get copyWith => __$AdvocacyStateCopyWithImpl<_AdvocacyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvocacyState&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._resharing, _resharing)&&const DeepCollectionEquality().equals(other._reshared, _reshared)&&(identical(other.lastXpAward, lastXpAward) || other.lastXpAward == lastXpAward)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_resharing),const DeepCollectionEquality().hash(_reshared),lastXpAward,error);

@override
String toString() {
  return 'AdvocacyState(posts: $posts, resharing: $resharing, reshared: $reshared, lastXpAward: $lastXpAward, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AdvocacyStateCopyWith<$Res> implements $AdvocacyStateCopyWith<$Res> {
  factory _$AdvocacyStateCopyWith(_AdvocacyState value, $Res Function(_AdvocacyState) _then) = __$AdvocacyStateCopyWithImpl;
@override @useResult
$Res call({
 List<AdvocacyPost> posts, Set<String> resharing, Set<String> reshared, int? lastXpAward, String? error
});




}
/// @nodoc
class __$AdvocacyStateCopyWithImpl<$Res>
    implements _$AdvocacyStateCopyWith<$Res> {
  __$AdvocacyStateCopyWithImpl(this._self, this._then);

  final _AdvocacyState _self;
  final $Res Function(_AdvocacyState) _then;

/// Create a copy of AdvocacyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? resharing = null,Object? reshared = null,Object? lastXpAward = freezed,Object? error = freezed,}) {
  return _then(_AdvocacyState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<AdvocacyPost>,resharing: null == resharing ? _self._resharing : resharing // ignore: cast_nullable_to_non_nullable
as Set<String>,reshared: null == reshared ? _self._reshared : reshared // ignore: cast_nullable_to_non_nullable
as Set<String>,lastXpAward: freezed == lastXpAward ? _self.lastXpAward : lastXpAward // ignore: cast_nullable_to_non_nullable
as int?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
