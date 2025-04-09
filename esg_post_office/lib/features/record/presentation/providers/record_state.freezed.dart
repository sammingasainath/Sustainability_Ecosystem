// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BillState _$BillStateFromJson(Map<String, dynamic> json) {
  return _BillState.fromJson(json);
}

/// @nodoc
mixin _$BillState {
  bool get isProcessing => throw _privateConstructorUsedError;
  bool get isUploading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  Map<String, dynamic>? get billData => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BillStateCopyWith<BillState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillStateCopyWith<$Res> {
  factory $BillStateCopyWith(BillState value, $Res Function(BillState) then) =
      _$BillStateCopyWithImpl<$Res, BillState>;
  @useResult
  $Res call(
      {bool isProcessing,
      bool isUploading,
      bool isSubmitting,
      Map<String, dynamic>? billData,
      String? error});
}

/// @nodoc
class _$BillStateCopyWithImpl<$Res, $Val extends BillState>
    implements $BillStateCopyWith<$Res> {
  _$BillStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? isUploading = null,
    Object? isSubmitting = null,
    Object? billData = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      billData: freezed == billData
          ? _value.billData
          : billData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BillStateImplCopyWith<$Res>
    implements $BillStateCopyWith<$Res> {
  factory _$$BillStateImplCopyWith(
          _$BillStateImpl value, $Res Function(_$BillStateImpl) then) =
      __$$BillStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isProcessing,
      bool isUploading,
      bool isSubmitting,
      Map<String, dynamic>? billData,
      String? error});
}

/// @nodoc
class __$$BillStateImplCopyWithImpl<$Res>
    extends _$BillStateCopyWithImpl<$Res, _$BillStateImpl>
    implements _$$BillStateImplCopyWith<$Res> {
  __$$BillStateImplCopyWithImpl(
      _$BillStateImpl _value, $Res Function(_$BillStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? isUploading = null,
    Object? isSubmitting = null,
    Object? billData = freezed,
    Object? error = freezed,
  }) {
    return _then(_$BillStateImpl(
      isProcessing: null == isProcessing
          ? _value.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      billData: freezed == billData
          ? _value._billData
          : billData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BillStateImpl extends _BillState {
  const _$BillStateImpl(
      {this.isProcessing = false,
      this.isUploading = false,
      this.isSubmitting = false,
      final Map<String, dynamic>? billData = null,
      this.error = null})
      : _billData = billData,
        super._();

  factory _$BillStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  @JsonKey()
  final bool isUploading;
  @override
  @JsonKey()
  final bool isSubmitting;
  final Map<String, dynamic>? _billData;
  @override
  @JsonKey()
  Map<String, dynamic>? get billData {
    final value = _billData;
    if (value == null) return null;
    if (_billData is EqualUnmodifiableMapView) return _billData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final String? error;

  @override
  String toString() {
    return 'BillState(isProcessing: $isProcessing, isUploading: $isUploading, isSubmitting: $isSubmitting, billData: $billData, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillStateImpl &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            const DeepCollectionEquality().equals(other._billData, _billData) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isProcessing, isUploading,
      isSubmitting, const DeepCollectionEquality().hash(_billData), error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BillStateImplCopyWith<_$BillStateImpl> get copyWith =>
      __$$BillStateImplCopyWithImpl<_$BillStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillStateImplToJson(
      this,
    );
  }
}

abstract class _BillState extends BillState {
  const factory _BillState(
      {final bool isProcessing,
      final bool isUploading,
      final bool isSubmitting,
      final Map<String, dynamic>? billData,
      final String? error}) = _$BillStateImpl;
  const _BillState._() : super._();

  factory _BillState.fromJson(Map<String, dynamic> json) =
      _$BillStateImpl.fromJson;

  @override
  bool get isProcessing;
  @override
  bool get isUploading;
  @override
  bool get isSubmitting;
  @override
  Map<String, dynamic>? get billData;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$BillStateImplCopyWith<_$BillStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
