// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roadmap_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoadmapProgress {

/// 1..66. Day 1 is the day the roadmap started.
 int get currentDay;/// Completion keys, each `'<levelId>-<stepId>'`. The composite key is why
/// the Sunday reach task is step 5 and not 4 — step 4 already belongs to
/// the day-1..4 profile extras, and a collision would have each step
/// marking the other done.
 List<String> get completedSteps;/// Needed on the CLIENT, not just the server: the Sunday reach task only
/// exists on days the client can prove are Sundays. Without it the app
/// rebuilds a roadmap with no Sundays in it and that task never renders,
/// however correctly the server placed it.
 DateTime? get roadmapStartedAt;/// `'personal'` | `'company'`. Decides which roadmap is built.
 String get brandType;/// An AI post written for today and waiting for approval. Its presence
/// rewrites today's publish task into "Approve Your Daily Post".
 String? get pendingPostIdToday;/// An approved post already queued to publish.
 String? get scheduledPostId; DateTime? get scheduledPostAt;
/// Create a copy of RoadmapProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoadmapProgressCopyWith<RoadmapProgress> get copyWith => _$RoadmapProgressCopyWithImpl<RoadmapProgress>(this as RoadmapProgress, _$identity);

  /// Serializes this RoadmapProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoadmapProgress&&(identical(other.currentDay, currentDay) || other.currentDay == currentDay)&&const DeepCollectionEquality().equals(other.completedSteps, completedSteps)&&(identical(other.roadmapStartedAt, roadmapStartedAt) || other.roadmapStartedAt == roadmapStartedAt)&&(identical(other.brandType, brandType) || other.brandType == brandType)&&(identical(other.pendingPostIdToday, pendingPostIdToday) || other.pendingPostIdToday == pendingPostIdToday)&&(identical(other.scheduledPostId, scheduledPostId) || other.scheduledPostId == scheduledPostId)&&(identical(other.scheduledPostAt, scheduledPostAt) || other.scheduledPostAt == scheduledPostAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentDay,const DeepCollectionEquality().hash(completedSteps),roadmapStartedAt,brandType,pendingPostIdToday,scheduledPostId,scheduledPostAt);

@override
String toString() {
  return 'RoadmapProgress(currentDay: $currentDay, completedSteps: $completedSteps, roadmapStartedAt: $roadmapStartedAt, brandType: $brandType, pendingPostIdToday: $pendingPostIdToday, scheduledPostId: $scheduledPostId, scheduledPostAt: $scheduledPostAt)';
}


}

