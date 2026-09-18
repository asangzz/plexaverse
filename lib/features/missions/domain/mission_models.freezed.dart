// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionStepResult {

 bool get alreadyCompleted; int get xpAwarded;
/// Create a copy of MissionStepResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionStepResultCopyWith<MissionStepResult> get copyWith => _$MissionStepResultCopyWithImpl<MissionStepResult>(this as MissionStepResult, _$identity);

  /// Serializes this MissionStepResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionStepResult&&(identical(other.alreadyCompleted, alreadyCompleted) || other.alreadyCompleted == alreadyCompleted)&&(identical(other.xpAwarded, xpAwarded) || other.xpAwarded == xpAwarded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alreadyCompleted,xpAwarded);

@override
String toString() {
  return 'MissionStepResult(alreadyCompleted: $alreadyCompleted, xpAwarded: $xpAwarded)';
}


}

/// @nodoc
abstract mixin class $MissionStepResultCopyWith<$Res>  {
  factory $MissionStepResultCopyWith(MissionStepResult value, $Res Function(MissionStepResult) _then) = _$MissionStepResultCopyWithImpl;
@useResult
$Res call({
 bool alreadyCompleted, int xpAwarded
});




}
/// @nodoc
class _$MissionStepResultCopyWithImpl<$Res>
    implements $MissionStepResultCopyWith<$Res> {
  _$MissionStepResultCopyWithImpl(this._self, this._then);

  final MissionStepResult _self;
  final $Res Function(MissionStepResult) _then;

/// Create a copy of MissionStepResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alreadyCompleted = null,Object? xpAwarded = null,}) {
  return _then(_self.copyWith(
alreadyCompleted: null == alreadyCompleted ? _self.alreadyCompleted : alreadyCompleted // ignore: cast_nullable_to_non_nullable
as bool,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionStepResult].
extension MissionStepResultPatterns on MissionStepResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionStepResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionStepResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionStepResult value)  $default,){
final _that = this;
switch (_that) {
case _MissionStepResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionStepResult value)?  $default,){
final _that = this;
switch (_that) {
case _MissionStepResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool alreadyCompleted,  int xpAwarded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionStepResult() when $default != null:
return $default(_that.alreadyCompleted,_that.xpAwarded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool alreadyCompleted,  int xpAwarded)  $default,) {final _that = this;
switch (_that) {
case _MissionStepResult():
return $default(_that.alreadyCompleted,_that.xpAwarded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool alreadyCompleted,  int xpAwarded)?  $default,) {final _that = this;
switch (_that) {
case _MissionStepResult() when $default != null:
return $default(_that.alreadyCompleted,_that.xpAwarded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MissionStepResult extends MissionStepResult {
  const _MissionStepResult({this.alreadyCompleted = false, this.xpAwarded = 0}): super._();
  factory _MissionStepResult.fromJson(Map<String, dynamic> json) => _$MissionStepResultFromJson(json);

@override@JsonKey() final  bool alreadyCompleted;
@override@JsonKey() final  int xpAwarded;

/// Create a copy of MissionStepResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionStepResultCopyWith<_MissionStepResult> get copyWith => __$MissionStepResultCopyWithImpl<_MissionStepResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionStepResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionStepResult&&(identical(other.alreadyCompleted, alreadyCompleted) || other.alreadyCompleted == alreadyCompleted)&&(identical(other.xpAwarded, xpAwarded) || other.xpAwarded == xpAwarded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alreadyCompleted,xpAwarded);

@override
String toString() {
  return 'MissionStepResult(alreadyCompleted: $alreadyCompleted, xpAwarded: $xpAwarded)';
}


}

/// @nodoc
abstract mixin class _$MissionStepResultCopyWith<$Res> implements $MissionStepResultCopyWith<$Res> {
  factory _$MissionStepResultCopyWith(_MissionStepResult value, $Res Function(_MissionStepResult) _then) = __$MissionStepResultCopyWithImpl;
@override @useResult
$Res call({
 bool alreadyCompleted, int xpAwarded
});




}
/// @nodoc
class __$MissionStepResultCopyWithImpl<$Res>
    implements _$MissionStepResultCopyWith<$Res> {
  __$MissionStepResultCopyWithImpl(this._self, this._then);

  final _MissionStepResult _self;
  final $Res Function(_MissionStepResult) _then;

/// Create a copy of MissionStepResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alreadyCompleted = null,Object? xpAwarded = null,}) {
  return _then(_MissionStepResult(
alreadyCompleted: null == alreadyCompleted ? _self.alreadyCompleted : alreadyCompleted // ignore: cast_nullable_to_non_nullable
as bool,xpAwarded: null == xpAwarded ? _self.xpAwarded : xpAwarded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MissionProfile {

 UserPreferences get preferences;/// Null when no LinkedIn account is connected yet. The hand-off card then
/// says so instead of building a URL around an empty segment.
 String? get linkedinSlug;/// The signed-in user's display name, from `GET /auth/me`.
///
/// The web reads it off the NextAuth session. This app keeps `AuthUser`
/// inside the auth flow and exposes no app-wide provider for it, so the
/// one screen that needs a name — the banner — asks the server rather than
/// reaching into another slice's internals.
 String? get displayName;
/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionProfileCopyWith<MissionProfile> get copyWith => _$MissionProfileCopyWithImpl<MissionProfile>(this as MissionProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionProfile&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.linkedinSlug, linkedinSlug) || other.linkedinSlug == linkedinSlug)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,linkedinSlug,displayName);

@override
String toString() {
  return 'MissionProfile(preferences: $preferences, linkedinSlug: $linkedinSlug, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $MissionProfileCopyWith<$Res>  {
  factory $MissionProfileCopyWith(MissionProfile value, $Res Function(MissionProfile) _then) = _$MissionProfileCopyWithImpl;
@useResult
$Res call({
 UserPreferences preferences, String? linkedinSlug, String? displayName
});


$UserPreferencesCopyWith<$Res> get preferences;

}
/// @nodoc
class _$MissionProfileCopyWithImpl<$Res>
    implements $MissionProfileCopyWith<$Res> {
  _$MissionProfileCopyWithImpl(this._self, this._then);

  final MissionProfile _self;
  final $Res Function(MissionProfile) _then;

/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preferences = null,Object? linkedinSlug = freezed,Object? displayName = freezed,}) {
  return _then(_self.copyWith(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,linkedinSlug: freezed == linkedinSlug ? _self.linkedinSlug : linkedinSlug // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}


/// Adds pattern-matching-related methods to [MissionProfile].
extension MissionProfilePatterns on MissionProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionProfile value)  $default,){
final _that = this;
switch (_that) {
case _MissionProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MissionProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserPreferences preferences,  String? linkedinSlug,  String? displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionProfile() when $default != null:
return $default(_that.preferences,_that.linkedinSlug,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserPreferences preferences,  String? linkedinSlug,  String? displayName)  $default,) {final _that = this;
switch (_that) {
case _MissionProfile():
return $default(_that.preferences,_that.linkedinSlug,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserPreferences preferences,  String? linkedinSlug,  String? displayName)?  $default,) {final _that = this;
switch (_that) {
case _MissionProfile() when $default != null:
return $default(_that.preferences,_that.linkedinSlug,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc


class _MissionProfile extends MissionProfile {
  const _MissionProfile({this.preferences = UserPreferences.empty, this.linkedinSlug, this.displayName}): super._();
  

@override@JsonKey() final  UserPreferences preferences;
/// Null when no LinkedIn account is connected yet. The hand-off card then
/// says so instead of building a URL around an empty segment.
@override final  String? linkedinSlug;
/// The signed-in user's display name, from `GET /auth/me`.
///
/// The web reads it off the NextAuth session. This app keeps `AuthUser`
/// inside the auth flow and exposes no app-wide provider for it, so the
/// one screen that needs a name — the banner — asks the server rather than
/// reaching into another slice's internals.
@override final  String? displayName;

/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionProfileCopyWith<_MissionProfile> get copyWith => __$MissionProfileCopyWithImpl<_MissionProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionProfile&&(identical(other.preferences, preferences) || other.preferences == preferences)&&(identical(other.linkedinSlug, linkedinSlug) || other.linkedinSlug == linkedinSlug)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,linkedinSlug,displayName);

@override
String toString() {
  return 'MissionProfile(preferences: $preferences, linkedinSlug: $linkedinSlug, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$MissionProfileCopyWith<$Res> implements $MissionProfileCopyWith<$Res> {
  factory _$MissionProfileCopyWith(_MissionProfile value, $Res Function(_MissionProfile) _then) = __$MissionProfileCopyWithImpl;
@override @useResult
$Res call({
 UserPreferences preferences, String? linkedinSlug, String? displayName
});


@override $UserPreferencesCopyWith<$Res> get preferences;

}
/// @nodoc
class __$MissionProfileCopyWithImpl<$Res>
    implements _$MissionProfileCopyWith<$Res> {
  __$MissionProfileCopyWithImpl(this._self, this._then);

  final _MissionProfile _self;
  final $Res Function(_MissionProfile) _then;

/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? linkedinSlug = freezed,Object? displayName = freezed,}) {
  return _then(_MissionProfile(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as UserPreferences,linkedinSlug: freezed == linkedinSlug ? _self.linkedinSlug : linkedinSlug // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MissionProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPreferencesCopyWith<$Res> get preferences {
  
  return $UserPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}
}

/// @nodoc
mixin _$SeasonRecap {

 int get roadmapDay; int get postsPublished;/// True when the post count hit the page limit, so the real figure is
/// "[postsPublished] or more". Rendered as `100+` rather than a number the
/// app cannot stand behind.
 bool get postsAtLeast; int get xpBalance;
/// Create a copy of SeasonRecap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeasonRecapCopyWith<SeasonRecap> get copyWith => _$SeasonRecapCopyWithImpl<SeasonRecap>(this as SeasonRecap, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeasonRecap&&(identical(other.roadmapDay, roadmapDay) || other.roadmapDay == roadmapDay)&&(identical(other.postsPublished, postsPublished) || other.postsPublished == postsPublished)&&(identical(other.postsAtLeast, postsAtLeast) || other.postsAtLeast == postsAtLeast)&&(identical(other.xpBalance, xpBalance) || other.xpBalance == xpBalance));
}


@override
int get hashCode => Object.hash(runtimeType,roadmapDay,postsPublished,postsAtLeast,xpBalance);

@override
String toString() {
  return 'SeasonRecap(roadmapDay: $roadmapDay, postsPublished: $postsPublished, postsAtLeast: $postsAtLeast, xpBalance: $xpBalance)';
}


}

/// @nodoc
abstract mixin class $SeasonRecapCopyWith<$Res>  {
  factory $SeasonRecapCopyWith(SeasonRecap value, $Res Function(SeasonRecap) _then) = _$SeasonRecapCopyWithImpl;
@useResult
$Res call({
 int roadmapDay, int postsPublished, bool postsAtLeast, int xpBalance
});




}
/// @nodoc
class _$SeasonRecapCopyWithImpl<$Res>
    implements $SeasonRecapCopyWith<$Res> {
  _$SeasonRecapCopyWithImpl(this._self, this._then);

  final SeasonRecap _self;
  final $Res Function(SeasonRecap) _then;

/// Create a copy of SeasonRecap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roadmapDay = null,Object? postsPublished = null,Object? postsAtLeast = null,Object? xpBalance = null,}) {
  return _then(_self.copyWith(
roadmapDay: null == roadmapDay ? _self.roadmapDay : roadmapDay // ignore: cast_nullable_to_non_nullable
as int,postsPublished: null == postsPublished ? _self.postsPublished : postsPublished // ignore: cast_nullable_to_non_nullable
as int,postsAtLeast: null == postsAtLeast ? _self.postsAtLeast : postsAtLeast // ignore: cast_nullable_to_non_nullable
as bool,xpBalance: null == xpBalance ? _self.xpBalance : xpBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SeasonRecap].
extension SeasonRecapPatterns on SeasonRecap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeasonRecap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeasonRecap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeasonRecap value)  $default,){
final _that = this;
switch (_that) {
case _SeasonRecap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeasonRecap value)?  $default,){
final _that = this;
switch (_that) {
case _SeasonRecap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roadmapDay,  int postsPublished,  bool postsAtLeast,  int xpBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeasonRecap() when $default != null:
return $default(_that.roadmapDay,_that.postsPublished,_that.postsAtLeast,_that.xpBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roadmapDay,  int postsPublished,  bool postsAtLeast,  int xpBalance)  $default,) {final _that = this;
switch (_that) {
case _SeasonRecap():
return $default(_that.roadmapDay,_that.postsPublished,_that.postsAtLeast,_that.xpBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roadmapDay,  int postsPublished,  bool postsAtLeast,  int xpBalance)?  $default,) {final _that = this;
switch (_that) {
case _SeasonRecap() when $default != null:
return $default(_that.roadmapDay,_that.postsPublished,_that.postsAtLeast,_that.xpBalance);case _:
  return null;

}
}

}

/// @nodoc


class _SeasonRecap extends SeasonRecap {
  const _SeasonRecap({this.roadmapDay = 0, this.postsPublished = 0, this.postsAtLeast = false, this.xpBalance = 0}): super._();
  

@override@JsonKey() final  int roadmapDay;
@override@JsonKey() final  int postsPublished;
/// True when the post count hit the page limit, so the real figure is
/// "[postsPublished] or more". Rendered as `100+` rather than a number the
/// app cannot stand behind.
@override@JsonKey() final  bool postsAtLeast;
@override@JsonKey() final  int xpBalance;

/// Create a copy of SeasonRecap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeasonRecapCopyWith<_SeasonRecap> get copyWith => __$SeasonRecapCopyWithImpl<_SeasonRecap>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeasonRecap&&(identical(other.roadmapDay, roadmapDay) || other.roadmapDay == roadmapDay)&&(identical(other.postsPublished, postsPublished) || other.postsPublished == postsPublished)&&(identical(other.postsAtLeast, postsAtLeast) || other.postsAtLeast == postsAtLeast)&&(identical(other.xpBalance, xpBalance) || other.xpBalance == xpBalance));
}


@override
int get hashCode => Object.hash(runtimeType,roadmapDay,postsPublished,postsAtLeast,xpBalance);

@override
String toString() {
  return 'SeasonRecap(roadmapDay: $roadmapDay, postsPublished: $postsPublished, postsAtLeast: $postsAtLeast, xpBalance: $xpBalance)';
}


}

/// @nodoc
abstract mixin class _$SeasonRecapCopyWith<$Res> implements $SeasonRecapCopyWith<$Res> {
  factory _$SeasonRecapCopyWith(_SeasonRecap value, $Res Function(_SeasonRecap) _then) = __$SeasonRecapCopyWithImpl;
@override @useResult
$Res call({
 int roadmapDay, int postsPublished, bool postsAtLeast, int xpBalance
});




}
/// @nodoc
class __$SeasonRecapCopyWithImpl<$Res>
    implements _$SeasonRecapCopyWith<$Res> {
  __$SeasonRecapCopyWithImpl(this._self, this._then);

  final _SeasonRecap _self;
  final $Res Function(_SeasonRecap) _then;

/// Create a copy of SeasonRecap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roadmapDay = null,Object? postsPublished = null,Object? postsAtLeast = null,Object? xpBalance = null,}) {
  return _then(_SeasonRecap(
roadmapDay: null == roadmapDay ? _self.roadmapDay : roadmapDay // ignore: cast_nullable_to_non_nullable
as int,postsPublished: null == postsPublished ? _self.postsPublished : postsPublished // ignore: cast_nullable_to_non_nullable
as int,postsAtLeast: null == postsAtLeast ? _self.postsAtLeast : postsAtLeast // ignore: cast_nullable_to_non_nullable
as bool,xpBalance: null == xpBalance ? _self.xpBalance : xpBalance // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BannerTemplate {

 String get id; String get name; String? get description; String? get thumbnail; int get width; int get height;/// Null when the list was fetched without `includeData`. Such a template
/// cannot be previewed, so the screen drops it rather than rendering an
/// empty card.
 BannerDesign? get data;
/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerTemplateCopyWith<BannerTemplate> get copyWith => _$BannerTemplateCopyWithImpl<BannerTemplate>(this as BannerTemplate, _$identity);

  /// Serializes this BannerTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,data);

@override
String toString() {
  return 'BannerTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class $BannerTemplateCopyWith<$Res>  {
  factory $BannerTemplateCopyWith(BannerTemplate value, $Res Function(BannerTemplate) _then) = _$BannerTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, BannerDesign? data
});


$BannerDesignCopyWith<$Res>? get data;

}
/// @nodoc
class _$BannerTemplateCopyWithImpl<$Res>
    implements $BannerTemplateCopyWith<$Res> {
  _$BannerTemplateCopyWithImpl(this._self, this._then);

  final BannerTemplate _self;
  final $Res Function(BannerTemplate) _then;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BannerDesign?,
  ));
}
/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BannerDesignCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BannerDesignCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [BannerTemplate].
extension BannerTemplatePatterns on BannerTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerTemplate value)  $default,){
final _that = this;
switch (_that) {
case _BannerTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  BannerDesign? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  BannerDesign? data)  $default,) {final _that = this;
switch (_that) {
case _BannerTemplate():
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? thumbnail,  int width,  int height,  BannerDesign? data)?  $default,) {final _that = this;
switch (_that) {
case _BannerTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.thumbnail,_that.width,_that.height,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerTemplate extends BannerTemplate {
  const _BannerTemplate({required this.id, this.name = '', this.description, this.thumbnail, this.width = 1200, this.height = 400, this.data}): super._();
  factory _BannerTemplate.fromJson(Map<String, dynamic> json) => _$BannerTemplateFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override final  String? description;
@override final  String? thumbnail;
@override@JsonKey() final  int width;
@override@JsonKey() final  int height;
/// Null when the list was fetched without `includeData`. Such a template
/// cannot be previewed, so the screen drops it rather than rendering an
/// empty card.
@override final  BannerDesign? data;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerTemplateCopyWith<_BannerTemplate> get copyWith => __$BannerTemplateCopyWithImpl<_BannerTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnail, thumbnail) || other.thumbnail == thumbnail)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,thumbnail,width,height,data);

@override
String toString() {
  return 'BannerTemplate(id: $id, name: $name, description: $description, thumbnail: $thumbnail, width: $width, height: $height, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BannerTemplateCopyWith<$Res> implements $BannerTemplateCopyWith<$Res> {
  factory _$BannerTemplateCopyWith(_BannerTemplate value, $Res Function(_BannerTemplate) _then) = __$BannerTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? thumbnail, int width, int height, BannerDesign? data
});


@override $BannerDesignCopyWith<$Res>? get data;

}
/// @nodoc
class __$BannerTemplateCopyWithImpl<$Res>
    implements _$BannerTemplateCopyWith<$Res> {
  __$BannerTemplateCopyWithImpl(this._self, this._then);

  final _BannerTemplate _self;
  final $Res Function(_BannerTemplate) _then;

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? thumbnail = freezed,Object? width = null,Object? height = null,Object? data = freezed,}) {
  return _then(_BannerTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnail: freezed == thumbnail ? _self.thumbnail : thumbnail // ignore: cast_nullable_to_non_nullable
as String?,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as BannerDesign?,
  ));
}

/// Create a copy of BannerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BannerDesignCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $BannerDesignCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$BannerCanvas {

 double get width; double get height;/// A CSS colour string. Parsed by [parseCssColor]; a gradient (which the
/// Studio does allow) fails that parse and falls back to the Studio's own
/// default ground.
 String? get background;
/// Create a copy of BannerCanvas
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerCanvasCopyWith<BannerCanvas> get copyWith => _$BannerCanvasCopyWithImpl<BannerCanvas>(this as BannerCanvas, _$identity);

  /// Serializes this BannerCanvas to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerCanvas&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,background);

@override
String toString() {
  return 'BannerCanvas(width: $width, height: $height, background: $background)';
}


}

/// @nodoc
abstract mixin class $BannerCanvasCopyWith<$Res>  {
  factory $BannerCanvasCopyWith(BannerCanvas value, $Res Function(BannerCanvas) _then) = _$BannerCanvasCopyWithImpl;
@useResult
$Res call({
 double width, double height, String? background
});




}
/// @nodoc
class _$BannerCanvasCopyWithImpl<$Res>
    implements $BannerCanvasCopyWith<$Res> {
  _$BannerCanvasCopyWithImpl(this._self, this._then);

  final BannerCanvas _self;
  final $Res Function(BannerCanvas) _then;

/// Create a copy of BannerCanvas
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? background = freezed,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerCanvas].
extension BannerCanvasPatterns on BannerCanvas {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerCanvas value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerCanvas() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerCanvas value)  $default,){
final _that = this;
switch (_that) {
case _BannerCanvas():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerCanvas value)?  $default,){
final _that = this;
switch (_that) {
case _BannerCanvas() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height,  String? background)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerCanvas() when $default != null:
return $default(_that.width,_that.height,_that.background);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height,  String? background)  $default,) {final _that = this;
switch (_that) {
case _BannerCanvas():
return $default(_that.width,_that.height,_that.background);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height,  String? background)?  $default,) {final _that = this;
switch (_that) {
case _BannerCanvas() when $default != null:
return $default(_that.width,_that.height,_that.background);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerCanvas extends BannerCanvas {
  const _BannerCanvas({this.width = 1200.0, this.height = 400.0, this.background}): super._();
  factory _BannerCanvas.fromJson(Map<String, dynamic> json) => _$BannerCanvasFromJson(json);

@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
/// A CSS colour string. Parsed by [parseCssColor]; a gradient (which the
/// Studio does allow) fails that parse and falls back to the Studio's own
/// default ground.
@override final  String? background;

/// Create a copy of BannerCanvas
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerCanvasCopyWith<_BannerCanvas> get copyWith => __$BannerCanvasCopyWithImpl<_BannerCanvas>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerCanvasToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerCanvas&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,background);

@override
String toString() {
  return 'BannerCanvas(width: $width, height: $height, background: $background)';
}


}

/// @nodoc
abstract mixin class _$BannerCanvasCopyWith<$Res> implements $BannerCanvasCopyWith<$Res> {
  factory _$BannerCanvasCopyWith(_BannerCanvas value, $Res Function(_BannerCanvas) _then) = __$BannerCanvasCopyWithImpl;
@override @useResult
$Res call({
 double width, double height, String? background
});




}
/// @nodoc
class __$BannerCanvasCopyWithImpl<$Res>
    implements _$BannerCanvasCopyWith<$Res> {
  __$BannerCanvasCopyWithImpl(this._self, this._then);

  final _BannerCanvas _self;
  final $Res Function(_BannerCanvas) _then;

/// Create a copy of BannerCanvas
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? background = freezed,}) {
  return _then(_BannerCanvas(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,background: freezed == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BannerElement {

 String get id;/// `rectangle` | `ellipse` | `text` | `image` | `line` | `group` | `frame`.
 String get type; String get name; double get x; double get y; double get width; double get height; String get fill; double get opacity; bool get visible; double? get borderRadius; String? get text; double? get fontSize; String? get fontFamily; int? get fontWeight;/// `left` | `center` | `right`.
 String? get textAlign; String? get imageUrl; List<BannerElement> get children;
/// Create a copy of BannerElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerElementCopyWith<BannerElement> get copyWith => _$BannerElementCopyWithImpl<BannerElement>(this as BannerElement, _$identity);

  /// Serializes this BannerElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerElement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.text, text) || other.text == text)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.textAlign, textAlign) || other.textAlign == textAlign)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,x,y,width,height,fill,opacity,visible,borderRadius,text,fontSize,fontFamily,fontWeight,textAlign,imageUrl,const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'BannerElement(id: $id, type: $type, name: $name, x: $x, y: $y, width: $width, height: $height, fill: $fill, opacity: $opacity, visible: $visible, borderRadius: $borderRadius, text: $text, fontSize: $fontSize, fontFamily: $fontFamily, fontWeight: $fontWeight, textAlign: $textAlign, imageUrl: $imageUrl, children: $children)';
}


}

/// @nodoc
abstract mixin class $BannerElementCopyWith<$Res>  {
  factory $BannerElementCopyWith(BannerElement value, $Res Function(BannerElement) _then) = _$BannerElementCopyWithImpl;
@useResult
$Res call({
 String id, String type, String name, double x, double y, double width, double height, String fill, double opacity, bool visible, double? borderRadius, String? text, double? fontSize, String? fontFamily, int? fontWeight, String? textAlign, String? imageUrl, List<BannerElement> children
});




}
/// @nodoc
class _$BannerElementCopyWithImpl<$Res>
    implements $BannerElementCopyWith<$Res> {
  _$BannerElementCopyWithImpl(this._self, this._then);

  final BannerElement _self;
  final $Res Function(BannerElement) _then;

/// Create a copy of BannerElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? fill = null,Object? opacity = null,Object? visible = null,Object? borderRadius = freezed,Object? text = freezed,Object? fontSize = freezed,Object? fontFamily = freezed,Object? fontWeight = freezed,Object? textAlign = freezed,Object? imageUrl = freezed,Object? children = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,fill: null == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as String,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,fontSize: freezed == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,fontWeight: freezed == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int?,textAlign: freezed == textAlign ? _self.textAlign : textAlign // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<BannerElement>,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerElement].
extension BannerElementPatterns on BannerElement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerElement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerElement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerElement value)  $default,){
final _that = this;
switch (_that) {
case _BannerElement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerElement value)?  $default,){
final _that = this;
switch (_that) {
case _BannerElement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  String fill,  double opacity,  bool visible,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? textAlign,  String? imageUrl,  List<BannerElement> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerElement() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.fill,_that.opacity,_that.visible,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.textAlign,_that.imageUrl,_that.children);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  String fill,  double opacity,  bool visible,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? textAlign,  String? imageUrl,  List<BannerElement> children)  $default,) {final _that = this;
switch (_that) {
case _BannerElement():
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.fill,_that.opacity,_that.visible,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.textAlign,_that.imageUrl,_that.children);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String name,  double x,  double y,  double width,  double height,  String fill,  double opacity,  bool visible,  double? borderRadius,  String? text,  double? fontSize,  String? fontFamily,  int? fontWeight,  String? textAlign,  String? imageUrl,  List<BannerElement> children)?  $default,) {final _that = this;
switch (_that) {
case _BannerElement() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.x,_that.y,_that.width,_that.height,_that.fill,_that.opacity,_that.visible,_that.borderRadius,_that.text,_that.fontSize,_that.fontFamily,_that.fontWeight,_that.textAlign,_that.imageUrl,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerElement extends BannerElement {
  const _BannerElement({this.id = '', this.type = 'rectangle', this.name = '', this.x = 0.0, this.y = 0.0, this.width = 0.0, this.height = 0.0, this.fill = 'transparent', this.opacity = 1.0, this.visible = true, this.borderRadius, this.text, this.fontSize, this.fontFamily, this.fontWeight, this.textAlign, this.imageUrl, final  List<BannerElement> children = const <BannerElement>[]}): _children = children,super._();
  factory _BannerElement.fromJson(Map<String, dynamic> json) => _$BannerElementFromJson(json);

@override@JsonKey() final  String id;
/// `rectangle` | `ellipse` | `text` | `image` | `line` | `group` | `frame`.
@override@JsonKey() final  String type;
@override@JsonKey() final  String name;
@override@JsonKey() final  double x;
@override@JsonKey() final  double y;
@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
@override@JsonKey() final  String fill;
@override@JsonKey() final  double opacity;
@override@JsonKey() final  bool visible;
@override final  double? borderRadius;
@override final  String? text;
@override final  double? fontSize;
@override final  String? fontFamily;
@override final  int? fontWeight;
/// `left` | `center` | `right`.
@override final  String? textAlign;
@override final  String? imageUrl;
 final  List<BannerElement> _children;
@override@JsonKey() List<BannerElement> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of BannerElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerElementCopyWith<_BannerElement> get copyWith => __$BannerElementCopyWithImpl<_BannerElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerElement&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.fill, fill) || other.fill == fill)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.text, text) || other.text == text)&&(identical(other.fontSize, fontSize) || other.fontSize == fontSize)&&(identical(other.fontFamily, fontFamily) || other.fontFamily == fontFamily)&&(identical(other.fontWeight, fontWeight) || other.fontWeight == fontWeight)&&(identical(other.textAlign, textAlign) || other.textAlign == textAlign)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,x,y,width,height,fill,opacity,visible,borderRadius,text,fontSize,fontFamily,fontWeight,textAlign,imageUrl,const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'BannerElement(id: $id, type: $type, name: $name, x: $x, y: $y, width: $width, height: $height, fill: $fill, opacity: $opacity, visible: $visible, borderRadius: $borderRadius, text: $text, fontSize: $fontSize, fontFamily: $fontFamily, fontWeight: $fontWeight, textAlign: $textAlign, imageUrl: $imageUrl, children: $children)';
}


}

