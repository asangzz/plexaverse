// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MissionEntity {

 int get id; String get missionKey; String get title; String get description; MissionStatus get status; int get xpReward; int get progress; int get total; int get sortOrder;
/// Create a copy of MissionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionEntityCopyWith<MissionEntity> get copyWith => _$MissionEntityCopyWithImpl<MissionEntity>(this as MissionEntity, _$identity);

  /// Serializes this MissionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.missionKey, missionKey) || other.missionKey == missionKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.total, total) || other.total == total)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,missionKey,title,description,status,xpReward,progress,total,sortOrder);

@override
String toString() {
  return 'MissionEntity(id: $id, missionKey: $missionKey, title: $title, description: $description, status: $status, xpReward: $xpReward, progress: $progress, total: $total, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MissionEntityCopyWith<$Res>  {
  factory $MissionEntityCopyWith(MissionEntity value, $Res Function(MissionEntity) _then) = _$MissionEntityCopyWithImpl;
@useResult
$Res call({
 int id, String missionKey, String title, String description, MissionStatus status, int xpReward, int progress, int total, int sortOrder
});




}
/// @nodoc
class _$MissionEntityCopyWithImpl<$Res>
    implements $MissionEntityCopyWith<$Res> {
  _$MissionEntityCopyWithImpl(this._self, this._then);

  final MissionEntity _self;
  final $Res Function(MissionEntity) _then;

/// Create a copy of MissionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? missionKey = null,Object? title = null,Object? description = null,Object? status = null,Object? xpReward = null,Object? progress = null,Object? total = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,missionKey: null == missionKey ? _self.missionKey : missionKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionEntity].
extension MissionEntityPatterns on MissionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionEntity value)  $default,){
final _that = this;
switch (_that) {
case _MissionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MissionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String missionKey,  String title,  String description,  MissionStatus status,  int xpReward,  int progress,  int total,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionEntity() when $default != null:
return $default(_that.id,_that.missionKey,_that.title,_that.description,_that.status,_that.xpReward,_that.progress,_that.total,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String missionKey,  String title,  String description,  MissionStatus status,  int xpReward,  int progress,  int total,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MissionEntity():
return $default(_that.id,_that.missionKey,_that.title,_that.description,_that.status,_that.xpReward,_that.progress,_that.total,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String missionKey,  String title,  String description,  MissionStatus status,  int xpReward,  int progress,  int total,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MissionEntity() when $default != null:
return $default(_that.id,_that.missionKey,_that.title,_that.description,_that.status,_that.xpReward,_that.progress,_that.total,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MissionEntity extends MissionEntity {
  const _MissionEntity({required this.id, required this.missionKey, required this.title, required this.description, this.status = MissionStatus.locked, this.xpReward = 100, this.progress = 0, this.total = 1, this.sortOrder = 0}): super._();
  factory _MissionEntity.fromJson(Map<String, dynamic> json) => _$MissionEntityFromJson(json);

@override final  int id;
@override final  String missionKey;
@override final  String title;
@override final  String description;
@override@JsonKey() final  MissionStatus status;
@override@JsonKey() final  int xpReward;
@override@JsonKey() final  int progress;
@override@JsonKey() final  int total;
@override@JsonKey() final  int sortOrder;

/// Create a copy of MissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionEntityCopyWith<_MissionEntity> get copyWith => __$MissionEntityCopyWithImpl<_MissionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.missionKey, missionKey) || other.missionKey == missionKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.total, total) || other.total == total)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,missionKey,title,description,status,xpReward,progress,total,sortOrder);

@override
String toString() {
  return 'MissionEntity(id: $id, missionKey: $missionKey, title: $title, description: $description, status: $status, xpReward: $xpReward, progress: $progress, total: $total, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MissionEntityCopyWith<$Res> implements $MissionEntityCopyWith<$Res> {
  factory _$MissionEntityCopyWith(_MissionEntity value, $Res Function(_MissionEntity) _then) = __$MissionEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String missionKey, String title, String description, MissionStatus status, int xpReward, int progress, int total, int sortOrder
});




}
/// @nodoc
class __$MissionEntityCopyWithImpl<$Res>
    implements _$MissionEntityCopyWith<$Res> {
  __$MissionEntityCopyWithImpl(this._self, this._then);

  final _MissionEntity _self;
  final $Res Function(_MissionEntity) _then;

/// Create a copy of MissionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? missionKey = null,Object? title = null,Object? description = null,Object? status = null,Object? xpReward = null,Object? progress = null,Object? total = null,Object? sortOrder = null,}) {
  return _then(_MissionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,missionKey: null == missionKey ? _self.missionKey : missionKey // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MissionStatus,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
