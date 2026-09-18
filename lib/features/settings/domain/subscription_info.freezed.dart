// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubscriptionInfo {

/// Plan display name — "Creator" on the gradient card.
 String get planName;/// Provenance line on the card's right ("From Plexaverse web app").
 String get source;/// Credits left this cycle — "453 remaining".
 int get creditsRemaining;/// Monthly plan allowance — "600 credits".
 int get creditsTotal;/// Unused Digital Twin slots — "4 avatar slots remaining".
 int get avatarSlotsRemaining;/// Fixed Digital Twin quota — the 5 segments of the quota bar.
 int get avatarSlotsTotal;/// "Recent Activity" rows in the Subscription sheet, newest first.
 List<SubscriptionActivity> get recentActivity;
/// Create a copy of SubscriptionInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionInfoCopyWith<SubscriptionInfo> get copyWith => _$SubscriptionInfoCopyWithImpl<SubscriptionInfo>(this as SubscriptionInfo, _$identity);

  /// Serializes this SubscriptionInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionInfo&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.source, source) || other.source == source)&&(identical(other.creditsRemaining, creditsRemaining) || other.creditsRemaining == creditsRemaining)&&(identical(other.creditsTotal, creditsTotal) || other.creditsTotal == creditsTotal)&&(identical(other.avatarSlotsRemaining, avatarSlotsRemaining) || other.avatarSlotsRemaining == avatarSlotsRemaining)&&(identical(other.avatarSlotsTotal, avatarSlotsTotal) || other.avatarSlotsTotal == avatarSlotsTotal)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planName,source,creditsRemaining,creditsTotal,avatarSlotsRemaining,avatarSlotsTotal,const DeepCollectionEquality().hash(recentActivity));

@override
String toString() {
  return 'SubscriptionInfo(planName: $planName, source: $source, creditsRemaining: $creditsRemaining, creditsTotal: $creditsTotal, avatarSlotsRemaining: $avatarSlotsRemaining, avatarSlotsTotal: $avatarSlotsTotal, recentActivity: $recentActivity)';
}


}

