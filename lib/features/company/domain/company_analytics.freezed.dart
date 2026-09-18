// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FollowerCounts {

 int get organicFollowerCount; int get paidFollowerCount;
/// Create a copy of FollowerCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowerCountsCopyWith<FollowerCounts> get copyWith => _$FollowerCountsCopyWithImpl<FollowerCounts>(this as FollowerCounts, _$identity);

  /// Serializes this FollowerCounts to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowerCounts&&(identical(other.organicFollowerCount, organicFollowerCount) || other.organicFollowerCount == organicFollowerCount)&&(identical(other.paidFollowerCount, paidFollowerCount) || other.paidFollowerCount == paidFollowerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organicFollowerCount,paidFollowerCount);

@override
String toString() {
  return 'FollowerCounts(organicFollowerCount: $organicFollowerCount, paidFollowerCount: $paidFollowerCount)';
}


}

/// @nodoc
abstract mixin class $FollowerCountsCopyWith<$Res>  {
  factory $FollowerCountsCopyWith(FollowerCounts value, $Res Function(FollowerCounts) _then) = _$FollowerCountsCopyWithImpl;
@useResult
$Res call({
 int organicFollowerCount, int paidFollowerCount
});




}
/// @nodoc
class _$FollowerCountsCopyWithImpl<$Res>
    implements $FollowerCountsCopyWith<$Res> {
  _$FollowerCountsCopyWithImpl(this._self, this._then);

  final FollowerCounts _self;
  final $Res Function(FollowerCounts) _then;

/// Create a copy of FollowerCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organicFollowerCount = null,Object? paidFollowerCount = null,}) {
  return _then(_self.copyWith(
organicFollowerCount: null == organicFollowerCount ? _self.organicFollowerCount : organicFollowerCount // ignore: cast_nullable_to_non_nullable
as int,paidFollowerCount: null == paidFollowerCount ? _self.paidFollowerCount : paidFollowerCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FollowerCounts].
extension FollowerCountsPatterns on FollowerCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowerCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowerCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowerCounts value)  $default,){
final _that = this;
switch (_that) {
case _FollowerCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowerCounts value)?  $default,){
final _that = this;
switch (_that) {
case _FollowerCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int organicFollowerCount,  int paidFollowerCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowerCounts() when $default != null:
return $default(_that.organicFollowerCount,_that.paidFollowerCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int organicFollowerCount,  int paidFollowerCount)  $default,) {final _that = this;
switch (_that) {
case _FollowerCounts():
return $default(_that.organicFollowerCount,_that.paidFollowerCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int organicFollowerCount,  int paidFollowerCount)?  $default,) {final _that = this;
switch (_that) {
case _FollowerCounts() when $default != null:
return $default(_that.organicFollowerCount,_that.paidFollowerCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FollowerCounts extends FollowerCounts {
  const _FollowerCounts({this.organicFollowerCount = 0, this.paidFollowerCount = 0}): super._();
  factory _FollowerCounts.fromJson(Map<String, dynamic> json) => _$FollowerCountsFromJson(json);

@override@JsonKey() final  int organicFollowerCount;
@override@JsonKey() final  int paidFollowerCount;

/// Create a copy of FollowerCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowerCountsCopyWith<_FollowerCounts> get copyWith => __$FollowerCountsCopyWithImpl<_FollowerCounts>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FollowerCountsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowerCounts&&(identical(other.organicFollowerCount, organicFollowerCount) || other.organicFollowerCount == organicFollowerCount)&&(identical(other.paidFollowerCount, paidFollowerCount) || other.paidFollowerCount == paidFollowerCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organicFollowerCount,paidFollowerCount);

@override
String toString() {
  return 'FollowerCounts(organicFollowerCount: $organicFollowerCount, paidFollowerCount: $paidFollowerCount)';
}


}

/// @nodoc
abstract mixin class _$FollowerCountsCopyWith<$Res> implements $FollowerCountsCopyWith<$Res> {
  factory _$FollowerCountsCopyWith(_FollowerCounts value, $Res Function(_FollowerCounts) _then) = __$FollowerCountsCopyWithImpl;
@override @useResult
$Res call({
 int organicFollowerCount, int paidFollowerCount
});




}
/// @nodoc
class __$FollowerCountsCopyWithImpl<$Res>
    implements _$FollowerCountsCopyWith<$Res> {
  __$FollowerCountsCopyWithImpl(this._self, this._then);

  final _FollowerCounts _self;
  final $Res Function(_FollowerCounts) _then;

/// Create a copy of FollowerCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organicFollowerCount = null,Object? paidFollowerCount = null,}) {
  return _then(_FollowerCounts(
organicFollowerCount: null == organicFollowerCount ? _self.organicFollowerCount : organicFollowerCount // ignore: cast_nullable_to_non_nullable
as int,paidFollowerCount: null == paidFollowerCount ? _self.paidFollowerCount : paidFollowerCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GeoFollowerBucket {

 String? get geo; FollowerCounts get followerCounts;
/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoFollowerBucketCopyWith<GeoFollowerBucket> get copyWith => _$GeoFollowerBucketCopyWithImpl<GeoFollowerBucket>(this as GeoFollowerBucket, _$identity);

  /// Serializes this GeoFollowerBucket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoFollowerBucket&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.followerCounts, followerCounts) || other.followerCounts == followerCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,geo,followerCounts);

@override
String toString() {
  return 'GeoFollowerBucket(geo: $geo, followerCounts: $followerCounts)';
}


}

/// @nodoc
abstract mixin class $GeoFollowerBucketCopyWith<$Res>  {
  factory $GeoFollowerBucketCopyWith(GeoFollowerBucket value, $Res Function(GeoFollowerBucket) _then) = _$GeoFollowerBucketCopyWithImpl;
@useResult
$Res call({
 String? geo, FollowerCounts followerCounts
});


$FollowerCountsCopyWith<$Res> get followerCounts;

}
/// @nodoc
class _$GeoFollowerBucketCopyWithImpl<$Res>
    implements $GeoFollowerBucketCopyWith<$Res> {
  _$GeoFollowerBucketCopyWithImpl(this._self, this._then);

  final GeoFollowerBucket _self;
  final $Res Function(GeoFollowerBucket) _then;

/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? geo = freezed,Object? followerCounts = null,}) {
  return _then(_self.copyWith(
geo: freezed == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as String?,followerCounts: null == followerCounts ? _self.followerCounts : followerCounts // ignore: cast_nullable_to_non_nullable
as FollowerCounts,
  ));
}
/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerCountsCopyWith<$Res> get followerCounts {
  
  return $FollowerCountsCopyWith<$Res>(_self.followerCounts, (value) {
    return _then(_self.copyWith(followerCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeoFollowerBucket].
extension GeoFollowerBucketPatterns on GeoFollowerBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoFollowerBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoFollowerBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoFollowerBucket value)  $default,){
final _that = this;
switch (_that) {
case _GeoFollowerBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoFollowerBucket value)?  $default,){
final _that = this;
switch (_that) {
case _GeoFollowerBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? geo,  FollowerCounts followerCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoFollowerBucket() when $default != null:
return $default(_that.geo,_that.followerCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? geo,  FollowerCounts followerCounts)  $default,) {final _that = this;
switch (_that) {
case _GeoFollowerBucket():
return $default(_that.geo,_that.followerCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? geo,  FollowerCounts followerCounts)?  $default,) {final _that = this;
switch (_that) {
case _GeoFollowerBucket() when $default != null:
return $default(_that.geo,_that.followerCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoFollowerBucket implements GeoFollowerBucket {
  const _GeoFollowerBucket({this.geo, this.followerCounts = const FollowerCounts()});
  factory _GeoFollowerBucket.fromJson(Map<String, dynamic> json) => _$GeoFollowerBucketFromJson(json);

@override final  String? geo;
@override@JsonKey() final  FollowerCounts followerCounts;

/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoFollowerBucketCopyWith<_GeoFollowerBucket> get copyWith => __$GeoFollowerBucketCopyWithImpl<_GeoFollowerBucket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoFollowerBucketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoFollowerBucket&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.followerCounts, followerCounts) || other.followerCounts == followerCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,geo,followerCounts);

@override
String toString() {
  return 'GeoFollowerBucket(geo: $geo, followerCounts: $followerCounts)';
}


}

/// @nodoc
abstract mixin class _$GeoFollowerBucketCopyWith<$Res> implements $GeoFollowerBucketCopyWith<$Res> {
  factory _$GeoFollowerBucketCopyWith(_GeoFollowerBucket value, $Res Function(_GeoFollowerBucket) _then) = __$GeoFollowerBucketCopyWithImpl;
@override @useResult
$Res call({
 String? geo, FollowerCounts followerCounts
});


@override $FollowerCountsCopyWith<$Res> get followerCounts;

}
/// @nodoc
class __$GeoFollowerBucketCopyWithImpl<$Res>
    implements _$GeoFollowerBucketCopyWith<$Res> {
  __$GeoFollowerBucketCopyWithImpl(this._self, this._then);

  final _GeoFollowerBucket _self;
  final $Res Function(_GeoFollowerBucket) _then;

/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? geo = freezed,Object? followerCounts = null,}) {
  return _then(_GeoFollowerBucket(
geo: freezed == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as String?,followerCounts: null == followerCounts ? _self.followerCounts : followerCounts // ignore: cast_nullable_to_non_nullable
as FollowerCounts,
  ));
}

/// Create a copy of GeoFollowerBucket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerCountsCopyWith<$Res> get followerCounts {
  
  return $FollowerCountsCopyWith<$Res>(_self.followerCounts, (value) {
    return _then(_self.copyWith(followerCounts: value));
  });
}
}


/// @nodoc
mixin _$StaffCountBucket {

 String? get staffCountRange; FollowerCounts get followerCounts;
/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffCountBucketCopyWith<StaffCountBucket> get copyWith => _$StaffCountBucketCopyWithImpl<StaffCountBucket>(this as StaffCountBucket, _$identity);

  /// Serializes this StaffCountBucket to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffCountBucket&&(identical(other.staffCountRange, staffCountRange) || other.staffCountRange == staffCountRange)&&(identical(other.followerCounts, followerCounts) || other.followerCounts == followerCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,staffCountRange,followerCounts);

@override
String toString() {
  return 'StaffCountBucket(staffCountRange: $staffCountRange, followerCounts: $followerCounts)';
}


}

/// @nodoc
abstract mixin class $StaffCountBucketCopyWith<$Res>  {
  factory $StaffCountBucketCopyWith(StaffCountBucket value, $Res Function(StaffCountBucket) _then) = _$StaffCountBucketCopyWithImpl;
@useResult
$Res call({
 String? staffCountRange, FollowerCounts followerCounts
});


$FollowerCountsCopyWith<$Res> get followerCounts;

}
/// @nodoc
class _$StaffCountBucketCopyWithImpl<$Res>
    implements $StaffCountBucketCopyWith<$Res> {
  _$StaffCountBucketCopyWithImpl(this._self, this._then);

  final StaffCountBucket _self;
  final $Res Function(StaffCountBucket) _then;

/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? staffCountRange = freezed,Object? followerCounts = null,}) {
  return _then(_self.copyWith(
staffCountRange: freezed == staffCountRange ? _self.staffCountRange : staffCountRange // ignore: cast_nullable_to_non_nullable
as String?,followerCounts: null == followerCounts ? _self.followerCounts : followerCounts // ignore: cast_nullable_to_non_nullable
as FollowerCounts,
  ));
}
/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerCountsCopyWith<$Res> get followerCounts {
  
  return $FollowerCountsCopyWith<$Res>(_self.followerCounts, (value) {
    return _then(_self.copyWith(followerCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [StaffCountBucket].
extension StaffCountBucketPatterns on StaffCountBucket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffCountBucket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffCountBucket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffCountBucket value)  $default,){
final _that = this;
switch (_that) {
case _StaffCountBucket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffCountBucket value)?  $default,){
final _that = this;
switch (_that) {
case _StaffCountBucket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? staffCountRange,  FollowerCounts followerCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffCountBucket() when $default != null:
return $default(_that.staffCountRange,_that.followerCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? staffCountRange,  FollowerCounts followerCounts)  $default,) {final _that = this;
switch (_that) {
case _StaffCountBucket():
return $default(_that.staffCountRange,_that.followerCounts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? staffCountRange,  FollowerCounts followerCounts)?  $default,) {final _that = this;
switch (_that) {
case _StaffCountBucket() when $default != null:
return $default(_that.staffCountRange,_that.followerCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffCountBucket extends StaffCountBucket {
  const _StaffCountBucket({this.staffCountRange, this.followerCounts = const FollowerCounts()}): super._();
  factory _StaffCountBucket.fromJson(Map<String, dynamic> json) => _$StaffCountBucketFromJson(json);

@override final  String? staffCountRange;
@override@JsonKey() final  FollowerCounts followerCounts;

/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffCountBucketCopyWith<_StaffCountBucket> get copyWith => __$StaffCountBucketCopyWithImpl<_StaffCountBucket>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffCountBucketToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffCountBucket&&(identical(other.staffCountRange, staffCountRange) || other.staffCountRange == staffCountRange)&&(identical(other.followerCounts, followerCounts) || other.followerCounts == followerCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,staffCountRange,followerCounts);

@override
String toString() {
  return 'StaffCountBucket(staffCountRange: $staffCountRange, followerCounts: $followerCounts)';
}


}

/// @nodoc
abstract mixin class _$StaffCountBucketCopyWith<$Res> implements $StaffCountBucketCopyWith<$Res> {
  factory _$StaffCountBucketCopyWith(_StaffCountBucket value, $Res Function(_StaffCountBucket) _then) = __$StaffCountBucketCopyWithImpl;
@override @useResult
$Res call({
 String? staffCountRange, FollowerCounts followerCounts
});


@override $FollowerCountsCopyWith<$Res> get followerCounts;

}
/// @nodoc
class __$StaffCountBucketCopyWithImpl<$Res>
    implements _$StaffCountBucketCopyWith<$Res> {
  __$StaffCountBucketCopyWithImpl(this._self, this._then);

  final _StaffCountBucket _self;
  final $Res Function(_StaffCountBucket) _then;

/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? staffCountRange = freezed,Object? followerCounts = null,}) {
  return _then(_StaffCountBucket(
staffCountRange: freezed == staffCountRange ? _self.staffCountRange : staffCountRange // ignore: cast_nullable_to_non_nullable
as String?,followerCounts: null == followerCounts ? _self.followerCounts : followerCounts // ignore: cast_nullable_to_non_nullable
as FollowerCounts,
  ));
}

/// Create a copy of StaffCountBucket
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FollowerCountsCopyWith<$Res> get followerCounts {
  
  return $FollowerCountsCopyWith<$Res>(_self.followerCounts, (value) {
    return _then(_self.copyWith(followerCounts: value));
  });
}
}


/// @nodoc
mixin _$PageViewCount {

 int get pageViews; int get uniquePageViews;
/// Create a copy of PageViewCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageViewCountCopyWith<PageViewCount> get copyWith => _$PageViewCountCopyWithImpl<PageViewCount>(this as PageViewCount, _$identity);

  /// Serializes this PageViewCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageViewCount&&(identical(other.pageViews, pageViews) || other.pageViews == pageViews)&&(identical(other.uniquePageViews, uniquePageViews) || other.uniquePageViews == uniquePageViews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageViews,uniquePageViews);

@override
String toString() {
  return 'PageViewCount(pageViews: $pageViews, uniquePageViews: $uniquePageViews)';
}


}

/// @nodoc
abstract mixin class $PageViewCountCopyWith<$Res>  {
  factory $PageViewCountCopyWith(PageViewCount value, $Res Function(PageViewCount) _then) = _$PageViewCountCopyWithImpl;
@useResult
$Res call({
 int pageViews, int uniquePageViews
});




}
/// @nodoc
class _$PageViewCountCopyWithImpl<$Res>
    implements $PageViewCountCopyWith<$Res> {
  _$PageViewCountCopyWithImpl(this._self, this._then);

  final PageViewCount _self;
  final $Res Function(PageViewCount) _then;

/// Create a copy of PageViewCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageViews = null,Object? uniquePageViews = null,}) {
  return _then(_self.copyWith(
pageViews: null == pageViews ? _self.pageViews : pageViews // ignore: cast_nullable_to_non_nullable
as int,uniquePageViews: null == uniquePageViews ? _self.uniquePageViews : uniquePageViews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PageViewCount].
extension PageViewCountPatterns on PageViewCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageViewCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageViewCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageViewCount value)  $default,){
final _that = this;
switch (_that) {
case _PageViewCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageViewCount value)?  $default,){
final _that = this;
switch (_that) {
case _PageViewCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageViews,  int uniquePageViews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageViewCount() when $default != null:
return $default(_that.pageViews,_that.uniquePageViews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageViews,  int uniquePageViews)  $default,) {final _that = this;
switch (_that) {
case _PageViewCount():
return $default(_that.pageViews,_that.uniquePageViews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageViews,  int uniquePageViews)?  $default,) {final _that = this;
switch (_that) {
case _PageViewCount() when $default != null:
return $default(_that.pageViews,_that.uniquePageViews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageViewCount implements PageViewCount {
  const _PageViewCount({this.pageViews = 0, this.uniquePageViews = 0});
  factory _PageViewCount.fromJson(Map<String, dynamic> json) => _$PageViewCountFromJson(json);

@override@JsonKey() final  int pageViews;
@override@JsonKey() final  int uniquePageViews;

/// Create a copy of PageViewCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageViewCountCopyWith<_PageViewCount> get copyWith => __$PageViewCountCopyWithImpl<_PageViewCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageViewCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageViewCount&&(identical(other.pageViews, pageViews) || other.pageViews == pageViews)&&(identical(other.uniquePageViews, uniquePageViews) || other.uniquePageViews == uniquePageViews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageViews,uniquePageViews);

@override
String toString() {
  return 'PageViewCount(pageViews: $pageViews, uniquePageViews: $uniquePageViews)';
}


}

/// @nodoc
abstract mixin class _$PageViewCountCopyWith<$Res> implements $PageViewCountCopyWith<$Res> {
  factory _$PageViewCountCopyWith(_PageViewCount value, $Res Function(_PageViewCount) _then) = __$PageViewCountCopyWithImpl;
@override @useResult
$Res call({
 int pageViews, int uniquePageViews
});




}
/// @nodoc
class __$PageViewCountCopyWithImpl<$Res>
    implements _$PageViewCountCopyWith<$Res> {
  __$PageViewCountCopyWithImpl(this._self, this._then);

  final _PageViewCount _self;
  final $Res Function(_PageViewCount) _then;

/// Create a copy of PageViewCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageViews = null,Object? uniquePageViews = null,}) {
  return _then(_PageViewCount(
pageViews: null == pageViews ? _self.pageViews : pageViews // ignore: cast_nullable_to_non_nullable
as int,uniquePageViews: null == uniquePageViews ? _self.uniquePageViews : uniquePageViews // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CompanyPageStats {

@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson) Map<String, PageViewCount> get views;
/// Create a copy of CompanyPageStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyPageStatsCopyWith<CompanyPageStats> get copyWith => _$CompanyPageStatsCopyWithImpl<CompanyPageStats>(this as CompanyPageStats, _$identity);

  /// Serializes this CompanyPageStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyPageStats&&const DeepCollectionEquality().equals(other.views, views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(views));

@override
String toString() {
  return 'CompanyPageStats(views: $views)';
}


}

/// @nodoc
abstract mixin class $CompanyPageStatsCopyWith<$Res>  {
  factory $CompanyPageStatsCopyWith(CompanyPageStats value, $Res Function(CompanyPageStats) _then) = _$CompanyPageStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson) Map<String, PageViewCount> views
});




}
/// @nodoc
class _$CompanyPageStatsCopyWithImpl<$Res>
    implements $CompanyPageStatsCopyWith<$Res> {
  _$CompanyPageStatsCopyWithImpl(this._self, this._then);

  final CompanyPageStats _self;
  final $Res Function(CompanyPageStats) _then;

/// Create a copy of CompanyPageStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? views = null,}) {
  return _then(_self.copyWith(
views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as Map<String, PageViewCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyPageStats].
extension CompanyPageStatsPatterns on CompanyPageStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyPageStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyPageStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyPageStats value)  $default,){
final _that = this;
switch (_that) {
case _CompanyPageStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyPageStats value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyPageStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson)  Map<String, PageViewCount> views)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyPageStats() when $default != null:
return $default(_that.views);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson)  Map<String, PageViewCount> views)  $default,) {final _that = this;
switch (_that) {
case _CompanyPageStats():
return $default(_that.views);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson)  Map<String, PageViewCount> views)?  $default,) {final _that = this;
switch (_that) {
case _CompanyPageStats() when $default != null:
return $default(_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyPageStats extends CompanyPageStats {
  const _CompanyPageStats({@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson) final  Map<String, PageViewCount> views = const <String, PageViewCount>{}}): _views = views,super._();
  factory _CompanyPageStats.fromJson(Map<String, dynamic> json) => _$CompanyPageStatsFromJson(json);

 final  Map<String, PageViewCount> _views;
@override@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson) Map<String, PageViewCount> get views {
  if (_views is EqualUnmodifiableMapView) return _views;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_views);
}


/// Create a copy of CompanyPageStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyPageStatsCopyWith<_CompanyPageStats> get copyWith => __$CompanyPageStatsCopyWithImpl<_CompanyPageStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyPageStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyPageStats&&const DeepCollectionEquality().equals(other._views, _views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_views));

@override
String toString() {
  return 'CompanyPageStats(views: $views)';
}


}

/// @nodoc
abstract mixin class _$CompanyPageStatsCopyWith<$Res> implements $CompanyPageStatsCopyWith<$Res> {
  factory _$CompanyPageStatsCopyWith(_CompanyPageStats value, $Res Function(_CompanyPageStats) _then) = __$CompanyPageStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _viewsFromJson, toJson: _viewsToJson) Map<String, PageViewCount> views
});




}
/// @nodoc
class __$CompanyPageStatsCopyWithImpl<$Res>
    implements _$CompanyPageStatsCopyWith<$Res> {
  __$CompanyPageStatsCopyWithImpl(this._self, this._then);

  final _CompanyPageStats _self;
  final $Res Function(_CompanyPageStats) _then;

/// Create a copy of CompanyPageStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? views = null,}) {
  return _then(_CompanyPageStats(
views: null == views ? _self._views : views // ignore: cast_nullable_to_non_nullable
as Map<String, PageViewCount>,
  ));
}


}


/// @nodoc
mixin _$CompanyFollowerStats {

 List<GeoFollowerBucket> get followerCountsByGeoCountry; List<StaffCountBucket> get followerCountsByStaffCountRange;
/// Create a copy of CompanyFollowerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyFollowerStatsCopyWith<CompanyFollowerStats> get copyWith => _$CompanyFollowerStatsCopyWithImpl<CompanyFollowerStats>(this as CompanyFollowerStats, _$identity);

  /// Serializes this CompanyFollowerStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyFollowerStats&&const DeepCollectionEquality().equals(other.followerCountsByGeoCountry, followerCountsByGeoCountry)&&const DeepCollectionEquality().equals(other.followerCountsByStaffCountRange, followerCountsByStaffCountRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(followerCountsByGeoCountry),const DeepCollectionEquality().hash(followerCountsByStaffCountRange));

@override
String toString() {
  return 'CompanyFollowerStats(followerCountsByGeoCountry: $followerCountsByGeoCountry, followerCountsByStaffCountRange: $followerCountsByStaffCountRange)';
}


}

/// @nodoc
abstract mixin class $CompanyFollowerStatsCopyWith<$Res>  {
  factory $CompanyFollowerStatsCopyWith(CompanyFollowerStats value, $Res Function(CompanyFollowerStats) _then) = _$CompanyFollowerStatsCopyWithImpl;
@useResult
$Res call({
 List<GeoFollowerBucket> followerCountsByGeoCountry, List<StaffCountBucket> followerCountsByStaffCountRange
});




}
/// @nodoc
class _$CompanyFollowerStatsCopyWithImpl<$Res>
    implements $CompanyFollowerStatsCopyWith<$Res> {
  _$CompanyFollowerStatsCopyWithImpl(this._self, this._then);

  final CompanyFollowerStats _self;
  final $Res Function(CompanyFollowerStats) _then;

/// Create a copy of CompanyFollowerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followerCountsByGeoCountry = null,Object? followerCountsByStaffCountRange = null,}) {
  return _then(_self.copyWith(
followerCountsByGeoCountry: null == followerCountsByGeoCountry ? _self.followerCountsByGeoCountry : followerCountsByGeoCountry // ignore: cast_nullable_to_non_nullable
as List<GeoFollowerBucket>,followerCountsByStaffCountRange: null == followerCountsByStaffCountRange ? _self.followerCountsByStaffCountRange : followerCountsByStaffCountRange // ignore: cast_nullable_to_non_nullable
as List<StaffCountBucket>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyFollowerStats].
extension CompanyFollowerStatsPatterns on CompanyFollowerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyFollowerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyFollowerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyFollowerStats value)  $default,){
final _that = this;
switch (_that) {
case _CompanyFollowerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyFollowerStats value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyFollowerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GeoFollowerBucket> followerCountsByGeoCountry,  List<StaffCountBucket> followerCountsByStaffCountRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyFollowerStats() when $default != null:
return $default(_that.followerCountsByGeoCountry,_that.followerCountsByStaffCountRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GeoFollowerBucket> followerCountsByGeoCountry,  List<StaffCountBucket> followerCountsByStaffCountRange)  $default,) {final _that = this;
switch (_that) {
case _CompanyFollowerStats():
return $default(_that.followerCountsByGeoCountry,_that.followerCountsByStaffCountRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GeoFollowerBucket> followerCountsByGeoCountry,  List<StaffCountBucket> followerCountsByStaffCountRange)?  $default,) {final _that = this;
switch (_that) {
case _CompanyFollowerStats() when $default != null:
return $default(_that.followerCountsByGeoCountry,_that.followerCountsByStaffCountRange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyFollowerStats extends CompanyFollowerStats {
  const _CompanyFollowerStats({final  List<GeoFollowerBucket> followerCountsByGeoCountry = const <GeoFollowerBucket>[], final  List<StaffCountBucket> followerCountsByStaffCountRange = const <StaffCountBucket>[]}): _followerCountsByGeoCountry = followerCountsByGeoCountry,_followerCountsByStaffCountRange = followerCountsByStaffCountRange,super._();
  factory _CompanyFollowerStats.fromJson(Map<String, dynamic> json) => _$CompanyFollowerStatsFromJson(json);

 final  List<GeoFollowerBucket> _followerCountsByGeoCountry;
@override@JsonKey() List<GeoFollowerBucket> get followerCountsByGeoCountry {
  if (_followerCountsByGeoCountry is EqualUnmodifiableListView) return _followerCountsByGeoCountry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followerCountsByGeoCountry);
}

 final  List<StaffCountBucket> _followerCountsByStaffCountRange;
@override@JsonKey() List<StaffCountBucket> get followerCountsByStaffCountRange {
  if (_followerCountsByStaffCountRange is EqualUnmodifiableListView) return _followerCountsByStaffCountRange;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followerCountsByStaffCountRange);
}


/// Create a copy of CompanyFollowerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyFollowerStatsCopyWith<_CompanyFollowerStats> get copyWith => __$CompanyFollowerStatsCopyWithImpl<_CompanyFollowerStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyFollowerStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyFollowerStats&&const DeepCollectionEquality().equals(other._followerCountsByGeoCountry, _followerCountsByGeoCountry)&&const DeepCollectionEquality().equals(other._followerCountsByStaffCountRange, _followerCountsByStaffCountRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_followerCountsByGeoCountry),const DeepCollectionEquality().hash(_followerCountsByStaffCountRange));

@override
String toString() {
  return 'CompanyFollowerStats(followerCountsByGeoCountry: $followerCountsByGeoCountry, followerCountsByStaffCountRange: $followerCountsByStaffCountRange)';
}


}

/// @nodoc
abstract mixin class _$CompanyFollowerStatsCopyWith<$Res> implements $CompanyFollowerStatsCopyWith<$Res> {
  factory _$CompanyFollowerStatsCopyWith(_CompanyFollowerStats value, $Res Function(_CompanyFollowerStats) _then) = __$CompanyFollowerStatsCopyWithImpl;
@override @useResult
$Res call({
 List<GeoFollowerBucket> followerCountsByGeoCountry, List<StaffCountBucket> followerCountsByStaffCountRange
});




}
/// @nodoc
class __$CompanyFollowerStatsCopyWithImpl<$Res>
    implements _$CompanyFollowerStatsCopyWith<$Res> {
  __$CompanyFollowerStatsCopyWithImpl(this._self, this._then);

  final _CompanyFollowerStats _self;
  final $Res Function(_CompanyFollowerStats) _then;

/// Create a copy of CompanyFollowerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followerCountsByGeoCountry = null,Object? followerCountsByStaffCountRange = null,}) {
  return _then(_CompanyFollowerStats(
followerCountsByGeoCountry: null == followerCountsByGeoCountry ? _self._followerCountsByGeoCountry : followerCountsByGeoCountry // ignore: cast_nullable_to_non_nullable
as List<GeoFollowerBucket>,followerCountsByStaffCountRange: null == followerCountsByStaffCountRange ? _self._followerCountsByStaffCountRange : followerCountsByStaffCountRange // ignore: cast_nullable_to_non_nullable
as List<StaffCountBucket>,
  ));
}


}


/// @nodoc
mixin _$CompanyAnalytics {

 String? get orgId; CompanyFollowerStats? get followers; CompanyPageStats? get pageStats; String? get timestamp;
/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyAnalyticsCopyWith<CompanyAnalytics> get copyWith => _$CompanyAnalyticsCopyWithImpl<CompanyAnalytics>(this as CompanyAnalytics, _$identity);

  /// Serializes this CompanyAnalytics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyAnalytics&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.pageStats, pageStats) || other.pageStats == pageStats)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orgId,followers,pageStats,timestamp);

@override
String toString() {
  return 'CompanyAnalytics(orgId: $orgId, followers: $followers, pageStats: $pageStats, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $CompanyAnalyticsCopyWith<$Res>  {
  factory $CompanyAnalyticsCopyWith(CompanyAnalytics value, $Res Function(CompanyAnalytics) _then) = _$CompanyAnalyticsCopyWithImpl;
@useResult
$Res call({
 String? orgId, CompanyFollowerStats? followers, CompanyPageStats? pageStats, String? timestamp
});


$CompanyFollowerStatsCopyWith<$Res>? get followers;$CompanyPageStatsCopyWith<$Res>? get pageStats;

}
/// @nodoc
class _$CompanyAnalyticsCopyWithImpl<$Res>
    implements $CompanyAnalyticsCopyWith<$Res> {
  _$CompanyAnalyticsCopyWithImpl(this._self, this._then);

  final CompanyAnalytics _self;
  final $Res Function(CompanyAnalytics) _then;

/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orgId = freezed,Object? followers = freezed,Object? pageStats = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
orgId: freezed == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String?,followers: freezed == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as CompanyFollowerStats?,pageStats: freezed == pageStats ? _self.pageStats : pageStats // ignore: cast_nullable_to_non_nullable
as CompanyPageStats?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyFollowerStatsCopyWith<$Res>? get followers {
    if (_self.followers == null) {
    return null;
  }

  return $CompanyFollowerStatsCopyWith<$Res>(_self.followers!, (value) {
    return _then(_self.copyWith(followers: value));
  });
}/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyPageStatsCopyWith<$Res>? get pageStats {
    if (_self.pageStats == null) {
    return null;
  }

  return $CompanyPageStatsCopyWith<$Res>(_self.pageStats!, (value) {
    return _then(_self.copyWith(pageStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompanyAnalytics].
extension CompanyAnalyticsPatterns on CompanyAnalytics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyAnalytics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyAnalytics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyAnalytics value)  $default,){
final _that = this;
switch (_that) {
case _CompanyAnalytics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyAnalytics value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyAnalytics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? orgId,  CompanyFollowerStats? followers,  CompanyPageStats? pageStats,  String? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyAnalytics() when $default != null:
return $default(_that.orgId,_that.followers,_that.pageStats,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? orgId,  CompanyFollowerStats? followers,  CompanyPageStats? pageStats,  String? timestamp)  $default,) {final _that = this;
switch (_that) {
case _CompanyAnalytics():
return $default(_that.orgId,_that.followers,_that.pageStats,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? orgId,  CompanyFollowerStats? followers,  CompanyPageStats? pageStats,  String? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _CompanyAnalytics() when $default != null:
return $default(_that.orgId,_that.followers,_that.pageStats,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyAnalytics extends CompanyAnalytics {
  const _CompanyAnalytics({this.orgId, this.followers, this.pageStats, this.timestamp}): super._();
  factory _CompanyAnalytics.fromJson(Map<String, dynamic> json) => _$CompanyAnalyticsFromJson(json);

@override final  String? orgId;
@override final  CompanyFollowerStats? followers;
@override final  CompanyPageStats? pageStats;
@override final  String? timestamp;

/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyAnalyticsCopyWith<_CompanyAnalytics> get copyWith => __$CompanyAnalyticsCopyWithImpl<_CompanyAnalytics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyAnalyticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyAnalytics&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.pageStats, pageStats) || other.pageStats == pageStats)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,orgId,followers,pageStats,timestamp);

@override
String toString() {
  return 'CompanyAnalytics(orgId: $orgId, followers: $followers, pageStats: $pageStats, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$CompanyAnalyticsCopyWith<$Res> implements $CompanyAnalyticsCopyWith<$Res> {
  factory _$CompanyAnalyticsCopyWith(_CompanyAnalytics value, $Res Function(_CompanyAnalytics) _then) = __$CompanyAnalyticsCopyWithImpl;
@override @useResult
$Res call({
 String? orgId, CompanyFollowerStats? followers, CompanyPageStats? pageStats, String? timestamp
});


@override $CompanyFollowerStatsCopyWith<$Res>? get followers;@override $CompanyPageStatsCopyWith<$Res>? get pageStats;

}
/// @nodoc
class __$CompanyAnalyticsCopyWithImpl<$Res>
    implements _$CompanyAnalyticsCopyWith<$Res> {
  __$CompanyAnalyticsCopyWithImpl(this._self, this._then);

  final _CompanyAnalytics _self;
  final $Res Function(_CompanyAnalytics) _then;

/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orgId = freezed,Object? followers = freezed,Object? pageStats = freezed,Object? timestamp = freezed,}) {
  return _then(_CompanyAnalytics(
orgId: freezed == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String?,followers: freezed == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as CompanyFollowerStats?,pageStats: freezed == pageStats ? _self.pageStats : pageStats // ignore: cast_nullable_to_non_nullable
as CompanyPageStats?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyFollowerStatsCopyWith<$Res>? get followers {
    if (_self.followers == null) {
    return null;
  }

  return $CompanyFollowerStatsCopyWith<$Res>(_self.followers!, (value) {
    return _then(_self.copyWith(followers: value));
  });
}/// Create a copy of CompanyAnalytics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyPageStatsCopyWith<$Res>? get pageStats {
    if (_self.pageStats == null) {
    return null;
  }

  return $CompanyPageStatsCopyWith<$Res>(_self.pageStats!, (value) {
    return _then(_self.copyWith(pageStats: value));
  });
}
}

// dart format on
