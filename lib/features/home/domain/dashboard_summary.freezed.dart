// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardSummary {

 DashboardStats get stats; int get totalImpressions; int get totalEngagements; int get totalFollowers; int get scheduledCount; String get impressionsDelta; String get engagementsDelta; String get followersDelta; List<DashboardPost> get recentPosts; DashboardMission? get mission;
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardSummaryCopyWith<DashboardSummary> get copyWith => _$DashboardSummaryCopyWithImpl<DashboardSummary>(this as DashboardSummary, _$identity);

  /// Serializes this DashboardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardSummary&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.totalImpressions, totalImpressions) || other.totalImpressions == totalImpressions)&&(identical(other.totalEngagements, totalEngagements) || other.totalEngagements == totalEngagements)&&(identical(other.totalFollowers, totalFollowers) || other.totalFollowers == totalFollowers)&&(identical(other.scheduledCount, scheduledCount) || other.scheduledCount == scheduledCount)&&(identical(other.impressionsDelta, impressionsDelta) || other.impressionsDelta == impressionsDelta)&&(identical(other.engagementsDelta, engagementsDelta) || other.engagementsDelta == engagementsDelta)&&(identical(other.followersDelta, followersDelta) || other.followersDelta == followersDelta)&&const DeepCollectionEquality().equals(other.recentPosts, recentPosts)&&(identical(other.mission, mission) || other.mission == mission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,totalImpressions,totalEngagements,totalFollowers,scheduledCount,impressionsDelta,engagementsDelta,followersDelta,const DeepCollectionEquality().hash(recentPosts),mission);

@override
String toString() {
  return 'DashboardSummary(stats: $stats, totalImpressions: $totalImpressions, totalEngagements: $totalEngagements, totalFollowers: $totalFollowers, scheduledCount: $scheduledCount, impressionsDelta: $impressionsDelta, engagementsDelta: $engagementsDelta, followersDelta: $followersDelta, recentPosts: $recentPosts, mission: $mission)';
}


}

