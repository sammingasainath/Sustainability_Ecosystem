// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_to_json_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImageToJsonResult _$ImageToJsonResultFromJson(Map<String, dynamic> json) {
  return _ImageToJsonResult.fromJson(json);
}

/// @nodoc
mixin _$ImageToJsonResult {
  String get extractedText => throw _privateConstructorUsedError;
  Map<String, dynamic> get jsonResponse => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageToJsonResultCopyWith<ImageToJsonResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageToJsonResultCopyWith<$Res> {
  factory $ImageToJsonResultCopyWith(
          ImageToJsonResult value, $Res Function(ImageToJsonResult) then) =
      _$ImageToJsonResultCopyWithImpl<$Res, ImageToJsonResult>;
  @useResult
  $Res call({String extractedText, Map<String, dynamic> jsonResponse});
}

/// @nodoc
class _$ImageToJsonResultCopyWithImpl<$Res, $Val extends ImageToJsonResult>
    implements $ImageToJsonResultCopyWith<$Res> {
  _$ImageToJsonResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? extractedText = null,
    Object? jsonResponse = null,
  }) {
    return _then(_value.copyWith(
      extractedText: null == extractedText
          ? _value.extractedText
          : extractedText // ignore: cast_nullable_to_non_nullable
              as String,
      jsonResponse: null == jsonResponse
          ? _value.jsonResponse
          : jsonResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageToJsonResultImplCopyWith<$Res>
    implements $ImageToJsonResultCopyWith<$Res> {
  factory _$$ImageToJsonResultImplCopyWith(_$ImageToJsonResultImpl value,
          $Res Function(_$ImageToJsonResultImpl) then) =
      __$$ImageToJsonResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String extractedText, Map<String, dynamic> jsonResponse});
}

/// @nodoc
class __$$ImageToJsonResultImplCopyWithImpl<$Res>
    extends _$ImageToJsonResultCopyWithImpl<$Res, _$ImageToJsonResultImpl>
    implements _$$ImageToJsonResultImplCopyWith<$Res> {
  __$$ImageToJsonResultImplCopyWithImpl(_$ImageToJsonResultImpl _value,
      $Res Function(_$ImageToJsonResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? extractedText = null,
    Object? jsonResponse = null,
  }) {
    return _then(_$ImageToJsonResultImpl(
      extractedText: null == extractedText
          ? _value.extractedText
          : extractedText // ignore: cast_nullable_to_non_nullable
              as String,
      jsonResponse: null == jsonResponse
          ? _value._jsonResponse
          : jsonResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageToJsonResultImpl implements _ImageToJsonResult {
  const _$ImageToJsonResultImpl(
      {required this.extractedText,
      required final Map<String, dynamic> jsonResponse})
      : _jsonResponse = jsonResponse;

  factory _$ImageToJsonResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageToJsonResultImplFromJson(json);

  @override
  final String extractedText;
  final Map<String, dynamic> _jsonResponse;
  @override
  Map<String, dynamic> get jsonResponse {
    if (_jsonResponse is EqualUnmodifiableMapView) return _jsonResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_jsonResponse);
  }

  @override
  String toString() {
    return 'ImageToJsonResult(extractedText: $extractedText, jsonResponse: $jsonResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageToJsonResultImpl &&
            (identical(other.extractedText, extractedText) ||
                other.extractedText == extractedText) &&
            const DeepCollectionEquality()
                .equals(other._jsonResponse, _jsonResponse));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, extractedText,
      const DeepCollectionEquality().hash(_jsonResponse));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageToJsonResultImplCopyWith<_$ImageToJsonResultImpl> get copyWith =>
      __$$ImageToJsonResultImplCopyWithImpl<_$ImageToJsonResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageToJsonResultImplToJson(
      this,
    );
  }
}

abstract class _ImageToJsonResult implements ImageToJsonResult {
  const factory _ImageToJsonResult(
          {required final String extractedText,
          required final Map<String, dynamic> jsonResponse}) =
      _$ImageToJsonResultImpl;

  factory _ImageToJsonResult.fromJson(Map<String, dynamic> json) =
      _$ImageToJsonResultImpl.fromJson;

  @override
  String get extractedText;
  @override
  Map<String, dynamic> get jsonResponse;
  @override
  @JsonKey(ignore: true)
  _$$ImageToJsonResultImplCopyWith<_$ImageToJsonResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