/// @nodoc
abstract mixin class _$BannerElementCopyWith<$Res> implements $BannerElementCopyWith<$Res> {
  factory _$BannerElementCopyWith(_BannerElement value, $Res Function(_BannerElement) _then) = __$BannerElementCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String name, double x, double y, double width, double height, String fill, double opacity, bool visible, double? borderRadius, String? text, double? fontSize, String? fontFamily, int? fontWeight, String? textAlign, String? imageUrl, List<BannerElement> children
});




}
/// @nodoc
class __$BannerElementCopyWithImpl<$Res>
    implements _$BannerElementCopyWith<$Res> {
  __$BannerElementCopyWithImpl(this._self, this._then);

  final _BannerElement _self;
  final $Res Function(_BannerElement) _then;

/// Create a copy of BannerElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? x = null,Object? y = null,Object? width = null,Object? height = null,Object? fill = null,Object? opacity = null,Object? visible = null,Object? borderRadius = freezed,Object? text = freezed,Object? fontSize = freezed,Object? fontFamily = freezed,Object? fontWeight = freezed,Object? textAlign = freezed,Object? imageUrl = freezed,Object? children = null,}) {
  return _then(_BannerElement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,fill: null == fill ? _self.fill : fill // ignore: cast_nullable_to_non_nullable
as String,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,fontSize: freezed == fontSize ? _self.fontSize : fontSize // ignore: cast_nullable_to_non_nullable
as double?,fontFamily: freezed == fontFamily ? _self.fontFamily : fontFamily // ignore: cast_nullable_to_non_nullable
as String?,fontWeight: freezed == fontWeight ? _self.fontWeight : fontWeight // ignore: cast_nullable_to_non_nullable
as int?,textAlign: freezed == textAlign ? _self.textAlign : textAlign // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<BannerElement>,
  ));
}


}