/// @nodoc
abstract mixin class $DashboardSummaryCopyWith<$Res>  {
  factory $DashboardSummaryCopyWith(DashboardSummary value, $Res Function(DashboardSummary) _then) = _$DashboardSummaryCopyWithImpl;
@useResult
$Res call({
 DashboardStats stats, int totalImpressions, int totalEngagements, int totalFollowers, int scheduledCount, String impressionsDelta, String engagementsDelta, String followersDelta, List<DashboardPost> recentPosts, DashboardMission? mission
});


$DashboardStatsCopyWith<$Res> get stats;$DashboardMissionCopyWith<$Res>? get mission;

}
/// @nodoc
class _$DashboardSummaryCopyWithImpl<$Res>
    implements $DashboardSummaryCopyWith<$Res> {
  _$DashboardSummaryCopyWithImpl(this._self, this._then);

  final DashboardSummary _self;
  final $Res Function(DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? totalImpressions = null,Object? totalEngagements = null,Object? totalFollowers = null,Object? scheduledCount = null,Object? impressionsDelta = null,Object? engagementsDelta = null,Object? followersDelta = null,Object? recentPosts = null,Object? mission = freezed,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as DashboardStats,totalImpressions: null == totalImpressions ? _self.totalImpressions : totalImpressions // ignore: cast_nullable_to_non_nullable
as int,totalEngagements: null == totalEngagements ? _self.totalEngagements : totalEngagements // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,scheduledCount: null == scheduledCount ? _self.scheduledCount : scheduledCount // ignore: cast_nullable_to_non_nullable
as int,impressionsDelta: null == impressionsDelta ? _self.impressionsDelta : impressionsDelta // ignore: cast_nullable_to_non_nullable
as String,engagementsDelta: null == engagementsDelta ? _self.engagementsDelta : engagementsDelta // ignore: cast_nullable_to_non_nullable
as String,followersDelta: null == followersDelta ? _self.followersDelta : followersDelta // ignore: cast_nullable_to_non_nullable
as String,recentPosts: null == recentPosts ? _self.recentPosts : recentPosts // ignore: cast_nullable_to_non_nullable
as List<DashboardPost>,mission: freezed == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as DashboardMission?,
  ));
}
/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<$Res> get stats {
  
  return $DashboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardMissionCopyWith<$Res>? get mission {
    if (_self.mission == null) {
    return null;
  }

  return $DashboardMissionCopyWith<$Res>(_self.mission!, (value) {
    return _then(_self.copyWith(mission: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardSummary].
extension DashboardSummaryPatterns on DashboardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardSummary value)  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardStats stats,  int totalImpressions,  int totalEngagements,  int totalFollowers,  int scheduledCount,  String impressionsDelta,  String engagementsDelta,  String followersDelta,  List<DashboardPost> recentPosts,  DashboardMission? mission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.stats,_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.scheduledCount,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.recentPosts,_that.mission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardStats stats,  int totalImpressions,  int totalEngagements,  int totalFollowers,  int scheduledCount,  String impressionsDelta,  String engagementsDelta,  String followersDelta,  List<DashboardPost> recentPosts,  DashboardMission? mission)  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary():
return $default(_that.stats,_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.scheduledCount,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.recentPosts,_that.mission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardStats stats,  int totalImpressions,  int totalEngagements,  int totalFollowers,  int scheduledCount,  String impressionsDelta,  String engagementsDelta,  String followersDelta,  List<DashboardPost> recentPosts,  DashboardMission? mission)?  $default,) {final _that = this;
switch (_that) {
case _DashboardSummary() when $default != null:
return $default(_that.stats,_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.scheduledCount,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.recentPosts,_that.mission);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardSummary extends DashboardSummary {
  const _DashboardSummary({required this.stats, this.totalImpressions = 0, this.totalEngagements = 0, this.totalFollowers = 0, this.scheduledCount = 0, this.impressionsDelta = '+0%', this.engagementsDelta = '+0%', this.followersDelta = '+0%', final  List<DashboardPost> recentPosts = const <DashboardPost>[], this.mission}): _recentPosts = recentPosts,super._();
  factory _DashboardSummary.fromJson(Map<String, dynamic> json) => _$DashboardSummaryFromJson(json);

@override final  DashboardStats stats;
@override@JsonKey() final  int totalImpressions;
@override@JsonKey() final  int totalEngagements;
@override@JsonKey() final  int totalFollowers;
@override@JsonKey() final  int scheduledCount;
@override@JsonKey() final  String impressionsDelta;
@override@JsonKey() final  String engagementsDelta;
@override@JsonKey() final  String followersDelta;
 final  List<DashboardPost> _recentPosts;
@override@JsonKey() List<DashboardPost> get recentPosts {
  if (_recentPosts is EqualUnmodifiableListView) return _recentPosts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentPosts);
}

@override final  DashboardMission? mission;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardSummaryCopyWith<_DashboardSummary> get copyWith => __$DashboardSummaryCopyWithImpl<_DashboardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardSummary&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.totalImpressions, totalImpressions) || other.totalImpressions == totalImpressions)&&(identical(other.totalEngagements, totalEngagements) || other.totalEngagements == totalEngagements)&&(identical(other.totalFollowers, totalFollowers) || other.totalFollowers == totalFollowers)&&(identical(other.scheduledCount, scheduledCount) || other.scheduledCount == scheduledCount)&&(identical(other.impressionsDelta, impressionsDelta) || other.impressionsDelta == impressionsDelta)&&(identical(other.engagementsDelta, engagementsDelta) || other.engagementsDelta == engagementsDelta)&&(identical(other.followersDelta, followersDelta) || other.followersDelta == followersDelta)&&const DeepCollectionEquality().equals(other._recentPosts, _recentPosts)&&(identical(other.mission, mission) || other.mission == mission));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,totalImpressions,totalEngagements,totalFollowers,scheduledCount,impressionsDelta,engagementsDelta,followersDelta,const DeepCollectionEquality().hash(_recentPosts),mission);

@override
String toString() {
  return 'DashboardSummary(stats: $stats, totalImpressions: $totalImpressions, totalEngagements: $totalEngagements, totalFollowers: $totalFollowers, scheduledCount: $scheduledCount, impressionsDelta: $impressionsDelta, engagementsDelta: $engagementsDelta, followersDelta: $followersDelta, recentPosts: $recentPosts, mission: $mission)';
}


}

