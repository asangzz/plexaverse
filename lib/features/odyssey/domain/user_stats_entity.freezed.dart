// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStatsEntity {

 int get streakDays; int get xp; int get level; String get levelTitle; int get weeklyXp; int get weeklyXpGoal; String? get lastActiveDateStr;
/// Create a copy of UserStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsEntityCopyWith<UserStatsEntity> get copyWith => _$UserStatsEntityCopyWithImpl<UserStatsEntity>(this as UserStatsEntity, _$identity);

  /// Serializes this UserStatsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStatsEntity&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.weeklyXp, weeklyXp) || other.weeklyXp == weeklyXp)&&(identical(other.weeklyXpGoal, weeklyXpGoal) || other.weeklyXpGoal == weeklyXpGoal)&&(identical(other.lastActiveDateStr, lastActiveDateStr) || other.lastActiveDateStr == lastActiveDateStr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakDays,xp,level,levelTitle,weeklyXp,weeklyXpGoal,lastActiveDateStr);

@override
String toString() {
  return 'UserStatsEntity(streakDays: $streakDays, xp: $xp, level: $level, levelTitle: $levelTitle, weeklyXp: $weeklyXp, weeklyXpGoal: $weeklyXpGoal, lastActiveDateStr: $lastActiveDateStr)';
}


}

/// @nodoc
abstract mixin class $UserStatsEntityCopyWith<$Res>  {
  factory $UserStatsEntityCopyWith(UserStatsEntity value, $Res Function(UserStatsEntity) _then) = _$UserStatsEntityCopyWithImpl;
@useResult
$Res call({
 int streakDays, int xp, int level, String levelTitle, int weeklyXp, int weeklyXpGoal, String? lastActiveDateStr
});




}
/// @nodoc
class _$UserStatsEntityCopyWithImpl<$Res>
    implements $UserStatsEntityCopyWith<$Res> {
  _$UserStatsEntityCopyWithImpl(this._self, this._then);

  final UserStatsEntity _self;
  final $Res Function(UserStatsEntity) _then;

/// Create a copy of UserStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? streakDays = null,Object? xp = null,Object? level = null,Object? levelTitle = null,Object? weeklyXp = null,Object? weeklyXpGoal = null,Object? lastActiveDateStr = freezed,}) {
  return _then(_self.copyWith(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXpGoal: null == weeklyXpGoal ? _self.weeklyXpGoal : weeklyXpGoal // ignore: cast_nullable_to_non_nullable
as int,lastActiveDateStr: freezed == lastActiveDateStr ? _self.lastActiveDateStr : lastActiveDateStr // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStatsEntity].
extension UserStatsEntityPatterns on UserStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int streakDays,  int xp,  int level,  String levelTitle,  int weeklyXp,  int weeklyXpGoal,  String? lastActiveDateStr)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStatsEntity() when $default != null:
return $default(_that.streakDays,_that.xp,_that.level,_that.levelTitle,_that.weeklyXp,_that.weeklyXpGoal,_that.lastActiveDateStr);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int streakDays,  int xp,  int level,  String levelTitle,  int weeklyXp,  int weeklyXpGoal,  String? lastActiveDateStr)  $default,) {final _that = this;
switch (_that) {
case _UserStatsEntity():
return $default(_that.streakDays,_that.xp,_that.level,_that.levelTitle,_that.weeklyXp,_that.weeklyXpGoal,_that.lastActiveDateStr);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int streakDays,  int xp,  int level,  String levelTitle,  int weeklyXp,  int weeklyXpGoal,  String? lastActiveDateStr)?  $default,) {final _that = this;
switch (_that) {
case _UserStatsEntity() when $default != null:
return $default(_that.streakDays,_that.xp,_that.level,_that.levelTitle,_that.weeklyXp,_that.weeklyXpGoal,_that.lastActiveDateStr);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStatsEntity extends UserStatsEntity {
  const _UserStatsEntity({this.streakDays = 0, this.xp = 0, this.level = 1, this.levelTitle = 'Beginner', this.weeklyXp = 0, this.weeklyXpGoal = 2000, this.lastActiveDateStr}): super._();
  factory _UserStatsEntity.fromJson(Map<String, dynamic> json) => _$UserStatsEntityFromJson(json);

@override@JsonKey() final  int streakDays;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int level;
@override@JsonKey() final  String levelTitle;
@override@JsonKey() final  int weeklyXp;
@override@JsonKey() final  int weeklyXpGoal;
@override final  String? lastActiveDateStr;

/// Create a copy of UserStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsEntityCopyWith<_UserStatsEntity> get copyWith => __$UserStatsEntityCopyWithImpl<_UserStatsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStatsEntity&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.levelTitle, levelTitle) || other.levelTitle == levelTitle)&&(identical(other.weeklyXp, weeklyXp) || other.weeklyXp == weeklyXp)&&(identical(other.weeklyXpGoal, weeklyXpGoal) || other.weeklyXpGoal == weeklyXpGoal)&&(identical(other.lastActiveDateStr, lastActiveDateStr) || other.lastActiveDateStr == lastActiveDateStr));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,streakDays,xp,level,levelTitle,weeklyXp,weeklyXpGoal,lastActiveDateStr);

@override
String toString() {
  return 'UserStatsEntity(streakDays: $streakDays, xp: $xp, level: $level, levelTitle: $levelTitle, weeklyXp: $weeklyXp, weeklyXpGoal: $weeklyXpGoal, lastActiveDateStr: $lastActiveDateStr)';
}


}

/// @nodoc
abstract mixin class _$UserStatsEntityCopyWith<$Res> implements $UserStatsEntityCopyWith<$Res> {
  factory _$UserStatsEntityCopyWith(_UserStatsEntity value, $Res Function(_UserStatsEntity) _then) = __$UserStatsEntityCopyWithImpl;
@override @useResult
$Res call({
 int streakDays, int xp, int level, String levelTitle, int weeklyXp, int weeklyXpGoal, String? lastActiveDateStr
});




}
/// @nodoc
class __$UserStatsEntityCopyWithImpl<$Res>
    implements _$UserStatsEntityCopyWith<$Res> {
  __$UserStatsEntityCopyWithImpl(this._self, this._then);

  final _UserStatsEntity _self;
  final $Res Function(_UserStatsEntity) _then;

/// Create a copy of UserStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? streakDays = null,Object? xp = null,Object? level = null,Object? levelTitle = null,Object? weeklyXp = null,Object? weeklyXpGoal = null,Object? lastActiveDateStr = freezed,}) {
  return _then(_UserStatsEntity(
streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,levelTitle: null == levelTitle ? _self.levelTitle : levelTitle // ignore: cast_nullable_to_non_nullable
as String,weeklyXp: null == weeklyXp ? _self.weeklyXp : weeklyXp // ignore: cast_nullable_to_non_nullable
as int,weeklyXpGoal: null == weeklyXpGoal ? _self.weeklyXpGoal : weeklyXpGoal // ignore: cast_nullable_to_non_nullable
as int,lastActiveDateStr: freezed == lastActiveDateStr ? _self.lastActiveDateStr : lastActiveDateStr // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
