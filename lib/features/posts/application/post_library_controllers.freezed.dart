// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_library_controllers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PostLibraryState {

 List<LibraryPost> get posts; String? get nextCursor; bool get hasMore; bool get loadingMore;/// Server ids with a mutation in flight. Per-id rather than a single
/// boolean because the list shows an Approve button on every row, and one
/// global flag would spin all of them for a tap on one.
 Set<String> get busyIds;
/// Create a copy of PostLibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostLibraryStateCopyWith<PostLibraryState> get copyWith => _$PostLibraryStateCopyWithImpl<PostLibraryState>(this as PostLibraryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostLibraryState&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&const DeepCollectionEquality().equals(other.busyIds, busyIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),nextCursor,hasMore,loadingMore,const DeepCollectionEquality().hash(busyIds));

@override
String toString() {
  return 'PostLibraryState(posts: $posts, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, busyIds: $busyIds)';
}


}

/// @nodoc
abstract mixin class $PostLibraryStateCopyWith<$Res>  {
  factory $PostLibraryStateCopyWith(PostLibraryState value, $Res Function(PostLibraryState) _then) = _$PostLibraryStateCopyWithImpl;
@useResult
$Res call({
 List<LibraryPost> posts, String? nextCursor, bool hasMore, bool loadingMore, Set<String> busyIds
});




}
/// @nodoc
class _$PostLibraryStateCopyWithImpl<$Res>
    implements $PostLibraryStateCopyWith<$Res> {
  _$PostLibraryStateCopyWithImpl(this._self, this._then);

  final PostLibraryState _self;
  final $Res Function(PostLibraryState) _then;

/// Create a copy of PostLibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? busyIds = null,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<LibraryPost>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,busyIds: null == busyIds ? _self.busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PostLibraryState].
extension PostLibraryStatePatterns on PostLibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostLibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostLibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostLibraryState value)  $default,){
final _that = this;
switch (_that) {
case _PostLibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostLibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _PostLibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore,  bool loadingMore,  Set<String> busyIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostLibraryState() when $default != null:
return $default(_that.posts,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.busyIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore,  bool loadingMore,  Set<String> busyIds)  $default,) {final _that = this;
switch (_that) {
case _PostLibraryState():
return $default(_that.posts,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.busyIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LibraryPost> posts,  String? nextCursor,  bool hasMore,  bool loadingMore,  Set<String> busyIds)?  $default,) {final _that = this;
switch (_that) {
case _PostLibraryState() when $default != null:
return $default(_that.posts,_that.nextCursor,_that.hasMore,_that.loadingMore,_that.busyIds);case _:
  return null;

}
}

}

/// @nodoc


class _PostLibraryState extends PostLibraryState {
  const _PostLibraryState({final  List<LibraryPost> posts = const <LibraryPost>[], this.nextCursor, this.hasMore = false, this.loadingMore = false, final  Set<String> busyIds = const <String>{}}): _posts = posts,_busyIds = busyIds,super._();
  

 final  List<LibraryPost> _posts;
@override@JsonKey() List<LibraryPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override final  String? nextCursor;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  bool loadingMore;
/// Server ids with a mutation in flight. Per-id rather than a single
/// boolean because the list shows an Approve button on every row, and one
/// global flag would spin all of them for a tap on one.
 final  Set<String> _busyIds;
/// Server ids with a mutation in flight. Per-id rather than a single
/// boolean because the list shows an Approve button on every row, and one
/// global flag would spin all of them for a tap on one.
@override@JsonKey() Set<String> get busyIds {
  if (_busyIds is EqualUnmodifiableSetView) return _busyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_busyIds);
}


/// Create a copy of PostLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostLibraryStateCopyWith<_PostLibraryState> get copyWith => __$PostLibraryStateCopyWithImpl<_PostLibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostLibraryState&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&const DeepCollectionEquality().equals(other._busyIds, _busyIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),nextCursor,hasMore,loadingMore,const DeepCollectionEquality().hash(_busyIds));

@override
String toString() {
  return 'PostLibraryState(posts: $posts, nextCursor: $nextCursor, hasMore: $hasMore, loadingMore: $loadingMore, busyIds: $busyIds)';
}


}

/// @nodoc
abstract mixin class _$PostLibraryStateCopyWith<$Res> implements $PostLibraryStateCopyWith<$Res> {
  factory _$PostLibraryStateCopyWith(_PostLibraryState value, $Res Function(_PostLibraryState) _then) = __$PostLibraryStateCopyWithImpl;
@override @useResult
$Res call({
 List<LibraryPost> posts, String? nextCursor, bool hasMore, bool loadingMore, Set<String> busyIds
});




}
/// @nodoc
class __$PostLibraryStateCopyWithImpl<$Res>
    implements _$PostLibraryStateCopyWith<$Res> {
  __$PostLibraryStateCopyWithImpl(this._self, this._then);

  final _PostLibraryState _self;
  final $Res Function(_PostLibraryState) _then;

/// Create a copy of PostLibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? nextCursor = freezed,Object? hasMore = null,Object? loadingMore = null,Object? busyIds = null,}) {
  return _then(_PostLibraryState(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<LibraryPost>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,busyIds: null == busyIds ? _self._busyIds : busyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