/// @nodoc
abstract mixin class _$DashboardSummaryCopyWith<$Res> implements $DashboardSummaryCopyWith<$Res> {
  factory _$DashboardSummaryCopyWith(_DashboardSummary value, $Res Function(_DashboardSummary) _then) = __$DashboardSummaryCopyWithImpl;
@override @useResult
$Res call({
 DashboardStats stats, int totalImpressions, int totalEngagements, int totalFollowers, int scheduledCount, String impressionsDelta, String engagementsDelta, String followersDelta, List<DashboardPost> recentPosts, DashboardMission? mission
});


@override $DashboardStatsCopyWith<$Res> get stats;@override $DashboardMissionCopyWith<$Res>? get mission;

}
/// @nodoc
class __$DashboardSummaryCopyWithImpl<$Res>
    implements _$DashboardSummaryCopyWith<$Res> {
  __$DashboardSummaryCopyWithImpl(this._self, this._then);

  final _DashboardSummary _self;
  final $Res Function(_DashboardSummary) _then;

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? totalImpressions = null,Object? totalEngagements = null,Object? totalFollowers = null,Object? scheduledCount = null,Object? impressionsDelta = null,Object? engagementsDelta = null,Object? followersDelta = null,Object? recentPosts = null,Object? mission = freezed,}) {
  return _then(_DashboardSummary(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as DashboardStats,totalImpressions: null == totalImpressions ? _self.totalImpressions : totalImpressions // ignore: cast_nullable_to_non_nullable
as int,totalEngagements: null == totalEngagements ? _self.totalEngagements : totalEngagements // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,scheduledCount: null == scheduledCount ? _self.scheduledCount : scheduledCount // ignore: cast_nullable_to_non_nullable
as int,impressionsDelta: null == impressionsDelta ? _self.impressionsDelta : impressionsDelta // ignore: cast_nullable_to_non_nullable
as String,engagementsDelta: null == engagementsDelta ? _self.engagementsDelta : engagementsDelta // ignore: cast_nullable_to_non_nullable
as String,followersDelta: null == followersDelta ? _self.followersDelta : followersDelta // ignore: cast_nullable_to_non_nullable
as String,recentPosts: null == recentPosts ? _self._recentPosts : recentPosts // ignore: cast_nullable_to_non_nullable
as List<DashboardPost>,mission: freezed == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as DashboardMission?,
  ));
}

/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<$Res> get stats {
  
  return $DashboardStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of DashboardSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardMissionCopyWith<$Res>? get mission {
    if (_self.mission == null) {
    return null;
  }

  return $DashboardMissionCopyWith<$Res>(_self.mission!, (value) {
    return _then(_self.copyWith(mission: value));
  });
}
}


/// @nodoc
mixin _$DashboardStats {

 int get streakDays; int get weeklyXp; int get weeklyXpGoal; int get level; String get levelTitle;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.weeklyXp, weeklyXp) || other.weeklyXp == weeklyXp)&&(identical(other.weeklyXpGoal, weeklyXpGoal) || other.weeklyXpGoal == weeklyXpGoal)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakDays,weeklyXp,weeklyXpGoal,level,levelTitle);

@override
String toString() {
  return 'DashboardStats(streakDays: $streakDays, weeklyXp: $weeklyXp, weeklyXpGoal: $weeklyXpGoal, level: $level, levelTitle: $levelTitle)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
 int streakDays, int weeklyXp, int weeklyXpGoal, int level, String levelTitle
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streakDays = null,Object? weeklyXp = null,Object? weeklyXpGoal = null,Object? level = null,Object? levelTitle = null,}) {
  return _then(_self.copyWith(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXpGoal: null == weeklyXpGoal ? _self.weeklyXpGoal : weeklyXpGoal // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStats].
extension DashboardStatsPatterns on DashboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStats value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int streakDays,  int weeklyXp,  int weeklyXpGoal,  int level,  String levelTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.streakDays,_that.weeklyXp,_that.weeklyXpGoal,_that.level,_that.levelTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int streakDays,  int weeklyXp,  int weeklyXpGoal,  int level,  String levelTitle)  $default,) {final _that = this;
switch (_that) {
case _DashboardStats():
return $default(_that.streakDays,_that.weeklyXp,_that.weeklyXpGoal,_that.level,_that.levelTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int streakDays,  int weeklyXp,  int weeklyXpGoal,  int level,  String levelTitle)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.streakDays,_that.weeklyXp,_that.weeklyXpGoal,_that.level,_that.levelTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardStats extends DashboardStats {
  const _DashboardStats({this.streakDays = 0, this.weeklyXp = 0, this.weeklyXpGoal = 2000, this.level = 1, this.levelTitle = 'Beginner'}): super._();
  factory _DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);

@override@JsonKey() final  int streakDays;
@override@JsonKey() final  int weeklyXp;
@override@JsonKey() final  int weeklyXpGoal;
@override@JsonKey() final  int level;
@override@JsonKey() final  String levelTitle;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.weeklyXp, weeklyXp) || other.weeklyXp == weeklyXp)&&(identical(other.weeklyXpGoal, weeklyXpGoal) || other.weeklyXpGoal == weeklyXpGoal)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakDays,weeklyXp,weeklyXpGoal,level,levelTitle);

