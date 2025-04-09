// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_to_json_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageToJsonState {
  bool get isLoading => throw _privateConstructorUsedError;
  ImageToJsonResult? get result => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImageToJsonStateCopyWith<ImageToJsonState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageToJsonStateCopyWith<$Res> {
  factory $ImageToJsonStateCopyWith(
          ImageToJsonState value, $Res Function(ImageToJsonState) then) =
      _$ImageToJsonStateCopyWithImpl<$Res, ImageToJsonState>;
  @useResult
  $Res call({bool isLoading, ImageToJsonResult? result, String? error});

  $ImageToJsonResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$ImageToJsonStateCopyWithImpl<$Res, $Val extends ImageToJsonState>
    implements $ImageToJsonStateCopyWith<$Res> {
  _$ImageToJsonStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? result = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageToJsonResult?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ImageToJsonResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $ImageToJsonResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ImageToJsonStateImplCopyWith<$Res>
    implements $ImageToJsonStateCopyWith<$Res> {
  factory _$$ImageToJsonStateImplCopyWith(_$ImageToJsonStateImpl value,
          $Res Function(_$ImageToJsonStateImpl) then) =
      __$$ImageToJsonStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, ImageToJsonResult? result, String? error});

  @override
  $ImageToJsonResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$ImageToJsonStateImplCopyWithImpl<$Res>
    extends _$ImageToJsonStateCopyWithImpl<$Res, _$ImageToJsonStateImpl>
    implements _$$ImageToJsonStateImplCopyWith<$Res> {
  __$$ImageToJsonStateImplCopyWithImpl(_$ImageToJsonStateImpl _value,
      $Res Function(_$ImageToJsonStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? result = freezed,
    Object? error = freezed,
  }) {
    return _then(_$ImageToJsonStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as ImageToJsonResult?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ImageToJsonStateImpl implements _ImageToJsonState {
  const _$ImageToJsonStateImpl(
      {this.isLoading = false, this.result = null, this.error = null});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final ImageToJsonResult? result;
  @override
  @JsonKey()
  final String? error;

  @override
  String toString() {
    return 'ImageToJsonState(isLoading: $isLoading, result: $result, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageToJsonStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, result, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageToJsonStateImplCopyWith<_$ImageToJsonStateImpl> get copyWith =>
      __$$ImageToJsonStateImplCopyWithImpl<_$ImageToJsonStateImpl>(
          this, _$identity);
}

abstract class _ImageToJsonState implements ImageToJsonState {
  const factory _ImageToJsonState(
      {final bool isLoading,
      final ImageToJsonResult? result,
      final String? error}) = _$ImageToJsonStateImpl;

  @override
  bool get isLoading;
  @override
  ImageToJsonResult? get result;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$ImageToJsonStateImplCopyWith<_$ImageToJsonStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
