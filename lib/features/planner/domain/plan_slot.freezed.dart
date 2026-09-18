// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanSlot {

/// 'Monday' … 'Sunday'.
 String get day;/// The content type — 'niche', 'general', 'productive', 'poll'.
 String get type;/// 'text' | 'image' | 'poll' | 'carousel'.
 String get format;/// The editorial angle the model was given. Free text it may rewrite.
 String get angle; String get title; bool get titleEditedByUser; List<String> get hashtags;@JsonKey(unknownEnumValue: SlotStatus.planned) SlotStatus get status;/// The server id of the generated post, once one exists.
 String? get postId;/// A maintenance-mode rest day. Reduced-cadence users (3 posts a week) get
/// these; the Sunday article still generates regardless, because it is the
/// week's spine rather than one of its posts.
 bool get restDay;/// This slot carries a takeaway in its first comment. Decided by the
/// planner rather than at generation time, so the user can see which days
/// will have one before any of them are written.
 String? get artifact;/// Which poster style this day gets — 'comparison', 'infographic', …
/// A property of the WEEK, not a coin flip per post.
 String? get posterTag;
/// Create a copy of PlanSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanSlotCopyWith<PlanSlot> get copyWith => _$PlanSlotCopyWithImpl<PlanSlot>(this as PlanSlot, _$identity);

  /// Serializes this PlanSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanSlot&&(identical(other.day, day) || other.day == day)&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleEditedByUser, titleEditedByUser) || other.titleEditedByUser == titleEditedByUser)&&const DeepCollectionEquality().equals(other.hashtags, hashtags)&&(identical(other.status, status) || other.status == status)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.restDay, restDay) || other.restDay == restDay)&&(identical(other.artifact, artifact) || other.artifact == artifact)&&(identical(other.posterTag, posterTag) || other.posterTag == posterTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,type,format,angle,title,titleEditedByUser,const DeepCollectionEquality().hash(hashtags),status,postId,restDay,artifact,posterTag);

@override
String toString() {
  return 'PlanSlot(day: $day, type: $type, format: $format, angle: $angle, title: $title, titleEditedByUser: $titleEditedByUser, hashtags: $hashtags, status: $status, postId: $postId, restDay: $restDay, artifact: $artifact, posterTag: $posterTag)';
}


}

