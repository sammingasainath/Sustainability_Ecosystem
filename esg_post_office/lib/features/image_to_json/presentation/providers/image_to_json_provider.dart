import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/image_to_json_result.dart';
import '../../data/repositories/image_to_json_repository_impl.dart';
import '../../../../core/failure.dart';

part 'image_to_json_provider.freezed.dart';

@freezed
class ImageToJsonState with _$ImageToJsonState {
  const factory ImageToJsonState({
    @Default(false) bool isLoading,
    @Default(null) ImageToJsonResult? result,
    @Default(null) String? error,
  }) = _ImageToJsonState;
}

class ImageToJsonNotifier extends StateNotifier<ImageToJsonState> {
  final ImageToJsonRepositoryImpl _repository;

  ImageToJsonNotifier(this._repository) : super(const ImageToJsonState());

  Future<void> processImage({
    required File imageFile,
    required String customPrompt,
  }) async {
    state = state.copyWith(isLoading: true, error: null, result: null);

    final result = await _repository.processImage(
      imageFile: imageFile,
      customPrompt: customPrompt,
    );

    state = result.fold(
      (failure) => state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (success) => state.copyWith(
        isLoading: false,
        result: success,
      ),
    );
  }
}

final imageToJsonProvider =
    StateNotifierProvider<ImageToJsonNotifier, ImageToJsonState>((ref) {
  return ImageToJsonNotifier(ImageToJsonRepositoryImpl());
}); 