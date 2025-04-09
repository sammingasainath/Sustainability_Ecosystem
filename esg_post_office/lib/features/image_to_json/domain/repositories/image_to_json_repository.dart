import 'dart:io';

import 'package:fpdart/fpdart.dart';
import '../entities/image_to_json_result.dart';
import '../../../../core/failure.dart';

abstract class ImageToJsonRepository {
  Future<Either<Failure, ImageToJsonResult>> processImage({
    required File imageFile,
    required String customPrompt,
  });
} 