// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plexa_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlexaSession {

 List<String> get comments; List<String> get connections;
/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<PlexaSession> get copyWith => _$PlexaSessionCopyWithImpl<PlexaSession>(this as PlexaSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaSession&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.connections, connections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'PlexaSession(comments: $comments, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $PlexaSessionCopyWith<$Res>  {
  factory $PlexaSessionCopyWith(PlexaSession value, $Res Function(PlexaSession) _then) = _$PlexaSessionCopyWithImpl;
@useResult
$Res call({
 List<String> comments, List<String> connections
});




}
/// @nodoc
class _$PlexaSessionCopyWithImpl<$Res>
    implements $PlexaSessionCopyWith<$Res> {
  _$PlexaSessionCopyWithImpl(this._self, this._then);

  final PlexaSession _self;
  final $Res Function(PlexaSession) _then;

/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comments = null,Object? connections = null,}) {
  return _then(_self.copyWith(
comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaSession].
extension PlexaSessionPatterns on PlexaSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaSession value)  $default,){
final _that = this;
switch (_that) {
case _PlexaSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaSession value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> comments,  List<String> connections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
return $default(_that.comments,_that.connections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> comments,  List<String> connections)  $default,) {final _that = this;
switch (_that) {
case _PlexaSession():
return $default(_that.comments,_that.connections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> comments,  List<String> connections)?  $default,) {final _that = this;
switch (_that) {
case _PlexaSession() when $default != null:
return $default(_that.comments,_that.connections);case _:
  return null;

}
}

}

/// @nodoc


class _PlexaSession extends PlexaSession {
  const _PlexaSession({final  List<String> comments = const <String>[], final  List<String> connections = const <String>[]}): _comments = comments,_connections = connections,super._();
  

 final  List<String> _comments;
@override@JsonKey() List<String> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

 final  List<String> _connections;
@override@JsonKey() List<String> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaSessionCopyWith<_PlexaSession> get copyWith => __$PlexaSessionCopyWithImpl<_PlexaSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaSession&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._connections, _connections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'PlexaSession(comments: $comments, connections: $connections)';
}


}

