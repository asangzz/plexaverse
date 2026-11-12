// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectionReading {

 int get count;/// ISO 8601, as the server stored it.
 String get measuredAt;
/// Create a copy of ConnectionReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionReadingCopyWith<ConnectionReading> get copyWith => _$ConnectionReadingCopyWithImpl<ConnectionReading>(this as ConnectionReading, _$identity);

  /// Serializes this ConnectionReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionReading&&(identical(other.count, count) || other.count == count)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,measuredAt);

@override
String toString() {
  return 'ConnectionReading(count: $count, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class $ConnectionReadingCopyWith<$Res>  {
  factory $ConnectionReadingCopyWith(ConnectionReading value, $Res Function(ConnectionReading) _then) = _$ConnectionReadingCopyWithImpl;
@useResult
$Res call({
 int count, String measuredAt
});




}
/// @nodoc
class _$ConnectionReadingCopyWithImpl<$Res>
    implements $ConnectionReadingCopyWith<$Res> {
  _$ConnectionReadingCopyWithImpl(this._self, this._then);

  final ConnectionReading _self;
  final $Res Function(ConnectionReading) _then;

/// Create a copy of ConnectionReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? measuredAt = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionReading].
extension ConnectionReadingPatterns on ConnectionReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionReading value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionReading value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String measuredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionReading() when $default != null:
return $default(_that.count,_that.measuredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String measuredAt)  $default,) {final _that = this;
switch (_that) {
case _ConnectionReading():
return $default(_that.count,_that.measuredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String measuredAt)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionReading() when $default != null:
return $default(_that.count,_that.measuredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectionReading extends ConnectionReading {
  const _ConnectionReading({this.count = 0, this.measuredAt = ''}): super._();
  factory _ConnectionReading.fromJson(Map<String, dynamic> json) => _$ConnectionReadingFromJson(json);

@override@JsonKey() final  int count;
/// ISO 8601, as the server stored it.
@override@JsonKey() final  String measuredAt;

/// Create a copy of ConnectionReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionReadingCopyWith<_ConnectionReading> get copyWith => __$ConnectionReadingCopyWithImpl<_ConnectionReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectionReadingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionReading&&(identical(other.count, count) || other.count == count)&&(identical(other.measuredAt, measuredAt) || other.measuredAt == measuredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,measuredAt);

@override
String toString() {
  return 'ConnectionReading(count: $count, measuredAt: $measuredAt)';
}


}

/// @nodoc
abstract mixin class _$ConnectionReadingCopyWith<$Res> implements $ConnectionReadingCopyWith<$Res> {
  factory _$ConnectionReadingCopyWith(_ConnectionReading value, $Res Function(_ConnectionReading) _then) = __$ConnectionReadingCopyWithImpl;
@override @useResult
$Res call({
 int count, String measuredAt
});




}
/// @nodoc
class __$ConnectionReadingCopyWithImpl<$Res>
    implements _$ConnectionReadingCopyWith<$Res> {
  __$ConnectionReadingCopyWithImpl(this._self, this._then);

  final _ConnectionReading _self;
  final $Res Function(_ConnectionReading) _then;

/// Create a copy of ConnectionReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? measuredAt = null,}) {
  return _then(_ConnectionReading(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,measuredAt: null == measuredAt ? _self.measuredAt : measuredAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConnectionGrowth {

/// Latest minus the latest reading at or before seven days ago — or minus
/// the first reading when none is that old yet.
///
/// Null when the latest reading is itself a week old or more: nothing was
/// measured this week, so any figure here would be older movement (or a
/// false "no change") labelled as this week's.
 int? get week;/// Latest minus the first reading ever recorded.
 int get sinceFirst;/// When the first reading was true, ISO 8601.
 String get firstMeasuredAt;/// Whole days between the first and the latest reading.
 int get daysCovered;/// How many readings the figures come from. One means there is no growth
/// to speak of yet.
 int get readings;
/// Create a copy of ConnectionGrowth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionGrowthCopyWith<ConnectionGrowth> get copyWith => _$ConnectionGrowthCopyWithImpl<ConnectionGrowth>(this as ConnectionGrowth, _$identity);

  /// Serializes this ConnectionGrowth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionGrowth&&(identical(other.week, week) || other.week == week)&&(identical(other.sinceFirst, sinceFirst) || other.sinceFirst == sinceFirst)&&(identical(other.firstMeasuredAt, firstMeasuredAt) || other.firstMeasuredAt == firstMeasuredAt)&&(identical(other.daysCovered, daysCovered) || other.daysCovered == daysCovered)&&(identical(other.readings, readings) || other.readings == readings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,sinceFirst,firstMeasuredAt,daysCovered,readings);

@override
String toString() {
  return 'ConnectionGrowth(week: $week, sinceFirst: $sinceFirst, firstMeasuredAt: $firstMeasuredAt, daysCovered: $daysCovered, readings: $readings)';
}


}

/// @nodoc
abstract mixin class $ConnectionGrowthCopyWith<$Res>  {
  factory $ConnectionGrowthCopyWith(ConnectionGrowth value, $Res Function(ConnectionGrowth) _then) = _$ConnectionGrowthCopyWithImpl;
@useResult
$Res call({
 int? week, int sinceFirst, String firstMeasuredAt, int daysCovered, int readings
});




}
/// @nodoc
class _$ConnectionGrowthCopyWithImpl<$Res>
    implements $ConnectionGrowthCopyWith<$Res> {
  _$ConnectionGrowthCopyWithImpl(this._self, this._then);

  final ConnectionGrowth _self;
  final $Res Function(ConnectionGrowth) _then;

/// Create a copy of ConnectionGrowth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? week = freezed,Object? sinceFirst = null,Object? firstMeasuredAt = null,Object? daysCovered = null,Object? readings = null,}) {
  return _then(_self.copyWith(
week: freezed == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int?,sinceFirst: null == sinceFirst ? _self.sinceFirst : sinceFirst // ignore: cast_nullable_to_non_nullable
as int,firstMeasuredAt: null == firstMeasuredAt ? _self.firstMeasuredAt : firstMeasuredAt // ignore: cast_nullable_to_non_nullable
as String,daysCovered: null == daysCovered ? _self.daysCovered : daysCovered // ignore: cast_nullable_to_non_nullable
as int,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionGrowth].
extension ConnectionGrowthPatterns on ConnectionGrowth {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionGrowth value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionGrowth() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionGrowth value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionGrowth():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionGrowth value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionGrowth() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? week,  int sinceFirst,  String firstMeasuredAt,  int daysCovered,  int readings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionGrowth() when $default != null:
return $default(_that.week,_that.sinceFirst,_that.firstMeasuredAt,_that.daysCovered,_that.readings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? week,  int sinceFirst,  String firstMeasuredAt,  int daysCovered,  int readings)  $default,) {final _that = this;
switch (_that) {
case _ConnectionGrowth():
return $default(_that.week,_that.sinceFirst,_that.firstMeasuredAt,_that.daysCovered,_that.readings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? week,  int sinceFirst,  String firstMeasuredAt,  int daysCovered,  int readings)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionGrowth() when $default != null:
return $default(_that.week,_that.sinceFirst,_that.firstMeasuredAt,_that.daysCovered,_that.readings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectionGrowth implements ConnectionGrowth {
  const _ConnectionGrowth({this.week, this.sinceFirst = 0, this.firstMeasuredAt = '', this.daysCovered = 0, this.readings = 0});
  factory _ConnectionGrowth.fromJson(Map<String, dynamic> json) => _$ConnectionGrowthFromJson(json);

/// Latest minus the latest reading at or before seven days ago — or minus
/// the first reading when none is that old yet.
///
/// Null when the latest reading is itself a week old or more: nothing was
/// measured this week, so any figure here would be older movement (or a
/// false "no change") labelled as this week's.
@override final  int? week;
/// Latest minus the first reading ever recorded.
@override@JsonKey() final  int sinceFirst;
/// When the first reading was true, ISO 8601.
@override@JsonKey() final  String firstMeasuredAt;
/// Whole days between the first and the latest reading.
@override@JsonKey() final  int daysCovered;
/// How many readings the figures come from. One means there is no growth
/// to speak of yet.
@override@JsonKey() final  int readings;

/// Create a copy of ConnectionGrowth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionGrowthCopyWith<_ConnectionGrowth> get copyWith => __$ConnectionGrowthCopyWithImpl<_ConnectionGrowth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectionGrowthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionGrowth&&(identical(other.week, week) || other.week == week)&&(identical(other.sinceFirst, sinceFirst) || other.sinceFirst == sinceFirst)&&(identical(other.firstMeasuredAt, firstMeasuredAt) || other.firstMeasuredAt == firstMeasuredAt)&&(identical(other.daysCovered, daysCovered) || other.daysCovered == daysCovered)&&(identical(other.readings, readings) || other.readings == readings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,week,sinceFirst,firstMeasuredAt,daysCovered,readings);

@override
String toString() {
  return 'ConnectionGrowth(week: $week, sinceFirst: $sinceFirst, firstMeasuredAt: $firstMeasuredAt, daysCovered: $daysCovered, readings: $readings)';
}


}

/// @nodoc
abstract mixin class _$ConnectionGrowthCopyWith<$Res> implements $ConnectionGrowthCopyWith<$Res> {
  factory _$ConnectionGrowthCopyWith(_ConnectionGrowth value, $Res Function(_ConnectionGrowth) _then) = __$ConnectionGrowthCopyWithImpl;
@override @useResult
$Res call({
 int? week, int sinceFirst, String firstMeasuredAt, int daysCovered, int readings
});




}
/// @nodoc
class __$ConnectionGrowthCopyWithImpl<$Res>
    implements _$ConnectionGrowthCopyWith<$Res> {
  __$ConnectionGrowthCopyWithImpl(this._self, this._then);

  final _ConnectionGrowth _self;
  final $Res Function(_ConnectionGrowth) _then;

/// Create a copy of ConnectionGrowth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? week = freezed,Object? sinceFirst = null,Object? firstMeasuredAt = null,Object? daysCovered = null,Object? readings = null,}) {
  return _then(_ConnectionGrowth(
week: freezed == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as int?,sinceFirst: null == sinceFirst ? _self.sinceFirst : sinceFirst // ignore: cast_nullable_to_non_nullable
as int,firstMeasuredAt: null == firstMeasuredAt ? _self.firstMeasuredAt : firstMeasuredAt // ignore: cast_nullable_to_non_nullable
as String,daysCovered: null == daysCovered ? _self.daysCovered : daysCovered // ignore: cast_nullable_to_non_nullable
as int,readings: null == readings ? _self.readings : readings // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ConnectionSummary {

/// Null until the first count is saved.
 ConnectionReading? get reading;/// Null with no readings.
 ConnectionGrowth? get growth;/// Oldest first.
 List<ConnectionReading> get history;
/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionSummaryCopyWith<ConnectionSummary> get copyWith => _$ConnectionSummaryCopyWithImpl<ConnectionSummary>(this as ConnectionSummary, _$identity);

  /// Serializes this ConnectionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionSummary&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.growth, growth) || other.growth == growth)&&const DeepCollectionEquality().equals(other.history, history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reading,growth,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'ConnectionSummary(reading: $reading, growth: $growth, history: $history)';
}


}

/// @nodoc
abstract mixin class $ConnectionSummaryCopyWith<$Res>  {
  factory $ConnectionSummaryCopyWith(ConnectionSummary value, $Res Function(ConnectionSummary) _then) = _$ConnectionSummaryCopyWithImpl;
@useResult
$Res call({
 ConnectionReading? reading, ConnectionGrowth? growth, List<ConnectionReading> history
});


$ConnectionReadingCopyWith<$Res>? get reading;$ConnectionGrowthCopyWith<$Res>? get growth;

}
/// @nodoc
class _$ConnectionSummaryCopyWithImpl<$Res>
    implements $ConnectionSummaryCopyWith<$Res> {
  _$ConnectionSummaryCopyWithImpl(this._self, this._then);

  final ConnectionSummary _self;
  final $Res Function(ConnectionSummary) _then;

/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reading = freezed,Object? growth = freezed,Object? history = null,}) {
  return _then(_self.copyWith(
reading: freezed == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as ConnectionReading?,growth: freezed == growth ? _self.growth : growth // ignore: cast_nullable_to_non_nullable
as ConnectionGrowth?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ConnectionReading>,
  ));
}
/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConnectionReadingCopyWith<$Res>? get reading {
    if (_self.reading == null) {
    return null;
  }

  return $ConnectionReadingCopyWith<$Res>(_self.reading!, (value) {
    return _then(_self.copyWith(reading: value));
  });
}/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConnectionGrowthCopyWith<$Res>? get growth {
    if (_self.growth == null) {
    return null;
  }

  return $ConnectionGrowthCopyWith<$Res>(_self.growth!, (value) {
    return _then(_self.copyWith(growth: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConnectionSummary].
extension ConnectionSummaryPatterns on ConnectionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionSummary value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConnectionReading? reading,  ConnectionGrowth? growth,  List<ConnectionReading> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionSummary() when $default != null:
return $default(_that.reading,_that.growth,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConnectionReading? reading,  ConnectionGrowth? growth,  List<ConnectionReading> history)  $default,) {final _that = this;
switch (_that) {
case _ConnectionSummary():
return $default(_that.reading,_that.growth,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConnectionReading? reading,  ConnectionGrowth? growth,  List<ConnectionReading> history)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionSummary() when $default != null:
return $default(_that.reading,_that.growth,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectionSummary implements ConnectionSummary {
  const _ConnectionSummary({this.reading, this.growth, final  List<ConnectionReading> history = const <ConnectionReading>[]}): _history = history;
  factory _ConnectionSummary.fromJson(Map<String, dynamic> json) => _$ConnectionSummaryFromJson(json);

/// Null until the first count is saved.
@override final  ConnectionReading? reading;
/// Null with no readings.
@override final  ConnectionGrowth? growth;
/// Oldest first.
 final  List<ConnectionReading> _history;
/// Oldest first.
@override@JsonKey() List<ConnectionReading> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionSummaryCopyWith<_ConnectionSummary> get copyWith => __$ConnectionSummaryCopyWithImpl<_ConnectionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionSummary&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.growth, growth) || other.growth == growth)&&const DeepCollectionEquality().equals(other._history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reading,growth,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'ConnectionSummary(reading: $reading, growth: $growth, history: $history)';
}


}

/// @nodoc
abstract mixin class _$ConnectionSummaryCopyWith<$Res> implements $ConnectionSummaryCopyWith<$Res> {
  factory _$ConnectionSummaryCopyWith(_ConnectionSummary value, $Res Function(_ConnectionSummary) _then) = __$ConnectionSummaryCopyWithImpl;
@override @useResult
$Res call({
 ConnectionReading? reading, ConnectionGrowth? growth, List<ConnectionReading> history
});


@override $ConnectionReadingCopyWith<$Res>? get reading;@override $ConnectionGrowthCopyWith<$Res>? get growth;

}
/// @nodoc
class __$ConnectionSummaryCopyWithImpl<$Res>
    implements _$ConnectionSummaryCopyWith<$Res> {
  __$ConnectionSummaryCopyWithImpl(this._self, this._then);

  final _ConnectionSummary _self;
  final $Res Function(_ConnectionSummary) _then;

/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reading = freezed,Object? growth = freezed,Object? history = null,}) {
  return _then(_ConnectionSummary(
reading: freezed == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as ConnectionReading?,growth: freezed == growth ? _self.growth : growth // ignore: cast_nullable_to_non_nullable
as ConnectionGrowth?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ConnectionReading>,
  ));
}

/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConnectionReadingCopyWith<$Res>? get reading {
    if (_self.reading == null) {
    return null;
  }

  return $ConnectionReadingCopyWith<$Res>(_self.reading!, (value) {
    return _then(_self.copyWith(reading: value));
  });
}/// Create a copy of ConnectionSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConnectionGrowthCopyWith<$Res>? get growth {
    if (_self.growth == null) {
    return null;
  }

  return $ConnectionGrowthCopyWith<$Res>(_self.growth!, (value) {
    return _then(_self.copyWith(growth: value));
  });
}
}

// dart format on