/// @nodoc
abstract mixin class $PlanSlotCopyWith<$Res>  {
  factory $PlanSlotCopyWith(PlanSlot value, $Res Function(PlanSlot) _then) = _$PlanSlotCopyWithImpl;
@useResult
$Res call({
 String day, String type, String format, String angle, String title, bool titleEditedByUser, List<String> hashtags,@JsonKey(unknownEnumValue: SlotStatus.planned) SlotStatus status, String? postId, bool restDay, String? artifact, String? posterTag
});




}
/// @nodoc
class _$PlanSlotCopyWithImpl<$Res>
    implements $PlanSlotCopyWith<$Res> {
  _$PlanSlotCopyWithImpl(this._self, this._then);

  final PlanSlot _self;
  final $Res Function(PlanSlot) _then;

/// Create a copy of PlanSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? type = null,Object? format = null,Object? angle = null,Object? title = null,Object? titleEditedByUser = null,Object? hashtags = null,Object? status = null,Object? postId = freezed,Object? restDay = null,Object? artifact = freezed,Object? posterTag = freezed,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleEditedByUser: null == titleEditedByUser ? _self.titleEditedByUser : titleEditedByUser // ignore: cast_nullable_to_non_nullable
as bool,hashtags: null == hashtags ? _self.hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SlotStatus,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,restDay: null == restDay ? _self.restDay : restDay // ignore: cast_nullable_to_non_nullable
as bool,artifact: freezed == artifact ? _self.artifact : artifact // ignore: cast_nullable_to_non_nullable
as String?,posterTag: freezed == posterTag ? _self.posterTag : posterTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanSlot].
extension PlanSlotPatterns on PlanSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanSlot value)  $default,){
final _that = this;
switch (_that) {
case _PlanSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanSlot value)?  $default,){
final _that = this;
switch (_that) {
case _PlanSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String day,  String type,  String format,  String angle,  String title,  bool titleEditedByUser,  List<String> hashtags, @JsonKey(unknownEnumValue: SlotStatus.planned)  SlotStatus status,  String? postId,  bool restDay,  String? artifact,  String? posterTag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanSlot() when $default != null:
return $default(_that.day,_that.type,_that.format,_that.angle,_that.title,_that.titleEditedByUser,_that.hashtags,_that.status,_that.postId,_that.restDay,_that.artifact,_that.posterTag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String day,  String type,  String format,  String angle,  String title,  bool titleEditedByUser,  List<String> hashtags, @JsonKey(unknownEnumValue: SlotStatus.planned)  SlotStatus status,  String? postId,  bool restDay,  String? artifact,  String? posterTag)  $default,) {final _that = this;
switch (_that) {
case _PlanSlot():
return $default(_that.day,_that.type,_that.format,_that.angle,_that.title,_that.titleEditedByUser,_that.hashtags,_that.status,_that.postId,_that.restDay,_that.artifact,_that.posterTag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String day,  String type,  String format,  String angle,  String title,  bool titleEditedByUser,  List<String> hashtags, @JsonKey(unknownEnumValue: SlotStatus.planned)  SlotStatus status,  String? postId,  bool restDay,  String? artifact,  String? posterTag)?  $default,) {final _that = this;
switch (_that) {
case _PlanSlot() when $default != null:
return $default(_that.day,_that.type,_that.format,_that.angle,_that.title,_that.titleEditedByUser,_that.hashtags,_that.status,_that.postId,_that.restDay,_that.artifact,_that.posterTag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanSlot extends PlanSlot {
  const _PlanSlot({required this.day, this.type = 'general', this.format = 'text', this.angle = '', this.title = '', this.titleEditedByUser = false, final  List<String> hashtags = const <String>[], @JsonKey(unknownEnumValue: SlotStatus.planned) this.status = SlotStatus.planned, this.postId, this.restDay = false, this.artifact, this.posterTag}): _hashtags = hashtags,super._();
  factory _PlanSlot.fromJson(Map<String, dynamic> json) => _$PlanSlotFromJson(json);

/// 'Monday' … 'Sunday'.
@override final  String day;
/// The content type — 'niche', 'general', 'productive', 'poll'.
@override@JsonKey() final  String type;
/// 'text' | 'image' | 'poll' | 'carousel'.
@override@JsonKey() final  String format;
/// The editorial angle the model was given. Free text it may rewrite.
@override@JsonKey() final  String angle;
@override@JsonKey() final  String title;
@override@JsonKey() final  bool titleEditedByUser;
 final  List<String> _hashtags;
@override@JsonKey() List<String> get hashtags {
  if (_hashtags is EqualUnmodifiableListView) return _hashtags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hashtags);
}

@override@JsonKey(unknownEnumValue: SlotStatus.planned) final  SlotStatus status;
/// The server id of the generated post, once one exists.
@override final  String? postId;
/// A maintenance-mode rest day. Reduced-cadence users (3 posts a week) get
/// these; the Sunday article still generates regardless, because it is the
/// week's spine rather than one of its posts.
@override@JsonKey() final  bool restDay;
/// This slot carries a takeaway in its first comment. Decided by the
/// planner rather than at generation time, so the user can see which days
/// will have one before any of them are written.
@override final  String? artifact;
/// Which poster style this day gets — 'comparison', 'infographic', …
/// A property of the WEEK, not a coin flip per post.
@override final  String? posterTag;

/// Create a copy of PlanSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanSlotCopyWith<_PlanSlot> get copyWith => __$PlanSlotCopyWithImpl<_PlanSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanSlot&&(identical(other.day, day) || other.day == day)&&(identical(other.type, type) || other.type == type)&&(identical(other.format, format) || other.format == format)&&(identical(other.angle, angle) || other.angle == angle)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleEditedByUser, titleEditedByUser) || other.titleEditedByUser == titleEditedByUser)&&const DeepCollectionEquality().equals(other._hashtags, _hashtags)&&(identical(other.status, status) || other.status == status)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.restDay, restDay) || other.restDay == restDay)&&(identical(other.artifact, artifact) || other.artifact == artifact)&&(identical(other.posterTag, posterTag) || other.posterTag == posterTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,type,format,angle,title,titleEditedByUser,const DeepCollectionEquality().hash(_hashtags),status,postId,restDay,artifact,posterTag);

@override
String toString() {
  return 'PlanSlot(day: $day, type: $type, format: $format, angle: $angle, title: $title, titleEditedByUser: $titleEditedByUser, hashtags: $hashtags, status: $status, postId: $postId, restDay: $restDay, artifact: $artifact, posterTag: $posterTag)';
}


}

/// @nodoc
abstract mixin class _$PlanSlotCopyWith<$Res> implements $PlanSlotCopyWith<$Res> {
  factory _$PlanSlotCopyWith(_PlanSlot value, $Res Function(_PlanSlot) _then) = __$PlanSlotCopyWithImpl;
@override @useResult
$Res call({
 String day, String type, String format, String angle, String title, bool titleEditedByUser, List<String> hashtags,@JsonKey(unknownEnumValue: SlotStatus.planned) SlotStatus status, String? postId, bool restDay, String? artifact, String? posterTag
});




}
/// @nodoc
class __$PlanSlotCopyWithImpl<$Res>
    implements _$PlanSlotCopyWith<$Res> {
  __$PlanSlotCopyWithImpl(this._self, this._then);

  final _PlanSlot _self;
  final $Res Function(_PlanSlot) _then;

/// Create a copy of PlanSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? type = null,Object? format = null,Object? angle = null,Object? title = null,Object? titleEditedByUser = null,Object? hashtags = null,Object? status = null,Object? postId = freezed,Object? restDay = null,Object? artifact = freezed,Object? posterTag = freezed,}) {
  return _then(_PlanSlot(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,angle: null == angle ? _self.angle : angle // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleEditedByUser: null == titleEditedByUser ? _self.titleEditedByUser : titleEditedByUser // ignore: cast_nullable_to_non_nullable
as bool,hashtags: null == hashtags ? _self._hashtags : hashtags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SlotStatus,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,restDay: null == restDay ? _self.restDay : restDay // ignore: cast_nullable_to_non_nullable
as bool,artifact: freezed == artifact ? _self.artifact : artifact // ignore: cast_nullable_to_non_nullable
as String?,posterTag: freezed == posterTag ? _self.posterTag : posterTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$WeekPlan {

 String get id; int get weekNumber; int get season; String? get phase; String? get topic; List<PlanSlot> get posts; String? get generatedAt;
/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekPlanCopyWith<WeekPlan> get copyWith => _$WeekPlanCopyWithImpl<WeekPlan>(this as WeekPlan, _$identity);

  /// Serializes this WeekPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.topic, topic) || other.topic == topic)&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,phase,topic,const DeepCollectionEquality().hash(posts),generatedAt);

@override
String toString() {
  return 'WeekPlan(id: $id, weekNumber: $weekNumber, season: $season, phase: $phase, topic: $topic, posts: $posts, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class $WeekPlanCopyWith<$Res>  {
  factory $WeekPlanCopyWith(WeekPlan value, $Res Function(WeekPlan) _then) = _$WeekPlanCopyWithImpl;
@useResult
$Res call({
 String id, int weekNumber, int season, String? phase, String? topic, List<PlanSlot> posts, String? generatedAt
});




}
/// @nodoc
class _$WeekPlanCopyWithImpl<$Res>
    implements $WeekPlanCopyWith<$Res> {
  _$WeekPlanCopyWithImpl(this._self, this._then);

  final WeekPlan _self;
  final $Res Function(WeekPlan) _then;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? phase = freezed,Object? topic = freezed,Object? posts = null,Object? generatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,phase: freezed == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<PlanSlot>,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekPlan].
extension WeekPlanPatterns on WeekPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekPlan value)  $default,){
final _that = this;
switch (_that) {
case _WeekPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekPlan value)?  $default,){
final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  String? phase,  String? topic,  List<PlanSlot> posts,  String? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.phase,_that.topic,_that.posts,_that.generatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int weekNumber,  int season,  String? phase,  String? topic,  List<PlanSlot> posts,  String? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _WeekPlan():
return $default(_that.id,_that.weekNumber,_that.season,_that.phase,_that.topic,_that.posts,_that.generatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int weekNumber,  int season,  String? phase,  String? topic,  List<PlanSlot> posts,  String? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WeekPlan() when $default != null:
return $default(_that.id,_that.weekNumber,_that.season,_that.phase,_that.topic,_that.posts,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekPlan extends WeekPlan {
  const _WeekPlan({required this.id, required this.weekNumber, required this.season, this.phase, this.topic, final  List<PlanSlot> posts = const <PlanSlot>[], this.generatedAt}): _posts = posts,super._();
  factory _WeekPlan.fromJson(Map<String, dynamic> json) => _$WeekPlanFromJson(json);

@override final  String id;
@override final  int weekNumber;
@override final  int season;
@override final  String? phase;
@override final  String? topic;
 final  List<PlanSlot> _posts;
@override@JsonKey() List<PlanSlot> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override final  String? generatedAt;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekPlanCopyWith<_WeekPlan> get copyWith => __$WeekPlanCopyWithImpl<_WeekPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.season, season) || other.season == season)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.topic, topic) || other.topic == topic)&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,weekNumber,season,phase,topic,const DeepCollectionEquality().hash(_posts),generatedAt);

@override
String toString() {
  return 'WeekPlan(id: $id, weekNumber: $weekNumber, season: $season, phase: $phase, topic: $topic, posts: $posts, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$WeekPlanCopyWith<$Res> implements $WeekPlanCopyWith<$Res> {
  factory _$WeekPlanCopyWith(_WeekPlan value, $Res Function(_WeekPlan) _then) = __$WeekPlanCopyWithImpl;
@override @useResult
$Res call({
 String id, int weekNumber, int season, String? phase, String? topic, List<PlanSlot> posts, String? generatedAt
});




}
/// @nodoc
class __$WeekPlanCopyWithImpl<$Res>
    implements _$WeekPlanCopyWith<$Res> {
  __$WeekPlanCopyWithImpl(this._self, this._then);

  final _WeekPlan _self;
  final $Res Function(_WeekPlan) _then;

/// Create a copy of WeekPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? weekNumber = null,Object? season = null,Object? phase = freezed,Object? topic = freezed,Object? posts = null,Object? generatedAt = freezed,}) {
  return _then(_WeekPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as int,phase: freezed == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as String?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<PlanSlot>,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlannerState {

 WeekPlan? get plan; int get currentWeekNumber; int get currentSeason; String? get upcomingTopic; String? get upcomingPhase; String? get upcomingTitle;
/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannerStateCopyWith<PlannerState> get copyWith => _$PlannerStateCopyWithImpl<PlannerState>(this as PlannerState, _$identity);

  /// Serializes this PlannerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannerState&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.currentWeekNumber, currentWeekNumber) || other.currentWeekNumber == currentWeekNumber)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.upcomingTopic, upcomingTopic) || other.upcomingTopic == upcomingTopic)&&(identical(other.upcomingPhase, upcomingPhase) || other.upcomingPhase == upcomingPhase)&&(identical(other.upcomingTitle, upcomingTitle) || other.upcomingTitle == upcomingTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,currentWeekNumber,currentSeason,upcomingTopic,upcomingPhase,upcomingTitle);

@override
String toString() {
  return 'PlannerState(plan: $plan, currentWeekNumber: $currentWeekNumber, currentSeason: $currentSeason, upcomingTopic: $upcomingTopic, upcomingPhase: $upcomingPhase, upcomingTitle: $upcomingTitle)';
}


}

/// @nodoc
abstract mixin class $PlannerStateCopyWith<$Res>  {
  factory $PlannerStateCopyWith(PlannerState value, $Res Function(PlannerState) _then) = _$PlannerStateCopyWithImpl;
@useResult
$Res call({
 WeekPlan? plan, int currentWeekNumber, int currentSeason, String? upcomingTopic, String? upcomingPhase, String? upcomingTitle
});


$WeekPlanCopyWith<$Res>? get plan;

}
/// @nodoc
class _$PlannerStateCopyWithImpl<$Res>
    implements $PlannerStateCopyWith<$Res> {
  _$PlannerStateCopyWithImpl(this._self, this._then);

  final PlannerState _self;
  final $Res Function(PlannerState) _then;

/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = freezed,Object? currentWeekNumber = null,Object? currentSeason = null,Object? upcomingTopic = freezed,Object? upcomingPhase = freezed,Object? upcomingTitle = freezed,}) {
  return _then(_self.copyWith(
plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WeekPlan?,currentWeekNumber: null == currentWeekNumber ? _self.currentWeekNumber : currentWeekNumber // ignore: cast_nullable_to_non_nullable
as int,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int,upcomingTopic: freezed == upcomingTopic ? _self.upcomingTopic : upcomingTopic // ignore: cast_nullable_to_non_nullable
as String?,upcomingPhase: freezed == upcomingPhase ? _self.upcomingPhase : upcomingPhase // ignore: cast_nullable_to_non_nullable
as String?,upcomingTitle: freezed == upcomingTitle ? _self.upcomingTitle : upcomingTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekPlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $WeekPlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlannerState].
extension PlannerStatePatterns on PlannerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannerState value)  $default,){
final _that = this;
switch (_that) {
case _PlannerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlannerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeekPlan? plan,  int currentWeekNumber,  int currentSeason,  String? upcomingTopic,  String? upcomingPhase,  String? upcomingTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannerState() when $default != null:
return $default(_that.plan,_that.currentWeekNumber,_that.currentSeason,_that.upcomingTopic,_that.upcomingPhase,_that.upcomingTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeekPlan? plan,  int currentWeekNumber,  int currentSeason,  String? upcomingTopic,  String? upcomingPhase,  String? upcomingTitle)  $default,) {final _that = this;
switch (_that) {
case _PlannerState():
return $default(_that.plan,_that.currentWeekNumber,_that.currentSeason,_that.upcomingTopic,_that.upcomingPhase,_that.upcomingTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeekPlan? plan,  int currentWeekNumber,  int currentSeason,  String? upcomingTopic,  String? upcomingPhase,  String? upcomingTitle)?  $default,) {final _that = this;
switch (_that) {
case _PlannerState() when $default != null:
return $default(_that.plan,_that.currentWeekNumber,_that.currentSeason,_that.upcomingTopic,_that.upcomingPhase,_that.upcomingTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlannerState extends PlannerState {
  const _PlannerState({this.plan, this.currentWeekNumber = 1, this.currentSeason = 1, this.upcomingTopic, this.upcomingPhase, this.upcomingTitle}): super._();
  factory _PlannerState.fromJson(Map<String, dynamic> json) => _$PlannerStateFromJson(json);

@override final  WeekPlan? plan;
@override@JsonKey() final  int currentWeekNumber;
@override@JsonKey() final  int currentSeason;
@override final  String? upcomingTopic;
@override final  String? upcomingPhase;
@override final  String? upcomingTitle;

/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannerStateCopyWith<_PlannerState> get copyWith => __$PlannerStateCopyWithImpl<_PlannerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlannerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannerState&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.currentWeekNumber, currentWeekNumber) || other.currentWeekNumber == currentWeekNumber)&&(identical(other.currentSeason, currentSeason) || other.currentSeason == currentSeason)&&(identical(other.upcomingTopic, upcomingTopic) || other.upcomingTopic == upcomingTopic)&&(identical(other.upcomingPhase, upcomingPhase) || other.upcomingPhase == upcomingPhase)&&(identical(other.upcomingTitle, upcomingTitle) || other.upcomingTitle == upcomingTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,plan,currentWeekNumber,currentSeason,upcomingTopic,upcomingPhase,upcomingTitle);

@override
String toString() {
  return 'PlannerState(plan: $plan, currentWeekNumber: $currentWeekNumber, currentSeason: $currentSeason, upcomingTopic: $upcomingTopic, upcomingPhase: $upcomingPhase, upcomingTitle: $upcomingTitle)';
}


}

/// @nodoc
abstract mixin class _$PlannerStateCopyWith<$Res> implements $PlannerStateCopyWith<$Res> {
  factory _$PlannerStateCopyWith(_PlannerState value, $Res Function(_PlannerState) _then) = __$PlannerStateCopyWithImpl;
@override @useResult
$Res call({
 WeekPlan? plan, int currentWeekNumber, int currentSeason, String? upcomingTopic, String? upcomingPhase, String? upcomingTitle
});


@override $WeekPlanCopyWith<$Res>? get plan;

}
/// @nodoc
class __$PlannerStateCopyWithImpl<$Res>
    implements _$PlannerStateCopyWith<$Res> {
  __$PlannerStateCopyWithImpl(this._self, this._then);

  final _PlannerState _self;
  final $Res Function(_PlannerState) _then;

/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = freezed,Object? currentWeekNumber = null,Object? currentSeason = null,Object? upcomingTopic = freezed,Object? upcomingPhase = freezed,Object? upcomingTitle = freezed,}) {
  return _then(_PlannerState(
plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as WeekPlan?,currentWeekNumber: null == currentWeekNumber ? _self.currentWeekNumber : currentWeekNumber // ignore: cast_nullable_to_non_nullable
as int,currentSeason: null == currentSeason ? _self.currentSeason : currentSeason // ignore: cast_nullable_to_non_nullable
as int,upcomingTopic: freezed == upcomingTopic ? _self.upcomingTopic : upcomingTopic // ignore: cast_nullable_to_non_nullable
as String?,upcomingPhase: freezed == upcomingPhase ? _self.upcomingPhase : upcomingPhase // ignore: cast_nullable_to_non_nullable
as String?,upcomingTitle: freezed == upcomingTitle ? _self.upcomingTitle : upcomingTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PlannerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekPlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $WeekPlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

// dart format on
