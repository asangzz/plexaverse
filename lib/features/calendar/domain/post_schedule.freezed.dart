// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleTopic {

 String get id; String get name;
/// Create a copy of ScheduleTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleTopicCopyWith<ScheduleTopic> get copyWith => _$ScheduleTopicCopyWithImpl<ScheduleTopic>(this as ScheduleTopic, _$identity);

  /// Serializes this ScheduleTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ScheduleTopic(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ScheduleTopicCopyWith<$Res>  {
  factory $ScheduleTopicCopyWith(ScheduleTopic value, $Res Function(ScheduleTopic) _then) = _$ScheduleTopicCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$ScheduleTopicCopyWithImpl<$Res>
    implements $ScheduleTopicCopyWith<$Res> {
  _$ScheduleTopicCopyWithImpl(this._self, this._then);

  final ScheduleTopic _self;
  final $Res Function(ScheduleTopic) _then;

/// Create a copy of ScheduleTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleTopic].
extension ScheduleTopicPatterns on ScheduleTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleTopic value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleTopic value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleTopic() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _ScheduleTopic():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleTopic() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleTopic implements ScheduleTopic {
  const _ScheduleTopic({required this.id, this.name = ''});
  factory _ScheduleTopic.fromJson(Map<String, dynamic> json) => _$ScheduleTopicFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;

/// Create a copy of ScheduleTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleTopicCopyWith<_ScheduleTopic> get copyWith => __$ScheduleTopicCopyWithImpl<_ScheduleTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ScheduleTopic(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ScheduleTopicCopyWith<$Res> implements $ScheduleTopicCopyWith<$Res> {
  factory _$ScheduleTopicCopyWith(_ScheduleTopic value, $Res Function(_ScheduleTopic) _then) = __$ScheduleTopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$ScheduleTopicCopyWithImpl<$Res>
    implements _$ScheduleTopicCopyWith<$Res> {
  __$ScheduleTopicCopyWithImpl(this._self, this._then);

  final _ScheduleTopic _self;
  final $Res Function(_ScheduleTopic) _then;

/// Create a copy of ScheduleTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_ScheduleTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CalendarAccount {

 String get id; String get profileName;/// `'personal'` or `'company'`. Absent on the schedule join.
 String get appType;/// The account's LinkedIn token is dead or nearly dead and the user has to
/// re-authorise. Absent on the schedule join, so it defaults to false —
/// never assume a reconnect is needed from missing data.
 bool get needsReconnect;
/// Create a copy of CalendarAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarAccountCopyWith<CalendarAccount> get copyWith => _$CalendarAccountCopyWithImpl<CalendarAccount>(this as CalendarAccount, _$identity);

  /// Serializes this CalendarAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileName,appType,needsReconnect);

@override
String toString() {
  return 'CalendarAccount(id: $id, profileName: $profileName, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class $CalendarAccountCopyWith<$Res>  {
  factory $CalendarAccountCopyWith(CalendarAccount value, $Res Function(CalendarAccount) _then) = _$CalendarAccountCopyWithImpl;
@useResult
$Res call({
 String id, String profileName, String appType, bool needsReconnect
});




}
/// @nodoc
class _$CalendarAccountCopyWithImpl<$Res>
    implements $CalendarAccountCopyWith<$Res> {
  _$CalendarAccountCopyWithImpl(this._self, this._then);

  final CalendarAccount _self;
  final $Res Function(CalendarAccount) _then;

/// Create a copy of CalendarAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileName = null,Object? appType = null,Object? needsReconnect = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: null == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarAccount].
extension CalendarAccountPatterns on CalendarAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarAccount value)  $default,){
final _that = this;
switch (_that) {
case _CalendarAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarAccount value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileName,  String appType,  bool needsReconnect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarAccount() when $default != null:
return $default(_that.id,_that.profileName,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileName,  String appType,  bool needsReconnect)  $default,) {final _that = this;
switch (_that) {
case _CalendarAccount():
return $default(_that.id,_that.profileName,_that.appType,_that.needsReconnect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileName,  String appType,  bool needsReconnect)?  $default,) {final _that = this;
switch (_that) {
case _CalendarAccount() when $default != null:
return $default(_that.id,_that.profileName,_that.appType,_that.needsReconnect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarAccount extends CalendarAccount {
  const _CalendarAccount({required this.id, this.profileName = '', this.appType = 'personal', this.needsReconnect = false}): super._();
  factory _CalendarAccount.fromJson(Map<String, dynamic> json) => _$CalendarAccountFromJson(json);

@override final  String id;
@override@JsonKey() final  String profileName;
/// `'personal'` or `'company'`. Absent on the schedule join.
@override@JsonKey() final  String appType;
/// The account's LinkedIn token is dead or nearly dead and the user has to
/// re-authorise. Absent on the schedule join, so it defaults to false —
/// never assume a reconnect is needed from missing data.
@override@JsonKey() final  bool needsReconnect;

/// Create a copy of CalendarAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarAccountCopyWith<_CalendarAccount> get copyWith => __$CalendarAccountCopyWithImpl<_CalendarAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.appType, appType) || other.appType == appType)&&(identical(other.needsReconnect, needsReconnect) || other.needsReconnect == needsReconnect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,profileName,appType,needsReconnect);

@override
String toString() {
  return 'CalendarAccount(id: $id, profileName: $profileName, appType: $appType, needsReconnect: $needsReconnect)';
}


}

/// @nodoc
abstract mixin class _$CalendarAccountCopyWith<$Res> implements $CalendarAccountCopyWith<$Res> {
  factory _$CalendarAccountCopyWith(_CalendarAccount value, $Res Function(_CalendarAccount) _then) = __$CalendarAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileName, String appType, bool needsReconnect
});




}
/// @nodoc
class __$CalendarAccountCopyWithImpl<$Res>
    implements _$CalendarAccountCopyWith<$Res> {
  __$CalendarAccountCopyWithImpl(this._self, this._then);

  final _CalendarAccount _self;
  final $Res Function(_CalendarAccount) _then;

/// Create a copy of CalendarAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileName = null,Object? appType = null,Object? needsReconnect = null,}) {
  return _then(_CalendarAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,appType: null == appType ? _self.appType : appType // ignore: cast_nullable_to_non_nullable
as String,needsReconnect: null == needsReconnect ? _self.needsReconnect : needsReconnect // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PostSchedule {

 String get id; String? get topicId; String get linkedinAccountId;/// Which days it fires, 0=Sunday … 6=Saturday.
 List<int> get dayOfWeek;/// `HH:MM`, 24-hour. The server validates this shape and rejects anything
/// else, so the UI only ever offers real slots.
 String get timeOfDay;/// IANA zone. The server defaults to `Asia/Kolkata`.
 String get timezone; bool get isActive; ScheduleTopic? get topic; CalendarAccount? get linkedinAccount;
/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostScheduleCopyWith<PostSchedule> get copyWith => _$PostScheduleCopyWithImpl<PostSchedule>(this as PostSchedule, _$identity);

  /// Serializes this PostSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.linkedinAccountId, linkedinAccountId) || other.linkedinAccountId == linkedinAccountId)&&const DeepCollectionEquality().equals(other.dayOfWeek, dayOfWeek)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.linkedinAccount, linkedinAccount) || other.linkedinAccount == linkedinAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicId,linkedinAccountId,const DeepCollectionEquality().hash(dayOfWeek),timeOfDay,timezone,isActive,topic,linkedinAccount);

@override
String toString() {
  return 'PostSchedule(id: $id, topicId: $topicId, linkedinAccountId: $linkedinAccountId, dayOfWeek: $dayOfWeek, timeOfDay: $timeOfDay, timezone: $timezone, isActive: $isActive, topic: $topic, linkedinAccount: $linkedinAccount)';
}


}

/// @nodoc
abstract mixin class $PostScheduleCopyWith<$Res>  {
  factory $PostScheduleCopyWith(PostSchedule value, $Res Function(PostSchedule) _then) = _$PostScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String? topicId, String linkedinAccountId, List<int> dayOfWeek, String timeOfDay, String timezone, bool isActive, ScheduleTopic? topic, CalendarAccount? linkedinAccount
});


$ScheduleTopicCopyWith<$Res>? get topic;$CalendarAccountCopyWith<$Res>? get linkedinAccount;

}
/// @nodoc
class _$PostScheduleCopyWithImpl<$Res>
    implements $PostScheduleCopyWith<$Res> {
  _$PostScheduleCopyWithImpl(this._self, this._then);

  final PostSchedule _self;
  final $Res Function(PostSchedule) _then;

/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? topicId = freezed,Object? linkedinAccountId = null,Object? dayOfWeek = null,Object? timeOfDay = null,Object? timezone = null,Object? isActive = null,Object? topic = freezed,Object? linkedinAccount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,linkedinAccountId: null == linkedinAccountId ? _self.linkedinAccountId : linkedinAccountId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as ScheduleTopic?,linkedinAccount: freezed == linkedinAccount ? _self.linkedinAccount : linkedinAccount // ignore: cast_nullable_to_non_nullable
as CalendarAccount?,
  ));
}
/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $ScheduleTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarAccountCopyWith<$Res>? get linkedinAccount {
    if (_self.linkedinAccount == null) {
    return null;
  }

  return $CalendarAccountCopyWith<$Res>(_self.linkedinAccount!, (value) {
    return _then(_self.copyWith(linkedinAccount: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostSchedule].
extension PostSchedulePatterns on PostSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PostSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PostSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? topicId,  String linkedinAccountId,  List<int> dayOfWeek,  String timeOfDay,  String timezone,  bool isActive,  ScheduleTopic? topic,  CalendarAccount? linkedinAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostSchedule() when $default != null:
return $default(_that.id,_that.topicId,_that.linkedinAccountId,_that.dayOfWeek,_that.timeOfDay,_that.timezone,_that.isActive,_that.topic,_that.linkedinAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? topicId,  String linkedinAccountId,  List<int> dayOfWeek,  String timeOfDay,  String timezone,  bool isActive,  ScheduleTopic? topic,  CalendarAccount? linkedinAccount)  $default,) {final _that = this;
switch (_that) {
case _PostSchedule():
return $default(_that.id,_that.topicId,_that.linkedinAccountId,_that.dayOfWeek,_that.timeOfDay,_that.timezone,_that.isActive,_that.topic,_that.linkedinAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? topicId,  String linkedinAccountId,  List<int> dayOfWeek,  String timeOfDay,  String timezone,  bool isActive,  ScheduleTopic? topic,  CalendarAccount? linkedinAccount)?  $default,) {final _that = this;
switch (_that) {
case _PostSchedule() when $default != null:
return $default(_that.id,_that.topicId,_that.linkedinAccountId,_that.dayOfWeek,_that.timeOfDay,_that.timezone,_that.isActive,_that.topic,_that.linkedinAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostSchedule extends PostSchedule {
  const _PostSchedule({required this.id, this.topicId, this.linkedinAccountId = '', final  List<int> dayOfWeek = const <int>[], this.timeOfDay = '09:00', this.timezone = 'Asia/Kolkata', this.isActive = true, this.topic, this.linkedinAccount}): _dayOfWeek = dayOfWeek,super._();
  factory _PostSchedule.fromJson(Map<String, dynamic> json) => _$PostScheduleFromJson(json);

@override final  String id;
@override final  String? topicId;
@override@JsonKey() final  String linkedinAccountId;
/// Which days it fires, 0=Sunday … 6=Saturday.
 final  List<int> _dayOfWeek;
/// Which days it fires, 0=Sunday … 6=Saturday.
@override@JsonKey() List<int> get dayOfWeek {
  if (_dayOfWeek is EqualUnmodifiableListView) return _dayOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dayOfWeek);
}

/// `HH:MM`, 24-hour. The server validates this shape and rejects anything
/// else, so the UI only ever offers real slots.
@override@JsonKey() final  String timeOfDay;
/// IANA zone. The server defaults to `Asia/Kolkata`.
@override@JsonKey() final  String timezone;
@override@JsonKey() final  bool isActive;
@override final  ScheduleTopic? topic;
@override final  CalendarAccount? linkedinAccount;

/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostScheduleCopyWith<_PostSchedule> get copyWith => __$PostScheduleCopyWithImpl<_PostSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.linkedinAccountId, linkedinAccountId) || other.linkedinAccountId == linkedinAccountId)&&const DeepCollectionEquality().equals(other._dayOfWeek, _dayOfWeek)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.linkedinAccount, linkedinAccount) || other.linkedinAccount == linkedinAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,topicId,linkedinAccountId,const DeepCollectionEquality().hash(_dayOfWeek),timeOfDay,timezone,isActive,topic,linkedinAccount);

@override
String toString() {
  return 'PostSchedule(id: $id, topicId: $topicId, linkedinAccountId: $linkedinAccountId, dayOfWeek: $dayOfWeek, timeOfDay: $timeOfDay, timezone: $timezone, isActive: $isActive, topic: $topic, linkedinAccount: $linkedinAccount)';
}


}

/// @nodoc
abstract mixin class _$PostScheduleCopyWith<$Res> implements $PostScheduleCopyWith<$Res> {
  factory _$PostScheduleCopyWith(_PostSchedule value, $Res Function(_PostSchedule) _then) = __$PostScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String? topicId, String linkedinAccountId, List<int> dayOfWeek, String timeOfDay, String timezone, bool isActive, ScheduleTopic? topic, CalendarAccount? linkedinAccount
});


@override $ScheduleTopicCopyWith<$Res>? get topic;@override $CalendarAccountCopyWith<$Res>? get linkedinAccount;

}
/// @nodoc
class __$PostScheduleCopyWithImpl<$Res>
    implements _$PostScheduleCopyWith<$Res> {
  __$PostScheduleCopyWithImpl(this._self, this._then);

  final _PostSchedule _self;
  final $Res Function(_PostSchedule) _then;

/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? topicId = freezed,Object? linkedinAccountId = null,Object? dayOfWeek = null,Object? timeOfDay = null,Object? timezone = null,Object? isActive = null,Object? topic = freezed,Object? linkedinAccount = freezed,}) {
  return _then(_PostSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String?,linkedinAccountId: null == linkedinAccountId ? _self.linkedinAccountId : linkedinAccountId // ignore: cast_nullable_to_non_nullable
as String,dayOfWeek: null == dayOfWeek ? _self._dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as List<int>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as ScheduleTopic?,linkedinAccount: freezed == linkedinAccount ? _self.linkedinAccount : linkedinAccount // ignore: cast_nullable_to_non_nullable
as CalendarAccount?,
  ));
}

/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleTopicCopyWith<$Res>? get topic {
    if (_self.topic == null) {
    return null;
  }

  return $ScheduleTopicCopyWith<$Res>(_self.topic!, (value) {
    return _then(_self.copyWith(topic: value));
  });
}/// Create a copy of PostSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarAccountCopyWith<$Res>? get linkedinAccount {
    if (_self.linkedinAccount == null) {
    return null;
  }

  return $CalendarAccountCopyWith<$Res>(_self.linkedinAccount!, (value) {
    return _then(_self.copyWith(linkedinAccount: value));
  });
}
}

// dart format on