/// @nodoc
abstract mixin class $RoadmapProgressCopyWith<$Res>  {
  factory $RoadmapProgressCopyWith(RoadmapProgress value, $Res Function(RoadmapProgress) _then) = _$RoadmapProgressCopyWithImpl;
@useResult
$Res call({
 int currentDay, List<String> completedSteps, DateTime? roadmapStartedAt, String brandType, String? pendingPostIdToday, String? scheduledPostId, DateTime? scheduledPostAt
});




}
/// @nodoc
class _$RoadmapProgressCopyWithImpl<$Res>
    implements $RoadmapProgressCopyWith<$Res> {
  _$RoadmapProgressCopyWithImpl(this._self, this._then);

  final RoadmapProgress _self;
  final $Res Function(RoadmapProgress) _then;

/// Create a copy of RoadmapProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDay = null,Object? completedSteps = null,Object? roadmapStartedAt = freezed,Object? brandType = null,Object? pendingPostIdToday = freezed,Object? scheduledPostId = freezed,Object? scheduledPostAt = freezed,}) {
  return _then(_self.copyWith(
currentDay: null == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int,completedSteps: null == completedSteps ? _self.completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<String>,roadmapStartedAt: freezed == roadmapStartedAt ? _self.roadmapStartedAt : roadmapStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandType: null == brandType ? _self.brandType : brandType // ignore: cast_nullable_to_non_nullable
as String,pendingPostIdToday: freezed == pendingPostIdToday ? _self.pendingPostIdToday : pendingPostIdToday // ignore: cast_nullable_to_non_nullable
as String?,scheduledPostId: freezed == scheduledPostId ? _self.scheduledPostId : scheduledPostId // ignore: cast_nullable_to_non_nullable
as String?,scheduledPostAt: freezed == scheduledPostAt ? _self.scheduledPostAt : scheduledPostAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoadmapProgress].
extension RoadmapProgressPatterns on RoadmapProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoadmapProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoadmapProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoadmapProgress value)  $default,){
final _that = this;
switch (_that) {
case _RoadmapProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoadmapProgress value)?  $default,){
final _that = this;
switch (_that) {
case _RoadmapProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentDay,  List<String> completedSteps,  DateTime? roadmapStartedAt,  String brandType,  String? pendingPostIdToday,  String? scheduledPostId,  DateTime? scheduledPostAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoadmapProgress() when $default != null:
return $default(_that.currentDay,_that.completedSteps,_that.roadmapStartedAt,_that.brandType,_that.pendingPostIdToday,_that.scheduledPostId,_that.scheduledPostAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentDay,  List<String> completedSteps,  DateTime? roadmapStartedAt,  String brandType,  String? pendingPostIdToday,  String? scheduledPostId,  DateTime? scheduledPostAt)  $default,) {final _that = this;
switch (_that) {
case _RoadmapProgress():
return $default(_that.currentDay,_that.completedSteps,_that.roadmapStartedAt,_that.brandType,_that.pendingPostIdToday,_that.scheduledPostId,_that.scheduledPostAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentDay,  List<String> completedSteps,  DateTime? roadmapStartedAt,  String brandType,  String? pendingPostIdToday,  String? scheduledPostId,  DateTime? scheduledPostAt)?  $default,) {final _that = this;
switch (_that) {
case _RoadmapProgress() when $default != null:
return $default(_that.currentDay,_that.completedSteps,_that.roadmapStartedAt,_that.brandType,_that.pendingPostIdToday,_that.scheduledPostId,_that.scheduledPostAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoadmapProgress extends RoadmapProgress {
  const _RoadmapProgress({this.currentDay = 1, final  List<String> completedSteps = const <String>[], this.roadmapStartedAt, this.brandType = 'personal', this.pendingPostIdToday, this.scheduledPostId, this.scheduledPostAt}): _completedSteps = completedSteps,super._();
  factory _RoadmapProgress.fromJson(Map<String, dynamic> json) => _$RoadmapProgressFromJson(json);

/// 1..66. Day 1 is the day the roadmap started.
@override@JsonKey() final  int currentDay;
/// Completion keys, each `'<levelId>-<stepId>'`. The composite key is why
/// the Sunday reach task is step 5 and not 4 — step 4 already belongs to
/// the day-1..4 profile extras, and a collision would have each step
/// marking the other done.
 final  List<String> _completedSteps;
/// Completion keys, each `'<levelId>-<stepId>'`. The composite key is why
/// the Sunday reach task is step 5 and not 4 — step 4 already belongs to
/// the day-1..4 profile extras, and a collision would have each step
/// marking the other done.
@override@JsonKey() List<String> get completedSteps {
  if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSteps);
}

/// Needed on the CLIENT, not just the server: the Sunday reach task only
/// exists on days the client can prove are Sundays. Without it the app
/// rebuilds a roadmap with no Sundays in it and that task never renders,
/// however correctly the server placed it.
@override final  DateTime? roadmapStartedAt;
/// `'personal'` | `'company'`. Decides which roadmap is built.
@override@JsonKey() final  String brandType;
/// An AI post written for today and waiting for approval. Its presence
/// rewrites today's publish task into "Approve Your Daily Post".
@override final  String? pendingPostIdToday;
/// An approved post already queued to publish.
@override final  String? scheduledPostId;
@override final  DateTime? scheduledPostAt;

/// Create a copy of RoadmapProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoadmapProgressCopyWith<_RoadmapProgress> get copyWith => __$RoadmapProgressCopyWithImpl<_RoadmapProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoadmapProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoadmapProgress&&(identical(other.currentDay, currentDay) || other.currentDay == currentDay)&&const DeepCollectionEquality().equals(other._completedSteps, _completedSteps)&&(identical(other.roadmapStartedAt, roadmapStartedAt) || other.roadmapStartedAt == roadmapStartedAt)&&(identical(other.brandType, brandType) || other.brandType == brandType)&&(identical(other.pendingPostIdToday, pendingPostIdToday) || other.pendingPostIdToday == pendingPostIdToday)&&(identical(other.scheduledPostId, scheduledPostId) || other.scheduledPostId == scheduledPostId)&&(identical(other.scheduledPostAt, scheduledPostAt) || other.scheduledPostAt == scheduledPostAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentDay,const DeepCollectionEquality().hash(_completedSteps),roadmapStartedAt,brandType,pendingPostIdToday,scheduledPostId,scheduledPostAt);

@override
String toString() {
  return 'RoadmapProgress(currentDay: $currentDay, completedSteps: $completedSteps, roadmapStartedAt: $roadmapStartedAt, brandType: $brandType, pendingPostIdToday: $pendingPostIdToday, scheduledPostId: $scheduledPostId, scheduledPostAt: $scheduledPostAt)';
}


}

/// @nodoc
abstract mixin class _$RoadmapProgressCopyWith<$Res> implements $RoadmapProgressCopyWith<$Res> {
  factory _$RoadmapProgressCopyWith(_RoadmapProgress value, $Res Function(_RoadmapProgress) _then) = __$RoadmapProgressCopyWithImpl;
@override @useResult
$Res call({
 int currentDay, List<String> completedSteps, DateTime? roadmapStartedAt, String brandType, String? pendingPostIdToday, String? scheduledPostId, DateTime? scheduledPostAt
});




}
/// @nodoc
class __$RoadmapProgressCopyWithImpl<$Res>
    implements _$RoadmapProgressCopyWith<$Res> {
  __$RoadmapProgressCopyWithImpl(this._self, this._then);

  final _RoadmapProgress _self;
  final $Res Function(_RoadmapProgress) _then;

/// Create a copy of RoadmapProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDay = null,Object? completedSteps = null,Object? roadmapStartedAt = freezed,Object? brandType = null,Object? pendingPostIdToday = freezed,Object? scheduledPostId = freezed,Object? scheduledPostAt = freezed,}) {
  return _then(_RoadmapProgress(
currentDay: null == currentDay ? _self.currentDay : currentDay // ignore: cast_nullable_to_non_nullable
as int,completedSteps: null == completedSteps ? _self._completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<String>,roadmapStartedAt: freezed == roadmapStartedAt ? _self.roadmapStartedAt : roadmapStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,brandType: null == brandType ? _self.brandType : brandType // ignore: cast_nullable_to_non_nullable
as String,pendingPostIdToday: freezed == pendingPostIdToday ? _self.pendingPostIdToday : pendingPostIdToday // ignore: cast_nullable_to_non_nullable
as String?,scheduledPostId: freezed == scheduledPostId ? _self.scheduledPostId : scheduledPostId // ignore: cast_nullable_to_non_nullable
as String?,scheduledPostAt: freezed == scheduledPostAt ? _self.scheduledPostAt : scheduledPostAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
