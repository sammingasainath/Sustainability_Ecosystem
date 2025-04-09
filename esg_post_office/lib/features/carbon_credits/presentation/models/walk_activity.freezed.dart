// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalkActivity _$WalkActivityFromJson(Map<String, dynamic> json) {
  return _WalkActivity.fromJson(json);
}

/// @nodoc
mixin _$WalkActivity {
  int get steps => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  double get carbonCredits => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalkActivityCopyWith<WalkActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalkActivityCopyWith<$Res> {
  factory $WalkActivityCopyWith(
          WalkActivity value, $Res Function(WalkActivity) then) =
      _$WalkActivityCopyWithImpl<$Res, WalkActivity>;
  @useResult
  $Res call(
      {int steps,
      double distance,
      double carbonCredits,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class _$WalkActivityCopyWithImpl<$Res, $Val extends WalkActivity>
    implements $WalkActivityCopyWith<$Res> {
  _$WalkActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? distance = null,
    Object? carbonCredits = null,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_value.copyWith(
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      carbonCredits: null == carbonCredits
          ? _value.carbonCredits
          : carbonCredits // ignore: cast_nullable_to_non_nullable
              as double,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalkActivityImplCopyWith<$Res>
    implements $WalkActivityCopyWith<$Res> {
  factory _$$WalkActivityImplCopyWith(
          _$WalkActivityImpl value, $Res Function(_$WalkActivityImpl) then) =
      __$$WalkActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int steps,
      double distance,
      double carbonCredits,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class __$$WalkActivityImplCopyWithImpl<$Res>
    extends _$WalkActivityCopyWithImpl<$Res, _$WalkActivityImpl>
    implements _$$WalkActivityImplCopyWith<$Res> {
  __$$WalkActivityImplCopyWithImpl(
      _$WalkActivityImpl _value, $Res Function(_$WalkActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? steps = null,
    Object? distance = null,
    Object? carbonCredits = null,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_$WalkActivityImpl(
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      carbonCredits: null == carbonCredits
          ? _value.carbonCredits
          : carbonCredits // ignore: cast_nullable_to_non_nullable
              as double,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalkActivityImpl implements _WalkActivity {
  const _$WalkActivityImpl(
      {required this.steps,
      required this.distance,
      required this.carbonCredits,
      required this.startTime,
      required this.endTime});

  factory _$WalkActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalkActivityImplFromJson(json);

  @override
  final int steps;
  @override
  final double distance;
  @override
  final double carbonCredits;
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'WalkActivity(steps: $steps, distance: $distance, carbonCredits: $carbonCredits, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalkActivityImpl &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.carbonCredits, carbonCredits) ||
                other.carbonCredits == carbonCredits) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, steps, distance, carbonCredits, startTime, endTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalkActivityImplCopyWith<_$WalkActivityImpl> get copyWith =>
      __$$WalkActivityImplCopyWithImpl<_$WalkActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalkActivityImplToJson(
      this,
    );
  }
}

abstract class _WalkActivity implements WalkActivity {
  const factory _WalkActivity(
      {required final int steps,
      required final double distance,
      required final double carbonCredits,
      required final DateTime startTime,
      required final DateTime? endTime}) = _$WalkActivityImpl;

  factory _WalkActivity.fromJson(Map<String, dynamic> json) =
      _$WalkActivityImpl.fromJson;

  @override
  int get steps;
  @override
  double get distance;
  @override
  double get carbonCredits;
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  @JsonKey(ignore: true)
  _$$WalkActivityImplCopyWith<_$WalkActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