/// @nodoc
abstract mixin class _$PlexaSessionCopyWith<$Res> implements $PlexaSessionCopyWith<$Res> {
  factory _$PlexaSessionCopyWith(_PlexaSession value, $Res Function(_PlexaSession) _then) = __$PlexaSessionCopyWithImpl;
@override @useResult
$Res call({
 List<String> comments, List<String> connections
});




}
/// @nodoc
class __$PlexaSessionCopyWithImpl<$Res>
    implements _$PlexaSessionCopyWith<$Res> {
  __$PlexaSessionCopyWithImpl(this._self, this._then);

  final _PlexaSession _self;
  final $Res Function(_PlexaSession) _then;

/// Create a copy of PlexaSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comments = null,Object? connections = null,}) {
  return _then(_PlexaSession(
comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>,connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PlexaComment {

 String get id; String get comment; String get searchKeywords;/// The KIND of high-reach post this comment fits, not a real post. Nothing
/// in the product knows which post the user will actually comment on.
 String get targetPostTitle;
/// Create a copy of PlexaComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaCommentCopyWith<PlexaComment> get copyWith => _$PlexaCommentCopyWithImpl<PlexaComment>(this as PlexaComment, _$identity);

  /// Serializes this PlexaComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaComment&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.searchKeywords, searchKeywords) || other.searchKeywords == searchKeywords)&&(identical(other.targetPostTitle, targetPostTitle) || other.targetPostTitle == targetPostTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,searchKeywords,targetPostTitle);

@override
String toString() {
  return 'PlexaComment(id: $id, comment: $comment, searchKeywords: $searchKeywords, targetPostTitle: $targetPostTitle)';
}


}

/// @nodoc
abstract mixin class $PlexaCommentCopyWith<$Res>  {
  factory $PlexaCommentCopyWith(PlexaComment value, $Res Function(PlexaComment) _then) = _$PlexaCommentCopyWithImpl;
@useResult
$Res call({
 String id, String comment, String searchKeywords, String targetPostTitle
});




}
/// @nodoc
class _$PlexaCommentCopyWithImpl<$Res>
    implements $PlexaCommentCopyWith<$Res> {
  _$PlexaCommentCopyWithImpl(this._self, this._then);

  final PlexaComment _self;
  final $Res Function(PlexaComment) _then;

/// Create a copy of PlexaComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? comment = null,Object? searchKeywords = null,Object? targetPostTitle = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as String,targetPostTitle: null == targetPostTitle ? _self.targetPostTitle : targetPostTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaComment].
extension PlexaCommentPatterns on PlexaComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaComment value)  $default,){
final _that = this;
switch (_that) {
case _PlexaComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaComment value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String comment,  String searchKeywords,  String targetPostTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaComment() when $default != null:
return $default(_that.id,_that.comment,_that.searchKeywords,_that.targetPostTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String comment,  String searchKeywords,  String targetPostTitle)  $default,) {final _that = this;
switch (_that) {
case _PlexaComment():
return $default(_that.id,_that.comment,_that.searchKeywords,_that.targetPostTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String comment,  String searchKeywords,  String targetPostTitle)?  $default,) {final _that = this;
switch (_that) {
case _PlexaComment() when $default != null:
return $default(_that.id,_that.comment,_that.searchKeywords,_that.targetPostTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlexaComment implements PlexaComment {
  const _PlexaComment({this.id = '', this.comment = '', this.searchKeywords = '', this.targetPostTitle = ''});
  factory _PlexaComment.fromJson(Map<String, dynamic> json) => _$PlexaCommentFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String comment;
@override@JsonKey() final  String searchKeywords;
/// The KIND of high-reach post this comment fits, not a real post. Nothing
/// in the product knows which post the user will actually comment on.
@override@JsonKey() final  String targetPostTitle;

/// Create a copy of PlexaComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaCommentCopyWith<_PlexaComment> get copyWith => __$PlexaCommentCopyWithImpl<_PlexaComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlexaCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaComment&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.searchKeywords, searchKeywords) || other.searchKeywords == searchKeywords)&&(identical(other.targetPostTitle, targetPostTitle) || other.targetPostTitle == targetPostTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,searchKeywords,targetPostTitle);

@override
String toString() {
  return 'PlexaComment(id: $id, comment: $comment, searchKeywords: $searchKeywords, targetPostTitle: $targetPostTitle)';
}


}

/// @nodoc
abstract mixin class _$PlexaCommentCopyWith<$Res> implements $PlexaCommentCopyWith<$Res> {
  factory _$PlexaCommentCopyWith(_PlexaComment value, $Res Function(_PlexaComment) _then) = __$PlexaCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String comment, String searchKeywords, String targetPostTitle
});




}
/// @nodoc
class __$PlexaCommentCopyWithImpl<$Res>
    implements _$PlexaCommentCopyWith<$Res> {
  __$PlexaCommentCopyWithImpl(this._self, this._then);

  final _PlexaComment _self;
  final $Res Function(_PlexaComment) _then;

/// Create a copy of PlexaComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? comment = null,Object? searchKeywords = null,Object? targetPostTitle = null,}) {
  return _then(_PlexaComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,searchKeywords: null == searchKeywords ? _self.searchKeywords : searchKeywords // ignore: cast_nullable_to_non_nullable
as String,targetPostTitle: null == targetPostTitle ? _self.targetPostTitle : targetPostTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PlexaConnection {

 String get id; String get role; String get company; String get note; String get searchUrl;/// The one card in five that is a DM rather than a connection request —
/// LinkedIn's free plan caps personalised notes at roughly five a week.
 bool get isDirectMessage;
/// Create a copy of PlexaConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaConnectionCopyWith<PlexaConnection> get copyWith => _$PlexaConnectionCopyWithImpl<PlexaConnection>(this as PlexaConnection, _$identity);

  /// Serializes this PlexaConnection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.company, company) || other.company == company)&&(identical(other.note, note) || other.note == note)&&(identical(other.searchUrl, searchUrl) || other.searchUrl == searchUrl)&&(identical(other.isDirectMessage, isDirectMessage) || other.isDirectMessage == isDirectMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,company,note,searchUrl,isDirectMessage);

@override
String toString() {
  return 'PlexaConnection(id: $id, role: $role, company: $company, note: $note, searchUrl: $searchUrl, isDirectMessage: $isDirectMessage)';
}


}

/// @nodoc
abstract mixin class $PlexaConnectionCopyWith<$Res>  {
  factory $PlexaConnectionCopyWith(PlexaConnection value, $Res Function(PlexaConnection) _then) = _$PlexaConnectionCopyWithImpl;
@useResult
$Res call({
 String id, String role, String company, String note, String searchUrl, bool isDirectMessage
});




}
/// @nodoc
class _$PlexaConnectionCopyWithImpl<$Res>
    implements $PlexaConnectionCopyWith<$Res> {
  _$PlexaConnectionCopyWithImpl(this._self, this._then);

  final PlexaConnection _self;
  final $Res Function(PlexaConnection) _then;

/// Create a copy of PlexaConnection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? company = null,Object? note = null,Object? searchUrl = null,Object? isDirectMessage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,searchUrl: null == searchUrl ? _self.searchUrl : searchUrl // ignore: cast_nullable_to_non_nullable
as String,isDirectMessage: null == isDirectMessage ? _self.isDirectMessage : isDirectMessage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaConnection].
extension PlexaConnectionPatterns on PlexaConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaConnection value)  $default,){
final _that = this;
switch (_that) {
case _PlexaConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaConnection value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaConnection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String company,  String note,  String searchUrl,  bool isDirectMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaConnection() when $default != null:
return $default(_that.id,_that.role,_that.company,_that.note,_that.searchUrl,_that.isDirectMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String company,  String note,  String searchUrl,  bool isDirectMessage)  $default,) {final _that = this;
switch (_that) {
case _PlexaConnection():
return $default(_that.id,_that.role,_that.company,_that.note,_that.searchUrl,_that.isDirectMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String company,  String note,  String searchUrl,  bool isDirectMessage)?  $default,) {final _that = this;
switch (_that) {
case _PlexaConnection() when $default != null:
return $default(_that.id,_that.role,_that.company,_that.note,_that.searchUrl,_that.isDirectMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlexaConnection implements PlexaConnection {
  const _PlexaConnection({this.id = '', this.role = '', this.company = '', this.note = '', this.searchUrl = '', this.isDirectMessage = false});
  factory _PlexaConnection.fromJson(Map<String, dynamic> json) => _$PlexaConnectionFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String role;
@override@JsonKey() final  String company;
@override@JsonKey() final  String note;
@override@JsonKey() final  String searchUrl;
/// The one card in five that is a DM rather than a connection request —
/// LinkedIn's free plan caps personalised notes at roughly five a week.
@override@JsonKey() final  bool isDirectMessage;

/// Create a copy of PlexaConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaConnectionCopyWith<_PlexaConnection> get copyWith => __$PlexaConnectionCopyWithImpl<_PlexaConnection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlexaConnectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.company, company) || other.company == company)&&(identical(other.note, note) || other.note == note)&&(identical(other.searchUrl, searchUrl) || other.searchUrl == searchUrl)&&(identical(other.isDirectMessage, isDirectMessage) || other.isDirectMessage == isDirectMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,company,note,searchUrl,isDirectMessage);

@override
String toString() {
  return 'PlexaConnection(id: $id, role: $role, company: $company, note: $note, searchUrl: $searchUrl, isDirectMessage: $isDirectMessage)';
}


}

/// @nodoc
abstract mixin class _$PlexaConnectionCopyWith<$Res> implements $PlexaConnectionCopyWith<$Res> {
  factory _$PlexaConnectionCopyWith(_PlexaConnection value, $Res Function(_PlexaConnection) _then) = __$PlexaConnectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String company, String note, String searchUrl, bool isDirectMessage
});




}
/// @nodoc
class __$PlexaConnectionCopyWithImpl<$Res>
    implements _$PlexaConnectionCopyWith<$Res> {
  __$PlexaConnectionCopyWithImpl(this._self, this._then);

  final _PlexaConnection _self;
  final $Res Function(_PlexaConnection) _then;

/// Create a copy of PlexaConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? company = null,Object? note = null,Object? searchUrl = null,Object? isDirectMessage = null,}) {
  return _then(_PlexaConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,searchUrl: null == searchUrl ? _self.searchUrl : searchUrl // ignore: cast_nullable_to_non_nullable
as String,isDirectMessage: null == isDirectMessage ? _self.isDirectMessage : isDirectMessage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PlexaTopVoice {

 String get id; String get postUrl; String get authorName; String get firstLine; String get comment;/// This lane carries its own durable stamp rather than relying on the
/// session map, because the comments screen reads the same rows.
 String? get actedAt;
/// Create a copy of PlexaTopVoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaTopVoiceCopyWith<PlexaTopVoice> get copyWith => _$PlexaTopVoiceCopyWithImpl<PlexaTopVoice>(this as PlexaTopVoice, _$identity);

  /// Serializes this PlexaTopVoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaTopVoice&&(identical(other.id, id) || other.id == id)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.actedAt, actedAt) || other.actedAt == actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postUrl,authorName,firstLine,comment,actedAt);

@override
String toString() {
  return 'PlexaTopVoice(id: $id, postUrl: $postUrl, authorName: $authorName, firstLine: $firstLine, comment: $comment, actedAt: $actedAt)';
}


}

/// @nodoc
abstract mixin class $PlexaTopVoiceCopyWith<$Res>  {
  factory $PlexaTopVoiceCopyWith(PlexaTopVoice value, $Res Function(PlexaTopVoice) _then) = _$PlexaTopVoiceCopyWithImpl;
@useResult
$Res call({
 String id, String postUrl, String authorName, String firstLine, String comment, String? actedAt
});




}
/// @nodoc
class _$PlexaTopVoiceCopyWithImpl<$Res>
    implements $PlexaTopVoiceCopyWith<$Res> {
  _$PlexaTopVoiceCopyWithImpl(this._self, this._then);

  final PlexaTopVoice _self;
  final $Res Function(PlexaTopVoice) _then;

/// Create a copy of PlexaTopVoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postUrl = null,Object? authorName = null,Object? firstLine = null,Object? comment = null,Object? actedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,firstLine: null == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaTopVoice].
extension PlexaTopVoicePatterns on PlexaTopVoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaTopVoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaTopVoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaTopVoice value)  $default,){
final _that = this;
switch (_that) {
case _PlexaTopVoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaTopVoice value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaTopVoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postUrl,  String authorName,  String firstLine,  String comment,  String? actedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaTopVoice() when $default != null:
return $default(_that.id,_that.postUrl,_that.authorName,_that.firstLine,_that.comment,_that.actedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postUrl,  String authorName,  String firstLine,  String comment,  String? actedAt)  $default,) {final _that = this;
switch (_that) {
case _PlexaTopVoice():
return $default(_that.id,_that.postUrl,_that.authorName,_that.firstLine,_that.comment,_that.actedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postUrl,  String authorName,  String firstLine,  String comment,  String? actedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlexaTopVoice() when $default != null:
return $default(_that.id,_that.postUrl,_that.authorName,_that.firstLine,_that.comment,_that.actedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlexaTopVoice extends PlexaTopVoice {
  const _PlexaTopVoice({this.id = '', this.postUrl = '', this.authorName = '', this.firstLine = '', this.comment = '', this.actedAt}): super._();
  factory _PlexaTopVoice.fromJson(Map<String, dynamic> json) => _$PlexaTopVoiceFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String postUrl;
@override@JsonKey() final  String authorName;
@override@JsonKey() final  String firstLine;
@override@JsonKey() final  String comment;
/// This lane carries its own durable stamp rather than relying on the
/// session map, because the comments screen reads the same rows.
@override final  String? actedAt;

/// Create a copy of PlexaTopVoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaTopVoiceCopyWith<_PlexaTopVoice> get copyWith => __$PlexaTopVoiceCopyWithImpl<_PlexaTopVoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlexaTopVoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaTopVoice&&(identical(other.id, id) || other.id == id)&&(identical(other.postUrl, postUrl) || other.postUrl == postUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.firstLine, firstLine) || other.firstLine == firstLine)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.actedAt, actedAt) || other.actedAt == actedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postUrl,authorName,firstLine,comment,actedAt);

@override
String toString() {
  return 'PlexaTopVoice(id: $id, postUrl: $postUrl, authorName: $authorName, firstLine: $firstLine, comment: $comment, actedAt: $actedAt)';
}


}

/// @nodoc
abstract mixin class _$PlexaTopVoiceCopyWith<$Res> implements $PlexaTopVoiceCopyWith<$Res> {
  factory _$PlexaTopVoiceCopyWith(_PlexaTopVoice value, $Res Function(_PlexaTopVoice) _then) = __$PlexaTopVoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String postUrl, String authorName, String firstLine, String comment, String? actedAt
});




}
/// @nodoc
class __$PlexaTopVoiceCopyWithImpl<$Res>
    implements _$PlexaTopVoiceCopyWith<$Res> {
  __$PlexaTopVoiceCopyWithImpl(this._self, this._then);

  final _PlexaTopVoice _self;
  final $Res Function(_PlexaTopVoice) _then;

/// Create a copy of PlexaTopVoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postUrl = null,Object? authorName = null,Object? firstLine = null,Object? comment = null,Object? actedAt = freezed,}) {
  return _then(_PlexaTopVoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postUrl: null == postUrl ? _self.postUrl : postUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,firstLine: null == firstLine ? _self.firstLine : firstLine // ignore: cast_nullable_to_non_nullable
as String,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,actedAt: freezed == actedAt ? _self.actedAt : actedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PlexaLaneState<T> {

 bool get ready; List<T> get items;
/// Create a copy of PlexaLaneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<T, PlexaLaneState<T>> get copyWith => _$PlexaLaneStateCopyWithImpl<T, PlexaLaneState<T>>(this as PlexaLaneState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaLaneState<T>&&(identical(other.ready, ready) || other.ready == ready)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,ready,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PlexaLaneState<$T>(ready: $ready, items: $items)';
}


}

/// @nodoc
abstract mixin class $PlexaLaneStateCopyWith<T,$Res>  {
  factory $PlexaLaneStateCopyWith(PlexaLaneState<T> value, $Res Function(PlexaLaneState<T>) _then) = _$PlexaLaneStateCopyWithImpl;
@useResult
$Res call({
 bool ready, List<T> items
});




}
/// @nodoc
class _$PlexaLaneStateCopyWithImpl<T,$Res>
    implements $PlexaLaneStateCopyWith<T, $Res> {
  _$PlexaLaneStateCopyWithImpl(this._self, this._then);

  final PlexaLaneState<T> _self;
  final $Res Function(PlexaLaneState<T>) _then;

/// Create a copy of PlexaLaneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ready = null,Object? items = null,}) {
  return _then(_self.copyWith(
ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlexaLaneState].
extension PlexaLaneStatePatterns<T> on PlexaLaneState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaLaneState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaLaneState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaLaneState<T> value)  $default,){
final _that = this;
switch (_that) {
case _PlexaLaneState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaLaneState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaLaneState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ready,  List<T> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaLaneState() when $default != null:
return $default(_that.ready,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ready,  List<T> items)  $default,) {final _that = this;
switch (_that) {
case _PlexaLaneState():
return $default(_that.ready,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ready,  List<T> items)?  $default,) {final _that = this;
switch (_that) {
case _PlexaLaneState() when $default != null:
return $default(_that.ready,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _PlexaLaneState<T> implements PlexaLaneState<T> {
  const _PlexaLaneState({this.ready = false, final  List<T> items = const <Never>[]}): _items = items;
  

@override@JsonKey() final  bool ready;
 final  List<T> _items;
@override@JsonKey() List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PlexaLaneState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaLaneStateCopyWith<T, _PlexaLaneState<T>> get copyWith => __$PlexaLaneStateCopyWithImpl<T, _PlexaLaneState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaLaneState<T>&&(identical(other.ready, ready) || other.ready == ready)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,ready,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PlexaLaneState<$T>(ready: $ready, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PlexaLaneStateCopyWith<T,$Res> implements $PlexaLaneStateCopyWith<T, $Res> {
  factory _$PlexaLaneStateCopyWith(_PlexaLaneState<T> value, $Res Function(_PlexaLaneState<T>) _then) = __$PlexaLaneStateCopyWithImpl;
@override @useResult
$Res call({
 bool ready, List<T> items
});




}
/// @nodoc
class __$PlexaLaneStateCopyWithImpl<T,$Res>
    implements _$PlexaLaneStateCopyWith<T, $Res> {
  __$PlexaLaneStateCopyWithImpl(this._self, this._then);

  final _PlexaLaneState<T> _self;
  final $Res Function(_PlexaLaneState<T>) _then;

/// Create a copy of PlexaLaneState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ready = null,Object? items = null,}) {
  return _then(_PlexaLaneState<T>(
ready: null == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

/// @nodoc
mixin _$PlexaDay {

 PlexaSession get session; PlexaLaneState<PlexaComment> get comments; PlexaLaneState<PlexaConnection> get connections; PlexaLaneState<PlexaTopVoice> get topVoices;/// The topic today's comments were written around.
 String get topic;
/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlexaDayCopyWith<PlexaDay> get copyWith => _$PlexaDayCopyWithImpl<PlexaDay>(this as PlexaDay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlexaDay&&(identical(other.session, session) || other.session == session)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.topVoices, topVoices) || other.topVoices == topVoices)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,session,comments,connections,topVoices,topic);

@override
String toString() {
  return 'PlexaDay(session: $session, comments: $comments, connections: $connections, topVoices: $topVoices, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $PlexaDayCopyWith<$Res>  {
  factory $PlexaDayCopyWith(PlexaDay value, $Res Function(PlexaDay) _then) = _$PlexaDayCopyWithImpl;
@useResult
$Res call({
 PlexaSession session, PlexaLaneState<PlexaComment> comments, PlexaLaneState<PlexaConnection> connections, PlexaLaneState<PlexaTopVoice> topVoices, String topic
});


$PlexaSessionCopyWith<$Res> get session;$PlexaLaneStateCopyWith<PlexaComment, $Res> get comments;$PlexaLaneStateCopyWith<PlexaConnection, $Res> get connections;$PlexaLaneStateCopyWith<PlexaTopVoice, $Res> get topVoices;

}
/// @nodoc
class _$PlexaDayCopyWithImpl<$Res>
    implements $PlexaDayCopyWith<$Res> {
  _$PlexaDayCopyWithImpl(this._self, this._then);

  final PlexaDay _self;
  final $Res Function(PlexaDay) _then;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? comments = null,Object? connections = null,Object? topVoices = null,Object? topic = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlexaSession,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaComment>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaConnection>,topVoices: null == topVoices ? _self.topVoices : topVoices // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaTopVoice>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<$Res> get session {
  
  return $PlexaSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaComment, $Res> get comments {
  
  return $PlexaLaneStateCopyWith<PlexaComment, $Res>(_self.comments, (value) {
    return _then(_self.copyWith(comments: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaConnection, $Res> get connections {
  
  return $PlexaLaneStateCopyWith<PlexaConnection, $Res>(_self.connections, (value) {
    return _then(_self.copyWith(connections: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaTopVoice, $Res> get topVoices {
  
  return $PlexaLaneStateCopyWith<PlexaTopVoice, $Res>(_self.topVoices, (value) {
    return _then(_self.copyWith(topVoices: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlexaDay].
extension PlexaDayPatterns on PlexaDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlexaDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlexaDay value)  $default,){
final _that = this;
switch (_that) {
case _PlexaDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlexaDay value)?  $default,){
final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlexaSession session,  PlexaLaneState<PlexaComment> comments,  PlexaLaneState<PlexaConnection> connections,  PlexaLaneState<PlexaTopVoice> topVoices,  String topic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
return $default(_that.session,_that.comments,_that.connections,_that.topVoices,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlexaSession session,  PlexaLaneState<PlexaComment> comments,  PlexaLaneState<PlexaConnection> connections,  PlexaLaneState<PlexaTopVoice> topVoices,  String topic)  $default,) {final _that = this;
switch (_that) {
case _PlexaDay():
return $default(_that.session,_that.comments,_that.connections,_that.topVoices,_that.topic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlexaSession session,  PlexaLaneState<PlexaComment> comments,  PlexaLaneState<PlexaConnection> connections,  PlexaLaneState<PlexaTopVoice> topVoices,  String topic)?  $default,) {final _that = this;
switch (_that) {
case _PlexaDay() when $default != null:
return $default(_that.session,_that.comments,_that.connections,_that.topVoices,_that.topic);case _:
  return null;

}
}

}

/// @nodoc


class _PlexaDay extends PlexaDay {
  const _PlexaDay({this.session = const PlexaSession(), this.comments = const PlexaLaneState<PlexaComment>(), this.connections = const PlexaLaneState<PlexaConnection>(), this.topVoices = const PlexaLaneState<PlexaTopVoice>(), this.topic = ''}): super._();
  

@override@JsonKey() final  PlexaSession session;
@override@JsonKey() final  PlexaLaneState<PlexaComment> comments;
@override@JsonKey() final  PlexaLaneState<PlexaConnection> connections;
@override@JsonKey() final  PlexaLaneState<PlexaTopVoice> topVoices;
/// The topic today's comments were written around.
@override@JsonKey() final  String topic;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlexaDayCopyWith<_PlexaDay> get copyWith => __$PlexaDayCopyWithImpl<_PlexaDay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlexaDay&&(identical(other.session, session) || other.session == session)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.connections, connections) || other.connections == connections)&&(identical(other.topVoices, topVoices) || other.topVoices == topVoices)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,session,comments,connections,topVoices,topic);

@override
String toString() {
  return 'PlexaDay(session: $session, comments: $comments, connections: $connections, topVoices: $topVoices, topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$PlexaDayCopyWith<$Res> implements $PlexaDayCopyWith<$Res> {
  factory _$PlexaDayCopyWith(_PlexaDay value, $Res Function(_PlexaDay) _then) = __$PlexaDayCopyWithImpl;
@override @useResult
$Res call({
 PlexaSession session, PlexaLaneState<PlexaComment> comments, PlexaLaneState<PlexaConnection> connections, PlexaLaneState<PlexaTopVoice> topVoices, String topic
});


@override $PlexaSessionCopyWith<$Res> get session;@override $PlexaLaneStateCopyWith<PlexaComment, $Res> get comments;@override $PlexaLaneStateCopyWith<PlexaConnection, $Res> get connections;@override $PlexaLaneStateCopyWith<PlexaTopVoice, $Res> get topVoices;

}
/// @nodoc
class __$PlexaDayCopyWithImpl<$Res>
    implements _$PlexaDayCopyWith<$Res> {
  __$PlexaDayCopyWithImpl(this._self, this._then);

  final _PlexaDay _self;
  final $Res Function(_PlexaDay) _then;

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? comments = null,Object? connections = null,Object? topVoices = null,Object? topic = null,}) {
  return _then(_PlexaDay(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlexaSession,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaComment>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaConnection>,topVoices: null == topVoices ? _self.topVoices : topVoices // ignore: cast_nullable_to_non_nullable
as PlexaLaneState<PlexaTopVoice>,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaSessionCopyWith<$Res> get session {
  
  return $PlexaSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaComment, $Res> get comments {
  
  return $PlexaLaneStateCopyWith<PlexaComment, $Res>(_self.comments, (value) {
    return _then(_self.copyWith(comments: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaConnection, $Res> get connections {
  
  return $PlexaLaneStateCopyWith<PlexaConnection, $Res>(_self.connections, (value) {
    return _then(_self.copyWith(connections: value));
  });
}/// Create a copy of PlexaDay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlexaLaneStateCopyWith<PlexaTopVoice, $Res> get topVoices {
  
  return $PlexaLaneStateCopyWith<PlexaTopVoice, $Res>(_self.topVoices, (value) {
    return _then(_self.copyWith(topVoices: value));
  });
}
}

// dart format on