@override
String toString() {
  return 'DashboardStats(streakDays: $streakDays, weeklyXp: $weeklyXp, weeklyXpGoal: $weeklyXpGoal, level: $level, levelTitle: $levelTitle)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int streakDays, int weeklyXp, int weeklyXpGoal, int level, String levelTitle
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streakDays = null,Object? weeklyXp = null,Object? weeklyXpGoal = null,Object? level = null,Object? levelTitle = null,}) {
  return _then(_DashboardStats(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXpGoal: null == weeklyXpGoal ? _self.weeklyXpGoal : weeklyXpGoal // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardPost {

 String get id; String get preview; DashboardPostStatus get status; int get impressions; int get engagements; bool get hasMetrics;
/// Create a copy of DashboardPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPostCopyWith<DashboardPost> get copyWith => _$DashboardPostCopyWithImpl<DashboardPost>(this as DashboardPost, _$identity);

  /// Serializes this DashboardPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPost&&(identical(other.id, id) || other.id == id)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.status, status) || other.status == status)&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.hasMetrics, hasMetrics) || other.hasMetrics == hasMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,preview,status,impressions,engagements,hasMetrics);

@override
String toString() {
  return 'DashboardPost(id: $id, preview: $preview, status: $status, impressions: $impressions, engagements: $engagements, hasMetrics: $hasMetrics)';
}


}

/// @nodoc
abstract mixin class $DashboardPostCopyWith<$Res>  {
  factory $DashboardPostCopyWith(DashboardPost value, $Res Function(DashboardPost) _then) = _$DashboardPostCopyWithImpl;
@useResult
$Res call({
 String id, String preview, DashboardPostStatus status, int impressions, int engagements, bool hasMetrics
});




}
/// @nodoc
class _$DashboardPostCopyWithImpl<$Res>
    implements $DashboardPostCopyWith<$Res> {
  _$DashboardPostCopyWithImpl(this._self, this._then);

  final DashboardPost _self;
  final $Res Function(DashboardPost) _then;

/// Create a copy of DashboardPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? preview = null,Object? status = null,Object? impressions = null,Object? engagements = null,Object? hasMetrics = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DashboardPostStatus,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,hasMetrics: null == hasMetrics ? _self.hasMetrics : hasMetrics // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPost].
extension DashboardPostPatterns on DashboardPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPost value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPost value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String preview,  DashboardPostStatus status,  int impressions,  int engagements,  bool hasMetrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPost() when $default != null:
return $default(_that.id,_that.preview,_that.status,_that.impressions,_that.engagements,_that.hasMetrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String preview,  DashboardPostStatus status,  int impressions,  int engagements,  bool hasMetrics)  $default,) {final _that = this;
switch (_that) {
case _DashboardPost():
return $default(_that.id,_that.preview,_that.status,_that.impressions,_that.engagements,_that.hasMetrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String preview,  DashboardPostStatus status,  int impressions,  int engagements,  bool hasMetrics)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPost() when $default != null:
return $default(_that.id,_that.preview,_that.status,_that.impressions,_that.engagements,_that.hasMetrics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPost extends DashboardPost {
  const _DashboardPost({required this.id, required this.preview, this.status = DashboardPostStatus.draft, this.impressions = 0, this.engagements = 0, this.hasMetrics = false}): super._();
  factory _DashboardPost.fromJson(Map<String, dynamic> json) => _$DashboardPostFromJson(json);

@override final  String id;
@override final  String preview;
@override@JsonKey() final  DashboardPostStatus status;
@override@JsonKey() final  int impressions;
@override@JsonKey() final  int engagements;
@override@JsonKey() final  bool hasMetrics;

/// Create a copy of DashboardPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPostCopyWith<_DashboardPost> get copyWith => __$DashboardPostCopyWithImpl<_DashboardPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPost&&(identical(other.id, id) || other.id == id)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.status, status) || other.status == status)&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.hasMetrics, hasMetrics) || other.hasMetrics == hasMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,preview,status,impressions,engagements,hasMetrics);

@override
String toString() {
  return 'DashboardPost(id: $id, preview: $preview, status: $status, impressions: $impressions, engagements: $engagements, hasMetrics: $hasMetrics)';
}


}

/// @nodoc
abstract mixin class _$DashboardPostCopyWith<$Res> implements $DashboardPostCopyWith<$Res> {
  factory _$DashboardPostCopyWith(_DashboardPost value, $Res Function(_DashboardPost) _then) = __$DashboardPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String preview, DashboardPostStatus status, int impressions, int engagements, bool hasMetrics
});




}
/// @nodoc
class __$DashboardPostCopyWithImpl<$Res>
    implements _$DashboardPostCopyWith<$Res> {
  __$DashboardPostCopyWithImpl(this._self, this._then);

  final _DashboardPost _self;
  final $Res Function(_DashboardPost) _then;

/// Create a copy of DashboardPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? preview = null,Object? status = null,Object? impressions = null,Object? engagements = null,Object? hasMetrics = null,}) {
  return _then(_DashboardPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DashboardPostStatus,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,hasMetrics: null == hasMetrics ? _self.hasMetrics : hasMetrics // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DashboardMission {

 String get title; String get statusLabel;
/// Create a copy of DashboardMission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardMissionCopyWith<DashboardMission> get copyWith => _$DashboardMissionCopyWithImpl<DashboardMission>(this as DashboardMission, _$identity);

  /// Serializes this DashboardMission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardMission&&(identical(other.title, title) || other.title == title)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,statusLabel);

@override
String toString() {
  return 'DashboardMission(title: $title, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class $DashboardMissionCopyWith<$Res>  {
  factory $DashboardMissionCopyWith(DashboardMission value, $Res Function(DashboardMission) _then) = _$DashboardMissionCopyWithImpl;
@useResult
$Res call({
 String title, String statusLabel
});




}
/// @nodoc
class _$DashboardMissionCopyWithImpl<$Res>
    implements $DashboardMissionCopyWith<$Res> {
  _$DashboardMissionCopyWithImpl(this._self, this._then);

  final DashboardMission _self;
  final $Res Function(DashboardMission) _then;

/// Create a copy of DashboardMission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? statusLabel = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardMission].
extension DashboardMissionPatterns on DashboardMission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardMission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardMission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardMission value)  $default,){
final _that = this;
switch (_that) {
case _DashboardMission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardMission value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardMission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String statusLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardMission() when $default != null:
return $default(_that.title,_that.statusLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String statusLabel)  $default,) {final _that = this;
switch (_that) {
case _DashboardMission():
return $default(_that.title,_that.statusLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String statusLabel)?  $default,) {final _that = this;
switch (_that) {
case _DashboardMission() when $default != null:
return $default(_that.title,_that.statusLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardMission implements DashboardMission {
  const _DashboardMission({required this.title, this.statusLabel = 'Active'});
  factory _DashboardMission.fromJson(Map<String, dynamic> json) => _$DashboardMissionFromJson(json);

@override final  String title;
@override@JsonKey() final  String statusLabel;

/// Create a copy of DashboardMission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardMissionCopyWith<_DashboardMission> get copyWith => __$DashboardMissionCopyWithImpl<_DashboardMission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardMissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardMission&&(identical(other.title, title) || other.title == title)&&(identical(other.statusLabel, statusLabel) || other.statusLabel == statusLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,statusLabel);

@override
String toString() {
  return 'DashboardMission(title: $title, statusLabel: $statusLabel)';
}


}

/// @nodoc
abstract mixin class _$DashboardMissionCopyWith<$Res> implements $DashboardMissionCopyWith<$Res> {
  factory _$DashboardMissionCopyWith(_DashboardMission value, $Res Function(_DashboardMission) _then) = __$DashboardMissionCopyWithImpl;
@override @useResult
$Res call({
 String title, String statusLabel
});




}
/// @nodoc
class __$DashboardMissionCopyWithImpl<$Res>
    implements _$DashboardMissionCopyWith<$Res> {
  __$DashboardMissionCopyWithImpl(this._self, this._then);

  final _DashboardMission _self;
  final $Res Function(_DashboardMission) _then;

/// Create a copy of DashboardMission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? statusLabel = null,}) {
  return _then(_DashboardMission(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,statusLabel: null == statusLabel ? _self.statusLabel : statusLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