/// @nodoc
abstract mixin class $SubscriptionInfoCopyWith<$Res>  {
  factory $SubscriptionInfoCopyWith(SubscriptionInfo value, $Res Function(SubscriptionInfo) _then) = _$SubscriptionInfoCopyWithImpl;
@useResult
$Res call({
 String planName, String source, int creditsRemaining, int creditsTotal, int avatarSlotsRemaining, int avatarSlotsTotal, List<SubscriptionActivity> recentActivity
});




}
/// @nodoc
class _$SubscriptionInfoCopyWithImpl<$Res>
    implements $SubscriptionInfoCopyWith<$Res> {
  _$SubscriptionInfoCopyWithImpl(this._self, this._then);

  final SubscriptionInfo _self;
  final $Res Function(SubscriptionInfo) _then;

/// Create a copy of SubscriptionInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planName = null,Object? source = null,Object? creditsRemaining = null,Object? creditsTotal = null,Object? avatarSlotsRemaining = null,Object? avatarSlotsTotal = null,Object? recentActivity = null,}) {
  return _then(_self.copyWith(
planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,creditsRemaining: null == creditsRemaining ? _self.creditsRemaining : creditsRemaining // ignore: cast_nullable_to_non_nullable
as int,creditsTotal: null == creditsTotal ? _self.creditsTotal : creditsTotal // ignore: cast_nullable_to_non_nullable
as int,avatarSlotsRemaining: null == avatarSlotsRemaining ? _self.avatarSlotsRemaining : avatarSlotsRemaining // ignore: cast_nullable_to_non_nullable
as int,avatarSlotsTotal: null == avatarSlotsTotal ? _self.avatarSlotsTotal : avatarSlotsTotal // ignore: cast_nullable_to_non_nullable
as int,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<SubscriptionActivity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionInfo].
extension SubscriptionInfoPatterns on SubscriptionInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionInfo value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planName,  String source,  int creditsRemaining,  int creditsTotal,  int avatarSlotsRemaining,  int avatarSlotsTotal,  List<SubscriptionActivity> recentActivity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionInfo() when $default != null:
return $default(_that.planName,_that.source,_that.creditsRemaining,_that.creditsTotal,_that.avatarSlotsRemaining,_that.avatarSlotsTotal,_that.recentActivity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planName,  String source,  int creditsRemaining,  int creditsTotal,  int avatarSlotsRemaining,  int avatarSlotsTotal,  List<SubscriptionActivity> recentActivity)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionInfo():
return $default(_that.planName,_that.source,_that.creditsRemaining,_that.creditsTotal,_that.avatarSlotsRemaining,_that.avatarSlotsTotal,_that.recentActivity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planName,  String source,  int creditsRemaining,  int creditsTotal,  int avatarSlotsRemaining,  int avatarSlotsTotal,  List<SubscriptionActivity> recentActivity)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionInfo() when $default != null:
return $default(_that.planName,_that.source,_that.creditsRemaining,_that.creditsTotal,_that.avatarSlotsRemaining,_that.avatarSlotsTotal,_that.recentActivity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionInfo extends SubscriptionInfo {
  const _SubscriptionInfo({required this.planName, required this.source, required this.creditsRemaining, required this.creditsTotal, required this.avatarSlotsRemaining, required this.avatarSlotsTotal, final  List<SubscriptionActivity> recentActivity = const <SubscriptionActivity>[]}): _recentActivity = recentActivity,super._();
  factory _SubscriptionInfo.fromJson(Map<String, dynamic> json) => _$SubscriptionInfoFromJson(json);

/// Plan display name — "Creator" on the gradient card.
@override final  String planName;
/// Provenance line on the card's right ("From Plexaverse web app").
@override final  String source;
/// Credits left this cycle — "453 remaining".
@override final  int creditsRemaining;
/// Monthly plan allowance — "600 credits".
@override final  int creditsTotal;
/// Unused Digital Twin slots — "4 avatar slots remaining".
@override final  int avatarSlotsRemaining;
/// Fixed Digital Twin quota — the 5 segments of the quota bar.
@override final  int avatarSlotsTotal;
/// "Recent Activity" rows in the Subscription sheet, newest first.
 final  List<SubscriptionActivity> _recentActivity;
/// "Recent Activity" rows in the Subscription sheet, newest first.
@override@JsonKey() List<SubscriptionActivity> get recentActivity {
  if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivity);
}


/// Create a copy of SubscriptionInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionInfoCopyWith<_SubscriptionInfo> get copyWith => __$SubscriptionInfoCopyWithImpl<_SubscriptionInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionInfo&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.source, source) || other.source == source)&&(identical(other.creditsRemaining, creditsRemaining) || other.creditsRemaining == creditsRemaining)&&(identical(other.creditsTotal, creditsTotal) || other.creditsTotal == creditsTotal)&&(identical(other.avatarSlotsRemaining, avatarSlotsRemaining) || other.avatarSlotsRemaining == avatarSlotsRemaining)&&(identical(other.avatarSlotsTotal, avatarSlotsTotal) || other.avatarSlotsTotal == avatarSlotsTotal)&&const DeepCollectionEquality().equals(other._recentActivity, _recentActivity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planName,source,creditsRemaining,creditsTotal,avatarSlotsRemaining,avatarSlotsTotal,const DeepCollectionEquality().hash(_recentActivity));

@override
String toString() {
  return 'SubscriptionInfo(planName: $planName, source: $source, creditsRemaining: $creditsRemaining, creditsTotal: $creditsTotal, avatarSlotsRemaining: $avatarSlotsRemaining, avatarSlotsTotal: $avatarSlotsTotal, recentActivity: $recentActivity)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionInfoCopyWith<$Res> implements $SubscriptionInfoCopyWith<$Res> {
  factory _$SubscriptionInfoCopyWith(_SubscriptionInfo value, $Res Function(_SubscriptionInfo) _then) = __$SubscriptionInfoCopyWithImpl;
@override @useResult
$Res call({
 String planName, String source, int creditsRemaining, int creditsTotal, int avatarSlotsRemaining, int avatarSlotsTotal, List<SubscriptionActivity> recentActivity
});




}
/// @nodoc
class __$SubscriptionInfoCopyWithImpl<$Res>
    implements _$SubscriptionInfoCopyWith<$Res> {
  __$SubscriptionInfoCopyWithImpl(this._self, this._then);

  final _SubscriptionInfo _self;
  final $Res Function(_SubscriptionInfo) _then;

/// Create a copy of SubscriptionInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planName = null,Object? source = null,Object? creditsRemaining = null,Object? creditsTotal = null,Object? avatarSlotsRemaining = null,Object? avatarSlotsTotal = null,Object? recentActivity = null,}) {
  return _then(_SubscriptionInfo(
planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,creditsRemaining: null == creditsRemaining ? _self.creditsRemaining : creditsRemaining // ignore: cast_nullable_to_non_nullable
as int,creditsTotal: null == creditsTotal ? _self.creditsTotal : creditsTotal // ignore: cast_nullable_to_non_nullable
as int,avatarSlotsRemaining: null == avatarSlotsRemaining ? _self.avatarSlotsRemaining : avatarSlotsRemaining // ignore: cast_nullable_to_non_nullable
as int,avatarSlotsTotal: null == avatarSlotsTotal ? _self.avatarSlotsTotal : avatarSlotsTotal // ignore: cast_nullable_to_non_nullable
as int,recentActivity: null == recentActivity ? _self._recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<SubscriptionActivity>,
  ));
}


}


/// @nodoc
mixin _$SubscriptionActivity {

/// Row title — "Quick Avatar Video".
 String get title;/// Relative timestamp — "3h ago".
 String get timeAgo;/// Activity kind — "Video" / "AI asset" / "Video Agent".
 String get kind;/// Signed credit change; spends are negative ("-3 credits").
 int get creditsDelta;/// "0:08" duration chip on video thumbnails; absent (not null) in the
/// JSON for non-video activity (e.g. an AI asset).
@JsonKey(includeIfNull: false) String? get durationLabel;
/// Create a copy of SubscriptionActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionActivityCopyWith<SubscriptionActivity> get copyWith => _$SubscriptionActivityCopyWithImpl<SubscriptionActivity>(this as SubscriptionActivity, _$identity);

  /// Serializes this SubscriptionActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionActivity&&(identical(other.title, title) || other.title == title)&&(identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.creditsDelta, creditsDelta) || other.creditsDelta == creditsDelta)&&(identical(other.durationLabel, durationLabel) || other.durationLabel == durationLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,timeAgo,kind,creditsDelta,durationLabel);

@override
String toString() {
  return 'SubscriptionActivity(title: $title, timeAgo: $timeAgo, kind: $kind, creditsDelta: $creditsDelta, durationLabel: $durationLabel)';
}


}

/// @nodoc
abstract mixin class $SubscriptionActivityCopyWith<$Res>  {
  factory $SubscriptionActivityCopyWith(SubscriptionActivity value, $Res Function(SubscriptionActivity) _then) = _$SubscriptionActivityCopyWithImpl;
@useResult
$Res call({
 String title, String timeAgo, String kind, int creditsDelta,@JsonKey(includeIfNull: false) String? durationLabel
});




}
/// @nodoc
class _$SubscriptionActivityCopyWithImpl<$Res>
    implements $SubscriptionActivityCopyWith<$Res> {
  _$SubscriptionActivityCopyWithImpl(this._self, this._then);

  final SubscriptionActivity _self;
  final $Res Function(SubscriptionActivity) _then;

/// Create a copy of SubscriptionActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? timeAgo = null,Object? kind = null,Object? creditsDelta = null,Object? durationLabel = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timeAgo: null == timeAgo ? _self.timeAgo : timeAgo // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,creditsDelta: null == creditsDelta ? _self.creditsDelta : creditsDelta // ignore: cast_nullable_to_non_nullable
as int,durationLabel: freezed == durationLabel ? _self.durationLabel : durationLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionActivity].
extension SubscriptionActivityPatterns on SubscriptionActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionActivity value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionActivity value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String timeAgo,  String kind,  int creditsDelta, @JsonKey(includeIfNull: false)  String? durationLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionActivity() when $default != null:
return $default(_that.title,_that.timeAgo,_that.kind,_that.creditsDelta,_that.durationLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String timeAgo,  String kind,  int creditsDelta, @JsonKey(includeIfNull: false)  String? durationLabel)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionActivity():
return $default(_that.title,_that.timeAgo,_that.kind,_that.creditsDelta,_that.durationLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String timeAgo,  String kind,  int creditsDelta, @JsonKey(includeIfNull: false)  String? durationLabel)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionActivity() when $default != null:
return $default(_that.title,_that.timeAgo,_that.kind,_that.creditsDelta,_that.durationLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionActivity extends SubscriptionActivity {
  const _SubscriptionActivity({required this.title, required this.timeAgo, required this.kind, required this.creditsDelta, @JsonKey(includeIfNull: false) this.durationLabel}): super._();
  factory _SubscriptionActivity.fromJson(Map<String, dynamic> json) => _$SubscriptionActivityFromJson(json);

/// Row title — "Quick Avatar Video".
@override final  String title;
/// Relative timestamp — "3h ago".
@override final  String timeAgo;
/// Activity kind — "Video" / "AI asset" / "Video Agent".
@override final  String kind;
/// Signed credit change; spends are negative ("-3 credits").
@override final  int creditsDelta;
/// "0:08" duration chip on video thumbnails; absent (not null) in the
/// JSON for non-video activity (e.g. an AI asset).
@override@JsonKey(includeIfNull: false) final  String? durationLabel;

/// Create a copy of SubscriptionActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionActivityCopyWith<_SubscriptionActivity> get copyWith => __$SubscriptionActivityCopyWithImpl<_SubscriptionActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionActivity&&(identical(other.title, title) || other.title == title)&&(identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.creditsDelta, creditsDelta) || other.creditsDelta == creditsDelta)&&(identical(other.durationLabel, durationLabel) || other.durationLabel == durationLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,timeAgo,kind,creditsDelta,durationLabel);

@override
String toString() {
  return 'SubscriptionActivity(title: $title, timeAgo: $timeAgo, kind: $kind, creditsDelta: $creditsDelta, durationLabel: $durationLabel)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionActivityCopyWith<$Res> implements $SubscriptionActivityCopyWith<$Res> {
  factory _$SubscriptionActivityCopyWith(_SubscriptionActivity value, $Res Function(_SubscriptionActivity) _then) = __$SubscriptionActivityCopyWithImpl;
@override @useResult
$Res call({
 String title, String timeAgo, String kind, int creditsDelta,@JsonKey(includeIfNull: false) String? durationLabel
});




}
/// @nodoc
class __$SubscriptionActivityCopyWithImpl<$Res>
    implements _$SubscriptionActivityCopyWith<$Res> {
  __$SubscriptionActivityCopyWithImpl(this._self, this._then);

  final _SubscriptionActivity _self;
  final $Res Function(_SubscriptionActivity) _then;

/// Create a copy of SubscriptionActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? timeAgo = null,Object? kind = null,Object? creditsDelta = null,Object? durationLabel = freezed,}) {
  return _then(_SubscriptionActivity(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,timeAgo: null == timeAgo ? _self.timeAgo : timeAgo // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,creditsDelta: null == creditsDelta ? _self.creditsDelta : creditsDelta // ignore: cast_nullable_to_non_nullable
as int,durationLabel: freezed == durationLabel ? _self.durationLabel : durationLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