/// @nodoc
mixin _$BannerDesign {

/// Nullable rather than defaulted: `json_serializable` can only take a
/// LITERAL as a `@JsonKey` default, so a defaulted nested object would not
/// survive codegen. [frame] is the read side.
 BannerCanvas? get canvas; List<BannerElement> get elements;
/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerDesignCopyWith<BannerDesign> get copyWith => _$BannerDesignCopyWithImpl<BannerDesign>(this as BannerDesign, _$identity);

  /// Serializes this BannerDesign to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerDesign&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other.elements, elements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canvas,const DeepCollectionEquality().hash(elements));

@override
String toString() {
  return 'BannerDesign(canvas: $canvas, elements: $elements)';
}


}

/// @nodoc
abstract mixin class $BannerDesignCopyWith<$Res>  {
  factory $BannerDesignCopyWith(BannerDesign value, $Res Function(BannerDesign) _then) = _$BannerDesignCopyWithImpl;
@useResult
$Res call({
 BannerCanvas? canvas, List<BannerElement> elements
});


$BannerCanvasCopyWith<$Res>? get canvas;

}
/// @nodoc
class _$BannerDesignCopyWithImpl<$Res>
    implements $BannerDesignCopyWith<$Res> {
  _$BannerDesignCopyWithImpl(this._self, this._then);

  final BannerDesign _self;
  final $Res Function(BannerDesign) _then;

/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? canvas = freezed,Object? elements = null,}) {
  return _then(_self.copyWith(
canvas: freezed == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as BannerCanvas?,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as List<BannerElement>,
  ));
}
/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BannerCanvasCopyWith<$Res>? get canvas {
    if (_self.canvas == null) {
    return null;
  }

  return $BannerCanvasCopyWith<$Res>(_self.canvas!, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}
}


