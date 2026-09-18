// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompanyPostStats {

 int get impressionCount; int get clickCount; int get likeCount; int get commentCount; int get shareCount; double get engagement; double get engagementRate;
/// Create a copy of CompanyPostStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyPostStatsCopyWith<CompanyPostStats> get copyWith => _$CompanyPostStatsCopyWithImpl<CompanyPostStats>(this as CompanyPostStats, _$identity);

  /// Serializes this CompanyPostStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyPostStats&&(identical(other.impressionCount, impressionCount) || other.impressionCount == impressionCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.engagement, engagement) || other.engagement == engagement)&&(identical(other.engagementRate, engagementRate) || other.engagementRate == engagementRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressionCount,clickCount,likeCount,commentCount,shareCount,engagement,engagementRate);

@override
String toString() {
  return 'CompanyPostStats(impressionCount: $impressionCount, clickCount: $clickCount, likeCount: $likeCount, commentCount: $commentCount, shareCount: $shareCount, engagement: $engagement, engagementRate: $engagementRate)';
}


}

/// @nodoc
abstract mixin class $CompanyPostStatsCopyWith<$Res>  {
  factory $CompanyPostStatsCopyWith(CompanyPostStats value, $Res Function(CompanyPostStats) _then) = _$CompanyPostStatsCopyWithImpl;
@useResult
$Res call({
 int impressionCount, int clickCount, int likeCount, int commentCount, int shareCount, double engagement, double engagementRate
});




}
/// @nodoc
class _$CompanyPostStatsCopyWithImpl<$Res>
    implements $CompanyPostStatsCopyWith<$Res> {
  _$CompanyPostStatsCopyWithImpl(this._self, this._then);

  final CompanyPostStats _self;
  final $Res Function(CompanyPostStats) _then;

/// Create a copy of CompanyPostStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? impressionCount = null,Object? clickCount = null,Object? likeCount = null,Object? commentCount = null,Object? shareCount = null,Object? engagement = null,Object? engagementRate = null,}) {
  return _then(_self.copyWith(
impressionCount: null == impressionCount ? _self.impressionCount : impressionCount // ignore: cast_nullable_to_non_nullable
as int,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,engagement: null == engagement ? _self.engagement : engagement // ignore: cast_nullable_to_non_nullable
as double,engagementRate: null == engagementRate ? _self.engagementRate : engagementRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyPostStats].
extension CompanyPostStatsPatterns on CompanyPostStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyPostStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyPostStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyPostStats value)  $default,){
final _that = this;
switch (_that) {
case _CompanyPostStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyPostStats value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyPostStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int impressionCount,  int clickCount,  int likeCount,  int commentCount,  int shareCount,  double engagement,  double engagementRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyPostStats() when $default != null:
return $default(_that.impressionCount,_that.clickCount,_that.likeCount,_that.commentCount,_that.shareCount,_that.engagement,_that.engagementRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int impressionCount,  int clickCount,  int likeCount,  int commentCount,  int shareCount,  double engagement,  double engagementRate)  $default,) {final _that = this;
switch (_that) {
case _CompanyPostStats():
return $default(_that.impressionCount,_that.clickCount,_that.likeCount,_that.commentCount,_that.shareCount,_that.engagement,_that.engagementRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int impressionCount,  int clickCount,  int likeCount,  int commentCount,  int shareCount,  double engagement,  double engagementRate)?  $default,) {final _that = this;
switch (_that) {
case _CompanyPostStats() when $default != null:
return $default(_that.impressionCount,_that.clickCount,_that.likeCount,_that.commentCount,_that.shareCount,_that.engagement,_that.engagementRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyPostStats implements CompanyPostStats {
  const _CompanyPostStats({this.impressionCount = 0, this.clickCount = 0, this.likeCount = 0, this.commentCount = 0, this.shareCount = 0, this.engagement = 0, this.engagementRate = 0});
  factory _CompanyPostStats.fromJson(Map<String, dynamic> json) => _$CompanyPostStatsFromJson(json);

@override@JsonKey() final  int impressionCount;
@override@JsonKey() final  int clickCount;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int commentCount;
@override@JsonKey() final  int shareCount;
@override@JsonKey() final  double engagement;
@override@JsonKey() final  double engagementRate;

/// Create a copy of CompanyPostStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyPostStatsCopyWith<_CompanyPostStats> get copyWith => __$CompanyPostStatsCopyWithImpl<_CompanyPostStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyPostStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyPostStats&&(identical(other.impressionCount, impressionCount) || other.impressionCount == impressionCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.shareCount, shareCount) || other.shareCount == shareCount)&&(identical(other.engagement, engagement) || other.engagement == engagement)&&(identical(other.engagementRate, engagementRate) || other.engagementRate == engagementRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressionCount,clickCount,likeCount,commentCount,shareCount,engagement,engagementRate);

@override
String toString() {
  return 'CompanyPostStats(impressionCount: $impressionCount, clickCount: $clickCount, likeCount: $likeCount, commentCount: $commentCount, shareCount: $shareCount, engagement: $engagement, engagementRate: $engagementRate)';
}


}

/// @nodoc
abstract mixin class _$CompanyPostStatsCopyWith<$Res> implements $CompanyPostStatsCopyWith<$Res> {
  factory _$CompanyPostStatsCopyWith(_CompanyPostStats value, $Res Function(_CompanyPostStats) _then) = __$CompanyPostStatsCopyWithImpl;
@override @useResult
$Res call({
 int impressionCount, int clickCount, int likeCount, int commentCount, int shareCount, double engagement, double engagementRate
});




}
/// @nodoc
class __$CompanyPostStatsCopyWithImpl<$Res>
    implements _$CompanyPostStatsCopyWith<$Res> {
  __$CompanyPostStatsCopyWithImpl(this._self, this._then);

  final _CompanyPostStats _self;
  final $Res Function(_CompanyPostStats) _then;

/// Create a copy of CompanyPostStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? impressionCount = null,Object? clickCount = null,Object? likeCount = null,Object? commentCount = null,Object? shareCount = null,Object? engagement = null,Object? engagementRate = null,}) {
  return _then(_CompanyPostStats(
impressionCount: null == impressionCount ? _self.impressionCount : impressionCount // ignore: cast_nullable_to_non_nullable
as int,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,shareCount: null == shareCount ? _self.shareCount : shareCount // ignore: cast_nullable_to_non_nullable
as int,engagement: null == engagement ? _self.engagement : engagement // ignore: cast_nullable_to_non_nullable
as double,engagementRate: null == engagementRate ? _self.engagementRate : engagementRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CompanyPostItem {

 String get id; String get text;/// Epoch milliseconds. LinkedIn sends a number; the field is absent on
/// posts whose `createdAt` was not a number, which is why it is nullable.
 int? get createdAt; bool get isAdvocated; String? get advocacyExpiry; CompanyPostStats get stats;
/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyPostItemCopyWith<CompanyPostItem> get copyWith => _$CompanyPostItemCopyWithImpl<CompanyPostItem>(this as CompanyPostItem, _$identity);

  /// Serializes this CompanyPostItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyPostItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isAdvocated, isAdvocated) || other.isAdvocated == isAdvocated)&&(identical(other.advocacyExpiry, advocacyExpiry) || other.advocacyExpiry == advocacyExpiry)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,isAdvocated,advocacyExpiry,stats);

@override
String toString() {
  return 'CompanyPostItem(id: $id, text: $text, createdAt: $createdAt, isAdvocated: $isAdvocated, advocacyExpiry: $advocacyExpiry, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $CompanyPostItemCopyWith<$Res>  {
  factory $CompanyPostItemCopyWith(CompanyPostItem value, $Res Function(CompanyPostItem) _then) = _$CompanyPostItemCopyWithImpl;
@useResult
$Res call({
 String id, String text, int? createdAt, bool isAdvocated, String? advocacyExpiry, CompanyPostStats stats
});


$CompanyPostStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$CompanyPostItemCopyWithImpl<$Res>
    implements $CompanyPostItemCopyWith<$Res> {
  _$CompanyPostItemCopyWithImpl(this._self, this._then);

  final CompanyPostItem _self;
  final $Res Function(CompanyPostItem) _then;

/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? createdAt = freezed,Object? isAdvocated = null,Object? advocacyExpiry = freezed,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,isAdvocated: null == isAdvocated ? _self.isAdvocated : isAdvocated // ignore: cast_nullable_to_non_nullable
as bool,advocacyExpiry: freezed == advocacyExpiry ? _self.advocacyExpiry : advocacyExpiry // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as CompanyPostStats,
  ));
}
/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyPostStatsCopyWith<$Res> get stats {
  
  return $CompanyPostStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompanyPostItem].
extension CompanyPostItemPatterns on CompanyPostItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyPostItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyPostItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyPostItem value)  $default,){
final _that = this;
switch (_that) {
case _CompanyPostItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyPostItem value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyPostItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  int? createdAt,  bool isAdvocated,  String? advocacyExpiry,  CompanyPostStats stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyPostItem() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.isAdvocated,_that.advocacyExpiry,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  int? createdAt,  bool isAdvocated,  String? advocacyExpiry,  CompanyPostStats stats)  $default,) {final _that = this;
switch (_that) {
case _CompanyPostItem():
return $default(_that.id,_that.text,_that.createdAt,_that.isAdvocated,_that.advocacyExpiry,_that.stats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  int? createdAt,  bool isAdvocated,  String? advocacyExpiry,  CompanyPostStats stats)?  $default,) {final _that = this;
switch (_that) {
case _CompanyPostItem() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.isAdvocated,_that.advocacyExpiry,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyPostItem extends CompanyPostItem {
  const _CompanyPostItem({required this.id, this.text = '', this.createdAt, this.isAdvocated = false, this.advocacyExpiry, this.stats = const CompanyPostStats()}): super._();
  factory _CompanyPostItem.fromJson(Map<String, dynamic> json) => _$CompanyPostItemFromJson(json);

@override final  String id;
@override@JsonKey() final  String text;
/// Epoch milliseconds. LinkedIn sends a number; the field is absent on
/// posts whose `createdAt` was not a number, which is why it is nullable.
@override final  int? createdAt;
@override@JsonKey() final  bool isAdvocated;
@override final  String? advocacyExpiry;
@override@JsonKey() final  CompanyPostStats stats;

/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyPostItemCopyWith<_CompanyPostItem> get copyWith => __$CompanyPostItemCopyWithImpl<_CompanyPostItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyPostItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyPostItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isAdvocated, isAdvocated) || other.isAdvocated == isAdvocated)&&(identical(other.advocacyExpiry, advocacyExpiry) || other.advocacyExpiry == advocacyExpiry)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,isAdvocated,advocacyExpiry,stats);

@override
String toString() {
  return 'CompanyPostItem(id: $id, text: $text, createdAt: $createdAt, isAdvocated: $isAdvocated, advocacyExpiry: $advocacyExpiry, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$CompanyPostItemCopyWith<$Res> implements $CompanyPostItemCopyWith<$Res> {
  factory _$CompanyPostItemCopyWith(_CompanyPostItem value, $Res Function(_CompanyPostItem) _then) = __$CompanyPostItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, int? createdAt, bool isAdvocated, String? advocacyExpiry, CompanyPostStats stats
});


@override $CompanyPostStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$CompanyPostItemCopyWithImpl<$Res>
    implements _$CompanyPostItemCopyWith<$Res> {
  __$CompanyPostItemCopyWithImpl(this._self, this._then);

  final _CompanyPostItem _self;
  final $Res Function(_CompanyPostItem) _then;

/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? createdAt = freezed,Object? isAdvocated = null,Object? advocacyExpiry = freezed,Object? stats = null,}) {
  return _then(_CompanyPostItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,isAdvocated: null == isAdvocated ? _self.isAdvocated : isAdvocated // ignore: cast_nullable_to_non_nullable
as bool,advocacyExpiry: freezed == advocacyExpiry ? _self.advocacyExpiry : advocacyExpiry // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as CompanyPostStats,
  ));
}

/// Create a copy of CompanyPostItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyPostStatsCopyWith<$Res> get stats {
  
  return $CompanyPostStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
