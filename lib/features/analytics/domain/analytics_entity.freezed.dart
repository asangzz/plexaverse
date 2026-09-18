// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopPostSummary {

 int get postId; String get preview; int get impressions; int get engagements; double get engagementRate;
/// Create a copy of TopPostSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopPostSummaryCopyWith<TopPostSummary> get copyWith => _$TopPostSummaryCopyWithImpl<TopPostSummary>(this as TopPostSummary, _$identity);

  /// Serializes this TopPostSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopPostSummary&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.engagementRate, engagementRate) || other.engagementRate == engagementRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,preview,impressions,engagements,engagementRate);

@override
String toString() {
  return 'TopPostSummary(postId: $postId, preview: $preview, impressions: $impressions, engagements: $engagements, engagementRate: $engagementRate)';
}


}

/// @nodoc
abstract mixin class $TopPostSummaryCopyWith<$Res>  {
  factory $TopPostSummaryCopyWith(TopPostSummary value, $Res Function(TopPostSummary) _then) = _$TopPostSummaryCopyWithImpl;
@useResult
$Res call({
 int postId, String preview, int impressions, int engagements, double engagementRate
});




}
/// @nodoc
class _$TopPostSummaryCopyWithImpl<$Res>
    implements $TopPostSummaryCopyWith<$Res> {
  _$TopPostSummaryCopyWithImpl(this._self, this._then);

  final TopPostSummary _self;
  final $Res Function(TopPostSummary) _then;

/// Create a copy of TopPostSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = null,Object? preview = null,Object? impressions = null,Object? engagements = null,Object? engagementRate = null,}) {
  return _then(_self.copyWith(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,engagementRate: null == engagementRate ? _self.engagementRate : engagementRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TopPostSummary].
extension TopPostSummaryPatterns on TopPostSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopPostSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopPostSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopPostSummary value)  $default,){
final _that = this;
switch (_that) {
case _TopPostSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopPostSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TopPostSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int postId,  String preview,  int impressions,  int engagements,  double engagementRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopPostSummary() when $default != null:
return $default(_that.postId,_that.preview,_that.impressions,_that.engagements,_that.engagementRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int postId,  String preview,  int impressions,  int engagements,  double engagementRate)  $default,) {final _that = this;
switch (_that) {
case _TopPostSummary():
return $default(_that.postId,_that.preview,_that.impressions,_that.engagements,_that.engagementRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int postId,  String preview,  int impressions,  int engagements,  double engagementRate)?  $default,) {final _that = this;
switch (_that) {
case _TopPostSummary() when $default != null:
return $default(_that.postId,_that.preview,_that.impressions,_that.engagements,_that.engagementRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopPostSummary implements TopPostSummary {
  const _TopPostSummary({required this.postId, required this.preview, this.impressions = 0, this.engagements = 0, this.engagementRate = 0.0});
  factory _TopPostSummary.fromJson(Map<String, dynamic> json) => _$TopPostSummaryFromJson(json);

@override final  int postId;
@override final  String preview;
@override@JsonKey() final  int impressions;
@override@JsonKey() final  int engagements;
@override@JsonKey() final  double engagementRate;

/// Create a copy of TopPostSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopPostSummaryCopyWith<_TopPostSummary> get copyWith => __$TopPostSummaryCopyWithImpl<_TopPostSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopPostSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopPostSummary&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.engagements, engagements) || other.engagements == engagements)&&(identical(other.engagementRate, engagementRate) || other.engagementRate == engagementRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,preview,impressions,engagements,engagementRate);

@override
String toString() {
  return 'TopPostSummary(postId: $postId, preview: $preview, impressions: $impressions, engagements: $engagements, engagementRate: $engagementRate)';
}


}

/// @nodoc
abstract mixin class _$TopPostSummaryCopyWith<$Res> implements $TopPostSummaryCopyWith<$Res> {
  factory _$TopPostSummaryCopyWith(_TopPostSummary value, $Res Function(_TopPostSummary) _then) = __$TopPostSummaryCopyWithImpl;
@override @useResult
$Res call({
 int postId, String preview, int impressions, int engagements, double engagementRate
});




}
/// @nodoc
class __$TopPostSummaryCopyWithImpl<$Res>
    implements _$TopPostSummaryCopyWith<$Res> {
  __$TopPostSummaryCopyWithImpl(this._self, this._then);

  final _TopPostSummary _self;
  final $Res Function(_TopPostSummary) _then;

/// Create a copy of TopPostSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = null,Object? preview = null,Object? impressions = null,Object? engagements = null,Object? engagementRate = null,}) {
  return _then(_TopPostSummary(
postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,engagements: null == engagements ? _self.engagements : engagements // ignore: cast_nullable_to_non_nullable
as int,engagementRate: null == engagementRate ? _self.engagementRate : engagementRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AnalyticsEntity {

// Hero metric
 int get totalImpressions; int get totalEngagements; int get totalFollowers;// Period-over-period deltas (percentage points)
 double get impressionsDelta; double get engagementsDelta; double get followersDelta;// Sub-metrics
 int get reactions; int get comments; int get reposts; double get reactionsDelta; double get commentsDelta; double get repostsDelta;// Chart: normalized 0-1 values for the selected time range
 List<double> get impressionSeries;// Best post in the period
 TopPostSummary? get topPost;// Impressions by weekday Mon-Sun (index 0=Mon)
 List<int> get weekdayImpressions;
/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsEntityCopyWith<AnalyticsEntity> get copyWith => _$AnalyticsEntityCopyWithImpl<AnalyticsEntity>(this as AnalyticsEntity, _$identity);

  /// Serializes this AnalyticsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsEntity&&(identical(other.totalImpressions, totalImpressions) || other.totalImpressions == totalImpressions)&&(identical(other.totalEngagements, totalEngagements) || other.totalEngagements == totalEngagements)&&(identical(other.totalFollowers, totalFollowers) || other.totalFollowers == totalFollowers)&&(identical(other.impressionsDelta, impressionsDelta) || other.impressionsDelta == impressionsDelta)&&(identical(other.engagementsDelta, engagementsDelta) || other.engagementsDelta == engagementsDelta)&&(identical(other.followersDelta, followersDelta) || other.followersDelta == followersDelta)&&(identical(other.reactions, reactions) || other.reactions == reactions)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.reactionsDelta, reactionsDelta) || other.reactionsDelta == reactionsDelta)&&(identical(other.commentsDelta, commentsDelta) || other.commentsDelta == commentsDelta)&&(identical(other.repostsDelta, repostsDelta) || other.repostsDelta == repostsDelta)&&const DeepCollectionEquality().equals(other.impressionSeries, impressionSeries)&&(identical(other.topPost, topPost) || other.topPost == topPost)&&const DeepCollectionEquality().equals(other.weekdayImpressions, weekdayImpressions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalImpressions,totalEngagements,totalFollowers,impressionsDelta,engagementsDelta,followersDelta,reactions,comments,reposts,reactionsDelta,commentsDelta,repostsDelta,const DeepCollectionEquality().hash(impressionSeries),topPost,const DeepCollectionEquality().hash(weekdayImpressions));

@override
String toString() {
  return 'AnalyticsEntity(totalImpressions: $totalImpressions, totalEngagements: $totalEngagements, totalFollowers: $totalFollowers, impressionsDelta: $impressionsDelta, engagementsDelta: $engagementsDelta, followersDelta: $followersDelta, reactions: $reactions, comments: $comments, reposts: $reposts, reactionsDelta: $reactionsDelta, commentsDelta: $commentsDelta, repostsDelta: $repostsDelta, impressionSeries: $impressionSeries, topPost: $topPost, weekdayImpressions: $weekdayImpressions)';
}


}

/// @nodoc
abstract mixin class $AnalyticsEntityCopyWith<$Res>  {
  factory $AnalyticsEntityCopyWith(AnalyticsEntity value, $Res Function(AnalyticsEntity) _then) = _$AnalyticsEntityCopyWithImpl;
@useResult
$Res call({
 int totalImpressions, int totalEngagements, int totalFollowers, double impressionsDelta, double engagementsDelta, double followersDelta, int reactions, int comments, int reposts, double reactionsDelta, double commentsDelta, double repostsDelta, List<double> impressionSeries, TopPostSummary? topPost, List<int> weekdayImpressions
});


$TopPostSummaryCopyWith<$Res>? get topPost;

}
/// @nodoc
class _$AnalyticsEntityCopyWithImpl<$Res>
    implements $AnalyticsEntityCopyWith<$Res> {
  _$AnalyticsEntityCopyWithImpl(this._self, this._then);

  final AnalyticsEntity _self;
  final $Res Function(AnalyticsEntity) _then;

/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalImpressions = null,Object? totalEngagements = null,Object? totalFollowers = null,Object? impressionsDelta = null,Object? engagementsDelta = null,Object? followersDelta = null,Object? reactions = null,Object? comments = null,Object? reposts = null,Object? reactionsDelta = null,Object? commentsDelta = null,Object? repostsDelta = null,Object? impressionSeries = null,Object? topPost = freezed,Object? weekdayImpressions = null,}) {
  return _then(_self.copyWith(
totalImpressions: null == totalImpressions ? _self.totalImpressions : totalImpressions // ignore: cast_nullable_to_non_nullable
as int,totalEngagements: null == totalEngagements ? _self.totalEngagements : totalEngagements // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,impressionsDelta: null == impressionsDelta ? _self.impressionsDelta : impressionsDelta // ignore: cast_nullable_to_non_nullable
as double,engagementsDelta: null == engagementsDelta ? _self.engagementsDelta : engagementsDelta // ignore: cast_nullable_to_non_nullable
as double,followersDelta: null == followersDelta ? _self.followersDelta : followersDelta // ignore: cast_nullable_to_non_nullable
as double,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,reactionsDelta: null == reactionsDelta ? _self.reactionsDelta : reactionsDelta // ignore: cast_nullable_to_non_nullable
as double,commentsDelta: null == commentsDelta ? _self.commentsDelta : commentsDelta // ignore: cast_nullable_to_non_nullable
as double,repostsDelta: null == repostsDelta ? _self.repostsDelta : repostsDelta // ignore: cast_nullable_to_non_nullable
as double,impressionSeries: null == impressionSeries ? _self.impressionSeries : impressionSeries // ignore: cast_nullable_to_non_nullable
as List<double>,topPost: freezed == topPost ? _self.topPost : topPost // ignore: cast_nullable_to_non_nullable
as TopPostSummary?,weekdayImpressions: null == weekdayImpressions ? _self.weekdayImpressions : weekdayImpressions // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopPostSummaryCopyWith<$Res>? get topPost {
    if (_self.topPost == null) {
    return null;
  }

  return $TopPostSummaryCopyWith<$Res>(_self.topPost!, (value) {
    return _then(_self.copyWith(topPost: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsEntity].
extension AnalyticsEntityPatterns on AnalyticsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsEntity value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalImpressions,  int totalEngagements,  int totalFollowers,  double impressionsDelta,  double engagementsDelta,  double followersDelta,  int reactions,  int comments,  int reposts,  double reactionsDelta,  double commentsDelta,  double repostsDelta,  List<double> impressionSeries,  TopPostSummary? topPost,  List<int> weekdayImpressions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsEntity() when $default != null:
return $default(_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.reactions,_that.comments,_that.reposts,_that.reactionsDelta,_that.commentsDelta,_that.repostsDelta,_that.impressionSeries,_that.topPost,_that.weekdayImpressions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalImpressions,  int totalEngagements,  int totalFollowers,  double impressionsDelta,  double engagementsDelta,  double followersDelta,  int reactions,  int comments,  int reposts,  double reactionsDelta,  double commentsDelta,  double repostsDelta,  List<double> impressionSeries,  TopPostSummary? topPost,  List<int> weekdayImpressions)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsEntity():
return $default(_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.reactions,_that.comments,_that.reposts,_that.reactionsDelta,_that.commentsDelta,_that.repostsDelta,_that.impressionSeries,_that.topPost,_that.weekdayImpressions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalImpressions,  int totalEngagements,  int totalFollowers,  double impressionsDelta,  double engagementsDelta,  double followersDelta,  int reactions,  int comments,  int reposts,  double reactionsDelta,  double commentsDelta,  double repostsDelta,  List<double> impressionSeries,  TopPostSummary? topPost,  List<int> weekdayImpressions)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsEntity() when $default != null:
return $default(_that.totalImpressions,_that.totalEngagements,_that.totalFollowers,_that.impressionsDelta,_that.engagementsDelta,_that.followersDelta,_that.reactions,_that.comments,_that.reposts,_that.reactionsDelta,_that.commentsDelta,_that.repostsDelta,_that.impressionSeries,_that.topPost,_that.weekdayImpressions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsEntity extends AnalyticsEntity {
  const _AnalyticsEntity({this.totalImpressions = 0, this.totalEngagements = 0, this.totalFollowers = 0, this.impressionsDelta = 0.0, this.engagementsDelta = 0.0, this.followersDelta = 0.0, this.reactions = 0, this.comments = 0, this.reposts = 0, this.reactionsDelta = 0.0, this.commentsDelta = 0.0, this.repostsDelta = 0.0, final  List<double> impressionSeries = const <double>[], this.topPost, final  List<int> weekdayImpressions = const <int>[0, 0, 0, 0, 0, 0, 0]}): _impressionSeries = impressionSeries,_weekdayImpressions = weekdayImpressions,super._();
  factory _AnalyticsEntity.fromJson(Map<String, dynamic> json) => _$AnalyticsEntityFromJson(json);

// Hero metric
@override@JsonKey() final  int totalImpressions;
@override@JsonKey() final  int totalEngagements;
@override@JsonKey() final  int totalFollowers;
// Period-over-period deltas (percentage points)
@override@JsonKey() final  double impressionsDelta;
@override@JsonKey() final  double engagementsDelta;
@override@JsonKey() final  double followersDelta;
// Sub-metrics
@override@JsonKey() final  int reactions;
@override@JsonKey() final  int comments;
@override@JsonKey() final  int reposts;
@override@JsonKey() final  double reactionsDelta;
@override@JsonKey() final  double commentsDelta;
@override@JsonKey() final  double repostsDelta;
// Chart: normalized 0-1 values for the selected time range
 final  List<double> _impressionSeries;
// Chart: normalized 0-1 values for the selected time range
@override@JsonKey() List<double> get impressionSeries {
  if (_impressionSeries is EqualUnmodifiableListView) return _impressionSeries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_impressionSeries);
}

// Best post in the period
@override final  TopPostSummary? topPost;
// Impressions by weekday Mon-Sun (index 0=Mon)
 final  List<int> _weekdayImpressions;
// Impressions by weekday Mon-Sun (index 0=Mon)
@override@JsonKey() List<int> get weekdayImpressions {
  if (_weekdayImpressions is EqualUnmodifiableListView) return _weekdayImpressions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdayImpressions);
}


/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsEntityCopyWith<_AnalyticsEntity> get copyWith => __$AnalyticsEntityCopyWithImpl<_AnalyticsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsEntity&&(identical(other.totalImpressions, totalImpressions) || other.totalImpressions == totalImpressions)&&(identical(other.totalEngagements, totalEngagements) || other.totalEngagements == totalEngagements)&&(identical(other.totalFollowers, totalFollowers) || other.totalFollowers == totalFollowers)&&(identical(other.impressionsDelta, impressionsDelta) || other.impressionsDelta == impressionsDelta)&&(identical(other.engagementsDelta, engagementsDelta) || other.engagementsDelta == engagementsDelta)&&(identical(other.followersDelta, followersDelta) || other.followersDelta == followersDelta)&&(identical(other.reactions, reactions) || other.reactions == reactions)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.reposts, reposts) || other.reposts == reposts)&&(identical(other.reactionsDelta, reactionsDelta) || other.reactionsDelta == reactionsDelta)&&(identical(other.commentsDelta, commentsDelta) || other.commentsDelta == commentsDelta)&&(identical(other.repostsDelta, repostsDelta) || other.repostsDelta == repostsDelta)&&const DeepCollectionEquality().equals(other._impressionSeries, _impressionSeries)&&(identical(other.topPost, topPost) || other.topPost == topPost)&&const DeepCollectionEquality().equals(other._weekdayImpressions, _weekdayImpressions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalImpressions,totalEngagements,totalFollowers,impressionsDelta,engagementsDelta,followersDelta,reactions,comments,reposts,reactionsDelta,commentsDelta,repostsDelta,const DeepCollectionEquality().hash(_impressionSeries),topPost,const DeepCollectionEquality().hash(_weekdayImpressions));

@override
String toString() {
  return 'AnalyticsEntity(totalImpressions: $totalImpressions, totalEngagements: $totalEngagements, totalFollowers: $totalFollowers, impressionsDelta: $impressionsDelta, engagementsDelta: $engagementsDelta, followersDelta: $followersDelta, reactions: $reactions, comments: $comments, reposts: $reposts, reactionsDelta: $reactionsDelta, commentsDelta: $commentsDelta, repostsDelta: $repostsDelta, impressionSeries: $impressionSeries, topPost: $topPost, weekdayImpressions: $weekdayImpressions)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsEntityCopyWith<$Res> implements $AnalyticsEntityCopyWith<$Res> {
  factory _$AnalyticsEntityCopyWith(_AnalyticsEntity value, $Res Function(_AnalyticsEntity) _then) = __$AnalyticsEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalImpressions, int totalEngagements, int totalFollowers, double impressionsDelta, double engagementsDelta, double followersDelta, int reactions, int comments, int reposts, double reactionsDelta, double commentsDelta, double repostsDelta, List<double> impressionSeries, TopPostSummary? topPost, List<int> weekdayImpressions
});


@override $TopPostSummaryCopyWith<$Res>? get topPost;

}
/// @nodoc
class __$AnalyticsEntityCopyWithImpl<$Res>
    implements _$AnalyticsEntityCopyWith<$Res> {
  __$AnalyticsEntityCopyWithImpl(this._self, this._then);

  final _AnalyticsEntity _self;
  final $Res Function(_AnalyticsEntity) _then;

/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalImpressions = null,Object? totalEngagements = null,Object? totalFollowers = null,Object? impressionsDelta = null,Object? engagementsDelta = null,Object? followersDelta = null,Object? reactions = null,Object? comments = null,Object? reposts = null,Object? reactionsDelta = null,Object? commentsDelta = null,Object? repostsDelta = null,Object? impressionSeries = null,Object? topPost = freezed,Object? weekdayImpressions = null,}) {
  return _then(_AnalyticsEntity(
totalImpressions: null == totalImpressions ? _self.totalImpressions : totalImpressions // ignore: cast_nullable_to_non_nullable
as int,totalEngagements: null == totalEngagements ? _self.totalEngagements : totalEngagements // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,impressionsDelta: null == impressionsDelta ? _self.impressionsDelta : impressionsDelta // ignore: cast_nullable_to_non_nullable
as double,engagementsDelta: null == engagementsDelta ? _self.engagementsDelta : engagementsDelta // ignore: cast_nullable_to_non_nullable
as double,followersDelta: null == followersDelta ? _self.followersDelta : followersDelta // ignore: cast_nullable_to_non_nullable
as double,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,reposts: null == reposts ? _self.reposts : reposts // ignore: cast_nullable_to_non_nullable
as int,reactionsDelta: null == reactionsDelta ? _self.reactionsDelta : reactionsDelta // ignore: cast_nullable_to_non_nullable
as double,commentsDelta: null == commentsDelta ? _self.commentsDelta : commentsDelta // ignore: cast_nullable_to_non_nullable
as double,repostsDelta: null == repostsDelta ? _self.repostsDelta : repostsDelta // ignore: cast_nullable_to_non_nullable
as double,impressionSeries: null == impressionSeries ? _self._impressionSeries : impressionSeries // ignore: cast_nullable_to_non_nullable
as List<double>,topPost: freezed == topPost ? _self.topPost : topPost // ignore: cast_nullable_to_non_nullable
as TopPostSummary?,weekdayImpressions: null == weekdayImpressions ? _self._weekdayImpressions : weekdayImpressions // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of AnalyticsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TopPostSummaryCopyWith<$Res>? get topPost {
    if (_self.topPost == null) {
    return null;
  }

  return $TopPostSummaryCopyWith<$Res>(_self.topPost!, (value) {
    return _then(_self.copyWith(topPost: value));
  });
}
}

// dart format on
