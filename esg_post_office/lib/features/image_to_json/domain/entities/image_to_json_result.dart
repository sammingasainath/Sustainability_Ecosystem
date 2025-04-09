import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_to_json_result.freezed.dart';
part 'image_to_json_result.g.dart';

@freezed
class ImageToJsonResult with _$ImageToJsonResult {
  const factory ImageToJsonResult({
    required String extractedText,
    required Map<String, dynamic> jsonResponse,
  }) = _ImageToJsonResult;

  factory ImageToJsonResult.fromJson(Map<String, dynamic> json) =>
      _$ImageToJsonResultFromJson(json);
} 