// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'advocacy_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdvocacyAccount {

 String get profileName; String? get profileImage; String? get profileSlug;
/// Create a copy of AdvocacyAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvocacyAccountCopyWith<AdvocacyAccount> get copyWith => _$AdvocacyAccountCopyWithImpl<AdvocacyAccount>(this as AdvocacyAccount, _$identity);

  /// Serializes this AdvocacyAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvocacyAccount&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileName,profileImage,profileSlug);

@override
String toString() {
  return 'AdvocacyAccount(profileName: $profileName, profileImage: $profileImage, profileSlug: $profileSlug)';
}


}

/// @nodoc
abstract mixin class $AdvocacyAccountCopyWith<$Res>  {
  factory $AdvocacyAccountCopyWith(AdvocacyAccount value, $Res Function(AdvocacyAccount) _then) = _$AdvocacyAccountCopyWithImpl;
@useResult
$Res call({
 String profileName, String? profileImage, String? profileSlug
});




}
/// @nodoc
class _$AdvocacyAccountCopyWithImpl<$Res>
    implements $AdvocacyAccountCopyWith<$Res> {
  _$AdvocacyAccountCopyWithImpl(this._self, this._then);

  final AdvocacyAccount _self;
  final $Res Function(AdvocacyAccount) _then;

/// Create a copy of AdvocacyAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileName = null,Object? profileImage = freezed,Object? profileSlug = freezed,}) {
  return _then(_self.copyWith(
profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvocacyAccount].
extension AdvocacyAccountPatterns on AdvocacyAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvocacyAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvocacyAccount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvocacyAccount value)  $default,){
final _that = this;
switch (_that) {
case _AdvocacyAccount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvocacyAccount value)?  $default,){
final _that = this;
switch (_that) {
case _AdvocacyAccount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileName,  String? profileImage,  String? profileSlug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvocacyAccount() when $default != null:
return $default(_that.profileName,_that.profileImage,_that.profileSlug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileName,  String? profileImage,  String? profileSlug)  $default,) {final _that = this;
switch (_that) {
case _AdvocacyAccount():
return $default(_that.profileName,_that.profileImage,_that.profileSlug);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileName,  String? profileImage,  String? profileSlug)?  $default,) {final _that = this;
switch (_that) {
case _AdvocacyAccount() when $default != null:
return $default(_that.profileName,_that.profileImage,_that.profileSlug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdvocacyAccount implements AdvocacyAccount {
  const _AdvocacyAccount({this.profileName = '', this.profileImage, this.profileSlug});
  factory _AdvocacyAccount.fromJson(Map<String, dynamic> json) => _$AdvocacyAccountFromJson(json);

@override@JsonKey() final  String profileName;
@override final  String? profileImage;
@override final  String? profileSlug;

/// Create a copy of AdvocacyAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvocacyAccountCopyWith<_AdvocacyAccount> get copyWith => __$AdvocacyAccountCopyWithImpl<_AdvocacyAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdvocacyAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvocacyAccount&&(identical(other.profileName, profileName) || other.profileName == profileName)&&(identical(other.profileImage, profileImage) || other.profileImage == profileImage)&&(identical(other.profileSlug, profileSlug) || other.profileSlug == profileSlug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileName,profileImage,profileSlug);

@override
String toString() {
  return 'AdvocacyAccount(profileName: $profileName, profileImage: $profileImage, profileSlug: $profileSlug)';
}


}

/// @nodoc
abstract mixin class _$AdvocacyAccountCopyWith<$Res> implements $AdvocacyAccountCopyWith<$Res> {
  factory _$AdvocacyAccountCopyWith(_AdvocacyAccount value, $Res Function(_AdvocacyAccount) _then) = __$AdvocacyAccountCopyWithImpl;
@override @useResult
$Res call({
 String profileName, String? profileImage, String? profileSlug
});




}
/// @nodoc
class __$AdvocacyAccountCopyWithImpl<$Res>
    implements _$AdvocacyAccountCopyWith<$Res> {
  __$AdvocacyAccountCopyWithImpl(this._self, this._then);

  final _AdvocacyAccount _self;
  final $Res Function(_AdvocacyAccount) _then;

/// Create a copy of AdvocacyAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileName = null,Object? profileImage = freezed,Object? profileSlug = freezed,}) {
  return _then(_AdvocacyAccount(
profileName: null == profileName ? _self.profileName : profileName // ignore: cast_nullable_to_non_nullable
as String,profileImage: freezed == profileImage ? _self.profileImage : profileImage // ignore: cast_nullable_to_non_nullable
as String?,profileSlug: freezed == profileSlug ? _self.profileSlug : profileSlug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdvocacyMetrics {

 int get impressions; int get clicks; int get comments; int get shares; int get reactions;
/// Create a copy of AdvocacyMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvocacyMetricsCopyWith<AdvocacyMetrics> get copyWith => _$AdvocacyMetricsCopyWithImpl<AdvocacyMetrics>(this as AdvocacyMetrics, _$identity);

  /// Serializes this AdvocacyMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvocacyMetrics&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.clicks, clicks) || other.clicks == clicks)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.reactions, reactions) || other.reactions == reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressions,clicks,comments,shares,reactions);

@override
String toString() {
  return 'AdvocacyMetrics(impressions: $impressions, clicks: $clicks, comments: $comments, shares: $shares, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class $AdvocacyMetricsCopyWith<$Res>  {
  factory $AdvocacyMetricsCopyWith(AdvocacyMetrics value, $Res Function(AdvocacyMetrics) _then) = _$AdvocacyMetricsCopyWithImpl;
@useResult
$Res call({
 int impressions, int clicks, int comments, int shares, int reactions
});




}
/// @nodoc
class _$AdvocacyMetricsCopyWithImpl<$Res>
    implements $AdvocacyMetricsCopyWith<$Res> {
  _$AdvocacyMetricsCopyWithImpl(this._self, this._then);

  final AdvocacyMetrics _self;
  final $Res Function(AdvocacyMetrics) _then;

/// Create a copy of AdvocacyMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? impressions = null,Object? clicks = null,Object? comments = null,Object? shares = null,Object? reactions = null,}) {
  return _then(_self.copyWith(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvocacyMetrics].
extension AdvocacyMetricsPatterns on AdvocacyMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvocacyMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvocacyMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvocacyMetrics value)  $default,){
final _that = this;
switch (_that) {
case _AdvocacyMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvocacyMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _AdvocacyMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int impressions,  int clicks,  int comments,  int shares,  int reactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvocacyMetrics() when $default != null:
return $default(_that.impressions,_that.clicks,_that.comments,_that.shares,_that.reactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int impressions,  int clicks,  int comments,  int shares,  int reactions)  $default,) {final _that = this;
switch (_that) {
case _AdvocacyMetrics():
return $default(_that.impressions,_that.clicks,_that.comments,_that.shares,_that.reactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int impressions,  int clicks,  int comments,  int shares,  int reactions)?  $default,) {final _that = this;
switch (_that) {
case _AdvocacyMetrics() when $default != null:
return $default(_that.impressions,_that.clicks,_that.comments,_that.shares,_that.reactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdvocacyMetrics implements AdvocacyMetrics {
  const _AdvocacyMetrics({this.impressions = 0, this.clicks = 0, this.comments = 0, this.shares = 0, this.reactions = 0});
  factory _AdvocacyMetrics.fromJson(Map<String, dynamic> json) => _$AdvocacyMetricsFromJson(json);

@override@JsonKey() final  int impressions;
@override@JsonKey() final  int clicks;
@override@JsonKey() final  int comments;
@override@JsonKey() final  int shares;
@override@JsonKey() final  int reactions;

/// Create a copy of AdvocacyMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvocacyMetricsCopyWith<_AdvocacyMetrics> get copyWith => __$AdvocacyMetricsCopyWithImpl<_AdvocacyMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdvocacyMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvocacyMetrics&&(identical(other.impressions, impressions) || other.impressions == impressions)&&(identical(other.clicks, clicks) || other.clicks == clicks)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.shares, shares) || other.shares == shares)&&(identical(other.reactions, reactions) || other.reactions == reactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,impressions,clicks,comments,shares,reactions);

@override
String toString() {
  return 'AdvocacyMetrics(impressions: $impressions, clicks: $clicks, comments: $comments, shares: $shares, reactions: $reactions)';
}


}

/// @nodoc
abstract mixin class _$AdvocacyMetricsCopyWith<$Res> implements $AdvocacyMetricsCopyWith<$Res> {
  factory _$AdvocacyMetricsCopyWith(_AdvocacyMetrics value, $Res Function(_AdvocacyMetrics) _then) = __$AdvocacyMetricsCopyWithImpl;
@override @useResult
$Res call({
 int impressions, int clicks, int comments, int shares, int reactions
});




}
/// @nodoc
class __$AdvocacyMetricsCopyWithImpl<$Res>
    implements _$AdvocacyMetricsCopyWith<$Res> {
  __$AdvocacyMetricsCopyWithImpl(this._self, this._then);

  final _AdvocacyMetrics _self;
  final $Res Function(_AdvocacyMetrics) _then;

/// Create a copy of AdvocacyMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? impressions = null,Object? clicks = null,Object? comments = null,Object? shares = null,Object? reactions = null,}) {
  return _then(_AdvocacyMetrics(
impressions: null == impressions ? _self.impressions : impressions // ignore: cast_nullable_to_non_nullable
as int,clicks: null == clicks ? _self.clicks : clicks // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,shares: null == shares ? _self.shares : shares // ignore: cast_nullable_to_non_nullable
as int,reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AdvocacyPost {

 String get id; String get content;/// The LinkedIn URN. Resharing needs it, and a row without one cannot be
/// amplified — see [canReshare].
 String? get linkedinPostId; String? get linkedinUrl; String? get publishedAt; bool get isAdvocated; String? get advocacyExpiry; AdvocacyAccount? get account; AdvocacyMetrics? get metrics;
/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvocacyPostCopyWith<AdvocacyPost> get copyWith => _$AdvocacyPostCopyWithImpl<AdvocacyPost>(this as AdvocacyPost, _$identity);

  /// Serializes this AdvocacyPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvocacyPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.linkedinPostId, linkedinPostId) || other.linkedinPostId == linkedinPostId)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.isAdvocated, isAdvocated) || other.isAdvocated == isAdvocated)&&(identical(other.advocacyExpiry, advocacyExpiry) || other.advocacyExpiry == advocacyExpiry)&&(identical(other.account, account) || other.account == account)&&(identical(other.metrics, metrics) || other.metrics == metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,linkedinPostId,linkedinUrl,publishedAt,isAdvocated,advocacyExpiry,account,metrics);

@override
String toString() {
  return 'AdvocacyPost(id: $id, content: $content, linkedinPostId: $linkedinPostId, linkedinUrl: $linkedinUrl, publishedAt: $publishedAt, isAdvocated: $isAdvocated, advocacyExpiry: $advocacyExpiry, account: $account, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $AdvocacyPostCopyWith<$Res>  {
  factory $AdvocacyPostCopyWith(AdvocacyPost value, $Res Function(AdvocacyPost) _then) = _$AdvocacyPostCopyWithImpl;
@useResult
$Res call({
 String id, String content, String? linkedinPostId, String? linkedinUrl, String? publishedAt, bool isAdvocated, String? advocacyExpiry, AdvocacyAccount? account, AdvocacyMetrics? metrics
});


$AdvocacyAccountCopyWith<$Res>? get account;$AdvocacyMetricsCopyWith<$Res>? get metrics;

}
/// @nodoc
class _$AdvocacyPostCopyWithImpl<$Res>
    implements $AdvocacyPostCopyWith<$Res> {
  _$AdvocacyPostCopyWithImpl(this._self, this._then);

  final AdvocacyPost _self;
  final $Res Function(AdvocacyPost) _then;

/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? linkedinPostId = freezed,Object? linkedinUrl = freezed,Object? publishedAt = freezed,Object? isAdvocated = null,Object? advocacyExpiry = freezed,Object? account = freezed,Object? metrics = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,linkedinPostId: freezed == linkedinPostId ? _self.linkedinPostId : linkedinPostId // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,isAdvocated: null == isAdvocated ? _self.isAdvocated : isAdvocated // ignore: cast_nullable_to_non_nullable
as bool,advocacyExpiry: freezed == advocacyExpiry ? _self.advocacyExpiry : advocacyExpiry // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AdvocacyAccount?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as AdvocacyMetrics?,
  ));
}
/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvocacyAccountCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $AdvocacyAccountCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvocacyMetricsCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $AdvocacyMetricsCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdvocacyPost].
extension AdvocacyPostPatterns on AdvocacyPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvocacyPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvocacyPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvocacyPost value)  $default,){
final _that = this;
switch (_that) {
case _AdvocacyPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvocacyPost value)?  $default,){
final _that = this;
switch (_that) {
case _AdvocacyPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content,  String? linkedinPostId,  String? linkedinUrl,  String? publishedAt,  bool isAdvocated,  String? advocacyExpiry,  AdvocacyAccount? account,  AdvocacyMetrics? metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvocacyPost() when $default != null:
return $default(_that.id,_that.content,_that.linkedinPostId,_that.linkedinUrl,_that.publishedAt,_that.isAdvocated,_that.advocacyExpiry,_that.account,_that.metrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content,  String? linkedinPostId,  String? linkedinUrl,  String? publishedAt,  bool isAdvocated,  String? advocacyExpiry,  AdvocacyAccount? account,  AdvocacyMetrics? metrics)  $default,) {final _that = this;
switch (_that) {
case _AdvocacyPost():
return $default(_that.id,_that.content,_that.linkedinPostId,_that.linkedinUrl,_that.publishedAt,_that.isAdvocated,_that.advocacyExpiry,_that.account,_that.metrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content,  String? linkedinPostId,  String? linkedinUrl,  String? publishedAt,  bool isAdvocated,  String? advocacyExpiry,  AdvocacyAccount? account,  AdvocacyMetrics? metrics)?  $default,) {final _that = this;
switch (_that) {
case _AdvocacyPost() when $default != null:
return $default(_that.id,_that.content,_that.linkedinPostId,_that.linkedinUrl,_that.publishedAt,_that.isAdvocated,_that.advocacyExpiry,_that.account,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdvocacyPost extends AdvocacyPost {
  const _AdvocacyPost({required this.id, this.content = '', this.linkedinPostId, this.linkedinUrl, this.publishedAt, this.isAdvocated = false, this.advocacyExpiry, this.account, this.metrics}): super._();
  factory _AdvocacyPost.fromJson(Map<String, dynamic> json) => _$AdvocacyPostFromJson(json);

@override final  String id;
@override@JsonKey() final  String content;
/// The LinkedIn URN. Resharing needs it, and a row without one cannot be
/// amplified — see [canReshare].
@override final  String? linkedinPostId;
@override final  String? linkedinUrl;
@override final  String? publishedAt;
@override@JsonKey() final  bool isAdvocated;
@override final  String? advocacyExpiry;
@override final  AdvocacyAccount? account;
@override final  AdvocacyMetrics? metrics;

/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvocacyPostCopyWith<_AdvocacyPost> get copyWith => __$AdvocacyPostCopyWithImpl<_AdvocacyPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdvocacyPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvocacyPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.linkedinPostId, linkedinPostId) || other.linkedinPostId == linkedinPostId)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.isAdvocated, isAdvocated) || other.isAdvocated == isAdvocated)&&(identical(other.advocacyExpiry, advocacyExpiry) || other.advocacyExpiry == advocacyExpiry)&&(identical(other.account, account) || other.account == account)&&(identical(other.metrics, metrics) || other.metrics == metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,linkedinPostId,linkedinUrl,publishedAt,isAdvocated,advocacyExpiry,account,metrics);

@override
String toString() {
  return 'AdvocacyPost(id: $id, content: $content, linkedinPostId: $linkedinPostId, linkedinUrl: $linkedinUrl, publishedAt: $publishedAt, isAdvocated: $isAdvocated, advocacyExpiry: $advocacyExpiry, account: $account, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$AdvocacyPostCopyWith<$Res> implements $AdvocacyPostCopyWith<$Res> {
  factory _$AdvocacyPostCopyWith(_AdvocacyPost value, $Res Function(_AdvocacyPost) _then) = __$AdvocacyPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, String? linkedinPostId, String? linkedinUrl, String? publishedAt, bool isAdvocated, String? advocacyExpiry, AdvocacyAccount? account, AdvocacyMetrics? metrics
});


@override $AdvocacyAccountCopyWith<$Res>? get account;@override $AdvocacyMetricsCopyWith<$Res>? get metrics;

}
/// @nodoc
class __$AdvocacyPostCopyWithImpl<$Res>
    implements _$AdvocacyPostCopyWith<$Res> {
  __$AdvocacyPostCopyWithImpl(this._self, this._then);

  final _AdvocacyPost _self;
  final $Res Function(_AdvocacyPost) _then;

/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? linkedinPostId = freezed,Object? linkedinUrl = freezed,Object? publishedAt = freezed,Object? isAdvocated = null,Object? advocacyExpiry = freezed,Object? account = freezed,Object? metrics = freezed,}) {
  return _then(_AdvocacyPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,linkedinPostId: freezed == linkedinPostId ? _self.linkedinPostId : linkedinPostId // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as String?,isAdvocated: null == isAdvocated ? _self.isAdvocated : isAdvocated // ignore: cast_nullable_to_non_nullable
as bool,advocacyExpiry: freezed == advocacyExpiry ? _self.advocacyExpiry : advocacyExpiry // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AdvocacyAccount?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as AdvocacyMetrics?,
  ));
}

/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvocacyAccountCopyWith<$Res>? get account {
    if (_self.account == null) {
    return null;
  }

  return $AdvocacyAccountCopyWith<$Res>(_self.account!, (value) {
    return _then(_self.copyWith(account: value));
  });
}/// Create a copy of AdvocacyPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvocacyMetricsCopyWith<$Res>? get metrics {
    if (_self.metrics == null) {
    return null;
  }

  return $AdvocacyMetricsCopyWith<$Res>(_self.metrics!, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}

// dart format on