/// Adds pattern-matching-related methods to [BannerDesign].
extension BannerDesignPatterns on BannerDesign {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerDesign value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerDesign() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerDesign value)  $default,){
final _that = this;
switch (_that) {
case _BannerDesign():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerDesign value)?  $default,){
final _that = this;
switch (_that) {
case _BannerDesign() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BannerCanvas? canvas,  List<BannerElement> elements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerDesign() when $default != null:
return $default(_that.canvas,_that.elements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BannerCanvas? canvas,  List<BannerElement> elements)  $default,) {final _that = this;
switch (_that) {
case _BannerDesign():
return $default(_that.canvas,_that.elements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BannerCanvas? canvas,  List<BannerElement> elements)?  $default,) {final _that = this;
switch (_that) {
case _BannerDesign() when $default != null:
return $default(_that.canvas,_that.elements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerDesign extends BannerDesign {
  const _BannerDesign({this.canvas, final  List<BannerElement> elements = const <BannerElement>[]}): _elements = elements,super._();
  factory _BannerDesign.fromJson(Map<String, dynamic> json) => _$BannerDesignFromJson(json);

/// Nullable rather than defaulted: `json_serializable` can only take a
/// LITERAL as a `@JsonKey` default, so a defaulted nested object would not
/// survive codegen. [frame] is the read side.
@override final  BannerCanvas? canvas;
 final  List<BannerElement> _elements;
@override@JsonKey() List<BannerElement> get elements {
  if (_elements is EqualUnmodifiableListView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_elements);
}


/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerDesignCopyWith<_BannerDesign> get copyWith => __$BannerDesignCopyWithImpl<_BannerDesign>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerDesignToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerDesign&&(identical(other.canvas, canvas) || other.canvas == canvas)&&const DeepCollectionEquality().equals(other._elements, _elements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,canvas,const DeepCollectionEquality().hash(_elements));

@override
String toString() {
  return 'BannerDesign(canvas: $canvas, elements: $elements)';
}


}

/// @nodoc
abstract mixin class _$BannerDesignCopyWith<$Res> implements $BannerDesignCopyWith<$Res> {
  factory _$BannerDesignCopyWith(_BannerDesign value, $Res Function(_BannerDesign) _then) = __$BannerDesignCopyWithImpl;
@override @useResult
$Res call({
 BannerCanvas? canvas, List<BannerElement> elements
});


@override $BannerCanvasCopyWith<$Res>? get canvas;

}
/// @nodoc
class __$BannerDesignCopyWithImpl<$Res>
    implements _$BannerDesignCopyWith<$Res> {
  __$BannerDesignCopyWithImpl(this._self, this._then);

  final _BannerDesign _self;
  final $Res Function(_BannerDesign) _then;

/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? canvas = freezed,Object? elements = null,}) {
  return _then(_BannerDesign(
canvas: freezed == canvas ? _self.canvas : canvas // ignore: cast_nullable_to_non_nullable
as BannerCanvas?,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as List<BannerElement>,
  ));
}

/// Create a copy of BannerDesign
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BannerCanvasCopyWith<$Res>? get canvas {
    if (_self.canvas == null) {
    return null;
  }

  return $BannerCanvasCopyWith<$Res>(_self.canvas!, (value) {
    return _then(_self.copyWith(canvas: value));
  });
}
}

// dart format on
