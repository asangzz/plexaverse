// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BannerState {

 List<BannerTemplate> get templates; int get index;/// The position line printed on the banner. Seeded from the user's
/// headline, then owned by whatever they type.
 String get position; String get userName;/// The numeric Company Page id. Null when no page is linked — the banner
/// can still be previewed, but it cannot be applied to anything.
 String? get organizationId; BannerApplyStatus get status; String? get error;/// The page URL the server reports after a successful apply.
 String? get pageUrl;
/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerStateCopyWith<BannerState> get copyWith => _$BannerStateCopyWithImpl<BannerState>(this as BannerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerState&&const DeepCollectionEquality().equals(other.templates, templates)&&(identical(other.index, index) || other.index == index)&&(identical(other.position, position) || other.position == position)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(templates),index,position,userName,organizationId,status,error,pageUrl);

@override
String toString() {
  return 'BannerState(templates: $templates, index: $index, position: $position, userName: $userName, organizationId: $organizationId, status: $status, error: $error, pageUrl: $pageUrl)';
}


}

/// @nodoc
abstract mixin class $BannerStateCopyWith<$Res>  {
  factory $BannerStateCopyWith(BannerState value, $Res Function(BannerState) _then) = _$BannerStateCopyWithImpl;
@useResult
$Res call({
 List<BannerTemplate> templates, int index, String position, String userName, String? organizationId, BannerApplyStatus status, String? error, String? pageUrl
});




}
/// @nodoc
class _$BannerStateCopyWithImpl<$Res>
    implements $BannerStateCopyWith<$Res> {
  _$BannerStateCopyWithImpl(this._self, this._then);

  final BannerState _self;
  final $Res Function(BannerState) _then;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? templates = null,Object? index = null,Object? position = null,Object? userName = null,Object? organizationId = freezed,Object? status = null,Object? error = freezed,Object? pageUrl = freezed,}) {
  return _then(_self.copyWith(
templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<BannerTemplate>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BannerApplyStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageUrl: freezed == pageUrl ? _self.pageUrl : pageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerState].
extension BannerStatePatterns on BannerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerState value)  $default,){
final _that = this;
switch (_that) {
case _BannerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerState value)?  $default,){
final _that = this;
switch (_that) {
case _BannerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BannerTemplate> templates,  int index,  String position,  String userName,  String? organizationId,  BannerApplyStatus status,  String? error,  String? pageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerState() when $default != null:
return $default(_that.templates,_that.index,_that.position,_that.userName,_that.organizationId,_that.status,_that.error,_that.pageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BannerTemplate> templates,  int index,  String position,  String userName,  String? organizationId,  BannerApplyStatus status,  String? error,  String? pageUrl)  $default,) {final _that = this;
switch (_that) {
case _BannerState():
return $default(_that.templates,_that.index,_that.position,_that.userName,_that.organizationId,_that.status,_that.error,_that.pageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BannerTemplate> templates,  int index,  String position,  String userName,  String? organizationId,  BannerApplyStatus status,  String? error,  String? pageUrl)?  $default,) {final _that = this;
switch (_that) {
case _BannerState() when $default != null:
return $default(_that.templates,_that.index,_that.position,_that.userName,_that.organizationId,_that.status,_that.error,_that.pageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _BannerState extends BannerState {
  const _BannerState({final  List<BannerTemplate> templates = const <BannerTemplate>[], this.index = 0, this.position = 'Position', this.userName = '', this.organizationId, this.status = BannerApplyStatus.idle, this.error, this.pageUrl}): _templates = templates,super._();
  

 final  List<BannerTemplate> _templates;
@override@JsonKey() List<BannerTemplate> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}

@override@JsonKey() final  int index;
/// The position line printed on the banner. Seeded from the user's
/// headline, then owned by whatever they type.
@override@JsonKey() final  String position;
@override@JsonKey() final  String userName;
/// The numeric Company Page id. Null when no page is linked — the banner
/// can still be previewed, but it cannot be applied to anything.
@override final  String? organizationId;
@override@JsonKey() final  BannerApplyStatus status;
@override final  String? error;
/// The page URL the server reports after a successful apply.
@override final  String? pageUrl;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerStateCopyWith<_BannerState> get copyWith => __$BannerStateCopyWithImpl<_BannerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerState&&const DeepCollectionEquality().equals(other._templates, _templates)&&(identical(other.index, index) || other.index == index)&&(identical(other.position, position) || other.position == position)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_templates),index,position,userName,organizationId,status,error,pageUrl);

@override
String toString() {
  return 'BannerState(templates: $templates, index: $index, position: $position, userName: $userName, organizationId: $organizationId, status: $status, error: $error, pageUrl: $pageUrl)';
}


}

/// @nodoc
abstract mixin class _$BannerStateCopyWith<$Res> implements $BannerStateCopyWith<$Res> {
  factory _$BannerStateCopyWith(_BannerState value, $Res Function(_BannerState) _then) = __$BannerStateCopyWithImpl;
@override @useResult
$Res call({
 List<BannerTemplate> templates, int index, String position, String userName, String? organizationId, BannerApplyStatus status, String? error, String? pageUrl
});




}
/// @nodoc
class __$BannerStateCopyWithImpl<$Res>
    implements _$BannerStateCopyWith<$Res> {
  __$BannerStateCopyWithImpl(this._self, this._then);

  final _BannerState _self;
  final $Res Function(_BannerState) _then;

/// Create a copy of BannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? templates = null,Object? index = null,Object? position = null,Object? userName = null,Object? organizationId = freezed,Object? status = null,Object? error = freezed,Object? pageUrl = freezed,}) {
  return _then(_BannerState(
templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<BannerTemplate>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BannerApplyStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,pageUrl: freezed == pageUrl ? _self.pageUrl : pageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
